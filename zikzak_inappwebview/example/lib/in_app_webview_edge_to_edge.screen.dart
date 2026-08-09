import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// Example demonstrating the Android `insetsForWebContentToIgnore` setting —
/// the zikzak equivalent of `webview_flutter_android`'s
/// `setInsetsForWebContentToIgnore`.
///
/// When edge-to-edge is enabled, the WebView is told to ignore the system-bars,
/// display-cutout and IME insets so web content renders behind the status bar,
/// navigation bar, cutout and on-screen keyboard instead of being shrunk by
/// them.
///
/// Note: for the insets to actually reach the WebView, the host activity must
/// itself be drawn edge-to-edge (e.g. by calling `enableEdgeToEdge()` on
/// Android 15+ or not opting out of edge-to-edge). This example focuses on the
/// WebView-side API.
class InAppWebViewEdgeToEdgeExampleScreen extends StatefulWidget {
  const InAppWebViewEdgeToEdgeExampleScreen({super.key});

  @override
  State<InAppWebViewEdgeToEdgeExampleScreen> createState() =>
      _InAppWebViewEdgeToEdgeExampleScreenState();
}

class _InAppWebViewEdgeToEdgeExampleScreenState
    extends State<InAppWebViewEdgeToEdgeExampleScreen> {
  final GlobalKey _webViewKey = GlobalKey();
  InAppWebViewController? _webViewController;
  bool _edgeToEdge = true;

  // The insets the WebView should ignore when edge-to-edge is on. These mirror
  // `webview_flutter_android`'s `AndroidWebViewInsets` plus `displayCutout`.
  List<AndroidWebViewInsets> get _ignoredInsets => [
        AndroidWebViewInsets.systemBars,
        AndroidWebViewInsets.displayCutout,
        AndroidWebViewInsets.ime,
      ];

  InAppWebViewSettings get _settings => InAppWebViewSettings(
        javaScriptEnabled: true,
        domStorageEnabled: true,
        // Tell the WebView to render behind the status bar, navigation bar,
        // cutout and IME instead of being inset by them.
        insetsForWebContentToIgnore:
            _edgeToEdge ? _ignoredInsets : const [],
      );

  Future<void> _toggleEdgeToEdge(bool value) async {
    setState(() => _edgeToEdge = value);
    // Apply the change at runtime via setSettings — no rebuild required.
    await _webViewController?.setSettings(settings: _settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edge-to-edge WebView'),
        actions: [
          Switch(
            value: _edgeToEdge,
            onChanged: _toggleEdgeToEdge,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              _edgeToEdge
                  ? 'Edge-to-edge ON: web content renders behind the status '
                      'bar, navigation bar, cutout and IME.'
                  : 'Edge-to-edge OFF: the WebView is inset by the system '
                      'bars / IME (default Android behavior).',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: InAppWebView(
              key: _webViewKey,
              initialUrlRequest:
                  URLRequest(url: WebUri('https://flutter.dev')),
              initialSettings: _settings,
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}
