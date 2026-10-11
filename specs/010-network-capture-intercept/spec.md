# Feature Specification: Network Capture — Mission-Grade Intercept

**Feature Branch**: `010-network-capture-intercept`

**Created**: 2026-08-22

**Status**: Draft

**Input**: GitHub issue #240 (arrrrny/zikzak_inappwebview). The existing Network Capture engine (pure-Dart JS injector, all platforms, headless-capable) intercepts a page's own XHR/fetch traffic so an AI agent or user can turn an unknown retailer's API calls into structured intelligence. This feature hardens that engine into a mission-grade interception product by (1) wiring a pluggable distillation post-processor so raw captures become distilled "Sightings", (2) exposing a live streaming event API so a browse mission can return early on a high-confidence product-API hit instead of always waiting for network idle, (3) guaranteeing a salvage flush that emits all buffered-but-unreported events before disposal on cancellation/timeout, (4) enforcing per-domain capture budgets (max entries, max bytes, max body size) at the capture level, (5) redacting auth-shaped secrets at the source before any consumer observes them, and (6) detecting SSO/auth-flow sequences, marking them `auth`, and dropping their bodies entirely — all while keeping capture overhead under 5% of page-load p50 on a mid-tier Android profile.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Distilled Sightings from a Live Retailer Session (Priority: P1)

An agent developer browsing an unknown retailer needs to call a single method on the capture controller and receive structured, distiller-valid Sightings (the distilled intelligence derived from the raw XHR/fetch traffic) rather than having to hand-parse raw `NetworkEntry` objects. Raw access via `getEntries()` must remain unchanged for callers who want unprocessed data; the new `getSightings()` path returns the distilled output produced by a pluggable post-processor (the `SightingDistiller`).

**Why this priority**: Distillation is the headline deliverable ("the gold mine" in the ZikZak AI agent architecture). Without it the captured traffic stays as opaque raw entries and the mission produces no usable API intelligence, which is the entire point of the feature.

**Independent Test**: Load a known retailer in an InAppWebView with capture + distillation enabled, let traffic settle, call `getSightings()`, and assert the returned objects are non-empty and validate against the distiller's Sighting contract (e.g. required fields present, classification populated). Verify `getEntries()` still returns the same raw entries it would without distillation enabled.

**Acceptance Scenarios**:

1. **Given** a WebView with network capture and a distiller post-processor configured, **When** a live session on a retailer yields XHR/fetch traffic, **Then** `getSightings()` returns a non-empty list of Sightings that pass the distiller's validity check and reflect the captured requests.
2. **Given** the same session, **When** `getEntries()` is called, **Then** it returns the raw `NetworkEntry` objects unchanged (the distillation post-processor does not mutate raw storage).
3. **Given** no distiller post-processor is configured, **When** `getSightings()` is called, **Then** it returns an empty `List<Sighting>` without throwing, and capture continues to operate normally.

---

### User Story 2 - Early Return on High-Confidence Product-API Hit (Priority: P1)

A browse mission (`intercept_browse`) must be able to terminate early — the moment a captured event is classified as a high-confidence product-API hit — instead of blocking until the network goes idle. The consumer configures a `stopOn` condition `{classification, minRank}`; when a streamed event matches, the mission returns with the sightings accumulated so far.

**Why this priority**: Waiting for full network idle is the slow path and wastes time on long-poll/SPA sites; early return is what makes the cold-path browse fast enough to be useful in an interactive agent loop.

**Independent Test**: Drive a mock session where a high-confidence product-API event arrives partway through streaming. Configure `stopOn` to match it. Assert the mission returns in less than the idle-wait duration and that the returned sightings include the triggering event.

**Acceptance Scenarios**:

1. **Given** streaming capture with `stopOn: {classification: product-api, minRank: 0.9}`, **When** an event arrives classified `product-api` with rank ≥ 0.9, **Then** the stream completes and the mission returns without waiting for network idle.
2. **Given** the same `stopOn` condition, **When** only low-confidence events (< minRank) arrive, **Then** the mission does not early-return and instead resolves on idle or timeout as before.
3. **Given** an early return has fired, **When** the capture controller is inspected, **Then** the sightings reported include the triggering event and all previously streamed events, and the remaining un-streamed events are handled under the budget rules (no unbounded growth).

---

### User Story 3 - Salvage Flush on Cancellation / Timeout (Priority: P1)

When a browse mission is cancelled or its timeout elapses mid-capture, every event already captured but not yet reported must be emitted (flushed) before the WebView/controller is disposed. This pairs with the zuraffa salvage protocol so no intelligence is silently lost.

**Why this priority**: A kill mid-capture without a flush means zero salvage and a permanently lost window of intelligence — directly defeating the mission-grade guarantee. This is the safety net that makes the other features usable in practice.

**Independent Test**: Start a capture, cancel/timeout it after some events have arrived but before idle, and assert that all pre-cancellation events are delivered on the stream/flush sink and that no event that arrived more than the documented loss window before cancellation is missing.

**Acceptance Scenarios**:

1. **Given** an active capture with buffered events, **When** the mission is cancelled, **Then** all buffered-but-unreported events are flushed to the consumer before disposal completes.
2. **Given** an active capture, **When** the configured timeout elapses, **Then** the salvage flush runs prior to teardown and the consumer receives the partial sightings set.
3. **Given** the documented loss window W (e.g. > 1s), **When** an event arrives and then cancellation occurs W after that event, **Then** that event is present in the flushed output (zero-loss window satisfied).

---

### User Story 4 - Per-Domain Capture Budgets (Priority: P2)

A mission must be able to bound resource usage at the capture layer with per-domain budgets: a maximum number of entries, a maximum total bytes, and a maximum body size per mission — enforced in addition to any distiller-side caps. When a budget is exceeded, capture for that domain is throttled/closed rather than silently consuming unbounded memory.

**Why this priority**: Budgets keep long or chatty sessions from exhausting device memory and keep capture cost predictable. They are part of the mission-grade hardening but are a guardrail rather than the core intelligence path, so P2.

**Independent Test**: Configure a per-domain budget (e.g. max 10 entries), drive 50 matching requests to that domain, and assert that capture stops/truncates for that domain at the limit while capture of other domains is unaffected.

**Acceptance Scenarios**:

1. **Given** a per-domain budget of `maxEntries: 10`, **When** more than 10 matching requests to that domain occur, **Then** only the first 10 are retained and further entries for that domain are dropped (or flagged budget-exceeded) without error.
2. **Given** a per-domain `maxBytes` budget, **When** accumulated captured bytes for that domain cross the limit, **Then** capture for that domain stops honoring the budget and other domains continue normally.
3. **Given** a `maxBodySize` lower than the global setting, **When** a large body arrives for that domain, **Then** it is truncated to the per-domain cap while bodies for other domains use their own (or the global) limit.

---

### User Story 5 - Secret Redaction at Source (Priority: P1)

Auth-shaped headers, cookies, and query/body parameters (tokens, session cookies, bearer credentials, etc.) must be flagged and redacted in the event stream before any consumer — raw callbacks, the controller, the distiller, or the stream — can see them. This is defense-in-depth alongside redaction the distiller may also perform.

**Why this priority**: Captured live traffic routinely carries bearer tokens and session cookies. Leaking these into logs, sightings, or the distiller would be a severe security defect; redaction at the source is non-negotiable for a mission-grade product.

**Independent Test**: Plant known secret tokens in request headers, cookies, and URL/body params during a capture session. Assert that across every stream tier (raw callbacks, `getEntries`, `getSightings`, salvaged flush) the planted values are absent and replaced with a redaction marker.

**Acceptance Scenarios**:

1. **Given** a request carrying a planted `Authorization: Bearer <token>` header, **When** the event is observed at any tier, **Then** the raw token value is absent and replaced by a redaction marker.
2. **Given** a request with a planted session cookie, **When** the event propagates, **Then** the cookie value is redacted before reaching raw callbacks, the controller, and the stream.
3. **Given** a request URL or body containing a planted `api_key`/`password` param, **When** captured, **Then** that param's value is redacted at the source and never appears in `getEntries()` or `getSightings()`.

---

### User Story 6 - SSO / Auth-Flow Detection (Priority: P2)

Sequences of events matching known login patterns must be detected, tagged with an `auth` classification, and their response bodies dropped entirely (no body retained) as a stronger guarantee than field-level redaction.

**Why this priority**: Login flows concentrate the highest-value secrets; dropping the body wholesale for detected auth sequences is the safest default and complements per-field redaction. P2 because it builds on the redaction and classification machinery of P1 stories.

**Independent Test**: Drive a synthetic login sequence (redirect to an IdP, token-exchange request, session-establishing response) and assert the matched entries are marked `auth` and that `getEntries()`/`getSightings()` expose no response body for them.

**Acceptance Scenarios**:

1. **Given** a sequence of events matching a configured login pattern, **When** captured, **Then** the involved entries are marked with an `auth` classification.
2. **Given** an entry marked `auth`, **When** the response body would normally be captured, **Then** the body is dropped entirely and is `null` in `getEntries()`/`getSightings()`.
3. **Given** an `auth`-marked entry, **When** it is emitted on the stream or salvage flush, **Then** it carries the `auth` tag and no body content.

---

### User Story 7 - Capture Overhead Within Budget (Priority: P2)

The added interception work (streaming, redaction, budgeting, salvage buffering) must keep total capture overhead under 5% of page-load p50 on a mid-tier Android profile, measured by a benchmark harness with before/after numbers.

**Why this priority**: If hardening the engine makes browsing materially slower, the mission-grade product becomes unusable on real devices. It is P2 only because it is a validation/non-functional gate rather than a user-facing capability.

**Independent Test**: Run the documented benchmark harness on a mid-tier Android profile for a reference page with capture fully enabled vs. a baseline without the new interception work; assert the delta is < 5% of p50 page load.

**Acceptance Scenarios**:

1. **Given** the benchmark harness running on a mid-tier Android profile, **When** capture (streaming + redaction + budgets + salvage) is enabled, **Then** page-load p50 increases by less than 5% versus the no-capture baseline.
2. **Given** the benchmark run, **When** completed, **Then** documented before/after numbers are produced and committed as the overhead evidence.

---

### Edge Cases

- What happens when a distiller post-processor throws or returns malformed Sightings — is the raw entry still retrievable and does the stream continue?
- What happens to a partially-streamed event when `stopOn` fires mid-event — is it included or discarded?
- What happens if the WebView is disposed before the salvage flush completes (race between dispose and flush)?
- What happens when a per-domain budget is hit but the distiller cap for the same domain is not, or vice versa — which wins?
- What happens when a secret is split across a header and a body param (e.g. a token echoed in the response) — is every occurrence redacted?
- What happens when redaction rules themselves receive a value that looks like a secret but is benign (false positive) — is there an audit/escape path?
- What happens when SSO detection misfires on a non-login flow — is the body recoverable or permanently dropped?
- What happens to the stream when capture is enabled on a `HeadlessInAppWebView` and the headless instance is torn down by the pool manager (issue #237)?
- What happens when `getSightings()` is called concurrently with an active stream — is the snapshot consistent?
- What happens when `networkCaptureMaxBodySize` (global) and the per-domain `maxBodySize` conflict — which takes precedence?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The capture pipeline (`NetworkCaptureManager` → `NetworkCaptureController`) MUST expose a pluggable post-processor slot that a `SightingDistiller`-compatible distiller can be wired into, producing distilled output without altering raw entry storage.
- **FR-002**: The `NetworkCaptureController` MUST continue to provide `getEntries()` returning raw `NetworkEntry` objects exactly as before, and MUST additionally provide `getSightings()` returning the distiller-valid distilled output for the same session.
- **FR-003**: The capture engine MUST expose a live streaming event API (not only bulk `getEntries`/`getSightings` collection) so consumers can react to each captured event as it arrives.
- **FR-004**: The streaming API MUST accept a configurable `stopOn` condition `{classification, minRank}` and MUST terminate/return early when a streamed event matches the condition, rather than always waiting for network idle.
- **FR-005**: On cancellation or timeout of an active capture, the engine MUST emit (salvage-flush) all buffered-but-unreported events to the consumer before the WebView/controller is disposed, with a documented zero-loss window (e.g. > 1s).
- **FR-006**: The capture layer MUST enforce per-domain budgets of maximum entries, maximum total bytes, and maximum body size per mission, independently of and in addition to any distiller-side caps.
- **FR-007**: The engine MUST redact auth-shaped secrets (headers, cookies, and URL/body parameters) at the source, before the event is delivered to raw callbacks, the controller, the stream, or the distiller.
- **FR-008**: The engine MUST detect SSO/auth-flow event sequences, mark the involved entries with an `auth` classification, and MUST drop their response bodies entirely.
- **FR-009**: Redaction and `auth`-body-dropping MUST apply uniformly across every consumer tier — raw callbacks, `getEntries()`, `getSightings()`, and the salvage flush — with no tier receiving un-redacted secrets.
- **FR-010**: The engine MUST keep added capture overhead (streaming, redaction, budgeting, salvage buffering) below 5% of page-load p50 on a mid-tier Android profile, validated by a benchmark harness that emits before/after numbers.
- **FR-011**: All new capture behavior MUST remain pure-Dart + JavaScript-injection based and MUST behave identically across Android, iOS, macOS, and for both visible and `HeadlessInAppWebView` instances, preserving the existing platform-independence of the engine.

### Key Entities

- **NetworkCaptureManager**: The Dart-side engine that builds the interceptor `UserScript`, registers the `__zikzakNetworkCapture__` JS handler, deduplicates and routes captured events, and owns the salvage/streaming/budget lifecycle. Lives in the main package.
- **NetworkCaptureController**: The collector that accumulates `NetworkEntry` request/response/body/error events and exposes `getEntries()`/`getBodies()`/`waitForIdle()`. Extended by this feature with `getSightings()` and the streaming/salvage surface and per-domain budget state. Lives in the platform interface.
- **SightingDistiller (external, arrrrny/dart_web_scraper#79)**: The pluggable post-processor that turns raw captures into distilled "Sightings". Wired into the capture pipeline via the post-processor slot.
- **Sighting**: The distilled, structured output object returned by `getSightings()`; validated against the distiller's contract.
- **CaptureBudget**: Per-domain configuration of `maxEntries`, `maxBytes`, and `maxBodySize` enforced at capture level.
- **StopOnCondition**: A `{classification, minRank}` predicate that drives early return on the streaming API.
- **SecretRedactor**: The source-level redaction ruleset flagging auth-shaped headers/cookies/params and replacing their values with a redaction marker.
- **SalvageFlush**: The pre-dispose emission of all buffered-but-unreported events, paired with the zuraffa salvage protocol (arrrrny/zuraffa#388).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: `getSightings()` returns a non-empty, distiller-valid list of Sightings for a live session on at least 3 distinct retailers, while `getEntries()` continues to return the unchanged raw entries.
- **SC-002**: With a configured `stopOn` condition, a high-confidence product-API hit triggers mission return in less than the network-idle wait time, and the returned sightings include the triggering event.
- **SC-003**: Cancellation or timeout mid-capture results in all pre-cancellation events being flushed to the consumer with zero loss beyond the documented window (e.g. > 1s).
- **SC-004**: A redaction test suite confirms planted tokens, cookies, and auth URL/body params are absent from every stream tier (raw callbacks, `getEntries`, `getSightings`, salvage flush) and replaced with a redaction marker.
- **SC-005**: Per-domain budgets (max entries / max bytes / max body size) are enforced so capture for an over-budget domain stops at the limit while other domains continue unaffected.
- **SC-006**: SSO/auth-flow sequences are marked `auth` and their response bodies are dropped entirely, with no body content reachable via any consumer tier.
- **SC-007**: Capture overhead with all new interception work enabled is documented before/after and stays below a 5% increase on page-load p50 for a mid-tier Android profile.

## Assumptions

- The `SightingDistiller` post-processor contract (arrrrny/dart_web_scraper#79) is available and stable enough to wire into the capture pipeline as a pluggable slot; if absent, `getSightings()` returns an empty `List<Sighting>` without breaking raw capture.
- Session lifecycle (creation/teardown of the WebView and headless pool) is provided by the pool work (arrrrny/zikzak_inappwebview#237), and the capture engine integrates with its dispose path to trigger the salvage flush.
- The consumer that drives early-return (`intercept_browse`, arrrrny/zikzak_inappwebview#239) reads `getSightings()` and the streaming API; this spec defines the producer side and assumes that consumer contract.
- The existing pure-Dart + JS-injection capture engine remains the implementation substrate, so platform parity (Android/iOS/macOS, headless) is preserved without native per-platform changes.
- Mid-tier Android profile and the benchmark harness referenced for SC-007 are those used by the project's existing performance testing, and a reproducible baseline (capture disabled) exists for comparison.
- Secret redaction at source and distiller-level redaction are complementary (defense in depth); this spec owns the source-level layer and does not assume the distiller performs it.
