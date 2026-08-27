# Bug Assessment: [P1] Standardize dispose patterns across wrapper classes + HeadlessInAppWebView double-dispose guard

- **Slug**: standardize-dispose-patterns
- **Created**: 2026-08-22T21:09:19
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/227
- **Verdict**: likely valid, needs reproduction
- **Severity**: unknown

## Report (verbatim or summarized)

Sub-issue of #161 (Epic: Architecture & tech debt reduction) — P1: catches real-world leaks.

## Current state
- A `Disposable` interface exists at the platform level, implemented by `PlatformInAppWebViewController`, `PlatformWebViewEnvironment`, `PlatformCookieManager`.
- The wrapper classes (`InAppWebViewController`, `InAppWebView`) do NOT implement it.
- `InAppLocalhostServer` has no dispose at all.
- `HeadlessInAppWebView` lacks double-dispose protection: calling `dispose()` before `run()` completes can leak (`_running` is false so `dispose()` returns early).

## Tasks
- [ ] Make all wrapper classes implement `Disposable`
- [ ] Add `dispose()` to `InAppLocalhostServer`
- [ ] `HeadlessInAppWebView`: proper double-dispose protection (dispose before/after run, idempotent)
- [ ] Standardize `dispose({bool isKeepAlive = false})` across all implementations
- [ ] Tests: double-dispose is safe; dispose-before-run leaks nothing; keepAlive behavior consistent

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
