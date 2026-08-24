# Bug Assessment: macOS fires scroll callbacks into a `default:` that throws `UnimplementedError`

- **Slug**: macos-unimplemented-scroll-callbacks
- **Created**: 2026-08-24
- **Source**: pasted text (runtime logs from `flutter run -d macos` of the zuraffa_browser demo) + direct source read of `zikzak_inappwebview` (verified 2026-08-24)
- **Verdict**: valid
- **Severity**: high

## Report (verbatim or summarized)

Observed on every page load of a WKWebView-backed page (chat.z.ai / kimi.ai) in the
zuraffa_browser demo:

```
flutter: UnimplementedError: Unimplemented onScrollChanged method
flutter: #0      MacOSInAppWebViewController.handleMethod (.../in_app_webview_controller.dart:368:9)
#1      new MacOSInAppWebViewController.<anonymous closure> (.../in_app_webview_controller.dart:50:22)
...
flutter: UnimplementedError: Unimplemented onContentSizeChanged method
flutter: UnimplementedError: Unimplemented onOverScrolled method
```

Three distinct `UnimplementedError`s per page load, and they repeat on every
scroll because the native side posts these on a `requestAnimationFrame` loop.

## Symptom

The native macOS side (issue #197) was taught to emit `onScrollChanged`,
`onContentSizeChanged`, and `onOverScrolled` over the platform channel. The
Dart receiver in the macOS plugin (`MacOSInAppWebViewController.handleMethod`)
never gained `case` arms for these three method names, so they fall through to
`default:` and throw `UnimplementedError("Unimplemented ${call.method} method")`.

Expected: these callbacks should forward to
`params.webviewParams?.onScrollChanged / onContentSizeChanged / onOverScrolled`
exactly like `onProgressChanged` does. Instead the app drowns in
`UnhandledException`-class console spam on every load and scroll, and any
consumer who registers those callbacks never receives them — the API
advertises the events but macOS silently never delivers them.

## Reproduction

1. `flutter run -d macos` a project that uses `zikzak_inappwebview` with a
   `InAppWebView` (default or isolated store, does not matter).
2. Wait for the first page to finish loading (`onLoadStop`).
3. Observe the three `UnimplementedError` lines in the debug console.
4. Scroll the page; observe the errors fire again (debounced via rAF).

## Suspected Code Paths (verified 2026-08-24)

- `zikzak_inappwebview_macos/lib/src/in_app_webview/in_app_webview_controller.dart:367-368`
  — `default: throw UnimplementedError("Unimplemented ${call.method} method");`
  The three method names are absent from the `case` list. Confirmed by reading
  the full `handleMethod` switch: it handles `onLoadStart` (80) … `onReceivedClientCertRequest` (354)
  — 27+ arms — but NOT `onScrollChanged` / `onContentSizeChanged` / `onOverScrolled`.
- `zikzak_inappwebview_macos/lib/src/in_app_webview/in_app_webview_controller.dart:49-55`
  — the channel handler wraps `handleMethod` in `try { ... } on Error { print... }`,
  which is the *only* reason this does not hard-crash: it converts the thrown
  `Error` into console noise instead of terminating the channel handler.
- `zikzak_inappwebview_macos/lib/src/in_app_webview/in_app_webview_controller.dart:136-141`
  — the `onProgressChanged` arm is the exact template to mirror (null-guarded
  `params.webviewParams?.onProgressChanged` callback, decoded args).
- `zikzak_inappwebview_macos/macos/.../InAppWebView.swift:2299-2332`
  — native `userContentController(_:didReceive:)` handler for
  `"onScrollChangedReceived"` that calls
  `channel?.invokeMethod("onScrollChanged"|"onContentSizeChanged"|"onOverScrolled", arguments:)`.
  These are the producers the Dart side ignores.
  - `onScrollChanged` → line 2308, arguments `["x": x, "y": y]`
  - `onContentSizeChanged` → line 2317, `["oldContentSize": …, "newContentSize": …]`
  - `onOverScrolled` → line 2329, `["x": x, "y": y, "clampedX": …, "clampedY": …]`
- `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/platform_webview.dart:187, 628, 948`
  — the consumer-side callback signatures that exist and should be invoked:
  - `onScrollChanged(T, int x, int y)`
  - `onOverScrolled(T, int x, int y, bool clampedX, bool clampedY)`
  - `onContentSizeChanged(T, Size oldContentSize, Size newContentSize)`

Native payload key names verified against `InAppWebView.swift:2305-2332`:
`x`/`y` (Int), `clampedX`/`clampedY` (Bool), `oldContentSize`/`newContentSize`
each with `width`/`height` (Double).

## Root Cause Hypothesis

The feature was shipped half-wired (issue #197 added the native emitters and
the JS observer, but the Dart dispatcher's `default:` was left as a catch-all
throw and the three `case` arms were never added). Confidence: **high** — the
gap is directly visible: native `invokeMethod` names vs. the Dart `case` list
have zero overlap for these three, and the live stack trace pins the throw to
line 368.

## Proposed Remediation

**Preferred**: Add three `case` arms to `handleMethod` immediately before the
`default:` (mirroring the `onProgressChanged` arm at lines 136-141), each
guarded by a null check on the corresponding `params.webviewParams` callback and
forwarding the decoded native arguments:

```dart
case 'onScrollChanged':
  if (params.webviewParams?.onScrollChanged != null) {
    params.webviewParams!.onScrollChanged!(
      controller,
      call.arguments['x'] as int? ?? 0,
      call.arguments['y'] as int? ?? 0,
    );
  }
  break;
case 'onContentSizeChanged':
  if (params.webviewParams?.onContentSizeChanged != null) {
    final old = call.arguments['oldContentSize'] as Map? ?? {};
    final neu = call.arguments['newContentSize'] as Map? ?? {};
    params.webviewParams!.onContentSizeChanged!(
      controller,
      Size((old['width'] as num? ?? 0).toDouble(),
           (old['height'] as num? ?? 0).toDouble()),
      Size((neu['width'] as num? ?? 0).toDouble(),
           (neu['height'] as num? ?? 0).toDouble()),
    );
  }
  break;
case 'onOverScrolled':
  if (params.webviewParams?.onOverScrolled != null) {
    params.webviewParams!.onOverScrolled!(
      controller,
      call.arguments['x'] as int? ?? 0,
      call.arguments['y'] as int? ?? 0,
      call.arguments['clampedX'] as bool? ?? false,
      call.arguments['clampedY'] as bool? ?? false,
    );
  }
  break;
```

This is a pure additive change to the macOS plugin; it does not touch the
platform interface or other platforms, so there is no cross-platform API
breakage.

**Alternatives**:
- Make `default:` a silent no-op (just `return null;`) instead of throwing. This
  stops the spam for ANY future unhandled method, but it also hides genuinely
  missing handlers and papers over the real defect. Use ONLY as a belt-and-
  braces follow-up, not as the primary fix. The three handlers above are the
  actual fix.

**Files likely to change**:
- `zikzak_inappwebview_macos/lib/src/in_app_webview/in_app_webview_controller.dart`

**Tests to add or update**:
- A unit test for `handleMethod` that feeds each of the three method names with
  representative `call.arguments` and asserts the matching
  `params.webviewParams` callback is invoked with the decoded values (and that
  a null callback is a no-op / does not throw).
- A regression test asserting the `default:` branch is NOT hit for these three
  names (so a future refactor cannot silently re-break them).

## Risks & Considerations

- The `default:` throw is the only thing standing between these unhandled
  methods and a dead channel handler; wiring the three cases removes the spam
  for exactly the methods we see. Other still-unhandled methods (if any) would
  keep throwing — that is correct behavior and should stay loud.
- `Size` must be constructed from the native doubles; native sends `Double`
  widths/heights, so do not treat them as ints.
- No behavior change for consumers who do NOT register these callbacks — the
  null-guard means they stay silent, exactly as before.

## Open Questions

- None blocking. Native argument key names verified against
  `InAppWebView.swift:2305-2332`.
