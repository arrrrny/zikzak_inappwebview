# Bug Issue: REWRITE: extract value-add into module — pool, capture, VCR, dismisser, recipes, tracker as ports & services

- **Slug**: rewrite-extract-module
- **Fetched**: 2026-08-22T21:09:19
- **Issue**: 242
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/242
- **State**: open
- **Severity**: unknown
- **Author**: arrrrny
- **Labels**: zikzak-ai

## Body

## Context

Extraction pass of the Wave Z module (umbrella: #241): move the intelligence into `zikzak_inappwebview_module` behind clean ports, leaving the plugin a thin core. Feature specs from the in-flight issues carry over; this issue defines where they live and how they're structured as module services.

## Requirements

1. **Ports & adapters** (module-defined interfaces, plugin-adapter implementations):
   - `WebViewSessionFactory` + **WebViewPool** (from #237) — session handles, domain affinity, memory-pressure disposal; adapter over `HeadlessInAppWebView`
   - `CaptureSource` — live capture events + bulk entries; **mission-grade intercept semantics** (from #240: streaming events, stopOn early-return, salvage flush, capture budgets, at-source redaction) implemented in the module on top of raw plugin events
   - `CassetteEngine` (from #238) — VCR record/replay as a transport-level wrapper over the session factory (replay mode never touches network)
   - `DialogueDismissPort` (dismissive presets), `RecipePort` (record/replay), `NavigationTrackerPort` (URL cycle events)
2. Each value-add becomes a module service or DDA datasource (structure per zuraffa#389); plugin adapters are the only code importing plugin internals.
3. **Distillation wiring**: module's capture pipeline exposes the distiller post-processor slot consuming the `Sighting` contract (arrrrny/dart_web_scraper#79) — module depends on the distiller interface, not the scraper package (inverted: scraper provides implementation).
4. Secrets/auth-flow redaction at source (from #240) lives in the module's capture service — one place, defense in depth with the distiller.
5. Behavior parity: existing plugin example/tests for moved features re-point at module equivalents and stay green.

## Acceptance criteria

- [ ] All listed features extracted; zero intelligence code in plugin core (umbrella grep gate)
- [ ] #237, #238, #240 acceptance criteria pass in module context (then close as landed-here)
- [ ] Distiller slot contract test with a stub implementation (real one from dart_web_scraper#79 wired later)
- [ ] Pool/VCR parity: pool no-leak run + VCR determinism run, unchanged from the original specs

## Dependencies

- arrrrny/zikzak_inappwebview#241 (umbrella — split map first)
- arrrrny/zuraffa#389 (package mode)

---
Wave Z of the ZikZak AI program — MAESTRO: arrrrny/zik_zak#176.


## Comments

**coderabbitai** (2026-08-18T10:46:14Z):

<!-- This is an auto-generated issue plan by CodeRabbit -->
<details>
<summary>🔗 Related PRs</summary>

arrrrny/zikzak_inappwebview#171 - feat: add Network Capture API — capture XHR/fetch requests and response bodies [merged]
arrrrny/zikzak_inappwebview#176 - refactor: split InAppWebViewController into domain-specific controllers [merged]
arrrrny/zikzak_inappwebview#187 - fix(macos): popup window crash, settings key, and event delivery [merged]
arrrrny/zikzak_inappwebview#216 - feat: session recipe, navigation tracking, dialogue dismissal, and navigation guards [merged]
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

**arrrrny** (2026-08-18T10:46:30Z):

MAESTRO: https://github.com/arrrrny/zik_zak/issues/176

Unblocks: arrrrny/zikzak_inappwebview#243, #244. Carries #237, #238, #240 acceptance into module context.

