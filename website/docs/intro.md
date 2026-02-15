---
sidebar_position: 1
---

# Introduction

**ZikZak InAppWebView** is a feature-rich Flutter plugin that allows you to add an inline WebView, use a headless WebView, and open an in-app browser window.

It provides a unified API for **Android, iOS, Web, macOS, Windows, and Linux**.

## Features

- **Inline WebView**: Embed web content directly into your Flutter widgets.
- **In-App Browser**: Open a full-featured browser window within your app.
- **Headless WebView**: Run web content in the background without a UI.
- **Cross-Platform**: Consistent API across 6 platforms.
- **Rich API**: Cookie management, script injection, custom headers, content blocking, and more.
- **Security**: Google Safe Browsing, certificate pinning, and HTTPS-only mode.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  zikzak_inappwebview: ^4.0.0
```

Then run:

```bash
flutter pub get
```

## Platform Requirements

### v4.0.0 (Current)
- **Dart**: `>=3.0.0 <4.0.0`
- **Flutter**: `>=3.10.0`
- **Android**: minSdk 21+, compileSdk 34+
- **iOS**: 12.0+
- **macOS**: 10.14+
- **Windows**: Windows 10/11
- **Linux**: Any modern distribution (GTK 3+)
- **Web**: Any modern browser

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
            safeBrowsingEnabled: true,
          ),
          onWebViewCreated: (controller) {
            print('WebView created!');
          },
          onLoadStop: (controller, url) {
            print('Page finished loading: $url');
          },
        ),
      ),
    );
  }
}
```
