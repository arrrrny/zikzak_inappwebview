---
feature: 010-network-capture-intercept
loop: outside-in # the feature has a real public surface: getSightings(), the streaming/salvage API, stopOn + per-domain budgets config
profile: .specify/memory/tdd-profile.md
spec_criteria: 20 # acceptance scenarios in spec.md (3+3+3+3+3+3+2 across the 7 user stories); 7 success criteria (SC-001..SC-007) are the measurable roll-ups
planned_at: f349d421
updated_at: f349d421
suite_baseline: blocked # zuraffa pub-cache corruption — run `flutter pub cache repair`; NetworkCaptureManager (the engine headline entity) lives in the umbrella `zikzak_inappwebview` package. Note: zikzak_inappwebview_platform_interface stays GREEN and hosts the controller-level unit work once plan.md exists.
---

# Test List: Network Capture — Mission-Grade Intercept

> **Loop note:** `plan.md` is absent for this feature, so this is an **outer-only**
> plan. The inner loop (unit behaviors grouped by component) is intentionally
> skipped — see "Invariants and edge cases still to place" for what belongs there.
> When `plan.md` is written, re-run `/speckit.tdd.plan` to append the inner tables.

## Outer loop: acceptance behaviors

One per acceptance scenario in `spec.md` (in spec order). Each stays red until the
feature works end to end through its real entry point: the `NetworkCaptureManager`
→ `NetworkCaptureController` capture pipeline (`getSightings()`, the streaming/salvage
surface, `stopOn`, per-domain `CaptureBudget`, `SecretRedactor`, `auth` sequence
detection) on a real InAppWebView / `HeadlessInAppWebView` session.

| id  | behavior                                                                                                              | traces            | kind    | state    | test |
| --- | -------------------------------------------------------------------------------------------------------------------- | ----------------- | ------- | -------- | ---- |
| A1  | With a distiller wired in, `getSightings()` returns a non-empty list of distiller-valid Sightings reflecting the captured requests. | SC-001, FR-001, FR-002, FR-003 | example | PENDING  |      |
| A2  | With a distiller wired in, `getEntries()` still returns the raw `NetworkEntry` objects unchanged (distillation does not mutate raw storage). | SC-001, FR-002 | example | PENDING  |      |
| A3  | With no distiller configured, `getSightings()` returns an empty list without throwing and capture continues normally.  | SC-001, FR-002    | example | PENDING  |      |
| A4  | With `stopOn: {classification: product-api, minRank: 0.9}`, a streamed event matching it completes the stream and the mission returns before network idle. | SC-002, FR-003, FR-004 | example | PENDING  |      |
| A5  | With the same `stopOn`, when only sub-`minRank` events arrive the mission does NOT early-return and resolves on idle/timeout as before. | SC-002, FR-004    | example | PENDING  |      |
| A6  | After an early return, the reported sightings include the triggering event plus all previously streamed events, and remaining events stay bounded by the budget rules (no unbounded growth). | SC-002, FR-004, FR-006 | example | PENDING  |      |
| A7  | On mission cancellation mid-capture, all buffered-but-unreported events are flushed to the consumer before disposal completes. | SC-003, FR-005    | example | PENDING  |      |
| A8  | When the configured timeout elapses, the salvage flush runs prior to teardown and the consumer receives the partial sightings set. | SC-003, FR-005    | example | PENDING  |      |
| A9  | An event arriving within the documented loss window W before cancellation is present in the flushed output (zero-loss window satisfied). | SC-003, FR-005    | example | PENDING  |      |
| A10 | With `maxEntries: 10`, when > 10 matching requests to that domain occur only the first 10 are retained and the rest are dropped/flagged budget-exceeded without error. | SC-005, FR-006    | example | PENDING  |      |
| A11 | When accumulated bytes for a domain cross `maxBytes`, capture for that domain stops honoring the budget while other domains continue normally. | SC-005, FR-006    | example | PENDING  |      |
| A12 | With a per-domain `maxBodySize` below the global setting, a large body for that domain is truncated to the per-domain cap while other domains use their own/global limit. | SC-005, FR-006    | example | PENDING  |      |
| A13 | A planted `Authorization: Bearer <token>` is absent and replaced by a redaction marker at every tier (raw callbacks, `getEntries`, `getSightings`, salvage flush). | SC-004, FR-007, FR-009 | example | PENDING  |      |
| A14 | A planted session cookie value is redacted before reaching raw callbacks, the controller, and the stream.             | SC-004, FR-007, FR-009 | example | PENDING  |      |
| A15 | A planted `api_key`/`password` param in a request URL or body is redacted at the source and never appears in `getEntries()`/`getSightings()`. | SC-004, FR-007, FR-009 | example | PENDING  |      |
| A16 | A sequence of events matching a configured login pattern is detected and the involved entries are marked with the `auth` classification. | SC-006, FR-008    | example | PENDING  |      |
| A17 | An `auth`-marked entry has its response body dropped entirely — `null` in `getEntries()`/`getSightings()`.                | SC-006, FR-008, FR-009 | example | PENDING  |      |
| A18 | An `auth`-marked entry emitted on the stream or salvage flush carries the `auth` tag and contains no body content.       | SC-006, FR-008, FR-009 | example | PENDING  |      |
| A19 | On the benchmark harness (mid-tier Android profile), enabling capture (streaming + redaction + budgets + salvage) raises page-load p50 by less than 5% versus the no-capture baseline. | SC-007, FR-010    | example | PENDING  |      |
| A20 | The benchmark run produces and commits before/after numbers as the overhead evidence.                                   | SC-007, FR-010    | example | PENDING  |      |

## Inner loop: unit behaviors

**Skipped — `plan.md` is absent.** The component-level behaviors below belong here
once the design is recorded, grouped by owning file (`NetworkCaptureController` in
`zikzak_inappwebview_platform_interface`, `NetworkCaptureManager` in
`zikzak_inappwebview`, plus the new `SightingDistiller` slot, `CaptureBudget`,
`StopOnCondition`, `SecretRedactor`, and `SalvageFlush` components). Re-run
`/speckit.tdd.plan` after `plan.md` exists to generate these tables.

## Invariants and edge cases still to place

These are derived from the spec's Edge Cases section and belong in the inner loop
(per-component), so they are listed here as not-yet-placed. Each must become a
numbered `U` line under its owning component once `plan.md` exists, or be dropped
with a reason.

- A throwing/malformed distiller still leaves the raw entry retrievable via `getEntries()` and the stream continues (US1 edge case).
- A partially-streamed event when `stopOn` fires mid-event is either included or discarded deterministically (US2 edge case).
- WebView disposed before the salvage flush completes — flush/teardown race is safe (US3 edge case).
- Per-domain budget hit while distiller cap not (and vice versa) — defined precedence (US4 edge case).
- A secret split across a header and a body param (echoed in response) — every occurrence redacted (US5 edge case).
- A benign value that looks like a secret — false-positive audit/escape path (US5 edge case).
- SSO detection misfires on a non-login flow — body recoverable, not permanently dropped (US6 edge case).
- Streaming on `HeadlessInAppWebView` torn down by the pool manager (issue #237) still flushes (US6/edge case).
- Concurrent `getSightings()` during an active stream yields a consistent snapshot (US6 edge case).
- `networkCaptureMaxBodySize` (global) vs per-domain `maxBodySize` conflict — per-domain takes precedence (US4 edge case).

## Out of scope

- **Distiller contract internals (`SightingDistiller`, arrrrny/dart_web_scraper#79):** external library; this feature tests the *wiring/slot* (FR-001) and graceful empty/passthrough degrade (A3), not the distiller's own logic.
- **Headless pool manager teardown integration (issue #237):** the dispose-path hookup that triggers the salvage flush is owned by the pool work; this feature defines the `SalvageFlush` producer contract, not the pool's lifecycle.
- **Benchmark harness infrastructure (SC-007):** the harness and the mid-tier Android profile are pre-existing project perf tooling; A19/A20 observe its output, they do not build it.
- **Native per-platform capture changes:** FR-011 keeps the pure-Dart + JS-injection substrate; no new native Android/iOS/macOS code is in scope, so there are no platform-native unit behaviors here.
- **Umbrella/module acceptance suites:** blocked by the zuraffa pub-cache corruption; their green run requires `flutter pub cache repair` (see suite_baseline).

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` at planning time. Run each
**from the package's own directory** (`cwd` noted per block) — never the repo root.

### Default / green stack — `zikzak_inappwebview_platform_interface` (`cwd: zikzak_inappwebview_platform_interface`)

- Single test: `flutter test --plain-name "{name}"`
- File: `flutter test {file}`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

### Umbrella package — `zikzak_inappwebview` (`cwd: zikzak_inappwebview`, **blocked** by zuraffa corruption)

- Single test: `flutter test --plain-name "{name}"`
- File: `flutter test {file}`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

> The feature's engine entity `NetworkCaptureManager` lives in the umbrella package,
> so its streaming / stopOn / salvage-flush acceptance tests will run there once the
> cache is repaired. Unit behaviors on `NetworkCaptureController` (budgets, redaction,
> `auth` tagging, `getSightings` passthrough) can be exercised on the green
> `platform_interface` stack.
