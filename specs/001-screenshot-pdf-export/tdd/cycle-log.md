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