# Bug Spec: macOS download chain — onDownloadStartRequest dispatch (Bug #339)

## Problem

The macOS package declares `useOnDownloadStart` (`InAppWebViewSettings.swift:9`)
and accepts the Dart `onDownloadStartRequest` callback, but no Swift code reads
the flag and no `WKDownload`/`WKDownloadDelegate`/`DownloadStartRequest` plumbing
exists anywhere in `zikzak_inappwebview_macos/macos/`. The same suite ships the
full working chain on iOS in the same version, so the documented macOS support
(`platform_webview.dart:195-201` lists MacOS) cannot fire its event. Additionally,
`shouldOverrideUrlLoading` silently downgrades Dart policy
`NavigationActionPolicy.DOWNLOAD` (2) to `.cancel` on macOS.

## Acceptance Criteria

1. **AC1 — Type parity.** The macOS Swift sources ship a
   `Types/DownloadStartRequest.swift` (port of the iOS type) exposing the
   documented payload fields (`url`, `userAgent`, `contentDisposition`,
   `mimeType`, `contentLength`, `suggestedFilename`, `textEncodingName`) via
   `toMap()`.
2. **AC2 — Download pipeline adoption.** macOS `InAppWebView` adopts
   `WKDownloadDelegate` and implements the destination callback
   (`download(_:decideDestinationUsing:suggestedFilename:completionHandler:)`)
   plus `webView(_:navigationResponse:didBecome:)`, dispatching
   `onDownloadStartRequest` and cancelling the native download
   (`completionHandler(nil)`) so the Dart side streams the bytes (lean-v1
   contract, mirroring iOS `InAppWebView.swift:2429-2469`).
3. **AC3 — Response-time download detection.** macOS
   `decidePolicyFor navigationResponse` honors `useOnDownloadStart`: a response
   that cannot be shown (`!canShowMIMEType`) resolves `.download`; the iOS-style
   main-frame/non-text-mime fallback dispatches the event and cancels the
   navigation; every path calls `decisionHandler` exactly once (mirroring iOS
   `InAppWebView.swift:2573-2597` for the default `useOnNavigationResponse`
   path — macOS has no `onNavigationResponse` dispatch, so the flag is not
   consulted here, which also avoids a WebKit decision-handler hang).
4. **AC4 — DOWNLOAD policy honored.** `shouldOverrideUrlLoading` maps Dart
   policy `2` (DOWNLOAD) to `.download` in both the `Int` and `NSNumber`
   normalization branches instead of silently downgrading to `.cancel`.
5. **AC5 — Channel bridge.** macOS `WebViewChannelDelegate` exposes
   `onDownloadStartRequest(request:)` invoking
   `channel?.invokeMethod("onDownloadStartRequest", arguments: request.toMap())`
   (iOS `WebViewChannelDelegate.swift:768-769` parity).
6. **AC6 — Dart routing.** `MacOSInAppWebViewController.handleMethod` handles
   `'onDownloadStartRequest'`, decodes `DownloadStartRequest.fromJson`, and
   forwards to `params.webviewParams!.onDownloadStartRequest!` — without this
   case the Swift event would fall into the `default:` branch
   (`throw UnimplementedError`) and the user callback would still never fire.
7. **AC7 — Minimal blast radius.** Only the macOS package changes
   (`zikzak_inappwebview_macos/**`) plus this bug's records under
   `.specify/bugs/339-*/` and `.specify/feature.json`; no other platform or
   package is touched; no unrelated formatting churn.
8. **AC8 — No regression.** `flutter analyze` and `flutter test` in
   `zikzak_inappwebview_macos` show no regression vs the pre-fix baseline; the
   new parity contract test is green.

## Environment Boundary (recorded, not hidden)

The end-to-end reproduction (clicking a `Content-Disposition: attachment` link
and observing the Dart callback fire) requires a macOS host with Xcode. This fix
was produced on Linux, where WebKit/FlutterMacOS cannot load and
`flutter build macos` does not exist as a subcommand. The red→green evidence is
therefore a host-runnable source-contract test (the repo's established pattern:
`swift_sourceframe_kvc_test.dart`, `user_script_initializer_parity_test.dart`)
plus static `rg` evidence and a Swift parse gate; the macOS runtime gates are
recorded as `MACOS-ONLY / NOT_EXECUTED` with exact CI commands in
`tdd/cycle-log.md`.
