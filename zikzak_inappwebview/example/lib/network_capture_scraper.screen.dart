import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

class NetworkCaptureScraperScreen extends StatefulWidget {
  const NetworkCaptureScraperScreen({super.key});

  @override
  State<NetworkCaptureScraperScreen> createState() =>
      _NetworkCaptureScraperScreenState();
}

class _NetworkCaptureScraperScreenState
    extends State<NetworkCaptureScraperScreen> {
  final _urlController = TextEditingController(
    text:
        'https://www.ulta.com/p/lash-sensational-sky-high-mascara-pimprod2020260?sku=2574523',
  );
  final _filterController = TextEditingController(text: '2574523');

  InAppWebViewController? _webViewController;
  NetworkCaptureController? _captureController;
  final List<_CapturedEntry> _capturedEntries = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  void _navigate() {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return;

    _captureController?.clear();
    _capturedEntries.clear();
    setState(() => _isLoading = true);

    _webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
  }

  void _onNetworkLoadingFinished(
    InAppWebViewController controller,
    NetworkResponseBody body,
  ) {
    final filter = _filterController.text.trim().toLowerCase();
    if (filter.isEmpty) return;

    final bodyLower = body.body.toLowerCase();
    if (!bodyLower.contains(filter)) return;

    final entry = _CapturedEntry(
      url: body.url.toString(),
      mimeType: body.mimeType ?? '',
      statusCode: 0, // populated from response callback
      size: body.size,
      truncated: body.truncated,
      body: body.body.length > 2000 ? body.body.substring(0, 2000) : body.body,
    );

    setState(() => _capturedEntries.add(entry));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network Capture Scraper')),
      body: Column(
        children: [
          // URL bar
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      labelText: 'URL',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 13),
                    onSubmitted: (_) => _navigate(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _navigate, child: const Text('Go')),
              ],
            ),
          ),
          // Filter bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _filterController,
                    decoration: InputDecoration(
                      labelText: 'Filter response bodies containing...',
                      border: const OutlineInputBorder(),
                      isDense: true,
                      suffix: Text('${_capturedEntries.length} matches'),
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          // WebView
          Expanded(
            flex: 3,
            child: InAppWebView(
              initialSettings: InAppWebViewSettings(
                useNetworkCapture: true,
                networkCaptureMaxBodySize: 100000,
              ),
              initialUrlRequest: URLRequest(url: WebUri(_urlController.text)),
              onWebViewCreated: (controller) {
                _webViewController = controller;
                // Auto-navigate on first load
                _navigate();
              },
              onLoadStop: (controller, url) {
                setState(() => _isLoading = false);
              },
              onNetworkLoadingFinished: _onNetworkLoadingFinished,
            ),
          ),
          const Divider(height: 1),
          // Captured entries
          Expanded(
            flex: 2,
            child: _capturedEntries.isEmpty
                ? const Center(
                    child: Text(
                      'No matching responses yet.\nLoad a page and responses matching the filter will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _capturedEntries.length,
                    itemBuilder: (context, index) {
                      final entry = _capturedEntries[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ExpansionTile(
                          title: Text(
                            entry.url,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                          subtitle: Text(
                            '${entry.mimeType} • ${entry.size} chars ${entry.truncated ? "(truncated)" : ""}',
                            style: const TextStyle(fontSize: 11),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: SelectableText(
                                entry.body,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CapturedEntry {
  final String url;
  final String mimeType;
  final int statusCode;
  final int size;
  final bool truncated;
  final String body;

  _CapturedEntry({
    required this.url,
    required this.mimeType,
    required this.statusCode,
    required this.size,
    required this.truncated,
    required this.body,
  });
}
