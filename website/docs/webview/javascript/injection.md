---
sidebar_position: 1
title: JavaScript Injection
---

# JavaScript Injection

ZikZak InAppWebView provides multiple methods for injecting JavaScript code into your WebView.

## Four Primary Injection Methods

### 1. evaluateJavascript

Evaluates JavaScript code and returns the result.

**Supported Platforms:** Android, iOS

```dart
onLoadStop: (controller, url) async {
  var result = await controller.evaluateJavascript(
    source: "document.title"
  );
  print('Page title: $result');

  // Execute complex JavaScript
  var json = await controller.evaluateJavascript(source: """
    JSON.stringify({
      title: document.title,
      url: window.location.href,
      userAgent: navigator.userAgent
    })
  """);
},
```

:::note
Returns `dynamic` type - handles JSON-serializable values (integers, strings, booleans, objects).
:::

### 2. callAsyncJavaScript

Executes asynchronous JavaScript functions with parameters.

**Supported Platforms:** Android, iOS

```dart
onLoadStop: (controller, url) async {
  var result = await controller.callAsyncJavaScript(
    functionBody: """
      var response = await fetch(arguments[0]);
      return await response.text();
    """,
    arguments: {'url': 'https://api.example.com/data'}
  );

  if (result != null && result.value != null) {
    print('Response: ${result.value}');
  }
  if (result != null && result.error != null) {
    print('Error: ${result.error}');
  }
},
```

Returns `CallAsyncJavaScriptResult` containing:
- `value`: The successful result
- `error`: Any error that occurred

### 3. injectJavascriptFileFromUrl

Loads external JavaScript files via URL.

**Supported Platforms:** Android, iOS

```dart
await controller.injectJavascriptFileFromUrl(
  urlFile: WebUri('https://code.jquery.com/jquery-3.6.0.min.js'),
  scriptHtmlTagAttributes: ScriptHtmlTagAttributes(
    id: 'jquery-script',
    onLoad: () {
      print('jQuery loaded successfully');
    },
    onError: () {
      print('Failed to load jQuery');
    },
  ),
);
```

:::tip
Requires `ScriptHtmlTagAttributes.id` to be set for callbacks to work.
:::

### 4. injectJavascriptFileFromAsset

Loads JavaScript files from Flutter asset folders.

**Supported Platforms:** Android, iOS

```dart
await controller.injectJavascriptFileFromAsset(
  assetFilePath: 'assets/js/custom-script.js'
);
```

:::note
This evaluates the asset file contents directly rather than creating a script tag.
:::

## Critical Timing Consideration

:::danger IMPORTANT
**Do NOT call injection methods during `onWebViewCreated` or `onLoadStart` events** - the WebView is not ready yet!
:::

✅ **Use these methods in:**
- `onLoadStop` event
- `onProgressChanged` when progress == 100
- Other events confirming page readiness

```dart
// ❌ WRONG - Too early!
onWebViewCreated: (controller) async {
  await controller.evaluateJavascript(source: 'alert("Hello")');
},

// ✅ CORRECT - Page is ready
onLoadStop: (controller, url) async {
  await controller.evaluateJavascript(source: 'alert("Hello")');
},
```

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

class JavaScriptInjectionExample extends StatefulWidget {
  @override
  _JavaScriptInjectionExampleState createState() =>
      _JavaScriptInjectionExampleState();
}

class _JavaScriptInjectionExampleState
    extends State<JavaScriptInjectionExample> {

  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JavaScript Injection'),
        actions: [
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: _executeJavaScript,
          ),
        ],
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri('https://flutter.dev'),
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          // Inject jQuery from CDN
          await controller.injectJavascriptFileFromUrl(
            urlFile: WebUri('https://code.jquery.com/jquery-3.6.0.min.js'),
          );

          // Inject custom script from assets
          await controller.injectJavascriptFileFromAsset(
            assetFilePath: 'assets/js/custom.js',
          );
        },
      ),
    );
  }

  Future<void> _executeJavaScript() async {
    if (webViewController != null) {
      // Get page information
      var title = await webViewController!.evaluateJavascript(
        source: 'document.title'
      );

      // Call async function
      var result = await webViewController!.callAsyncJavaScript(
        functionBody: """
          return new Promise((resolve) => {
            setTimeout(() => {
              resolve('Delayed result');
            }, 1000);
          });
        """,
      );

      print('Title: $title');
      print('Async result: ${result?.value}');
    }
  }
}
```

## Asset Configuration

Don't forget to add your JavaScript files to `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/js/custom.js
    - assets/js/helper.js
```

## Next Steps

- [JavaScript Communication](./communication) - Two-way Dart ↔ JavaScript communication
- User Scripts (coming soon) - Inject scripts before page loads
- Content Worlds (coming soon) - Isolated JavaScript execution
