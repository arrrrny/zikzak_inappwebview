# Feature Specification: VCR Deterministic Record/Replay for HeadlessInAppWebView

**Feature Branch**: `008-vcr-record-replay`

**Created**: 2026-08-22

**Status**: Draft

**Input**: User description (GitHub issue #238): Agent-driven scraping must be regression-testable in CI without live network or real webviews. The webview side needs a "VCR" — record real traffic once (pages, XHR/fetch responses, cookies) into a cassette, then replay deterministically so a downstream agent can run full missions in CI. A wrapper around `HeadlessInAppWebView` captures navigations, served HTML, network-capture events (request/response/body), and cookie snapshots in record mode; in replay mode it serves cassette content without network (intercepting `loadUrl`, injecting recorded HTML via `loadData`, synthesizing network-capture events) so downstream distillation logic runs unmodified. Matching is keyed by (URL, normalized request) with best-match fallback; unmatched live calls in replay are a hard failure by default (configurable soft for CI flakiness triage). A redaction hook scrubs auth headers/cookies at record time. The cassette format is versioned and small (body size caps reuse capture settings, 50 KB default).

## User Scenarios & Testing

### User Story 1 - Record a live session into a deterministic cassette (Priority: P1)

A developer runs a real `HeadlessInAppWebView` session against a live retailer page. The VCR wrapper, in record mode, captures every navigation, the served HTML, each network-capture event (request/response/body), and a cookie snapshot into a single gzipped JSON cassette. This cassette becomes the artifact replayed later in CI.

**Why this priority**: Record is the foundation — without a captured cassette there is nothing to replay, and every downstream capability (replay determinism, redaction, the external eval harness) depends on it being produced correctly and deterministically.

**Independent Test**: Drive a `HeadlessInAppWebView` through a scripted navigation while the wrapper is in record mode, then assert the produced cassette exists, is valid gzipped JSON, and contains one entry per captured navigation with non-empty HTML and at least the expected network entries.

**Acceptance Scenarios**:

1. **Given** a live `HeadlessInAppWebView` session, **When** the wrapper is in record mode and the page navigates, **Then** each navigation produces a cassette entry capturing its URL, served HTML, and cookie snapshot.
2. **Given** record mode is active, **When** an XHR/fetch request completes, **Then** a network-capture event with request headers/body and response headers/body is appended to the cassette.
3. **Given** a completed recording, **When** the cassette is written, **Then** it is stored as gzipped JSON carrying a declared format version.

---

### User Story 2 - Replay a cassette without live network (Priority: P1)

A developer runs the same wrapper in replay mode inside CI. `loadUrl` calls are intercepted; the recorded HTML is injected via `loadData` and network-capture events are synthesized from the cassette so downstream distillation logic (e.g., `getHtml()` and the agent's network handlers) executes unmodified. No live network traffic occurs.

**Why this priority**: Replay is the primary consumer-facing capability — it lets CI run full agent missions without live webviews or network, which is the entire purpose of the feature.

**Independent Test**: Load a cassette in replay mode, call `loadUrl` with a recorded URL, and assert that `getHtml()` returns the recorded HTML and that the synthesized network-capture events exactly match the cassette's stored entries, with zero outbound network calls observed.

**Acceptance Scenarios**:

1. **Given** a cassette recorded for URL `U`, **When** replay mode receives `loadUrl(U)`, **Then** the recorded HTML for `U` is returned via `loadData` and no network request is made.
2. **Given** a recorded network event, **When** the corresponding request occurs during replay, **Then** the recorded response/body is synthesized and surfaced as a network-capture event identical to the recorded one.
3. **Given** replay mode, **When** downstream code calls `getHtml()`, **Then** it returns the recorded HTML without any change to the consuming logic.

---

### User Story 3 - Deterministic matching with best-match fallback and unmatched-call policy (Priority: P2)

In replay mode, cassette entries are keyed by (URL, normalized request). A request that exactly matches a key is served deterministically. A request with no exact match resolves via best-match fallback so minor ordering/header/body differences still resolve to a stable entry. A request that cannot be matched at all is treated as a hard failure by default, configurable to soft (logged warning, empty response) for CI flakiness triage.

**Why this priority**: Determinism is what makes CI results reproducible, but exact matching is too brittle for real pages; best-match plus a configurable unmatched policy balance strict reproducibility against day-to-day triage ergonomics.

**Independent Test**: Replay the same cassette 10 times across replayed missions and assert identical outcomes; separately, issue a request that matches only by URL (differing normalized body) and assert it resolves via best-match; issue a fully unmatched request and assert it fails hard by default and proceeds soft when configured.

**Acceptance Scenarios**:

1. **Given** a cassette, **When** the same mission is replayed 10 times, **Then** each run produces an identical mission outcome (same `getHtml()` and the same network-entry ordering).
2. **Given** a request whose normalized body differs but whose URL matches, **When** best-match fallback is enabled, **Then** the closest recorded entry is served deterministically.
3. **Given** an unmatched request in replay mode, **When** the unmatched policy is hard (default), **Then** the replay fails with a clear error naming the unmatched key.
4. **Given** an unmatched request and a soft policy, **When** replay proceeds, **Then** a warning is logged and an empty response is returned instead of failing.

---

### User Story 4 - Redaction of secrets at record time (Priority: P3)

Before a cassette is written, a redaction hook scrubs auth headers and cookie values so credentials never land in the artifact. This keeps committed cassettes safe to share under `test/fixtures/`.

**Why this priority**: Redaction is essential for the "cassettes are committable" acceptance criterion, but it is a record-time concern layered on top of the record/replay core, so it ranks below the core round-trip.

**Independent Test**: Record a session that includes an `Authorization` header and a session cookie, then read the raw cassette bytes and assert that no auth header value and no cookie value is present in the file.

**Acceptance Scenarios**:

1. **Given** a recorded request containing an `Authorization` header, **When** the redaction hook runs, **Then** the header value is scrubbed before the cassette is written.
2. **Given** a recorded cookie snapshot with session values, **When** redaction runs, **Then** cookie values are redacted from the cassette while non-secret metadata (name, domain, flags) may be retained.
3. **Given** a custom redaction rule, **When** it is supplied to the wrapper, **Then** it is applied to matching headers/cookies before the cassette is written.

---

### User Story 5 - Versioned, size-capped cassette format (Priority: P3)

Cassette files carry a declared format version so loaders can detect and reject incompatible files. Recorded response bodies are capped at the capture setting's default (50 KB); oversized bodies are truncated or dropped per capture settings rather than inflating the cassette.

**Why this priority**: Format versioning and size caps keep cassettes small and forward/backward compatible, supporting the "small cassette" and "committable examples" acceptance criteria, but they are non-functional guards rather than the core record/replay behavior.

**Independent Test**: Generate cassettes on two format versions and assert the loader rejects a mismatched/unknown version with a clear message; record a response larger than 50 KB and assert the stored body is capped at the configured limit.

**Acceptance Scenarios**:

1. **Given** a cassette, **When** it is loaded, **Then** its declared format version is validated against the supported version and rejected if incompatible.
2. **Given** a captured response body exceeding the size cap, **When** the cassette is written, **Then** the body is capped at the configured limit (default 50 KB) using the existing capture settings.
3. **Given** a cassette smaller than the cap, **When** it is written, **Then** it remains gzip-compressed and under a reasonable size threshold suitable for committing to the repo.

---

### Edge Cases

- A URL is navigated multiple times with different content: the cassette stores per-navigation entries in sequence; matching uses the (URL, normalized request) key together with occurrence order so repeated loads resolve to the correct capture.
- A recorded page issues requests that were not captured (e.g., unsupported scheme or skipped by capture settings): during replay these become unmatched calls and are handled by the unmatched policy (hard/soft).
- Redaction is disabled (or a custom hook is empty): the cassette may contain secrets; the wrapper must emit a warning or refuse to write to a commit path, configurable per environment.
- Gzip decompression or JSON parsing fails: the loader rejects the cassette with a clear "corrupt/unsupported" error rather than partially loading it.
- Best-match fallback still finds nothing: the request falls through to the unmatched policy exactly as if no entry existed.
- The cassette is empty (no navigations recorded): replay of any `loadUrl` becomes an unmatched hard failure by default.
- Platform differences: `HeadlessInAppWebView` behavior varies across Android/iOS/Web/Linux/Windows/macOS. The cassette format and matching logic are platform-independent, so a cassette recorded on one platform replays identically on any other supported platform.

## Requirements

### Functional Requirements

- **FR-001**: The system MUST provide a VCR wrapper around `HeadlessInAppWebView` that operates in record mode and replay mode through the same public API.
- **FR-002**: In record mode, the system MUST capture navigations, served HTML, network-capture events (request/response/body), and cookie snapshots into a single cassette artifact.
- **FR-003**: The cassette artifact MUST be serialized as gzipped JSON that declares a format version.
- **FR-004**: In replay mode, the system MUST intercept `loadUrl` and serve the recorded HTML via `loadData` without performing any live network requests.
- **FR-005**: In replay mode, the system MUST synthesize network-capture events from the cassette so downstream consumers (e.g., `getHtml()` and agent network handlers) run unmodified.
- **FR-006**: The system MUST key cassette entries by (URL, normalized request) and apply best-match fallback when an exact key match is unavailable.
- **FR-007**: In replay mode, an unmatched request MUST fail the replay by default (hard failure), and the failure mode MUST be configurable to soft (warn and return empty) for CI flakiness triage.
- **FR-008**: The system MUST apply a redaction hook at record time that scrubs auth headers and cookie values before the cassette is written.
- **FR-009**: The cassette format MUST be versioned, and the loader MUST reject cassettes whose declared version is unsupported.
- **FR-010**: The system MUST cap recorded response body size using the existing capture settings (default 50 KB) when writing the cassette.
- **FR-011**: The cassette format and matching logic MUST be platform-independent so a cassette recorded on one platform replays identically on any other supported platform.

### Key Entities

- **VCRWrapper / CassetteEngine**: The wrapper around `HeadlessInAppWebView` that provides record and replay modes through a shared API.
- **HeadlessInAppWebView**: The underlying headless web view whose traffic is captured (record) or synthesized (replay); the only web view type in scope.
- **Cassette**: The gzipped JSON artifact storing recorded navigations, served HTML, network events, and cookie snapshots, with a declared format version.
- **CassetteEntry**: A single recorded navigation keyed by (URL, normalized request), containing served HTML, associated network-capture events, and a cookie snapshot.
- **NetworkCaptureEvent**: A representation of a request/response/body pair captured during recording.
- **RedactionHook**: A function applied at record time to scrub auth headers and cookie values before the cassette is written.
- **UnmatchedPolicy**: An enumeration (hard / soft) controlling replay behavior for requests that cannot be matched to a cassette entry.
- **CaptureSettings**: Existing webview capture configuration (including the 50 KB body-size cap) reused by the cassette writer.

## Success Criteria

### Measurable Outcomes

- **SC-001**: A record→replay round-trip of a scripted product-page session yields identical `getHtml()` output and identical network entries compared to the recording.
- **SC-002**: A redaction test confirms that no auth header value or cookie value is present in any committed cassette file.
- **SC-003**: Replaying the same cassette 10 times yields identical mission outcomes (deterministic replay).
- **SC-004**: Example cassettes for at least 3 real retailer pages are committed under `test/fixtures/` and load/replay successfully.
- **SC-005**: A recorded response larger than the 50 KB body cap stores a capped body, keeping the cassette small and compressible.
- **SC-006**: The loader rejects cassettes with an unsupported or unknown format version and reports a clear, actionable error.

## Assumptions

- Record and replay share the same wrapper API so downstream agent code is unchanged between modes.
- `HeadlessInAppWebView` is the only web view type in scope; the full (non-headless) `InAppWebView` is out of scope for this feature.
- Network traffic during record is real; during replay it is fully synthesized — no live calls are made in replay mode.
- The normalized-request definition (canonicalized headers, query, and body) is stable across the supported platforms.
- Capture settings (including the 50 KB body cap) already exist and are reused; the feature does not introduce a separate, competing cap.
- Cassettes are intended to be committed to the repository under `test/fixtures/`, so redaction is mandatory by default.
- This VCR is a foundation feeding the external `zfa agent replay` eval harness (zuraffa) and the `dws_playground` scenario pack; those consumers are out of this module's scope but are the intended downstream users.
