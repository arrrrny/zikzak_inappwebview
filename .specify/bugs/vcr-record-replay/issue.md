# Bug Issue: VCR: deterministic record/replay for HeadlessInAppWebView (CI-grade)

- **Slug**: vcr-record-replay
- **Fetched**: 2026-08-22T21:09:19
- **Issue**: 238
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/238
- **State**: open
- **Severity**: unknown
- **Author**: arrrrny
- **Labels**: zikzak-ai

## Body

## Context

Agent-driven scraping must be regression-testable in CI without live network or real webviews. dart_agent_core's eval replay covers the LLM side only; the webview side needs a **VCR**: record real traffic once (pages, XHR/fetch responses, cookies), then replay deterministically so `zfa agent replay` (zuraffa issue "zfa agent CLI + golden-mission eval harness") can run full missions in CI.

## Requirements

1. Record mode: a wrapper around `HeadlessInAppWebView` capturing navigations, served HTML, network-capture events (request/response/body), and cookie snapshots into a **cassette** file (JSON, gzipped).
2. Replay mode: same wrapper serves cassette content without network — intercepting `loadUrl`, injects recorded HTML via `loadData`, synthesizes network-capture events from the cassette so downstream distillation logic runs unmodified.
3. Determinism: cassette keyed by (URL, normalized request) with best-match fallback; unmatched live calls in replay mode = hard failure (configurable soft for CI flakiness triage).
4. Redaction hook applied at record time (auth headers/cookies scrubbed before cassette write).
5. Cassette format versioned; small — body size caps reuse the capture settings (50 KB default).

## Acceptance criteria

- [ ] Record → replay round-trip of a scripted product-page session yields identical `getHtml()` + network entries
- [ ] Cassette redaction test: no auth header/cookie value present in file
- [ ] Replay determinism: same cassette, 10 runs, identical mission outcome
- [ ] Cassettes for 3 real retailer pages committed under `test/fixtures/` as examples

## Dependencies

None — foundation. Feeds zuraffa `zfa agent replay` eval harness and dws_playground scenario pack.

---
Part of the ZikZak AI agent architecture — `docs/architecture/zikzak-ai-agent-architecture.md` in arrrrny/zik_zak (code-review gap #7).


## Comments

**arrrrny** (2026-08-18T10:30:57Z):

MAESTRO: https://github.com/arrrrny/zik_zak/issues/176

Unblocks: arrrrny/dart_web_scraper#81 (VCR-compatible tools), arrrrny/zikzak_inappwebview#239, arrrrny/dws_playground#7 (cassette missions)


**arrrrny** (2026-08-18T10:46:40Z):

MAESTRO: https://github.com/arrrrny/zik_zak/issues/176

Wave Z re-home: VCR becomes the module's CassetteEngine (arrrrny/zikzak_inappwebview#242) and its CI parity gate (arrrrny/zikzak_inappwebview#244). MAESTRO: arrrrny/zik_zak#176

