---
feature: 012-lifecycle-integration-tests
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 10
planned_at: abfa842e
updated_at: abfa842e
suite_baseline: red
---

# Test List: WebView Lifecycle Integration Tests

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md`. Each stays red until the feature works end to end through its real entry point.

| id  | behavior                                                    | traces | kind    | state   | test                                        |
| --- | ----------------------------------------------------------- | ------ | ------- | ------- | ------------------------------------------- |
| A1  | Hot restart: after reassemble, controller.getUrl() returns a non-null valid URL | AC-1 (US1#1) | example | DONE | `example/integration_test/lifecycle_test.dart › WebView survives hot restart (reassemble)` |
| A2  | Hot restart: after reassemble, evaluateJavascript('1+1') returns 2 | AC-1 (US1#2) | example | DONE | `example/integration_test/lifecycle_test.dart › WebView survives hot restart (reassemble)` |
| A3  | Hot restart mid-load: onLoadStop fires exactly once for final load after restart | AC-1 (US1#3) | example | DONE | `example/integration_test/lifecycle_test.dart › WebView survives hot restart (reassemble)` |
| A4  | Activity recreation (rotation): no MissingPluginException, getUrl() resolves | AC-2 (US2#1) | example | DONE | `example/integration_test/lifecycle_test.dart › background -> foreground does not throw MissingPluginException` |
| A5  | Activity recreation (background→foreground): channels registered, calls succeed | AC-2 (US2#2) | example | DONE | `example/integration_test/lifecycle_test.dart › background -> foreground does not throw MissingPluginException` |
| A6  | Activity recreation mid-load: WebView content preserved/restored | AC-2 (US2#3) | example | DONE | `example/integration_test/lifecycle_test.dart › background -> foreground does not throw MissingPluginException` |
| A7  | FlutterFragment: plugin registration completes without Activity | AC-3 (US3#1) | example | DONE | `example/integration_test/lifecycle_test.dart › plugin registration works without an Activity` |
| A8  | FlutterFragment: controller creation + later Activity attachment binds lifecycle | AC-3 (US3#2) | example | DONE | `example/integration_test/lifecycle_test.dart › plugin registration works without an Activity` |
| A9  | FlutterFragment: teardown before Activity available raises no exception | AC-3 (US3#3) | example | DONE | `example/integration_test/lifecycle_test.dart › plugin registration works without an Activity` |
| A10 | Windows WebView2: read-only user-data dir - initialisation completes without exception | AC-4 (US4#1) | example | PENDING | `example/integration_test/lifecycle_test.dart::Windows WebView2 read-only` (skip:true — Windows host required) |
| A11 | Windows WebView2: read-only dir - navigation completes or fails gracefully | AC-4 (US4#2) | example | PENDING | `example/integration_test/lifecycle_test.dart::Windows WebView2 read-only` (skip:true — Windows host required) |
| A12 | Windows WebView2: fallback writable dir selected when default unavailable | AC-4 (US4#3) | example | PENDING | `example/integration_test/lifecycle_test.dart::Windows WebView2 read-only` (skip:true — Windows host required) |

## Inner loop: unit behaviors

No `plan.md` exists for this feature. Inner-loop behaviors will be derived when a plan is created. Running in `outer-only` mode per workflow rules.

### Invariants and edge cases still to place

Behaviors that belong to the feature but do not yet have a home component. Each must become a numbered line above before the feature is done, or be dropped with a reason.

- Multiple WebViews during recreation: channel re-binding must be per-instance, not global (Edge Case)
- Cold start vs warm restart distinction: tests must not produce false negatives (Edge Case)

## Out of scope

Things a reader may expect on this list and the one-line reason they are absent.

- iOS-specific lifecycle tests: not mentioned in issue #228, Android/Windows only per spec
- Load/performance benchmarks: no requirement, no test
- HeadlessInAppWebView dispose patterns: already covered in existing lifecycle_test.dart (P1 of dispose-pattern epic)
- InAppLocalhostServer dispose: already covered in existing lifecycle_test.dart

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` at planning time, so this file is readable on its own:

- Single test: `flutter test {file} --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`
- Mutation (changed files): N/A — mutation_test package absent