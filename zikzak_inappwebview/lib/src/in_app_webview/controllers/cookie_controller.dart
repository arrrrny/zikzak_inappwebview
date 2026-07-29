import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../../cookie_manager.dart';
import '../in_app_webview_controller.dart';

///Domain-specific facade of [InAppWebViewController] for cookie management
///scoped to this WebView.
///
///Part of the domain controller split (issue #161, P3). Wraps the shared
///[CookieManager] so cookie operations default to the WebView's current URL
///and pass this controller as context — while still allowing explicit URLs
///and global operations.
class CookieController {
  final InAppWebViewController _controller;
  final CookieManager? _cookieManagerOverride;
  CookieManager? _cookieManager;

  ///Creates a [CookieController] bound to the given controller.
  CookieController(this._controller, {CookieManager? cookieManager})
    : _cookieManagerOverride = cookieManager;

  CookieManager get _cookies =>
      _cookieManager ??= _cookieManagerOverride ?? CookieManager.instance();

  Future<WebUri?> _resolveUrl(WebUri? url) async =>
      url ?? await _controller.getUrl();

  ///Gets the cookies for [url], or for the WebView's current URL when
  ///[url] is omitted. Returns an empty list when no URL is available.
  Future<List<Cookie>> getCookies({WebUri? url}) async {
    final resolved = await _resolveUrl(url);
    if (resolved == null) {
      return [];
    }
    return _cookies.getCookies(url: resolved, webViewController: _controller);
  }

  ///Gets the cookie named [name] for [url], or for the WebView's current
  ///URL when [url] is omitted.
  Future<Cookie?> getCookie({required String name, WebUri? url}) async {
    final resolved = await _resolveUrl(url);
    if (resolved == null) {
      return null;
    }
    return _cookies.getCookie(
      url: resolved,
      name: name,
      webViewController: _controller,
    );
  }

  ///Sets a cookie for [url], or for the WebView's current URL when [url]
  ///is omitted. Returns `false` when no URL is available.
  Future<bool> setCookie({
    required String name,
    required String value,
    WebUri? url,
    String path = "/",
    String? domain,
    int? expiresDate,
    int? maxAge,
    bool? isSecure,
    bool? isHttpOnly,
    HTTPCookieSameSitePolicy? sameSite,
  }) async {
    final resolved = await _resolveUrl(url);
    if (resolved == null) {
      return false;
    }
    return _cookies.setCookie(
      url: resolved,
      name: name,
      value: value,
      path: path,
      domain: domain,
      expiresDate: expiresDate,
      maxAge: maxAge,
      isSecure: isSecure,
      isHttpOnly: isHttpOnly,
      sameSite: sameSite,
      webViewController: _controller,
    );
  }

  ///Deletes the cookie named [name] for [url], or for the WebView's
  ///current URL when [url] is omitted.
  Future<bool> deleteCookie({
    required String name,
    WebUri? url,
    String path = "/",
    String? domain,
  }) async {
    final resolved = await _resolveUrl(url);
    if (resolved == null) {
      return false;
    }
    return _cookies.deleteCookie(
      url: resolved,
      name: name,
      path: path,
      domain: domain,
      webViewController: _controller,
    );
  }

  ///Deletes all cookies for [url], or for the WebView's current URL when
  ///[url] is omitted.
  Future<bool> deleteCookies({
    WebUri? url,
    String path = "/",
    String? domain,
  }) async {
    final resolved = await _resolveUrl(url);
    if (resolved == null) {
      return false;
    }
    return _cookies.deleteCookies(
      url: resolved,
      path: path,
      domain: domain,
      webViewController: _controller,
    );
  }

  ///Gets every cookie in the cookie store.
  Future<List<Cookie>> getAllCookies() => _cookies.getAllCookies();

  ///Deletes every cookie in the cookie store.
  Future<bool> deleteAllCookies() => _cookies.deleteAllCookies();

  ///Removes all session cookies.
  Future<bool> removeSessionCookies() => _cookies.removeSessionCookies();
}
