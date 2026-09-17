# Bug Issue: iOS cancels private custom URL schemes before the host navigation delegate sees them

- **Slug**: ios-custom-scheme-navigation
- **Fetched**: 2026-09-15
- **Issue**: none filed — tracked by pull request #334
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/pull/334
- **State**: fixed on `fix/ios-custom-scheme-navigation` (PR #334, open)
- **Severity**: high — on iOS a host cannot handle any private-scheme deep link
- **Author**: reported through the example app's deep-link flow (recorded in PR #334)
- **Labels**: none

## Body

### Description

On iOS, `shouldOverrideUrlLoading` is never invoked for a private custom URL
scheme such as `weixin://`. The native `WKUIDelegate` cancelled the navigation
inside `InAppWebView.webView(_:decidePolicyFor:decisionHandler:)` before the
host callback could run, because every scheme outside
`URLValidationManager.defaultSafeSchemes` was treated as invalid.

### Steps to Reproduce

1. Create an `InAppWebView` with `useShouldOverrideUrlLoading: true` and a
   `shouldOverrideUrlLoading` callback that handles `weixin://`.
2. Load a page, then navigate to `weixin://wap/pay?token=test`.
3. The callback never fires and the navigation is silently cancelled.

### Expected Behavior

The host navigation delegate sees the custom scheme and decides: `ALLOW` lets
the navigation through, `CANCEL` blocks it.

### Actual Behavior

The navigation is cancelled before the Dart callback runs, so a host cannot
cancel the WebView navigation and open the payment/authentication deep link
externally.

### Environment

- Flutter: 3.47.4
- Xcode: 26.3 · iOS 26.3 Simulator
- zikzak_inappwebview: 6.0.2

### Workaround

None at the Dart layer — the cancellation happens in the native pre-navigation
gate.

## Comments

None — the report reached the repository through PR #334, which is the tracked
artifact for this bug.
