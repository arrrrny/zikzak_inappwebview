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
  zikzak_inappwebview: ^4.6.0
```

## Requirements

| Platform    | Minimum Version | Notes                     |
| ----------- | --------------- | ------------------------- |
| **Flutter** | 3.10.0+         |                           |
| **Android** | API 24+         | Android 7.0+              |
| **iOS**     | 15.6+           |                           |
| **macOS**   | 12.0+           |                           |
| **Windows** | 10+             | Requires WebView2 Runtime |
| **Linux**   |                 | Requires WebKitGTK 2.40+  |
| **Web**     | Any             |                           |

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
