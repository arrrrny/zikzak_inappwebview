---
sidebar_position: 1
title: InAppBrowser
---

# InAppBrowser

`InAppBrowser` represents a native WebView displayed **on top of your Flutter app**, outside the Flutter widget tree.

**Supported Platforms:** Android, iOS, macOS, Windows, Linux, Web

## Basic Usage

Create a class that extends `InAppBrowser`:

```dart
import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

class MyInAppBrowser extends InAppBrowser {
  @override
  Future onBrowserCreated() async {
    print('Browser created!');
  }

  @override
  Future onLoadStart(url) async {
    print('Started loading: $url');
  }

  @override
  Future onLoadStop(url) async {
    print('Finished loading: $url');
  }

  @override
  void onReceivedError(WebResourceRequest request, WebResourceError error) {
    print('Error: ${error.description}');
  }

  @override
  void onProgressChanged(int progress) {
    print('Progress: $progress%');
  }

  @override
  void onExit() {
    print('Browser closed!');
  }
}
```

### Opening the Browser

```dart
final browser = MyInAppBrowser();

// Open with URL
await browser.openUrlRequest(
  urlRequest: URLRequest(
    url: WebUri('https://flutter.dev'),
  ),
  settings: InAppBrowserClassSettings(
    browserSettings: InAppBrowserSettings(
      hideUrlBar: false,
      toolbarTopBackgroundColor: Colors.blue,
    ),
    webViewSettings: InAppWebViewSettings(
      javaScriptEnabled: true,
      safeBrowsingEnabled: true,
    ),
  ),
);

// Or open with data
await browser.openData(
  data: '<html><body><h1>Hello World</h1></body></html>',
  mimeType: 'text/html',
  encoding: 'utf-8',
  baseUrl: WebUri('https://example.com'),
  settings: InAppBrowserClassSettings(/*...*/),
);
```

## Accessing the WebView Controller

Use `webViewController` to control the WebView:

```dart
class MyInAppBrowser extends InAppBrowser {
  @override
  Future onLoadStop(url) async {
    // Use the webViewController
    String? title = await webViewController?.getTitle();
    print('Page title: $title');

    // Evaluate JavaScript
    var result = await webViewController?.evaluateJavascript(
      source: 'document.body.innerHTML'
    );

    // Navigate
    await webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri('https://example.com'))
    );

    // Reload
    await webViewController?.reload();
  }
}
```

## Browser Settings

### InAppBrowserSettings

```dart
InAppBrowserSettings(
  // UI
  hideUrlBar: false,
  hideToolbarTop: false,
  hideToolbarBottom: true,
  toolbarTopBackgroundColor: Colors.blue,
  toolbarTopFixedTitle: 'My Browser',

  // Presentation (iOS)
  presentationStyle: ModalPresentationStyle.FULL_SCREEN,
  transitionStyle: ModalTransitionStyle.COVER_VERTICAL,

  // Menu
  hideDefaultMenuItems: false,

  // Android specific
  shouldCloseOnBackButtonPressed: true,
)
```

### InAppWebViewSettings

All WebView settings are available:

```dart
InAppWebViewSettings(
  javaScriptEnabled: true,
  safeBrowsingEnabled: true,
  mediaPlaybackRequiresUserGesture: false,
  userAgent: 'Custom User Agent',
  supportZoom: true,
  // ... all InAppWebView settings
)
```

## Custom Menu Items

Add custom buttons to the browser toolbar.

**Supported Platforms:** Android, iOS 14.0+

```dart
final browser = MyInAppBrowser();

// Add menu items before opening
await browser.addMenuItem(
  InAppBrowserMenuItem(
    id: 1,
    title: 'Share',
    icon: UIImage(systemName: 'square.and.arrow.up'), // iOS
    // or
    icon: AndroidResource.mipmap('ic_launcher'), // Android
    order: 1,
    onClick: () {
      print('Share clicked!');
      // Implement sharing logic
    },
  ),
);

await browser.addMenuItem(
  InAppBrowserMenuItem(
    id: 2,
    title: 'Refresh',
    order: 2,
    onClick: () async {
      await browser.webViewController?.reload();
    },
  ),
);

// Hide default menu items
await browser.openUrlRequest(
  urlRequest: URLRequest(url: WebUri('https://flutter.dev')),
  settings: InAppBrowserClassSettings(
    browserSettings: InAppBrowserSettings(
      hideDefaultMenuItems: true, // Hide default items
    ),
  ),
);
```

### Menu Item Properties

```dart
InAppBrowserMenuItem(
  id: 1,                    // Required: Unique identifier
  title: 'My Action',       // Required: Display text
  icon: UIImage(...),       // Optional: Custom icon
  iconColor: Colors.blue,   // Optional: Icon color
  order: 1,                 // Optional: Display order
  showAsAction: true,       // Optional: Show in toolbar (Android)
  onClick: () {             // Required: Click handler
    // Handle click
  },
)
```

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

class BrowserExample extends StatefulWidget {
  @override
  _BrowserExampleState createState() => _BrowserExampleState();
}

class _BrowserExampleState extends State<BrowserExample> {
  final MyInAppBrowser browser = MyInAppBrowser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InAppBrowser Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Open Browser'),
              onPressed: () async {
                await browser.openUrlRequest(
                  urlRequest: URLRequest(
                    url: WebUri('https://flutter.dev'),
                  ),
                  settings: InAppBrowserClassSettings(
                    browserSettings: InAppBrowserSettings(
                      hideUrlBar: false,
                      toolbarTopBackgroundColor: Colors.blue,
                    ),
                    webViewSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      safeBrowsingEnabled: true,
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: Text('Open with Custom Menu'),
              onPressed: () async {
                // Add menu items
                await browser.addMenuItem(
                  InAppBrowserMenuItem(
                    id: 1,
                    title: 'Share',
                    order: 1,
                    onClick: () {
                      print('Share clicked');
                    },
                  ),
                );

                await browser.openUrlRequest(
                  urlRequest: URLRequest(
                    url: WebUri('https://flutter.dev'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyInAppBrowser extends InAppBrowser {
  @override
  Future onBrowserCreated() async {
    print('Browser ready');
  }

  @override
  Future onLoadStart(url) async {
    print('Loading: $url');
  }

  @override
  Future onLoadStop(url) async {
    print('Loaded: $url');

    // Get page title
    String? title = await webViewController?.getTitle();
    print('Title: $title');
  }

  @override
  void onProgressChanged(int progress) {
    print('Progress: $progress%');
  }

  @override
  void onExit() {
    print('Browser closed');
  }

  @override
  void onReceivedError(WebResourceRequest request, WebResourceError error) {
    print('Error: ${error.description}');
  }
}
```

## Lifecycle Events

Override these methods to handle browser events:

| Event | Description |
|-------|-------------|
| `onBrowserCreated()` | Browser is created and ready |
| `onLoadStart(url)` | Page starts loading |
| `onLoadStop(url)` | Page finishes loading |
| `onProgressChanged(progress)` | Loading progress updates |
| `onReceivedError(request, error)` | Error occurred |
| `onReceivedHttpError(request, response)` | HTTP error received |
| `onUpdateVisitedHistory(url, isReload)` | History updated |
| `onTitleChanged(title)` | Page title changed |
| `onExit()` | Browser is closing |

## Controlling the Browser

```dart
// Inside your InAppBrowser class or after getting a reference
class MyInAppBrowser extends InAppBrowser {
  Future<void> customAction() async {
    // Navigation
    await webViewController?.goBack();
    await webViewController?.goForward();
    await webViewController?.reload();
    await webViewController?.stopLoading();

    // Get info
    var url = await webViewController?.getUrl();
    var title = await webViewController?.getTitle();
    var canGoBack = await webViewController?.canGoBack();

    // JavaScript
    await webViewController?.evaluateJavascript(
      source: 'alert("Hello from Dart!");'
    );

    // Close browser
    await close();
  }
}
```

## Comparison: InAppBrowser vs InAppWebView

| Feature | InAppBrowser | InAppWebView Widget |
|---------|--------------|---------------------|
| **Integration** | Full screen overlay | Flutter widget tree |
| **Navigation** | Built-in toolbar | Custom UI needed |
| **Use Case** | External content | Integrated content |
| **Lifecycle** | Independent | Flutter lifecycle |
| **Best For** | Opening external links | Embedded web content |

## Next Steps

- ChromeSafariBrowser (coming soon) - Native browser UI
- [InAppWebView](../webview/in-app-webview) - Widget-based WebView
- [JavaScript Communication](../webview/javascript/communication)
