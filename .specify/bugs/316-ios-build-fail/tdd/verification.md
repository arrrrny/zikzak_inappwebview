# TDD Verification — Bug #316 (ios-build-fail)

```yaml
verified_at: fix/316-ios-build-fail (base 0c51cce, pre-PR)
standard: .specify/extensions/tdd/templates/tdd-test-quality-rubric.md (resolved
  through the extension stack; no overrides/presets present)
profile: .specify/memory/tdd-profile.md (flutter stack, cwd zikzak_inappwebview_ios)
behaviors_total: 5 (B1–B5)
proven: 2
test_after: 0
no_test: 0
not_applicable: 3 (B3 by-construction+indirect, B4 audit, B5 suite gate)
high_smells: 0
criteria_covered: 5/5 (AC1–AC5) at the levels defined in spec.md's Environment
  Boundary; 2/5 (AC1, AC3) with executable automated evidence, 2/5 (AC2, AC4)
  by documented construction/audit, 1/5 (AC5) by suite runs
mutation: unmeasured (mutation tool absent per profile: `mutation: null`);
  deliberate-mutant equivalent provided by the RED runs themselves (the pre-fix
  tree IS the mutant; both contract tests catch it)
independence: NOT independent — the same session wrote the tests and this audit
verdict: PASS_WITH_GAPS
```

## Verdict

**PASS_WITH_GAPS** — the red→green cycle is real and reproduced at the exact
compiler stage that fails in issue #316 (Swift parser) plus executable Dart
source-contract tests that catch both bug classes, but the full Swift type-check /
Xcode build and mutation scoring could not run on this Linux host, so AC1/AC3's
compile-level proof is parse-level and test strength is unmeasured.

## Test-first evidence

| Behavior | Class | Evidence |
| --- | --- | --- |
| B1 (AC1 — no boolean-operand availability) | PROVEN | RED: `swiftc -parse` reproduces the exact `887:76` diagnostic (`tdd/red-swiftparse.txt`); Dart contract fails pre-fix (`+0 -2`, flags line 887, predecessor `!`, successor `)`). GREEN: full-tree parse CLEAN (139/139, `tdd/green-swiftparse.txt`); contract passes in the 11/11 suite run. History shows tests and fix in one commit — ordering is proven by the stashed-fix RED run recorded here and in `tdd/cycle-log.md`, not by commit archaeology. |
| B2 (AC3 — SPM floor ≤ 15.0) | PROVEN | RED: contract test fails pre-fix (`iOS platform minimum 16.0 exceeds 15.0`). GREEN: passes post-fix. The SPM-resolution manifestation is the issue #316 report itself; SPM does not run on Linux. |
| B3 (AC2 — data-store truth table) | NOT_APPLICABLE (by construction + indirect) | Truth-table equivalence documented line-by-line in `fix.md`; regression of the folded form is barred by B1's scan. No direct executable test of Swift runtime selection exists on this host. |
| B4 (AC4 — no unguarded modern API) | NOT_APPLICABLE (audit) | Guard audit recorded in `fix.md` (all 15/15.4/16/16.4/17 touchpoints with file:line). |
| B5 (AC5 — gates green) | NOT_APPLICABLE (suite gate) | iOS package 11/11; umbrella 245/2 with both failures proven pre-existing on pristine `master` via clean worktree; analyze clean on changed files; `git diff --check` clean. |

## Existing-test integrity

No existing test was modified, renamed, skipped, filtered, or loosened. The full
iOS package suite (including 9 pre-existing tests) passes unchanged. The umbrella
suite shows the same 2 failures before and after the change (master worktree
verification) — no regression introduced, no gate weakened.

## Findings

1. **MEDIUM — compile-level proof stops at parse.** `swiftc -parse` validates
   syntax (the failing stage of issue #316's error 2) but not name/type
   resolution; a full `swift build` on macOS could theoretically surface a
   different defect. Mitigated by: the diff is small, semantically equivalent,
   and mirrors an already-guarded pattern used elsewhere in the same file.
2. **LOW — test strength unmeasured.** No mutation tool for this stack
   (profile: `mutation: null`). The RED runs serve as one deliberate mutant per
   bug class, which is weaker than a scored mutation run.
3. **LOW — audit not independent.** Author of the fix and of this report is the
   same session; the verify protocol prefers a fresh-context smell pass. The
   smell catalogue was applied to the two new contract tests: no tautological or
   vacuous assertions found (both tests demonstrably fail on the pre-fix tree);
   helpers/profile conventions followed (flutter_test, package cwd).

## Traceability

| Acceptance criterion | Behaviors / tests | Status |
| --- | --- | --- |
| AC1 valid availability grammar | B1 — `test/swift_availability_usage_test.dart` + `swiftc -parse` | tested (parse level) |
| AC2 preserved truth table | B3 — construction proof in `fix.md` + B1 scan | documented (no runtime test on this host) |
| AC3 platform floor ≤ 15.0 | B2 — `test/ios_package_platform_test.dart` | tested |
| AC4 no unguarded modern API | B4 — guard audit in `fix.md` | audited |
| AC5 gates green, no formatting diffs | B5 — analyze/test/diff runs | tested (real counts in cycle-log) |

## What was not audited / not run

- Full Swift type-check and `swift build` (needs macOS + Apple SDK).
- `flutter build ios` end-to-end against an iOS 15.0 app target — the literal
  reproduction steps of issue #316 (needs macOS + Xcode); commands recorded in
  `tdd/cycle-log.md` for a reviewer with the toolchain.
- Runtime/device verification of data-store selection semantics (AC2) and of
  package behavior on iOS 15.0–15.x devices.
- Mutation scoring (no tool in profile); the deliberate-mutant evidence is the
  RED run itself.
- Other packages in the monorepo (android/macos/windows/linux/web/platform-
  interface/module) beyond the two suites the fix workflow runs by contract.
