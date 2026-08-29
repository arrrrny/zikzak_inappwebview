---
feature: 014-portable-sessions
verdict: FAIL
standard: .specify/extensions/tdd/templates/tdd-test-quality-rubric.md
verified_at: d31a9909
behaviors: 28
proven: 0
likely: 0
test_after: 6
no_test: 0
not_applicable: 22
high_smells: 0
criteria_total: 11
criteria_covered: 11
mutation_score: 11 # 11/11 deliberate mutants killed, scope: lib/src/webview_sessions/webview_sessions.dart
mutants_survived: 0
suite: 118 passed, 0 failed, ~36s
---

# TDD Verification: Portable Sessions (via zikzak_session)

**Verdict: FAIL.** Every acceptance behavior is `TEST_AFTER` — the feature shipped in
PR #256 before this TDD loop existed, so no pre-implementation red exists in git
history or the cycle log. Coverage and mutation strength are complete (11/11
mutants killed, 0 HIGH smells, all 11 spec criteria reached), so this is a
discipline/ordering failure, not a coverage failure. The rubric fails closed:
"Any `TEST_AFTER` behavior → FAIL".

## Test-first evidence

| Behavior | Class        | Evidence |
| -------- | ------------ | -------- |
| A1       | TEST_AFTER   | cycle-log "Unblock" + "Public-API coverage" entries; no red recorded; source shipped in PR #256 ahead of the tests |
| A2       | TEST_AFTER   | same as A1 |
| A3       | TEST_AFTER   | same as A1 |
| A4       | TEST_AFTER   | same as A1 |
| A5       | TEST_AFTER   | same as A1 |
| A6       | TEST_AFTER   | same as A1 |
| U1–U22   | NOT_APPLICABLE | Characterization baselines (green by definition against untouched code) — see test-list states |

Audit was performed by the same session that wrote the tests; the cycle log itself
discloses the test-after ordering, so no independent re-derivation was possible.

## Findings

| # | Severity | Finding | Evidence |
| - | -------- | ------- | -------- |
| 1 | (verdict) | All 6 acceptance behaviors lack pre-implementation red evidence (test-after). | `specs/014-portable-sessions/tdd/cycle-log.md:78-117` — "these tests were written against already-shipping code (feature was test-after, PR #256)" |
| 2 | none | No `HIGH` smells found. Tests assert observable results (persisted session shape, `CookieManager.setCookie` args, `localStorage.setItem` evaluations) via real `FileSessionStore`/`_FakeCookiePlatform`/`_InMemoryPort` fakes — never the subject. | `test/webview_sessions_test.dart` |

No existing passing test was weakened, loosened, skipped, or removed during the
loop; `git diff` against the feature scope shows only additions.

## Mutation results

No mutation tool in the stack (`mutation: null`). Used deliberate mutants on the
highest-risk behaviors (cookie mapping, storage harvest/apply, save/load
orchestration). Command: `flutter test test/webview_sessions_test.dart --plain-name "{name}"`.
Each mutant was restored exactly and the suite re-greened; none left in tree.

| Mutant | Behavior | Caught | Judgment |
| ------ | -------- | ------ | -------- |
| `secure ?? false` → `?? true` | U6/A5 | Yes | `Expected: false` / `Actual: <true>` |
| `value?.toString()` → `value` | U2/A5 | Yes | `int` not subtype of `String` |
| `domain ?? ''` → `?? 'NONE'` | U3/A5 | Yes | `Expected: ''` |
| `path ?? '/'` → `?? '/x'` | U4/A5 | Yes | `Expected: '/'` |
| `httpOnly ?? false` → `?? true` | U7/A5 | Yes | `Expected: false` |
| removed try/catch around evaluate | U9/A6 | Yes | exception propagated, test errors |
| removed non-Map guard | U11/A6 | Yes | compile error — guard load-bearing |
| `jsonEncode(value)` → `value` | U13/A6 | Yes | setItem arg differs |
| `port.delete` → `Future.value(false)` | U20/A3 | Yes | `Expected: true` |
| neutralized `await port.save(...)` | A1/S1 | Yes (after public-API tests added) | `Expected: length <1>` |
| `if (session==null) return false` → `return true` | A2/S2 | Yes (after public-API tests added) | `Expected: false` |

Score: **11/11 killed**, 0 survivors. The two historical survivors (S1/S2) were
closed by the test-after public-API tests (`save harvests...`/`load reports not-found...`).

## Traceability

| Criterion | Tests | End to end |
| --------- | ----- | ---------- |
| FR-001 (controller save/load/list/delete) | A3, A4, U19, U20 | Yes |
| FR-002 (delegate to SessionPort) | A1, A2, U14, U15 | Yes |
| FR-003 (harvest cookies + localStorage) | A1, U8–U12 | Yes |
| FR-004 (re-apply cookies + localStorage) | A2, U16–U18 | Yes |
| FR-005 (Cookie ↔ CookieEntry mapping) | A5, U1–U7 | Yes |
| FR-006 (storage key/value/origin) | A6, U12, U13 | Yes |
| FR-007 (injectable SessionPort) | A4, U22 | Yes |
| FR-008 (pubspec dependency) | — (dependency wiring, not a runtime behavior) | n/a |
| US1 (save/restore across restart) | A1, A2 | Yes |
| US2 (named sessions, no contamination) | A3 | Yes |
| US3 (pure-Flutter package integration) | A4 | Yes |

Untested criteria: none. Tests tracing to nothing: none.

## What was not audited

- **Mutation tool**: none in the stack, so strength is proven by deliberate mutants
  only (11 sampled behaviors), not an exhaustive mutant suite.
- **Integration/E2E on device** (save→load through a real `InAppWebViewController`):
  not run. The umbrella `flutter test` suite exercises the public API with injected
  fakes, which the traceability table reports as "end to end" at the Dart boundary.
- **Performance/load**: no criterion, not assessed.
- The `webview_sessions` files are currently **uncommitted** on branch
  `fix/webview-init-readiness-gate`; `verified_at` is the current `HEAD` (d31a9909)
  and the audit reflects the working-tree files as they stand.

## Note on remediation

The single blocking finding (test-after) is a historical ordering gap whose red
evidence cannot be retroactively produced — the code already shipped in PR #256.
Its functional coverage is now complete and mutation-pinned, so no remediation task
is warranted; the feature is safe to ship, but it will never earn a `PROVEN`
test-first classification.
