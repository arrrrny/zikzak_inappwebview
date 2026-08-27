# Bug Issue: [P3] Split InAppWebViewController into domain-specific controllers (Navigation, JavaScript, Cookie, Settings)

- **Slug**: split-controller-domains
- **Fetched**: 2026-08-22T21:09:19
- **Issue**: 229
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/229
- **State**: open
- **Severity**: unknown
- **Author**: arrrrny
- **Labels**: enhancement, epic, tech-debt

## Body

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

## Comments

**coderabbitai** (2026-08-16T12:20:15Z):

<!-- This is an auto-generated issue plan by CodeRabbit -->
<details>
<summary>🔗 Related PRs</summary>

arrrrny/zikzak_inappwebview#162 - fix: batch 1 critical fixes — lifecycle, security, platform stability [merged]
arrrrny/zikzak_inappwebview#176 - refactor: split InAppWebViewController into domain-specific controllers [merged]
</details>

---
<details>
<summary>📝 Issue Planner</summary>

<sub>Check the box below or use the `@coderabbitai plan` command to generate an implementation plan and prompts that you can use with your favorite coding assistant.</sub>

- [ ] <!-- {"checkboxId": "8d4f2b9c-3e1a-4f7c-a9b2-d5e8f1c4a7b9"} --> Create Plan
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
