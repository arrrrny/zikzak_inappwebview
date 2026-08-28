# Cycle Log: WebView Lifecycle Integration Tests

Append only. Newest last. Every entry's `red` block is the evidence that the test
existed and failed before the implementation.

## Baseline

- suite: default stack `flutter test` (zikzak_inappwebview_platform_interface) -> 300 passed, 0 failed, green
- note: `zikzak_inappwebview` (umbrella) and `zikzak_inappwebview_module` are blocked by
  the zuraffa pub-cache corruption (run `flutter pub cache repair`). The umbrella's
  `example/integration_test` (where the hot-restart / activity-recreation / FlutterFragment
  suites live) needs a real device/emulator and was not exercised in this baseline.
- commit: `f349d421`
- recorded: cycle 0, before any change
