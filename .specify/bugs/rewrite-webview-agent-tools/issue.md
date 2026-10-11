# Bug Issue: REWRITE: generated webview.* agent tools + cassette parity CI gate (supersedes hand-built provider)

- **Slug**: rewrite-webview-agent-tools
- **Fetched**: 2026-08-22T21:09:19
- **Issue**: 244
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/244
- **State**: open
- **Severity**: unknown
- **Author**: arrrrny
- **Labels**: zikzak-ai

## Body

## Context

Agent surface + parity gate of the module (umbrella: #241): the `webview.*` tool suite becomes **generated** from the usecases (#243) via package-mode AgentPlugin — #239's hand-built provider is superseded by SPI registration of generated tools. The cassette harness becomes the module's regression gate.

## Requirements

1. **Generated tools**: `zfa make --agent` in package mode emits `webview.*` tools from the #243 usecases (names match the architecture doc §4.1 surface); #239's `WebviewMcpToolProvider` reduces to registering the generated set into the kernel registry (arrrrny/zuraffa#386).
2. Tool schemas: session ids as opaque strings with continuation semantics documented in tool descriptions; capture filters/stopOn as typed args; oversized results → summary + artifactRef.
3. **Cassette parity harness as CI gate**: golden cassette set (≥ 3 retailers × {browse, intercept, search per engine, dialogue dismiss, recipe replay}) — recorded once via VCR (#238), replayed on every change; plus the multi-engine degrade set (each engine's block cassette).
4. dws_playground golden missions GM-2/GM-4/GM-5 re-point at module tools; green in CI = parity sign-off for the umbrella.
5. Consumer migration note: zik_zak K2 (arrrrny/zik_zak#174) imports module registrar; plugin-only import documented for non-zuraffa users (thin core still usable standalone).

## Acceptance criteria

- [ ] Tool list equals the §4.1 surface, all generated; zero hand-written tool classes in the module
- [ ] Cassette suite green in CI (macOS + Android emulator); determinism run (10× identical)
- [ ] dws_playground GM-2/4/5 green against module tools
- [ ] #239 closes as superseded-by-generated (mapping noted); #241 umbrella closes on this sign-off

## Dependencies

- arrrrny/zikzak_inappwebview#243 (usecases), arrrrny/zuraffa#385 + #389 (package-mode codegen), #386 (registry), #238 (VCR — re-homed by #242)
- Supersedes: arrrrny/zikzak_inappwebview#239 (SPI bridge → thin registration)

---
Wave Z of the ZikZak AI program — MAESTRO: arrrrny/zik_zak#176.


## Comments

**coderabbitai** (2026-08-18T10:46:23Z):

<!-- This is an auto-generated issue plan by CodeRabbit -->

<details>
<summary>⚠️ Possible Duplicate Issue(s)</summary>

- https://github.com/arrrrny/zikzak_inappwebview/issues/239
</details>
<details>
<summary>🔗 Related PRs</summary>

arrrrny/zikzak_inappwebview#187 - fix(macos): popup window crash, settings key, and event delivery [merged]
arrrrny/zikzak_inappwebview#211 - fix(android): bump toolchain — androidx.webkit 1.15.0, AGP 8.13.1, JVM target 17 (closes `#201`) [merged]
</details>

---
<details>
<summary>📝 Issue Planner</summary>

<sub>Check the box below or use the `@coderabbitai plan` command to generate an implementation plan and prompts that you can use with your favorite coding assistant.</sub>

- [ ] <!-- {"checkboxId":"8d4f2b9c-3e1a-4f7c-a9b2-d5e8f1c4a7b9"} --> Create Plan
</details>


---
<details>
<summary> 🧪 Issue enrichment is currently in open beta.</summary>


You can configure auto-planning by selecting labels in the issue_enrichment configuration.

To disable automatic issue enrichment, add the following to your `.coderabbit.yaml`:
```yaml
issue_enrichment:
  auto_enrich:
    enabled: false
```
</details>

💬 Have feedback or questions? Drop into our [discord](https://discord.gg/coderabbit)!

**arrrrny** (2026-08-18T10:46:33Z):

MAESTRO: https://github.com/arrrrny/zik_zak/issues/176

Terminal for Wave Z webview side — supersedes arrrrny/zikzak_inappwebview#239; gates dws_playground GM-2/GM-4/GM-5; closes umbrella #241.

