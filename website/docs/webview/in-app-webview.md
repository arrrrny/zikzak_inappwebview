---
sidebar_position: 1
title: InAppWebView Widget
---

# InAppWebView Widget

InAppWebView is a Flutter Widget for adding an **inline native WebView** integrated into the Flutter widget tree.

## Platform Implementations

- **Android:** AndroidViewSurface
- **iOS:** UiKitView
- **macOS:** AppKitView (deprecated in v3.0)
- **Windows:** Custom implementation (deprecated in v3.0)
- **Web:** HtmlElementView via iframe (deprecated in v3.0)

:::info
ZikZak InAppWebView v3.0+ focuses exclusively on **Android and iOS** platforms for better quality and maintenance.
:::

## Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

class MyInAppBrowser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri('https://flutter.dev'),
      ),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        safeBrowsingEnabled: true, // Enabled by default in v3.0
      ),
      onWebViewCreated: (controller) {
        print('WebView created');
      },
      onLoadStart: (controller, url) {
        print('Page started loading: $url');
      },
      onLoadStop: (controller, url) async {
        print('Page finished loading: $url');
      },
      onProgressChanged: (controller, progress) {
        print('Loading progress: $progress%');
      },
    );
  }
}
```

## JavaScript Integration

JavaScript is **enabled by default** in ZikZak InAppWebView.

:::warning Important Timing Consideration
Do NOT call `evaluateJavascript` methods too early (such as in `onWebViewCreated` or `onLoadStart`). Use them in `onLoadStop` or other events where you know the page is ready.
:::

```dart
onLoadStop: (controller, url) async {
  // Safe to evaluate JavaScript here
  var result = await controller.evaluateJavascript(
    source: "document.title"
  );
  print('Page title: $result');
},
```

## Navigation Handling

Key navigation events:

### onLoadStart

Fires when page loading begins.

```dart
onLoadStart: (controller, url) {
  print('Started loading: $url');
},
```

### onLoadStop

Fires when page loading completes.

:::note
Could be called multiple times - this is platform-specific behavior.
:::

```dart
onLoadStop: (controller, url) async {
  print('Finished loading: $url');
},
```

### onUpdateVisitedHistory

For history-based navigation changes via JavaScript (when History API functions like `pushState()` or `replaceState()` are invoked).

```dart
onUpdateVisitedHistory: (controller, url, isReload) {
  print('History updated: $url, reload: $isReload');
},
```

## Custom URL Schemes

WebView restricts resources and links using custom schemes. Use well-formed URLs with custom schemes (e.g., `example-app://showProfile`) rather than simple strings in links.

For custom schemes returning responses, use **onLoadResourceWithCustomScheme**:

```dart
InAppWebView(
  initialSettings: InAppWebViewSettings(
    resourceCustomSchemes: ['my-scheme'],
  ),
  onLoadResourceWithCustomScheme: (controller, request) async {
    if (request.url.scheme == 'my-scheme') {
      // Return custom response
      return CustomSchemeResponse(
        data: Uint8List.fromList(utf8.encode('<html><body>Custom content</body></html>')),
        contentType: 'text/html',
      );
    }
    return null;
  },
),
```

## Local Content Loading

Three recommended approaches:

### 1. WebView Asset Loader (Android Only)

Provides flexible, performant loading with same-origin policy compliance.

```dart
// See WebView Asset Loader documentation
```

### 2. InApp Localhost Server

Creates a local server on `http://localhost:[port]/`

```dart
InAppLocalhostServer server = InAppLocalhostServer();
await server.start();

InAppWebView(
  initialUrlRequest: URLRequest(
    url: WebUri('http://localhost:8080/assets/index.html'),
  ),
)
```

### 3. loadData()

For simple HTML-only pages without subresources.

```dart
controller.loadData(
  data: '<html><body><h1>Hello World</h1></body></html>',
  baseUrl: WebUri('https://example.com'),
  mimeType: 'text/html',
  encoding: 'utf-8',
);
```

:::tip
The `baseUrl` should be HTTP(S) to comply with same-origin policies.
:::

## Security Recommendations

### ✅ DO:
- Load in-app content over HTTP/HTTPS
- Use appropriate mixed content modes
- Enable Safe Browsing (enabled by default in v3.0)
- Use WebView Asset Loader or localhost server for local content

### ❌ DO NOT:
- Use `file://` or `data:` URLs (opaque origins lacking powerful web APIs)
- Set `allowFileAccessFromFileURLs` or `allowUniversalAccessFromFileURLs` to true
- Use `file://android_assets/` or `file://android_res/` URLs
- Use `MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW`

## Window Management

By default, new window requests are ignored. To enable JavaScript window opening:

```dart
InAppWebView(
  initialSettings: InAppWebViewSettings(
    javaScriptCanOpenWindowsAutomatically: true,
    supportMultipleWindows: true, // Android requirement
  ),
  onCreateWindow: (controller, createWindowAction) async {
    // Customize window opening behavior
    print('New window requested: ${createWindowAction.request.url}');

    // You can create a new InAppWebView here
    return true;
  },
  onCloseWindow: (controller) {
    print('Window should close');
  },
)
```

## Common Settings

```dart
InAppWebViewSettings(
  // JavaScript
  javaScriptEnabled: true,

  // Security (v3.0 defaults)
  safeBrowsingEnabled: true,

  // Media
  mediaPlaybackRequiresUserGesture: false,

  // Zoom
  supportZoom: true,
  builtInZoomControls: true,
  displayZoomControls: false,

  // Caching
  cacheEnabled: true,

  // User Agent
  userAgent: 'Custom User Agent String',

  // Content
  loadWithOverviewMode: true,
  useWideViewPort: true,
)
```

## Controller Methods

The `InAppWebViewController` provides methods to control the WebView:

```dart
InAppWebViewController controller;

// Navigation
await controller.loadUrl(urlRequest: URLRequest(url: WebUri('https://example.com')));
await controller.reload();
await controller.goBack();
await controller.goForward();

// JavaScript
var result = await controller.evaluateJavascript(source: 'document.title');

// Scroll
await controller.scrollTo(x: 0, y: 100);
var scrollPosition = await controller.getScrollX();

// Zoom
await controller.zoomBy(zoomFactor: 2.0);

// Screenshots
Uint8List? screenshot = await controller.takeScreenshot();

// Page info
var url = await controller.getUrl();
var title = await controller.getTitle();
```

## Next Steps

- [JavaScript Injection](./javascript/injection)
- [JavaScript Communication](./javascript/communication)
- User Scripts (coming soon)
- Context Menu (coming soon)
- Pull-to-Refresh Controller (coming soon)
