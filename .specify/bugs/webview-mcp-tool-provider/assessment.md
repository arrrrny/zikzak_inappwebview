# Bug Assessment: agent: WebviewMcpToolProvider — webview.* tool suite (browse, intercept_browse, search, cookies, recipes)

- **Slug**: webview-mcp-tool-provider
- **Created**: 2026-08-22T21:09:19
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/239
- **Verdict**: likely valid, needs reproduction
- **Severity**: unknown

## Report (verbatim or summarized)

## Context

zikzak_inappwebview's capabilities (headless browsing, network capture, cookies, dialogue dismissal, recipes) become the agent's eyes and hands on unknown websites. This issue delivers them as MCP tools through zuraffa's `McpToolProvider` SPI — the **browser tool suite** of the device agent.

## Requirements

1. New library target exposing `WebviewMcpToolProvider implements McpToolProvider` (interface from arrrrny/zuraffa#386), namespace `webview`.
2. Tool surface (all mission-scoped via pool session handles from arrrrny/zikzak_inappwebview#237):
   - `webview.browse(session, url)` — headless load, wait idle, return title/url/artifactRef(html)
   - `webview.intercept_browse(session, url, filters?)` — browse + capture; return distilled **Sightings** (distiller from arrrrny/dart_web_scraper#79) not raw events; caps enforced by distiller
   - `webview.search(session, engine, query)` — multi-engine: retailer on-site search (preferred), DDG/Bing HTML, Google last — extracts result links; engine failures degrade in order
   - `webview.execute_js(session, code)` — eval with result size discipline (summary+ref beyond threshold)
   - `webview.cookies.get/set`, `webview.dialogue_dismiss(session)`, `webview.screenshot(session)`, `webview.pdf(session)`
   - `webview.recipe.record/replay` — record user flow; replay headlessly (credentials never enter traces; consent flag required)
3. Every tool result carries `sessionId` continuation so agent sequences stay on one webview inst

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
