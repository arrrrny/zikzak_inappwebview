---
feature: 279-per-profile-proxy
verdict: PASS
standard: .specify/extensions/tdd/templates/tdd-test-quality-rubric.md # rubric graded against
verified_at: cd9b116c # short SHA audited
behaviors: 45 # 8 acceptance (A1-A8) + 37 unit (U1-U36 incl. U19b)
proven: 45
likely: 0
test_after: 0
no_test: 0
high_smells: 0
criteria_total: 8
criteria_covered: 8
mutation_score: 100 # deliberate mutants, scope: 3 sampled behaviors (no mutation tool in profile)
mutants_survived: 0 # 3/3 caught; one earlier attempt was an invalid mutant (see Mutation results)
suite: 44 passed, 0 failed, ~7s # fresh run at audit time, cwd zuraffa_browser
---

# TDD Verification: Per-profile and global proxy support (zuraffa_browser)

**Verdict: PASS.** Every behavior's test was committed red before its
implementation (git history corroborates every cycle-log red with a
test-only commit followed by an implementation commit), all 8 acceptance
criteria are covered through the package's real public entry points, and all
three sampled deliberate mutants were caught. The unit scope excludes the
two channel-backed adapters (documented below); the behavior criteria live
in the browser layer, which is fully tested.

## Audit context

Run by the same session that wrote the tests (not independent). Every test
and source file was re-read cold from the working tree at `cd9b116c`; the
three deliberate mutants were applied to the tree, observed, restored, and
the restore was verified with a full green suite run.

## Test-first evidence

Git shape per cycle (verified with `git show --name-only`):

| Cycle | Test-only commit (red) | Implementation commit | Red evidence |
| ----- | ---------------------- | --------------------- | ------------ |
| T001  | `9f350a9f`             | `bbc29809`            | compile failure of both test files (API surface absent), recorded in cycle-log |
| T002  | `4fa5bc43`             | `22f93aa6`            | `createProfile` undefined, recorded in cycle-log |
| T003  | `13d5f595`             | `2c3769a7`            | `PageHost`/`openPage`/`proxySettingsFromConfig` undefined, recorded in cycle-log |
| T004  | `f736ff61`             | `5ae867a6`            | `navigate`/`dispose` undefined, recorded in cycle-log |

| Behavior group                                            | Class  | Evidence                                                                    |
| --------------------------------------------------------- | ------ | --------------------------------------------------------------------------- |
| A1, U17-U19b (global set/persist/apply)                   | PROVEN | red at `9f350a9f` (cycle log + history)                                     |
| U1-U14 (value objects, stores, vault)                     | PROVEN | red at `9f350a9f` (compile failure covers the whole file)                   |
| A2, A3, A8, U20-U25, U15 (profile layer, resolution)      | PROVEN | red at `4fa5bc43`                                                           |
| A5, A6, U26-U30 (page API, auth vault flow, mapping)      | PROVEN | red at `13d5f595`                                                           |
| A4 (restart survival, global + per-profile)               | PROVEN | split across `9f350a9f` (global) and `4fa5bc43` (profile-level) reds        |
| A7, U16, U31-U36 (direct default, lifecycle, disposal)    | PROVEN | red at `f736ff61`                                                           |

Test-after check on existing tests: no pre-existing tests were weakened,
skipped, renamed out of filters, or deleted. The feature's own tests were
adjusted during three green phases (T001 `const`→`final` construction sites —
validation behavior and `throwsArgumentError` kept; T002 one restart
assertion made null-aware — intent kept; T003 a setup bug fixed by adding
the missing arrange step — assertion unchanged). Each adjustment is recorded
in the cycle log and none loosens an assertion.

## Findings

| # | Severity | Finding                                                                                                        | Evidence                                          |
| - | -------- | -------------------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| 1 | MED      | `PlatformProxyApplier` (channel-backed) has no test: it is a thin adapter, but a regression there would ship silently | `lib/src/platform_proxy_applier.dart`             |
| 2 | MED      | Profile-level authenticated restart (password re-resolved from the vault) is only asserted at global level (U29); U24's restored profile proxy carries no password | `test/profile_proxy_test.dart` (U24)              |
| 3 | LOW      | Fake helpers are re-defined per test file (4 files) — this matches the stack profile's "fakes defined inline per file" convention, so it is recorded, not penalized | `test/*_test.dart`                                |

No HIGH smells found. Cold-read notes: assertions are value-specific (no
vacuous/tautological patterns found), the shared event log makes the
apply-before-load ordering directly observable, `reason:` labels accompany
non-obvious expects (no assertion roulette), no conditional logic, sleeps,
clocks, or network in tests, and the fakes sit only at the injected port
boundaries (store/vault/applier/host) while the subject under test — the
browser layer — is real.

## Mutation results

No mutation tool in the stack profile (`mutation: null`); deliberate mutants
on a sample of 3, one per highest-risk behavior class (precedence, order,
secret handling). Each applied one at a time, observed, restored exactly,
and the restore verified green (`+44`).

| Mutant                                                                        | Behavior | Survived | Judgment                                                       |
| ----------------------------------------------------------------------------- | -------- | -------- | -------------------------------------------------------------- |
| `profile.dart`: `effectiveProxy` precedence inverted (`global ?? explicit`)   | A2/U21   | No       | Caught by `profile_proxy_test` (+7 -1) — override is pinned    |
| `page.dart`: `navigate` loads the URL before applying the proxy               | U31      | No       | Caught by `lifecycle_test` (+8 -1) — ordering is pinned        |
| `proxy_config.dart`: `ProxyConfig.toJson` includes `password`                 | U5       | No       | Caught by `proxy_config_test` (+13 -1) — redaction is pinned   |
| (superseded attempt: same mutation applied to `ProxyConfigRecord.toJson` too) | —        | —        | Invalid mutant (compile error), excluded from scoring          |

3 behaviors sampled out of 45; the report does not claim exhaustive mutation
coverage.

## Traceability

| Criterion | Tests (real entry point: `Browser.open` → API)                  | End to end |
| --------- | ---------------------------------------------------------------- | ---------- |
| AC1       | `A1` (global_proxy_test + lifecycle_test two-profile navigation), `U19b` | Yes |
| AC2       | `A2`, `U21`, `U23`                                               | Yes        |
| AC3       | `U22` (falls back to global; falls back to direct)               | Yes        |
| AC4       | `U19` (global), `U24` (per-profile), `U13` (file store)          | Yes        |
| AC5       | `U29` (vault flow: set, store record secretRef-only, applier receives password, restart re-resolution) | Yes |
| AC6       | `U26`/`U27` (page override + fallback), `U28` (browser level)    | Yes        |
| AC7       | `U34` (explicit clear applied on first navigation)               | Yes        |
| AC8       | `U25`, `U15` (inheritance before and after global is set)        | Yes        |

Untested criteria: none. Tests tracing to nothing: none (units U1-U14, U30
trace to FR-001/002/005/009/012 in the test list).

## What was not audited

- The channel-backed adapters (`PlatformProxyApplier`,
  `HeadlessPageHost`) are outside unit-test scope: exercising them needs
  platform channels or a mocked `InAppWebViewPlatform`. The pure mapping
  they consume (`proxySettingsFromConfig`, U30) IS tested; the adapters
  themselves are not (finding #1, remediation task below).
- Deliberate mutants sampled 3 of 45 behaviors; the rest are unmeasured.
- Coverage tooling was not run (`flutter test --coverage` exists in the
  profile but was not used as evidence; traceability was done via the test
  list and a cold read).
- The pre-existing reds in `zikzak_inappwebview` (+240 -2) and
  `zikzak_inappwebview_platform_interface` (+305 -1) and the broken pub-cache
  copy of hosted `zuraffa 6.0.0` used by `zikzak_inappwebview_module` are
  outside this feature's scope (baseline recorded in the cycle log; this
  feature introduces no new failures in either in-scope package).
- Performance, load, and real-network proxy behavior: no criterion, no test,
  not assessed.
