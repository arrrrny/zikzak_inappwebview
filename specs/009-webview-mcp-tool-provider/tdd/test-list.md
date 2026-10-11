---
feature: 009-webview-mcp-tool-provider
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 16
planned_at: f349d421
updated_at: f349d421
suite_baseline: blocked
---

# Test List: WebView MCP Tool Provider (webview.* Tool Suite)

> **Loop mode**: `outside-in`. `plan.md` is ABSENT for this feature, so the inner
> loop (unit behaviors grouped by component) is **skipped** — this is an
> **outer-only** list. The 16 acceptance scenarios from `spec.md` each become one
> outer-loop `A` behavior (A1–A16). Three additional acceptance-level behaviors
> (A17–A19) cover functional/measurable criteria with no matching scenario
> (provider registration/discoverability, fresh-identity `newSession`, and
> per-call capture overrides + mobile defaults). Unit behaviors that belong to
> components named in a future `plan.md` are catalogued under
> "Invariants and edge cases still to place" and must be placed into inner-loop
> tables before implementation starts.
>
> **Suite baseline**: `blocked`. The feature implements zuraffa's `McpToolProvider`
> SPI, so its tests run in the umbrella `zikzak_inappwebview` package, whose suite
> is blocked by the corrupted zuraffa pub-cache
> (`flutter pub cache repair` to unblock). The default stack
> (`zikzak_inappwebview_platform_interface`) is green at 300 tests and is the
> fallback for any pure-logic units later split out.

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md`. Each stays red until the feature works
end to end through its real entry point: the `WebviewMcpToolProvider` registered
with the agent kernel, invoked in-process via the `McpToolProvider` SPI (tool
listing + tool call). Assert on the returned result envelope (title/url/artifactRef,
Sighting set, link set, sessionId, partial/cancelled status, redaction), not on
internal collaborators.

| id  | behavior                                                                                              | traces               | kind    | state    | test |
| --- | ----------------------------------------------------------------------------------------------------- | -------------------- | ------- | -------- | ---- |
| A1  | `webview.browse` with a valid URL returns a result containing the page title, the resolved URL, and an `artifactRef` to the captured HTML. | AC-1                 | example | PENDING  |      |
| A2  | A follow-up tool call that reuses the `sessionId` returned by `webview.browse` acts on the **same** pooled webview instance rather than a fresh one. | AC-2                 | example | PENDING  |      |
| A3  | A tool call referencing a released `sessionId` either re-acquires the pooled instance or returns a clear "session not active" error rather than leaking or crashing. | AC-3                 | example | PENDING  |      |
| A4  | `webview.intercept_browse` with default capture settings returns a **bounded list of distilled Sightings**, not the raw intercepted event stream. | AC-4                 | example | PENDING  |      |
| A5  | When a page would exceed configured capture caps (event count, payload size, binary capture off by default), the distiller truncates the output to stay within bounds without erroring. | AC-5                 | example | PENDING  |      |
| A6  | Intercepting fixture pages representing real retailers yields a Sighting set that passes the same secret-free and bounded assertions the fixtures encode. | AC-6                 | example | PENDING  |      |
| A7  | `webview.search` with an explicit engine preference returns extracted result links for that engine.     | AC-7                 | example | PENDING  |      |
| A8  | When the preferred engine blocks/errors, `webview.search` falls back to the next engine in the defined order and still returns whatever links it could extract (no hard error). | AC-8                 | example | PENDING  |      |
| A9  | When all non-Google engines fail, `webview.search` attempts Google last and returns a usable (possibly partial) link set or an empty set with a clear degraded-status note. | AC-9                 | example | PENDING  |      |
| A10 | A cookie set via `webview.cookies.set` on a session is returned by `webview.cookies.get` and is usable by subsequent navigation. | AC-10                | example | PENDING  |      |
| A11 | `webview.dialogue_dismiss` clears a consent dialogue overlay so subsequent screenshot/PDF captures are unobstructed. | AC-11                | example | PENDING  |      |
| A12 | When a `webview.execute_js` result exceeds the configured size threshold, the payload is summarized inline with an `artifactRef` for the full output rather than inlined whole. | AC-12                | example | PENDING  |      |
| A13 | A recipe recorded with consent granted and replayed headlessly excludes user credentials from the trace and reproduces the captured steps. | AC-13                | example | PENDING  |      |
| A14 | Cancellation signalled mid-`intercept_browse` flushes already-distilled Sightings before disposing.    | AC-14                | example | PENDING  |      |
| A15 | After cancellation completes, the webview instance is returned to the pool with no leaked or orphaned live instances. | AC-15                | example | PENDING  |      |
| A16 | A cancelled mission's result is marked partial/cancelled rather than success and contains no half-written raw capture artifacts. | AC-16                | example | PENDING  |      |
| A17 | The `WebviewMcpToolProvider` registers with the agent kernel and every declared `webview.*` tool (`browse`, `intercept_browse`, `search`, `execute_js`, `cookies.get`, `cookies.set`, `dialogue_dismiss`, `screenshot`, `pdf`, `recipe.record`, `recipe.replay`) is discoverable (listed) and callable in-process. | SC-001, FR-001, FR-002 | example | PENDING  |      |
| A18 | Passing `newSession: true` on a reuse-defaulted tool provisions a fresh pooled instance and returns a new `sessionId` rather than reusing prior identity. | FR-004               | example | PENDING  |      |
| A19 | Per-call capture arguments (filters, caps, binary-capture) override defaults, and the mobile-tuned defaults keep captured artifact sizes within mobile-sane limits. | FR-014, SC-007       | example | PENDING  |      |

## Inner loop: unit behaviors

**SKIPPED — `plan.md` is absent for this feature.** No component list exists to
group unit behaviors under, so the inner loop cannot be opened yet. Behaviors that
are unit-level (and therefore not directly observable at the provider's public SPI
entry point) are collected under "Invariants and edge cases still to place" and
must be promoted into per-component tables once `plan.md` is written. The outer
loop above remains the contract that must pass end to end first.

## Invariants and edge cases still to place

Behaviors belonging to the feature that are unit-level or below the SPI surface and
await a `plan.md` component to attach to. Each must become a numbered `U` line in
an inner-loop table before the feature is implemented (outer loop stays red-first).

- **Deterministic distiller truncation policy** (caps overflow): when activity exceeds a cap, oldest/largest Sightings are dropped deterministically and the result stays bounded and secret-free (edge case "Distiller overflow"; supports A5/A6).
- **`newSession` vs reuse boundary**: `newSession: false` (default) reuses the pooled instance under the returned `sessionId`; only `newSession: true` provisions a fresh instance (edge case "Fresh identity required"; supports A18).
- **Per-engine "no usable results" detection**: each engine returning a bot-check/CAPTCHA/empty page is treated as soft failure and continues down the order; all engines failing yields an empty, clearly-degraded result (edge case "Search engine blocks"; supports A8/A9).
- **Oversized / non-serializable `execute_js` result**: results above threshold are summarized with an external `artifactRef`; extremely large or non-serializable results must not crash the tool (edge case "Oversized execute_js result"; supports A12).
- **Credential redaction is consent-independent**: recorded/replayed flows redact credential fields regardless of consent state; consent gates *recording* only (edge case "Credential hygiene in recipes"; supports A13).
- **Cancellation-arrival-between-events salvage**: a cancel arriving between captured events still emits a coherent partial set and guarantees pool release even if disposal is interrupted (edge case "Cancellation during capture"; supports A14/A15).
- **Mobile default tuning boundary**: defaults (binary capture off, tight caps, compact payloads) keep artifact sizes and memory within device limits; desktop callers may raise caps (edge case "Mobile default tuning"; supports A19).
- **Unknown / expired `sessionId` without `newSession`**: returns "session not active" and does not spawn an uncontrolled new instance unless `newSession: true` (edge case "Unknown or released sessionId"; supports A3).
- **Privacy invariant (sampled at boundaries, `kind: example`)**: no Sighting in any intercept result contains a credential/token value; no recipe trace contains a credential value. (No property library in the profile — sample fixtures at secret/secret-free and small/large boundaries.)

## Out of scope

Things a reader may expect on this list, and the one-line reason they are absent.

- **`WebViewPool` / session-handle (#237)**, **`SightingDistiller` (#79)**, **`CancelToken`/mission salvage (#388)**, and **VCR cassette infra (#238)**: assumed-provided dependencies (see spec Assumptions). Their internal implementation is tested by their own features; this suite consumes them through fakes/spies at the boundary.
- **Tool generation from module use-cases (#244)**: the spec states the exact generation mechanism is a follow-up and does not change the external contract documented here; not built in this feature.
- **Live network / real search-engine e2e**: covered by VCR cassettes (FR-016, SC-008) recorded offline; no live upstream calls in tests.
- **Native platform rendering of screenshot/PDF**: the visual fidelity of captured artifacts is a platform concern; this suite asserts the capture is produced and unobstructed (A11), not pixel content.

> **VCR / SC-008 note**: SC-008 (full suite passes end-to-end under VCR cassettes
> with no live network) is a cross-cutting test-harness property, not a single new
> acceptance behavior. It is satisfied by writing every `A` test above against
> recorded cassettes with live network disabled (FR-016). It is intentionally not
> added as a separate `A` line to avoid a redundant broad behavior.

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` at planning time, so this
file is readable on its own. Run from the **`zikzak_inappwebview`** package
directory (the relevant package for this feature — its suite is currently `blocked`
by the zuraffa pub-cache corruption; run `flutter pub cache repair` first).

- Single test: `flutter test --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`
