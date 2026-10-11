# Feature Specification: WebViewPool — Mission-Scoped Sessions, Domain Affinity, and Memory-Pressure Disposal

**Feature Branch**: `[007-webview-pool-sessions]`

**Created**: 2026-08-22

**Status**: Draft

**Input**: ZikZak AI's `webview.*` tool layer drives headless web view instances from an agent loop. Web views are heavyweight (10–50 MB each; iOS tolerates only a handful live), agent tool sequences are naturally stateful (browse → intercept → execute_js → cookies), and parallel missions will otherwise leak web views. The user requests a `WebViewPool` foundation that (1) acquires/releases headless web view instances keyed by a per-mission session handle rather than by URL; (2) reuses a warm instance for the same eTLD+1 (domain affinity) to preserve cookies and JS state; (3) enforces per-pool caps (max live instances with platform-aware defaults, max per domain, idle TTL eviction) and disposes idle instances first under memory pressure via a Flutter lifecycle listener; (4) exposes a session API — `acquire(sessionId, domainHint)`, `release(sessionId)`, `disposeAll()`, plus introspection (`liveCount`, `sessions()`); (5) is thread-safe so concurrent acquisitions from the agent loop do not race-create instances; (6) lets each acquisition compose caller-provided `InAppWebViewSettings` (network capture filters, dialogue dismissal); and (7) ships as pure plugin-level public API + docs with no dependency on MCP/zuraffa types. It must also be shared with the external `dart_web_scraper` web view fetch path so a single mission never double-renders a page.

## User Scenarios & Testing

### User Story 1 - Acquire and release mission-scoped sessions (Priority: P1)

An agent developer issues a mission and obtains a session handle (`sessionId`). For every step of the mission (browse, intercept, execute JS, read cookies) they call `acquire(sessionId, domainHint)` and receive the same underlying headless web view instance, then call `release(sessionId)` when the mission ends. The pool guarantees exactly one live instance per active session handle, keeping cookies and JavaScript execution state consistent across the mission's tool calls.

**Why this priority**: This is the core contract the entire `webview.*` tool layer and the `dart_web_scraper` fetch path build on. Without keying instances by session handle, parallel missions leak web views and lose state — the central defect the feature exists to fix.

**Independent Test**: Drive the public pool API directly (no MCP layer) — call `acquire` twice with the same `sessionId`, assert the returned instance identity is equal, run a second `acquire`/`release` cycle, and assert `liveCount` returns to zero after `release`/`disposeAll`.

**Acceptance Scenarios**:

1. **Given** the pool has no instance for session `S`, **When** `acquire(S, "example.com")` is called, **Then** a new headless web view instance is created and returned, and `liveCount` becomes 1.
2. **Given** session `S` holds a live instance, **When** `acquire(S, "example.com")` is called again, **Then** the same instance reference is returned and no second instance is created.
3. **Given** session `S` is live, **When** `release(S)` is called, **Then** the instance is returned to the pool as idle, `sessions()` no longer lists `S` as active, and `liveCount` reflects the change.
4. **Given** multiple sessions `S1`..`Sn` are live, **When** `disposeAll()` is called, **Then** every live and idle instance is disposed and `liveCount` returns 0.

---

### User Story 2 - Domain affinity preserves warm state (Priority: P1)

When a mission re-acquires for the same eTLD+1 (e.g., `app.example.com` and `shop.example.com`), the pool prefers a warm idle instance already scoped to `example.com` so the page's cookies and JS context survive. If no warm instance for that domain exists, the pool creates or reuses a generic idle instance and re-scopes it to the domain hint on navigation.

**Why this priority**: Domain affinity is what makes stateful agent sequences (browse → intercept → execute_js → cookies) work without re-authenticating on every step, and it directly satisfies the requirement that a single mission never double-renders a page when shared with the scraper path.

**Independent Test**: Acquire a session for `example.com`, set a cookie / JS state, release it; then acquire a new session with domain hint `example.com` (or `app.example.com`, same eTLD+1) and assert the warm instance is reused and the cookie/JS state persists. A second test with a different eTLD+1 asserts a non-affine instance is used instead.

**Acceptance Scenarios**:

1. **Given** an idle instance previously scoped to eTLD+1 `example.com`, **When** `acquire(S2, "app.example.com")` is called, **Then** the pool returns that warm instance (affinity hit) rather than creating a new one.
2. **Given** a session with a cookie set on `example.com`, **When** a subsequent affine acquisition for the same eTLD+1 reuses the instance, **Then** the cookie and JS execution context remain available to the caller.
3. **Given** no idle instance for the requested eTLD+1, **When** `acquire(S, "other.org")` is called, **Then** an available generic idle instance is reused and re-scoped to `other.org`, or a new instance is created if none is idle.
4. **Given** the pool records affinity, **When** `sessions()` introspection is queried, **Then** each returned entry reports its current eTLD+1 domain association.

---

### User Story 3 - Caps, TTL eviction, and memory-pressure disposal (Priority: P2)

The pool enforces platform-aware caps (max live instances, max per domain) and an idle TTL. When the process is backgrounded or the OS signals memory pressure, an `AppLifecycleListener` callback disposes idle instances first, leaving active (in-use) sessions intact. If the live cap is exceeded because more domains are active than the cap allows, the oldest idle instance is evicted before any active one.

**Why this priority**: This prevents the iOS/Android/macOS crash and OOM failure modes described in the issue (a handful of live web views on iOS), but it is a protective safeguard layered on the core session contract in P1.

**Independent Test**: Configure a low cap in a test harness, drive acquisitions past the cap plus a long idle TTL, and assert that idle instances are evicted (TTL) and that a simulated background/low-memory lifecycle event disposes idle instances first while an actively-acquired session survives.

**Acceptance Scenarios**:

1. **Given** the idle TTL has elapsed for an idle instance, **When** the eviction sweep runs, **Then** that idle instance is disposed and `liveCount` decreases.
2. **Given** the pool has reached the max-per-domain cap for `example.com`, **When** an affine `acquire` exceeds it, **Then** the oldest idle `example.com` instance is evicted to make room rather than exceeding the cap.
3. **Given** one instance is actively acquired (in use) and several are idle, **When** a memory-pressure / lifecycle pause event fires, **Then** the idle instances are disposed first and the active instance remains usable.
4. **Given** platform-aware defaults, **When** the pool initializes on each target platform (iOS/Android/macOS/Web/Linux/Windows), **Then** the effective max-live cap is appropriate for that platform (lower on memory-constrained mobile, higher where allowed).

---

### User Story 4 - Concurrent acquisition safety (Priority: P2)

The agent loop fires many tool calls in parallel. Multiple `acquire` calls for the same or different `sessionId`s arriving simultaneously must not create duplicate instances or corrupt pool state.

**Why this priority**: Race conditions in the pool would silently recreate the leak the feature is meant to prevent and are hard to diagnose in production; correctness under concurrency is a prerequisite for the multi-mission use case.

**Independent Test**: Spawn N concurrent `acquire` calls for the same `sessionId` (and a second batch for distinct ids) and assert exactly one instance exists per distinct id afterwards, with `liveCount` equal to the number of distinct ids and no duplicate-create observed.

**Acceptance Scenarios**:

1. **Given** K concurrent `acquire(S, …)` calls for the same session, **When** all complete, **Then** exactly one instance is created and `liveCount` reflects a single live session for `S`.
2. **Given** concurrent acquisitions across M distinct sessions under contention, **When** they complete, **Then** `liveCount` equals M and `sessions()` lists all M with no shared/aliased instances.
3. **Given** a high-contention burst, **When** it completes, **Then** no exception or deadlock occurs and introspection (`liveCount`, `sessions()`) remains consistent.

---

### User Story 5 - Per-acquisition configuration composition (Priority: P3)

Each `acquire` call accepts caller-provided `InAppWebViewSettings` (e.g., network capture filters, dialogue dismissal) so a mission can tune its session without affecting other sessions in the pool. The composed settings are applied to the issued instance at acquisition time.

**Why this priority**: Important for the `webview.*` tool provider and capture workflows, but it layers on top of the already-required session/affinity/cap behavior; it does not block the foundational contract.

**Independent Test**: Acquire two sessions with different `InAppWebViewSettings`, then inspect each issued instance's effective settings and assert they differ as supplied and do not bleed into the other session.

**Acceptance Scenarios**:

1. **Given** an `acquire` call passes `InAppWebViewSettings` with capture filters enabled, **When** the instance is issued, **Then** those settings are applied to that instance only.
2. **Given** a second `acquire` for a different session passes different settings, **When** both are live, **Then** each instance retains only its own supplied configuration.
3. **Given** an acquisition with no settings override, **When** the instance is issued, **Then** it uses the pool's default base configuration.

---

### Edge Cases

- **Same session acquired after `disposeAll()`**: `acquire` for a previously-disposed session must create a fresh instance; the pool must not resurrect disposed state.
- **Release of an unknown / never-acquired sessionId**: `release` on an unknown handle must be a safe no-op and not throw or corrupt introspection.
- **`acquire` and `release` for the same id racing**: re-entrant acquire/release must remain consistent (e.g., release during an in-flight acquire for the same id resolves to the correct final state).
- **Memory-pressure event while an instance is actively in use**: the pool must never dispose an in-use instance; only idle instances are evicted, and active sessions keep working.
- **Domain hint omitted / null**: pool treats it as a generic (non-affine) acquisition and may still reuse any idle instance, just without affinity preference.
- **eTLD+1 extraction for unusual registries (multi-part TLDs, IP addresses, localhost)**: the affinity key must degrade gracefully (e.g., treat IP/localhost as exact-match) rather than throwing.
- **Platforms without a real lifecycle/memory signal (Web/Windows/Linux)**: the memory-pressure hook is a no-op or best-effort; caps and TTL still apply so behavior is safe everywhere.
- **`sessions()`/introspection called concurrently with mutations**: introspection must return a consistent snapshot without throwing.

## Requirements

### Functional Requirements

- **FR-001**: The system MUST expose a `WebViewPool` singleton that acquires and releases `HeadlessInAppWebView` instances keyed by a caller-supplied `sessionId` string (one handle per mission), not by URL.
- **FR-002**: The system MUST implement domain affinity such that an idle instance already associated with the requested eTLD+1 is preferred (reused) over creating a new instance, preserving cookies and JS execution state for the mission.
- **FR-003**: The system MUST enforce per-pool caps including a platform-aware maximum number of live instances, a maximum number of instances per eTLD+1 domain, and an idle TTL after which idle instances are evicted.
- **FR-004**: The system MUST provide a memory-pressure / lifecycle hook (via Flutter `AppLifecycleListener` or equivalent platform-aware signal) that disposes idle instances before any actively-acquired instance when memory is constrained or the app is backgrounded.
- **FR-005**: The system MUST provide the session API `acquire(sessionId, domainHint)`, `release(sessionId)`, and `disposeAll()`, returning an instance from `acquire` and guaranteeing exactly one live instance per active session handle.
- **FR-006**: The system MUST provide introspection `liveCount` and `sessions()` that report the current number of live instances and the set of active sessions (with their domain associations) in a consistent manner.
- **FR-007**: The system MUST be thread-safe so concurrent `acquire`/`release` calls from a multi-mission agent loop cannot race-create duplicate instances, leak instances, or corrupt pool state.
- **FR-008**: The system MUST allow each `acquire` call to supply caller-provided `InAppWebViewSettings` (e.g., network capture filters, dialogue dismissal) that are composed onto the issued instance without affecting other sessions in the pool.
- **FR-009**: The system MUST treat `release`/`disposeAll` on unknown or already-disposed handles as safe no-ops, and `acquire` after disposal MUST return a fresh instance.
- **FR-010**: The system MUST be exposed as a pure plugin-level public API with documentation, with no dependency on MCP or `zuraffa` types, and MUST be usable from an external consumer (e.g., `dart_web_scraper`'s web view client) via a session handle so a single mission never double-renders a page.

### Key Entities

- **WebViewPool**: The singleton manager that owns the live/idle instance sets, affinity map, caps, TTL timer, and lifecycle hook, and implements the session API and introspection.
- **sessionId (session handle)**: A caller-issued string identifying one mission; the key used to acquire/release a dedicated headless web view instance.
- **HeadlessInAppWebView instance**: The heavyweight headless web view object the pool creates, hands out, reuses, and disposes.
- **eTLD+1 / domainHint**: The effective top-level-domain-plus-one key used for affinity; derived from the `domainHint` supplied at acquire time.
- **InAppWebViewSettings**: The caller-supplied configuration (capture filters, dialogue dismissal, etc.) composed onto a pool-issued instance per acquisition.
- **Idle TTL / caps**: Pool policy values (max live, max per domain, idle timeout) with platform-aware defaults; an eviction sweep applies them.

## Success Criteria

### Measurable Outcomes

- **SC-001**: A simulated 20-mission run with browse→intercept→execute_js→cookies sequences leaves zero leaked instances, verified by asserting `liveCount == 0` (and `sessions()` empty) after all missions `release`/`disposeAll`.
- **SC-002**: Concurrent acquisitions for the same `sessionId` (≥10 in parallel) result in exactly one live instance for that id and no duplicate-create events; `liveCount` equals the number of distinct ids.
- **SC-003**: An affine re-acquisition for the same eTLD+1 reuses a warm idle instance and preserves at least one cookie or JS-state artifact across the acquisition boundary (measured via introspection/round-trip).
- **SC-004**: Under the idle TTL, idle instances are evicted and `liveCount` decreases accordingly; under a simulated memory-pressure/lifecycle event, idle instances are disposed before any actively-acquired instance, which remains usable.
- **SC-005**: Per-pool caps are never exceeded: live instances ≤ platform-aware max and per-domain instances ≤ max-per-domain, even under burst acquisition past the cap.
- **SC-006**: Pool introspection (`liveCount`, `sessions()`) consistently reflects pool state across concurrent acquire/release and never throws under contention.
- **SC-007**: Per-acquisition `InAppWebViewSettings` are applied to the issued instance only and do not bleed into other sessions in the pool (verified by comparing effective settings across two sessions).
- **SC-008**: The feature is consumable as pure plugin-level public API (no MCP/zuraffa import required) and is documented with a public page and an example-app section demonstrating manual pool usage.

## Assumptions

- The agent loop issues a unique `sessionId` per mission and calls `release`/`disposeAll` when the mission ends; the pool's leak guarantee depends on well-behaved release, with TTL/eviction as a backstop for stragglers.
- `HeadlessInAppWebView` and `InAppWebViewSettings` already exist in the plugin and are the instance/configuration types the pool issues and composes; the pool does not redefine them.
- eTLD+1 extraction can rely on a standard public-suffix-aware approach (or a pragmatic heuristic) and degrades to exact-match for IPs/localhost/unknown registries without throwing.
- Platform-aware cap defaults are configurable; the feature ships with sensible per-platform defaults (lower on iOS/Android, higher where the platform permits) and lets consumers override them.
- The memory-pressure/lifecycle signal is available on iOS/Android/macOS via Flutter's `AppLifecycleListener`; on Web/Windows/Linux it is best-effort or no-op, while caps and TTL still provide safety.
- `dart_web_scraper` and the `webview.*` tool provider integrate by calling the pool's public session API with a session handle; the pool itself contains no MCP/zuraffa coupling and exposes only the plugin-level contract.
- The pool lives in the umbrella plugin / shared web view module as a pure-Dart singleton so it can be reached from both the in-app web view tooling and external consumers within the same process.
