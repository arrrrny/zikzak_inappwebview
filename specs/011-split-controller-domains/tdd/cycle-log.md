# Cycle Log: Split InAppWebViewController into Domain-Specific Controllers

Append only. Newest last. Every entry's `red` block is the evidence that the test existed and failed before the implementation.

## Baseline

- suite: `flutter test` (in `zikzak_inappwebview`) -> 95 passed, 2 files fail to compile
- commit: `abfa842e`
- recorded: cycle 0, before any change

### Baseline details

The full `flutter test` in `zikzak_inappwebview` reports 95 passing tests and 2 files that fail to compile (pre-existing, unrelated to this feature):

1. `test/headless_dispose_test.dart` — references a `disposed` getter on `HeadlessInAppWebView` that no longer exists (interface drift from the standardize-dispose-patterns work).
2. `test/webview_sessions_test.dart` — imports `package:zikzak_session`, which is **not declared in `pubspec.yaml`**; the source `lib/src/webview_sessions/webview_sessions.dart` has the same missing import. This is an unmet dependency, not a test bug.

These reds are pre-existing and unrelated to any TDD cycle. No TDD loop can start on top of this red baseline until they are resolved — that is a separate fix (restore the `disposed` getter, or add/repair the `zikzak_session` dependency), not part of a behavior cycle. The rest of the suite (95 tests) is green and safe to cycle against once the two broken files are quarantined or fixed.

## Cycle 1 — Platform interface delegate getters + exports (U68–U72, R001/R002)

- behavior: U68–U72 (PlatformInAppWebViewController exposes four nullable delegate getters; all four delegate types exported from platform interface)
- test file: `zikzak_inappwebview_platform_interface/test/in_app_webview_controller_delegates_test.dart`
- test names: `the four domain delegate types are exported from the platform interface`, `PlatformInAppWebViewController declares all four delegate getters`
- red command: `flutter test test/in_app_webview_controller_delegates_test.dart`
- red output (decisive):
  ```
  test/in_app_webview_controller_delegates_test.dart:70:38: Error: The return type of the method '_ProbeJavaScript.callAsyncJavaScript' is 'Future<CallAsyncJavaScriptResult?>', which does not match the return type, 'Future<String?>', of the overridden method, 'PlatformJavaScriptDelegate.callAsyncJavaScript'.
  ...
  Failed to load ".../in_app_webview_controller_delegates_test.dart": Compilation failed
  ```
  (the test also referenced `PlatformCookieDelegate`/`PlatformSettingsDelegate` and the `cookieDelegate`/`settingsDelegate` controller getters, which were not yet exported/wired — surfaced as further compile errors.)
- green: fixed source gaps per R001/R002 — added `export 'modules/platform_{navigation,javascript,cookie,settings}_delegate.dart';` to `lib/src/in_app_webview/main.dart`, imported the cookie/settings delegates in `platform_inappwebview_controller.dart`, and added `cookieDelegate => null` + `settingsDelegate => null` getters. Also corrected two compile-only bugs in the test's own probe fakes (`_ProbeJavaScript.callAsyncJavaScript` now returns `Future<String?>`, `removeJavaScriptHandler` now returns `Future<JavaScriptHandlerCallback?>`); these were signature mismatches against the already-committed abstract class, not assertion changes.
- suite after: `flutter test` in `zikzak_inappwebview_platform_interface` -> 150 passed; `flutter test` in `zikzak_inappwebview` -> 118 passed. No regressions.
- commit: (pending — see report)
- notes: This is a compile-time probe test, not behavioral. It proves the symbols/delegates exist and are exported; it does not assert delegation behavior. U73–U76 (delegate method surfaces) are implemented in the modules but have no dedicated behavioral test yet (test-after).