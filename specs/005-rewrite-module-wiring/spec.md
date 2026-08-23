# Feature Specification: Rewrite Module Wiring (Zuraffa-native)

**Feature Branch**: `005-rewrite-module-wiring`

**Created**: 2026-08-22

**Status**: Draft

**Input**: User description (derived from GitHub issue #243 "REWRITE: module wiring — DDA stores, generated ZuraffaUseCases (browse/intercept/search/...), mission semantics"): The plugin's module must be rewired to be Zuraffa-native. State must move into DDA datasources (stores), operations must become `ZuraffaUseCase`s that emit v6 `SignalResult` streaming, and everything must register through the package registrar so a consuming app receives sessions, budgets, and lifecycle "for free." Concretely this covers: (1) DDA datasources — a session store (mission-scoped webview sessions + cookies), a cookie store (`CookieManager` facade), an artifact store (HTML/screenshots/PDF → mission store via the artifactRef pattern), and a cassette store (VCR files); (2) `ZuraffaUseCase`s — `browse`, `interceptBrowse` (returns Sightings via the distiller slot), `search` (multi-engine degrade order), `executeJs`, `cookies.get/set`, `dialogueDismiss`, `screenshot`, `pdf`, `recipeRecord`, `recipeReplay` (confirm risk — credential flows), each generated via `zfa make` and risk-annotated per the annotation scheme; (3) mission semantics integration — a cancellation/salvage protocol honored by every usecase and budgets mapped to a `MissionBudgetHook` performing webview-seconds accounting; (4) streaming — usecase events (page state, capture progress, sightings found) surfaced as kernel events to the mission UI; (5) a module-level DI registrar + engine module so importing the module makes services available without manual wiring.

## User Scenarios & Testing

### User Story 1 - Zero-manual-wiring module registration (Priority: P1)

A developer adds the webview module to a Zuraffa-based app and imports the engine module. Without writing any registration or wiring code, the package registrar exposes every store and usecase on the module's public surface, so the app can resolve a web view session, fire a browse, and read artifacts immediately.

**Why this priority**: This is the headline outcome of the rewrite ("import → services available, no manual wiring"). If the registrar and engine module do not expose the full surface, none of the downstream agent tools or mission features can function. It is independently demonstrable: a single registrar-resolution test proves the wiring is complete.

**Independent Test**: Can be fully tested by importing the engine module in a consuming-app harness and asserting that the registrar resolves every store and usecase by type/key with zero explicit registration calls — delivering the full wired surface from one import.

**Acceptance Scenarios**:

1. **Given** a consuming app that imports only the engine module, **When** it asks the package registrar for the session store, cookie store, artifact store, cassette store, and every usecase by type, **Then** each is resolved successfully without any manual registration in app code.
2. **Given** the engine module is imported, **When** the consumer requests the same usecase type twice, **Then** a consistent, equivalent instance is returned (registrar is stable/idempotent), and importing the engine module a second time does not create duplicate registrations.
3. **Given** the engine module is not imported, **When** the consumer asks the registrar for a module usecase, **Then** resolution fails with a clear "not registered" signal rather than a silent null.

---

### User Story 2 - Generated mission-scoped usecases with streaming (Priority: P1)

A mission-driven consumer invokes the operations (`browse`, `interceptBrowse`, `search`, `executeJs`, `cookies.get/set`, `dialogueDismiss`, `screenshot`, `pdf`, `recipeRecord`, `recipeReplay`). Each operation is produced by code generation (not hand-written), carries the correct risk tier, returns its result as a v6 `SignalResult`, and streams progress (page state, capture progress, sightings found) over the result channel before completing.

**Why this priority**: The generated usecase surface is what the agent tooling derives from (it "generates the usecases the agent tools derive from"), and every acceptance check for streaming/risk depends on it. It is independently testable by generating the usecases and asserting generation origin, risk tiers, and at least one streamed event per streaming usecase.

**Independent Test**: Can be tested by regenerating the usecases with `zfa make` and asserting (a) no hand-written implementation bodies exist for the defined usecase set, (b) each usecase's risk annotation matches its tier, and (c) capture/progress/sighting usecases emit ≥1 `SignalResult` event before terminal completion.

**Acceptance Scenarios**:

1. **Given** the full usecase set is generated, **When** the build runs, **Then** `browse`, `interceptBrowse`, `search`, `executeJs`, `cookies.get`, `cookies.set`, `dialogueDismiss`, `screenshot`, `pdf`, `recipeRecord`, and `recipeReplay` all exist as generated `ZuraffaUseCase`s (provenance is code-generated, not hand-written).
2. **Given** a `recipeReplay` usecase invocation, **When** the replay reaches a credential-bearing step, **Then** the usecase is annotated with `confirm` risk and obtains explicit confirmation before executing that step.
3. **Given** an `interceptBrowse` run that finds elements matching the distiller, **When** the interception proceeds, **Then** matching content is emitted as Sightings through the distiller slot while the `SignalResult` stream reports page-state progress.
4. **Given** a `search` invocation, **When** the primary engine returns no results or fails, **Then** the usecase follows the defined degrade order across remaining engines before returning an empty-result signal.

---

### User Story 3 - Session continuity via pooled DDA stores (Priority: P2)

A consumer runs a sequence of operations (`browse` → `interceptBrowse` → `executeJs`) inside one mission and expects them to share a single pooled webview instance, with all captured artifacts (HTML/screenshots/PDF) persisted to the mission store through the artifactRef pattern and cookies scoped to the mission session.

**Why this priority**: Session continuity and the DDA stores are the foundation that makes multi-step missions coherent (cookies, captures, and the webview pool all hang off the session store). It is independently testable by asserting instance identity across the three operations and inspecting artifactRef persistence.

**Independent Test**: Can be tested by executing browse→intercept→executeJs on one mission and asserting (a) the same pooled webview instance identity is reused, (b) a screenshot/PDF artifact recorded during the mission resolves via its artifactRef from the mission store, and (c) a cookie set on the session is readable through the cookie store within that mission.

**Acceptance Scenarios**:

1. **Given** a mission with one webview session, **When** `browse`, then `interceptBrowse`, then `executeJs` are invoked in sequence, **Then** all three share the same pooled webview instance (asserted by instance identity).
2. **Given** a `screenshot` or `pdf` capture during a mission, **When** the capture completes, **Then** the artifact is written through the artifact store and is retrievable from the mission store via its artifactRef.
3. **Given** a cookie set through `cookies.set` on a mission session, **When** `cookies.get` is read afterward, **Then** the cookie is returned scoped to that mission session via the cookie store.

---

### User Story 4 - Mission cancellation, salvage, and budget accounting (Priority: P3)

A long-running `interceptBrowse` is cancelled mid-flight. The mission runtime triggers the cancellation/salvage protocol: the usecase flushes whatever captures it has, releases its pooled session back to the pool, and returns any partial Sightings. Webview time consumed is accounted against the mission budget via the `MissionBudgetHook` (webview-seconds), and a budget-exceeded condition halts further consumption.

**Why this priority**: Cancellation/salvage and budget enforcement protect the runtime from resource leaks and runaway cost, but they sit on top of the wired module (stories 1–3). They are independently testable via a cancellation harness (no-leak assertion) and a budget-exhaustion assertion.

**Independent Test**: Can be tested by starting an `interceptBrowse`, cancelling before completion, and asserting (a) partial sightings are returned, (b) the pooled session is released and no sessions/cassettes leak, and (c) exhausting the webview-seconds budget emits a budget-exceeded kernel event and blocks further webview time.

**Acceptance Scenarios**:

1. **Given** an in-flight `interceptBrowse`, **When** the mission cancels it, **Then** the usecase flushes captured artifacts, releases the pooled session, returns any partial Sightings, and leaves no leaked sessions or cassettes (verified by a no-leak assertion).
2. **Given** a mission whose webview-seconds budget is exhausted, **When** a usecase attempts further webview consumption, **Then** consumption is blocked and a budget-exceeded kernel event is emitted before any over-run.
3. **Given** a usecase cancellation where the salvage flush itself fails, **When** the failure occurs, **Then** the pooled session is still released and no session/cassette leak remains (partial captures may be lost, but resources are clean).

---

### Edge Cases

- What happens when a usecase is cancelled before any capture has been flushed? It must still release the pooled session and return empty Sightings with no session/cassette leak.
- What happens when the salvage flush fails during cancellation? The pooled session must still be released; partial captures may be lost but no resource leak is permitted.
- What happens when all search engines fail or return no results? The multi-engine degrade order is exhausted and the usecase returns an explicit empty/failure `SignalResult`.
- What happens when the artifact store or mission store is unavailable? The artifactRef cannot be resolved and the usecase surfaces a failure through `SignalResult` rather than throwing uncaught.
- What happens when the webview-seconds budget runs out mid-`interceptBrowse`? A budget-exceeded event fires and the usecase cancels via the salvage protocol.
- What happens when the engine module is imported more than once? Registration must be idempotent with no duplicate entries.
- What happens when a user denies confirmation on a `recipeReplay` credential step? The replay aborts without executing the credential-bearing steps.

## Requirements

### Functional Requirements

- **FR-001**: The system MUST provide DDA datasources comprising a session store (mission-scoped webview sessions + cookies), a cookie store exposing a `CookieManager` facade, an artifact store persisting HTML/screenshots/PDF to the mission store via the artifactRef pattern, and a cassette store managing VCR files.
- **FR-002**: The system MUST provide a module-level DI registrar plus an engine module so that importing the engine module makes every store and usecase resolvable through the package registrar with zero manual wiring by the consuming app.
- **FR-003**: The system MUST produce every `ZuraffaUseCase` through code generation (`zfa make`) rather than hand-written implementations, with each usecase risk-annotated according to the annotation scheme.
- **FR-004**: Each generated usecase MUST return its operation result as a v6 `SignalResult` and MUST stream progress events (page state, capture progress, sightings found) over that result channel before reaching terminal completion.
- **FR-005**: The system MUST provide the following usecases: `browse`, `interceptBrowse`, `search`, `executeJs`, `cookies.get`, `cookies.set`, `dialogueDismiss`, `screenshot`, `pdf`, `recipeRecord`, and `recipeReplay`.
- **FR-006**: `interceptBrowse` MUST accept `filters` and `stopOn` parameters, MUST return Sightings through the distiller slot, and MUST honor stop conditions during interception.
- **FR-007**: `search` MUST perform a multi-engine query and MUST follow a defined degrade order when an engine fails or returns no results.
- **FR-008**: `recipeReplay` MUST be annotated with `confirm` risk (credential flows) and MUST obtain explicit confirmation before executing credential-bearing steps.
- **FR-009**: Every usecase MUST honor the mission cancellation/salvage protocol: on cancellation it MUST flush captures, release pooled sessions, and return any partial results (Sightings) without leaking sessions or cassettes.
- **FR-010**: Mission budgets MUST map to a `MissionBudgetHook` performing webview-seconds accounting, and usecases MUST check/consume that budget while spending webview time.
- **FR-011**: Usecase events (page state, capture progress, sightings found) MUST surface as kernel events so the mission UI can subscribe and react.
- **FR-012**: `cookies.get`/`cookies.set` MUST operate through the cookie store so cookies are scoped to the mission session.

### Key Entities

- **SessionStore**: DDA store holding mission-scoped webview sessions and their associated cookies; the anchor for session continuity and the webview pool.
- **CookieStore**: DDA store providing a `CookieManager` facade so cookies are read/written scoped to a mission session.
- **ArtifactStore**: DDA store that persists HTML/screenshots/PDF captures to the mission store using the artifactRef pattern.
- **CassetteStore**: DDA store managing VCR (cassette) files used for record/replay.
- **ZuraffaUseCase**: The generated unit of operation (browse, interceptBrowse, search, executeJs, cookies, dialogueDismiss, screenshot, pdf, recipeRecord, recipeReplay) that emits v6 `SignalResult` and honors mission semantics.
- **SignalResult**: v6 result type that carries a terminal result plus a stream of progress events for a usecase.
- **Mission**: The runtime scope under which sessions, budgets, and lifecycle are managed; provides cancellation and salvage orchestration.
- **MissionBudgetHook**: Hook that performs webview-seconds accounting against the mission budget and gates further webview consumption.
- **Sightings**: Structured findings emitted by `interceptBrowse` through the distiller slot.
- **artifactRef**: Reference pattern used by the artifact store to resolve a captured artifact from the mission store.
- **KernelEvent / PackageRegistrar / EngineModule**: The event bus, the DI registrar, and the importable module that together provide the zero-boilerplate wiring surface.

## Success Criteria

### Measurable Outcomes

- **SC-001**: A consuming app resolves 100% of the module's stores and usecases from the package registrar after importing only the engine module, with zero manual registration calls (verified by an automated registrar-resolution test).
- **SC-002**: 100% of the defined usecases are produced by code generation (no hand-written bodies) and carry the correct risk tier, verified by a generation-provenance assertion.
- **SC-003**: Every usecase returns a terminal `SignalResult`, and each capture/progress/sighting usecase emits at least one streamed event before completion (verified by per-usecase streaming tests).
- **SC-004**: Cancelling a mid-flight `interceptBrowse` yields any partial Sightings and zero leaked sessions/cassettes, verified by a no-leak assertion in the cancellation test.
- **SC-005**: `browse` → `interceptBrowse` → `executeJs` on one mission share a single pooled webview instance, verified by instance-identity assertion.
- **SC-006**: Exhausting the mission's webview-seconds budget emits a budget-exceeded kernel event and blocks further webview consumption before any over-run, verified by a budget test.

## Assumptions

- The umbrella rewrite (#241) and extraction (#242) are complete so that the underlying ports the module depends on already exist.
- The upstream Zuraffa capabilities are available and stable: package mode (zuraffa#389), the salvage protocol (zuraffa#388), usecase codegen (zuraffa#385), and the annotation scheme (zorphy#114).
- The consuming app uses the Zuraffa framework's package registrar/DI and mission runtime, so "import → available" is meaningful in that context.
- A webview pool is available to serve the pooled sessions referenced by the session store and salvage protocol.
- "DDA" refers to the domain architecture pattern already used in the project for state/stores, where datasources hold state and operations are expressed as usecases.
- The plugin continues to operate on the existing supported platforms (Android/iOS/Web/Linux/Windows/macOS) via the existing method-channel/controller layer; this feature rewires the Zuraffa-facing module surface on top of those ports rather than altering platform rendering.
