# zikzak_webview_windows

A [Flutter](https://flutter.dev/) WebView plugin for Windows built on [Microsoft Edge WebView2](https://docs.microsoft.com/en-us/microsoft-edge/webview2/).

> **This is a maintained fork of [`webview_windows`](https://pub.dev/packages/webview_windows) by Niklas Schulze
> ([jnschulze/flutter-webview-windows](https://github.com/jnschulze/flutter-webview-windows)).**
> It is renamed and published under the `zikzak_*` namespace so that
> [`zikzak_inappwebview`](https://pub.dev/packages/zikzak_inappwebview) can consume a WebView2 build that carries the
> DevTools protocol API from [jnschulze/flutter-webview-windows#334](https://github.com/jnschulze/flutter-webview-windows/pull/334),
> which no hosted `webview_windows` release has. Everything that is not listed in
> [CHANGELOG.md](CHANGELOG.md) under `0.5.0` is upstream work, unchanged. The original BSD-3-Clause license is retained in
> [LICENSE](LICENSE); copyright remains with Niklas Schulze.

## Differences from upstream `webview_windows`

* Package name `webview_windows` → `zikzak_webview_windows`. Import
  `package:zikzak_webview_windows/zikzak_webview_windows.dart`.
* The native plugin follows the rename (`ZikzakWebviewWindowsPlugin`, CMake target
  `zikzak_webview_windows_plugin`), because Flutter's Windows plugin registrant derives the header path and the
  registration symbol from the package name.
* SDK constraint widened from `>=2.13.0 <3.0.0` to `>=3.8.0 <4.0.0`, and `flutter: >=3.47.0` declared. The upstream upper
  bound excludes Dart 3, so a hosted package carrying it cannot be resolved by any Dart 3 consumer.
* Carries the WebView2 DevTools protocol API (`callDevToolsProtocolMethod`, `devToolsProtocolEvent`, DevTools listener
  add/remove) from TsinbeiLabs' branch for upstream PR #334.

## Target platform requirements

- [WebView2 Runtime](https://developer.microsoft.com/en-us/microsoft-edge/webview2/)
  Before initializing the webview, call `getWebViewVersion()` to check whether the required **WebView2 Runtime** is
  installed or not on the current system. If `getWebViewVersion()` returns null, guide your user to install
  **WebView2 Runtime** from this [page](https://developer.microsoft.com/en-us/microsoft-edge/webview2/).
- Windows 10 1809+

## Development platform requirements

- Visual Studio 2019 or higher
- Windows 11 SDK (10.0.22000.194 or higher)
- (recommended) nuget.exe in your $PATH *(The makefile attempts to download nuget if it's not installed, however, this fallback might not work in China)*

## Limitations

This plugin provides seamless composition of web-based contents with other Flutter widgets by rendering off-screen.

Unfortunately, [Microsoft Edge WebView2](https://docs.microsoft.com/en-us/microsoft-edge/webview2/) doesn't currently have an explicit API for offscreen rendering.
In order to still be able to obtain a pixel buffer upon rendering a new frame, this plugin currently relies on the `Windows.Graphics.Capture` API provided by Windows 10.
The downside is that older Windows versions aren't currently supported.

Older Windows versions might still be targeted by using `BitBlt` for the time being.

See:
- https://github.com/MicrosoftEdge/WebView2Feedback/issues/20
- https://github.com/MicrosoftEdge/WebView2Feedback/issues/526
- https://github.com/MicrosoftEdge/WebView2Feedback/issues/547