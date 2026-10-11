# Test List — Bug #316 (ios-build-fail)

Source spec: `./spec.md` · Assessment: `./assessment.md` · Runner: `flutter_test`
(cwd `zikzak_inappwebview_ios` per `.specify/memory/tdd-profile.md`)

The behavior under fix is native (Swift + SwiftPM). The authoritative compile-level
reproduction (`flutter build ios`, `swiftc`) requires macOS + Xcode and cannot run
in this Linux environment; the tests below encode the two bug classes as real,
executable source-contract tests so the regression is provable red→green here.
macOS-level verification commands are recorded in `./tdd/cycle-log.md`.

| Behavior id | Behavior (spec ref) | Test | Kind | State |
| --- | --- | --- | --- | --- |
| B1 | AC1 — no `#available`/`#unavailable` outside `if`/`guard`/`while` conditions in iOS Swift sources | `zikzak_inappwebview_ios/test/swift_availability_usage_test.dart` — scans every `Sources/**/*.swift` (comments/strings stripped) and fails listing any availability condition used as a boolean operand (`!`, `&&`, `\|\|` prefixes; boolean continuations after the closing paren) | source-contract unit | DONE |
| B2 | AC3 — SPM iOS platform minimum ≤ 15.0 | `zikzak_inappwebview_ios/test/ios_package_platform_test.dart` — parses `ios/zikzak_inappwebview_ios/Package.swift`, asserts the declared `.iOS("…")` minimum is at most 15.0 | source-contract unit | DONE |
| B3 | AC2 — preserved data-store truth table | restructure documented truth-table-equivalent in `fix.md`; pinned indirectly by B1 (the offending line must be replaced by nested `if`s; the test forbids any boolean-operand reintroduction) | by-construction + B1 | DONE |
| B4 | AC4 — no unguarded iOS 15.4+/16+ API | manual audit of all 15.4/16/16.4 touchpoints, evidence recorded in `fix.md` (each usage site already `#available`-guarded; lowering the floor introduces no new unguarded path) | audit | DONE |
| B5 | AC5 — analyze/test gates green, no formatting diffs | `flutter analyze` + `flutter test` in `zikzak_inappwebview_ios` and `zikzak_inappwebview`; `git diff --stat` | suite | DONE |

## Cycle log (summary — full evidence in `./tdd/cycle-log.md`)

- Cycle 1 (B1): RED — test fails on `InAppWebView.swift:887:76` violation → fix
  (nested ifs) → GREEN.
- Cycle 2 (B2): RED — test fails on `.iOS("16.0")` > 15.0 → fix (`.iOS("15.0")`)
  → GREEN.
