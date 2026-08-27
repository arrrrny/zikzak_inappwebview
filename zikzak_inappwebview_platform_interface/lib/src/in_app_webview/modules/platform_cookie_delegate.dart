import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../web_uri.dart';
import '../../types/main.dart';
import '../platform_inappwebview_controller.dart';

/// Delegate for cookie-management methods scoped to a single
/// [PlatformInAppWebViewController].
///
/// Part of the domain-controller split (issue #229, P3): cookie operations
/// that operate on the WebView's current context are grouped behind this
/// focused facade so the main [PlatformInAppWebViewController] stays easy to
/// reason about. The shared [PlatformCookieManager] remains the source of
/// truth for cross-WebView global operations; this delegate exposes the
/// per-controller subset that takes a [PlatformInAppWebViewController] as
/// context.
///
/// Platform implementations override the [PlatformInAppWebViewController.cookieDelegate]
/// getter to return a concrete instance. The default getter returns `null`,
/// preserving backward compatibility for implementations that have not yet
/// been migrated.
abstract class PlatformCookieDelegate extends PlatformInterface {
  /// Creates a new [PlatformCookieDelegate].
  PlatformCookieDelegate({required Object token}) : super(token: token);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager.setCookie}
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
  }) {
    throw UnimplementedError(
      'setCookie is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager.getCookies}
  Future<List<Cookie>> getCookies({required WebUri url}) {
    throw UnimplementedError(
      'getCookies is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager.getCookie}
  Future<Cookie?> getCookie({required WebUri url, required String name}) {
    throw UnimplementedError(
      'getCookie is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager.deleteCookie}
  Future<bool> deleteCookie({
    required WebUri url,
    required String name,
    String path = "/",
    String? domain,
  }) {
    throw UnimplementedError(
      'deleteCookie is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager.deleteCookies}
  Future<bool> deleteCookies({
    required WebUri url,
    String path = "/",
    String? domain,
  }) {
    throw UnimplementedError(
      'deleteCookies is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager.getAllCookies}
  Future<List<Cookie>> getAllCookies() {
    throw UnimplementedError(
      'getAllCookies is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager.deleteAllCookies}
  Future<bool> deleteAllCookies() {
    throw UnimplementedError(
      'deleteAllCookies is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager.removeSessionCookies}
  Future<bool> removeSessionCookies() {
    throw UnimplementedError(
      'removeSessionCookies is not implemented on the current platform',
    );
  }
}
