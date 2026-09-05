# TDD Verification — 312-macos-usercontentcontroller-public

- **verified_at**: `6fb7f8cb` (base) + working tree committed as the fix commit on `fix/312-macos-usercontentcontroller-public`
- **standard**: `.specify/extensions/tdd/templates/tdd-test-quality-rubric.md` (resolved: extension copy; no overrides/presets present)
- **feature dir**: `.specify/bugs/312-macos-usercontentcontroller-public/` (bug workflow dir; `.specify/feature.json` deliberately NOT flipped — it tracks in-flight `specs/001-screenshot-pdf-export` on master)
- **environment**: Linux x86_64 (Debian 13), Flutter 3.47.2 / Dart 3.13.2 (Linux host), Swift 6.1.2 (Linux tarball; `swiftc` with local `libncurses6` compat shim). **No macOS SDK, no Xcode, no WebKit, no FlutterMacOS.**
- **audit independence**: NOT independent — the same session that wrote the fix wrote this report. Fail-closed applies throughout.

## Verdict: PASS_WITH_GAPS

The Swift compiler itself enforces the fixed rule: the pre-fix access-control shape is
rejected with the issue's exact diagnostic (red, executed) and the post-fix shape
type-checks clean (green, executed). Every runnable gate is green or byte-identical
to the pre-fix baseline. The remaining gap is environmental, not evidential: the real
macOS compile gate (`flutter build macos`, AC1 end-to-end) was **not executed**
because the subcommand does not exist off macOS — recorded as a gap with exact CI
commands, not claimed as a pass.

## Suite runs (observed on this host)

| Gate | Command | Clean tree (fix stashed) | Fixed tree | Verdict |
| --- | --- | --- | --- | --- |
| analyze (macos pkg) | `cd zikzak_inappwebview_macos && flutter analyze` | 4 findings (1 info, 3 warnings; exit 1), all in files untouched by this change | 4 findings, byte-identical set | no regression |
| test (macos pkg) | `cd zikzak_inappwebview_macos && flutter test` | 42 passed / 0 failed | **42 passed / 0 failed** | green, no regression |
| analyze (umbrella) | `cd zikzak_inappwebview/zikzak_inappwebview && flutter analyze` | — (Swift-only diff cannot affect; 309 baseline identical at 37) | 37 findings, all pre-existing | no regression |
| test (umbrella) | `cd zikzak_inappwebview/zikzak_inappwebview && flutter test` | **236 passed / 3 failed** | 236 passed / 3 failed — same 3 failures | failures PROVEN pre-existing (stash re-run) |
| swift typecheck (rule repro) | `swiftc -typecheck red_repro.swift` / `green_repro.swift` | RED: exit 1, `error: method 'userContentController(_:didReceive:)' must be declared public because it matches a requirement in public protocol` + fix-it note | GREEN: exit 0, zero diagnostics | compiler-enforced red→green |
| swift parse (real files) | `swiftc -parse InAppWebView.swift` + `WeakScriptMessageHandler.swift` | — | PARSE OK ×2 (exit 0) | syntax-only |
| build (macos pkg) | `cd zikzak_inappwebview_macos && flutter build macos` | — | **NOT EXECUTED** — observed on this host: `Could not find a subcommand named "macos" for "flutter build".` | gap (macOS-only) |
| formatting | `git diff --check` | — | clean — zero whitespace/formatting diffs | clean |
| platform isolation | `git status --porcelain` / `git diff --stat` | — | 1 Swift file + `.specify/bugs/312-*/` records; no other platform/package | confined |

Umbrella test failures (all three pre-existing; identical on clean and fixed trees,
and identical to the 309 run's recorded baseline): `proxy_tracing_controllers_test.dart`
file load error `[E]`; `domain_controllers_behavioral_test.dart` U14
(loadSimulatedRequest delegation); `in_app_webview_dispose_test.dart` U9 (dispose
keep-alive forwarding).

## Test-first evidence (per behavior)

| ID | Behavior | Classification | Basis |
| --- | --- | --- | --- |
| B1 (AC1) | Compiler rejects internal witness of public-protocol requirement; accepts `public` witness | **PROVEN** | cycle-log C1a red (exit 1, exact diagnostic) and C2a green (exit 0), executed with Swift 6.1.2 on this host; shape-exact repro with WebKit types stubbed |
| B2 (AC1) | Changed real files parse cleanly | **PROVEN (shallow)** | `swiftc -parse` only; **no type-check against WebKit/FlutterMacOS** (impossible on Linux) |
| B3 (AC1) | `flutter build macos` compiles the package; line-2318 error gone | **NO_TEST (macOS-only)** | Not executable on this host (subcommand absent — observed). Red evidenced indirectly: executed compiler-rule red (B1) + the real build log in issue #312 + source inspection of line 2318. CI command recorded in cycle-log C2c |
| B4 (AC2) | Diff touches ONLY the access modifier; #309 deserialization logic unchanged | **PROVEN** | `git diff` inspected directly: one token (`func` → `public func`), nothing else |
| B5 (AC3) | Changes confined to macOS package + this bug's records | **PROVEN** | `git status --porcelain` inspected directly |
| B6 (AC3) | Zero formatting/whitespace diffs | **PROVEN** | `git diff --check` clean |
| B7 (AC4) | macOS-package analyze unchanged vs baseline | **PROVEN** | baseline vs post-fix: byte-identical 4-finding set, none in changed code |
| B8 (AC4) | macOS-package test suite green | **PROVEN** | 42/42 observed both trees |
| B9 (AC4) | Umbrella gates unchanged; 3 failures pre-existing | **PROVEN** | 236/3 on both trees; stash re-run isolates failures to master |

## Red-phase evidence

- **Executed red**: cycle-log C1a — `swiftc -typecheck` rejects the pre-fix
  access-control shape with the issue's exact diagnostic and the fix-it
  ("mark the instance method as 'public'") that names the one-token fix.
  Recorded BEFORE the real file was modified (ordering: repro red → fix applied
  → repro green, all in one working session; git history shows the real-file
  fix and these records landing in the same commit, so ordering between repro
  and fix rests on the cycle log's word, which is self-reported — flagged per
  the rubric's evidence-source rules).
- **Not-executed red**: the real macOS build (C1b). No macOS toolchain exists
  on this host; the subcommand is absent (observed). The red is evidenced
  indirectly only. By the rubric this makes B3 **NO_TEST (macOS-only)** — an
  environmental impossibility, not an oversight.
- Baseline discipline: umbrella failures isolated to master via stash → re-run
  → identical failures → restore; macOS-package baseline captured pre-fix.

## Smells / discrepancies found

None HIGH. No test files were added or changed by this fix (the behavior is a
compile-time Swift access-control violation; the repo's macOS Xcode test target
does not exist, and inventing a Dart test that greps the Swift source for the
modifier would be a tautological, implementation-coupled test — deliberately not
authored). Pre-existing analyzer/test debt in both packages predates this change
and is out of scope per the hard constraints (fix ONLY the access modifier).

Minor finding (MED, process): the cycle log's C1a red ordering is self-reported
(repro files live outside the repo and land in no commit); a skeptic has only
the log's word that red preceded green. Weight against it: the same Swift
compiler both rejects and accepts the two shapes on demand today — anyone can
re-run the two commands and observe the red and the green independently.

## Mutation / deliberate-mutant results

- **Tooling**: none for Swift on Linux (profile records `mutation: null`).
- **Deliberate mutant (sample of 1, the highest-risk behavior)**: remove the
  `public` modifier from the protocol witness (= revert the fix) →
  `swiftc -typecheck` fails with the issue's exact diagnostic (caught); restore
  exactly → typecheck green, `flutter test` 42/42, `git diff --check` clean.
  This is literally the bug re-introduced and caught, then restored and
  verified — the restore was verified before proceeding. No other behaviors
  were mutated (sample size 1 of 9; not exhaustive).

## Traceability

| Criterion | Tests / Gates | End to end |
| --- | --- | --- |
| AC1 (macOS compiles; witness error gone) | B1 (compiler rule, executed), B2 (parse), B3 (real build — **NOT_EXECUTED**) | **No** — end-to-end proof requires macOS CI |
| AC2 (access modifier only; #309 logic untouched) | B4 | n/a (diff inspection) |
| AC3 (scope confinement; zero formatting diffs) | B5, B6 | n/a (diff inspection) |
| AC4 (no regression in runnable gates) | B7, B8, B9 | Yes (Linux-executable gates) |

Criteria with no executed test: AC1 end-to-end (B3) — environmental gap.
Tests tracing to nothing: none.

## What was not audited

- The real macOS build (`flutter build macos`) was not executed — no macOS
  host, SDK, Xcode, WebKit, or FlutterMacOS on this machine. AC1 is proven at
  the compiler-rule level, not end-to-end.
- No Swift type-checking of the real `InAppWebView.swift` against WebKit/
  FlutterMacOS modules (impossible on Linux); only parse-level syntax.
- No mutation tooling for Swift; deliberate-mutant sampling was 1 of 9
  behaviors.
- Umbrella `flutter analyze` was run on the fixed tree only (37 findings); its
  clean-tree value is taken from the 309 run's identical baseline plus the
  Swift-only scope of this diff, not from a fresh stash re-run.
- No iOS/Android/Web/Windows/Linux verification was run; the diff touches none
  of their files (verified by `git status --porcelain` scope, not by their test
  suites).

## Remediation tasks (do not gate this PR)

- **R1** (high): run `cd zikzak_inappwebview_macos && flutter build macos` on
  macOS CI (Xcode toolchain) and paste the `BUILD SUCCEEDED` output plus a
  `grep -c "must be declared public"` of the build log (expect 0) into this
  file's addendum. This closes AC1 end-to-end.
- **R2** (medium): add an Xcode test target for `zikzak_inappwebview_macos` so
  macOS-only Swift behavior (including the #309 deserialization path and the
  protocol conformance of `InAppWebView`) gains an executable home; port the
  B1 repro into an XCTest asserting the type-checks of the real module.
- **R3** (low): the umbrella suite's 3 pre-existing failures (proxy_tracing
  load error, U14, U9) and 37 analyzer findings predate this change; sweep them
  once a maintainer confirms they are not load-bearing for in-flight branches.
