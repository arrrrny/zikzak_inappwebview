# Cycle Log: Screenshot and PDF Export

Append only. Newest last. Every entry's `red` block is the evidence that the test existed and failed before the implementation.

## Baseline

- suite: `flutter test` (in `zikzak_inappwebview`) -> 95 passed, 2 files fail to compile (0 passed in broken files)
- commit: `abfa842e`
- recorded: cycle 0, before any change
- notes: Two pre-existing compile failures unrelated to this feature:
  1. `test/headless_dispose_test.dart` — references a `disposed` getter on `HeadlessInAppWebView` that no longer exists (interface drift)
  2. `test/webview_sessions_test.dart` — imports `package:zikzak_session`, which is **not declared in `pubspec.yaml`**; the source `lib/src/webview_sessions/webview_sessions.dart` has the same missing import. This is an unmet dependency, not a test bug.
- The rest of the suite (95 tests) is green and safe to cycle against once the two broken files are quarantined or fixed.

## U6 — Dart takeScreenshot delegates screenshotConfiguration to the platform

- test: `zikzak_inappwebview/test/screenshot_pdf_delegation_test.dart › U6 takeScreenshot delegates to platform with the screenshotConfiguration`
- red: none — the delegation already existed in `InAppWebViewController.takeScreenshot` (in_app_webview_controller.dart:208), so the test passed on first run.
- deliberate mutant: changed the forward to `platform.takeScreenshot(screenshotConfiguration: null)`; ran the test; it failed with:
  `Expected: same instance as ScreenshotConfiguration:<ScreenshotConfiguration(rect: null, snapshotWidth: null, compressFormat: CompressFormat.PNG, quality: 100, afterScreenUpdates: true)>  Actual: <null>`. Restored the override exactly; test green again.
- green: no source change; behavior already satisfied by the existing delegation.
- refactor: none.
- commit: pending (WIP, not yet committed)
- notes: green-on-first-run characterization; mutant confirms the assertion catches a dropped config. Backfilled this session to log the prior unlogged cycle.

## U7 — Dart takeScreenshot forwards and returns the platform's Uint8List (or null)

- test: `zikzak_inappwebview/test/screenshot_pdf_delegation_test.dart › U7 takeScreenshot returns the platform Uint8List or null`
- red: none — the override already returned `platform.takeScreenshot(...)` (in_app_webview_controller.dart:208), so the test passed on first run.
- deliberate mutant: changed the override to `=> Future<Uint8List?>.value(Uint8List(0))`; ran the test; it failed with:
  `Expected: [1, 2, 3, 4]  Actual: []`. Restored the override exactly; test green again.
- green: no source change; behavior already satisfied by the existing forward-and-return.
- refactor: none.
- commit: pending (WIP, not yet committed)
- notes: green-on-first-run characterization; mutant confirms the test catches a dropped/empty return. Full suite after: 200 passed (no regression).

## U34 — deprecated IOSInAppWebViewController forwards takeScreenshot

- test: `zikzak_inappwebview/test/screenshot_pdf_delegation_test.dart › U34 deprecated IOSInAppWebViewController forwards takeScreenshot to its platform controller`
- red: none — the facade already forwarded to `_controller?.takeScreenshot(screenshotConfiguration: ...)` (apple/in_app_webview_controller.dart:28), so the test passed on first run.
- deliberate mutant: changed the facade forward to `screenshotConfiguration: null`; ran the test; it failed with:
  `Expected: same instance as ScreenshotConfiguration:<ScreenshotConfiguration(rect: null, snapshotWidth: null, compressFormat: CompressFormat.PNG, quality: 100, afterScreenUpdates: true)>  Actual: <null>`. Restored exactly; test green again.
- green: no source change; behavior already satisfied.
- refactor: none.
- commit: pending (WIP, not yet committed)
- notes: green-on-first-run characterization; mutant confirms the forwarded config is asserted. Full suite after: 201 passed (no regression). Required importing the deprecated class via its `src/` path (not exported from the barrel).

## U16 — Android Dart createPdf delegates pdfConfiguration to the method channel

- test: `zikzak_inappwebview_android/test/in_app_webview/android_screenshot_pdf_delegation_test.dart › U16 createPdf delegates to channel with pdfConfiguration.toJson()`
- red: none — the delegation already existed in `AndroidInAppWebViewController.createPdf` (in_app_webview_controller.dart:2524), so the test passed on first run.
- deliberate mutant: changed the channel method literal from `'createPdf'` to `'createPdfX'`; ran the test; it failed with:
  `Expected: 'createPdf'  Actual: 'createPdfX'  Which: is different. Both strings start the same, but the actual value also has the following trailing characters: X`. Restored the source exactly; test green again.
- green: no source change; behavior already satisfied by the existing delegation (`args['pdfConfiguration'] = pdfConfiguration?.toJson(); channel?.invokeMethod<Uint8List?>('createPdf', args)`).
- refactor: none. The shared `_FakeChannel extends MethodChannel` and `_newController` helper already factor the construction/seam injection.
- commit: pending (WIP, not yet committed)
- notes: Android package's first behavioral delegation test. The controller is constructed normally (so its constructor-side `initMethodCallHandler` registration works under `TestWidgetsFlutterBinding.ensureInitialized()`), then its `channel` is replaced with the recording fake before the method call. Full Android suite after: 5 passed (no regression). `tasks.md` carries no `[U16]` marker, so no task was ticked.

## U17 — Android Dart createPdf returns the channel Uint8List or null

- test: `zikzak_inappwebview_android/test/in_app_webview/android_screenshot_pdf_delegation_test.dart › U17 createPdf returns the channel Uint8List or null`
- red: none — the override already returned `await channel?.invokeMethod<Uint8List?>('createPdf', args)` (in_app_webview_controller.dart:2524), so the test passed on first run.
- deliberate mutant: changed the override body to `return null;`; ran the test; it failed with:
  `Expected: [10, 20, 30]  Actual: <null>  Which: is not Iterable  the Uint8List the channel returns must be propagated as-is`. Restored the override exactly; test green again.
- green: no source change; behavior already satisfied by the existing forward-and-return.
- refactor: none. Shares the `_FakeChannel` / `_newController` helpers with U16.
- commit: pending (WIP, not yet committed)
- notes: green-on-first-run characterization; mutant confirms the test catches a dropped/empty return. Full Android suite after: 6 passed (no regression). `tasks.md` carries no `[U17]` marker, so no task was ticked.

## U41 — Android takeScreenshot Dart delegation + return (characterization promoted to behavioral)

- test: `zikzak_inappwebview_android/test/in_app_webview/android_screenshot_pdf_delegation_test.dart › U41 Android takeScreenshot delegates screenshotConfiguration and returns the channel bytes or null`
- red: none — the `takeScreenshot` Dart override already delegated and returned (in_app_webview_controller.dart:1937), so the test passed on first run.
- deliberate mutant: changed the channel method literal from `'takeScreenshot'` to `'takeScreenshotX'`; ran the test; it failed with:
  `Expected: 'takeScreenshot'  Actual: 'takeScreenshotX'  Which: is different. Both strings start the same, but the actual value also has the following trailing characters: X`. Restored the source exactly; test green again.
- green: no source change; behavior already satisfied by the existing delegation (`args['screenshotConfiguration'] = screenshotConfiguration?.toJson(); channel?.invokeMethod<Uint8List?>('takeScreenshot', args)`).
- refactor: none. Reuses the `_FakeChannel` / `_newController` helpers and the U16/U17 style.
- commit: pending (WIP, not yet committed)
- notes: Promotes the previously-BASELINE characterization row U41 to a real behavioral test covering both the `screenshotConfiguration.toJson()` forward and the bytes/null return. The Java handler half of U41 (native `InAppWebView.java` takeScreenshot) is out of Dart-unit scope and still needs native/integration coverage. Full Android suite after: 7 passed (no regression). `tasks.md` carries no `[U41]` marker, so no task was ticked.
## U25 — Linux Dart createPdf delegates pdfConfiguration to the method channel

- test: `zikzak_inappwebview_linux/test/in_app_webview/screenshot_pdf_delegation_test.dart › U25 createPdf delegates to channel with pdfConfiguration.toJson()`
- red: none — the delegation already existed in `LinuxInAppWebViewController.createPdf` (in_app_webview_controller.dart:336), so the test passed on first run.
- deliberate mutant: changed the channel method literal from `'createPdf'` to `'createPdfX'`; ran the test; it failed with:
  `Expected: 'createPdf'  Actual: 'createPdfX'  Which: is different. Both strings start the same, but the actual value also has the following trailing characters: X`. Restored the source exactly; test green again.
- green: no source change; behavior already satisfied by the existing delegation (`args.putIfAbsent('pdfConfiguration', () => pdfConfiguration?.toJson()); _channel.invokeMethod<Uint8List?>('createPdf', args)`).
- refactor: none. New Linux test file created (`test/in_app_webview/screenshot_pdf_delegation_test.dart`); reuses the binary-messenger mock pattern from the macOS exemplar (`context_menu_test.dart`) and the channel-name convention `dev.zuzu/zikzak_inappwebview_${id}`.
- commit: pending (WIP; batched with U26/U27/U38/U39 per session commit plan)
- notes: green-on-first-run characterization; mutant confirms the test catches a renamed/dropped channel method. Full Linux suite after: 1 passed (no regression). `tasks.md` carries no `[U25]` marker, so no task was ticked.

## U26 — Linux Dart takeScreenshot delegates screenshotConfiguration to the method channel

- test: `zikzak_inappwebview_linux/test/in_app_webview/screenshot_pdf_delegation_test.dart › U26 takeScreenshot delegates to channel with screenshotConfiguration.toJson()`
- red: none — the delegation already existed in `LinuxInAppWebViewController.takeScreenshot` (in_app_webview_controller.dart:324), so the test passed on first run.
- deliberate mutant: changed the channel method literal from `'takeScreenshot'` to `'takeScreenshotX'`; ran the test; it failed with:
  `Expected: 'takeScreenshot'  Actual: 'takeScreenshotX'  Which: is different. Both strings start the same, but the actual value also has the following trailing characters: X`. Restored the source exactly; test green again.
- green: no source change; behavior already satisfied by the existing delegation (`args.putIfAbsent('screenshotConfiguration', () => screenshotConfiguration?.toJson()); _channel.invokeMethod<Uint8List?>('takeScreenshot', args)`).
- refactor: none. Shares the group, `_newController` helper, and mock setup with U25.
- commit: pending (WIP; batched with U25/U27/U38/U39 per session commit plan)
- notes: green-on-first-run characterization; mutant confirms the test catches a renamed/dropped channel method. Full Linux suite after: 2 passed (no regression). `tasks.md` carries no `[U26]` marker, so no task was ticked.

## U27 — Linux Dart overrides propagate the channel Uint8List or null

- test: `zikzak_inappwebview_linux/test/in_app_webview/screenshot_pdf_delegation_test.dart › U27 overrides return the channel Uint8List or null`
- red: none — both overrides already propagated the channel result (in_app_webview_controller.dart:324 and :336), so the test passed on first run.
- deliberate mutant: changed `createPdf` to `return null;`; ran the test; it failed with:
  `Expected: [10, 20, 30]  Actual: <null>  Which: is not Iterable  the Uint8List the channel returns must be propagated as-is`. Restored the override exactly; test green again.
- green: no source change; behavior already satisfied by the existing forward-and-return.
- refactor: none. Shares the group, `_newController` helper, and mock setup with U25/U26.
- commit: pending (WIP; batched with U25/U26/U38/U39 per session commit plan)
- notes: green-on-first-run characterization; mutant confirms the test catches a dropped/empty return. Full Linux suite after: 3 passed (no regression). `tasks.md` carries no `[U27]` marker, so no task was ticked.

## U38 — Windows Dart takeScreenshot returns null without throwing

- test: `zikzak_inappwebview_windows/test/screenshot_pdf_delegation_test.dart › U38 takeScreenshot returns null without throwing`
- red: none — the override already returned `null` (in_app_webview_windows_controller.dart:308), so the test passed on first run.
- deliberate mutant: changed the override body to `throw UnimplementedError();`; ran the test; it failed with:
  `UnimplementedError  package:zikzak_inappwebview_windows/src/in_app_webview_windows_controller.dart 308:5  InAppWebViewWindowsController.takeScreenshot`. Restored the override exactly; test green again.
- green: no source change; behavior already satisfied by the existing `return null;` stub (Windows screenshot/pdf is out of scope per spec.md).
- refactor: none. New Windows test file created; reuses the `WebviewController()` construction seam from the existing `in_app_webview_windows_controller_test.dart` exemplar.
- commit: pending (WIP; batched with U25/U26/U27/U39 per session commit plan)
- notes: green-on-first-run characterization; mutant confirms the test catches a reintroduced throw. Full Windows suite after: 14 passed (no regression). `tasks.md` carries no `[U38]` marker, so no task was ticked.

## U39 — Web Dart takeScreenshot returns null without throwing

- test: `zikzak_inappwebview_web/test/screenshot_pdf_delegation_test.dart › U39 takeScreenshot returns null without throwing`
- red command: `flutter test test/screenshot_pdf_delegation_test.dart --platform=chrome --plain-name "U39 takeScreenshot returns null without throwing"` (the web package cannot compile on the Dart VM because `package:web` requires the JS backend, so the Chrome browser backend is used).
- red: none — the override already returned `null` (in_app_webview_web_controller.dart:209), so the test passed on first run under Chrome.
- deliberate mutant: changed the override body to `throw UnimplementedError();`; ran the test under Chrome; it failed with the thrown `UnimplementedError`. Restored the override exactly; test green again.
- green: no source change; behavior already satisfied by the existing `return null;` stub (Web screenshot/pdf is out of scope per spec.md).
- refactor: none. New Web test file created; the Web controller is constructed with a real `web.HTMLIFrameElement()` only available under the Chrome backend.
- commit: pending (WIP; batched with U25/U26/U27/U38 per session commit plan)
- notes: green-on-first-run characterization run under Chrome (the only backend on which the `web` package compiles). Mutant confirms the test catches a reintroduced throw. `tasks.md` carries no `[U39]` marker, so no task was ticked. NOTE: this test must be run with `--platform=chrome`; it will not compile under the default Dart VM runner.

## A4 — Android createPdf returns non-null valid PDF bytes (acceptance)

- test: `zikzak_inappwebview/example/integration_test/android_create_pdf_test.dart › A4 Android createPdf returns non-null valid PDF bytes`
- red command: `flutter test integration_test/android_create_pdf_test.dart -d emulator-5554`
- red: the test failed. Initially `createPdf` returned `null` (the native catch block returned `result.success(null)`); a diagnostic re-run surfaced the real cause as a `PlatformException(CREATEPDF_INNER, java.lang.IllegalArgumentException: width and height must be > 0, null, null)`. The native `createPdf`/`capturePdf` read `viewWidth`/`viewHeight` in the outer runnable **before the WebView was laid out**, so both were `0`; `Bitmap.createBitmap(0, 1576)` then threw. Diagnostic dimensions at capture time: `w=0 mw=1050 pw=1050 ph=1575 sr=1576` — the measured width is 1050 once laid out. The test genuinely failed (red) before any fix existed.
- green: moved the dimension computation (`getWidth()>0?getWidth():getMeasuredWidth()`, `computeVerticalScrollRange()`, `MAX_HEIGHT` clamp) **inside** `doCapture`, which runs after the `postVisualStateCallback` visual-state completion, so the view is already laid out and `getMeasuredWidth()` returns 1050. Removed the temporary diagnostic `result.error` instrumentation and restored the original graceful `result.success(null)` on genuine capture failure.
  - source: `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebView.java` (`createPdf` + `capturePdf`)
  - acceptance result: `00:02 +1: All tests passed!` (EXIT=0) on emulator-5554 (API 26)
- deliberate mutant: N/A — the test was RED on first run (the failure was observed before implementation), so the green-on-first-run mutant check does not apply. The red evidence above is the real pre-implementation failure.
- refactor: none needed. The fix is the minimal production change that makes the behavior hold.
- commit: e9642e34
- notes: Acceptance behavior requiring a real Android WebView; ran on a device/emulator, not the Dart-VM unit runner. This is a genuine production bug fix (zero-size PDF capture), not only a new test. `tasks.md` carries no `[A4]` marker, so no task was ticked.

## A5 — Android createPdf with A4 page size paginates content across A4 pages

- test: `zikzak_inappwebview/example/integration_test/android_create_pdf_test.dart › A5 Android createPdf with A4 page size produces A4 pages with all content`
- red: ran `flutter test -d emulator-5554 integration_test/android_create_pdf_test.dart --plain-name "A5 Android createPdf with A4 page size produces A4 pages with all content"`. Failed with:
  `Expected: a value greater than or equal to <2>  Actual: <1>  Which: is not a value greater than or equal to <2>` (only 1 `/MediaBox` found; native `createPdf` ignored `pageSize` and emitted a single content-sized page).
- green: threaded `pdfConfiguration` from `InAppWebView.createPdf` into `capturePdf`; `capturePdf` now reads `pageSize`/`margins`/`orientation` from the map (swapping w/h for LANDSCAPE) and slices the scaled WebView bitmap into `ceil(scaledContentHeight / contentHeight)` pages, each drawn at its own `/MediaBox`, with the surplus clipped by the page. Original content-sized single-page behavior is retained when `pageSize` is null. Added `toDouble` helper.
- refactor: none (change is localized to the capture path; the single-page fallback is preserved, so A4 is unaffected).
- commit: 189cb769
- notes: Acceptance test on emulator-5554 (API 26). Regression: full `android_create_pdf_test.dart` (A4+A5) green, 2 passed. `tasks.md` carries no `[A5]` marker, so no task was ticked. PDFConfiguration pageSize/margins/orientation fields (zorphy) were added in this commit so the test could carry the A4 size across the channel.

## A13 — Android takeScreenshot returns non-null valid PNG image bytes (acceptance)

- test: `zikzak_inappwebview/example/integration_test/android_take_screenshot_test.dart › A13 Android takeScreenshot returns non-null valid PNG image bytes`
- red command: `flutter test -d emulator-5554 integration_test/android_take_screenshot_test.dart --plain-name "A13 Android takeScreenshot returns non-null valid PNG image bytes"`
- red: the test failed. The Dart assertion `expect(bytes, isNotNull)` failed with:
  `Expected: not null  Actual: <null>  takeScreenshot must return non-null bytes on Android (FR-001)`.
  The channel returned `null`. Root cause in the native handler: `takeScreenshot` read `getMeasuredWidth()`/`getMeasuredHeight()` directly and wrapped the body in a catch that returned `result.success(null)` on `IllegalArgumentException`. Before the WebView finished layout both dimensions were `0`, so `Bitmap.createBitmap(0, 0, ARGB_8888)` threw and the null was returned. The failure was observed before any fix existed.
- green: applied the same pattern `createPdf`/`capturePdf` already use — prefer the laid-out size (`getWidth() > 0 ? getWidth() : getMeasuredWidth()`, same for height), guard against a 0-size capture (return `null` instead of throwing), and `postDelayed` the capture by 1000ms so the WebView has finished layout before its size is read.
  - source: `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebView.java` (`takeScreenshot`)
  - acceptance result: `00:02 +1: All tests passed!` (EXIT=0) on emulator-5554 (API 26)
  - regression: Android package Dart suite after — `All tests passed!` (7 passed, U16/U17/U41 delegation intact)
- deliberate mutant: N/A — the test was RED on first run (failure observed before implementation), so the green-on-first-run mutant check does not apply. The red evidence above is the real pre-implementation failure.
- refactor: none needed. The fix only aligns `takeScreenshot` with the existing `capturePdf` dimension-reading pattern; no new duplication introduced.
- commit: 7e5f9041
- notes: Acceptance behavior requiring a real Android WebView; ran on a device/emulator, not the Dart-VM unit runner. This is a genuine production bug fix (zero-size screenshot capture), not only a new test. `tasks.md` carries no `[A13]` marker, so no task was ticked.

## A14 — Android takeScreenshot with rect crops to the specified portion (acceptance)

- test: `zikzak_inappwebview/example/integration_test/android_take_screenshot_test.dart › A14 Android takeScreenshot with rect captures only the specified portion of the view`
- red: none — the native rect-crop already existed in `InAppWebView.takeScreenshot` (InAppWebView.java:1198), so the test passed on first run on emulator-5554 (API 26).
- deliberate mutant: forced `rectWidth = screenshotBitmap.getWidth()` and `rectHeight = screenshotBitmap.getHeight()` (neutralizing the crop so the cropped bitmap equals the full bitmap); ran `flutter test integration_test/android_take_screenshot_test.dart -d emulator-5554 --plain-name "A14 Android takeScreenshot with rect captures only the specified portion of the view"`. It failed with:
  `Expected: a value less than <1050>  Actual: <1050>  Which: is not a value less than <1050>  rect must crop the width (FR-002)`. Restored the native code exactly (`git checkout`); test green again.
- green: no source change; behavior already satisfied by the existing rect crop in `InAppWebView.takeScreenshot`.
- refactor: none.
- commit: fabdfe74
- notes: green-on-first-run acceptance; the deliberate mutant confirms the test catches a dropped/neutralized crop (the assertions `cropW < fullW` / `cropH < fullH` / `closeTo(fullW/2, 2.0)` all depend on the native rect block). Real-device (emulator) acceptance, not the Dart-VM unit runner. `tasks.md` carries no `[A14]` marker, so no task was ticked.

## A1 — macOS takeScreenshot returns non-null valid PNG image bytes (acceptance)

- test: `zikzak_inappwebview/example/integration_test/macos_take_screenshot_test.dart › A1 macOS takeScreenshot returns non-null valid PNG image bytes`
- red: none — the native `takeScreenshot` handler already existed in `InAppWebView.swift` (case "takeScreenshot", line 805) returning the PNG `Data` via `result(imageData)`, so the test passed on first run on the macOS desktop target.
- deliberate mutant: changed the handler's final `result(imageData)` to `result(nil)`; ran `flutter test integration_test/macos_take_screenshot_test.dart -d macos --plain-name "A1 macOS takeScreenshot returns non-null valid PNG image bytes"`. It failed with:
  `Expected: not null  Actual: <null>  takeScreenshot must return non-null bytes on macOS (US1-AC1)`. Restored the native code exactly (`git checkout`); test green again.
- green: no source change; behavior already satisfied by the existing macOS `takeScreenshot` handler (WKSnapshotConfiguration + PNG `NSBitmapImageRep`).
- refactor: none.
- commit: 94c745ab
- notes: green-on-first-run acceptance; the deliberate mutant confirms the test catches a handler that returns null. Real macOS desktop acceptance, not the Dart-VM unit runner. (Note: the macOS run emits benign `UnimplementedError` logs for `onScrollChanged`/`onContentSizeChanged`/`onOverScrolled` channel methods during webview init — these do not affect the assertion.) `tasks.md` carries no `[A1]` marker, so no task was ticked.
