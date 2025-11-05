import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:logging/logging.dart';

import 'main.dart';

/// Example screen demonstrating WebAuthenticationSession for OAuth flows.
///
/// NOTE: This example uses a placeholder OAuth URL (example.com) which will not work.
/// To test this feature, replace the URL with a real OAuth provider like:
/// - GitHub: https://github.com/login/oauth/authorize?client_id=YOUR_ID
/// - Google: https://accounts.google.com/o/oauth2/auth?client_id=YOUR_ID
/// - Any other OAuth 2.0 provider
///
/// You'll also need to:
/// 1. Register your app with the OAuth provider
/// 2. Configure the callback URL scheme in your Info.plist (iOS) or AndroidManifest.xml
/// 3. Update the callbackURLScheme parameter to match your registered scheme
class WebAuthenticationSessionExampleScreen extends StatefulWidget {
  const WebAuthenticationSessionExampleScreen({super.key});

  @override
  WebAuthenticationSessionExampleScreenState createState() =>
      WebAuthenticationSessionExampleScreenState();
}

class WebAuthenticationSessionExampleScreenState
    extends State<WebAuthenticationSessionExampleScreen> {
  WebAuthenticationSession? session;
  String? token;
  final _logger = Logger('WebAuthenticationSessionExampleScreen');

  @override
  void dispose() {
    session?.dispose();
    super.dispose();
  }

  Future<void> _createWebAuthSession() async {
    if (session != null ||
        kIsWeb ||
        ![TargetPlatform.iOS, TargetPlatform.macOS]
            .contains(defaultTargetPlatform) ||
        !await WebAuthenticationSession.isAvailable()) {
      _logger.warning('Cannot create Web Authentication Session');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Cannot create Web Authentication Session!'),
        ));
      }
      return;
    }

    try {
      // Example OAuth flow using a mock service
      // In production, replace with your actual OAuth provider URL
      // For example: GitHub OAuth would be:
      // "https://github.com/login/oauth/authorize?client_id=YOUR_CLIENT_ID&redirect_uri=your-app://callback"
      session = await WebAuthenticationSession.create(
          url: WebUri(
              "https://example.com/oauth/authorize?response_type=token&client_id=demo&redirect_uri=myapp://callback"),
          callbackURLScheme: "myapp",
          onComplete: (url, error) {
            if (url != null) {
              setState(() {
                // Parse token from URL fragment or query parameters
                // OAuth 2.0 implicit flow typically uses fragment (#token=...)
                token = url.fragment.contains('token=')
                    ? Uri.parse('?${url.fragment}').queryParameters["token"]
                    : url.queryParameters["token"];
              });
              _logger.info('Received callback URL: $url');
            } else if (error != null) {
              _logger.warning('Web Authentication error: $error');
            }
            return Future<
                void>.value(); // Add this line to return a Future<void>
          });
      setState(() {});
    } catch (e) {
      _logger.severe('Error creating Web Authentication Session: $e');
    }
  }

  Future<void> _startWebAuthSession() async {
    try {
      if (await session?.canStart() ?? false) {
        final started = await session?.start() ?? false;
        if (!started) {
          _logger.warning('Cannot start Web Authentication Session');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Cannot start Web Authentication Session!'),
            ));
          }
        } else {
          _logger.info('Web Authentication Session started successfully');
        }
      } else {
        _logger.warning('Session cannot start');
      }
    } catch (e) {
      _logger.severe('Error starting Web Authentication Session: $e');
    }
  }

  void _disposeWebAuthSession() {
    try {
      session?.dispose();
      setState(() {
        token = null;
        session = null;
      });
      _logger.info('Web Authentication Session disposed');
    } catch (e) {
      _logger.severe('Error disposing Web Authentication Session: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          "WebAuthenticationSession",
        )),
        drawer: myDrawer(context: context),
        body: SafeArea(
          child: Column(children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ℹ️ Demo Configuration Required',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This example uses a placeholder OAuth URL. To test:\n'
                    '1. Replace the URL with a real OAuth provider\n'
                    '2. Configure your app callback scheme\n'
                    '3. Register your app with the OAuth provider',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Center(
                child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Token: ${token ?? 'null (demo URL - see note above)'}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
            if (session == null)
              Center(
                child: ElevatedButton(
                    onPressed: _createWebAuthSession,
                    child: const Text("Create Web Auth Session")),
              )
            else ...[
              Center(
                child: ElevatedButton(
                    onPressed: _startWebAuthSession,
                    child: const Text("Start Web Auth Session")),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: _disposeWebAuthSession,
                    child: const Text("Dispose Web Auth Session")),
              )
            ],
          ]),
        ));
  }
}
