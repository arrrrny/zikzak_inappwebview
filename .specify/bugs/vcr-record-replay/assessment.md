# Bug Assessment: VCR: deterministic record/replay for HeadlessInAppWebView (CI-grade)

- **Slug**: vcr-record-replay
- **Created**: 2026-08-22T21:09:19
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/238
- **Verdict**: likely valid, needs reproduction
- **Severity**: unknown

## Report (verbatim or summarized)

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
- [ ] Replay determinism: same cassette, 10 runs,

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
