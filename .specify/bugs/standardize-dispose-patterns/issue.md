# Bug Issue: [P1] Standardize dispose patterns across wrapper classes + HeadlessInAppWebView double-dispose guard

- **Slug**: standardize-dispose-patterns
- **Fetched**: 2026-08-22T21:09:19
- **Issue**: 227
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/227
- **State**: open
- **Severity**: unknown
- **Author**: arrrrny
- **Labels**: epic, tech-debt

## Body

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

## Comments

**coderabbitai** (2026-08-16T12:19:39Z):

<!-- This is an auto-generated issue plan by CodeRabbit -->
<details>
<summary>🔗 Related PRs</summary>

arrrrny/zikzak_inappwebview#162 - fix: batch 1 critical fixes — lifecycle, security, platform stability [merged]
arrrrny/zikzak_inappwebview#175 - fix: standardize dispose patterns across all wrapper classes [merged]
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
