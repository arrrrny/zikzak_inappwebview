# Bug Assessment: REWRITE: extract value-add into module — pool, capture, VCR, dismisser, recipes, tracker as ports & services

- **Slug**: rewrite-extract-module
- **Created**: 2026-08-22T21:09:19
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/242
- **Verdict**: likely valid, needs reproduction
- **Severity**: unknown

## Report (verbatim or summarized)

## Context

Extraction pass of the Wave Z module (umbrella: #241): move the intelligence into `zikzak_inappwebview_module` behind clean ports, leaving the plugin a thin core. Feature specs from the in-flight issues carry over; this issue defines where they live and how they're structured as module services.

## Requirements

1. **Ports & adapters** (module-defined interfaces, plugin-adapter implementations):
   - `WebViewSessionFactory` + **WebViewPool** (from #237) — session handles, domain affinity, memory-pressure disposal; adapter over `HeadlessInAppWebView`
   - `CaptureSource` — live capture events + bulk entries; **mission-grade intercept semantics** (from #240: streaming events, stopOn early-return, salvage flush, capture budgets, at-source redaction) implemented in the module on top of raw plugin events
   - `CassetteEngine` (from #238) — VCR record/replay as a transport-level wrapper over the session factory (replay mode never touches network)
   - `DialogueDismissPort` (dismissive presets), `RecipePort` (record/replay), `NavigationTrackerPort` (URL cycle events)
2. Each value-add becomes a module service or DDA datasource (structure per zuraffa#389); plugin adapters are the only code importing plugin internals.
3. **Distillation wiring**: module's capture pipeline exposes the distiller post-processor slot consuming the `Sighting` contract (arrrrny/dart_web_scraper#79) — module depends on the distiller interface, not the scraper package (inverted: scraper provides i

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
