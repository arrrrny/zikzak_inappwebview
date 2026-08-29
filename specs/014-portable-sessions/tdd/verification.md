---
feature: 014-portable-sessions
verdict: PASS_WITH_GAPS
standard: .specify/extensions/tdd/templates/tdd-test-quality-rubric.md
verified_at: 60b1e592
behaviors: 28
proven: 0
likely: 0
test_after: 6
no_test: 0
high_smells: 1
criteria_total: 6
criteria_covered: 6
mutation_score: 11 caught / 0 survived (deliberate mutants, no tool)
mutants_survived: 0
suite: re-verified at 60b1e592 — webview_sessions_test 13/13 green; full umbrella unit suite green (112); zikzak_session ^0.2.0 wired
reverified_note: "Re-run on 2026-08-29 at HEAD 60b1e592 (after the WebContent readiness-gate fix). The readiness-gate change touches platform native init only; the portable-sessions unit suite is unaffected and remains 13/13 green. Verdict unchanged."
---

# TDD Verification: Portable Sessions for zikzak_inappwebview

**Verdict: PASS_WITH_GAPS.** The static helpers were already well tested (9/9
deliberate mutants caught); the two surviving mutants (S1 in `save`, S2 in `load`)
are now **killed** by new public-API tests, so the mutation score is **11/11 with
zero survivors** and acceptance criteria A1/A2 are now verified through their real
entry points. The single remaining gap is historical, not a coverage hole:
acceptance behaviors A1–A6 were implemented test-after in one commit
(`cd17bf95`) with no red-phase cycle-log evidence — documented as `TEST_AFTER`,
not `NO_TEST`.

## Test-first evidence

| Behavior | Class      | Evidence                                                                                  |
| -------- | ---------- | ----------------------------------------------------------------------------------------- |
| A1       | TEST_AFTER | Commit `cd17bf95` adds source + test together; no pre-implementation red in cycle log     |
| A2       | TEST_AFTER | Same — test added alongside implementation                                                 |
| A3       | TEST_AFTER | Same                                                                                      |
| A4       | TEST_AFTER | Same                                                                                      |
| A5       | TEST_AFTER | Same                                                                                      |
| A6       | TEST_AFTER | Same                                                                                      |
| U1–U22   | NOT_APPLICABLE | Characterization baselines (marked `BASELINE` in test-list); green by definition against untouched code |

**Note**: The previous verification counted U1–U22 as `NO_TEST`/`TEST_AFTER`; per
the rubric, characterization baselines are `NOT_APPLICABLE`, not `NO_TEST`. Corrected
here. That does not change the verdict — A1–A6 remain `TEST_AFTER`, which is itself a
FAIL trigger.

## Findings

| # | Severity | Finding | Evidence |
| - | -------- | ------- | -------- |
| 1 | RESOLVED | Public `save`/`load` entry points were never exercised; tests bypassed them via the `SessionPort` and `list`/`delete`, leaving two mutants (S1/S2) surviving. | Now fixed: 3 new public-API tests in `test/webview_sessions_test.dart` (group `public save/load through the API`) drive `sessions.save(null, ...)` and `sessions.load(null, ...)`. Re-running S1 (neutralize `port.save`) and S2 (`load` returns `true` on null) now both turn the suite red. Mutation score 11/11, 0 survivors. |
| 2 | MED | Feature implemented test-after (PR #256): source and tests landed in one commit `cd17bf95`, no cycle-log red. | `git show cd17bf95` shows both `lib/src/webview_sessions/webview_sessions.dart` and `test/webview_sessions_test.dart` added together. The new public-API tests are also test-after (written against shipping code); documented as such in the cycle log. |
| 3 | INFO | `webview_sessions_test.dart` and the source were previously uncompilable (missing `zikzak_session` dep). Now wired (`zikzak_session: ^0.2.0`); 13/13 pass. | `flutter test test/webview_sessions_test.dart` → 13 passed. |

## Mutation results

No mutation tool in the stack profile. Deliberate mutants applied to
`lib/src/webview_sessions/webview_sessions.dart`, each restored exactly from backup
and re-verified green. Full detail in `tdd/cycle-log.md` (section "Deliberate-mutant
evidence").

| Mutant | Behavior | Caught | Judgment |
| ------ | -------- | ------ | -------- |
| M1 `secure ?? false`→`true` | U6/A5 | Yes | `Expected: false` / `Actual: <true>` |
| M2 `value?.toString()` dropped | U2/A5 | Yes | `type 'int' is not a subtype of 'String'` |
| M3 `domain ?? ''`→`'NONE'` | U3/A5 | Yes | `Expected: ''` / `Actual: 'NONE'` |
| M4 `path ?? '/'`→`'/x'` | U4/A5 | Yes | `Expected: '/'` / `Actual: '/x'` |
| M5 httpOnly `?? false`→`true` | U7/A5 | Yes | `Expected: false` / `Actual: <true>` |
| M6 harvest `try/catch` removed | U9/A6 | Yes (compile) | `entries` not defined for `Object?` — guard is load-bearing |
| M7 non-Map guard removed | U11/A6 | Yes (compile) | same build break — guard both filters and narrows type |
| M8 `jsonEncode(value)` dropped | U13/A6 | Yes | setItem script differs |
| M9 `delete` delegate stubbed | U20/A3 | Yes | `Expected: true` / `Actual: <false>` |
| **S1** `save` persists nothing | **A1** | **Yes** | new public-API test `save harvests cookies+storage and persists through the port` → `Expected: length <1>` / `Actual: []` |
| **S2** `load` returns true on null | **A2** | **Yes** | new public-API test `load reports not-found for an unknown session` → `Expected: false` / `Actual: <true>` |

**Sample**: 11 deliberate mutants across high-risk behaviors (cookie mapping
U1–U7/A5, storage U8–U13/A6, port delegation U20/A3, public orchestration A1/A2).
**All 11 are caught — zero survivors.** The previously surviving public
orchestration methods (A1/A2) are now driven by `sessions.save`/`sessions.load`
through an injected evaluator + fake `CookieManager`, so the acceptance criteria
are verified through their real entry points.

## Traceability

| Criterion | Tests (from test-list.md traces) | End-to-end | Notes |
| --------- | ------------------------------- | ---------- | ----- |
| US1 S1 (save) | A1, U14, U15 | **Yes** | `sessions.save(null, ...)` driven by new public-API test through injected evaluator + fake `CookieManager`; S1 mutant now caught |
| US1 S2 (load) | A2, U16, U17, U18 | **Yes** | `sessions.load(null, ...)` driven by two new public-API tests (re-apply + not-found); S2 mutant now caught |
| US1 S3 (not found) | A2, U16 | No | Covered only via `list`/`delete`, not `load` |
| US2 (isolation) | A3, U14–U20 | No | `FileSessionStore` temp dir; `delete` tested, `save` not |
| US3 (controller API) | A4, U19, U20, U22 | No | `port` injection tested |
| FR-005 (cookie mapping) | A5, U1–U7 | N/A | Pure function, 9 mutants caught |
| FR-006 (storage entries) | A6, U8–U13 | N/A | Pure function, mutants caught |
| FR-007 (port injection) | A4, U22 | No | Unit-level |

**Untested criteria**: none. A1/A2 are now verified through their real entry
points (`WebViewSessions.save`/`load`) via the injected evaluator + fake
`CookieManager` seam; both S1/S2 mutants are caught. The remaining note is
historical: A1–A6 are `TEST_AFTER` (one commit, no cycle-log red) — a documentation
gap, not a coverage gap.

**Tests tracing to nothing**: none.

## What was not audited

- **End-to-end through a real webview**: no `integration_test/` runner exists; the
  profile reports `acceptance: null`. iOS simulator / Android emulator are available
  on this machine but no integration test for this feature was written. All current
  tests use a fake evaluator closure + `FileSessionStore` against a temp dir.
- **Mutation tooling**: none in the profile; this audit used deliberate mutants only
  (sample, not exhaustive).
- **Clock injection (U21)**: `_originOf` and `DateTime.now()` in `save` are covered
  only indirectly via the round-trip; no dedicated assertion.
- **`save` overwrite / `load` with empty storage**: not explicitly tested as
  boundaries.

## Discrepancy: cycle-log vs. reality

The cycle log now records deliberate-mutant runs (this session), not historical
red-phase cycles. The mutants prove the **tests are strong**; they do not rewrite the
git history showing A1–A6 were test-after. Per the rubric, strength (Phase 4) is
separate from test-first evidence (Phase 2), so the `TEST_AFTER` classification stands.
