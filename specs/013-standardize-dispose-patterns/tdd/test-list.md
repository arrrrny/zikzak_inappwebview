---
feature: 013-standardize-dispose-patterns
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 9
planned_at: abfa842e
updated_at: abfa842e
suite_baseline: red
---

# Test List: Standardize Dispose Patterns Across Wrapper Classes + HeadlessInAppWebView Double-Dispose Guard

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md`. Each stays red until the feature works end to end through its real entry point.

| id | behavior | traces | kind | state | test |
| --- | ----------------------------------------------------------- | ------ | ------- | ------- | ------------------------------------------- |
| A1 | Calling dispose() on a HeadlessInAppWebView before run() releases platform resources exactly once with no leak | US1-AC1, FR-004 | example | DONE | subsumed by U1: test/headless_dispose_guard_test.dart (dispose before run forwards isKeepAlive:false once) |
| A2 | Calling dispose() twice on a started HeadlessInAppWebView invokes platform dispose only once (idempotent) | US1-AC2, FR-004, FR-008 | example | DONE | subsumed by U3: test/headless_dispose_guard_test.dart (second dispose a no-op) |
| A3 | Concurrent or repeated dispose() calls on HeadlessInAppWebView never throw and never leak | US1-AC3, FR-008 | example | DONE | subsumed by U6: test/headless_dispose_guard_test.dart (concurrent calls invoke platform at most once) |
| A4 | InAppWebViewController, InAppWebView, InAppLocalhostServer, and HeadlessInAppWebView all declare implements Disposable | US2-AC1, FR-002 | example | DONE | test/disposable_pattern_test.dart |
| A5 | dispose() on any wrapper forwards to platform dispose(isKeepAlive: ...) with the same default parameter | US2-AC2, FR-005, FR-006 | example | DONE | subsumed by U8 (controller), U11 (webview), U17 (server accepts signature) in test/in_app_webview_dispose_test.dart and test/in_app_localhost_server_dispose_test.dart |
| A6 | InAppLocalhostServer.dispose() stops the server if running, releases resources, and is idempotent | US2-AC3, FR-003 | example | DONE | subsumed by U14/U15/U16: test/in_app_localhost_server_dispose_test.dart |
| A7 | dispose(isKeepAlive: true) on a keep-alive-backed controller releases Dart-side resources but retains native view | US3-AC1, FR-007 | example | PENDING | device-only: keepAlive native-view retention is platform behavior not observable at the wrapper level with a fake platform; no integration_test harness exists (see Out of scope) |
| A8 | Subsequent dispose() without keep-alive on a keep-alive controller fully releases native view | US3-AC2, FR-007 | example | BLOCKED | conflicts with FR-008 idempotency guard (U3): a second dispose() is a no-op and never re-reaches the platform. Cannot be satisfied without removing the guard that U3/U6 require. See cycle-log note. |
| A9 | isKeepAlive default (false) and semantics are identical across all disposable wrappers | US3-AC3, FR-005, FR-007 | example | DONE | subsumed by U9 (controller) and U12 (webview) in test/in_app_webview_dispose_test.dart: both forward the actual flag, default false |

## Inner loop: unit behaviors

Grouped by the component from plan.md that owns them. Since plan.md is absent, we derive component boundaries from spec.md wrapper classes.

### `zikzak_inappwebview/lib/src/in_app_webview/headless_in_app_webview.dart`

| id | behavior | traces | kind | state | test |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U1 | HeadlessInAppWebView.dispose() before run() sets internal disposed flag and calls platform.dispose(isKeepAlive: false) once | FR-004, FR-008, FR-009 | example | DONE | test/headless_dispose_guard_test.dart |
| U2 | HeadlessInAppWebView.dispose() after run() sets disposed flag and calls platform.dispose(isKeepAlive: false) once | FR-004, FR-008 | example | DONE | test/headless_dispose_guard_test.dart: U2: dispose() after run() forwards to platform.dispose(isKeepAlive: false) exactly once |
| U3 | Second dispose() call on HeadlessInAppWebView is a no-op (does not call platform.dispose again) | FR-004, FR-008 | example | DONE | test/headless_dispose_guard_test.dart |
| U4 | dispose(isKeepAlive: true) forwards true to platform.dispose(isKeepAlive: true) | FR-005, FR-006, FR-007 | example | DONE | test/headless_dispose_guard_test.dart |
| U5 | dispose(isKeepAlive: false) after dispose(isKeepAlive: true) calls platform.dispose(isKeepAlive: false) and fully releases | FR-007, FR-008 | example | BLOCKED | conflicts with FR-008 idempotency guard (U3/U6): once disposed, a second dispose() returns early and never reaches the platform, so it cannot "fully release" via a second call. Resolving requires either dropping the idempotency guard (breaks U3/A2/A3) or a keepAlive-aware re-dispose path not present in the wrapper. Reported as a spec/impl conflict; no test written that would contradict the guard. |
| U6 | Concurrent dispose() calls are serialized and platform.dispose() invoked at most once | FR-008, FR-009 | example | DONE | test/headless_dispose_guard_test.dart |

### `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview_controller.dart`

| id | behavior | traces | kind | state | test |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U7 | InAppWebViewController implements Disposable with canonical signature | FR-001, FR-002, FR-005 | example | DONE | test/disposable_pattern_test.dart |
| U8 | InAppWebViewController.dispose({bool isKeepAlive = false}) forwards to platform.dispose(isKeepAlive: ...) | FR-006 | example | DONE | test/in_app_webview_dispose_test.dart: U8: InAppWebViewController.dispose(isKeepAlive: true) forwards to platform.dispose(isKeepAlive: true) |
| U9 | isKeepAlive semantics: true retains native view, subsequent false releases it | FR-007 | example | DONE | test/in_app_webview_dispose_test.dart: U9: a later dispose(isKeepAlive: false) after dispose(isKeepAlive: true) forwards false and fully releases |

### `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview.dart`

| id | behavior | traces | kind | state | test |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U10 | InAppWebView implements Disposable with canonical signature | FR-001, FR-002, FR-005 | example | DONE | test/disposable_pattern_test.dart |
| U11 | InAppWebView.dispose({bool isKeepAlive = false}) forwards to platform.dispose(isKeepAlive: ...) | FR-006 | example | DONE | test/in_app_webview_dispose_test.dart: U11: InAppWebView.dispose(isKeepAlive: true) forwards to platform.dispose(isKeepAlive: true) |
| U12 | isKeepAlive semantics consistent with InAppWebViewController | FR-007 | example | DONE | test/in_app_webview_dispose_test.dart: U12: a later InAppWebView.dispose(isKeepAlive: false) after keepAlive forwards false and fully releases |

### `zikzak_inappwebview/lib/src/in_app_localhost_server.dart`

| id | behavior | traces | kind | state | test |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U13 | InAppLocalhostServer implements Disposable with canonical signature | FR-001, FR-002, FR-003, FR-005 | example | DONE | test/disposable_pattern_test.dart |
| U14 | dispose() on running server calls close() and marks disposed (fire-and-forget, swallows errors) | FR-003, FR-008 | example | DONE | test/in_app_localhost_server_dispose_test.dart |
| U15 | dispose() on non-running server marks disposed without error | FR-003, FR-008, FR-009 | example | DONE | test/in_app_localhost_server_dispose_test.dart: U15: dispose() on a non-running server marks it disposed and does not close it |
| U16 | Second dispose() call is a no-op (idempotent) | FR-003, FR-008 | example | DONE | test/in_app_localhost_server_dispose_test.dart: U16: a second dispose() call on the server is a no-op (idempotent) |
| U17 | dispose(isKeepAlive: ...) signature accepted but flag has no effect on server behavior | FR-005, FR-011 | example | DONE | test/in_app_localhost_server_dispose_test.dart: U17: dispose(isKeepAlive: true) is accepted but has no effect on server behavior |

### `zikzak_inappwebview_platform_interface/lib/src/types/disposable.dart`

| id | behavior | traces | kind | state | test |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U18 | Disposable interface declares void dispose({bool isKeepAlive = false}) as the single canonical contract | FR-001, FR-005 | example | DONE | test/disposable_pattern_test.dart |

## Invariants and edge cases still to place

Behaviors that belong to the feature but do not yet have a home component. Each must become a numbered line above before the feature is done, or be dropped with a reason.

- Edge case: Dispose before run on HeadlessInAppWebView must not early-return leaving leak (covered by U1)
- Edge case: Double dispose on any wrapper is safe no-op (covered by U3, U16)
- Edge case: Concurrent dispose overlapping calls must not double-free or throw (covered by U6)
- Edge case: InAppLocalhostServer not started - dispose safe and idempotent (covered by U15)
- Edge case: InAppLocalhostServer async close - dispose does not surface unhandled error (covered by U14)
- Edge case: keepAlive interaction with double dispose - keepAlive then plain dispose ends in full teardown (covered by U5)
- Edge case: Wrapper forwarding to already-disposed platform must be tolerated (covered by U3, U9, U12, U16)

## Out of scope

Things a reader may expect on this list and the one-line reason they are absent.

- Platform-specific implementation changes (Android/iOS/Web native code): spec only covers wrapper Dart classes
- Adding Disposable to classes not listed (PlatformCookieManager, etc.): those are platform interfaces, not public wrappers
- Integration tests on real devices: no integration_test/ dir exists yet; unit tests use fakes per profile conventions

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` at planning time, so this file is readable on its own:

- Single test: `flutter test {file} --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`
- Mutation: null (not available in this stack)