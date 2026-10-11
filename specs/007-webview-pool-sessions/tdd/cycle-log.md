# Cycle Log: WebViewPool — Mission-Scoped Sessions, Domain Affinity, and Memory-Pressure Disposal

Append only. Newest last.

## Baseline

- suite (default stack `zikzak_inappwebview_platform_interface`): `flutter test` -> 300 passed, 0 failed, green
- suite (umbrella `zikzak_inappwebview` and `zikzak_inappwebview_module`): blocked — corrupted `zuraffa` package in pub cache (`.../zuraffa-6.0.0/lib/src/extensions/` missing). Fix: `flutter pub cache repair`.
- commit: `f349d421`
- recorded: cycle 0, before any change

<!-- No cycles recorded yet. Behaviors are listed in tdd/test-list.md and are all PENDING. -->
