import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview_linux/zikzak_inappwebview_linux.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LinuxInAppWebViewPlatform.registerWith();
  runApp(const MaterialApp(home: _Home()));
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('zikzak Linux example')),
        body: Center(
          child: FilledButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const _ManualTestPage()),
            ),
            child: const Text('Open manual test page'),
          ),
        ),
      );
}

/// Popping this route disposes the webview (README manual check 10).
class _ManualTestPage extends StatefulWidget {
  const _ManualTestPage();

  @override
  State<_ManualTestPage> createState() => _ManualTestPageState();
}

class _ManualTestPageState extends State<_ManualTestPage> {
  PlatformInAppWebViewController? _controller;
  final _cookies = LinuxCookieManager(const LinuxCookieManagerCreationParams());

  Future<void> _clearCookiesAndReload() async {
    await _cookies.deleteAllCookies();
    await _controller?.reload();
  }

  static final _exampleUrl = WebUri('https://example.com/');

  void _say(String text) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(text), duration: const Duration(seconds: 8)));

  /// Sets a cookie for an https URL, then reads it back (README manual check 12).
  Future<void> _setAndReadCookie() async {
    final ok = await _cookies.setCookie(
      url: _exampleUrl,
      name: 'zz_check',
      value: 'hello',
      sameSite: HTTPCookieSameSitePolicy.LAX,
    );
    await _showCookies('setCookie returned $ok');
  }

  Future<void> _showCookies([String prefix = 'getCookies']) async {
    final cookies = await _cookies.getCookies(url: _exampleUrl);
    if (!mounted) return;
    final text = cookies.isEmpty
        ? 'empty'
        : cookies
            .map((c) => '${c.name}=${c.value} sameSite=${httpCookieSameSitePolicyToWire(c.sameSite)}')
            .join('; ');
    _say('$prefix: $text');
  }

  Future<void> _deleteAllAndRead() async {
    await _cookies.deleteAllCookies();
    await _showCookies('after deleteAllCookies');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Manual test'),
          actions: [
            IconButton(
              tooltip: 'Set zz_check cookie for example.com and read it',
              icon: const Icon(Icons.add_circle_outline),
              onPressed: _setAndReadCookie,
            ),
            IconButton(
              tooltip: 'Read cookies for example.com',
              icon: const Icon(Icons.visibility),
              onPressed: _showCookies,
            ),
            IconButton(
              tooltip: 'Delete all cookies, then read',
              icon: const Icon(Icons.delete_sweep),
              onPressed: _deleteAllAndRead,
            ),
            IconButton(
              tooltip: 'Load example.com',
              icon: const Icon(Icons.public),
              onPressed: () => _controller?.loadUrl(
                  urlRequest: URLRequest(url: _exampleUrl)),
            ),
            IconButton(
              tooltip: 'Flutter dialog over the page',
              icon: const Icon(Icons.layers),
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => const AlertDialog(content: Text('Drawn by Flutter over the page')),
              ),
            ),
            IconButton(
              tooltip: 'Delete all cookies and reload',
              icon: const Icon(Icons.cookie),
              onPressed: _clearCookiesAndReload,
            ),
          ],
        ),
        body: LinuxInAppWebViewWidget(
          LinuxInAppWebViewWidgetCreationParams(
            initialFile: 'assets/manual_test.html',
            onWebViewCreated: (controller) => _controller = controller,
          ),
        ).build(context),
      );
}
