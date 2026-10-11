# Bug Assessment: [P2] Lifecycle integration tests — hot restart, activity recreation, FlutterFragment, WebView2 Program Files

- **Slug**: lifecycle-integration-tests
- **Created**: 2026-08-22T21:09:19
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/228
- **Verdict**: likely valid, needs reproduction
- **Severity**: unknown

## Report (verbatim or summarized)

Sub-issue of #161 (Epic: Architecture & tech debt reduction) — P2: catches regressions.

## Tasks
- [ ] Hot restart test: launch, navigate, hot restart, verify WebView still functional
- [ ] Activity recreation test: rotate device / foreground → background → foreground, verify no `MissingPluginException`
- [ ] `FlutterFragment` test: verify plugin registration completes without requiring an Activity
- [ ] Windows `Program Files` scenario: WebView2 handles read-only install directories gracefully

Note: platform-channel tests should use the current zorphy-based platform interface (post-#226 migration).

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
