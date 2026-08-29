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
| A1 | Calling dispose() on a HeadlessInAppWebView before run() releases platform resources exactly once with no leak | US1-AC1, FR-004 | example | PENDING | |
| A2 | Calling dispose() twice on a started HeadlessInAppWebView invokes platform dispose only once (idempotent) | US1-AC2, FR-004, FR-008 | example | PENDING | |
| A3 | Concurrent or repeated dispose() calls on HeadlessInAppWebView never throw and never leak | US1-AC3, FR-008 | example | PENDING | |
| A4 | InAppWebViewController, InAppWebView, InAppLocalhostServer, and HeadlessInAppWebView all declare implements Disposable | US2-AC1, FR-002 | example | DONE | test/disposable_pattern_test.dart |
| A5 | dispose() on any wrapper forwards to platform dispose(isKeepAlive: ...) with the same default parameter | US2-AC2, FR-005, FR-006 | example | PENDING | |
| A6 | InAppLocalhostServer.dispose() stops the server if running, releases resources, and is idempotent | US2-AC3, FR-003 | example | PENDING | |
| A7 | dispose(isKeepAlive: true) on a keep-alive-backed controller releases Dart-side resources but retains native view | US3-AC1, FR-007 | example | PENDING | |
| A8 | Subsequent dispose() without keep-alive on a keep-alive controller fully releases native view | US3-AC2, FR-007 | example | PENDING | |
| A9 | isKeepAlive default (false) and semantics are identical across all disposable wrappers | US3-AC3, FR-005, FR-007 | example | PENDING | |

## Inner loop: unit behaviors

Grouped by the component from plan.md that owns them. Since plan.md is absent, we derive component boundaries from spec.md wrapper classes.

### `zikzak_inappwebview/lib/src/in_app_webview/headless_in_app_webview.dart`

| id | behavior | traces | kind | state | test |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U1 | HeadlessInAppWebView.dispose() before run() sets internal disposed flag and calls platform.dispose(isKeepAlive: false) once | FR-004, FR-008, FR-009 | example | DONE | test/headless_dispose_guard_test.dart |
| U2 | HeadlessInAppWebView.dispose() after run() sets disposed flag and calls platform.dispose(isKeepAlive: false) once | FR-004, FR-008 | example | PENDING | |
| U3 | Second dispose() call on HeadlessInAppWebView is a no-op (does not call platform.dispose again) | FR-004, FR-008 | example | DONE | test/headless_dispose_guard_test.dart |
| U4 | dispose(isKeepAlive: true) forwards true to platform.dispose(isKeepAlive: true) | FR-005, FR-006, FR-007 | example | DONE | test/headless_dispose_guard_test.dart |
| U5 | dispose(isKeepAlive: false) after dispose(isKeepAlive: true) calls platform.dispose(isKeepAlive: false) and fully releases | FR-007, FR-008 | example | PENDING | |
| U6 | Concurrent dispose() calls are serialized and platform.dispose() invoked at most once | FR-008, FR-009 | example | DONE | test/headless_dispose_guard_test.dart |

### `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview_controller.dart`

| id | behavior | traces | kind | state | test |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U7 | InAppWebViewController implements Disposable with canonical signature | FR-001, FR-002, FR-005 | example | DONE | test/disposable_pattern_test.dart |
| U8 | InAppWebViewController.dispose({bool isKeepAlive = false}) forwards to platform.dispose(isKeepAlive: ...) | FR-006 | example | PENDING | |
| U9 | isKeepAlive semantics: true retains native view, subsequent false releases it | FR-007 | example | PENDING | |

### `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview.dart`

| id | behavior | traces | kind | state | test |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U10 | InAppWebView implements Disposable with canonical signature | FR-001, FR-002, FR-005 | example | DONE | test/disposable_pattern_test.dart |
| U11 | InAppWebView.dispose({bool isKeepAlive = false}) forwards to platform.dispose(isKeepAlive: ...) | FR-006 | example | PENDING | |
| U12 | isKeepAlive semantics consistent with InAppWebViewController | FR-007 | example | PENDING | |

### `zikzak_inappwebview/lib/src/in_app_localhost_server.dart`

| id | behavior | traces | kind | state | test |
| --- | --------------------------------------------------------- | ---------- | -------- | ------- | -------------------------------------- |
| U13 | InAppLocalhostServer implements Disposable with canonical signature | FR-001, FR-002, FR-003, FR-005 | example | DONE | test/disposable_pattern_test.dart |
| U14 | dispose() on running server calls close() and marks disposed (fire-and-forget, swallows errors) | FR-003, FR-008 | example | DONE | test/in_app_localhost_server_dispose_test.dart |
| U15 | dispose() on non-running server marks disposed without error | FR-003, FR-008, FR-009 | example | DONE | test/in_app_localhost_server_dispose_test.dart: U15: dispose() on a non-running server marks it disposed and does not close it |
| U16 | Second dispose() call is a no-op (idempotent) | FR-003, FR-008 | example | PENDING | |
| U17 | dispose(isKeepAlive: ...) signature accepted but flag has no effect on server behavior | FR-005, FR-011 | example | PENDING | |

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