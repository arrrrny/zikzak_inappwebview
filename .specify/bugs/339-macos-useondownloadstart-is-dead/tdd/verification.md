---
feature: 339-macos-useondownloadstart-is-dead
verdict: PASS_WITH_GAPS
standard: .specify/extensions/tdd/templates/tdd-test-quality-rubric.md # rubric graded against (resolved: extension copy; no overrides/presets present)
verified_at: fbc30418 # short SHA audited (test-first commit; fix sources verified in the working tree on top of it)
behaviors: 12
proven: 11
likely: 0
test_after: 0
no_test: 1 # B11 — macOS runtime end-to-end, not executable on this host
high_smells: 0
criteria_total: 8
criteria_covered: 8
mutation_score: 4/4 # scope: deliberate mutants on the changed files (B2, B4, B5, B7); no mutation tool in the profile
mutants_survived: 0 # M2 initially survived and drove a test strengthening BEFORE the fix commit; re-proved caught
suite: 58 passed, 0 failed (macos pkg, 11s); 7/7 parity test; umbrella 250 passed, 0 failed (isolation signal)
---

# TDD Verification — 339-macos-useondownloadstart-is-dead

**Verdict: PASS_WITH_GAPS.** Every runnable behavior is PROVEN with an observed
red (0 passed / 7 failed at the test-only commit) and an observed green (7/7;
full suite 58/58; analyze clean; Swift parse gate clean), and all four
deliberate mutants were caught — but the click-level end-to-end macOS runtime
gate (B11) was **not executed** because no macOS toolchain exists on this host,
so the top-line `PASS` conditions cannot honestly be met.

- **audit independence**: NOT independent — the same session that wrote the fix
  wrote this report (Hard Rule 2 disclosure). Every file was re-read as it
  stands; the mutation pass is the cold-context substitute.
- **feature dir**: `.specify/bugs/339-macos-useondownloadstart-is-dead/`
  (resolved by `.specify/scripts/bash/check-prerequisites.sh --json --paths-only`
  from `.specify/feature.json`; `FEATURE_DIR` = the bug workflow dir per repo
  convention for bug fixes).
- **environment**: Linux x86_64 (Debian 13), Flutter 3.47.5 / Dart 3.13.4,
  Swift 6.1.2 (Linux tarball + `libncursesw` shim). No macOS SDK, no Xcode, no
  WebKit, no FlutterMacOS.

## Suite runs (observed on this host)

| Gate | Command | Clean tree (fix stashed) | Fixed tree | Verdict |
| --- | --- | --- | --- | --- |
| red (parity contract) | worktree at `fbc30418` + `flutter test test/download_start_request_parity_test.dart` | **exit 1, `00:04 +0 -7: Some tests failed.`** (all 7 criteria red, each for the documented gap) | — | red observed on the exact committed test |
| green (parity contract) | `cd zikzak_inappwebview_macos && flutter test test/download_start_request_parity_test.dart` | — | exit 0, `00:04 +7: All tests passed!` | red→green |
| test (macos pkg) | `flutter test` | — (pre-fix baseline: pre-existing suite green) | `00:11 +58: All tests passed!` | green, no regression |
| analyze (macos pkg) | `flutter analyze` | baseline: `No issues found!` | `No issues found! (ran in 9.4s)` | identical to baseline |
| analyze (umbrella) | `cd zikzak_inappwebview && flutter analyze` | 23 infos (AGENTS.md baseline) | 23 infos, 0 warnings/errors — identical set | no regression |
| test (umbrella) | `cd zikzak_inappwebview && flutter test` | 250 pass baseline | `00:25 +250: All tests passed!` | no regression (isolation signal) |
| swift parse (touched files) | `swiftc -parse InAppWebView.swift` / `WebViewChannelDelegate.swift` / `Types/DownloadStartRequest.swift` | — | PARSE OK ×3, exit 0 (Swift 6.1.2) | syntax-only |
| swift typecheck (real files) | `swiftc -typecheck ...` | — | **NOT EXECUTED** — `import WebKit`/`import FlutterMacOS` cannot resolve off Apple platforms | gap (environmental) |
| formatting | `git diff --check`; `dart format` on changed Dart files | — | `git diff --check` exit 0; `0 changed` | clean |
| platform isolation | `git status --porcelain` / `git diff --stat` | — | macOS package sources + test + `.specify/` records + `.specify/feature.json` only; no other platform/package | confined |

## Test-first evidence (per behavior)

History shape: `fbc30418` ("test(339): … (red)") touches ONLY the parity test
and the `.specify/bugs/339-*/` records — verified via `git show --stat` — and
the source fix lands in the following commit. The red was OBSERVED in a
throwaway `git worktree` at that commit, so test-before-source is corroborated
by history, not just claimed.

One disclosure per the rubric's amendment clause: the test commit was AMENDED
once (`a435e1ec` → `fbc30418`) to add the strengthened AC6 assertions — this
happened BEFORE any source commit, the amendment was driven by a surviving
mutant (see Mutation results), and the red was re-observed after the amendment,
so the ordering evidence remains intact. Classified honestly:

| ID | Criterion | Behavior | Class | Basis |
| --- | --- | --- | --- | --- |
| B1 | AC1 | macOS ships `Types/DownloadStartRequest.swift` with the 7 payload keys | PROVEN | cycle-log C1b red (AC1 [E]) + C2 green; test-only commit precedes source |
| B2 | AC2 | `InAppWebView` adopts `WKDownloadDelegate` | PROVEN | C1b red (AC2 [E]) + C2 green; M1 mutant caught |
| B3 | AC2 | destination callback dispatches + `completionHandler(nil)`; `didBecome` dispatches | PROVEN | C1b red (AC4 [E]) + C2 green |
| B4 | AC3 | `decidePolicyFor navigationResponse` download detection honoring `useOnDownloadStart` | PROVEN | C1b red (AC3 [E]) + C2 green; M3 mutant caught |
| B5 | AC4 | policy `2` → `.download` in BOTH Int and NSNumber branches | PROVEN | C1b red (AC6 [E]) + C2 green; M2 mutant caught after strengthening |
| B6 | AC5 | `WebViewChannelDelegate.onDownloadStartRequest` bridge | PROVEN | C1b red (AC5 [E]) + C2 green |
| B7 | AC6 | Dart controller routes `'onDownloadStartRequest'` to the callback | PROVEN | C1b red (AC7 [E]) + C2 green; M4 mutant caught |
| B8 | AC7 | diff confinement + zero formatting churn | PROVEN | `git status --porcelain`, `git diff --check` (exit 0), `dart format` `0 changed` — commands + output in cycle-log C2b |
| B9 | AC8 | macOS-package analyze identical to baseline | PROVEN | baseline vs post-fix runs, both `No issues found!` |
| B10 | AC8 | macOS-package suite green (58/58) | PROVEN | observed both runs; pre-existing suite unchanged |
| B11 | AC2–AC6 | end-to-end `Content-Disposition: attachment` click dispatches the event on macOS | **NO_TEST (macOS-only)** | exact repro command recorded in cycle-log C3; not executable off macOS (no `-d macos` subcommand; WebKit/FlutterMacOS unavailable) |
| B12 | AC2–AC4 | touched Swift files parse cleanly | PROVEN (shallow) | `swiftc -parse` ×3 exit 0 — syntax-only, no type-check possible |

Diff check against tests that already existed: no existing test was modified,
weakened, renamed, skipped, or excluded by this change (the only pre-existing
file touched by `dart format .` was `swift_sourceframe_kvc_test.dart`, whose
unrelated reformat was reverted; the file is not format-clean on master —
pre-existing, flagged, not fixed here).

## Findings

Ordered by severity. The auditor did not fix these during the audit.

| # | Severity | Finding | Evidence |
| --- | --- | --- | --- |
| 1 | MED | The host-runnable contract is a source-scan test: it pins presence, ordering, and branch structure of the native chain, but not runtime semantics — WebKit's actual `.download` pipeline behavior is only provable on macOS. The M2 event below is the concrete demonstration: a `contains`-based assertion was satisfied by the wrong branch. Residual risk of the same class (a semantic mutant that keeps the pinned tokens while changing meaning) cannot be fully excluded on this host. | `test/download_start_request_parity_test.dart` (whole file); pattern follows the repo's documented native-contract tests (`swift_sourceframe_kvc_test.dart` bug #327, `user_script_initializer_parity_test.dart` bug #317), so it is NOT foreign style |
| 2 | LOW | `swift_sourceframe_kvc_test.dart` is not dart-format-clean on master; `dart format .` wants to reflow it. Pre-existing drift, unrelated file, deliberately left untouched to keep the fix minimal. | `zikzak_inappwebview_macos/test/swift_sourceframe_kvc_test.dart` |
| 3 | LOW | The red commit was amended once (mutant-driven AC6 strengthening) before any source commit; ordering remains verifiable (`git show --stat fbc30418` shows test+records only) but the raw pre-amendment hash is only in the cycle log. | cycle-log C2e |

## Mutation results

No mutation tool in the profile (`.specify/memory/tdd-profile.md`); deliberate
mutants on a sample of the highest-risk behaviors — 4 of the 11 runnable
behaviors (B2, B4, B5, B7 — the adoption gate, the response-policy decision,
the policy mapping, and the Dart routing). One at a time, restored exactly,
suite re-verified green after each restoration and after the session.

| Mutant | Behavior | Survived | Judgment |
| --- | --- | --- | --- |
| M1: drop `, WKDownloadDelegate` from the class declaration | B2 | No | Caught by AC2 |
| M2: Int branch `case 2:` → `policy = .cancel` (the old bug) | B5 | **Yes, then No** — first run SURVIVED (bare `contains('policy = .download')` satisfied by the NSNumber branch); AC6 strengthened to pin both branch sub-blocks; re-run caught by AC6 | Survival drove a test strengthening BEFORE the fix commit; final state: caught |
| M3: `decisionHandler(.download)` → `.allow` in `decidePolicyFor navigationResponse` | B4 | No | Caught by AC3 |
| M4: rename Dart `case 'onDownloadStartRequest':` → `...X` | B7 | No | Caught by AC7 |

No surviving mutant remains inside a DONE behavior. Sampling, not exhaustive:
the remaining runnable behaviors (B1, B3, B6, B8–B10, B12) were not mutated.

## Traceability

| Criterion | Tests / gates | End to end |
| --- | --- | --- |
| AC1 (type parity) | B1 (AC1 test) | Source contract only — runtime on macOS |
| AC2 (WKDownloadDelegate adoption + callbacks) | B2, B3, B12 | Source contract only |
| AC3 (response-time detection) | B4 | Source contract only |
| AC4 (DOWNLOAD policy honored) | B5 | Source contract only |
| AC5 (channel bridge) | B6 | Source contract only |
| AC6 (Dart routing) | B7 | Source contract + analyze |
| AC7 (blast radius) | B8 | Repo gate (executed) |
| AC8 (no regression) | B9, B10, umbrella runs | Package gates (executed) |

Criteria with no test: none (all 8 map to executed gates). Tests tracing to
nothing: none. No criterion is verified through the real macOS runtime entry
point on this host — that is the gap behind the verdict, tracked as B11 and
remediation task T1.

## What was not audited

- **macOS runtime behavior**: the WebKit `.download` pipeline, the actual
  dispatch of `onDownloadStartRequest` on an attachment click, and the absence
  of decision-handler hangs — no macOS host, not executed (B11; cycle-log C3).
- **Swift type-checking**: `-parse` only; `import WebKit`/`import FlutterMacOS`
  cannot resolve on Linux, so type errors (e.g. a signature drift against the
  WKDownloadDelegate protocol) are NOT excluded by this audit. CI's `build-ios`
  job compiles the iOS Swift sources, not the macOS ones — first real compile
  of the macOS package happens on a contributor's macOS build.
- **Mutation sampling**: 4 of 11 runnable behaviors; not exhaustive.
- **Other platform packages** (android/web/windows/linux): untouched by the
  diff; their CI gates were not re-run locally.
- **Performance**: no criterion, no test, not assessed.
