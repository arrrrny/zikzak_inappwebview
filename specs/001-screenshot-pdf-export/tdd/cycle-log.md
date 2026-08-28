# Cycle Log: Screenshot and PDF Export

Append only. Newest last. Every entry's `red` block is the evidence that the test
existed and failed before the implementation.

## Baseline

- suite (default stack, cwd `zikzak_inappwebview_platform_interface`): `flutter test`
  -> 300 passed, 0 failed (~82s), green
- suite (platform stacks, smoke-verified per `.specify/memory/tdd-profile.md`):
  `zikzak_inappwebview_android` 6 passed, `zikzak_inappwebview_ios` 5 passed,
  `zikzak_inappwebview_macos` 21 passed, `zikzak_inappwebview_linux` 7 passed,
  `zikzak_inappwebview_windows` 8 passed — all green
- suite (`zikzak_inappwebview` umbrella, `zikzak_inappwebview_module`): **blocked**,
  not red — zuraffa pub-cache corruption; run `flutter pub cache repair`
- suite (`zikzak_inappwebview_web`): 0 test files (empty); new web behavior needs a
  characterization test first (U26)
- baseline taken from the recorded profile, not re-executed: the full suites are too
  slow for a planning step and two of them are environment-blocked
- commit: `f349d421`
- recorded: cycle 0, before any change
