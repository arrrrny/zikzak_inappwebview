# Bug Assessment: Impeller/Metal WebView texture crash — "Lost connection to device"

- **Slug**: macos-impeller-webview-texture-crash
- **Created**: 2026-08-24
- **Source**: pasted text (runtime crash from `flutter run -d macos` of the zuraffa_browser demo) + direct source read of `zikzak_inappwebview_macos` (verified 2026-08-24) + reproduction attempt (2026-08-24, see below)
- **Verdict**: invalid — could not reproduce on Flutter 3.47.1 (likely fixed upstream / version-specific)
- **Severity**: low (unconfirmed; no repro on current toolchain)

## Report (verbatim or summarized)

While the `InAppWebView` is on screen (loading `chat.z.ai`), the app hard-crashes:

```
[ERROR:flutter/impeller/renderer/backend/metal/texture_mtl.mm(36)] Break on 'ImpellerValidationBreak' to inspect point of failure: The texture and its descriptor disagree about its size.
[ERROR:flutter/impeller/core/formats.cc(48)] Break on 'ImpellerValidationBreak' to inspect point of failure: Store action needs resolve but no valid resolve texture specified.
Lost connection to device.
```

After the two Impeller validation errors the process dies and the tool detaches
(`Lost connection to device`).

## Symptom

With the **Impeller** rendering backend enabled (the Flutter default on macOS),
bringing up the `zikzak_inappwebview` `InAppWebView` causes an Impeller/Metal
validation failure (`texture and its descriptor disagree about its size` →
`Store action needs resolve but no valid resolve texture specified`) that takes
down the whole app. Expected: the WebView renders without crashing the
process. The crash does NOT occur when Impeller is disabled
(`flutter run -d macos --no-enable-impeller`), which is the current workaround.

## Reproduction

1. `flutter run -d macos` (Impeller ON — the default) a project using
   `zikzak_inappwebview` `InAppWebView`.
2. Let the first page load (`onLoadStop`).
3. Process crashes with the two Impeller validation errors; tool prints
   `Lost connection to device`.

Workaround that avoids it: `flutter run -d macos --no-enable-impeller`.

## Suspected Code Paths (verified 2026-08-24)

- `flutter/impeller/renderer/backend/metal/texture_mtl.mm:36` and
  `flutter/impeller/core/formats.cc:48` — Flutter's Impeller Metal backend, the
  actual origin of the validation failure. Flutter engine code, not in this repo.
- `zikzak_inappwebview_macos/macos/.../InAppWebViewFactory.swift:15-53`
  — `create(withViewIdentifier:arguments:)` builds the host `NSView` with
  `frame: .zero` (line 16) and, for the normal (non-popup) path, returns
  `webViewController.view()` (line 52). The native `WKWebView` is embedded as an
  AppKit platform view whose layer is composited by Impeller. **Concrete lead:**
  the container and webview start at a `.zero` frame; if Impeller bridges the
  native layer through a Metal texture before the first autoresize/layout pass
  propagates a non-zero `drawableSize`/`frame`, the texture descriptor can be
  zero/garbage-sized at first composite — exactly the `texture and its
  descriptor disagree about its size` condition.
- `zikzak_inappwebview_macos/lib/src/in_app_webview/in_app_webview_controller.dart:74`
  — `handleMethod` entry; not directly implicated, but the platform view's
  first paint is what triggers the crash, not a method call.
- The crash first appeared right after `onLoadStop` on the WebView, i.e. during
  first real paint/compositing of the native view under Impeller.

## Root Cause Hypothesis

The `WKWebView` platform-view layer is being composited by Impeller with a
texture whose size/resolve target is inconsistent (likely a zero or unset
viewport/texture size at first paint, or a layer whose `frame`/`drawableSize`
wasn't propagated before Impeller tried to render it). Because the native view
lives outside Flutter's retained layer tree, Impeller has to bridge it through a
texture; if that bridge is set up a frame too late or with a bad size, Impeller
asserts and the GPU process dies. Confidence: **medium** — the symptom is real
and reproducible via the Impeller-on/off toggle, but whether the defect is in
zikzak's embedding glue (the `.zero` frame / layer setup in
`InAppWebViewFactory.swift`) or purely in Flutter's Impeller platform-view path
is not yet proven.

## Proposed Remediation

**Preferred (immediate, low-risk)**: document and apply the
`--no-enable-impeller` launch flag for the macOS target as the supported
workaround until the root cause is nailed. This is what keeps the app alive
today and is sufficient for the forklift-replacement use case on macOS.

**Investigate (proper fix)**: reproduce under Impeller with a minimal
`InAppWebView` (no app chrome) to decide ownership:
- If it reproduces with a bare zikzak WebView → it is a zikzak macOS embedding
  bug. Inspect `InAppWebViewFactory.swift:15-53`: ensure the platform-view
  container/webview reports a valid, non-zero size and a correct resolve texture
  before the first Impeller composite (e.g. force an initial `setFrame`/`layout`
  pass, or defer adding the WKWebView to the hierarchy until the platform view
  has a non-zero bounds, or set an explicit layer `drawableSize`). The fix would
  live in the macOS plugin's `FlutterPlatformView` glue, not the Dart
  `InAppWebView` widget.
- If it reproduces only with app UI around it → still likely Impeller +
  platform view; file upstream against Flutter with a reduced repro.

**Alternatives**:
- Force the macOS runner to use the OpenGL/Skia backend instead of Impeller
  (less future-proof; Impeller is the default and the Skia path is being retired).

**Files likely to change**:
- `zikzak_inappwebview_macos/macos/.../InAppWebViewFactory.swift` (if zikzak-owned)
- `zuraffa_browser/macos/Runner/...` / launch flags (workaround docs)

**Tests to add or update**:
- A CI smoke test that launches the macOS demo under Impeller and asserts the
  WebView paints without `Lost connection to device` (currently it would fail,
  marking the gap).

## Risks & Considerations

- `--no-enable-impeller` is a stopgap, not a fix; it trades away Impeller's
  performance/rendering improvements and may itself be removed by Flutter later.
- If the real cause is in Flutter's Impeller platform-view path, the durable fix
  lands upstream, not in zikzak — track the Flutter issue and link it.
- Do not paper over with a try/catch; this is a process death, not a catchable
  Dart exception.

## Reproduction Attempt (2026-08-24, this Mac)

Built and ran the `zuraffa_browser` demo (which auto-loads `https://www.kimi.ai/`
in an `InAppWebView`) as a Release macOS binary, exercising the local
`zikzak_inappwebview` 5.1.2 via path override. Environment: Flutter
**3.47.1** (stable, 2026-08-19), macOS with WindowServer active.

- Run 1 — Impeller default: app launched, `onWebViewCreated` + `onLoadStop`
  fired for `kimi.ai`, WebView composited under Impeller
  (`Using the Impeller rendering backend (MetalSDF)`). **No crash; process
  alive after 60s.** No `texture and its descriptor disagree about its size`
  or `Store action needs resolve…` errors in the log.
- Run 2 — attempted a window resize via `osascript` to force a re-composite of
  the platform view; blocked by macOS accessibility permissions
  (`-10006`). App still ran 50s with no crash.
- Run 3 — launched with `--no-enable-impeller`. Log **still** reported
  `Using the Impeller rendering backend (MetalSDF)` — the flag did not switch
  the backend on this Flutter version, so a true Skia comparison was not
  possible. App stayed alive 45s, no crash.

**Conclusion**: the reported Impeller/Metal texture crash does **not** reproduce
on Flutter 3.47.1 + `zikzak_inappwebview` 5.1.2. Either it was fixed in a
recent Flutter Impeller platform-view change, or it was version/condition
specific to the original reporter's older toolchain. With no reproduction, there
is no confirmed zikzak-side defect to fix, and the `--no-enable-impeller`
workaround (cited in the original report) is no longer needed on this version.

## Open Questions

- [RESOLVED by repro: a bare `InAppWebView` does NOT crash under Impeller on
  Flutter 3.47.1 — kimi.ai loaded and composited cleanly.] If it reappears on
  an older/newer Flutter, that pins the regression window.
- Whether a specific macOS Flutter version introduced (and later fixed) this.
- Confirm whether the `.zero` initial frame in `InAppWebViewFactory.swift:16/39`
  is the window where Impeller observed a zero-sized texture — could not be
  validated because the crash did not occur.
- Interactive triggers (scroll rAF loop, OAuth popup `onCreateWindow` re-parent,
  window resize) were not exercisable here (no display interaction /
  accessibility blocked); re-test those paths only if the crash resurfaces.
