# Cycle Log: Dismiss Dialogues Setting

Append only. Newest last. Every entry's `red` block is the evidence that the test
existed and failed before the implementation.

## Baseline

- suite: `flutter test` (default stack: `zikzak_inappwebview_platform_interface`) -> 300 passed, 0 failed (green)
- commit: `f349d421`
- recorded: cycle 0, before any change

## Notes and deviations

- The umbrella `zikzak_inappwebview` and `zikzak_inappwebview_module` suites were
  **blocked** (not red) by a corrupted `zuraffa` package in the pub cache
  (`.../zuraffa-6.0.0/lib/src/extensions/` is missing). Both crash at
  compile/load time. **Resolved 2026-08-28**: the umbrella `pubspec.yaml` now
  carries a `dependency_overrides` pinning `zuraffa` to `pub.zuzu.dev` `6.0.1`
  (the only hosted mirror with a complete 6.x — `pub.flutter-io.cn`/`pub.dev`
  serve a broken 6.0.0). `flutter pub get` resolves `zuraffa 6.0.1 (overridden)`,
  and a sample umbrella test (`test/disposable_pattern_test.dart`) compiles and
  passes. **Remaining block**: the umbrella's dismissal/acceptance tests (A*,
  U4–U12) evaluate overlay-dismissal JS inside a real `InAppWebView`, which needs a
  webview runtime. This headless host has no `DISPLAY`/Xvfb and no webkit libs, so
  those tests cannot run here and stay blocked. U1–U3 (platform_interface) are
  fully testable and DONE.
- The feature's distinctive behavior — the overlay-dismissal JavaScript — lives in
  the umbrella package (`lib/src/in_app_webview/in_app_webview.dart`, the
  `onLoadStop` handler gated on `dismissDialogues ?? false`). Its acceptance
  (A1–A7) and orchestration (U4–U12) tests cannot run in this headless environment
  (no webview runtime; the zuraffa cache is now fixed — see above). The
  `InAppWebViewSettings.dismissDialogues` field (U1–U3) is in the green
  `zikzak_inappwebview_platform_interface` stack and is tested and DONE.
- No characterization baselines were added: the spec's behaviors are the
  feature's own contract rather than a change to pre-existing untested logic, and
  the blocked umbrella suite means current behavior cannot be observed/locked.
  U5 (no injection when false) serves as the de-facto pre-feature baseline.

## Cycles

U1–U3 are brownfield: the `dismissDialogues` field and its codegen already existed
(generated constructor defaults `this.dismissDialogues = dismissDialogues ?? false`),
so the tests were green on first write rather than red. Each was proven real with a
deliberate-mutant check (mutate the generated default to `?? true`; the affected
test(s) fail, then the code is restored). All runs use
`zikzak_inappwebview_platform_interface` as cwd. Changes are **uncommitted** (no
commit made without an explicit request).

### U1 — default-constructed `InAppWebViewSettings` exposes `dismissDialogues == false` (FR-002)
- test: `test/types/in_app_webview_settings_test.dart` :: `InAppWebViewSettings.dismissDialogues default-constructed settings expose dismissDialogues == false`
- red (brownfield): impl pre-existed; test green on first write. Deliberate-mutant
  check: set generated `this.dismissDialogues = dismissDialogues ?? true`;
  `flutter test --plain-name "dismissDialogues"` → `+0 -1 ... default-constructed
  settings expose dismissDialogues == false` FAILED (Expected: false, Actual: <true>).
  Restored to `?? false`.
- green: `flutter test --plain-name "dismissDialogues"` → +3 passed; full
  `flutter test` → 303 passed, 0 failed (~42s).
- refactor: none.
- commit: uncommitted.

### U2 — `InAppWebViewSettings(dismissDialogues: true)` exposes `true` (FR-001)
- test: `test/types/in_app_webview_settings_test.dart` :: `InAppWebViewSettings.dismissDialogues dismissDialogues: true is exposed as true`
- red (brownfield): green on first write. Deliberate-mutant check above did not
  affect this case (explicit `true` survives `?? true`), confirming the mutant
  isolates U1/U3; no separate mutant needed.
- green: included in the +3 run above. Full suite 303 passed.
- refactor: none.
- commit: uncommitted.

### U3 — `dismissDialogues` round-trips through `toJson`/`fromJson` for true and false (FR-001, invariant)
- test: `test/types/in_app_webview_settings_test.dart` :: `InAppWebViewSettings.dismissDialogues dismissDialogues round-trips through toJson/fromJson (true and false)`
- red (brownfield): green on first write. Deliberate-mutant check: `?? true` made
  the default-round-trip assertion fail (`Expected: false, Actual: <true>`), proving
  the round-trip pins the boundary. Restored.
- green: included in the +3 run above. Full suite 303 passed.
- refactor: none.
- commit: uncommitted.
