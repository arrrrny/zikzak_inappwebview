# Bug Assessment: REWRITE: module wiring — DDA stores, generated ZuraffaUseCases (browse/intercept/search/...), mission semantics

- **Slug**: rewrite-module-wiring
- **Created**: 2026-08-22T21:09:19
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/243
- **Verdict**: likely valid, needs reproduction
- **Severity**: unknown

## Report (verbatim or summarized)

## Context

Zuraffa-native wiring of the module (umbrella: #241, extraction: #242): state becomes DDA stores, operations become `ZuraffaUseCase`s with v6 `SignalResult`, and everything registers through the package registrar so a consuming app gets sessions, budgets, and lifecycle for free.

## Requirements

1. **DDA datasources**: session store (mission-scoped webview sessions + cookies), cookie store (`CookieManager` facade), artifact store (HTML/screenshots/PDF → mission store via artifactRef pattern, arrrrny/zuraffa#387), cassette store (VCR files).
2. **ZuraffaUseCases** (each `zfa make`-generated, risk-annotated per zorphy#114):
   - `browse(session, url)` · `interceptBrowse(session, url, filters, stopOn)` (returns Sightings via the distiller slot) · `search(session, engine, query)` (multi-engine degrade order) · `executeJs(session, code)` · `cookies.get/set` · `dialogueDismiss` · `screenshot` · `pdf` · `recipeRecord` · `recipeReplay` (`confirm` risk — credential flows)
3. **Mission semantics integration**: cancellation/salvage protocol (arrrrny/zuraffa#388) honored by every usecase (flush captures, release pool sessions); budgets map to `MissionBudgetHook` webview-seconds accounting.
4. Streaming: usecase events (page state, capture progress, sightings found) surface as kernel events → mission UI.
5. Module-level DI registrar + engine module (zuraffa#389): import → services available, no manual wiring.

## Acceptance criteria

- [ ] All usecases generated (not hand-wri

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
