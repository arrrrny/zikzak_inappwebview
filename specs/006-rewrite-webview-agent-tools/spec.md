# Feature Specification: Generated `webview.*` Agent Tools + Cassette Parity CI Gate

**Feature Branch**: `006-rewrite-webview-agent-tools`

**Created**: 2026-08-22

**Status**: Draft

**Input**: GitHub issue #244 (Wave Z of the ZikZak AI program). The module's agent surface and its regression gate are being rewritten. The `webview.*` tool suite (browse, intercept_browse, search, execute_js, cookies, dialogue_dismiss, screenshot, pdf, recipe record/replay) must be **generated** from the module's usecases (#243) via `zfa make --agent` in package mode, instead of being hand-written. The previously hand-built `WebviewMcpToolProvider` (issue #239) is superseded: it reduces to registering the generated tool set into the zuraffa kernel registry via the `McpToolProvider` SPI (#386). A VCR-based cassette harness (#238, re-homed by #242) becomes the module's mandatory CI regression gate, with a golden cassette set across ≥ 3 retailers and a multi-engine degrade set. The dws_playground golden missions GM-2/GM-4/GM-5 are re-pointed at the module tools; a green run in CI is the parity sign-off that closes the umbrella issue #241. Non-zuraffa consumers keep a documented thin-core/standalone import path.

## User Scenarios & Testing

### User Story 1 — Generated tool suite matches the agreed surface with no hand-written tool classes (Priority: P1)

A maintainer building the agent module runs `zfa make --agent` in package mode after defining the module usecases (#243). The build emits one `webview.*` tool per entry in the architecture doc §4.1 surface, and the module's tool list is exactly that surface. The old hand-written `WebviewMcpToolProvider` is gone; only a thin registrar that registers the generated set into the kernel remains.

**Why this priority**: This is the defining deliverable of the feature — if the tools are not generated from usecases and the surface is not exactly the agreed set, every downstream dependency (dws_playground, zik_zak K2, the parity gate) is built on the wrong foundation.

**Independent Test**: Build the module in package mode, then assert (a) every tool name in the emitted `webview.*` set equals the §4.1 surface, (b) the generated artifact contains no hand-written tool class definitions for the module, and (c) the remaining registrar only references the generated symbol names and registers them with the kernel registry.

**Acceptance Scenarios**:

1. **Given** the module usecases are defined and `zfa make --agent` is invoked in package mode, **When** the build completes, **Then** the emitted tool names exactly equal the §4.1 surface (`webview.browse`, `webview.intercept_browse`, `webview.search`, `webview.execute_js`, `webview.cookies.get`, `webview.cookies.set`, `webview.dialogue_dismiss`, `webview.screenshot`, `webview.pdf`, `webview.recipe.record`, `webview.recipe.replay`) — no more, no fewer.
2. **Given** the generated tool set, **When** the module source is inspected, **Then** there are zero hand-written tool classes for the `webview.*` surface; the only remaining provider code is a registrar that registers the generated symbols into the kernel registry via the `McpToolProvider` SPI.
3. **Given** the generated set is registered, **When** an agent kernel lists tools in the `webview` namespace, **Then** all §4.1 tools are enumerated and individually callable in-process.

---

### User Story 2 — Tool schemas carry opaque session ids, typed capture args, and bounded results (Priority: P1)

An agent developer calls the generated tools. Session ids are opaque strings with documented continuation semantics (a returned `sessionId` is passed back to keep a sequence on one web view instance), and tools that must start a fresh identity accept an explicit `newSession` flag. Capture `filters`/`stopOn` are exposed as typed arguments, and any oversized result is returned as a summary plus an `artifactRef` (a reference to the full artifact) rather than an unbounded payload.

**Why this priority**: Correct session continuity and result-bounding are what make the tools usable and safe inside an agent loop (no unbounded payloads blowing up context, no accidental mixing of web-view identities). This is core to the tool contract.

**Independent Test**: Invoke `webview.browse` and `webview.intercept_browse` in sequence passing the returned `sessionId` back; assert the same web-view instance is used (pool asserts a single live web view) and that an `oversized` result yields a `summary` + `artifactRef` pair while a normal result returns the payload inline.

**Acceptance Scenarios**:

1. **Given** a tool description, **When** it is read, **Then** it documents session ids as opaque strings with continuation semantics and states which tools accept `newSession`.
2. **Given** a `webview.browse` → `webview.intercept_browse` → `webview.execute_js` sequence on one pooled instance, **When** the `sessionId` returned by browse is threaded through, **Then** the pool serves a single live web view for the whole sequence.
3. **Given** a tool configured with `filters`/`stopOn`, **When** it is called, **Then** those are accepted as typed arguments (not opaque payloads) and gate capture.
4. **Given** a tool whose result exceeds the size threshold, **When** it returns, **Then** the payload is the bounded `summary` plus an `artifactRef` pointing to the full artifact; a result under threshold is returned inline.

---

### User Story 3 — Cassette parity harness gates every change in CI (Priority: P1)

A CI pipeline runs on every change. It replays a golden cassette set covering ≥ 3 retailers × {browse, intercept, search per engine, dialogue dismiss, recipe replay}, recorded once via the VCR (#238), plus a multi-engine degrade set where each engine's block cassette is replayed. The run is deterministic (10 identical replays) and must be green on macOS and the Android emulator for the change to pass.

**Why this priority**: The cassette harness is the regression gate that gives the umbrella (#241) its parity sign-off. Without a green, deterministic, multi-platform cassette run, there is no objective proof the generated tools behave identically to the recorded reference behavior.

**Independent Test**: In a clean checkout, run the cassette replay suite and assert it is green on macOS and Android emulator, that replaying any golden cassette 10× yields byte-identical mission outcomes, and that a multi-engine degrade cassette (one engine blocked) produces the correct degraded result.

**Acceptance Scenarios**:

1. **Given** the committed golden cassettes, **When** the cassette suite runs in CI, **Then** it is green on both macOS and the Android emulator.
2. **Given** a single golden cassette, **When** it is replayed 10×, **Then** each replay produces an identical mission outcome (determinism).
3. **Given** the multi-engine degrade set, **When** an engine's block cassette is replayed, **Then** `webview.search` degrades correctly to the next engine without error.
4. **Given** an unmatched live network call during replay, **When** it occurs, **Then** the harness fails hard (deterministic mode) so regressions cannot silently go live.

---

### User Story 4 — dws_playground golden missions sign off parity; umbrella closes (Priority: P2)

The dws_playground golden missions GM-2, GM-4, and GM-5 are re-pointed to exercise the generated module tools rather than any hand-built provider. When those missions are green in CI, the umbrella issue #241 is considered signed off and #239 is closed as superseded-by-generated (with a recorded mapping of old tool names to generated ones).

**Why this priority**: This is the end-to-end acceptance that the generated tools are behaviorally equivalent to the prior surface. It is P2 because it depends on the generated set (US-1) and the cassette gate (US-3) already being correct.

**Independent Test**: Run dws_playground missions GM-2/GM-4/GM-5 against the module tools and assert they pass; verify the issue tracker records #239 closed-as-superseded with the old→new tool name mapping and #241 closed on this sign-off.

**Acceptance Scenarios**:

1. **Given** GM-2/GM-4/GM-5 configured against the module tools, **When** they run in CI, **Then** all three are green.
2. **Given** the green mission run, **When** the umbrella is reviewed, **Then** #241 is closed on this parity sign-off and #239 is closed as superseded-by-generated with its tool-name mapping noted.

---

### User Story 5 — Consumers can adopt via zuraffa registrar or standalone thin core (Priority: P2)

A zuraffa-based consumer (e.g., zik_zak K2, #174) imports the module's registrar to get the generated tools wired into its agent kernel automatically. A non-zuraffa consumer can import the plugin directly and use the thin core standalone without the zuraffa runtime. Both paths are documented.

**Why this priority**: Adoption and non-breaking migration matter for the ecosystem, but the feature is correct even if only one consumer path is documented; hence P2.

**Independent Test**: In a zuraffa host, import the module registrar and assert the `webview.*` tools appear in the kernel; in a non-zuraffa app, import the plugin and assert the thin core (e.g., `HeadlessInAppWebView`) is usable without a kernel.

**Acceptance Scenarios**:

1. **Given** a zuraffa consumer app, **When** it imports the module registrar, **Then** the generated `webview.*` tools are registered into its agent kernel.
2. **Given** a non-zuraffa app, **When** it imports the plugin directly, **Then** the thin core is usable standalone without requiring the zuraffa runtime.
3. **Given** the migration, **When** a consumer reads the docs, **Then** both the registrar import path and the plugin-only standalone import path are documented.

---

### Edge Cases

- **A usecase changes but the generator is not re-run**: The committed tool set no longer matches §4.1; the CI surface-equality check (US-1) fails and blocks the merge.
- **A cassette drifts from live behavior** (site changed, new DOM): Replay still passes against the recorded cassette but no longer reflects reality; redaction/version checks and periodic re-recording (record-once policy) mitigate, and the determinism run guards replay stability, not live accuracy.
- **Oversized result with no artifact store**: `artifactRef` must still be produced with a retrievable location; if the artifact store is unavailable, the tool fails loudly rather than returning a truncated silent payload.
- **Engine fully blocked in multi-engine degrade set**: `webview.search` degrades through all engines and returns an empty/no-result state without throwing, matching the degrade cassette expectation.
- **`newSession: true` mid-sequence**: The tool must not reuse the prior pooled instance; it must obtain a fresh identity, and the prior instance is released back to the pool without leaking.
- **CI runs on a platform without an Android emulator available**: The macOS cassette gate is mandatory; the Android emulator leg is required for the umbrella sign-off but the harness must still report which legs ran and whether the missing leg is the cause of a non-green run.
- **Secrets in recorded traffic**: VCR redaction must scrub auth headers/cookies at record time so no secret enters a committed cassette (per #238 acceptance).

## Requirements

### Functional Requirements

- **FR-001**: The system MUST generate the `webview.*` tool suite from the module usecases (#243) via `zfa make --agent` in package mode, with no hand-written tool classes for the module surface.
- **FR-002**: The generated tool set MUST exactly equal the architecture doc §4.1 surface (`webview.browse`, `webview.intercept_browse`, `webview.search`, `webview.execute_js`, `webview.cookies.get`, `webview.cookies.set`, `webview.dialogue_dismiss`, `webview.screenshot`, `webview.pdf`, `webview.recipe.record`, `webview.recipe.replay`) — no additions or omissions.
- **FR-003**: The previously hand-built `WebviewMcpToolProvider` (#239) MUST be reduced to a thin registrar that registers the generated tool set into the zuraffa kernel registry via the `McpToolProvider` SPI (#386); it MUST NOT contain hand-written tool implementations.
- **FR-004**: Every generated tool MUST expose session ids as opaque strings with continuation semantics documented in its tool description, and tools that require a fresh identity MUST accept a `newSession` flag.
- **FR-005**: Generated tools MUST accept capture `filters`/`stopOn` as typed arguments with sane mobile defaults.
- **FR-006**: Any tool result exceeding the size threshold MUST be returned as a bounded `summary` plus an `artifactRef` to the full artifact, never as an unbounded inline payload.
- **FR-007**: The module MUST provide a cassette parity harness that records once via VCR (#238) and replays on every change, used as the CI regression gate.
- **FR-008**: The golden cassette set MUST cover at least 3 retailers × {browse, intercept, search per engine, dialogue dismiss, recipe replay}.
- **FR-009**: The harness MUST include a multi-engine degrade set (each engine's block cassette) and assert correct `webview.search` degradation.
- **FR-010**: The CI cassette suite MUST be green on macOS and the Android emulator and MUST be deterministic (10 identical replays of any golden cassette yield identical outcomes).
- **FR-011**: The dws_playground golden missions GM-2, GM-4, and GM-5 MUST be re-pointed at the module tools and MUST be green in CI to constitute umbrella (#241) parity sign-off.
- **FR-012**: A zuraffa consumer MUST be able to adopt the tools by importing the module registrar, and a non-zuraffa consumer MUST be able to use the thin core standalone; both import paths MUST be documented.
- **FR-013**: Cassettes MUST be redacted at record time so no auth headers or cookie values are persisted, and the cassette format MUST be versioned.
- **FR-014**: In replay mode, an unmatched live network call MUST fail hard (deterministic mode), configurable to soft for CI flakiness triage, so missing cassettes cannot silently pass.

### Key Entities

- **`webview.*` tool suite**: The generated agent tool set in the `webview` namespace, one tool per §4.1 surface entry, produced by the package-mode codegen from module usecases.
- **Module usecases (#243)**: The source-of-truth capabilities (headless browse, network intercept, multi-engine search, execute_js, cookies, dialogue dismiss, screenshot, pdf, recipe record/replay) from which the tools are generated.
- **`McpToolProvider` SPI / kernel registry (#386)**: The zuraffa extension point and registry into which the generated tool set is registered by the thin registrar.
- **Cassette (VCR #238 / CassetteEngine #242)**: A versioned, gzipped JSON recording of a web-view session (navigations, served HTML, network-capture events, cookie snapshots) used for deterministic replay.
- **Pool session handle (#237)**: The opaque web-view session identity threaded between tools for continuity (the `sessionId` continuation token).
- **Golden parrot set / multi-engine degrade set**: The committed cassettes that form the CI regression gate and the engine-failure degrade proof.
- **dws_playground golden missions (GM-2/GM-4/GM-5)**: End-to-end agent missions that exercise the module tools and provide umbrella parity sign-off.

## Success Criteria

### Measurable Outcomes

- **SC-001**: The generated tool list is byte-for-byte equal to the §4.1 surface, verified by an automated CI check, with zero hand-written module tool classes present in source.
- **SC-002**: A `webview.browse` → `intercept_browse` → `execute_js` sequence on one pooled instance uses exactly one live web view (single-instance assertion), proving session continuation works.
- **SC-003**: Oversized tool results are always returned as `summary` + `artifactRef`, confirmed by a fixture that exceeds the size threshold.
- **SC-004**: The cassette suite is green on macOS and the Android emulator, and replaying any golden cassette 10× yields identical mission outcomes (determinism measured, not assumed).
- **SC-005**: The golden cassette set covers ≥ 3 retailers across all required operations (browse, intercept, search per engine, dialogue dismiss, recipe replay) and includes a multi-engine degrade set with a verified degradation outcome.
- **SC-006**: dws_playground missions GM-2/GM-4/GM-5 pass against the module tools in CI, triggering umbrella #241 sign-off and #239 closure-as-superseded with a recorded name mapping.
- **SC-007**: Both a zuraffa-based consumer (via module registrar) and a standalone plugin-only consumer can use the surface, validated by documentation and an integration check.
- **SC-008**: No committed cassette contains auth headers or cookie values (redaction verified), and the cassette format carries a version field.

## Assumptions

- The module usecases (#243) are defined and stable enough to drive codegen before this feature is built; the generator (`zfa make --agent`, zuraffa #385/#389) supports package-mode emission of `McpToolProvider`-compatible tools.
- The §4.1 surface in the zik_zak architecture doc is the authoritative tool list and is final; tool renames require updating this spec and the generator source in lockstep.
- The VCR / CassetteEngine (#238/#242) and the zuraffa `McpToolProvider` SPI + registry (#386) are available and API-compatible with the generated output.
- macOS and an Android emulator are available in CI for the required gate legs; if the Android leg is temporarily unavailable, the harness reports it explicitly rather than masking the gap.
- dws_playground and its golden missions GM-2/GM-4/GM-5 are available and can be pointed at the module tools.
- Cassettes are recorded once against real retailers and treated as the regression reference; periodic re-recording is an operational task outside this feature's automated gate.
- The thin core (`HeadlessInAppWebView` and supporting controllers) remains usable standalone without the zuraffa runtime for non-agent consumers.
- Secrets are only those present in network traffic at record time; redaction hooks cover the documented auth header/cookie locations.
