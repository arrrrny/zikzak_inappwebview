---
feature: 317-macos-userscript-init
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 4
planned_at: 0c51cce8
updated_at: 0c51cce8
suite_baseline: green
---

# Test List — 317-macos-userscript-init

Acceptance criteria (derived from issue #317 and the task's hard constraints):

- **AC1** — the macOS `UserScript` initializer
  `init(source:injectionTime:forMainFrameOnly:in:)` named in the issue is
  implemented, with iOS parity (same signature, same super delegation, same
  `contentWorld` recording).
- **AC2** — `initialUserScripts` works on macOS: scripts passed at creation
  inject before the first page load (runtime behavior on macOS).
- **AC3** — the change is confined to the macOS package plus bug records; iOS
  and every other platform untouched; zero formatting/whitespace diffs.
- **AC4** — the runnable Dart-side gates show no regression vs the pre-fix
  baseline (analyze finding sets identical; test suites identical pass/fail,
  plus the new parity tests).

The missing initializer is a Swift API gap in macOS-only code. The development
environment for this fix is Linux: no macOS SDK, no Xcode, no WebKit, no
FlutterMacOS, so `flutter build macos` and any macOS runtime observation are
impossible here. Behaviors are classified honestly: the Swift-language red→green
(B1/B2) is runnable via `swiftc` on a shape-exact repro and via a runnable Dart
parity gate that reads the native source; the real macOS compile and runtime
gates (B3/B4) are `MACOS-ONLY / NOT_EXECUTED` with exact commands in the cycle
log. No fake macOS run is invented to simulate them.

## Behaviors

| ID | Criterion | Behavior | Kind | Level | Test / Gate | Status |
| --- | --- | --- | --- | --- | --- | --- |
| B1 | AC1 | The native macOS `UserScript` source declares the `public override init(source:injectionTime:forMainFrameOnly:in:)` initializer with iOS-identical body (super delegation in contentWorld form + `self.contentWorld = contentWorld`), and the platform-channel deserialization entry point `fromMap` is intact | behavior | unit (native-source parity gate, runnable) | `cd zikzak_inappwebview_macos && flutter test test/user_script_initializer_parity_test.dart` (6 tests) | RUNNABLE / PROVEN (red C1a → green C2a) |
| B2 | AC1 | A consumer can construct `UserScript(source:injectionTime:forMainFrameOnly:in:)` — the exact construction shape from the issue — against a shape-exact stand-in for WKUserScript/WKContentWorld | behavior | unit (Swift language rule, shape-exact repro) | `swiftc -typecheck red_repro.swift` (expect fail) / `green_repro.swift` (expect pass), commands + output in cycle-log C1b/C1c | RUNNABLE / PROVEN (Swift 6.1.2, Linux) |
| B3 | AC1 | `flutter build macos` in `zikzak_inappwebview_macos` compiles the package with the new initializer | gate | integration (macOS toolchain) | macOS-only: `cd zikzak_inappwebview_macos && flutter build macos` (cycle-log C4) | MACOS-ONLY / NOT_EXECUTED |
| B4 | AC2 | `initialUserScripts` passed to `InAppWebView`/headless inject before first page load on macOS (no crash during platform-channel deserialization) | behavior | end-to-end (macOS runtime) | macOS-only: run example app with `initialUserScripts: [UserScript(...)]` (cycle-log C4) | MACOS-ONLY / NOT_EXECUTED |
| B5 | AC3 | Changes confined to `zikzak_inappwebview_macos/**` + `.specify/bugs/317-*/**` records; no iOS/other platform touched | gate | repo | `git status --porcelain` / `git diff --stat` | RUNNABLE / PROVEN |
| B6 | AC3 | Zero whitespace/formatting diffs in the change | gate | repo | `git diff --check` | RUNNABLE / PROVEN |
| B7 | AC4 | `flutter analyze` in `zikzak_inappwebview_macos`: finding set identical to pre-fix baseline (4 pre-existing, zero new) | gate | package | baseline vs post-fix run | RUNNABLE / PROVEN |
| B8 | AC4 | `flutter test` in `zikzak_inappwebview_macos`: 48 passed / 0 failed (pre-fix baseline 42/0 + 6 new parity tests) | gate | package | baseline vs post-fix run | RUNNABLE / PROVEN |
| B9 | AC4 | Umbrella gates unchanged: analyze 37 pre-existing; test 245 passed / 2 failed with both failures PROVEN pre-existing by pre-fix clean-tree baseline (stale fake `_FakePlatformProxyController.clearProxyOverride` compile error; U14 `loadSimulatedRequest` behavioral) | gate | package | baseline vs post-fix run | RUNNABLE / PROVEN |
| B10 | AC1 | The changed real file is syntactically valid Swift (parse gate; no type-check against WebKit/FlutterMacOS possible on Linux) | gate | file | `swiftc -parse UserScript.swift` | RUNNABLE / PROVEN (syntax-only) |
| B11 | AC1 | Test strength: the parity gate catches (a) removal of the #317 initializer and (b) dropping the `contentWorld` recording — deliberate mutants | gate | mutation (deliberate, sample) | M1/M2 in cycle-log C3, each caught, restore exact, suite green after restore | RUNNABLE / PROVEN |
