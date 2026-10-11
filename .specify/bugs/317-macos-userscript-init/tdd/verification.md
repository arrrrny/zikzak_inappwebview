# TDD Verification — 317-macos-userscript-init

- **verified_at**: `0c51cce8` (base) + working tree to be committed as the fix commit on `fix/317-macos-userscript-init`
- **standard**: `.specify/extensions/tdd/templates/tdd-test-quality-rubric.md` (resolved: extension copy; no overrides/presets present)
- **feature dir**: `.specify/bugs/317-macos-userscript-init/` (bug workflow dir; `.specify/feature.json` deliberately NOT flipped — it tracks in-flight work on master)
- **environment**: Linux x86_64 (Debian 13), Flutter 3.47.2 / Dart 3.13.2 (Linux host), Swift 6.1.2 (Linux tarball; `swiftc` with local `libncurses6` compat shim). **No macOS SDK, no Xcode, no WebKit, no FlutterMacOS.**
- **audit independence**: NOT independent — the same session that wrote the fix wrote this report. Fail-closed applies throughout; all files re-read cold during the audit.

## Verdict: PASS_WITH_GAPS

The missing initializer named in issue #317 now exists with iOS-identical shape,
and the red→green was executed at three independent gates: the Dart parity gate
on the real native source (red C1a → green C2a), the Swift compiler on a
shape-exact repro of the exact construction from the issue (red C1b, exit 1
with the compiler naming the only available `in:` form as the
`groupName:`-requiring one → green-shape control C1c, exit 0), and the full
package suites (all green or byte-identical baselines). Deliberate mutants M1/M2
prove the gate catches both removal of the initializer and weakening of its
body. The remaining gap is environmental, not evidential: the real macOS compile
gate (`flutter build macos`, B3) and the runtime injection observation (B4) were
**not executed** — macOS-only, with exact commands recorded in cycle-log C5.

## Test-first evidence

| Behavior | Class | Evidence |
| --- | --- | --- |
| B1 (parity gate on native source) | PROVEN | cycle C1a red recorded (2 failures on missing initializer); fix commit carries test + source together with the red in the log |
| B2 (Swift rule repro) | PROVEN | cycle C1b red recorded (exit 1, `missing argument for parameter 'groupName' in call`); C1c green-shape control exit 0 |
| B3 (flutter build macos) | NO_TEST (environmental) | macOS-only; NOT_EXECUTED, exact command in C5 |
| B4 (runtime injection) | NO_TEST (environmental) | macOS-only; NOT_EXECUTED, exact snippet in C5 |
| B5 (diff confinement) | PROVEN | `git status --porcelain`: 1 modified Swift file, 1 new test file, bug records only |
| B6 (formatting) | PROVEN | `git diff --check` clean |
| B7 (macos analyze) | PROVEN | 4 findings pre vs 4 post, identical set |
| B8 (macos suite) | PROVEN | 42/0 pre → 48/0 post (42 + 6 new parity tests) |
| B9 (umbrella gates) | PROVEN | analyze 37 identical; test 245/2 identical, both failures identified as pre-existing (stale fake compile error at `proxy_tracing_controllers_test.dart:24:16`; U14 behavioral at `domain_controllers_behavioral_test.dart:194`) |
| B10 (syntax gate, real file) | PROVEN | `swiftc -parse UserScript.swift` exit 0 (syntax-only by nature on Linux) |
| B11 (mutant strength) | PROVEN | M1 (initializer removed) CAUGHT; M2 (contentWorld recording dropped) CAUGHT; restore exact, suite green after restore |

## Findings

| # | Severity | Finding | Evidence |
| --- | --- | --- | --- |
| 1 | LOW | One test-bug during the cycle: the parity test's body-extraction regex (tempered lookahead stopping at `super.init(`) truncated the initializer body, failing post-fix despite a correct fix. Repaired during C2 (capture mechanism fixed, assertions unchanged); red in C1a was independent of the defect | `test/user_script_initializer_parity_test.dart:109-118` |
| 2 | LOW | The parity gate asserts native-source structure (regex on Swift source), not compiled behavior — necessary on a Linux host, and compensated by the shape-exact `swiftc` repro and `swiftc -parse` gate; replace or supplement with a real `flutter build macos` in CI when available | `test/user_script_initializer_parity_test.dart` (whole file) |

No `HIGH` smells. No weakened, skipped, or removed existing tests (diff touches
no pre-existing test). No `TEST_AFTER` behavior among runnable gates.

## Mutation results

No mutation tool in the profile (`mutation: null`). Deliberate mutants, one at a
time, on the changed file (sample = 2 of 2 mutation-relevant behaviors; small
sample by design, not exhaustive):

| Mutant | Behavior | Survived | Judgment |
| --- | --- | --- | --- |
| M1: delete `public override init(source:injectionTime:forMainFrameOnly:in:)` entirely | B1 | No | CAUGHT — parity test `— #317` red |
| M2: drop `self.contentWorld = contentWorld` from the new initializer | B1 | No | CAUGHT — `delegates to super` assertion red |

## Traceability

| Criterion | Tests / Gates | End to end |
| --- | --- | --- |
| AC1 (initializer implemented, iOS parity) | B1 (parity gate), B2 (Swift rule repro), B10 (parse gate), B11 (mutants) | compile-level yes; true end-to-end is B3 (macOS-only) |
| AC2 (initialUserScripts works before first page load) | B4 (macOS-only, NOT_EXECUTED); deserialization entry point statically asserted by B1 | No (environmental gap, honestly recorded) |
| AC3 (macOS-only change, zero formatting diffs) | B5, B6 | Yes (repo-level gates) |
| AC4 (no regression vs baseline) | B7, B8, B9 | Yes (baseline-compare gates) |

Criteria with no test at any level: none. Tests tracing to nothing: none.

## What was not audited

- **macOS compile + runtime**: `flutter build macos` (B3) and the runtime
  injection observation (B4) were not executed — impossible on this Linux host.
  These are the deliverable's final proof and must run on a macOS host/CI.
- **Mutation testing**: no tool configured in the profile; strength was sampled
  via 2 deliberate mutants, not measured exhaustively.
- **Other platform packages** (android/ios/web/windows/linux): untouched by the
  diff (B5) and not audited further.
- **Coverage tooling**: `flutter test --coverage` not used as corroboration here;
  the parity gate is source-structural and coverage adds no signal for a
  15-line Swift diff on a host that cannot compile it.
- **Performance**: not assessed; no criterion requires it.
