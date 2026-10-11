# Bug Issue: network capture: mission-grade intercept — distillation integration, streaming events, salvage flush, capture budgets

- **Slug**: network-capture-intercept
- **Fetched**: 2026-08-22T21:09:19
- **Issue**: 240
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/240
- **State**: open
- **Severity**: unknown
- **Author**: arrrrny
- **Labels**: zikzak-ai

## Body

## Context

The flagship cold-path capability: while the agent (or user) browses an unknown retailer, capture the site's own XHR/fetch traffic and turn it into structured API intelligence. The capture engine already exists (pure-Dart JS injector, all platforms, headless-capable); this issue hardens it into a **mission-grade interception product** with distillation baked in.

## Requirements

1. **Distillation integration**: capture pipeline (NetworkCaptureManager → NetworkCaptureController) gains a pluggable post-processor slot wired to the SightingDistiller (arrrrny/dart_web_scraper#79) — `getEntries()` stays raw, new `getSightings()` returns distilled output.
2. **Streaming capture events**: live event stream (not just bulk collect) so `intercept_browse` can return early on high-confidence product-API hit (configurable `stopOn: {classification, minRank}`) instead of always waiting for idle.
3. **Salvage flush**: cancellation/timeout path emits all buffered-but-unreported events before dispose (pairs with zuraffa salvage protocol, arrrrny/zuraffa#388).
4. **Per-domain capture budgets**: max entries, max bytes, max body size per mission (in addition to distiller caps) enforced at capture level.
5. **Secret redaction at source**: auth-shaped headers/cookies/params flagged and redacted in the event stream before any consumer sees them (defense in depth with distiller).
6. SSO/auth-flow detection: sequences matching login patterns are marked `auth` and bodies dropped entirely.
7. Performance: capture overhead < 5% page-load p50 on a mid-tier Android profile (benchmark harness).

## Acceptance criteria

- [ ] `getSightings()` returns distiller-valid Sightings from a live session on 3 retailers
- [ ] `stopOn` early-return test: product-API hit returns in < idle-time; remaining events discarded but budget-safe
- [ ] Cancellation salvage: kill mid-capture → all pre-kill events flushed, zero loss window > 1s
- [ ] Redaction test suite (tokens/cookies/auth params planted → absent from every stream tier)
- [ ] Overhead benchmark documented before/after

## Dependencies

- arrrrny/dart_web_scraper#79 (distiller — post-processor contract)
- arrrrny/zikzak_inappwebview#237 (pool — session lifecycle)
- Pairs with arrrrny/zikzak_inappwebview#239 (provider consumes this via intercept_browse)

---
Part of the ZikZak AI agent architecture — `docs/architecture/zikzak-ai-agent-architecture.md` in arrrrny/zik_zak (§4.2 — "the gold mine").


## Comments

**arrrrny** (2026-08-18T10:31:16Z):

MAESTRO: https://github.com/arrrrny/zik_zak/issues/176

Pairs-with: arrrrny/zikzak_inappwebview#239 (intercept_browse consumes getSightings)


**arrrrny** (2026-08-18T10:46:43Z):

MAESTRO: https://github.com/arrrrny/zik_zak/issues/176

Wave Z re-home: mission-grade intercept is implemented as the module's capture service over raw plugin events (arrrrny/zikzak_inappwebview#242). MAESTRO: arrrrny/zik_zak#176

