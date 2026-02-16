import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Implementation of [PlatformCookieManager] for Linux.
class LinuxCookieManager extends PlatformCookieManager {
  /// Constructs a [LinuxCookieManager].
  LinuxCookieManager(PlatformCookieManagerCreationParams params)
    : super.implementation(params);

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
    PlatformInAppWebViewController? webViewController,
  }) async {
    // TODO: implement setCookie
    return true;
  }

  @override
  Future<List<Cookie>> getCookies({
    required WebUri url,
    PlatformInAppWebViewController? webViewController,
  }) async {
    // TODO: implement getCookies
    return [];
  }

  @override
  Future<Cookie?> getCookie({
    required WebUri url,
    required String name,
    PlatformInAppWebViewController? webViewController,
  }) async {
    // TODO: implement getCookie
    return null;
  }

  @override
  Future<bool> deleteCookie({
    required WebUri url,
    required String name,
    String path = "/",
    String? domain,
    PlatformInAppWebViewController? webViewController,
  }) async {
    // TODO: implement deleteCookie
    return true;
  }

  @override
  Future<bool> deleteCookies({
    required WebUri url,
    String path = "/",
    String? domain,
    PlatformInAppWebViewController? webViewController,
  }) async {
    // TODO: implement deleteCookies
    return true;
  }

  @override
  Future<bool> deleteAllCookies({
    PlatformInAppWebViewController? webViewController,
  }) async {
    // TODO: implement deleteAllCookies
    return true;
  }

  @override
  Future<void> dispose() async {
    // TODO: implement dispose
  }
}
