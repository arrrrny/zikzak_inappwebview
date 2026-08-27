# Bug Assessment: [P3] Split InAppWebViewController into domain-specific controllers (Navigation, JavaScript, Cookie, Settings)

- **Slug**: split-controller-domains
- **Created**: 2026-08-22T21:09:19
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/229
- **Verdict**: likely valid, needs reproduction
- **Severity**: unknown

## Report (verbatim or summarized)

Sub-issue of #161 (Epic: Architecture & tech debt reduction) — P3: maintainability + enables parallel work.

## Current state
`InAppWebViewController` platform interface is ~530 lines (Android/iOS implementations ~2600 lines each). Growing — a single class becomes harder to reason about as features are added.

## Suggested breakdown
- `NavigationController` — `loadUrl`, `reload`, `goBack`, `goForward`, `canGoBack`, `canGoForward`
- `JavaScriptController` — `evaluateJavascript`, `addJavaScriptHandler`, `callJavaScriptHandler`
- `CookieController` — cookie management methods
- `SettingsController` — `getSettings`, `setSettings`

## Tasks
- [ ] Define the controller interfaces (split the existing method groups)
- [ ] Keep backward compatibility (the monolithic `InAppWebViewController` delegates to the controllers)
- [ ] Move implementations (Android/iOS) to match
- [ ] Update generated code / DI wiring if the zorphy migration touched these
- [ ] Tests: existing behavior preserved after the split

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
