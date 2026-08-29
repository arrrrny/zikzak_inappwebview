# Feature Specification: Standardize Dispose Patterns Across Wrapper Classes + HeadlessInAppWebView Double-Dispose Guard

**Feature Branch**: `013-standardize-dispose-patterns`

**Created**: 2026-08-22

**Status**: Draft

**Input**: GitHub issue #227 (sub-issue of epic #161 "Architecture & tech debt reduction"). The plugin has a `Disposable` interface at the platform level, already implemented by several platform classes (e.g. `PlatformInAppWebViewController`, `PlatformWebViewEnvironment`, `PlatformCookieManager`), but the public wrapper classes are inconsistent: the wrappers (`InAppWebViewController`, `InAppWebView`) do not implement `Disposable`, `InAppLocalhostServer` has no `dispose()` at all, and `HeadlessInAppWebView` lacks double-dispose protection — calling `dispose()` before `run()` completes can silently leak because its internal running flag is still false and the dispose call returns early. The goal is to make every disposable wrapper class consistently implement `Disposable` with a uniform `dispose({bool isKeepAlive = false})` signature, give `InAppLocalhostServer` a proper `dispose()`, and harden `HeadlessInAppWebView` so disposal is idempotent and safe before, during, and after `run()`, while keeping `isKeepAlive` behavior consistent everywhere.

## User Scenarios & Testing

### User Story 1 - Idempotent and leak-safe HeadlessInAppWebView disposal (Priority: P1)

A developer creates a `HeadlessInAppWebView`, starts it with `run()`, and later calls `dispose()`. To avoid crashes and resource leaks in real apps (where disposal can race with async startup, widget teardown, or be invoked more than once defensively), the headless web view must be fully released whether `dispose()` is called before `run()`, while running, or after running, and calling `dispose()` multiple times must be a safe no-op after the first call.

**Why this priority**: This is the core defect called out in the issue (a real-world leak path) and is labeled P1 in the parent epic. Unreleased headless web views leak native/JS resources and are hard to diagnose, so the guard must be correct before any cosmetic standardization.

**Independent Test**: Can be tested in isolation with a fake platform implementation — construct a `HeadlessInAppWebView`, call `dispose()` without ever calling `run()`, then call `dispose()` again, and assert the underlying platform `dispose()` is invoked once and no unclosed resources remain; repeat the matrix with `run()` first.

**Acceptance Scenarios**:

1. **Given** a `HeadlessInAppWebView` that has not yet been started, **When** `dispose()` is called, **Then** the underlying platform resources are released exactly once and no web view is left running.
2. **Given** a started `HeadlessInAppWebView`, **When** `dispose()` is called and then `dispose()` is called again, **Then** the second call is a no-op and the platform `dispose()` is invoked only once.
3. **Given** a `HeadlessInAppWebView` in any lifecycle state, **When** `dispose()` is invoked concurrently or repeatedly, **Then** it never throws and never leaks a partially-disposed instance.

---

### User Story 2 - Consistent Disposable contract on all wrapper classes (Priority: P2)

A developer writes generic code that holds a collection of disposable objects (or uses a `keepAlive`-based cache) and wants every public wrapper — `InAppWebViewController`, `InAppWebView`, `InAppLocalhostServer`, `HeadlessInAppWebView`, and any other wrapper exposing native resources — to be substitutable behind the `Disposable` interface with the same `dispose({bool isKeepAlive = false})` signature. This lets them rely on a single contract rather than memorizing per-class disposal quirks.

**Why this priority**: Standardization removes a whole class of integration bugs and makes the public API predictable; it is lower risk than the leak fix but still a primary item since the issue is specifically about wrapper-class inconsistency.

**Independent Test**: Can be tested by a compile-time/static assertion that each enumerated wrapper type is assignable to `Disposable`, plus a runtime test that invoking `dispose()` on each wrapper forwards to the platform implementation with the same default parameter shape.

**Acceptance Scenarios**:

1. **Given** the public wrappers `InAppWebViewController`, `InAppWebView`, `InAppLocalhostServer`, and `HeadlessInAppWebView`, **When** their declarations are inspected, **Then** each is declared `implements Disposable`.
2. **Given** any such wrapper, **When** its `dispose()` is invoked, **Then** the call forwards to the corresponding platform `dispose({bool isKeepAlive = false})` with the same default parameter.
3. **Given** `InAppLocalhostServer`, **When** it is no longer needed, **Then** calling `dispose()` stops the server (if running) and releases its resources, and is idempotent.

---

### User Story 3 - Consistent keepAlive semantics everywhere (Priority: P3)

A developer uses `dispose(isKeepAlive: true)` to release a controller's Dart-side resources while keeping the underlying platform/native web view alive for reuse (the documented keep-alive use case). They expect the same `isKeepAlive` meaning and behavior across every disposable wrapper, so a `keepAlive` controller is never torn down by a plain `dispose()` call and a subsequent `dispose()` without keep-alive actually frees it.

**Why this priority**: Keeps the standard contract coherent and prevents subtle cross-class behavioral drift, but it is a consistency guarantee layered on top of the two higher-priority, leak-focused changes.

**Independent Test**: Can be tested by disposing a keep-alive-backed controller with `isKeepAlive: true`, asserting the native view survives, then disposing again without keep-alive and asserting full teardown — repeated across the wrapper classes that support keep-alive.

**Acceptance Scenarios**:

1. **Given** a controller created with an `InAppWebViewKeepAlive`, **When** `dispose(isKeepAlive: true)` is called, **Then** Dart-side references are released but the native web view remains usable.
2. **Given** the same keep-alive controller, **When** a subsequent `dispose()` (without keep-alive) is called, **Then** the native web view is fully released.
3. **Given** any disposable wrapper, **When** `isKeepAlive` defaults are compared, **Then** the default value (`false`) and the interpretation of the flag are identical across all implementations.

---

### Edge Cases

- **Dispose before run**: Calling `dispose()` on a `HeadlessInAppWebView` that was never started (or whose `run()` Future has not completed) must still release resources and must not early-return leaving a leak.
- **Double dispose**: A second `dispose()` on any wrapper must be a safe no-op; platform `dispose()` must be invoked at most once.
- **Concurrent dispose**: Overlapping `dispose()` calls (e.g., from `State.dispose` and a manual call) must not double-free or throw.
- **InAppLocalhostServer not started**: `dispose()` on a server that was never `start()`ed must be safe and idempotent.
- **InAppLocalhostServer shutting down async**: If `close()` is asynchronous, `dispose()` must not surface the in-flight close Future as an unhandled error and must still mark the instance disposed.
- **keepAlive interaction with double dispose**: A `dispose(isKeepAlive: true)` followed by a plain `dispose()` must end in full teardown, not leave a half-released keep-alive view.
- **Wrapper wrapping an already-disposed platform**: Forwarding `dispose()` to a platform object that is already disposed must be tolerated (no crash) and idempotent.

## Requirements

### Functional Requirements

- **FR-001**: The system MUST define a single `Disposable` interface with the signature `void dispose({bool isKeepAlive = false})` and use it as the canonical disposal contract.
- **FR-002**: The system MUST ensure every public wrapper class that owns native or platform resources — at minimum `InAppWebViewController`, `InAppWebView`, `InAppLocalhostServer`, and `HeadlessInAppWebView` — declares `implements Disposable`.
- **FR-003**: `InAppLocalhostServer` MUST expose a `dispose({bool isKeepAlive = false})` method that stops the server if running, releases its resources, and is idempotent.
- **FR-004**: `HeadlessInAppWebView` MUST implement double-dispose protection such that `dispose()` is idempotent and safe whether it is called before `run()`, during `run()`, or after `run()` completes, with no resource leak in any of these states.
- **FR-005**: The system MUST standardize the `dispose({bool isKeepAlive = false})` signature and default parameter across all `Disposable` implementations (wrappers and platform classes) so the contract is uniform.
- **FR-006**: `Disposable.dispose()` MUST forward to the underlying platform `dispose(isKeepAlive: ...)` consistently, preserving the `isKeepAlive` value passed by the caller.
- **FR-007**: `isKeepAlive` semantics MUST be identical and consistently interpreted across all disposable wrappers: `true` releases Dart-side ownership while retaining the native view, and the next non-keep-alive `dispose()` must fully release it.
- **FR-008**: Repeated or concurrent `dispose()` calls on any wrapper MUST NOT throw, MUST NOT double-invoke the platform disposal, and MUST NOT leak resources.
- **FR-009**: The disposal guard MUST tolerate a `dispose()` call that targets an already-disposed or never-started platform resource without error.

### Key Entities

- **Disposable**: The canonical interface (`dispose({bool isKeepAlive = false})`) implemented by disposable types across the plugin.
- **Wrapper classes**: The public Dart API classes that delegate to platform implementations — `InAppWebViewController`, `InAppWebView`, `InAppLocalhostServer`, `HeadlessInAppWebView`.
- **Platform implementations**: The platform-interface classes (e.g. `PlatformInAppWebViewController`, `PlatformHeadlessInAppWebView`, `PlatformInAppLocalhostServer`) that perform the actual native/JS resource release.
- **isKeepAlive flag**: A boolean passed to `dispose()` indicating whether the native web view should be retained for reuse after Dart-side release.
- **InAppWebViewKeepAlive**: The token/object used to create a keep-alive-backed controller whose lifecycle differs from a standard controller.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Every public wrapper class that owns platform resources is statically assignable to `Disposable`, verifiable by a compile-time/static check in the test suite.
- **SC-002**: Calling `dispose()` on a `HeadlessInAppWebView` before `run()` completes, after `run()`, and twice in a row each results in exactly one platform `dispose()` invocation and zero leaked running web views (asserted by tests).
- **SC-003**: `InAppLocalhostServer.dispose()` reliably stops the server and is idempotent — a second call is a no-op and never errors.
- **SC-004**: The `dispose({bool isKeepAlive = false})` signature, including the default value and meaning of `isKeepAlive`, is identical across all disposable implementations, confirmed by shared tests/assertions.
- **SC-005**: A `dispose(isKeepAlive: true)` followed by a plain `dispose()` on a keep-alive-backed controller fully releases the native view and is reproducible across the wrappers that support keep-alive.
- **SC-006**: No new analyzer warnings, no `UnimplementedError` thrown by disposal in normal or repeated-dispose paths, and the disposal tests for double-dispose, dispose-before-run, and keep-alive consistency all pass.

## Assumptions

- A `Disposable` interface already exists in the platform-interface package and is the intended canonical contract; the change extends/uses it rather than introducing a new one.
- The platform implementations already expose a `dispose({bool isKeepAlive = false})` method that performs the real resource release; wrapper changes are about forwarding and guarding, not reimplementing native teardown.
- `HeadlessInAppWebView` internally tracks running state via `run()`/`isRunning()`; the fix relies on an explicit disposed flag rather than the running flag to decide whether disposal has occurred.
- `InAppLocalhostServer` exposes `start()`, `close()`, and `isRunning()` so `dispose()` can stop it when active and tolerate asynchronous shutdown.
- `isKeepAlive` is only meaningful for web-view-backed controllers; for non-web-view wrappers (e.g. `InAppLocalhostServer`) the flag is accepted for signature uniformity but does not alter behavior.
- Tests run against platform fakes/mocks (since native web views cannot be exercised in the Dart test runner), so assertions focus on call counts and state flags rather than live rendering.
