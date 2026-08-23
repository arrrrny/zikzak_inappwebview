# Bug Assessment: WebViewPool: mission-scoped sessions, domain affinity, memory-pressure disposal

- **Slug**: webview-pool-sessions
- **Created**: 2026-08-22T21:09:19
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/237
- **Verdict**: likely valid, needs reproduction
- **Severity**: unknown

## Report (verbatim or summarized)

## Context

ZikZak AI's `webview.*` MCP tools drive `HeadlessInAppWebView` instances from an agent loop. WebViews are heavyweight (10–50 MB each; iOS tolerates only a handful live), agent tool sequences are naturally **stateful** (browse → intercept → execute_js → cookies), and parallel missions will otherwise leak webviews. The pool is the load-bearing foundation every webview tool builds on — and it must be shared with `dart_web_scraper`'s `webViewClient` fetch path (see dart_web_scraper issue "unify WebView HTTP client with external WebViewPool session handles") so a single mission never double-renders a page.

## Requirements

1. `WebViewPool` singleton: acquires/releases `HeadlessInAppWebView` instances keyed by **session handle** (`sessionId` string issued per mission), not by URL.
2. **Domain affinity**: reusing a warm instance for the same eTLD+1 preserves cookies/JS state — preferred when available.
3. Per-pool caps: max live instances (platform-aware defaults), max per domain, idle TTL eviction, memory-pressure hook (Flutter `AppLifecycleListener`) disposing idle instances first.
4. Session API: `acquire(sessionId, domainHint)`, `release(sessionId)`, `disposeAll()`, plus introspection (`liveCount`, `sessions()`).
5. Thread-safety: concurrent tool calls from the agent loop acquiring simultaneously must not race-create instances.
6. Capture config composition: pool-issued instances must accept caller-provided `InAppWebViewSettings` (network capture filters, dialogue d

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
