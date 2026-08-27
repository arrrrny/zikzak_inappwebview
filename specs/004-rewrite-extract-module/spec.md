# Feature Specification: Extract Value-Add into Module (Ports & Services)

**Feature Branch**: `004-rewrite-extract-module`

**Created**: 2026-08-22

**Status**: Draft

**Input**: User description (from GitHub issue #242, "REWRITE: extract value-add into module — pool, capture, VCR, dismisser, recipes, tracker as ports & services"): Extract the Wave Z intelligence out of the `zikzak_inappwebview` plugin core and into a dedicated `zikzak_inappwebview_module` package behind clean ports and adapters, leaving the plugin a thin core. The module defines the value-add interfaces (ports) and implements them as services / DDA datasources, while plugin adapters are the only code allowed to import plugin internals. The moved capabilities are: `WebViewSessionFactory` + `WebViewPool` (#237), `CaptureSource` with mission-grade intercept semantics (#240), `CassetteEngine` VCR record/replay (#238), and the `DialogueDismissPort`, `RecipePort`, `NavigationTrackerPort` ports. The capture pipeline exposes a distiller post-processor slot consuming the `Sighting` contract (dart_web_scraper#79) via an inverted dependency. Secret/auth-flow redaction moves into the module's capture service as a single point of redaction. Existing plugin examples and tests for the moved features re-point at the module equivalents and stay green.

## User Scenarios & Testing

### User Story 1 - Module owns WebView pooling behind a port (Priority: P1)

A Flutter developer building capture or automation flows needs a managed pool of reusable web-view sessions. They depend on `zikzak_inappwebview_module`, acquire sessions through `WebViewSessionFactory` / `WebViewPool`, and rely on the module to recycle, hold with domain affinity, and evict sessions under memory pressure. The plugin core exposes only the thin adapter over `HeadlessInAppWebView`; none of the pooling logic lives there.

**Why this priority**: Pooling is the foundational substrate. Capture, VCR, and the remaining ports all sit on top of a managed session, and the umbrella gate ("zero intelligence code in plugin core") cannot pass until the pool logic is out of the core. It is the highest-leverage extraction.

**Independent Test**: A test that acquires N sessions through the module, releases them, simulates a memory-pressure event, and asserts that no `HeadlessInAppWebView` handle leaks and that the pool disposes the expected sessions.

**Acceptance Scenarios**:

1. **Given** the module is initialized, **When** a client requests a session for a domain, **Then** the pool returns a handle with domain affinity, reusing an idle session for the same domain when one is available.
2. **Given** a pool under memory pressure, **When** the pressure threshold is exceeded, **Then** the pool disposes the lowest-priority / longest-idle sessions and frees their resources.
3. **Given** any session that was acquired, **When** it is released or its owner disposes it, **Then** it is either returned to the pool or fully torn down, and no handle is leaked.

---

### User Story 2 - Capture service with at-source redaction and distiller slot (Priority: P2)

A developer capturing network traffic needs streaming events, budget caps, early-stop, salvage-on-teardown, and secrets redacted before anything crosses the capture boundary. The module's `CaptureSource` provides this on top of raw plugin capture events, and forwards processed `Sighting` objects through the distiller post-processor slot. Plugin internals only feed raw events; all intercept semantics and redaction live in the module.

**Why this priority**: Mission-grade capture parity (#240) and secret redaction are the primary compliance and reliability reasons for the extraction. A leak of auth-flow material or an unbounded capture would be a serious defect, so this must land immediately after the pooling substrate.

**Independent Test**: A capture run over a page that emits auth cookies and a large XHR, using a stub distiller, asserts that events stream incrementally, the budget stops capture, and no secret bytes appear in any emitted output.

**Acceptance Scenarios**:

1. **Given** a capture session configured with a finite budget, **When** the budget is exhausted, **Then** capture stops and a salvage flush emits all buffered entries before teardown.
2. **Given** a `stopOn` predicate, **When** it returns true mid-stream, **Then** capture ends early and returns the accumulated entries without processing further events.
3. **Given** raw events containing auth-flow tokens, **When** they reach the capture boundary, **Then** they are redacted at source and the distiller receives only redacted `Sighting` objects.

---

### User Story 3 - VCR record/replay and remaining ports (Priority: P3)

A developer records a session once and replays it deterministically and offline. The module's `CassetteEngine` wraps the session factory as a transport-level VCR; `RecipePort`, `DialogueDismissPort`, and `NavigationTrackerPort` provide record/replay of recipes, dismiss presets, and URL-cycle events respectively, each operating purely through its port boundary.

**Why this priority**: Replay determinism and the smaller ports are valuable but depend on the pooled/capture substrate from P1/P2, and they carry lower risk of secret leakage. They are sequenced last without blocking the core gate.

**Independent Test**: Record a cassette from a live run, then replay it twice from the same input and assert byte-identical outputs and zero network requests during replay.

**Acceptance Scenarios**:

1. **Given** a recorded cassette, **When** replay mode is active, **Then** the engine serves responses from the cassette and makes no network requests.
2. **Given** the same cassette replayed twice, **When** the two outputs are compared, **Then** they are byte-identical (deterministic replay).
3. **Given** `DialogueDismissPort`, `RecipePort`, and `NavigationTrackerPort`, **When** their record/replay operations are invoked through module services, **Then** they operate entirely through the port boundary without importing plugin internals.

---

### Edge Cases

- Replay references an asset not present in the cassette: the engine must fail deterministically and MUST NOT fall back to the network.
- Capture budget of zero: capture yields immediately with a single salvage flush and no events processed.
- Memory pressure occurs during an active capture: the pool evicts sessions only after the capture service salvages its buffer.
- A novel auth scheme is not matched by the redaction patterns: defense-in-depth applies — the distiller is a second redaction layer, and no raw secret should ever leave the capture service.
- The distiller stub returns a malformed `Sighting`: the distiller contract test must fail loudly rather than silently passing bad data downstream.
- Module unit tests run without the plugin present: fakes satisfy the ports, and plugin internals are never imported by module tests.
- A port is invoked before its adapter is registered: the module MUST surface a clear "adapter not registered" error rather than a null failure.

## Requirements

### Functional Requirements

- **FR-001**: The system MUST provide a module package `zikzak_inappwebview_module` that declares the value-add ports (`WebViewSessionFactory`, `CaptureSource`, `CassetteEngine`, `DialogueDismissPort`, `RecipePort`, `NavigationTrackerPort`) as abstract interfaces.
- **FR-002**: The system MUST implement each port as a module service or DDA datasource (structured per zuraffa#389), with all business logic residing in the module package.
- **FR-003**: The system MUST provide plugin-side adapter implementations of the ports, and these adapters MUST be the only code permitted to import `zikzak_inappwebview` plugin internals (`InAppWebViewController`, `HeadlessInAppWebView`, method channels).
- **FR-004**: The `WebViewPool` service MUST manage reusable session handles with domain affinity and MUST dispose idle / lowest-priority sessions under memory pressure, implemented as an adapter over `HeadlessInAppWebView`.
- **FR-005**: The `CaptureSource` service MUST implement mission-grade intercept semantics on top of raw plugin capture events, including streaming event emission, a `stopOn` early-return predicate, a salvage flush on teardown, per-session capture budgets, and at-source redaction.
- **FR-006**: The `CassetteEngine` service MUST provide VCR record/replay as a transport-level wrapper over the session factory, and replay mode MUST NOT initiate any network requests.
- **FR-007**: The module capture pipeline MUST expose a distiller post-processor slot that consumes the `Sighting` contract (dart_web_scraper#79), depending on the distiller interface rather than on the scraper package.
- **FR-008**: Secret and auth-flow redaction MUST occur at the capture source within the module's capture service as the single point of redaction, providing defense in depth alongside the distiller.
- **FR-009**: The `WebViewPool` service MUST guarantee no session leaks: every acquired handle is disposed or returned to the pool, and a no-leak verification run MUST pass.
- **FR-010**: VCR replay MUST be deterministic: identical input cassettes MUST produce byte-identical replayed outputs across repeated runs.
- **FR-011**: The plugin core MUST contain zero value-add / intelligence code; an automated structural gate (umbrella #241) MUST confirm that no port implementations or capture/cassette/redaction logic remain in the plugin core.
- **FR-012**: Existing plugin examples and tests for the moved features MUST be re-pointed at the module equivalents and MUST remain green (behavior parity).
- **FR-013**: The distiller slot MUST be validated by a contract test using a stub implementation, with the real implementation (dart_web_scraper#79) wired later.
- **FR-014**: Each port MUST define an explicit adapter-boundary contract so the module can be tested with fakes without importing any plugin internals.

### Key Entities

- **`zikzak_inappwebview_module`**: The dedicated module package that owns all extracted value-add logic behind ports and services.
- **Ports (abstract interfaces)**: `WebViewSessionFactory`, `CaptureSource`, `CassetteEngine`, `DialogueDismissPort`, `RecipePort`, `NavigationTrackerPort` — defined in the module, implemented by plugin adapters.
- **`WebViewPool` service**: Manages session handles, domain affinity, and memory-pressure disposal; backed by `HeadlessInAppWebView` via the adapter.
- **Capture service** (implements `CaptureSource`): Streaming capture with budgets, early-stop, salvage flush, and at-source redaction.
- **`CassetteEngine` service** (implements `CassetteEngine`): VCR record/replay transport wrapper over the session factory.
- **DDA datasource**: The structured storage/adapter shape (per zuraffa#389) used by remaining ports (recipe, dismiss, tracker).
- **`Sighting` contract**: The data shape (dart_web_scraper#79) consumed by the distiller slot; the module depends on the interface, not the scraper package.
- **Plugin adapters**: The only code importing plugin internals; bridge the module ports to `InAppWebViewController` / `HeadlessInAppWebView`.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Zero value-add logic remains in the plugin core, confirmed by an automated structural gate (e.g., a grep/import check) rather than manual review.
- **SC-002**: The module delivers WebView session pooling with no leaks, verified by a defined stress/teardown run that reports zero orphaned sessions.
- **SC-003**: Capture redaction removes secrets and auth-flow material at the source, verified by asserting no secret byte patterns appear in emitted capture output.
- **SC-004**: VCR replay is deterministic and network-free, verified by a determinism test that compares two replays of the same cassette and asserts identical output and zero network calls.
- **SC-005**: The distiller slot is validated by a contract test using a stub implementation that passes all defined `Sighting` contract assertions.
- **SC-006**: Behavior parity holds: existing tests for the moved features pass unchanged after being re-pointed at the module equivalents.
- **SC-007**: Module services are testable in isolation using fakes, with module unit tests importing no plugin internals.

## Assumptions

- The umbrella split map (#241) is completed first and the `zikzak_inappwebview_module` package already exists as a package target.
- The zuraffa#389 package-mode structure is the approved template for module services / DDA datasources.
- The dart_web_scraper#79 distiller interface lands separately; until then a stub implementation satisfies the distiller slot contract (FR-013).
- The feature specs from #237 (pool), #238 (VCR), and #240 (capture/redaction) carry their acceptance criteria into this module context and are closed as "landed-here" once passing.
- The plugin internals (`HeadlessInAppWebView`, `InAppWebViewController`, method channels) remain available and stable as adapter targets.
- Behavior parity assumes the moved features' existing plugin examples/tests can be re-pointed at module equivalents without altering their assertions.
