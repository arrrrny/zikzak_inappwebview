# Issue #339 — [BUG-macOS] useOnDownloadStart is dead: onDownloadStartRequest is never dispatched — no WKDownload plumbing (iOS parity gap)

Copied verbatim from arrrrny/zikzak_inappwebview#339 (sole input for this fix).

## Summary

On the **macOS** package (`zikzak_inappwebview_macos` 6.0.2), the
`onDownloadStartRequest` event **can never fire**: the Dart API and the settings
flag exist, but the native Swift half of the download chain is missing entirely.
The same suite ships the full working chain on **iOS** in the exact same
version, so this is an iOS→macOS parity gap, not a removed feature.

Found while implementing GUI downloads in a downstream consumer
([arrrrny/zuraffa_browser#214](https://github.com/arrrrny/zuraffa_browser/issues/214),
PR arrrrny/zuraffa_browser#222): the app wanted the lean v1 path (hook
`onDownloadStartRequest` → stream the file to `~/Downloads/zuraffa/`), and a
pre-UI spike against the resolved plugin source stopped the feature.

## Environment

- Package: `zikzak_inappwebview 6.0.2` (pub.dev), resolving
  `zikzak_inappwebview_macos 6.0.2` / `zikzak_inappwebview_ios 6.0.2`
- Verified against this repository's `master` @ `9e71017` (all platform
  packages still at `6.0.2`) — the gap is present there too
- Flutter 3.47.5 / Dart 3.13.4 consumer
- Method disclosure: findings are **static source evidence** from the exact
  resolved plugin code (analysis ran on a Linux host; no macOS runtime). Every
  claim below is a file+line citation from `master` @ `9e71017`.

## Evidence

### 1. The setting flag is declared but dead on macOS

`zikzak_inappwebview_macos/macos/.../InAppWebViewSettings.swift:9`:

```swift
var useOnDownloadStart = false
```

`rg -n "useOnDownloadStart" zikzak_inappwebview_macos/` shows the **only**
consumers are the declaration itself and a Dart-side inference in
`zikzak_inappwebview_macos/lib/src/in_app_webview/headless_in_app_webview.dart:334-336`
(which force-sets the flag to `true` when a Dart `onDownloadStartRequest`
callback is supplied). **No Swift code reads the flag.** Setting it to `true`
has no native effect.

### 2. No `WKDownload` plumbing of any kind in the macOS Swift sources

```
rg -n "WKDownload|WKDownloadDelegate|DownloadStartRequest|shouldPerformDownload|downloadDelegate" \
    zikzak_inappwebview_macos/macos/
# zero matches
```

The macOS package accepts the Dart `onDownloadStartRequest` callback
(`headless_in_app_webview.dart:30,104`) but nothing can ever dispatch it:
enumerating **every** native `invokeMethod(...)` call site in
`zikzak_inappwebview_macos/macos/**` yields exactly 27 distinct events —

`onBrowserCreated, onCloseWindow, onComplete, onConsoleMessage,
onContextMenuActionItemClicked, onCreateContextMenu, onCreateWindow, onExit,
onFindResultReceived, onHideContextMenu, onJsAlert, onJsConfirm, onJsPrompt,
onLoadStart, onLoadStop, onMessage, onPageCommitVisible, onPostMessage,
onPrintRequest, onProgressChanged, onReceivedError, onReceivedHttpError,
onScrollChanged, onTitleChanged, onUpdateVisitedHistory,
onWebContentProcessDidTerminate, onWebViewCreated`

— **no download event among them**.

### 3. The natural native hook point is empty

macOS implements `decidePolicyFor navigationResponse`
(`InAppWebView.swift:2764-2782`) but uses it **only** to emit
`onReceivedHttpError` for status ≥ 400, then unconditionally `.allow`. There is
no `canShowMimeView` check, no `.download` policy path, and no
`WKDownloadDelegate` adoption anywhere. This is precisely the hook the iOS
sibling uses (iOS `InAppWebView.swift:2539`).

### 4. iOS parity — the full chain exists in the same suite, same version

- `zikzak_inappwebview_ios/.../Types/DownloadStartRequest.swift` (the macOS
  package has no equivalent type in its Swift sources)
- Dispatch at iOS `InAppWebView/InAppWebView.swift:2444, 2467, 2598`
- Channel bridge at iOS `InAppWebView/WebViewChannelDelegate.swift:768-769`:

```swift
public func onDownloadStartRequest(request: DownloadStartRequest) {
    channel?.invokeMethod("onDownloadStartRequest", arguments: request.toMap())
}
```

### 5. Related: `NavigationActionPolicy.DOWNLOAD` is silently downgraded on macOS

macOS *does* dispatch `shouldOverrideUrlLoading`
(`InAppWebView.swift:2728-2760`, gated by `useShouldOverrideUrlLoading`), but
the handler maps Dart policy `2` (DOWNLOAD) to `.cancel`:

```swift
// InAppWebView.swift:2738-2741
case 0, 2:
    // 0 = CANCEL; 2 = DOWNLOAD (not supported on macOS yet —
    // fall back to CANCEL so we never silently allow a
    // navigation the user explicitly tried to block).
    policy = .cancel
```

This matches the Dart enum doc
(`platform_interface/.../navigation_action_policy.dart:10-13`, "available only
on iOS 14.5+... fallback to CANCEL") and the in-code comment ("not supported on
macOS yet") — flagging it here because it is the second half of the same gap.

### 6. API docs over-promise macOS

`zikzak_inappwebview_platform_interface/lib/src/in_app_webview/platform_webview.dart:195-201`
documents `onDownloadStartRequest` as:

> **Officially Supported Platforms/Implementations**: Android native WebView,
> iOS, **MacOS**

A consumer reading this (as our spec did) reasonably plans on macOS download
hooks that cannot fire.

## Minimal repro (sketch)

```dart
InAppWebView(
  initialUrlRequest: URLRequest(url: WebUri(server.serveAttachment())), // Content-Disposition: attachment
  onDownloadStartRequest: (controller, request) => print("DOWNLOAD: ${request.url}"), // never prints on macOS
  initialSettings: InAppWebViewSettings(useOnDownloadStart: true),
)
```

**Expected:** clicking the attachment link dispatches `onDownloadStartRequest`
with the URL/filename (as on iOS/Android).
**Actual on macOS 6.0.2:** the click navigates/is ignored per default WebKit
behavior; the callback never fires; no error or hint is emitted to Dart.

## Impact on a downstream consumer (concrete)

- zuraffa_browser planned its GUI-download v1 directly on this hook. The spike
  forced the spec's STOP clause: the streaming-save path (save to
  `~/Downloads/zuraffa/`, collision rename) was **deferred**, and the shipped
  fallback hands the URL to the OS (`process.open`) instead — a worse UX
  (external browser) that the plugin's documented macOS support promised to
  avoid.
- The app still wires `useOnDownloadStart: true` + the
  `onDownloadStartRequest` handler today (dormant on 6.0.2): the moment the
  native dispatch ships, the tested app-side flow lights up without an app
  change.

## Suggested fix direction (mirror iOS)

1. Port `Types/DownloadStartRequest.swift` to the macOS package.
2. In macOS `decidePolicyFor navigationResponse` (`InAppWebView.swift:2764`),
   add the iOS-style download detection (`canShowMimeView == false` →
   `.download`, macOS 10.15+) and honor `useOnDownloadStart` gating.
3. Respond to Dart `NavigationActionPolicy.DOWNLOAD` (2) from
   `shouldOverrideUrlLoading` as `.download` instead of `.cancel`.
4. Adopt `WKDownloadDelegate` and bridge via
   `WebViewChannelDelegate.onDownloadStartRequest` (as iOS does at
   `WebViewChannelDelegate.swift:768`). Even dispatching only the
   `onDownloadStartRequest` event (letting Dart stream the bytes, which is what
   our app does) would unblock the documented contract.
5. If macOS support is intentionally absent, remove "MacOS" from the
   `onDownloadStartRequest` platform doc and surface a debug warning when the
   callback/flag is set on macOS, so consumers don't build on a silent no-op.

Happy to provide the full spike record or test the fix on the downstream app
once a plugin build ships the dispatch.
