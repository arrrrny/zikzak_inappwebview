# Tasks: Reliable macOS find-in-page results on virtualized pages

Tests are mandatory and must be observed failing before their implementation. Run every Flutter test command with `--concurrency=2`.

## Phase 0: Baseline

- [X] T001 Establish the macOS package baseline against published dependencies: `flutter test --concurrency=2` -> 193 passed, 0 failed.

## Phase 1: Characterization and harness

- [X] T002 Add the Node DOM harness and executable nested-root characterization test without changing production source.
- [X] T003 Verify the characterization test with a deliberate shadow-root mutant, restore the source, and rerun the suite green.

## Phase 2: Exception-safe count delivery

- [X] T004 Add the failed-walk regression test and record its red output. [A1]
- [X] T005 Deliver final counts from `finally` and rerun the full suite green. [A1]
- [X] T006 Run the A1 acceptance test after implementation and record green evidence. [A1]

## Phase 3: Navigation result delivery

- [X] T007 Add the missing-highlight navigation regression test and record its red output. [A2]
- [X] T008 Post navigation counts even when the active highlight is missing and rerun the full suite green. [A2]
- [X] T009 Run the A2 acceptance test after implementation and record green evidence. [A2]
- [X] T010 Add the zero-match navigation boundary test and record its red output. [A3]
- [X] T011 Post zero-match navigation counts and rerun the full suite green. [A3]
- [X] T012 Run the A3 acceptance test after implementation and record green evidence. [A3]

## Phase 4: Virtualized-page rescans

- [ ] T013 Add the debounced scrollend rescan regression test and record its red output. [A4]
- [ ] T014 Retain the active query and rerun it once after a debounced scrollend; rerun the full suite green. [A4]
- [ ] T015 Run the A4 acceptance test after implementation and record green evidence. [A4]
- [ ] T016 Add the clear-cancels-rescan regression test and record its red output. [A5]
- [ ] T017 Cancel pending rescans when matches are cleared and rerun the full suite green. [A5]
- [ ] T018 Run the A5 acceptance test after implementation and record green evidence. [A5]

## Phase 5: Verification and delivery

- [ ] T019 Audit test-first evidence and run deliberate mutants for the highest-risk behaviors.
- [ ] T020 Run package analysis, the full macOS suite, and a macOS Swift build.
- [ ] T021 Restore setup-only dependency override files, review the final diff, and write the fix report.
- [ ] T022 Push the branch, open the PR linked to issue #472, pass the evidence gate, and complete the pool task.
