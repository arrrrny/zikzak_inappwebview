# Bug Issue: REWRITE: module wiring — DDA stores, generated ZuraffaUseCases (browse/intercept/search/...), mission semantics

- **Slug**: rewrite-module-wiring
- **Fetched**: 2026-08-22T21:09:19
- **Issue**: 243
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/243
- **State**: open
- **Severity**: unknown
- **Author**: arrrrny
- **Labels**: zikzak-ai

## Body

## Context

Zuraffa-native wiring of the module (umbrella: #241, extraction: #242): state becomes DDA stores, operations become `ZuraffaUseCase`s with v6 `SignalResult`, and everything registers through the package registrar so a consuming app gets sessions, budgets, and lifecycle for free.

## Requirements

1. **DDA datasources**: session store (mission-scoped webview sessions + cookies), cookie store (`CookieManager` facade), artifact store (HTML/screenshots/PDF → mission store via artifactRef pattern, arrrrny/zuraffa#387), cassette store (VCR files).
2. **ZuraffaUseCases** (each `zfa make`-generated, risk-annotated per zorphy#114):
   - `browse(session, url)` · `interceptBrowse(session, url, filters, stopOn)` (returns Sightings via the distiller slot) · `search(session, engine, query)` (multi-engine degrade order) · `executeJs(session, code)` · `cookies.get/set` · `dialogueDismiss` · `screenshot` · `pdf` · `recipeRecord` · `recipeReplay` (`confirm` risk — credential flows)
3. **Mission semantics integration**: cancellation/salvage protocol (arrrrny/zuraffa#388) honored by every usecase (flush captures, release pool sessions); budgets map to `MissionBudgetHook` webview-seconds accounting.
4. Streaming: usecase events (page state, capture progress, sightings found) surface as kernel events → mission UI.
5. Module-level DI registrar + engine module (zuraffa#389): import → services available, no manual wiring.

## Acceptance criteria

- [ ] All usecases generated (not hand-written) with correct risk tiers; `SignalResult` streaming verified per usecase
- [ ] Cancellation mid-`interceptBrowse`: salvage flush + pool release + partial sightings (no leak assertion)
- [ ] Registrar test: consuming app resolves every usecase/store with zero manual registration
- [ ] Session continuity: browse→intercept→executeJs share one pooled instance (assertion)

## Dependencies

- arrrrny/zikzak_inappwebview#242 (ports exist), arrrrny/zuraffa#389 (package mode), #388 (salvage protocol), #385 (usecase codegen), arrrrny/zorphy#114 (annotations)

---
Wave Z of the ZikZak AI program — MAESTRO: arrrrny/zik_zak#176.


## Comments

**coderabbitai** (2026-08-18T10:46:28Z):

<!-- This is an auto-generated issue plan by CodeRabbit -->
<details>
<summary>🔗 Related PRs</summary>

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

**arrrrny** (2026-08-18T10:46:31Z):

MAESTRO: https://github.com/arrrrny/zik_zak/issues/176

Unblocks: arrrrny/zikzak_inappwebview#244. Generates the usecases the agent tools derive from.

