# TDD Verification — 338-macos-contentblockers-never-applied

- **verified_at**: `af06268a` (test-first commit) + working tree to be committed
  as the fix commit on
  `fix/338-macos-inappwebviewsettings-contentblockers-is-decoded-but-ne`
- **standard**: `.specify/extensions/tdd/templates/tdd-test-quality-rubric.md`
  (resolved: extension copy; no overrides/presets present)
- **feature dir**: `.specify/bugs/338-macos-contentblockers-never-applied/`
  (bug workflow dir; resolved via `SPECIFY_FEATURE_DIRECTORY` +
  `check-prerequisites.sh --json --paths-only`; `.specify/feature.json`
  deliberately NOT flipped — it tracks in-flight work on master)
- **spec.md**: absent — bug workflow stores the spec as `issue.md`; the
  acceptance criteria live in `tdd/test-list.md` (4 ACs) and the audit graded
  against those
- **environment**: Linux x86_64 (Debian 13), Flutter 3.47.5 / Dart 3.13.4
  (Linux host). **No macOS SDK, no Xcode, no WebKit, no FlutterMacOS, no Swift
  toolchain** (Swift Linux tarball would exhaust this host's disk budget).
- **audit independence**: NOT independent — the same session that wrote the
  fix wrote this report. Fail-closed applies throughout; all files re-read
  cold during the audit.

## Verdict: PASS_WITH_GAPS

The decoded-but-never-consumed state issue #338 reports is fixed: macOS
`InAppWebView.setSettings` now mirrors the iOS `setSettings` branch one-to-one
(removeAllContentRuleLists → JSONSerialization →
`WKContentRuleListStore.default().compileContentRuleList(forIdentifier:
"ContentBlockingRules")` → add in the completion handler, `count > 0` guard),
the red→green was executed at the runnable gate (red `+2 -5` recorded at
`af06268a` BEFORE the fix existed — proven by commit order and by
`git show af06268a:<InAppWebView.swift>` containing zero
`compileContentRuleList` references — and green `+7` after), and both
deliberate mutants were caught. The remaining gaps are environmental, not
evidential: the real macOS compile gate (`flutter build macos`, B12) and the
runtime blocking observation (B13) were **not executed** — macOS-only, with
exact commands recorded in cycle-log C5.

## Test-first evidence

| Behavior | Class | Evidence |
| --- | --- | --- |
| B1 (setSettings consumes the key) | PROVEN | red C1 recorded pre-fix; commit `af06268a` orders the failing test before the fix commit; red state independently verifiable from that commit's tree |
| B2 (stale lists cleared) | PROVEN | same red→green ordering |
| B3 (serialize + compile via WKContentRuleListStore, shared identifier) | PROVEN | same red→green ordering |
| B4 (compiled list added in completion handler) | PROVEN | same red→green ordering; M2 proves the assertion bites |
| B5 (empty list clears, skips compiling) | PROVEN | same red→green ordering |
| B6 (iOS parity target intact) | PROVEN | gate green before and after; guards the reference branch |
| B7 (setting still declared) | PROVEN | gate green before and after; prevents satisfying the scan by deleting the declaration |
| B8 (diff confinement) | PROVEN | `git status --porcelain`: 1 modified Swift file (+33/−0), 1 new test file, bug records only; `example/pubspec.lock` pub side effect reverted |
| B9 (formatting/whitespace) | PROVEN | `git diff --check` clean; new test file `dart format`-clean and idempotent; package-wide `--set-exit-if-changed` hits ONLY pre-existing master drift (`test/swift_sourceframe_kvc_test.dart`, verified on the clean tree in C0, deliberately untouched) |
| B10 (macos analyze unchanged) | PROVEN | 0 findings pre vs 0 post |
| B11 (suites unchanged + new tests) | PROVEN | macOS 51/0 → 58/0 (+7); umbrella 23 analyze issues and 250/0 identical pre/post |
| B12 (flutter build macos) | NO_TEST (environmental) | macOS-only; NOT_EXECUTED, exact command in C5 |
| B13 (runtime blocking on macOS) | NO_TEST (environmental) | macOS-only; NOT_EXECUTED, issue repro snippet in C5 |
| B14 (mutant strength) | PROVEN | M1 CAUGHT (+2 -5), M2 CAUGHT (+6 -1); restore exact after each, green re-verified |

No pre-existing test was weakened, skipped, renamed, or excluded: the fix diff
touches only the Swift source (+33/−0); no test file other than the new one
changed. No `TEST_AFTER` behavior among the runnable gates.

## Findings

| # | Severity | Finding | Evidence |
| --- | --- | --- | --- |
| 1 | LOW | The parity gate asserts native-source structure (regex over the Swift source), not compiled or runtime behavior — necessary on a Linux host and the established house gate for native parity bugs (precedents: `swift_sourceframe_kvc_test.dart`, `user_script_initializer_parity_test.dart`); compensated by M1/M2 mutant proof and by the verbatim structural mirror of the compiling iOS branch; replace/supplement with `flutter build macos` in CI when a macOS runner exists | `test/content_blockers_parity_test.dart` (whole file) |
| 2 | LOW | The iOS cross-check reads the sibling package via a relative path (`../zikzak_inappwebview_ios/...`), so the gate requires the monorepo checkout layout; acceptable here (monorepo is the distribution source of truth) but worth a skip-with-reason if tests ever run in a standalone package checkout | `test/content_blockers_parity_test.dart:180-184` |
| 3 | LOW | One test-bug during the cycle: the serialization assertion used a literal `contains` against the whitespace-collapsed view, mismatching the source's line break inside the call; repaired in C2 with a whitespace-tolerant regex, assertions' intent unchanged; the recorded red did not depend on the defect | `test/content_blockers_parity_test.dart:315-323` |

No `HIGH` smells. No tautological, vacuous, or doubled-subject assertions —
each test pins one structural property with a `reason:` tied to the bug.
Style matches the suite it joins (source-scan gates with the ported
`stripSwiftNonCode` scanner). Deterministic (pure file reads), fast (~45 s,
dominated by one kernel compile), refactor-insensitive (white-space-tolerant
extraction).

## Mutation results

No mutation tool in the profile (`mutation: null`). Deliberate mutants, one at
a time, on the changed file (sample = 2 of 2 mutation-relevant behaviors;
small sample by design, not exhaustive):

| Mutant | Behavior | Survived | Judgment |
| --- | --- | --- | --- |
| M1: delete the entire contentBlockers branch | B1–B5 | No | CAUGHT — the five macOS behavior gates red (+2 -5) |
| M2: drop `configuration.userContentController.add(contentRuleList!)` from the completion handler | B4 | No | CAUGHT — exactly the "adds the compiled list" gate red (+6 -1) |

Both mutants restored exactly from a pre-mutation copy (`git diff --stat`
back to `+33`); parity suite green after restore (`00:44 +7: All tests
passed!`). Coverage tooling not used as corroboration: `flutter test
--coverage` measures Dart code, and the gate under audit scans Swift source —
coverage of the scanner is not evidence about the fix.

## Traceability

| Criterion | Tests / Gates | End to end |
| --- | --- | --- |
| AC1 (macOS consumes contentBlockers like the iOS branch) | B1–B7 (parity gate), B14 (mutants) | compile/runtime level is B12/B13 (macOS-only, NOT_EXECUTED) |
| AC2 (requests actually blocked at runtime on macOS) | B13 (macOS-only, NOT_EXECUTED); B3/B4 statically pin the mechanism WebKit applies pre-request | No (environmental gap, honestly recorded) |
| AC3 (macOS-only change, zero formatting diffs) | B8, B9 | Yes (repo-level gates) |
| AC4 (no regression vs baseline) | B10, B11 | Yes (baseline-compare gates) |

Criteria with no test at any level: none. Tests tracing to nothing: none.

## What was not audited

- **macOS compile + runtime**: `flutter build macos` (B12) and the runtime
  blocking observation (B13) were not executed — impossible on this Linux
  host. These are the deliverable's final proof and must run on a macOS
  host/CI.
- **Mutation testing**: no tool configured in the profile; strength was
  sampled via 2 deliberate mutants, not measured exhaustively.
- **Swift toolchain gates**: no `swiftc` parse/type pass was run (no Swift
  toolchain on this host; unlike the 317 audit which shipped one).
- **Other platform packages** (android/ios/windows/linux/web/platform
  interface/module): untouched by the diff (B8) and not audited further.
- **tasks.md**: the bug workflow dir has no tasks.md (there is no task
  lifecycle to append remediation tasks to); findings are recorded above
  instead — equivalent to running the audit with `--no-tasks`.
