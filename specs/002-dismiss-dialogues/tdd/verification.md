---
feature: 002-dismiss-dialogues
verdict: PASS_WITH_GAPS
standard: .specify/extensions/tdd/templates/tdd-test-quality-rubric.md # rubric graded against
verified_at: 5dc31499 # HEAD at re-audit; 002 e2e re-verified on macOS + Android after the WebView readiness gate
behaviors: 12
proven: 0
likely: 0
test_after: 0
no_test: 0
not_applicable: 12
high_smells: 0
criteria_total: 5 # SC-001..SC-005
criteria_covered: 5
mutation_score: null # no mutation tool in repo; deliberate-mutant sampled on A3 only
suite: "umbrella unit: 98 passed, 0 failed; integration iOS sim: 4 passed; macOS desktop: 4 passed; Android emulator (API 26): 4 passed"
---

# TDD Verification: Dismiss Dialogues Setting (002)

**Verdict: PASS_WITH_GAPS.** All five acceptance criteria (SC-001..SC-005) are covered by
passing tests exercised through the real WebView entry point on **three** platforms
(iOS Simulator, macOS desktop, Android emulator API 26), and there are no HIGH smells.
The remaining gaps are: (1) every behavior is characterization of pre-existing code — no
red-green loop with implementation written in response to the test; (2) mutation strength
is unmeasured (no mutation tool; only A3 got a deliberate-mutant proof). The previous
cross-platform gap (macOS desktop + Android blocked by the headless-WebView harness,
T039/T040) is **resolved** by the WebView readiness gate on this branch — see re-audit
note and cycle-log Cycles 4–5.

## Note on history (read this first)

`git log` shows the 002 branch's tests and the test-list/cycle-log are **uncommitted**
(`specs/002-dismiss-dialogues/tdd/` and `example/integration_test/dismiss_dialogues_test.dart`
are untracked; `tasks.md` is modified). So test-first *ordering* cannot be corroborated in
git history — the cycle-log is the only evidence, and it is self-reported. This audit does
not claim PROVEN for any behavior on that basis. The audit itself was not independent: the
A3/A5 tests and the mutant check were written in the same session.

## Test-first evidence

| Behavior | Class           | Evidence |
| -------- | --------------- | -------- |
| A1 (SC-001) | NOT_APPLICABLE | Characterization of pre-existing `dismissDialogues` default; cycle 1 records "passed on first run". |
| A2 (SC-002) | NOT_APPLICABLE | Integration characterization of existing inline removal; green on iOS sim. |
| A3 (SC-003) | NOT_APPLICABLE | Characterization, but **deliberate-mutant proven**: disabling the `for` loop (`i<3`→`i<0`) makes A3 fail at line 179; restoring makes it pass. Strongest evidence in the feature. |
| A4 (SC-004) | NOT_APPLICABLE | Integration characterization; green on iOS sim. |
| A5 (SC-005) | NOT_APPLICABLE | Characterization. No clean deliberate mutant (see Findings #2). |
| U1–U7     | NOT_APPLICABLE | BASELINE characterization of the *separate, unwired* `DialogueDismisser` module (test-list divergence finding). |

No `TEST_AFTER`, no `NO_TEST`. The absence of `PROVEN`/`LIKELY` is expected: this feature
was implemented before its tests, so every test is characterization.

## Findings

| # | Severity | Finding | Evidence |
| - | -------- | ------- | -------- |
| 1 | MED | **Sleepy test** — `pumpWebView` waits a fixed 4s after `onLoadStop` instead of polling for the DOM effect. Works, but can flake or waste time; a polling wait on the removed selector would be tighter. | `zikzak_inappwebview/example/integration_test/dismiss_dialogues_test.dart` (`Future.delayed(const Duration(seconds: 4))` in `pumpWebView`) |
| 2 | LOW | **A5 has no clean deliberate mutant.** Removing the outer `try/catch` in `in_app_webview.dart` leaves an *unhandled async* error that does not flip a subsequent `evaluateJavascript`, so a mutant would not change A5's outcome. The test still locks the "web view stays responsive after a JS error" contract. | `in_app_webview.dart:367` (`} catch (_) {}`) |
| 3 | INFO | **Divergence**: the spec's contract (`dismissDialogues` boolean) is the *inline* removal in `in_app_webview.dart:337`, while `DialogueDismisser` is a separate content-aware module not wired to the setting. U1–U7 characterize the unwired module. Already tracked as T041; out of the acceptance trace. | `specs/002-dismiss-dialogues/tdd/test-list.md` "Critical finding" |
| 4 | INFO | **Cross-platform gap — RESOLVED.** Was: integration verified only on iOS sim because macOS desktop hung on `loadData` and Android emulator never fired `onWebViewCreated` under `flutter test`. Both are now resolved by the WebView **readiness gate** on this branch (`60b1e592` + `794024b7`/`17b29dd3`). Re-run: macOS desktop `00:19 +4: All tests passed!`, Android emulator (API 26) `00:21 +4: All tests passed!`. T039/T040 closed. | cycle-log Cycles 4–5; `git log` readiness-gate commits |

No HIGH smells. The A1 unit test asserts the observable boolean (default + toggle), not a
double. The integration tests assert real DOM state via `evaluateJavascript`, with
labelled `reason:` arguments, so failures are specific.

## Mutation results

No mutation tool (`mutation_test`) in the lockfile. Deliberate mutants sampled:

| Mutant | Behavior | Caught | Judgment |
| ------ | -------- | ------ | -------- |
| `in_app_webview.dart` removal loop `i<3` → `i<0` | A3 | Yes | A3 fails at `#late` assertion, proves it tests the retry loop. Restored; re-ran green. |
| `in_app_webview.dart` outer `try/catch` removed | A5 | No* | *Unhandled async — would not flip A5; mutant not reliable, recorded as limitation. |

Scope: 1 of 5 acceptance behaviors sampled. Not exhaustive.

## Traceability

| Criterion | Tests | End to end |
| --------- | ----- | ---------- |
| SC-001 | A1 (`dismiss_dialogues_setting_test.dart`) | Yes (setting default) |
| SC-002 | A2 (`dismiss_dialogues_test.dart` SC-002) | Yes (iOS sim, macOS desktop, Android emulator API 26) |
| SC-003 | A3 (`dismiss_dialogues_test.dart` SC-003) | Yes (iOS sim, macOS desktop, Android emulator API 26) |
| SC-004 | A4 (`dismiss_dialogues_test.dart` SC-004) | Yes (iOS sim, macOS desktop, Android emulator API 26) |
| SC-005 | A5 (`dismiss_dialogues_test.dart` SC-005) | Yes (iOS sim, macOS desktop, Android emulator API 26) |

Untested criteria: none. Tests tracing to nothing: U1–U7 trace to the separate
`DialogueDismisser` module (intentional; see Finding #3). All five `traces` targets
exist and run.

## What was not audited

- **Mutation testing**: no tool in the repo; only a single deliberate mutant was run (A3).
- **The `DialogueDismisser` module internals** beyond the existing characterization (it is
  out of the acceptance trace per the divergence finding; see ADR 001).
- **Performance / load**: no criterion, no test, not assessed.
- **minSdk API-24**: the user asked about a lowered `minSdk` (24) Android emulator. The
  current config sets `minSdk = 26` in both the plugin and the example, so the API-26
  emulator exercised here already meets the floor; an explicit API-24 emulator run was not
  performed (it would only matter if `minSdk` is lowered below 26).
- **Git-history ordering**: the 002 work was authored before its tests in this session, so
  every test is characterization; the cycle-log is the only ordering evidence. The audit
  does not claim PROVEN for any behavior on that basis.
