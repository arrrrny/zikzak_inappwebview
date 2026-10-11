# Bug Assessment: REWRITE: generated webview.* agent tools + cassette parity CI gate (supersedes hand-built provider)

- **Slug**: rewrite-webview-agent-tools
- **Created**: 2026-08-22T21:09:19
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/244
- **Verdict**: likely valid, needs reproduction
- **Severity**: unknown

## Report (verbatim or summarized)

## Context

Agent surface + parity gate of the module (umbrella: #241): the `webview.*` tool suite becomes **generated** from the usecases (#243) via package-mode AgentPlugin — #239's hand-built provider is superseded by SPI registration of generated tools. The cassette harness becomes the module's regression gate.

## Requirements

1. **Generated tools**: `zfa make --agent` in package mode emits `webview.*` tools from the #243 usecases (names match the architecture doc §4.1 surface); #239's `WebviewMcpToolProvider` reduces to registering the generated set into the kernel registry (arrrrny/zuraffa#386).
2. Tool schemas: session ids as opaque strings with continuation semantics documented in tool descriptions; capture filters/stopOn as typed args; oversized results → summary + artifactRef.
3. **Cassette parity harness as CI gate**: golden cassette set (≥ 3 retailers × {browse, intercept, search per engine, dialogue dismiss, recipe replay}) — recorded once via VCR (#238), replayed on every change; plus the multi-engine degrade set (each engine's block cassette).
4. dws_playground golden missions GM-2/GM-4/GM-5 re-point at module tools; green in CI = parity sign-off for the umbrella.
5. Consumer migration note: zik_zak K2 (arrrrny/zik_zak#174) imports module registrar; plugin-only import documented for non-zuraffa users (thin core still usable standalone).

## Acceptance criteria

- [ ] Tool list equals the §4.1 surface, all generated; zero hand-written tool classes in the modul

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
