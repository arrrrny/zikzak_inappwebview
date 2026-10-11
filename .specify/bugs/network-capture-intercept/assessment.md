# Bug Assessment: network capture: mission-grade intercept — distillation integration, streaming events, salvage flush, capture budgets

- **Slug**: network-capture-intercept
- **Created**: 2026-08-22T21:09:19
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/240
- **Verdict**: likely valid, needs reproduction
- **Severity**: unknown

## Report (verbatim or summarized)

## Context

The flagship cold-path capability: while the agent (or user) browses an unknown retailer, capture the site's own XHR/fetch traffic and turn it into structured API intelligence. The capture engine already exists (pure-Dart JS injector, all platforms, headless-capable); this issue hardens it into a **mission-grade interception product** with distillation baked in.

## Requirements

1. **Distillation integration**: capture pipeline (NetworkCaptureManager → NetworkCaptureController) gains a pluggable post-processor slot wired to the SightingDistiller (arrrrny/dart_web_scraper#79) — `getEntries()` stays raw, new `getSightings()` returns distilled output.
2. **Streaming capture events**: live event stream (not just bulk collect) so `intercept_browse` can return early on high-confidence product-API hit (configurable `stopOn: {classification, minRank}`) instead of always waiting for idle.
3. **Salvage flush**: cancellation/timeout path emits all buffered-but-unreported events before dispose (pairs with zuraffa salvage protocol, arrrrny/zuraffa#388).
4. **Per-domain capture budgets**: max entries, max bytes, max body size per mission (in addition to distiller caps) enforced at capture level.
5. **Secret redaction at source**: auth-shaped headers/cookies/params flagged and redacted in the event stream before any consumer sees them (defense in depth with distiller).
6. SSO/auth-flow detection: sequences matching login patterns are marked `auth` and bodies dropped entirely.
7

## Symptom

[NEEDS CLARIFICATION]

## Reproduction

[NEEDS CLARIFICATION]

## Suspected Code Paths

[NEEDS CLARIFICATION — run /skill:speckit-bug-assess to locate the code, or fill in manually.]

## Root Cause Hypothesis

[NEEDS CLARIFICATION — not yet analyzed.]

## Proposed Remediation

[NEEDS CLARIFICATION — run /skill:speckit-bug-assess to propose a fix, or apply a fix directly with /skill:speckit-bug-fix.]

## Risks & Considerations

- Loaded from an existing GitHub issue; triage is incomplete until refined.

## Open Questions

- [NEEDS CLARIFICATION: …]
