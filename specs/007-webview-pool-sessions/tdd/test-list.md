---
feature: 007-webview-pool-sessions # spec-kit feature directory name
loop: outside-in # feature has a real user-visible surface: the WebViewPool public API
profile: .specify/memory/tdd-profile.md # stack profile the commands must read
spec_criteria: 18 # acceptance scenarios enumerated in spec.md (US1..US5)
planned_at: f349d421 # short SHA the list was derived from
updated_at: f349d421 # short SHA of the last change to this file
suite_baseline: blocked # umbrella/module blocked: zuraffa pub-cache corruption — run `flutter pub cache repair`
---

# Test List: WebViewPool — Mission-Scoped Sessions, Domain Affinity, and Memory-Pressure Disposal

> **Inner loop skipped (outer-only).** `plan.md` is absent for this feature, so no
> component-level unit behaviors (`U1`, `U2`, …) are listed. Every behavior below is
> an acceptance behavior driven through the real `WebViewPool` public API. The edge
> cases from spec.md are collected under "Invariants and edge cases still to place"
> and must be placed (as outer acceptance behaviors or inner unit behaviors) once
> `plan.md` exists.

## Outer loop: acceptance behaviors

One per acceptance criterion (acceptance scenario) in `spec.md`, in spec order. Each
stays PENDING (no test written yet) — this is a brand-new public API, so no existing
test in the repo covers any of these. Each is observable through the pool's real entry
point (`acquire` / `release` / `disposeAll` / `liveCount` / `sessions()`), not through
units beneath it.

| id  | behavior                                                                                              | traces                  | kind    | state    | test |
| --- | ----------------------------------------------------------------------------------------------------- | ----------------------- | ------- | -------- | ---- |
| A1  | Acquiring a session with no instance creates a new headless web view and `liveCount` becomes 1        | FR-001, FR-005, FR-006, SC-001 | example | PENDING  |      |
| A2  | Re-acquiring the same live session returns the same instance and creates no second instance           | FR-005, SC-001          | example | PENDING  |      |
| A3  | Releasing a live session returns it idle, drops it from `sessions()` active set, and `liveCount` drops | FR-005, FR-006, SC-001  | example | PENDING  |      |
| A4  | `disposeAll()` with several live sessions disposes every instance and `liveCount` returns to 0        | FR-005, SC-001          | example | PENDING  |      |
| A5  | Acquiring with an eTLD+1 hint reuses a warm idle instance already scoped to that eTLD+1 (affinity hit) | FR-002, SC-003          | example | PENDING  |      |
| A6  | A subsequent affine reuse keeps the prior session's cookie/JS execution context available to the caller | FR-002, SC-003          | example | PENDING  |      |
| A7  | Acquiring an unknown eTLD+1 reuses any available generic idle instance re-scoped, or creates a new one  | FR-002, SC-003          | example | PENDING  |      |
| A8  | `sessions()` reports each entry's current eTLD+1 domain association                                    | FR-006, SC-003          | example | PENDING  |      |
| A9  | An idle instance past its idle TTL is disposed by the eviction sweep and `liveCount` decreases         | FR-003, SC-004, SC-005   | example | PENDING  |      |
| A10 | An affine acquire past the max-per-domain cap evicts the oldest idle instance of that domain, not exceeding the cap | FR-003, SC-005   | example | PENDING  |      |
| A11 | A memory-pressure / lifecycle pause disposes idle instances first while an actively-acquired one stays usable | FR-004, SC-004    | example | PENDING  |      |
| A12 | The effective max-live cap defaults to a platform-appropriate value on each target platform (mobile lower, desktop higher) | FR-003, SC-005 | example | PENDING |  |
| A13 | K concurrent `acquire` calls for one session create exactly one instance; `liveCount` is 1 for that id  | FR-007, SC-002, SC-006   | example | PENDING  |      |
| A14 | Concurrent acquisitions across M distinct sessions leave `liveCount` == M with no aliased instances     | FR-007, SC-002, SC-006   | example | PENDING  |      |
| A15 | A high-contention burst completes with no exception/deadlock and introspection stays consistent         | FR-007, SC-006          | example | PENDING  |      |
| A16 | `acquire` settings with capture filters are applied to the issued instance only                         | FR-008, SC-007          | example | PENDING  |      |
| A17 | Two sessions with different `InAppWebViewSettings` each retain only their own configuration            | FR-008, SC-007          | example | PENDING  |      |
| A18 | An `acquire` with no settings override issues an instance using the pool's default base configuration    | FR-008, SC-007          | example | PENDING  |      |

## Inner loop: unit behaviors

**Skipped.** No `plan.md` exists for `007-webview-pool-sessions`, so there are no
component files to attach unit behaviors to. Produce `plan.md` and re-run
`/speckit.tdd.plan` to generate `U1`… behaviors (happy path, both sides of every cap
threshold, specific error/no-op paths, and invariants such as affinity round-trip and
idempotent `disposeAll`).

## Invariants and edge cases still to place

Behaviors in `spec.md` (Edge Cases) that are observable through the public API and must
become numbered lines above once `plan.md` is available (or be promoted to acceptance
behaviors). Each must be placed before the feature is done, or dropped with a reason.

- Acquire for a previously-disposed session creates a fresh instance; disposed state is never resurrected.
- `release` on an unknown / never-acquired sessionId is a safe no-op and leaves introspection intact.
- Re-entrant `acquire`/`release` for the same id resolves to a consistent final state (release during in-flight acquire).
- A memory-pressure event while an instance is actively in use never disposes that in-use instance.
- A null / omitted domain hint is treated as a generic (non-affine) acquisition that may still reuse any idle instance.
- eTLD+1 extraction degrades gracefully for multi-part TLDs, IP addresses, and localhost (exact-match, no throw).
- On Web/Windows/Linux (no lifecycle signal) the memory-pressure hook is a no-op/best-effort while caps and TTL still apply.
- `sessions()` / introspection called concurrently with mutations returns a consistent snapshot without throwing.

## Out of scope

Things a reader may expect on this list and the one-line reason they are absent.

- Native web view rendering / `HeadlessInAppWebView` internals: those types already exist in the plugin; the pool issues and reuses them, it does not redefine them.
- `webview.*` MCP tool provider wiring: explicitly excluded by spec.md (FR-010) — the pool must have no MCP/zuraffa coupling.
- `dart_web_scraper` integration: an external consumer reached via the public session API; not part of the pool's own test surface.
- Platform-specific `MethodChannel` native handlers: the pool is a pure-Dart singleton; native contracts belong to the platform packages' own suites.

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` at planning time (umbrella
`zikzak_inappwebview` stack, the package this feature targets), so this file is readable
on its own:

- Single test: `flutter test --plain-name "{name}"`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`

> **Note:** the umbrella and `zikzak_inappwebview_module` suites are `blocked` at
> baseline by a corrupted `zuraffa` pub-cache extraction. Run `flutter pub cache repair`
> before relying on the suite; the inner loop's single-test command is usable once the
> cache is repaired.
