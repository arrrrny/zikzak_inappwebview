---
feature: 010-network-capture-intercept
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 7
planned_at: abfa842e
updated_at: 15310f04
suite_baseline: green
---

# Test List: Network Capture — Mission-Grade Intercept

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md`. Each stays red until the feature works end to end through its real entry point.

| id  | behavior                                                    | traces     | kind      | state    | test                                      |
| --- | ----------------------------------------------------------- | ---------- | --------- | -------- | ----------------------------------------- |
| A1  | getSightings() returns non-empty, distiller-valid Sightings for a live retailer session | US1-AC1    | example   | PENDING  |                                           |
| A2  | getEntries() returns unchanged raw NetworkEntry objects when distillation is enabled | US1-AC2    | example   | PENDING  |                                           |
| A3  | getSightings() returns empty list (or passthrough) without throwing when no distiller configured | US1-AC3    | example   | PENDING  |                                           |
| A4  | Streaming API terminates early when stopOn condition matches a high-confidence product-API event | US2-AC1    | example   | PENDING  |                                           |
| A5  | Streaming API does not early-return when only low-confidence events arrive | US2-AC2    | example   | PENDING  |                                           |
| A6  | Early return includes triggering event and all previously streamed events in returned sightings | US2-AC3    | example   | PENDING  |                                           |
| A7  | Salvage flush emits all buffered-but-unreported events on cancellation before disposal | US3-AC1    | example   | PENDING  |                                           |
| A8  | Salvage flush emits all buffered events on timeout before teardown | US3-AC2    | example   | PENDING  |                                           |
| A9  | Zero-loss window (>1s) satisfied: events arriving >1s before cancellation are present in flush | US3-AC3    | example   | PENDING  |                                           |
| A10 | Per-domain maxEntries budget enforced: capture stops at limit for that domain only | US4-AC1    | example   | DONE     | `zikzak_inappwebview_platform_interface/test/types/network_capture_controller_budget_test.dart::enforces per-domain maxEntries budget; other domains keep capturing (A10)` |
| A11 | Per-domain maxBytes budget enforced: capture stops at limit for that domain only | US4-AC2    | example   | DONE     | `zikzak_inappwebview_platform_interface/test/types/network_capture_controller_budget_test.dart::enforces per-domain maxBytes budget on response bodies; others kept (A11)` |
| A12 | Per-domain maxBodySize budget enforced: bodies truncated to per-domain cap | US4-AC3    | example   | DONE     | `zikzak_inappwebview_platform_interface/test/types/network_capture_controller_budget_test.dart::enforces per-domain maxBodySize truncation; others kept whole (A12)` |
| A13 | Auth-shaped Authorization header values redacted at source before any consumer sees them | US5-AC1    | example   | DONE    | `test/network_capture_redaction_test.dart::redacts Authorization and session Cookie headers before any consumer (A13/A14)` |
| A14 | Session cookie values redacted at source before any consumer sees them | US5-AC2    | example   | DONE    | `test/network_capture_redaction_test.dart::redacts Authorization and session Cookie headers before any consumer (A13/A14)` |
| A15 | URL/body auth-shaped params (api_key, password) redacted at source before any consumer sees them | US5-AC3    | example   | DONE    | `test/network_capture_redaction_test.dart::redacts auth-shaped URL query and body params before any consumer (A15)` |
| A16 | SSO/auth-flow sequences detected and marked with auth classification | US6-AC1    | example   | PENDING  |                                           |
| A17 | Auth-marked entries have response body dropped entirely (null in getEntries/getSightings) | US6-AC2    | example   | PENDING  |                                           |
| A18 | Auth-marked entries carry auth tag and no body on stream and salvage flush | US6-AC3    | example   | PENDING  |                                           |
| A19 | Capture overhead with all features enabled < 5% page-load p50 on mid-tier Android | US7-AC1    | example   | PENDING  |                                           |
| A20 | Benchmark produces documented before/after numbers for overhead validation | US7-AC2    | example   | PENDING  |                                           |

## Inner loop: unit behaviors

_No plan.md present; inner loop skipped (outer-only mode)._

## Invariants and edge cases still to place

- Distiller throwing/malformed output: raw entry still retrievable, stream continues
- stopOn fires mid-event: event included or discarded consistently
- WebView disposed before salvage flush completes: race handled
- Per-domain budget vs distiller cap conflict: which wins documented
- Secret split across header and body: every occurrence redacted
- Redaction false positive: audit/escape path exists
- SSO misfire on non-login flow: body recoverable or documented as permanently dropped
- HeadlessInAppWebView torn down by pool manager: stream handled
- getSightings() called concurrently with active stream: snapshot consistent
- Global networkCaptureMaxBodySize vs per-domain maxBodySize: precedence documented

## Out of scope

- Password reset flow: separate feature
- Load behavior above 1000 concurrent sessions: no requirement
- SightingDistiller implementation: external dependency (arrrrny/dart_web_scraper#79)
- Session lifecycle / headless pool integration: provided by arrrrny/zikzak_inappwebview#237
- intercept_browse consumer: separate feature arrrrny/zikzak_inappwebview#239

## Verification commands

- Single test: `flutter test {file} --plain-name "{name}"`
- File tests: `flutter test {file}`
- Full suite: `flutter test`
- Coverage: `flutter test --coverage`