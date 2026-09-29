# Bug Issue: [macOS] InAppWebViewSettings.contentBlockers is decoded but never applied — no WKContentRuleList compilation (iOS parity gap)

- **Slug**: 338-macos-contentblockers-never-applied
- **Fetched**: 2026-09-27T00:00:00Z
- **Issue**: 338
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/338
- **State**: open
- **Severity**: major
- **Author**: (see GitHub issue)
- **Labels**: none
- **Package**: `zikzak_inappwebview_macos` 6.0.2 (also at master `9e710171`)

## Body

### Description

`InAppWebViewSettings.contentBlockers` is declared and decoded on macOS but
**never consumed**: nothing in the macOS Swift sources compiles or adds a
`WKContentRuleList`.

- Declared:
  `zikzak_inappwebview_macos/macos/.../InAppWebViewSettings.swift:17` —
  `var contentBlockers: [[String: [String: Any]]] = []`
- Consumed: nowhere —
  `grep -rn "contentBlockers|compileContentRuleList|WKContentRuleList" macos/...`
  finds no other reference.
- On iOS the same setting works:
  `zikzak_inappwebview_ios/.../InAppWebView.swift` (updateSettings) calls
  `WKContentRuleListStore.default().compileContentRuleList(...)` and adds the
  compiled list to `configuration.userContentController`.

### Steps to Reproduce

```dart
InAppWebViewSettings(contentBlockers: [
  {
    "trigger": {"url-filter": ".*\\.doubleclick\\.net.*", "load-type": ["third-party"]},
    "action": {"type": "block"},
  },
])
```

Load a page that requests a blocked URL on macOS: the request fires. Same code
on iOS: the request is blocked by WebKit before it starts.

### Expected Behavior

macOS should compile and add the rule list like iOS does
(`WKContentRuleListStore.default()` +
`configuration.userContentController.add(...)`, mirroring the iOS
`updateSettings` branch).

### Impact

`package:zuraffa_browser` ships a Settings-level ad/tracker shield built on
`InAppWebViewSettings(contentBlockers:)` (issue arrrrny/zuraffa_browser#217).
The feature is real on iOS and silently inert on macOS — the flagship platform
— until this parity gap closes. Related parity report: #197.
