---
feature: 312-macos-usercontentcontroller-public
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 4
planned_at: 6fb7f8cb
updated_at: 6fb7f8cb
suite_baseline: green
---

# Test List — 312-macos-usercontentcontroller-public

Acceptance criteria (derived from issue #312 and the task's hard constraints):

- **AC1** — the macOS package compiles: `flutter build macos` in
  `zikzak_inappwebview_macos` succeeds; the
  `userContentController(_:didReceive:)` protocol-witness error is gone.
- **AC2** — the fix is the access modifier ONLY: the defensive deserialization
  logic from #309 is unchanged (no behavioral diff beyond `public`).
- **AC3** — the change is confined to the macOS package (no other platform or
  package touched) and the diff carries zero formatting/whitespace changes.
- **AC4** — the runnable Dart-side gates show no regression vs the pre-fix
  baseline (analyze finding set identical; test suites identical pass/fail).

The failing behavior is a Swift compile-time access-control violation in
macOS-only code. The development environment for this fix is Linux: `flutter
build macos` is not even a registered subcommand on a Linux host (observed:
`Could not find a subcommand named "macos" for "flutter build".`), and no Swift
toolchain can type-check against WebKit/FlutterMacOS modules here. Behaviors are
classified honestly: the compiler-rule red→green (B1) is runnable via
`swiftc -typecheck` on a shape-exact repro; the syntax gate (B2) is runnable;
the real macOS compile gate (B3/B9) is `MACOS-ONLY / NOT_EXECUTED` with exact CI
commands in the cycle log. No fake Swift test is invented to simulate the macOS
build.

## Behaviors

| ID | Criterion | Behavior | Kind | Level | Test / Gate | Status |
| --- | --- | --- | --- | --- | --- | --- |
| B1 | AC1 | A public class with an internal witness for a public-protocol requirement fails to compile with the issue's exact diagnostic, and compiles once the witness is `public` (language rule enforced by the Swift compiler) | behavior | unit (Swift language rule, shape-exact repro) | `swiftc -typecheck` on `red_repro.swift` / `green_repro.swift` (commands + output in cycle-log C1/C2) | RUNNABLE / PROVEN (Swift 6.1.2, Linux) |
| B2 | AC1 | The changed real files are syntactically valid Swift (parse gate; no type-check against WebKit/FlutterMacOS possible on Linux) | gate | file | `swiftc -parse InAppWebView.swift` + `WeakScriptMessageHandler.swift` | RUNNABLE / PROVEN (syntax-only) |
| B3 | AC1 | `flutter build macos` in `zikzak_inappwebview_macos` compiles the package and no longer emits the line-2318 protocol-witness error | behavior | integration (macOS toolchain) | macOS-only: `cd zikzak_inappwebview_macos && flutter build macos` (cycle-log C1) | MACOS-ONLY / NOT_EXECUTED |
| B4 | AC2 | `git diff` against `master` touches ONLY the access modifier on the line-2318 declaration (no #309 logic change anywhere) | gate | repo | `git diff master... -- zikzak_inappwebview_macos` inspected directly | RUNNABLE / PROVEN |
| B5 | AC3 | Changes confined to `zikzak_inappwebview_macos/**` + `.specify/bugs/312-*/**` records; no other platform/package touched | gate | repo | `git status --porcelain` / `git diff --stat` | RUNNABLE / PROVEN |
| B6 | AC3 | Zero whitespace/formatting diffs in the change | gate | repo | `git diff --check` | RUNNABLE / PROVEN |
| B7 | AC4 | `flutter analyze` in `zikzak_inappwebview_macos`: finding set identical to pre-fix baseline (4 pre-existing, zero new) | gate | package | baseline vs post-fix run | RUNNABLE / PROVEN |
| B8 | AC4 | `flutter test` in `zikzak_inappwebview_macos`: 42 passed / 0 failed, same as pre-fix baseline | gate | package | baseline vs post-fix run | RUNNABLE / PROVEN |
| B9 | AC4 | Umbrella package gates unchanged: analyze 37 pre-existing; test 236 passed / 3 failed with the 3 failures PROVEN pre-existing by clean-tree (stash) re-run | gate | package | baseline vs post-fix vs stash re-run | RUNNABLE / PROVEN |
