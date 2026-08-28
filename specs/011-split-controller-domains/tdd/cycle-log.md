# Cycle Log: Split InAppWebViewController into Domain-Specific Controllers

Append only. Newest last. Every entry's `red` block is the evidence that the test
existed and failed before the implementation.

## Baseline

- suite: default stack `zikzak_inappwebview_platform_interface` -> 300 passed, 0 failed (green); `zikzak_inappwebview` (umbrella) and `zikzak_inappwebview_module` -> blocked (zuraffa pub-cache corruption, run `flutter pub cache repair`)
- commit: `f349d421`
- recorded: cycle 0, before any change
