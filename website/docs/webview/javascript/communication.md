---
sidebar_position: 2
title: JavaScript Communication
---

# JavaScript Communication

ZikZak InAppWebView provides three powerful methods for bidirectional communication between Dart and JavaScript.

## 1. JavaScript Handlers (Recommended)

The simplest and most commonly used method for Dart ↔ JavaScript communication.

### Dart Side: Register Handler

```dart
InAppWebView(
  onWebViewCreated: (controller) {
    // Register a handler that JavaScript can call
    controller.addJavaScriptHandler(
      handlerName: 'myHandler',
      callback: (args) {
        // args is a List containing the arguments passed from JavaScript
        print('Received from JS: $args');

        // Return data back to JavaScript
        return {
          'status': 'success',
          'message': 'Received: ${args[0]}',
          'timestamp': DateTime.now().toIso8601String(),
        };
      },
    );

    // Register multiple handlers
    controller.addJavaScriptHandler(
      handlerName: 'getUserData',
      callback: (args) async {
        // Can be async
        var userData = await fetchUserData();
        return userData;
      },
    );
  },
  onLoadStop: (controller, url) async {
    // JavaScript can now call these handlers
  },
)
```

### JavaScript Side: Call Handler

```javascript
// Call the Dart handler from JavaScript
window.flutter_inappwebview
  .callHandler('myHandler', 'Hello from JavaScript', 123, true)
  .then(function(result) {
    console.log('Response from Dart:', result);
    // result = { status: 'success', message: '...', timestamp: '...' }
  });

// Using async/await
async function callDart() {
  try {
    const result = await window.flutter_inappwebview.callHandler('getUserData');
    console.log('User data:', result);
  } catch (error) {
    console.error('Error calling Dart:', error);
  }
}
```

### Platform Readiness (Android)

:::warning Android Compatibility
For older Android WebViews, wait for the platform to be ready before calling handlers:
:::

```javascript
window.addEventListener('flutterInAppWebViewPlatformReady', function(event) {
  // Now it's safe to call handlers
  window.flutter_inappwebview.callHandler('myHandler', 'data');
});
```

### Security Features (v3.0+)

Control handler access with security settings:

```dart
InAppWebView(
  initialSettings: InAppWebViewSettings(
    // Restrict handlers to main frame only
    javaScriptHandlersForMainFrameOnly: true,

    // Allowlist specific origins (regex patterns)
    javaScriptBridgeOriginAllowList: [
      'https://trusted-domain\\.com',
      'https://.*\\.example\\.com',
    ],
  ),
  onWebViewCreated: (controller) {
    controller.addJavaScriptHandler(
      handlerName: 'secureHandler',
      callback: (args) {
        // Validate the call origin
        if (args.isNotEmpty && args.last is JavaScriptHandlerFunctionData) {
          var data = args.last as JavaScriptHandlerFunctionData;
          print('Called from: ${data.origin}');
          print('Frame URL: ${data.frameUrl}');

          // Additional security checks
          if (!isTrustedOrigin(data.origin)) {
            return {'error': 'Unauthorized'};
          }
        }

        return {'status': 'success'};
      },
    );
  },
)
```

## 2. Web Message Channels

HTML5 message channels with paired ports for structured communication.

**Supported Platforms:** Android, iOS

### Creating a Channel

```dart
onLoadStop: (controller, url) async {
  // Create a message channel
  var webMessageChannel = await controller.createWebMessageChannel();
  var port1 = webMessageChannel!.port1;
  var port2 = webMessageChannel.port2;

  // Set up Dart-side message listener
  await port1.setWebMessageCallback((message) async {
    print('Received from JS: $message');

    // Send response back
    await port1.postMessage(WebMessage(
      data: 'Response from Dart: ${DateTime.now()}',
    ));
  });

  // Transfer port2 to JavaScript
  await controller.postWebMessage(
    message: WebMessage(
      data: 'Port ready',
      ports: [port2],
    ),
    targetOrigin: WebUri('*'),
  );
},
```

### JavaScript Side

```javascript
window.addEventListener('message', function(event) {
  if (event.ports && event.ports.length > 0) {
    // Capture the port
    var port = event.ports[0];

    // Set up JavaScript-side listener
    port.onmessage = function(e) {
      console.log('Message from Dart:', e.data);
    };

    // Send message to Dart
    port.postMessage('Hello from JavaScript!');
  }
});
```

:::warning Port Lifecycle
- Ports become "neutered" when transferred and cannot be reused
- Cannot transfer ports after setting callbacks or posting messages
:::

## 3. Web Message Listeners

Inject JavaScript objects that listen for messages across frame boundaries.

**Supported Platforms:** Android, iOS

### Register a Listener

```dart
onWebViewCreated: (controller) async {
  // Register listener BEFORE page loads
  await controller.addWebMessageListener(
    WebMessageListener(
      jsObjectName: 'myApp',
      allowedOriginRules: [
        'https://example.com',
        'https://*.trusted-site.com',
        '*', // Allow all origins (use carefully!)
      ],
      onPostMessage: (message, sourceOrigin, isMainFrame, replyProxy) {
        print('Message: ${message?.data}');
        print('From: $sourceOrigin');
        print('Main frame: $isMainFrame');

        // Reply to JavaScript
        replyProxy.postMessage('Response from Dart');
      },
    ),
  );
},
```

### JavaScript Side

```javascript
// The 'myApp' object is automatically injected
myApp.postMessage('Hello Dart!');

// Listen for responses
myApp.addEventListener('message', function(event) {
  console.log('Reply from Dart:', event.data);
});

// Alternative syntax
myApp.onmessage = function(event) {
  console.log('Reply:', event.data);
};
```

### Origin Rules Format

```dart
allowedOriginRules: [
  'https://hostname.com',          // Exact domain
  'https://*.example.com',         // Wildcard subdomains
  'https://192.168.1.1',           // IP addresses (including IPv6)
  'my-app-scheme://',              // Custom schemes
  '*',                              // All origins (use cautiously!)
]
```

## Comparison Table

| Feature | JavaScript Handlers | Web Message Channels | Web Message Listeners |
|---------|---------------------|----------------------|-----------------------|
| **Ease of Use** | ⭐⭐⭐ Simple | ⭐⭐ Moderate | ⭐⭐ Moderate |
| **Bidirectional** | ✅ Yes | ✅ Yes | ✅ Yes |
| **Frame Support** | Main frame (configurable) | All frames | Configurable |
| **Origin Control** | ✅ v3.0+ | Limited | ✅ Yes |
| **Setup Timing** | Anytime | After page load | Before page load |
| **Best For** | Simple calls | Streaming data | Cross-frame communication |

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

class CommunicationExample extends StatefulWidget {
  @override
  _CommunicationExampleState createState() => _CommunicationExampleState();
}

class _CommunicationExampleState extends State<CommunicationExample> {
  InAppWebViewController? webViewController;
  String receivedMessage = 'No messages yet';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('JS Communication')),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Text('Received: $receivedMessage'),
          ),
          Expanded(
            child: InAppWebView(
              initialData: InAppWebViewInitialData(data: '''
                <!DOCTYPE html>
                <html>
                <body>
                  <h1>JavaScript Communication</h1>
                  <button onclick="sendToDart()">Send to Dart</button>
                  <button onclick="requestData()">Request Data</button>
                  <div id="result"></div>

                  <script>
                    function sendToDart() {
                      window.flutter_inappwebview
                        .callHandler('messageHandler', 'Hello from JS!')
                        .then(result => {
                          document.getElementById('result').innerText =
                            'Dart says: ' + result.message;
                        });
                    }

                    function requestData() {
                      window.flutter_inappwebview
                        .callHandler('getDataHandler')
                        .then(data => {
                          document.getElementById('result').innerText =
                            'Data: ' + JSON.stringify(data);
                        });
                    }
                  </script>
                </body>
                </html>
              '''),
              onWebViewCreated: (controller) {
                webViewController = controller;

                // Register handlers
                controller.addJavaScriptHandler(
                  handlerName: 'messageHandler',
                  callback: (args) {
                    setState(() {
                      receivedMessage = args[0];
                    });
                    return {
                      'status': 'received',
                      'message': 'Got your message: ${args[0]}',
                    };
                  },
                );

                controller.addJavaScriptHandler(
                  handlerName: 'getDataHandler',
                  callback: (args) {
                    return {
                      'timestamp': DateTime.now().toIso8601String(),
                      'platform': 'Flutter',
                      'version': '3.0.0',
                    };
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () {
          // Send message from Dart to JavaScript
          webViewController?.evaluateJavascript(source: '''
            document.getElementById('result').innerText = 'Message from Dart!';
          ''');
        },
      ),
    );
  }
}
```

## Best Practices

1. **Use JavaScript Handlers for most cases** - They're simple and work great
2. **Validate origins** - Use allowlists in production
3. **Handle errors** - JavaScript might call handlers with invalid data
4. **Avoid sensitive data** - Don't pass secrets through the bridge
5. **Test thoroughly** - Different platforms may behave differently

## Next Steps

- User Scripts (coming soon) - Pre-inject JavaScript code
- Content Worlds (coming soon) - Isolated execution environments
- [JavaScript Injection](./injection) - Different ways to inject JS
