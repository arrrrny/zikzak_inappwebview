# Bug Issue: [P2] Lifecycle integration tests — hot restart, activity recreation, FlutterFragment, WebView2 Program Files

- **Slug**: lifecycle-integration-tests
- **Fetched**: 2026-08-22T21:09:19
- **Issue**: 228
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/228
- **State**: open
- **Severity**: unknown
- **Author**: arrrrny
- **Labels**: epic, tech-debt

## Body

Sub-issue of #161 (Epic: Architecture & tech debt reduction) — P2: catches regressions.

## Tasks
- [ ] Hot restart test: launch, navigate, hot restart, verify WebView still functional
- [ ] Activity recreation test: rotate device / foreground → background → foreground, verify no `MissingPluginException`
- [ ] `FlutterFragment` test: verify plugin registration completes without requiring an Activity
- [ ] Windows `Program Files` scenario: WebView2 handles read-only install directories gracefully

Note: platform-channel tests should use the current zorphy-based platform interface (post-#226 migration).

## Comments

**coderabbitai** (2026-08-16T12:20:13Z):

<!-- This is an auto-generated issue plan by CodeRabbit -->
<details>
<summary>🔗 Related PRs</summary>

arrrrny/zikzak_inappwebview#162 - fix: batch 1 critical fixes — lifecycle, security, platform stability [merged]
arrrrny/zikzak_inappwebview#184 - fix(linux): fix blue screen by rendering webview offscreen + add openDevTools [merged]
arrrrny/zikzak_inappwebview#187 - fix(macos): popup window crash, settings key, and event delivery [merged]
arrrrny/zikzak_inappwebview#202 - fix(macos): await shouldOverrideUrlLoading response so cancellations are honored (`#192`) [merged]
arrrrny/zikzak_inappwebview#225 - fix(ios): gate HeadlessInAppWebView.run() on web-process readiness [open]
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
