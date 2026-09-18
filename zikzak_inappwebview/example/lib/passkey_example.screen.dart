import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// Drives the WebAuthn test page from `passkey_demo/index.html`.
///
/// The page reports every step through the injected JS bridge (`passkeyEvent`),
/// so the Flutter side shows the same verdict the page shows — which matters on
/// macOS, where the OS refuses the ceremony before any sheet appears and the
/// only signal is the DOMException the page catches.
///
/// Point it at a tunnel origin for a real ceremony:
///   flutter run -d macos --dart-define=PASSKEY_URL=https://<host>/
class PasskeyExampleScreen extends StatefulWidget {
  const PasskeyExampleScreen({super.key});

  static const defaultUrl = String.fromEnvironment(
    'PASSKEY_URL',
    defaultValue: 'http://localhost:8080/',
  );

  @override
  State<PasskeyExampleScreen> createState() => _PasskeyExampleScreenState();
}

class _PasskeyExampleScreenState extends State<PasskeyExampleScreen> {
  InAppWebViewController? _controller;
  late final TextEditingController _urlController = TextEditingController(
    text: PasskeyExampleScreen.defaultUrl,
  );

  final List<_Event> _events = [];
  String? _verdict;
  bool _verdictOk = false;
  double _progress = 0;

  InAppWebViewSettings get _settings => InAppWebViewSettings(
    javaScriptEnabled: true,
    domStorageEnabled: true,
    // Inert on Apple platforms: WebAuthn there is gated by the host app's
    // `webcredentials:` associated domain, not by a web-view setting. Kept so
    // the same screen exercises the Android `WebSettingsCompat` path.
    webAuthenticationSupport: WebAuthenticationSupport.FOR_APP,
  );

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _add(String level, String message) {
    setState(() {
      _events.insert(0, _Event(level, message));
      if (_events.length > 200) _events.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passkey Test')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      labelText: 'URL',
                    ),
                    onSubmitted: (_) => _load(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _load, child: const Text('Load')),
              ],
            ),
          ),
          if (_progress < 1)
            LinearProgressIndicator(value: _progress == 0 ? null : _progress),
          if (_verdict != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _verdictOk
                    ? Colors.green.withValues(alpha: 0.15)
                    : Colors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _verdict!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _verdictOk ? Colors.green.shade800 : Colors.red.shade800,
                ),
              ),
            ),
          Expanded(
            flex: 3,
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(PasskeyExampleScreen.defaultUrl),
              ),
              initialSettings: _settings,
              onWebViewCreated: (controller) {
                _controller = controller;
                controller.addJavaScriptHandler(
                  handlerName: 'passkeyEvent',
                  callback: (arguments) {
                    final payload = arguments.isNotEmpty ? arguments.first : null;
                    if (payload is Map) {
                      final level = '${payload['level'] ?? 'INFO'}';
                      final msg = '${payload['msg'] ?? ''}';
                      _add(level, msg);
                      _applyVerdict(level, msg);
                    }
                    return null;
                  },
                );
              },
              onLoadStart: (controller, url) {
                setState(() => _progress = 0);
                _add('INFO', 'load start: $url');
              },
              onLoadStop: (controller, url) async {
                setState(() => _progress = 1);
                _add('INFO', 'load stop: $url');
              },
              onProgressChanged: (controller, progress) {
                setState(() => _progress = progress / 100);
              },
              onConsoleMessage: (controller, consoleMessage) {
                debugPrint('Console: ${consoleMessage.message}');
                _add('CONSOLE', consoleMessage.message ?? '');
              },
              onReceivedError: (controller, request, error) {
                _add('ERROR', '${request.url}: ${error.description}');
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 2,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '${event.level}  ${event.message}',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: switch (event.level) {
                        'ERROR' => Colors.red.shade700,
                        'OK' => Colors.green.shade700,
                        'WARN' => Colors.orange.shade800,
                        _ => null,
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _applyVerdict(String level, String message) {
    if (level == 'OK' && message.contains('get() resolved')) {
      setState(() {
        _verdict = 'Signed in with passkey.';
        _verdictOk = true;
      });
    } else if (level == 'OK' && message.contains('create() resolved')) {
      setState(() {
        _verdict = 'Passkey created — now sign in.';
        _verdictOk = true;
      });
    } else if (level == 'ERROR') {
      setState(() {
        _verdict = message;
        _verdictOk = false;
      });
    }
  }

  Future<void> _load() async {
    final url = _urlController.text.trim();
    setState(() {
      _events.clear();
      _verdict = null;
    });
    await _controller?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
  }
}

class _Event {
  _Event(this.level, this.message);

  final String level;
  final String message;
}
