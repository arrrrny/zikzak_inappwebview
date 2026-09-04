---
feature: 309-macos-domexception-crash
loop: inside-out
profile: .specify/memory/tdd-profile.md
spec_criteria: 5
planned_at: 4dbe3171
updated_at: 4dbe3171
suite_baseline: green
---

# Test List — 309-macos-domexception-crash

The crashing behavior lives in macOS-only Swift (`WeakScriptMessageHandler`,
`InAppWebView.userContentController(_:didReceive:)`). The development environment
for this fix is Linux (no macOS SDK, no WebKit, no Xcode), so WebKit-level
behaviors cannot execute here. Behaviors are classified honestly: the runnable
gates (analyze/format/test in the touched Dart packages) are `RUNNABLE`; the
WebKit-level behaviors are `MACOS-ONLY` and are recorded as `NOT_EXECUTED` in the
cycle log with the exact commands a macOS maintainer/CI must run. This list does
not invent runnable tests to fake red/green for Swift code that cannot link here.

## Behaviors

| ID | Criterion | Behavior | Kind | Level | Test / Gate | Status |
| --- | --- | --- | --- | --- | --- | --- |
| B1 | AC1 | A script message whose body deserialization throws does not crash the process; the exception is contained at the ObjC boundary in `WeakScriptMessageHandler` | behavior | unit (Swift, macOS) | macOS-only: Xcode XCTest on `WeakScriptMessageHandlerTests` (commands in cycle-log C2) | MACOS-ONLY / NOT_EXECUTED |
| B2 | AC2 | On deserialization failure Dart receives a normal string error (`onConsoleMessage`, level 3) containing the handler name | behavior | unit (Swift→Dart, macOS) | macOS-only (cycle-log C2) | MACOS-ONLY / NOT_EXECUTED |
| B3 | AC3 | Bodies/leaves not expressible in the Flutter standard message codec (DOMException results, NSDate, URL, opaque objects, unsupported nested leaves) are recursively converted to string representation before `invokeMethod` | behavior | unit (Swift, macOS) | macOS-only (cycle-log C2) | MACOS-ONLY / NOT_EXECUTED |
| B4 | AC3 | Legitimate plugin traffic (JSON-string `callHandler` bodies, `[String: Any]` console bodies) passes through sanitization unchanged in shape | behavior | unit (Swift, macOS) | macOS-only (cycle-log C2) | MACOS-ONLY / NOT_EXECUTED |
| B5 | AC4 | Only `zikzak_inappwebview_macos/**` files changed vs `master` | gate | repo | `git diff --name-only master...` | RUNNABLE |
| B6 | AC5 | `flutter analyze` exits 0 in `zikzak_inappwebview_macos` | gate | package | `cd zikzak_inappwebview_macos && flutter analyze` | RUNNABLE |
| B7 | AC5 | `flutter test` all-green in `zikzak_inappwebview_macos` | gate | package | `cd zikzak_inappwebview_macos && flutter test` | RUNNABLE |
| B8 | AC5 | `flutter analyze` exits 0 in `zikzak_inappwebview` (umbrella) | gate | package | `cd zikzak_inappwebview && flutter analyze` | RUNNABLE |
| B9 | AC5 | `flutter test` all-green in `zikzak_inappwebview` (umbrella) | gate | package | `cd zikzak_inappwebview && flutter test` | RUNNABLE |
| B10 | AC5 | Changed Swift files parse cleanly (syntax gate; no Swift toolchain can typecheck WebKit targets on Linux) | gate | file | `swiftc -parse` if available on host, else documented absence | RUNNABLE* |
| B11 | AC1–AC3 | WebKit-level red→green: DOMException posted through the bridge crashes before the fix and does not crash after | behavior | integration (macOS app) | macOS-only repro in cycle-log C1 | MACOS-ONLY / NOT_EXECUTED |
