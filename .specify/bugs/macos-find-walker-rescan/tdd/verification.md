---
feature: macos-find-walker-rescan
verdict: PASS_WITH_GAPS
standard: .specify/extensions/tdd/templates/tdd-test-quality-rubric.md
verified_at: 92d5c85e
behaviors: 7
proven: 5
likely: 0
test_after: 0
no_test: 0
high_smells: 0
criteria_total: 6
criteria_covered: 6
mutation_score: n/a
mutants_survived: 0
suite: 200 passed, 0 failed, 2:36
---

# TDD Verification: Reliable macOS find-in-page results on virtualized pages

**Verdict: PASS_WITH_GAPS.** Every specified behavior has executable coverage through the injected script, all five behavior changes have recorded red-before-green history, and five deliberate mutants were caught. The remaining gaps are the unpinned Node test prerequisite and the pre-existing source-token assertions; neither leaves an acceptance criterion untested.

## Test-first evidence

| Behavior | Class | Evidence |
| ------- | ----- | -------- |
| A1 | PROVEN | Cycle 2 records the `0 !== 1` message-count red; `d15341ea` adds the test and `finally` delivery together. |
| A2 | PROVEN | Cycle 3 records the `0 !== 1` message-count red; `d6387885` adds the test and unconditional navigation post together. |
| A3 | PROVEN | Cycle 4 records the `0 !== 1` message-count red; `b3db92ed` adds the zero-match boundary and guarded navigation together. |
| A4 | PROVEN | Cycle 5 records the missing-timer red; `0a5ac008` adds the rescan. `92d5c85e` strengthens the same behavior with a controllable clock and restart-boundary assertions. |
| A5 | PROVEN | Cycle 6 records the surviving-timer red; `ff5648bb` adds cancellation and active-keyword reset together. |
| A6 | NOT_APPLICABLE | Characterization of existing #1155 nested-root behavior; `6b73bb90` adds the executable baseline and `92d5c85e` strengthens iframe cleanup. |
| A7 | NOT_APPLICABLE | Characterization of existing listener-count and null-document safety; added with the audit-strengthening commit `92d5c85e`. |

No existing assertion was removed, skipped, renamed out of reach, or loosened. The formatter changed layout in the touched Dart test file but not assertion meaning.

## Findings

| # | Severity | Finding | Evidence |
| - | -------- | ------- | -------- |
| 1 | MED | The Node runtime used by the executable harness is not declared or pinned by the Flutter-only CI job. | `zikzak_inappwebview_macos/test/find_shadow_dom_contract_test.dart:164`; `.github/workflows/ci.yml:134-144`. Local verification used Node v24.21.0. CI provisioning was not changed without authorization. |
| 2 | MED | The original #1155 source-token checks are implementation-coupled and comment-sensitive. | `zikzak_inappwebview_macos/test/find_shadow_dom_contract_test.dart:37-90`. They predate this fix and were retained rather than weakened; the executable Node scenarios are authoritative for behavior. |

The independent audit's three HIGH findings were resolved before this report: iframe cleanup is now exercised in both roots, debounce timing uses a fake clock with before/at/restart checks, and A7 verifies one capture listener plus a null `contentDocument`.

## Mutation results

No mutation tool is recorded in the stack profile. Five deliberate mutants were run individually, observed failing, restored exactly, and followed by a green full suite.

| Mutant | Behavior | Survived | Judgment |
| ------- | -------- | -------- | -------- |
| Disabled open-shadow-root traversal (`if (false && element.shadowRoot)`) | A6 | No | Caught by `0 !== 1`; baseline has real nested-root strength. |
| Disabled iframe highlight cleanup | A6 | No | Caught by `2 !== 1`; both roots now must be clean after rerun. |
| Changed rescan delay from 150 ms to 0 ms | A4 | No | Caught by `1 !== 0` before the debounce threshold. |
| Duplicated the `scrollend` listener registration | A7 | No | Caught by listener count `2 !== 1`. |
| Removed the null `contentDocument` guard | A7 | No | Caught by `TypeError: Cannot read properties of null (reading 'body')`. |

## Traceability

| Criterion | Tests | End to end |
| --------- | ----- | ---------- |
| AC-1 | A1 | Yes: exact injected script, partial walk, bridge message observed. |
| AC-2 | A2 | Yes: exact injected script, missing active node, bridge message observed. |
| AC-3 | A3 | Yes: exact injected script, zero-match boundary, bridge message observed. |
| AC-4 | A4 | Yes: exact injected script, fake-clock scroll events, mounted text and bridge message observed. |
| AC-5 | A5 | Yes: exact injected script, pending timer cancellation and no stale post observed. |
| AC-6 | A6, A7 | Yes: exact injected script, open shadow root, accessible iframe, and null-document iframe observed. |

Untested criteria: none. Tests tracing to no criterion or requirement: none.

## What was not audited

- A real WebKit session against GitHub's 6,630-line virtualized blob was not driven; the Node fixture is a minimal deterministic DOM, not jsdom or a browser.
- The macOS example build compiles the changed Swift but does not exercise find-in-page interactively.
- Mutation was a five-mutant manual sample, not exhaustive mutation testing.
- Node provisioning in CI remains unpinned and requires an authorized workflow change.
- Performance on a production-size DOM was not benchmarked; the implementation uses a 150 ms debounce and only runs while a non-empty query is active.
