# Feature Specification: WebView MCP Tool Provider (webview.* Tool Suite)

**Feature Branch**: `[009-webview-mcp-tool-provider]`

**Created**: 2026-08-22

**Status**: Draft

**Input**: GitHub issue #239 (slug `webview-mcp-tool-provider`). The user describes a need to surface the `zikzak_inappwebview` plugin's agent-facing capabilities — headless browsing, network interception/capture, cookies, dialogue dismissal, screenshots, PDF export, and recorded user flows ("recipes") — as a suite of MCP tools under the `webview` namespace, exposed through zuraffa's `McpToolProvider` SPI. The "browser tool suite" must let an autonomous agent act on unknown websites using a pooled webview instance, keep agent action sequences on a single session via a returned `sessionId`, degrade gracefully across search engines, enforce privacy and size discipline on results, honor mission cancellation with a salvage protocol, and be fully recordable/replayable for CI.

## User Scenarios & Testing

### User Story 1 - Browse a page and keep acting on the same webview (Priority: P1)

An agent calls `webview.browse(session, url)` to load a target page headlessly, wait until the page is idle, and receive a normalized result containing the page title, the finally-resolved URL, and an artifact reference to the rendered HTML. The result also carries a `sessionId` continuation token. The agent then calls further tools (`intercept_browse`, `execute_js`, etc.) passing that `sessionId` so the entire sequence of actions operates on the same pooled webview instance rather than spinning up a new browser each time. This keeps navigation state, cookies, and login sessions intact across steps.

**Why this priority**: Browsing is the foundational capability the whole suite is built on. Without reliable headless load, result normalization, and session continuity, every downstream tool (intercept, search, JS, recipes) has no instance to act against.

**Independent Test**: Stand up the provider against the agent kernel, call `webview.browse` with a test URL, and assert (a) the returned object contains `title`, `url`, and an `artifactRef` to HTML, and (b) a subsequent tool call reusing the returned `sessionId` reports operating on the same underlying webview instance (the pool asserts exactly one live webview for the sequence).

**Acceptance Scenarios**:

1. **Given** the provider is registered with the agent kernel, **When** the agent calls `webview.browse` with a valid URL, **Then** the result contains the page `title`, the resolved `url`, and an `artifactRef` pointing to the captured HTML.
2. **Given** a completed `browse` call, **When** the agent invokes another tool with the returned `sessionId`, **Then** the tool acts on the same pooled webview instance rather than a fresh one.
3. **Given** a `sessionId` that has been released back to the pool, **When** a tool call references it, **Then** the system either re-acquires the pooled instance or returns a clear "session not active" error rather than leaking or crashing.

---

### User Story 2 - Intercept a page and get bounded, privacy-safe Sightings (Priority: P2)

An agent calls `webview.intercept_browse(session, url, filters?)` to load a page while capturing its network activity, then receives a distilled set of **Sightings** produced by a dedicated distiller rather than raw network events. The capture is bounded by caps (max events, max payload size, binary capture toggle) enforced inside the distiller. The agent uses this to "see" what a page fetched (images, XHR, third-party requests) without being overwhelmed by raw event streams and without secrets leaking into the output.

**Why this priority**: Network interception is what turns the webview into the agent's "eyes" on unknown sites, but raw capture is unusable and risky at scale. Distillation + caps are the differentiators that make intercept safe and actionable.

**Independent Test**: Run `intercept_browse` against representative retailer pages (with distiller fixtures routed through the same code path) and assert the returned Sighting set is non-empty, bounded under configured caps, and free of obvious secrets (credentials, tokens) per the fixture assertions.

**Acceptance Scenarios**:

1. **Given** `intercept_browse` is called with default capture settings, **When** the page finishes loading, **Then** the result contains a bounded list of distilled Sightings, not the raw intercepted event stream.
2. **Given** capture caps are configured (event count, payload size, binary capture off by default), **When** the page would exceed those caps, **Then** the distiller truncates the output to stay within bounds without erroring.
3. **Given** distiller fixtures representing real retailer pages, **When** they are processed through the intercept path, **Then** the resulting Sighting set passes the same secret-free and bounded assertions the fixtures encode.

---

### User Story 3 - Search across engines with graceful degradation (Priority: P2)

An agent calls `webview.search(session, engine, query)` to discover result links. The tool prefers retailer on-site search when applicable, then falls back through DDG/Bing HTML endpoints, and only uses Google last. If an upstream engine blocks, rate-limits, or fails, the tool degrades in order — returning links it was able to extract from the engines that worked — instead of failing the whole operation.

**Why this priority**: Search is the agent's primary discovery mechanism on unknown sites, but individual engines are unreliable (bot blocking, CAPTCHAs). Ordered degradation is essential for robustness in production.

**Independent Test**: With per-engine VCR cassettes, replay a `search` call where one engine returns a block page; assert the tool still returns links harvested from the remaining engines and reports which engine failed, without raising.

**Acceptance Scenarios**:

1. **Given** a query and an explicit engine preference, **When** `search` runs, **Then** extracted result links are returned for that engine.
2. **Given** a multi-engine run where the preferred engine returns a block/error, **When** the tool proceeds, **Then** it falls back to the next engine in the defined order and returns whatever links it can extract.
3. **Given** all non-Google engines fail, **When** the tool reaches the Google fallback, **Then** it attempts Google last and still returns a usable (possibly partial) link set or an empty set with a clear degraded-status note.

---

### User Story 4 - Manage cookies, capture media, dismiss dialogues, run JS, and record/replay flows (Priority: P3)

An agent uses the remaining tool surface to operate on a session: `webview.cookies.get`/`webview.cookies.set` to read and write cookies; `webview.dialogue_dismiss(session)` to clear consent banners/overlays; `webview.screenshot(session)` and `webview.pdf(session)` to capture visual artifacts; `webview.execute_js(session, code)` to evaluate script with result-size discipline (summarizing and referencing rather than inlining oversized payloads); and `webview.recipe.record`/`webview.recipe.replay` to capture a user's interaction flow and replay it headlessly. Recording requires an explicit consent flag, and replayed/captured traces never include user credentials.

**Why this priority**: These are enrichment and automation capabilities layered on top of browse/intercept/search. They materially increase agent capability but depend on the core session model and are individually optional for most missions.

**Independent Test**: On a pooled session, set a cookie, read it back, dismiss an overlay, capture a screenshot and PDF, execute a small JS snippet, and verify the JS result obeys the size-threshold discipline. Separately, record a flow with consent enabled and replay it, asserting no credential values appear in the recorded trace.

**Acceptance Scenarios**:

1. **Given** a session with a cookie set via `webview.cookies.set`, **When** `webview.cookies.get` is called, **Then** the previously set cookie is returned and usable by subsequent navigation.
2. **Given** a page showing a consent dialogue, **When** `webview.dialogue_dismiss` runs, **Then** the overlay is cleared so screenshot/PDF captures are unobstructed.
3. **Given** a JS evaluation whose serialized result exceeds the configured size threshold, **When** `execute_js` returns, **Then** the payload is summarized inline with an artifact reference for the full output rather than inlined whole.
4. **Given** recipe recording is started with consent granted, **When** a flow is recorded and then replayed headlessly, **Then** user credentials are excluded from the trace and replay reproduces the captured steps.

---

### User Story 5 - Cancel a mission mid-capture without leaking the webview (Priority: P3)

A mission (cancel token) is cancelled while `webview.intercept_browse` is mid-flight. The tool honors the cancellation, flushes whatever Sightings it has already distilled through the salvage protocol, releases the webview back to the pool, and reports a partial result — without leaking the instance or leaving dangling capture subscriptions.

**Why this priority**: Cancellation correctness protects shared pool resources and prevents flaky, leaking CI and production agents; it is a correctness guarantee layered over the capture path rather than a user-facing feature.

**Independent Test**: Start an `intercept_browse` against a slow page, fire the cancel token mid-load, and assert (a) partial Sightings are emitted, (b) the pool reports the webview released (zero leaked live instances), and (c) no unhandled errors escape the tool.

**Acceptance Scenarios**:

1. **Given** an in-progress `intercept_browse`, **When** cancellation is signalled, **Then** the tool flushes already-distilled Sightings before disposing.
2. **Given** cancellation has completed, **When** the pool is inspected, **Then** the webview instance is returned to the pool with no leaked or orphaned live instances.
3. **Given** a cancelled mission, **When** the result is returned, **Then** it is marked partial/cancelled rather than success and contains no half-written raw capture artifacts.

---

### Edge Cases

- **Unknown or released `sessionId`**: A tool called with a `sessionId` that is unknown, expired, or already released must return a clear "session not active" error and must not create an uncontrolled new instance unless `newSession: true` is explicitly passed.
- **Fresh identity required**: Some missions need a clean slate (no cookies/history). Tools that must not reuse identity accept `newSession: true`; the system then provisions a fresh pooled instance and returns a new `sessionId`.
- **Distiller overflow**: When a page produces more network activity than configured caps allow, the distiller must truncate deterministically (oldest/largest dropped per cap policy) and the result must still be bounded and secret-free.
- **Search engine blocks**: Each engine may return a bot-check/CAPTCHA/empty page. The tool must detect "no usable results" per engine and continue down the order rather than treating it as a hard failure; if all engines fail, return an empty, clearly-degraded result.
- **Oversized `execute_js` result**: Results above the size threshold must be summarized with an external artifact reference; extremely large or non-serializable results must not crash the tool.
- **Credential hygiene in recipes**: If a recorded/replayed flow touches credential fields, the trace must redact them regardless of consent; consent gates *recording*, not redaction.
- **Cancellation during capture**: Cancellation may arrive between events; the salvage protocol must emit a coherent partial set and guarantee pool release even if disposal is interrupted.
- **Mobile default tuning**: On mobile, defaults (binary capture off, tight caps, compact payloads) must keep artifact sizes and memory within device limits; desktop callers may raise caps explicitly.

## Requirements

### Functional Requirements

- **FR-001**: The system MUST provide a `WebviewMcpToolProvider` that implements the agent kernel's `McpToolProvider` SPI and registers all of its tools under the `webview` namespace.
- **FR-002**: The system MUST expose, at minimum, the following tools: `webview.browse`, `webview.intercept_browse`, `webview.search`, `webview.execute_js`, `webview.cookies.get`, `webview.cookies.set`, `webview.dialogue_dismiss`, `webview.screenshot`, `webview.pdf`, `webview.recipe.record`, and `webview.recipe.replay`.
- **FR-003**: For every tool invocation, the system MUST return a result that carries a `sessionId` continuation token so the agent can keep acting on the same pooled webview instance across sequential calls.
- **FR-004**: The system MUST allow a caller to request a fresh identity by passing `newSession: true` on tools where reuse is otherwise defaulted; in that case it MUST provision a new pooled instance and return a new `sessionId`.
- **FR-005**: The system MUST implement `webview.browse` to load the target URL in a headless webview, wait until the page is idle, and return the page title, the resolved URL, and an artifact reference to the captured HTML.
- **FR-006**: The system MUST implement `webview.intercept_browse` to load a page while capturing network activity and return a distilled set of Sightings produced by the distiller, rather than raw intercepted events.
- **FR-007**: The system MUST enforce capture caps (event count, payload size, and binary-capture toggle) inside the distiller so intercepted output stays bounded and within configured limits.
- **FR-008**: The system MUST implement `webview.search` to prefer retailer on-site search when applicable, then fall back through DDG/Bing HTML endpoints, and use Google last, degrading in order when an engine blocks or fails.
- **FR-009**: The system MUST implement `webview.execute_js` to evaluate script in the session and apply result-size discipline, summarizing and externalizing (artifact reference) results that exceed a configured threshold rather than inlining them whole.
- **FR-010**: The system MUST implement `webview.cookies.get` and `webview.cookies.set` to read and write cookies scoped to the active session.
- **FR-011**: The system MUST implement `webview.dialogue_dismiss`, `webview.screenshot`, and `webview.pdf` to clear overlays and capture visual artifacts of the active session respectively.
- **FR-012**: The system MUST implement `webview.recipe.record` and `webview.recipe.replay` such that recording requires an explicit consent flag and replay executes the captured flow headlessly.
- **FR-013**: The system MUST ensure that recorded/replayed recipe traces never contain user credentials, applying redaction regardless of consent state.
- **FR-014**: The system MUST expose capture configuration (filters, caps, binary-capture) as per-call tool arguments, with defaults tuned to be sane for mobile devices.
- **FR-015**: The system MUST be cancellation-aware: every tool MUST honor the mission's cancel token and, on cancellation during capture, MUST run the salvage protocol (flush already-distilled events) before releasing the webview to the pool.
- **FR-016**: The system MUST be VCR-compatible so the entire tool suite can be exercised end-to-end under recorded/replayed cassettes in CI without live network access.

### Key Entities

- **WebviewMcpToolProvider**: The new provider library target that implements `McpToolProvider` and owns the `webview.*` tool surface.
- **McpToolProvider SPI (zuraffa)**: The agent-kernel service-provider interface the provider registers against; defines tool listing and in-process invocation contracts.
- **WebViewPool / session handle (#237)**: The pooled webview manager that hands out reusable instances; a `sessionId` references one live (or released) instance.
- **Sighting & SightingDistiller (#79)**: The distilled, privacy-safe representation of intercepted network activity and the component that produces it under caps.
- **CancelToken / Mission (zuraffa #388)**: The cancellation signal and its salvage protocol used to flush partial capture before disposal.
- **Recipe**: A recorded user interaction flow that can be replayed headlessly; traces must exclude credentials.
- **VCR cassette (#238)**: A recorded HTTP/network fixture enabling deterministic, offline end-to-end testing of the tool suite.
- **artifactRef**: A reference to a captured artifact (HTML, screenshot, PDF, or oversized JS result) stored externally and returned in place of inlining the payload.

## Success Criteria

### Measurable Outcomes

- **SC-001**: The provider registers with the agent kernel and every declared `webview.*` tool is discoverable (listed) and callable in-process.
- **SC-002**: A `browse` operation returns a result containing the page title, the resolved URL, and an HTML artifact reference, and sequential tool calls reusing the returned `sessionId` operate on the same webview instance (pool reports a single live instance for the sequence).
- **SC-003**: `intercept_browse` against representative pages yields a bounded, secret-free set of distilled Sightings that satisfies the distiller fixtures' assertions.
- **SC-004**: A multi-engine `search` returns extracted result links and, when one or more engines block, still returns links harvested from the remaining engines without raising a hard error.
- **SC-005**: A mission cancelled mid-`intercept_browse` emits a partial Sighting set, returns the webview to the pool, and leaves no leaked or orphaned live instances.
- **SC-006**: Recipe recording requires explicit consent and replayed/recorded traces contain no user credentials, verified by a redaction assertion.
- **SC-007**: Capture behavior (filters, caps, binary capture) is overridable per call and, with defaults, keeps captured artifact sizes within mobile-sane limits.
- **SC-008**: The full tool suite passes end-to-end under VCR cassettes in CI with no live network dependency.

## Assumptions

- The `WebViewPool` / session-handle mechanism (issue #237) is available and provides pooled, reusable headless webview instances addressable by `sessionId`.
- The agent kernel exposes the `McpToolProvider` SPI (zuraffa #386) with in-process tool listing and invocation, and a `CancelToken`/mission model with a salvage protocol (zuraffa #388).
- The `SightingDistiller` (dart_web_scraper #79) is available and enforces caps and secret-free output; `intercept_browse` delegates distillation to it rather than emitting raw events.
- VCR record/replay (issue #238) is available so the suite can run deterministically in CI without live network access.
- Browsing and capture operate on a headless webview; default capture settings are tuned for mobile resource constraints and may be raised explicitly by desktop callers.
- Per the issue's later discussion (Wave Z re-home, #244), the `webview.*` tools may ultimately be generated from module use-cases, reducing #239 to SPI registration. This spec documents the intended tool surface and behavior; the exact generation mechanism is a follow-up and does not change the external contract described here.
- Search engines are treated as best-effort and unreliable; the tool is expected to degrade per the defined engine order rather than guarantee coverage.
