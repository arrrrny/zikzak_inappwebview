---
feature: 007-webview-pool-sessions
verdict: FAIL
standard: .specify/extensions/tdd/templates/tdd-test-quality-rubric.md # rubric graded against
verified_at: 93916240 # short SHA audited
behaviors: 18
proven: 13
likely: 0
test_after: 0
no_test: 5
high_smells: 1 # catalogue; a further HIGH finding comes from a surviving deliberate mutant (see Mutation results)
criteria_total: 18
criteria_covered: 13
mutation_score: null # no mutation tool in profile (tdd-profile mutation: null); deliberate mutants: 3/4 caught
mutants_survived: 1 # evict-arbitrary-not-oldest; judged non-equivalent (ordering is spec'd but unpinned)
suite: "module package: 23 passed, 0 failed, 4s (flutter test --concurrency=2, HEAD 93916240)"
---

# TDD Verification: WebViewPool — Mission-Scoped Sessions, Domain Affinity, Memory-Pressure Disposal (007)

**Verdict: FAIL.** 5 of 18 acceptance behaviors have no test (A6, A9, A11, A12, A15), one
catalogue HIGH smell sits in a DONE behavior (A18), and a deliberate mutant survived inside
a DONE behavior (oldest-first eviction ordering is unpinned). What IS implemented is
disciplined: all 13 tested behaviors are PROVEN test-first with recorded reds and commit
ordering, no existing test was weakened, and the suite kills 3 of 4 deliberate mutants.

This is a partial-implementation audit: the branch pulls the pre-zuraffa#389 share of spec
007 forward (the issue's 2026-09-25 status comment sanctions "plain Dart ports + fakes").
The FAIL is the honest statement that the spec is not done; the remediation section below is
the remaining work.

## Test-first evidence

History (branch `fix/264-wave-z-rewrite-zuraffa-v6-webview-module-consolidated-tracki`):
`43029b74` adds the test file alone and is red (1 passed / 13 failed, red reason recorded in
cycle-log cycle 1); `198ae7f3` adds the creation seam + the cap tests (13 green, 4 red for
recorded behavioral reasons); `0183fbe4` lands the enforcement fixes and goes green.
Cycle log, history, and files agree; no discrepancy found. The cassette tests that existed
before this branch were not touched (no assertion removal, loosening, renames, skips, or
config exclusions — diff checked).

| Behavior | Class  | Evidence                                                                                     |
| -------- | ------ | -------------------------------------------------------------------------------------------- |
| A1       | PROVEN | cycle 1 red (creation assert) recorded; test-only commit `43029b74` precedes source commits |
| A2       | PROVEN | same red run; green in `198ae7f3`                                                           |
| A3       | PROVEN | same red run; wording aligned to FR-006/U10 liveCount semantics (documented in list)        |
| A4       | PROVEN | same red run; strengthened in cycle 2 to assert real disposal via fake dispose counters     |
| A5       | PROVEN | same red run; green once the seam landed                                                    |
| A7       | PROVEN | same red run; green once the seam landed                                                    |
| A8       | PROVEN | cycle 2 red with the exact stale-domain output (`Expected 'example.com' / Actual <null>`); fixed in `0183fbe4` |
| A10      | PROVEN | cycle 2 red (acquire succeeded instead of refusing); enforcement in `0183fbe4`              |
| A13      | PROVEN | cycle 1 red; serialization killed by the deliberate `serialization-removed` mutant check    |
| A14      | PROVEN | cycle 1 red; green after seam                                                               |
| A16      | PROVEN | cycle 1 red; green after seam; asserts settings reached the factory per instance            |
| A17      | PROVEN | cycle 1 red; green after seam                                                               |
| A18      | PROVEN | red recorded, but see HIGH smell #1: the assertion itself is weak                           |
| A6       | NO_TEST | needs a real rendering/cookie context — not honestly testable with plain-Dart fakes         |
| A9       | NO_TEST | TTL sweep runs on a hardcoded 30s periodic timer; no clock injection seam yet               |
| A11      | NO_TEST | needs Flutter binding lifecycle emulation (AppLifecycleListener)                            |
| A12      | NO_TEST | platform-conditional defaults; needs per-platform test lane                                  |
| A15      | NO_TEST | high-contention burst stress beyond A13/A14's scoped concurrency checks                      |

## Findings

| #   | Severity | Finding                                                                                                                      | Evidence                                  |
| --- | -------- | ---------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| 1   | HIGH     | A18 asserts only `isA<InAppWebViewSettings>()` — a type the static system already guarantees, so it can never fail; the "default base configuration" claim is not actually verified | `zikzak_inappwebview_module/test/webview_pool_test.dart:300` |
| 2   | HIGH     | Deliberate mutant `evict-arbitrary-not-oldest` SURVIVED: the max-live eviction test uses a single idle candidate, so US3's oldest-first ordering is unpinned — a regression that evicts the wrong idle instance would ship | `webview_pool_test.dart` (evict-oldest test); `webview_pool.dart` `_evictOldestIdle` |
| 3   | MED      | A7 joins two independently-failing behaviors (cross-domain isolation; generic reuse) in one test                            | `webview_pool_test.dart:157-182`          |
| 4   | MED      | A3 appends a disposeAll tail that gives the test A4's failure reason                                                         | `webview_pool_test.dart:116-117`          |
| 5   | MED      | Header comment says `maxLiveInstances: 4` but the group pool is built with 8 — the mis-explained boundary invites wrong copies | `webview_pool_test.dart:50-51,61`         |
| 6   | MED      | `expect(identical(...), isTrue)` instead of the file's own `same()` matcher style — failure output loses both operands       | `webview_pool_test.dart:213`              |
| 7   | LOW      | The 8-line cap-pool construction is duplicated across the three cap tests, differing only in two numbers                     | `webview_pool_test.dart:337-346,365-374,400-409` |

## Mutation results

No mutation tool in the profile (`mutation: null`), so deliberate mutants per the rubric,
one at a time, each restored and the suite re-verified green before the next.

| Mutant                                              | Behavior | Survived | Judgment                                                             |
| --------------------------------------------------- | -------- | -------- | -------------------------------------------------------------------- |
| `cap-guard-dropped`: `if (!evicted)` → `if (false)` | SC-005   | No       | Caught by the cap-throw test                                         |
| `affinity-lookup-dead`: domain-idle match disabled  | FR-002   | No       | Caught by A5 (created count 2 ≠ 1)                                   |
| `serialization-removed`: `await previous` dropped   | FR-007   | No       | Caught by A13 (10 creates instead of 1)                              |
| `evict-arbitrary-not-oldest`: oldest-comparison forced true | U13/US3 | Yes | Non-equivalent: ordering is spec'd but unpinned (single idle candidate) → Finding #2 |

4 behaviors sampled (cap refusal, affinity reuse, same-session concurrency, eviction
ordering); 3/4 mutants caught. Not exhaustive.

## Traceability

| Criterion (spec.md)            | Tests                     | End to end |
| ------------------------------ | ------------------------- | ---------- |
| US1-AS1..AS4 (session cycle)   | `A1`, `A2`, `A3`, `A4`    | Yes (pool public API) |
| US2-AS1 (affinity hit)         | `A5`                      | Yes        |
| US2-AS2 (warm state round-trip)| —                         | No (A6 NO_TEST) |
| US2-AS3 (non-affine fallback)  | `A7`                      | Yes        |
| US2-AS4 (association reported) | `A8`                      | Yes        |
| US3-AS1 (TTL eviction)         | —                         | No (A9 NO_TEST) |
| US3-AS2 (per-domain cap)       | `A10` (refusal variant)   | Yes        |
| US3-AS3 (memory pressure)      | —                         | No (A11 NO_TEST) |
| US3-AS4 (platform defaults)    | —                         | No (A12 NO_TEST) |
| US4-AS1..AS2 (concurrency)     | `A13`, `A14`              | Yes        |
| US4-AS3 (burst consistency)    | —                         | No (A15 NO_TEST) |
| US5-AS1..AS3 (settings)        | `A16`, `A17`, `A18`       | Yes (A18 weak, Finding #1) |

Untested criteria: US2-AS2, US3-AS1, US3-AS3, US3-AS4, US4-AS3. FR-004 has no test (A11).
FR-010 (no MCP/zuraffa coupling) is verified structurally — the module's pubspec has no
zuraffa dependency and `lib/` imports no MCP/zuraffa types — but there is no test asserting
it; noted as remediation R8.

## What was not audited

- The umbrella package suite (184 tests per the prior report): this branch touches only
  `zikzak_inappwebview_module`; the module package is the owning package per the profile.
- Mutation is a 4-mutant deliberate sample, not a tool score.
- Native/platform behavior of `HeadlessInAppWebView` (out of scope per the test list).
- Performance/load behavior: no criterion, no test, not assessed.
