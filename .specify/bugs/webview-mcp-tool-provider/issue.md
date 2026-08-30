# Bug Issue: agent: WebviewMcpToolProvider — webview.* tool suite (browse, intercept_browse, search, cookies, recipes)

- **Slug**: webview-mcp-tool-provider
- **Fetched**: 2026-08-22T21:09:19
- **Issue**: 239
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/239
- **State**: open
- **Severity**: unknown
- **Author**: arrrrny
- **Labels**: zikzak-ai

## Body

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
3. Every tool result carries `sessionId` continuation so agent sequences stay on one webview instance; tools that must not (fresh identity) accept `newSession: true`.
4. Capture settings (filters, caps, binary capture) exposed as tool args, defaults sane for mobile.
5. Cancellation-aware: tools honor `CancelToken` with the salvage protocol (flush captured events before dispose — arrrrny/zuraffa#388).
6. VCR-compatible end-to-end (record/replay under arrrrny/zikzak_inappwebview#238).

## Acceptance criteria

- [ ] Provider registers with zuraffa kernel; all tools list/call in-proc
- [ ] `intercept_browse` on 3 real retailer pages returns bounded, secret-free Sighting sets (distiller fixtures pass through this path)
- [ ] Multi-engine `search` degrades correctly when an engine blocks (VCR cassettes per engine)
- [ ] Session continuity test: browse → intercept → execute_js on one pooled instance; pool asserts single live webview
- [ ] Mission cancel mid-`intercept_browse`: partial sightings emitted, webview released to pool, no leak

## Dependencies

- arrrrny/zikzak_inappwebview#237 (WebViewPool — sessions)
- arrrrny/zuraffa#386 (McpToolProvider SPI)
- arrrrny/dart_web_scraper#79 (SightingDistiller — for intercept_browse)
- arrrrny/zikzak_inappwebview#238 (VCR — for CI)

---
Part of the ZikZak AI agent architecture — `docs/architecture/zikzak-ai-agent-architecture.md` in arrrrny/zik_zak (§4.1, §4.2).


## Comments

**arrrrny** (2026-08-18T10:31:14Z):

MAESTRO: https://github.com/arrrrny/zik_zak/issues/176

Unblocks: arrrrny/zik_zak#174, arrrrny/dws_playground#7


**arrrrny** (2026-08-18T10:46:41Z):

MAESTRO: https://github.com/arrrrny/zik_zak/issues/176

Wave Z re-home: webview.* tools become GENERATED from module usecases (arrrrny/zikzak_inappwebview#244); #239 reduces to SPI registration. MAESTRO: arrrrny/zik_zak#176

