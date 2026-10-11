# Bug Issue: [iOS] contentBlockers silently blocks the initial navigation (blank page, no logs)

- **Slug**: 349-ios-contentblockers-silently-blocks-the-initial-navigation-blank-page-no-logs
- **Fetched**: 2026-10-04T00:00:00Z
- **Issue**: 349
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/349
- **State**: open
- **Severity**: major
- **Author**: (see GitHub issue)
- **Package**: `zikzak_inappwebview_ios` 6.0.2 and 6.1.0 (identical on both)

## Body

`InAppWebViewSettings.contentBlockers` on iOS prevents the **first**
navigation from committing at all. The page never loads, and nothing is
logged — no error, no `onLoadError`, no network activity. With
`contentBlockers: null` the same tab commits normally.

### Repro shape

A tab whose `initialUrlRequest` is a normal https URL plus a non-null
`contentBlockers`; nulling `contentBlockers` alone is sufficient to make the
navigation commit.

### Observed

| `contentBlockers` | Address bar after load | Logs |
|---|---|---|
| non-null | `https://` (scheme only) | `onWebViewCreated` fires; **no** `onLoadStart`, no `onLoadStop`, no `onLoadError`, no WebContent network activity |
| `null` | `https://example.com/` (full, committed) | normal |

Platform: iOS 26.3 simulator, iPhone 17 Pro, Flutter 3.47.5,
`zikzak_inappwebview_ios` 6.0.2 and 6.1.0.

### Root cause (this repo, code reading)

`FlutterWebViewController.makeInitialLoad` (and the copy-pasted block in
`InAppBrowserWebViewController.viewDidLoad`) issues the initial navigation
ONLY from inside the `WKContentRuleListStore.compileContentRuleList`
completion:

1. a compilation error prints and `return`s — the initial navigation is never
   issued (silent blank page);
2. a `(nil, nil)` completion crashes on `contentRuleList!`;
3. the fixed persistent-store identifier `"ContentBlockingRules"` is
   recompiled across app launches and webviews, and WebKit can fail to
   deliver that recompilation's completion — silently orphaning the held
   initial load forever.

The macOS port fixed this exact defect class in #338
(`applyContentBlockers` funnel + `loadAfterContentRuleLists` settle gate +
compile token); iOS had not adopted it.

### Constraints honored

- Fix only what the issue describes (initial-navigation drop + the issue's
  URLRequest about:blank-fallback diagnostic); one PR for the issue.
- The separate "viewport still paints white with contentBlockers: null"
  observation from the issue is explicitly on-record only — NOT touched.
