# Cycle Log: WebView Lifecycle Integration Tests

Append only. Newest last. Every entry's `red` block is the evidence that the test existed and failed before the implementation.

## Baseline

- suite: `flutter test` (in `zikzak_inappwebview`) -> 95 passed, 2 files fail to compile (headless_dispose_test.dart, webview_sessions_test.dart)
- commit: `abfa842e`
- recorded: cycle 0, before any change

**Note on baseline**: The umbrella suite is RED at detection time. The two failing files are pre-existing and unrelated to this feature:
1. `test/headless_dispose_test.dart` — references a `disposed` getter on `HeadlessInAppWebView` that no longer exists (interface drift from standardize-dispose-patterns work)
2. `test/webview_sessions_test.dart` — imports `package:zikzak_session`, which is not declared in `pubspec.yaml`

The integration test suite in `example/integration_test/` runs separately and is not part of the umbrella package's `flutter test` output.