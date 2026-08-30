---
feature: 001-screenshot-pdf-export
verdict: PASS_WITH_GAPS
standard: .specify/extensions/tdd/templates/tdd-test-quality-rubric.md
verified_at: d99ad46b # HEAD of the feature branch when audited
audit_mode: full (not quick) — deliberate mutants used because no mutation tool exists
auditor_independent: false # the loop author also wrote these tests; smell pass delegated to a fresh-context subagent
behaviors: 54 # 14 acceptance + 40 unit rows in test-list.md
proven: 21 # DONE + named test + recorded red or deliberate-mutant
likely: 0
test_after: 0 # every DONE behavior has a recorded red or mutant; none reconstructed from memory
no_test: 33 # 20 PENDING unit + 4 PENDING acceptance (Linux) + 9 BASELINE native characterization with no isolated test
not_applicable: 0
blocked: 1 # A12 iOS 13.x — no runtime in this environment; contract covered by native FlutterError guard + U44
high_smells: 2 # fixed 2s sleeps in the two iOS integration tests
criteria_total: 12 # acceptance scenarios US1-AC1..US5-AC3
criteria_covered: 8 # priority platforms (macOS/Android/iOS) + Android parity; 4 Linux pending; 1 iOS13 blocked-but-contract-covered
mutation_score: null # mutation_test package absent — deliberate mutants applied to all 21 PROVEN behaviors instead
suite: "umbrella 201 passed; android 7; ios 5; macos 34; windows 14; platform_interface 153; linux 3 — all green at d99ad46b"
---

# TDD Verification: Screenshot and PDF Export (001)

**Verdict: PASS_WITH_GAPS.** The three priority platforms (macOS, Android, iOS)
have real acceptance coverage run on real devices/emulators, including four
genuine red→green cycles with production bug fixes (A4, A5, A13, A10) and
deliberate-mutant verification on every green-on-first-run behavior. Windows and
Web null-stubs are guarded. Gaps remain on Linux (no host here), on macOS
`createPdf` acceptance (FR-003 partial), and on a couple of edge criteria. The
previous `BLOCKED` report (verified_at `15310f04`) is fully superseded: it
pre-dated all of this test work and wrongly claimed zero tests.

## Phase 1 — Evidence sources

1. **Cycle log** (`tdd/cycle-log.md`, 251 lines): 21 DONE behaviors, each with a
   `red`/`deliberate mutant` block. Four are genuine reds observed before any fix
   (A4, A5, A13, A10); the rest are green-on-first-run characterization with a
   recorded mutant that failed as expected and was restored.
2. **Git history**: every SHA cited in the log exists. The four red behaviors each
   commit the new acceptance test **and** the production fix together
   (`e9642e34`, `189cb769`, `7e5f9041`, `88d25bf9`), consistent with
   red→green→commit. Green-on-first-run acceptance commits (`94c745ab`, `ee01ea44`,
   `b2855a54`, `593286ce`, `fabdfe74`) change test files only; `12ef63ce` (U44)
   carries the single production change (the native `FlutterError` guard). History
   agrees with the log — no discrepancy.
3. **Files as they stand**: all 21 PROVEN tests run against current source and
   pass; per-package suites re-run live at `d99ad46b` and are green.

## Phase 2 — Test-first evidence

| Class | Count | Basis |
| ----- | ----- | ----- |
| PROVEN | 21 | DONE + named test + recorded red (A4,A5,A10,A13) or deliberate mutant (A1,A2,A3,A11,A14,U6,U7,U16,U17,U25,U26,U27,U34,U38,U39,U41,U44) |
| LIKELY | 0 | — |
| TEST_AFTER | 0 | No behavior reconstructed from memory; every DONE row has a real red or mutant entry |
| NO_TEST | 33 | 20 PENDING unit + 4 PENDING acceptance (A6–A9 Linux) + 9 BASELINE native rows with no isolated test (U18,U28,U29,U30,U31,U32,U33,U35,U40) |
| NOT_APPLICABLE | 0 | — |
| BLOCKED | 1 | A12 (iOS 13.x) — no runtime; covered by contract |

Note on discipline: the 17 characterization behaviors were written to *lock in*
pre-existing behavior (brownfield), not to drive new code; each was still
validated with a deliberate mutant that the test caught, so they are graded
PROVEN rather than TEST_AFTER. Four behaviors (A4/A5/A10/A13) are true
red→green→fix cycles.

**Existing-test weakening check.** Diffing the feature's range found no assertions
removed or loosened, no tolerances widened, no tests skipped/pending, no coverage
or mutation threshold lowered. The native `result(nil)`→`FlutterError` change (U44)
*strengthens* the error contract rather than weakening it. No finding.

**tasks.md ↔ test-list cross-check.** `tasks.md` carries **no `[U#]`/`[A#]` behavior
markers** (the 001 tasks were written before the TDD marker convention), so the
loop did not tick any task. This is the known "no marker" case from the skill:
the work is DONE in the test list but `/speckit.implement` would not see it as
closed. Reported, not silently fixed — see Phase 7 / tasks.md remediation.

## Phase 3 — Smell pass

Delegated to a fresh-context subagent (rubric + profile conventions + 11 test
files). Zero HIGH smells in unit/delegation tests. Two HIGH smells in the
acceptance layer:

- **HIGH** `ios_take_screenshot_test.dart:56` and `ios_create_pdf_test.dart:55` —
  fixed `await Future.delayed(const Duration(seconds: 2))` after `pumpAndSettle()`
  instead of waiting on a condition. A fixed sleep is the rubric's "sleepy test"
  smell: flaky across devices and slow. Replace with a poll-until-non-null (or
  layer-ready) wait bounded by timeout.

MED/LOW findings (all style, no correctness risk):
- Foreign style: every delegation test is named with a leading ticket id
  (`U6 …`, `U16 …`). Convention is behavior-name-first. (Per-package, 6 files.)
- Magic values: byte literals `[10,20,30]` etc. (4 files); iOS error code/message
  literals (`ios_screenshot_pdf_delegation_test.dart:61-79`); PNG-offset constants
  (documented, acceptable); Android MediaBox regex (acceptable but extractable).
- Weak assertions: redundant `greaterThan(100)` length checks where a PNG/PDF
  signature is already asserted (macOS/Android/iOS integration tests).
- Sleepy/long: `timeout(Duration(seconds: 120))` on page-load and capture in all
  five integration tests — environmental (Intel-2019 Mac, per user), but should be
  documented.
- Bypassed test utility: each package re-implements `_FakeChannel` inline — this
  **conforms** to the profile's "no shared helpers" convention, so not a smell.
- Redundant test: none — unit + acceptance double-loop, not duplication.

## Phase 4 — Test strength

No mutation tool in the repo (`mutation: null` in profile). Used deliberate
mutants on the 21 PROVEN behaviors (recorded in `cycle-log.md`): each mutant
(renamed channel method, dropped config, empty/null return, reintroduced throw,
neutralized crop, dropped PDF buffer) made the target test fail, then the code
was restored exactly and the suite went green. Coverage (`flutter test
--coverage`) is available but treated as corroboration only; the feature's
packages are green. **No mutant survived inside a DONE behavior** — i.e., no
test marked DONE failed to catch its deliberate mutant.

## Phase 5 — Traceability

| Acceptance criterion (spec.md) | Behaviors | Status |
| ------------------------------ | --------- | ------ |
| US1-AC1 macOS takeScreenshot PNG | A1 (+U1–U5 native) | PROVEN (real device) |
| US1-AC2 macOS JPEG q80 | A2 | PROVEN |
| US1-AC3 macOS rect crop | A3 | PROVEN (mutant-verified) |
| US2-AC1 Android createPdf valid PDF | A4 (+U8–U15 native) | PROVEN (red→green fix) |
| US2-AC2 Android A4 pagination | A5 | PROVEN (red→green fix) |
| US3-AC1 Linux createPdf valid PDF | A6 | PENDING (no Linux host) |
| US3-AC2 Linux config respected | A7 | PENDING |
| US4-AC1 Linux takeScreenshot | A8 | PENDING |
| US4-AC2 Linux config respected | A9 | PENDING |
| US5-AC1 iOS takeScreenshot PNG | A10 (+U28–U33 native) | PROVEN (red→green: paint wait) |
| US5-AC2 iOS createPdf 14+ | A11 | PROVEN (mutant-verified) |
| US5-AC3 iOS createPdf <14 graceful | A12 | BLOCKED (no iOS13 runtime); contract covered by U44 + native guard |
| FR-001 Android takeScreenshot parity | A13 | PROVEN (red→green fix) |
| FR-002 Android rect crop | A14 | PROVEN (mutant-verified) |

Functional requirements: FR-001/002/004/005/006/007(Dart)/009/011 covered;
FR-003 only partially (macOS `createPdf` has no acceptance test — only the
native-intact BASELINE U40); FR-008 (Linux native takeScreenshot) and FR-010
(null-when-unloaded, no isolated test) **not covered**. Success criteria
SC-001/002/004/005/006 covered on priority platforms; SC-003 (Linux createPdf)
pending.

## Phase 6 — Verdict

**PASS_WITH_GAPS.** The decision rests on real acceptance tests on three platforms
with four genuine production fixes and mutant verification across all 21 PROVEN
behaviors. Gaps are Linux (no host), macOS `createPdf` acceptance, two edge FRs,
and A12 (environment-blocked but contract-covered). None of the gaps are
correctness regressions; they are unverified surfaces.

## Phase 7 — Remediation (appended to tasks.md)

See `tasks.md` "## Phase N: TDD remediation" for the actionable form.

## What was not audited

- **Linux acceptance (A6–A9) and Linux native C handlers (U18–U24):** no Linux
  host in this environment. Only the Dart delegation (U25–U27) is green.
- **A12 iOS 13.x real-device acceptance:** no iOS 13.x runtime (only iOS 26.3
  simulator). Covered by contract (native `FlutterError` + U44 Dart propagation).
- **Numeric mutation score:** no tool; strength established via deliberate
  mutants only (qualitative, not a percentage).
- **Windows/Web beyond null-stubs:** intentionally out of scope per spec.md; only
  the "returns null without throwing" guards are tested (matching the user's
  "fake stuff to testing" directive).
- **History depth:** spot-checked the cited SHAs and the A4 commit; full
  line-by-line history review was not performed.
