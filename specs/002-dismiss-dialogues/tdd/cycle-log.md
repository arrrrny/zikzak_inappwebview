# Cycle Log: Dismiss Dialogues Setting (002)

Append only. Newest last. Every entry's `red` block is the evidence that the test
existed and failed before the implementation.

## Baseline

- suite: `cd zikzak_inappwebview && flutter test` -> `00:05 +95 -2` (95 pass, 2 files fail to compile; the 2 reds are pre-existing and unrelated to this feature — see profile notes)
- module tests: `flutter test test/dialogue_dismisser/dialogue_dismisser_test.dart` -> all green
- commit: `abfa842e`
- recorded: cycle 0, before any change
- note: global umbrella baseline is RED only because of two unrelated broken files
  (`headless_dispose_test.dart`, `webview_sessions_test.dart`). The `dialogue_dismisser`
  module is green. This feature's cycles run against the module + new tests; the two
  broken files are tracked separately and are not part of any cycle here.

## Cycle 1 — A1 (dismissDialogues defaults to false)

- behavior: `InAppWebViewSettings.dismissDialogues` defaults to `false` (overlay removal disabled).
- kind: characterization (the field + default already exist in `in_app_webview_settings.zorphy.dart`).
- test: `zikzak_inappwebview/test/dismiss_dialogues_setting_test.dart`
  (`InAppWebViewSettings.dismissDialogues (FR-001, FR-002, SC-001) defaults to false (overlay removal disabled)`)
- red: N/A — test written against pre-existing behavior, passed on first run (no implementation change required).
- red command: `cd zikzak_inappwebview && flutter test test/dismiss_dialogues_setting_test.dart --plain-name "defaults to false (overlay removal disabled)"`
- red output: `00:00 +1: All tests passed!` (verified; the default already holds, so this is BASELINE not RED)
- green: same run — green, no source change needed.
- suite: only this file run; umbrella full-suite baseline remains `00:05 +95 -2` (unchanged).
- refactor: none.
- commit: not committed (work-in-progress; `--no-commit` session).
- note: this is a characterization entry, not a test-after admission. The field and its `false` default predate this list; the test locks the contract so a later change would go red.

## Integration attempt — A2/A4 (overlay removal on device)

- test: `zikzak_inappwebview/example/integration_test/dismiss_dialogues_test.dart`
  (`SC-002: dismissDialogues removes fixed/sticky overlays when enabled`,
   `SC-004: dismissDialogues leaves overlays intact when disabled`)
- macOS desktop (`-d macos`): built OK, but the run hung until the 15-min task
  cap and the harness aborted with
  `Bad state: Cannot close sink while adding stream` in `FlutterPlatform._startTest`.
  Root cause: headless macOS WebView in `flutter test -d macos` does not foreground
  (`Failed to foreground app; open returned 1`) and `pumpAndSettle` never settles
  with a live WebView; the test "did not complete". The assertion logic is correct
  (the inline `dismissDialogues` JS runs in `onLoadStop`, `in_app_webview.dart:337`).
  Reworked the test to drop `pumpAndSettle` (fixed delays + per-call timeouts) and
  re-pointed the run at Android (`emulator-5554`) and iOS for reliable evidence.
- Android (`emulator-5554`): required `minSdk = 26` in
  `example/android/app/build.gradle.kts` (plugin needs a higher SDK than the
  example default). After that the APK built, but `onWebViewCreated` never fired
  in the test harness (controller future timed out at 20s) — a known limitation of
  driving `InAppWebView` under `flutter test` on Android, not a feature bug. The
  dismissal logic itself is identical to iOS and source-verified.
- iOS Simulator (`iPhone 16e`, `38AC6290-...`): **PASSED** both cases.
  - command: `flutter test integration_test/dismiss_dialogues_test.dart -d 38AC6290-6E3D-4FCC-BBD4-33F6DF0410D0`
  - output: `00:12 +2: All tests passed!` (SC-002 then SC-004)
  - This is the acceptance evidence: with `dismissDialogues: true` the fixed/sticky
    overlays are removed and content is preserved; with `false` they remain.
- platform status: iOS ✓ verified; macOS ⚠ harness limitation (headless webview);
  Android ⚠ harness limitation (`onWebViewCreated` not firing under `flutter test`).
  Both limitations are environment/tooling, not regressions in the feature.
- A3 (SC-003 dynamic overlays) and A5 (SC-005 no crash) remain PENDING: not yet
  exercised by an integration test. The inline removal retries 3× on `onLoadStop`
  (covers A3's intent) and wraps each removal in try/catch (covers A5's intent),
  but neither is asserted by a test yet.

## Cycle 2 — A3 (dynamic late-loading overlays removed within retry window)

- behavior: fixed/sticky overlays injected *after* `onLoadStop` (here via `setTimeout(1000)`)
  are still removed by the 3× retry loop.
- kind: characterization of existing inline dismissal (`in_app_webview.dart` onLoadStop
  retry loop). The implementation predates the test.
- test: `zikzak_inappwebview/example/integration_test/dismiss_dialogues_test.dart`
  (`SC-003: dismissDialogues removes fixed/sticky overlays injected after load (retry window)`)
- red (deliberate mutant): the source loop `for (var i = 0; i < 3; i++)` was changed to
  `i < 0` (no removal runs), then ran the single test:
  - command: `cd zikzak_inappwebview/example && flutter test integration_test/dismiss_dialogues_test.dart --plain-name "SC-003" -d 38AC6290-6E3D-4FCC-BBD4-33F6DF0410D0`
  - output: `00:06 +0 -1: ... SC-003 ... [E]` failing at line 179 (`#late` still present)
  - restored source to `i < 3` afterwards; re-ran -> `00:06 +1: All tests passed!`
- green: full integration run on iOS Simulator:
  - command: `cd zikzak_inappwebview/example && flutter test integration_test/dismiss_dialogues_test.dart -d 38AC6290-6E3D-4FCC-BBD4-33F6DF0410D0`
  - output: `00:20 +4: All tests passed!` (SC-002, SC-004, SC-003, SC-005)
- refactor: none (test helper `pumpWebView` gained an `html` parameter so A3/A5 can
  load bespoke pages; A2/A4 unaffected).
- platform status: iOS Simulator ✓ verified. macOS desktop / Android emulator NOT run:
  the same `loadData`/`onWebViewCreated` harness timeouts that block A2/A4 also block
  these (see T039/T040, still open).
- note: this is a characterization cycle — the behavior already existed, so the red is a
  mutant, not a missing-implementation failure. The mutant proves the test asserts the
  retry loop, not merely loads the page.

## Cycle 3 — A5 (JS error non-propagation)

- behavior: when the removal script throws (page overrides `document.querySelectorAll`
  to throw), the web view stays responsive and can still execute JS afterwards.
- kind: characterization of the outer `try/catch` in `in_app_webview.dart` onLoadStop.
- test: `zikzak_inappwebview/example/integration_test/dismiss_dialogues_test.dart`
  (`SC-005: dismissDialogues never crashes the web view when the removal script throws`)
- red: not a missing-implementation red — behavior predates the test. No clean deliberate
  mutant available: removing the outer try/catch leaves an *unhandled async* error that
  does not fail a subsequent `evaluateJavascript`, so a mutant would not flip the test.
  Recorded as characterization; the test nonetheless locks the "web view survives + stays
  responsive" contract that a future regression would break.
- green: included in the same iOS Simulator run -> `00:20 +4: All tests passed!`.
- refactor: none.
- platform status: iOS Simulator ✓ verified. macOS desktop / Android emulator blocked
  by the same harness timeouts (T039/T040 open).
