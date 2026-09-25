# Bug Issue: [macOS] Crash on macOS 15.1 in decidePolicyForNavigationAction — URLRequest._unconditionallyBridgeFromObjectiveC when accessing navigationAction.sourceFrame.request

- **Slug**: macos-sourceframe-crash
- **Fetched**: 2026-09-25
- **Issue**: 327
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/327
- **State**: open
- **Severity**: unknown (crash — user-visible EXC_BREAKPOINT)
- **Author**: docaohuynh
- **Labels**: (none)

## Body

App crashes on macOS 15.1 (Sequoia 24B83) when a navigation causes `WKNavigationAction.sourceFrame` (or its `.request`) to be nil at runtime. Does NOT crash on newer macOS (reported as macOS 26).

Crash details:

- Exception: `EXC_BREAKPOINT (SIGTRAP)`, signal 5, main thread
- Key frames: `static URLRequest._unconditionallyBridgeFromObjectiveC(_:)` ← `WebKit::NavigationState::NavigationClient::decidePolicyForNavigationAction(...)` ← `WebKit::WebPageProxy::decidePolicyForNavigationAction(...)`

Root cause per report — in `zikzak_inappwebview_macos` → `InAppWebView.swift`:

```swift
let sourceFrame: [String: Any] = [
    "isMainFrame": navigationAction.sourceFrame.isMainFrame,
    "request": ["url": navigationAction.sourceFrame.request.url?.absoluteString ?? ""],
    "securityOrigin": [
        "host": navigationAction.sourceFrame.securityOrigin.host,
        ...
    ],
]
```

`sourceFrame` and especially `sourceFrame.request` are treated as non-optional, but WebKit can return nil at runtime on macOS 15.1 (nullability annotation mismatch between the ObjC runtime and the Swift overlay). `targetFrame` is already guarded with `if let`, but `sourceFrame` is not.

Environment: `zikzak_inappwebview` 4.7.0, macOS 15.1 (24B83) crashes; macOS 26 does not; Apple Silicon; app uses the `shouldOverrideUrlLoading` path.

Suggested fix (per report): safely access `sourceFrame` via optional/KVC read with fallback, same spirit as the existing `targetFrame` guard.

Crash log attached to the issue (sing-my-song-log-2026-09-08-162851.ips.txt).

## Comments

None.
