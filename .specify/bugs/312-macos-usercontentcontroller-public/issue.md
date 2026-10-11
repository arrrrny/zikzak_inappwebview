# Bug Issue: macOS 5.2.1/5.3.0 build error — userContentController must be public

- **Slug**: 312-macos-usercontentcontroller-public
- **Fetched**: 2026-09-05T04:40:00Z
- **Issue**: 312
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/312
- **State**: open
- **Severity**: critical
- **Author**: (see GitHub issue)
- **Labels**: none

## Body

### Build Error

```
InAppWebView.swift:2318:10: error: method 'userContentController(_:didReceive:)' must be declared public because it matches a requirement in public protocol 'WKScriptMessageHandler'
```

### Versions Affected

- zikzak_inappwebview_macos 5.2.1
- zikzak_inappwebview_macos 5.3.0

### Expected

The `userContentController(_:didReceive:)` method in `InAppWebView.swift` should be
declared `public` so it can satisfy the `WKScriptMessageHandler` protocol
requirement when the class is used as a public delegate.

### Context

This was introduced in PR #310 (fix/309-macos-domexception-crash) which added the
`userContentController(_:didReceive:)` method for defensive deserialization. The
method needs the `public` access modifier to match the protocol requirement.

## Comments

None.

## Root cause (verified in tree at `6fb7f8cb`)

`InAppWebView` is declared `public class InAppWebView: WKWebView, WKNavigationDelegate,
WKScriptMessageHandler, DefensivelyDeserializedScriptMessageHandling, WKUIDelegate,
NSMenuDelegate` (`Sources/zikzak_inappwebview_macos/InAppWebView.swift:70`). The
2-argument `userContentController(_:didReceive:)` witness at line 2318 is declared
without an access modifier (internal), so it cannot satisfy the requirement of the
public `WKScriptMessageHandler` protocol from WebKit. The 4-argument sanitized
variant added by #309 (line 2334) is already `public` and is NOT a protocol
requirement (extra parameters) — it is unaffected.

Introduced by PR #310 (commit `864e791a`, `fix/309-macos-domexception-crash`),
which added the internal 2-arg fallback method for direct registration.
