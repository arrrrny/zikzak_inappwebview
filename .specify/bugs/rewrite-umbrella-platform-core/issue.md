# Bug Issue: REWRITE (umbrella): thin platform core + zuraffa v6 webview module — split map & scaffold

- **Slug**: rewrite-umbrella-platform-core
- **Fetched**: 2026-08-22T21:09:19
- **Issue**: 241
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/241
- **State**: open
- **Severity**: unknown
- **Author**: arrrrny
- **Labels**: enhancement, epic, tech-debt, zikzak-ai

## Body

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
2. Module scaffolded via `zfa package create` (zuraffa#389): domain/data/module layout, DI registrar, engine module registration.
3. **Plugin core API freeze**: raw capture events, controller facades, headless API stay stable; module versions independently.
4. Transition plan for consumers: zik_zak (K2 arrrrny/zik_zak#174 uses webview.* tools — re-point to module), dws_playground#7 missions target module.
5. Naming/location decision recorded (in-repo `zikzak_inappwebview_module/` default).

## Acceptance criteria

- [ ] Split map reviewed + merged into this issue; module package exists, `zfa build` + analyze clean
- [ ] Zero intelligence-layer code left in the plugin core (grep gate: pool/VCR/dismiss/recipe/tracker absent from plugin package)
- [ ] A "hello mission" (browse → getHtml) runs purely through module APIs on iOS + Android + macOS
- [ ] Decomposition issues below closed; #237–#240 land or re-point into the module

## Dependencies

- arrrrny/zuraffa#389 (package SDK — blocking)

## Decomposition

- value-add extraction with clean ports (next issue)
- zuraffa-native wiring: DDA stores + usecases (+1)
- agent surface + cassette parity (+2)

---
Wave Z of the ZikZak AI program — MAESTRO: arrrrny/zik_zak#176 · design doc: `docs/architecture/zikzak-ai-agent-architecture.md` in arrrrny/zik_zak (§4.1).


## Comments

**coderabbitai** (2026-08-18T10:45:55Z):

<!-- This is an auto-generated issue plan by CodeRabbit -->
<details>
<summary>🔗 Related PRs</summary>

arrrrny/zikzak_inappwebview#171 - feat: add Network Capture API — capture XHR/fetch requests and response bodies [merged]
arrrrny/zikzak_inappwebview#187 - fix(macos): popup window crash, settings key, and event delivery [merged]
arrrrny/zikzak_inappwebview#216 - feat: session recipe, navigation tracking, dialogue dismissal, and navigation guards [merged]
arrrrny/zikzak_inappwebview#225 - fix(ios): gate HeadlessInAppWebView.run() on web-process readiness [merged]
arrrrny/zikzak_inappwebview#234 - refactor(platform_interface+android+ios): complete InAppWebViewController domain delegate split (`#229`) [open]
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

**arrrrny** (2026-08-18T10:46:28Z):

MAESTRO: https://github.com/arrrrny/zik_zak/issues/176

Unblocks: arrrrny/zikzak_inappwebview#242, #243, #244. Re-homes #237, #238, #239, #240. Depends on arrrrny/zuraffa#389.

