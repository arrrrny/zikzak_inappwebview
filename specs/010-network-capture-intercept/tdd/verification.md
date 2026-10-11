---
feature: 010-network-capture-intercept
verdict: FAIL
standard: .specify/extensions/tdd/templates/tdd-test-quality-rubric.md
verified_at: 90f2d9ce # HEAD of fix/webview-init-readiness-gate
behaviors: 20
proven: 6 # A10, A11, A12, A13, A14, A15
likely: 0
test_after: 0
no_test: 14 # A1-A9, A16-A20
not_applicable: 0
high_smells: 0
criteria_total: 7 # SC-001..SC-007
criteria_covered: 2 # SC-004 (redaction), SC-005 (per-domain budgets)
mutation_score: null # no mutation tool; 6 deliberate mutants sampled (all caught)
mutants_sampled: 6 # A10, A11, A12, A13, A14, A15 — every implemented behavior
suite: "umbrella 186 passed / 0 failed (9s); platform_interface 153 passed / 0 failed (3s)"
---

# TDD Verification: Network Capture — Mission-Grade Intercept (010)

**Verdict: FAIL.** Five of seven acceptance criteria (SC-001, SC-002, SC-003, SC-006,
SC-007) have **no test**, and 14 of 20 behaviors are `NO_TEST`. This is an
**upgrade from the prior `BLOCKED`** verdict (verified_at `15310f04`): the suite was
then red and the feature was believed untested, whereas at `90f2d9ce` the suite is
green (umbrella 186 / platform_interface 153) and **six behaviors (A10–A15) are
`PROVEN`** with real red→green evidence and passing deliberate mutants. The feature
is no longer "nothing tested" — it is "security + cost-control behaviors proven, the
rest unwritten".

## Implementation status (scouted at HEAD 90f2d9ce)

Implementation IS present for the captured behaviors:
- `lib/src/in_app_webview/network_capture/secret_redactor.dart` — `redactRequest`,
  `redactResponse`, `redactBody` (FR-007 / SC-004, A13–A15).
- `zikzak_inappwebview_platform_interface/lib/src/types/network_capture_controller.dart`
  — `DomainBudget`, `domainBudgets`, per-domain `maxEntries`/`maxBytes`/`maxBodySize`
  enforcement in `trackRequest`/`attachBody` (FR-006 / SC-005, A10–A12).

The remaining behaviors (sightings/distillation, streaming `stopOn`, salvage flush,
SSO auth detection + body drop, overhead benchmark) have **no test and, for several,
only partial source** — their criteria are unverified.

## Test-first evidence

| Behavior | Class     | Evidence                                                                 |
| -------- | --------- | ----------------------------------------------------------------------- |
| A10      | PROVEN    | cycle-log red `Expected: <15> Actual: <55>`; test+source in `ecb9807b`   |
| A11      | PROVEN    | cycle-log red `Expected: <3> Actual: <4>`; test+source in `31b72b72`    |
| A12      | PROVEN    | cycle-log red `Expected: <5> Actual: <20>`; test+source in `8d7a0a1d`    |
| A13/A14  | PROVEN    | cycle-log red `Expected: '<redacted>' Actual: 'Bearer s3cr3t...'`; source `6db11a5d` |
| A15      | PROVEN    | cycle-log red `Expected: not contains 'AKIA...' Actual: '...api_key=AKIA...'`; source `35286a83` |
| A1–A9    | NO_TEST   | no test file references these behaviors                                  |
| A16–A20  | NO_TEST   | no test file references these behaviors                                  |

Git history corroborates the ordering: for every proven behavior the test file and
its source change land in the **same commit** (a legitimate per-cycle commit), and
the cycle log records the genuine red output. No test was weakened, skipped, or
renamed to dodge a filter. No existing test was loosened by this work.

## Findings

| #   | Severity | Finding                                                                                                  | Evidence                                  |
| --- | -------- | -------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| 1   | —        | **Verdict driver:** SC-001/002/003/006/007 have no test; 14 behaviors `NO_TEST`. Feature incomplete.     | `tdd/test-list.md` rows A1–A9, A16–A20    |
| 2   | MED      | Cycle-log commit SHAs for A13/A14 (`55e02139`) and A15 (`72d4896f`) are **stale** — they do not exist at HEAD (amended to `6db11a5d` / `35286a83`). Red evidence is genuine; only the SHA is wrong. Cycle log is append-only, so this is documented here rather than edited. | `tdd/cycle-log.md:28,49` |
| 3   | MED      | **Outer-loop acceptance gap:** Phase-3 tasks T051–T055 say "(outer loop green)", but no integration acceptance test exercises A10–A15 through the live capture path (`NetworkCaptureManager._onJavaScriptEvent`). Unit tests call `redactRequest` / `NetworkCaptureController` directly, which is strong but is not end-to-end. `redactBody` is also a pass-through stub (`secret_redactor.dart:111`) — A15 body content redaction beyond form-urlencoded is unverified. | `specs/010/.../tasks.md:61-65`; `secret_redactor.dart:108-111` |
| 4   | LOW      | `tasks.md` T010–T012 / T031–T033 were unchecked while the test-list marks A10–A12 `DONE`. Bookkeeping gap, reconciled during this audit (ticked). | `tasks.md:14-16,38-40` |

No `HIGH` smells. The six tests are well-formed: named after the behavior, use named
constants (`budgetDomain`, `kRedactionMarker`), and assert **observable results**
(redacted value equals the marker, truncated length equals 5, other domain unaffected)
rather than doubles, internals, or truthiness. They are not tautological, not
vacuous, and do not double the subject.

## Mutation results (deliberate mutants — no mutation tool)

Six behaviors sampled (every implemented one). Each mutant was applied, the behavior's
test was run (must fail), then the code was restored exactly and the suite re-run
green.

| Mutant                                                              | Behavior | Caught | Judgment                                  |
| ------------------------------------------------------------------- | -------- | ------ | ----------------------------------------- |
| `secret_redactor.dart` removed `'authorization'` from header keys    | A13      | Yes    | Redaction test fails on header assertion  |
| `secret_redactor.dart` removed `'cookie'` from header keys           | A14      | Yes    | Redaction test fails on cookie assertion  |
| `secret_redactor.dart` removed `'api_key'` from param keys           | A15      | Yes    | Redaction test fails on URL/body assertion |
| `trackRequest` early-return drop disabled (`maxEntries`)             | A10      | Yes    | Count 55 vs expected 15                   |
| `attachBody` maxBytes drop disabled                                  | A11      | Yes    | withBodies 4 vs expected 3               |
| `attachBody` truncation inverted (`>` → `<`)                         | A12      | Yes    | Body length 20 vs expected 5              |

All six survivors-caught. No surviving mutant inside a `DONE` behavior. The six
proven behaviors are genuinely regression-protected.

## Traceability

| Criterion | Behaviors | Test (real entry point) | Covered |
| --------- | --------- | ----------------------- | ------- |
| SC-001    | A1,A2,A3  | —                       | No      |
| SC-002    | A4,A5,A6  | —                       | No      |
| SC-003    | A7,A8,A9  | —                       | No      |
| SC-004    | A13,A14,A15 | `zikzak_inappwebview/test/network_capture_redaction_test.dart` (unit: `redactRequest`) | Yes |
| SC-005    | A10,A11,A12 | `zikzak_inappwebview_platform_interface/test/types/network_capture_controller_budget_test.dart` (unit: `NetworkCaptureController`) | Yes |
| SC-006    | A16,A17,A18 | —                     | No      |
| SC-007    | A19,A20   | — (requires device benchmark; not unit-testable) | No      |

Untested criteria: SC-001, SC-002, SC-003, SC-006, SC-007.
Tests tracing to nothing: none.

## What was not audited

- **Mutation tool absent** (profile `mutation: null`). Coverage is by 6 deliberate
  mutants, not exhaustive across all 7 criteria — only the 6 implemented behaviors
  were sampled.
- **`NetworkCaptureManager` redaction wiring is not covered.** The unit tests call
  `redactRequest`/`redactBody` directly; no test exercises the manager's
  `_onJavaScriptEvent` path that applies redaction before raw callbacks/collector.
  A coverage run was not performed for this audit, so the exact untested branches
  there are not enumerated.
- **Outer-loop / device behavior** (SC-001 sightings, SC-002 streaming, SC-003
  salvage, SC-006 auth detection, SC-007 overhead) is unverified by any test.
- **Android/iOS/macOS capture parity** (FR-011) is not exercised; the only native
  surface touched is the JS-injection redactor, tested in Dart.
