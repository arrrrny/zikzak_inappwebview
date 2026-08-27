# Bug Assessment: REWRITE (umbrella): thin platform core + zuraffa v6 webview module — split map & scaffold

- **Slug**: rewrite-umbrella-platform-core
- **Created**: 2026-08-22T21:09:19
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/241
- **Verdict**: likely valid, needs reproduction
- **Severity**: unknown

## Report (verbatim or summarized)

## Context — Wave Z umbrella

zikzak_inappwebview's value-add (network capture, WebViewPool, VCR, dialogue dismissers, recipes, navigation tracking, controllers) has outgrown a platform plugin's remit. The repo converts to a **two-tier shape**:

```
zikzak_inappwebview (platform plugin, THIN CORE — stays)
  └─ widget + controller + platform_interface + native packages
     (raw APIs only: webview lifecycle, JS eval, cookies, capture event plumbing)

zikzak_inappwebview_module (NEW, in-repo zuraffa v6 package — zuraffa#389 package mode)
  └─ the intelligence: pool, capture management + distillation wiring, VCR,
     dialogue dismisser, recipes, navigation tracker, session/cookie stores,
     ZuraffaUseCases (browse/search/intercept/...), generated agent tools
```

The plugin keeps doing what forks-of-plugins do (platform plumbing); everything with *policy, state, or intelligence* moves to the module where zuraffa generates the structure and the agent tools. In-flight feature issues re-home into the module: #237 (pool), #238 (VCR), #239 (tools), #240 (intercept) — their specs carry over unchanged, their landing zone changes.

## Requirements

1. **Split map** (first deliverable, in this issue): every current Dart-side value-add class → plugin core or module, with the interface between them (module consumes ONLY public plugin API — no platform_interface internals).
2. Module scaffolded via `zfa package create` (zuraffa#389): domain/data/module layout, DI registrar, engine module

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
