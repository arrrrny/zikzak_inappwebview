# Bug Issue: WebViewPool: mission-scoped sessions, domain affinity, memory-pressure disposal

- **Slug**: webview-pool-sessions
- **Fetched**: 2026-08-22T21:09:19
- **Issue**: 237
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/237
- **State**: open
- **Severity**: unknown
- **Author**: arrrrny
- **Labels**: zikzak-ai

## Body

## Context

ZikZak AI's `webview.*` MCP tools drive `HeadlessInAppWebView` instances from an agent loop. WebViews are heavyweight (10–50 MB each; iOS tolerates only a handful live), agent tool sequences are naturally **stateful** (browse → intercept → execute_js → cookies), and parallel missions will otherwise leak webviews. The pool is the load-bearing foundation every webview tool builds on — and it must be shared with `dart_web_scraper`'s `webViewClient` fetch path (see dart_web_scraper issue "unify WebView HTTP client with external WebViewPool session handles") so a single mission never double-renders a page.

## Requirements

1. `WebViewPool` singleton: acquires/releases `HeadlessInAppWebView` instances keyed by **session handle** (`sessionId` string issued per mission), not by URL.
2. **Domain affinity**: reusing a warm instance for the same eTLD+1 preserves cookies/JS state — preferred when available.
3. Per-pool caps: max live instances (platform-aware defaults), max per domain, idle TTL eviction, memory-pressure hook (Flutter `AppLifecycleListener`) disposing idle instances first.
4. Session API: `acquire(sessionId, domainHint)`, `release(sessionId)`, `disposeAll()`, plus introspection (`liveCount`, `sessions()`).
5. Thread-safety: concurrent tool calls from the agent loop acquiring simultaneously must not race-create instances.
6. Capture config composition: pool-issued instances must accept caller-provided `InAppWebViewSettings` (network capture filters, dialogue dismissal) per acquisition.
7. Exposed as public API + docs page; no dependency on MCP/zuraffa types (pure plugin-level feature).

## Acceptance criteria

- [ ] Unit + integration tests: acquire/release cycles, domain affinity hits, eviction under cap, concurrent acquire race test
- [ ] Memory-pressure disposal verified on iOS + Android + macOS
- [ ] Zero leaked instances after a simulated 20-mission run (assert via pool introspection)
- [ ] Example app section demonstrating manual pool usage

## Dependencies

None — foundation. Unblocks webview.* tool provider, intercept_browse, and dart_web_scraper webview-client unification.

---
Part of the ZikZak AI agent architecture — `docs/architecture/zikzak-ai-agent-architecture.md` in arrrrny/zik_zak (§4.1, code-review gap #1/#2).


## Comments

**arrrrny** (2026-08-18T10:30:56Z):

MAESTRO: https://github.com/arrrrny/zik_zak/issues/176

Unblocks: arrrrny/dart_web_scraper#81 (webview client unification), arrrrny/zikzak_inappwebview#239, arrrrny/zikzak_inappwebview#240, arrrrny/dws_playground#7


**arrrrny** (2026-08-18T10:46:38Z):

MAESTRO: https://github.com/arrrrny/zik_zak/issues/176

Wave Z re-home: WebViewPool lands inside the zuraffa webview module (arrrrny/zikzak_inappwebview#242) — spec unchanged, landing zone is the module. MAESTRO: arrrrny/zik_zak#176

