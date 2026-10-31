<div align="center">

# 🚀 ZikZak InAppWebView

### _The Feature-Rich WebView Plugin for Flutter_

<img src="https://img.shields.io/badge/Maintenance-Active-brightgreen" alt="Actively Maintained">
<img src="https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-blue" alt="Platforms">
<img src="https://img.shields.io/badge/License-Apache%202.0-blue" alt="License">

---

A Flutter plugin that allows you to add an inline WebView, use an headless WebView, and open an in-app browser window.
This is a community-driven fork of `flutter_inappwebview` focused on active maintenance, stability, and modern platform support.

[**Documentation**](https://arrrrny.github.io/zikzak_inappwebview/) | [**Pub.dev**](https://pub.dev/packages/zikzak_inappwebview) | [**API Reference**](https://pub.dev/documentation/zikzak_inappwebview/latest/)

</div>

---

## ✨ Key Features

- **Cross-Platform**: Support for Android, iOS, Web, macOS, Windows, and Linux.
- **In-App Browser**: Open a full-featured browser window inside your app.
- **Headless WebView**: Run WebView in the background without a UI.
- **Rich API**: Extensive control over navigation, cookies, scripts, and more.
- **Modern Security**: Enhanced security features and updates.

## 🧭 Navigation Tracker & Session Recipes

Two pure-Dart modules (no native code) built on the same UserScript + JS-bridge architecture as Network Capture:

**NavigationTracker** (`lib/src/navigation_tracker/`) — a unified, ordered URL-cycle stream for a webview. Merges `onLoadStart`/`onUpdateVisitedHistory`/server-redirect callbacks with an injected script that patches `history.pushState`/`replaceState` and listens to `popstate`/`hashchange`/`pageshow`, deduplicated into `UrlCycleEntry` records (`url`, `timestamp`, `trigger`, `isMainFrame`). Useful anywhere you need navigation history.

**Session Recipe** (`lib/src/session_recipe/`) — guided multi-step session recording and DOM-based replay:

```dart
final recorder = RecipeRecorder.maybeCreate(recipe: myRecipe, onEvent: (event) { /* live UI feedback */ });

InAppWebView(
  initialUserScripts: RecipeRecorder.mergeUserScripts(null, recorder),
  onWebViewCreated: recorder.attach,
  onLoadStart: (_, url) => recorder.onLoadStart(url),
  onUpdateVisitedHistory: (_, url, __) => recorder.onUpdateVisitedHistory(url),
  onNetworkRequest: (_, req) => recorder.onNetworkRequest(req),   // signal matching
  onNetworkResponse: (_, res) => recorder.onNetworkResponse(res),
);

// User confirms each step; finish() snapshots cookies into the recording.
final recording = await recorder.finish();

// Later: restore the session and replay steps via recorded DOM selectors.
final result = await RecipeReplayer().replay(
  controller: controller, recipe: myRecipe, recording: recording,
);
```

All models are storage-agnostic JSON (`toJson`/`fromJson`) — persist recordings however you like. See `test/session_recipe/` and `test/navigation_tracker/` for usage examples.

## � Installation

## Installation

Add `zikzak_inappwebview` to your `pubspec.yaml`:

```yaml
dependencies:
  zikzak_inappwebview: ^6.3.3
```

## Requirements

| Platform    | Minimum Version | Notes                     |
| ----------- | --------------- | ------------------------- |
| **Flutter** | 3.10.0+         |                           |
| **Android** | API 24+         | Android 7.0+              |
| **iOS**     | 15.0+           |                           |
| **macOS**   | 12.0+           |                           |
| **Windows** | 10+             | Requires WebView2 Runtime |
| **Linux**   |                 | Requires WebKitGTK 2.40+  |
| **Web**     | Any             |                           |

## ⚠️ Known Issues

### [iOS] Flutter 3.47.x: platform views drop overlapping Flutter content (#331)

On the Flutter 3.47.x stable line, iOS platform views — including `InAppWebView` — can make the Flutter content painted after them vanish from the frame ("rendering layer confusion"): an `AppBar` turns invisible, a modal bottom sheet's footer and the list items below a WebView card are not drawn. Upgrading from 3.44.x to 3.47.2 triggers it; the same app renders correctly on 3.44.x. The artifact shows up when Flutter content is composited over or after a platform view — for example a full-screen WebView body underneath a `showModalBottomSheet` that embeds more WebViews in a `ListView` — and multiple parties report it needs more than one platform view visible at once. It reproduces with Impeller disabled, so it is not an Impeller rasterizer bug.

This is an engine regression in Flutter's texture-layer hybrid composition (TLHC) overlay path, tracked upstream in [flutter/flutter#193363](https://github.com/flutter/flutter/issues/193363) (triaged `engine` / `platform-views`, `c: regression`). It is **not a plugin code defect**, and no plugin setting fixes it: the on-device mitigation matrix recorded in [`.specify/bugs/flutter347-platformview-rendering/fix.md`](https://github.com/arrrrny/zikzak_inappwebview/blob/master/.specify/bugs/flutter347-platformview-rendering/fix.md) (§ *Mitigation matrix*) leaves the artifact unchanged for every candidate tested — control `UiKitView`, Impeller disabled, an `Opacity(0.99)` snapshot wrap, native `clipsToBounds`, and `PlatformViewLink` construction. The plugin already pins the WKWebView root to its Flutter bounds (`clipsToBounds = true` at view setup), which is correctness hardening against mis-clipped compositing paths, not a fix for this artifact.

Workarounds until the engine fix ships in a Flutter stable release:

1. **Stay on the Flutter 3.44.x stable line** if your app overlays platform views with modal routes or can show more than one platform view at once.
2. **Avoid compositing Flutter content over a live platform view**: dismiss the underlying WebView (or keep it out of the tree) before presenting the sheet, and keep platform views out of lazy lists when possible.
3. Removing clip wrappers (`ClipRRect`, `Container` with `clipBehavior`) around the platform view has unblocked some layouts reported upstream, but it does not address the root cause and is not guaranteed.

## 🚀 Getting Started

Check out the [online documentation](https://arrrrny.github.io/zikzak_inappwebview/) for comprehensive guides and examples.

```dart
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

// ... inside your widget tree
InAppWebView(
  initialUrlRequest: URLRequest(url: WebUri("https://flutter.dev")),
  onWebViewCreated: (controller) {
    // Controller is ready!
  },
)
```

## 🤝 Contributing

Contributions are welcome! If you find a bug or have a feature request, please [open an issue](https://github.com/arrrrny/zikzak_inappwebview/issues).

## ⚖️ License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
