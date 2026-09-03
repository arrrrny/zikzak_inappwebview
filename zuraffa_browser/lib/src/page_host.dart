import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// Host port for a page's underlying webview (spec 279, FR-012).
///
/// Implemented by [HeadlessPageHost] in production; tests substitute fakes.
abstract class PageHost {
  /// Loads [uri] in the underlying webview.
  Future<void> loadUrl(WebUri uri);

  /// Closes and releases the underlying webview.
  Future<void> close();
}

/// Default production [PageHost]: a headless zikzak_inappwebview instance.
///
/// When [persistentStoreId] is provided it is forwarded as
/// [InAppWebViewSettings.persistentStoreIdentifier], so pages of a profile
/// share that profile's persistent store (profile-scoped, not page-scoped).
class HeadlessPageHost implements PageHost {
  final HeadlessInAppWebView _webview;
  var _running = false;

  /// Creates a headless page host.
  HeadlessPageHost({InAppWebViewSettings? settings})
    : _webview = HeadlessInAppWebView(initialSettings: settings);

  @override
  Future<void> loadUrl(WebUri uri) async {
    if (!_running) {
      await _webview.run();
      _running = true;
    }
    await _webview.webViewController?.loadUrl(urlRequest: URLRequest(url: uri));
  }

  @override
  Future<void> close() async {
    if (_running) {
      await _webview.dispose();
      _running = false;
    }
  }
}
