# Cycle Log: Reliable macOS find-in-page results on virtualized pages

Append only. Newest last. Every entry's `red` block is the evidence that the test existed and failed before the implementation.

## Baseline

- suite: `flutter test --concurrency=2` -> 193 passed, 0 failed, 2:02
- dependencies: `zikzak_inappwebview_platform_interface` 6.6.0 resolved from the hosted pub cache after the task-required path overrides were set aside
- commit: `19b13d24`
- recorded: cycle 0, before any test or production-source change
- deviation: an initial 120-second wrapper budget sent SIGTERM during test finalization at `01:47 +182`; the exact misfire was reported at https://github.com/arrrrny/zikzak_inappwebview/issues/472#issuecomment-7228988076 and the same suite passed with a 300-second hard timeout
- resolver deviation: `check-prerequisites.sh --json --paths-only` rejects the brief-mandated `feat/issue-472` branch name, so the explicitly pinned `.specify/bugs/macos-find-walker-rescan` directory is used directly

## Cycle 1: A6 nested roots are searched and cleared

- test: `test/find_shadow_dom_contract_test.dart::nested roots are searched and cleared` (new characterization)
- baseline: `flutter test --no-pub test/find_shadow_dom_contract_test.dart --plain-name "nested roots are searched and cleared" --concurrency=2` -> 1 passed against untouched source
- deliberate mutant: changed the walker's `if (element.shadowRoot)` to `if (false && element.shadowRoot)`; the same command failed with `AssertionError [ERR_ASSERTION]: Expected values to be strictly equal: 0 !== 1` at `find_interaction_harness.js:217`
- green: restored the condition exactly; full suite `flutter test --no-pub --concurrency=2` -> 194 passed, 0 failed, 1:53
- refactor: none needed; the harness is structural test support and no production source changed
- commit: `6b73bb90`

## Cycle 2: A1 failed walks still post final counts

- test: `test/find_shadow_dom_contract_test.dart::failed walks still post final counts` (new)
- red: `flutter test --no-pub test/find_shadow_dom_contract_test.dart --plain-name "failed walks still post final counts" --concurrency=2` -> `AssertionError [ERR_ASSERTION]: Expected values to be strictly equal: 0 !== 1` at `find_interaction_harness.js:247` (`messages.length`)
- green: `FindInteractionJS.swift` moved `_isDoneCounting` and the result post into `finally`; the single test passed and full suite `flutter test --no-pub --concurrency=2` -> 195 passed, 0 failed, 1:40
- refactor: none needed; the change is confined to `_findAllAsync`
- commit: `d15341ea`
