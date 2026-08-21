import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../in_app_webview_controller.dart';
import '../../cookie_manager.dart';

/// iOS implementation of [PlatformCookieDelegate].
///
/// Forwards every call to the shared [IOSCookieManager] singleton,
/// passing the parent [IOSInAppWebViewController] as `webViewController`
/// so per-WebView session cookies are honored. Global operations
/// ([getAllCookies], [deleteAllCookies], [removeSessionCookies]) do not
/// require the controller and are forwarded directly. Part of the
/// domain-controller split (issue #229, P3).
class IOSCookieDelegate extends PlatformCookieDelegate {
  /// Creates a new [IOSCookieDelegate] bound to [_controller].
  IOSCookieDelegate(this._controller) : super(token: _token);

  static final Object _token = Object();

  final IOSInAppWebViewController _controller;

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
  }) => IOSCookieManager.instance().setCookie(
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
      IOSCookieManager.instance().getCookies(
        url: url,
        webViewController: _controller,
      );

  @override
  Future<Cookie?> getCookie({required WebUri url, required String name}) =>
      IOSCookieManager.instance().getCookie(
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
  }) => IOSCookieManager.instance().deleteCookie(
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
  }) => IOSCookieManager.instance().deleteCookies(
    url: url,
    path: path,
    domain: domain,
    webViewController: _controller,
  );

  @override
  Future<List<Cookie>> getAllCookies() =>
      IOSCookieManager.instance().getAllCookies();

  @override
  Future<bool> deleteAllCookies() =>
      IOSCookieManager.instance().deleteAllCookies();

  @override
  Future<bool> removeSessionCookies() =>
      IOSCookieManager.instance().removeSessionCookies();
}
