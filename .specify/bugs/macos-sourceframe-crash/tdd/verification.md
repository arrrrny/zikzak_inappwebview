# TDD Verification — macos-sourceframe-crash (bug #327)

- **Slug**: macos-sourceframe-crash
- **Verified at**: 2026-09-25, branch `fix/macos-sourceframe-crash` (master 76528631 + fix)
- **Standard**: `.specify/extensions/tdd/templates/tdd-test-quality-rubric.md`
- **Verdict**: **PASS_WITH_GAPS** — test-first evidence is real and the test demonstrably fails on the defective tree, but the audit was not independent (same session) and the on-device crash repro is outside CI's reach.

## Verdict paragraph

Three source-contract tests pin the crash class (no `.sourceFrame` dot access),
the safe mechanism (KVC accessor), and the wiring (both call sites). RED was
observed against the genuinely defective tree before the fix existed and is
recorded verbatim in the cycle log; the same tests are green after the smallest
sufficient change, with the 48-test baseline intact and a compile proof for the
changed Swift. Gaps are named below and are environment-inherent, not
discipline failures.

## Test-first evidence

| Behavior | Classification | Evidence |
|----------|----------------|----------|
| A1 (AC1) | PROVEN | cycle log records the real red output (violation list) produced before any implementation existed; the same scan is green post-fix |
| A2 (AC2) | PROVEN | red: `Expected: <1> / Actual: <0>`; green post-fix |
| A3 (AC2/AC3) | PROVEN | red: `Expected: <2> / Actual: <0>`; green post-fix |
| A4 (AC4) | PROVEN | example macOS build exit 0 pre-fix and post-fix |
| A5 (AC5) | PROVEN | suite 48/48 baseline → 51/51 post-fix; analyze clean |

Git-history caveat: the fix lands as a single commit, so ordering is proven by
the cycle log (recorded failure output), not by commit granularity — per rubric
this alone would be LIKELY; the recorded pre-implementation red run against the
real defect upgrades it to PROVEN with the caveat recorded.

## Existing-test audit

Diff review: no existing assertion weakened, removed, skipped, or filtered; the
48 baseline tests all still pass. No coverage/threshold config touched.

## Smell pass

- Assertions are specific (violation lists, exact counts with reasons), state-
  based, deterministic, host-independent (no Xcode required).
- The stripper is ported verbatim from the iOS package's shipped test — same
  idiom, no second invented utility.
- Not independent: the audit was performed by the same session that wrote the
  tests. The files were re-read cold; no fresh-context subagent was used.
- Minor (LOW): AC3 pins exactly 2 call sites; a future third legitimate
  consumer of `sourceFrameMap()` will need to update the count. Deliberate —
  the pin is what makes the wiring regress-visible.

## Test strength (mutation)

No mutation tool in the profile. Deliberate-mutant sampling: the **natural
mutant** — the actual pre-fix tree with the defect present — was used as the
mutant, and all three tests failed against it (stronger than a synthetic
mutant: the real reported defect is what they catch). Re-introducing any single
`.sourceFrame` dot access re-fails AC1 by construction of the scan. Behaviors
sampled: 1/1 (the defect itself). Coverage: not run (no coverage command in the
profile for this package).

## Traceability

| AC | Behaviors | Tests |
|----|-----------|-------|
| AC1 | A1 | swift_sourceframe_kvc_test › AC1 |
| AC2 | A2, A3 | › AC2, AC3 |
| AC3 | A3 (+ accessor shape pinned in test-list A3) | › AC3 + compile |
| AC4 | A4 | example `flutter build macos --debug` |
| AC5 | A5 | full suite + analyze |

Real-entry-point check: the true entry point (WebCore handing a nil frame on
macOS 15.1) cannot be exercised in CI — recorded as the spec's environment
boundary since planning; the source contract is the strongest host-executable
proxy, matching the #316/#328 precedent.

## What was not audited

- Runtime behavior on an actual macOS 15.1 device/simulator (nil-frame crash
  repro) — not executable in this environment.
- iOS package (`Types/WKNavigationAction.swift`) — explicitly out of scope.
- Mutation tooling and coverage tooling — absent from the stack profile.
- The audit's independence (same-session audit; smell pass not delegated).
