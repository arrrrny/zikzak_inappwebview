# TDD Verification — flutter347-platformview-rendering (bug #331)

- **Slug**: flutter347-platformview-rendering
- **Verified at**: 2026-10-26T21:34Z (authoring host local time 2026-10-27, UTC+3), branch `fix/331-flutter-version-upgrade-from-3-44-x-to-3-47-2-causes-renderi` @ `e1c1a555` (forklift chore session, fresh run; the docs change this report audits landed as commit `17426183`, 2026-10-26T21:34Z)
- **Standard**: `.specify/extensions/tdd/templates/tdd-test-quality-rubric.md` (resolved: extension's own copy; no overrides/presets present)
- **Feature dir**: `.specify/bugs/flutter347-platformview-rendering` (resolved via `SPECIFY_FEATURE_DIRECTORY` + `check-prerequisites.sh --json --paths-only`; `.specify/feature.json` currently points at the 339 bug and was deliberately not used)
- **Verdict**: **PASS_WITH_GAPS** — all four acceptance criteria remain covered with real committed evidence, every suite in the repo that owns the #331 surface is green in this session (iOS 77/77, umbrella 269/269), and this session's change is docs-only; the gaps are the environment-inherent ones: the on-device matrix is not re-runnable on this Linux host, mutation strength was not re-measured this session, and the audit is not independent (same-session).

## Verdict paragraph

The original cycle (2026-09-25, PR #336, master `acf3a51c`) proved AC2 with a
recorded RED→GREEN and AC1 with five on-device rows and captured frames; that
evidence is committed in this feature directory and was re-read cold for this
audit. This session re-ran the full suites that own the #331 surface and added
the issue's final deliverable: user-facing workaround documentation (docs-only,
the canonical block in the package README plus a pointer from the root README)
that states explicitly that the artifact itself is an engine-side regression
(flutter/flutter#193363, still open) that no plugin-side change fixes. #331 stays
**open** with the `upstream` label and the PR links it with `Related to`, which
keeps AC4 ("the PR must not claim to close the issue") intact. No code behaviour
was touched in this session, so no new tests were owed; the contract test and
both package suites are green against the documentation state.

## Session evidence (this run, real commands)

| Command (cwd) | Result |
|---------------|--------|
| `flutter test --concurrency=2` in `zikzak_inappwebview_ios` | **77/77 passed**, ~64 s wall |
| `flutter test --concurrency=2` in `zikzak_inappwebview` | **269/269 passed**, ~20 s wall |
| `dart analyze` in `zikzak_inappwebview_ios` | 192 issues — exact pre-existing all-info baseline, 0 new, 0 warnings |
| `dart analyze` in `zikzak_inappwebview` | 23 issues (infos only) |
| `dart format .` in both packages | 9 pre-existing dart files would be re-formatted by Dart 3.13.7 (formatter drift vs the SDK the repo was formatted with) — reverted; none of the files are touched by this chore |
| `git diff --name-only HEAD -- '*.dart'` | empty (docs-only change) |

## Test-first evidence

| Behavior | Class | Evidence (re-checked this session) |
|----------|-------|------------------------------------|
| A1 (mitigation matrix, AC1) | NOT_APPLICABLE (evidence run, not a code behavior) | 5 rows executed on-device 2026-09-25 with captured frames (`ev_*.png`, `zkw331_*.png` committed); cycle-log cycle 2. Not re-runnable on this Linux host — see "What was not audited" |
| A2 (clipping contract, AC2) | PROVEN | RED recorded before the Swift change in cycle-log cycle 1; single-commit landing `acf3a51c` carries test+source together (order corroborated by the log); test re-run green this session inside the 77/77 |
| A3 (no regression, AC3) | PROVEN | 2026-09-25: 13/13, 192-info baseline; this session: 77/77 (suite grew since with unrelated #371 lifecycle tests), analyze delta still 0 |
| A4 (honest disposition, AC4) | PROVEN | fix.md/assessment.md state the artifact is not fixed plugin-side; investigation PR #336 used `Related`, not `Closes`. This session keeps that posture: the PR body says `Related to #331`, #331 stays OPEN with the `upstream` label, and both READMEs claim no behaviour change — AC4 as written is satisfied, not argued around |

Existing-test audit: no assertion weakened, removed, skipped or filtered by
either the 2026-09-25 cycle (re-checked from `acf3a51c` diff) or this session's
docs-only change (touches no dart file).

## Findings

| # | Severity | Finding | Evidence |
|---|----------|---------|----------|
| 1 | LOW | Repo-wide Dart formatter drift: `dart format .` under Dart 3.13.7 re-formats 9 pre-existing test/example files. Pre-existing, unrelated to this feature; reverted here to keep the chore diff scoped | `git status -- '*.dart'` after format: 9 files, none touched by this branch |
| 2 | LOW | A2 contract test pins presence, not position, of `clipsToBounds = true` on the root view (position is behaviourally irrelevant; a regression would be its removal — carried over from the previous report, unchanged) | `zikzak_inappwebview_ios/test/swift_platform_view_clipping_test.dart:67-80` |

No HIGH smells. No remediation tasks appended: both findings are LOW and
pre-existing/informational; neither blocks this disposition.

## Test strength (mutation)

- No mutation tool in the stack profile (`mutation: null`). The 2026-09-25 cycle
  used natural-mutant sampling (reverting the exact Swift line reproduces the
  recorded RED). This session did not re-run mutants: the Swift source is
  unchanged on this branch (docs-only), so the sampling result from the original
  cycle stands; strength is therefore **unmeasured for this session** and the
  verdict reflects it.
- Coverage: not run (no coverage command exercised for these packages this
  session; profile lists `flutter test --coverage` for the umbrella).

## Traceability

| AC | Behaviors | Evidence |
|----|-----------|----------|
| AC1 | A1 | cycle-log cycle 2 + committed `ev_*.png` frames + `fix.md` § *Mitigation matrix* (mirrored in `test.md`) |
| AC2 | A2 | `swift_platform_view_clipping_test.dart` (green in this session's 77/77); source pins at `InAppWebView.swift:179,582`, `FlutterWebViewController.swift:24` |
| AC3 | A3 | this session's suite + analyze table above |
| AC4 | A4 | fix.md § Deviations + this session's PR body (`Related to #331`, issue left open, no behaviour claim) |

Untested criteria: none. Tests tracing to nothing: none.

## What was not audited

- The on-device artifact itself: this Linux host has no iOS simulator/macOS
  toolchain; the mitigation matrix (AC1) stands on the committed 2026-09-25
  evidence and was not re-executed.
- Mutation/deliberate mutants were not re-run this session (no mutation tool in
  the profile; Swift source unchanged by this branch).
- macOS embedding, engine-side repair (upstream flutter/flutter#193363), and CI
  `build-ios` compile of this branch (no dart/objc change on this branch;
  CI coverage applies on push).
- Audit independence: same-session audit, files re-read cold, no fresh-context
  subagent available.
