import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../in_app_webview_controller.dart';
import '../../cookie_manager.dart';

/// Android implementation of [PlatformCookieDelegate].
///
/// Forwards every call to the shared [AndroidCookieManager] singleton,
/// passing the parent [AndroidInAppWebViewController] as
/// `webViewController` so per-WebView session cookies are honored.
/// Global operations ([getAllCookies], [deleteAllCookies],
/// [removeSessionCookies]) do not require the controller and are forwarded
/// directly. Part of the domain-controller split (issue #229, P3).
class AndroidCookieDelegate extends PlatformCookieDelegate {
  /// Creates a new [AndroidCookieDelegate] bound to [_controller].
  AndroidCookieDelegate(this._controller) : super(token: _token);

  static final Object _token = Object();

  final AndroidInAppWebViewController _controller;

  @override
  Future<bool> setCookie({
    required WebUri url,
    required String name,
    required String value,
    String path = "/",
    String? domain,
    int? expiresDate,
    int? maxAge,
    bool? isSecure,
    bool? isHttpOnly,
    HTTPCookieSameSitePolicy? sameSite,
  }) => AndroidCookieManager.instance().setCookie(
    url: url,
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

  @override
  Future<List<Cookie>> getCookies({required WebUri url}) =>
      AndroidCookieManager.instance().getCookies(
        url: url,
        webViewController: _controller,
      );

  @override
  Future<Cookie?> getCookie({required WebUri url, required String name}) =>
      AndroidCookieManager.instance().getCookie(
        url: url,
        name: name,
        webViewController: _controller,
      );

  @override
  Future<bool> deleteCookie({
    required WebUri url,
    required String name,
    String path = "/",
    String? domain,
  }) => AndroidCookieManager.instance().deleteCookie(
    url: url,
    name: name,
    path: path,
    domain: domain,
    webViewController: _controller,
  );

  @override
  Future<bool> deleteCookies({
    required WebUri url,
    String path = "/",
    String? domain,
  }) => AndroidCookieManager.instance().deleteCookies(
    url: url,
    path: path,
    domain: domain,
    webViewController: _controller,
  );

  @override
  Future<List<Cookie>> getAllCookies() =>
      AndroidCookieManager.instance().getAllCookies();

  @override
  Future<bool> deleteAllCookies() =>
      AndroidCookieManager.instance().deleteAllCookies();

  @override
  Future<bool> removeSessionCookies() =>
      AndroidCookieManager.instance().removeSessionCookies();
}
