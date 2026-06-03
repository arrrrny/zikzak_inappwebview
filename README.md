<div align="center">

# 🚀 ZikZak InAppWebView

### _The Feature-Rich WebView Plugin for Flutter_

<img src="https://img.shields.io/badge/Maintenance-Active-brightgreen" alt="Actively Maintained">
<img src="https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-blue" alt="Platforms">
<img src="https://img.shields.io/badge/License-Apache%202.0-blue" alt="License">

---

A Flutter plugin that allows you to add an inline WebView, use an headless WebView, and open an in-app browser window.
This is a community-driven fork of `flutter_inappwebview` focused on active maintenance, stability, and modern platform support.

## Sponsor

[![https://zuzu.dev](./assets/zikzak-ai.png)](https://zuzu.dev) [![Sponsored by ZikZak AI](https://img.shields.io/badge/Sponsored%20by-ZikZak%20AI-8A2BE2?style=flat-square&logo=heart)](https://zuzu.dev)

Thanks to ZikZak AI for sponsoring this project!

ZikZak AI is an AI-Powered Price Comparison app that you scan barcodes, and discover amazing savings instantly. Your personal shopping assistant that never sleeps.

<a href="https://apps.apple.com/tr/app/zik-zak/id1563425450"><img src="assets/app-store-badge.png" width="160" style="margin-right: 8px;"></a>
<a href="https://play.google.com/store/apps/details?id=dev.zuzu.zingo"><img src="assets/google-play-badge.png" width="160"></a>

[**Documentation**](https://arrrrny.github.io/zikzak_inappwebview/) | [**Pub.dev**](https://pub.dev/packages/zikzak_inappwebview) | [**API Reference**](https://pub.dev/documentation/zikzak_inappwebview/latest/) | [**Changelog**](https://github.com/arrrrny/zikzak_inappwebview/blob/master/zikzak_inappwebview/CHANGELOG.md)

</div>

---

## ✨ Key Features

- **Cross-Platform**: Support for Android, iOS, Web, macOS, Windows, and Linux.
- **In-App Browser**: Open a full-featured browser window inside your app.
- **Headless WebView**: Run WebView in the background without a UI.
- **Rich API**: Extensive control over navigation, cookies, scripts, and more.
- **Modern Security**: Enhanced security features and updates.

## � Installation

Add `zikzak_inappwebview` to your `pubspec.yaml`:

```yaml
dependencies:
  zikzak_inappwebview: ^4.0.0
```

## � Requirements

| Platform    | Minimum Version | Notes                     |
| ----------- | --------------- | ------------------------- |
| **Flutter** | 3.10.0+         |                           |
| **Android** | API 24+         | Android 7.0+              |
| **iOS**     | 15.0+           |                           |
| **macOS**   | 11.0+           |                           |
| **Windows** | 10+             | Requires WebView2 Runtime |
| **Linux**   |                 | Requires WebKitGTK        |
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

## 📦 Migration from flutter_inappwebview

Simply replace the import:

```dart
// Before
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// After
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
```

The API is nearly identical. Version 4.x.x corresponds to upstream 6.x.x.

## 📊 Project Stats

We track and triage all 156+ open issues from the upstream repository. Check out our [UPSTREAM_ISSUES_TRIAGE.md](./UPSTREAM_ISSUES_TRIAGE.md) for the full analysis.

## 🤝 Contributing

Contributions are welcome! If you find a bug or have a feature request, please [open an issue](https://github.com/arrrrny/zikzak_inappwebview/issues).

## ⚖️ License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
