---
sidebar_position: 1
---

# Getting Started

Welcome to **ZikZak InAppWebView** - the actively maintained Flutter WebView plugin!

## What is ZikZak InAppWebView?

ZikZak InAppWebView is a fork of the popular [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview) plugin that provides inline WebView, headless WebView, and in-app browser capabilities for Flutter applications.

**The key difference?** This fork is **actively maintained** by a human+AI team, with:

- ✅ Regular updates and bug fixes
- ✅ Quick responses to issues (usually within 24-48 hours)
- ✅ Security-first approach
- ✅ Modern architecture and clean code
- ✅ Breaking changes welcomed in v3.0 for a better future

## Why ZikZak InAppWebView?

The original `flutter_inappwebview` plugin, despite having 3.6k+ stars and being used by thousands of developers, has been left unmaintained. Critical bugs, iOS 18 crashes, and Xcode 16 build failures have gone unaddressed.

**ZikZak InAppWebView** exists because someone had to step up. We're here to:

- Fix critical bugs promptly
- Respond to issues and review PRs
- Implement modern security features
- Refactor and modernize the codebase
- Support the Flutter community

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  zikzak_inappwebview: ^3.0.0
```

Or live on the edge with the latest from Git:

```yaml
dependencies:
  zikzak_inappwebview:
    git:
      url: https://github.com/arrrrny/zikzak_inappwebview.git
      ref: main
```

Then run:

```bash
flutter pub get
```

## Platform Requirements

### v3.0 (Current)
- **Dart**: `>=2.17.0 <4.0.0`
- **Flutter**: `>=3.0.0`
- **Android**: minSdk 24 (Android 7.0+), compileSdk 36
- **iOS**: 15.0+, Xcode 14.3+
- **Platforms**: Android & iOS only (mobile-first, lean and clean)

### v2.x (Legacy)
- **Android**: minSdk 19, compileSdk 36
- **iOS**: 13.0+
- **Platforms**: Android, iOS, macOS, Web (deprecated)

## Quick Example

Here's a simple example to get you started:

```dart
import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('ZikZak InAppWebView')),
        body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri('https://flutter.dev'),
          ),
          initialSettings: InAppWebViewSettings(
            safeBrowsingEnabled: true, // Already enabled by default!
          ),
          onWebViewCreated: (controller) {
            print('WebView created!');
          },
          onLoadStop: (controller, url) {
            print('Page loaded: $url');
          },
        ),
      ),
    );
  }
}
```

## What's New in v3.0?

v3.0 brings major improvements and breaking changes (intentionally!):

### Completed Changes
- ✅ macOS/Windows/Web support removed (mobile-first focus)
- ✅ Minimum Android SDK raised to 24 (Android 7.0+)
- ✅ Minimum iOS raised to 15.0+
- ✅ Google Safe Browsing enabled by default
- ✅ Published to pub.dev

### Coming Soon
- ⏳ 30+ redundant settings removal
- ⏳ JavaScript disabled by default (opt-in for security)
- ⏳ Continued architecture refactoring

See the [Modernization Plan](./modernization-plan) for full details.

## Key Features

### Security (v3.0+)

- **Google Safe Browsing**: Enabled by default to protect against phishing and malware
- **Certificate Pinning**: SHA-256 public key pinning for MITM prevention
- **HTTPS-Only Mode**: Block or upgrade insecure HTTP requests
- **URL Scheme Validation**: Block dangerous schemes
- **Content Security Policy**: Proper HTTP header-based CSP

Learn more in [Security Features](./security-features).

### Core Functionality

- **InAppWebView Widget**: Embed WebViews directly in your Flutter UI
- **Headless WebView**: Run WebViews in the background
- **In-App Browser**: Chrome Custom Tabs (Android) / SFSafariViewController (iOS)
- **JavaScript Handlers**: Two-way communication between Dart and JavaScript
- **Cookie Management**: Full control over WebView cookies
- **File Downloads**: Handle file downloads with callbacks
- **Navigation Delegates**: Intercept and control navigation
- **Custom URL Schemes**: Handle custom schemes in your app

## Next Steps

- 📖 Read the [Modernization Plan](./modernization-plan)
- 🔒 Explore [Security Features](./security-features)
- 🐛 [Report issues](https://github.com/arrrrny/zikzak_inappwebview/issues)
- 💡 [Contribute](https://github.com/arrrrny/zikzak_inappwebview)

## Get Help

- **GitHub Issues**: [Open an issue](https://github.com/arrrrny/zikzak_inappwebview/issues)
- **GitHub Discussions**: [Ask questions](https://github.com/arrrrny/zikzak_inappwebview/discussions)
- **Stack Overflow**: Tag your question with `flutter-inappwebview`

## Support the Project

If you find this plugin useful, please:

- ⭐ Star the repo on [GitHub](https://github.com/arrrrny/zikzak_inappwebview)
- 📣 Share it with other Flutter developers
- 🐛 Report bugs and contribute fixes
- 💙 Give it a like on [pub.dev](https://pub.dev/packages/zikzak_inappwebview)

---

**Made with 💙 (and lots of caffeine) by ARRRRNY + Claude AI**
