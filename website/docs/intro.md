---
sidebar_position: 1
---

# Getting Started

## What is ZikZak InAppWebView?

**ZikZak InAppWebView** is a feature-rich Flutter plugin that allows you to embed WebView widgets, run headless WebViews, and open in-app browser windows. It's a community-driven fork of `flutter_inappwebview` with active maintenance, faster bug fixes, and modern platform support.

### Key Features

- **Cross-Platform**: Android, iOS, Web, macOS, Windows, Linux — one unified API
- **Rich API**: Complete control over navigation, cookies, JavaScript, content blocking, file picking, and more
- **JavaScript Bridge**: Full bidirectional communication between Dart and JavaScript
- **Headless WebView**: Run WebViews in the background without UI
- **In-App Browser**: Full browser experience within your app
- **Modern Security**: Proactive security patches and latest platform API support

## Installation

Add `zikzak_inappwebview` to your `pubspec.yaml`:

```yaml
dependencies:
  zikzak_inappwebview: ^4.2.3
```

Then import the package:

```dart
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
```

## Requirements

| Platform | Minimum Version | Notes                     |
| -------- | --------------- | ------------------------- |
| Dart     | ^3.8.0          |                           |
| Flutter  | >=3.29.0        |                           |
| Android  | API 26+         | Android 8.0+              |
| iOS      | 16.0+           | Xcode 15+                 |
| macOS    | 14.0+           |                           |
| Windows  | 10+             | WebView2 Runtime required |
| Linux    |                 | WebKitGTK required        |
| Web      | Any             | Modern browser            |

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('InAppWebView Example')),
        body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri('https://flutter.dev'),
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

## Next Steps

- 📖 Read the [InAppWebView Guide](/docs/webview/in-app-webview)
- 🔗 Learn about [JavaScript Communication](/docs/webview/javascript/communication)
- 🍪 Explore the [Cookie Manager](/docs/utilities/cookie-manager)
- 📚 Browse the [API Reference](https://pub.dev/documentation/zikzak_inappwebview/latest/)

## Migrating from flutter_inappwebview

If you're migrating from the upstream `flutter_inappwebview` package, the API is nearly identical — just replace the import:

```dart
// Before
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// After
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
```

Key differences:

- **Active maintenance**: Bugs are fixed, PRs are merged, releases happen regularly
- **Version**: Our fork tracks at version 4.x.x (upstream is at 6.x.x)
- **Modern defaults**: Better security defaults, deprecated APIs cleaned up
- **Windows**: Native Dart implementation (no C++ compilation needed)
