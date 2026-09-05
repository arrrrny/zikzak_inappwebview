---
feature: keepalive-dispose-release-gap (bug #295)
verdict: PASS_WITH_GAPS
standard: .specify/extensions/tdd/templates/tdd-test-quality-rubric.md
verified_at: a0c22131
behaviors: 10
proven: 5
likely: 5
test_after: 0
no_test: 0
high_smells: 0
criteria_total: 2
criteria_covered: 2
mutation_score: 100 # deliberate-mutant sampling only: 4/4 caught (M1-M4); no mutation tool in stack profile
mutants_survived: 0
suite: umbrella 245 passed, 2 failed (both pre-existing on master 8c6c13f7, unrelated to this fix); dispose suites 21/21 passed
---

# TDD Verification: keepAlive dispose releases native view on subsequent plain dispose (bug #295)

**Verdict: PASS_WITH_GAPS.** The core bug behaviors (U5, U9) have real
test-first red evidence and are pinned by four caught deliberate mutants; both
spec criteria (FR-007 release, FR-008 idempotency) are covered. The gaps: five
FR-008 lock behaviors have no behavioral red (impossible by construction — the
old guard blocked strictly more) and rest on headless-side mutant proof;
acceptance coverage runs through the wrapper entry points with fake platforms
because no `integration_test/` harness exists (the same gap the spec 013 audit
recorded); and the umbrella suite carries 2 pre-existing failures on master
unrelated to this fix.

## Test-first evidence

| Behavior | Class  | Evidence |
| -------- | ------ | -------- |
| U5 (headless keepAlive release) | PROVEN | cycle 1 real red recorded (`Expected: <2> / Actual: <1>`); mutant M1 re-flips it at a0c22131; test + source in same commit a0c22131 |
| U9 (controller keepAlive release, regression from #227) | PROVEN | real red on untouched baseline before any fix; restored by the three-state guard; mutant M4 re-flips it; same commit a0c22131 |
| U5b (keepAliveHeld repeat no-op, headless) | PROVEN | lock with mutant red: M2 flips U5b (`Expected: <1> / Actual: <2>`) |
| U5c (released terminal for keepAlive, headless) | PROVEN | lock with mutant red: M3 flips U5c and U3 |
| A8 (acceptance: keep-alive resource fully released by subsequent plain dispose) | PROVEN | mapped per spec 013 Cycle-15 convention to U5 + U9, both PROVEN; wrapper entry points are the real public API (no integration harness exists) |
| U9b (controller plain double-dispose no-op) | LIKELY | green lock; behavioral red impossible pre-fix (old guard strictly more blocking); no controller-side M3-analog mutant run |
| U9c (controller keepAliveHeld repeat no-op) | LIKELY | green lock; same reasoning; no controller-side M2-analog mutant run |
| U9d (controller released terminal for keepAlive) | LIKELY | green lock; same reasoning |
| A8-server (plain dispose after keepAlive completes release, no double close) | LIKELY | green lock documenting the allowed release transition; one transient failure during the cycle was a fake-fidelity correction (close() now models stop), not implementation red — see cycle-log Cycle 3 |
| A8-server-b (server keepAlive repeat no-op) | LIKELY | green lock; U17 contract (flag has no server-behavior effect) preserved |

## Findings

| # | Severity | Finding | Evidence |
| - | -------- | ------- | -------- |
| 1 | MED | Five FR-008 locks are LIKELY, not PROVEN: the pre-fix guard blocked strictly more calls, so no behavioral red exists for repeat/terminal no-ops; mutant proof was sampled on the headless guard (M2/M3) and not repeated per-wrapper | cycle-log Cycle 3; Mutant session |
| 2 | LOW | A8 acceptance is covered at wrapper level with fake platforms, not end to end on a device; native-view retention/release (A7) remains device-only and out of unit scope, unchanged from the spec 013 audit | specs/013 tdd/verification.md; test-list A7 note |
| 3 | LOW | Umbrella suite has 2 pre-existing failures on master unrelated to this fix: `domain_controllers_behavioral_test.dart` U14 (loadSimulatedRequest delegation) and a compile/load error in `proxy_tracing_controllers_test.dart`; both reproduce identically with this branch's changes stashed | flutter test run at master 8c6c13f7 vs a0c22131 |
| 4 | LOW | The dispose test fake for the server initially under-modeled the platform contract (`close()` must stop the server); corrected in a0c22131 with a comment pinning the contract | test/in_app_localhost_server_dispose_test.dart (fake close()) |

## Mutation results

No mutation tool in the stack (`mutation: null` in the TDD stack profile). Four
deliberate mutants sampled, all on the changed guard logic:

| Mutant | Behavior | Survived | Judgment |
| ------ | -------- | -------- | -------- |
| M1: headless guard → single-boolean | U5 | No | Caught; single-boolean semantics regression pinned |
| M2: keepAliveHeld identical-repeat unblocked (headless) | U5b | No | Caught; FR-008 keepAlive-repeat no-op pinned |
| M3: released non-terminal for keepAlive (headless) | U5c, U3 | No | Caught by both; terminal release state pinned |
| M4: controller guard → single-boolean | U9 | No | Caught; controller keepAlive release-forwarding pinned |

## Traceability

| Criterion | Tests | End to end |
| --------- | ----- | ---------- |
| FR-007 (next non-keep-alive dispose fully releases) | U5, U9, A8, A8-server | Wrapper-level (no device harness) |
| FR-008 (repeated/concurrent dispose: no throw, no double platform invoke) | U3, U6, U16, U5b, U5c, U9b, U9c, U9d, A8-server-b | Wrapper-level |

Untested criteria: none. Tests tracing to nothing: none.

## What was not audited

- Device/platform-channel behavior: `isKeepAlive` retention on real platform
  implementations is not observable at the wrapper level with fakes; A7 stays
  PENDING (device-only), unchanged from spec 013.
- `InAppWebView` widget path (U11/U12): forwards `isKeepAlive` directly with no
  guard; verified green and intentionally left unguarded (minimal fix) — no
  new tests added there.
- The 2 pre-existing umbrella failures were reproduced for baseline evidence
  only; triaging them is outside this bug's scope.
- Mutation testing was deliberate sampling on the changed guard logic, not a
  full-suite mutation run.
