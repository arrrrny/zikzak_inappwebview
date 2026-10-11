# TDD Verification — flutter347-platformview-rendering (bug #331)

- **Slug**: flutter347-platformview-rendering
- **Verified at**: 2026-09-25, branch `fix/flutter347-platformview-clipping` (master `54464edf`)
- **Standard**: `.specify/extensions/tdd/templates/tdd-test-quality-rubric.md`
- **Verdict**: **PASS_WITH_GAPS** — the shippable contract (AC2) has real red→green evidence and the matrix (AC1) is genuine on-device evidence; the audit was not independent and the artifact's actual repair is outside this repo.

## Verdict paragraph

The clipping contract test failed against the unmodified sources and passes
after the one-line hardening; the 12-test baseline is intact; analyze is at the
exact pre-existing info baseline. The on-device matrix runs are documented with
captured frames and device/build identifiers. The named gaps are
environment-inherent (engine-side defect, shared build host) and are disclosed
rather than papered over.

## Test-first evidence

| Behavior | Classification | Evidence |
|----------|----------------|----------|
| A2 (clipping contract) | PROVEN | recorded RED before the Swift change; GREEN after; 13/13 |
| A1 (mitigation matrix) | NOT_APPLICABLE (evidence run, not a code behavior) | 5 rows executed on-device, frames captured per row |
| A3 (no regression) | PROVEN | suite 12→13/13; analyze delta = 0 |
| A4 (honest disposition) | PROVEN | fix.md/test.md state the artifact is unfixed; PR uses `Related`, not `Closes` |

Git-history caveat: single-commit landing, ordering proven by the cycle log.

## Existing-test audit

No existing assertion weakened, removed, skipped, or filtered. Suite delta is
exactly +1 (the new contract test).

## Smell pass

- The contract test asserts a specific, non-tautological property with a
  line-comment-stripped source scan; failure reasons name the defect class.
- Not independent: same-session audit; re-read cold; no fresh-context subagent.
- LOW: the contract pins presence, not position, of `clipsToBounds = true`
  (position is behaviorally irrelevant; a regression would be its removal).

## Test strength (mutation)

Natural-mutant sampling: reverting the Swift line (the exact mutant the test
targets) reproduces the recorded RED. No mutation tooling in the profile.
Coverage: not run (no coverage command in this package's profile).

## Traceability

| AC | Behaviors | Evidence |
|----|-----------|----------|
| AC1 | A1 | cycle-log cycle 2 + ev_*.png |
| AC2 | A2 | swift_platform_view_clipping_test.dart |
| AC3 | A3 | suite + analyze outputs |
| AC4 | A4 | fix.md, test.md, PR body |

## What was not audited

- On-device verification that the shipped hardening causes no rendering change
  in healthy scenarios beyond the A/B frames already captured (same host as the
  matrix — the hardening frame was itself captured on-device and rendered
  normally inside its bounds).
- macOS embedding; engine repair; CI `build-ios` compile of this branch
  (triggered on push; local build was disk-constrained).
- Audit independence (same-session).
