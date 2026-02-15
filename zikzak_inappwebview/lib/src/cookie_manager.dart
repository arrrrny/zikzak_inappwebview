import 'dart:async';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'in_app_webview/in_app_webview_controller.dart';
import 'webview_environment/webview_environment.dart';

///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager}
class CookieManager {
  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager}
  CookieManager()
      : this.fromPlatformCreationParams(
          const PlatformCookieManagerCreationParams(),
        );

  /// Constructs a [CookieManager] from creation params for a specific
  /// platform.
  CookieManager.fromPlatformCreationParams(
    PlatformCookieManagerCreationParams params,
  ) : this.fromPlatform(PlatformCookieManager(params));

  /// Constructs a [CookieManager] from a specific platform
  /// implementation.
  CookieManager.fromPlatform(this.platform);

  /// Implementation of [PlatformCookieManager] for the current platform.
  final PlatformCookieManager platform;

  static CookieManager? _instance;

  ///Gets the [CookieManager] shared instance.
  ///
  ///[webViewEnvironment] (Supported only on Windows) - Used to create the [CookieManager] using the specified environment.
  static CookieManager instance({WebViewEnvironment? webViewEnvironment}) {
    if (webViewEnvironment == null) {
      if (_instance == null) {
        _instance = CookieManager();
      }
      return _instance!;
    } else {
      return CookieManager.fromPlatformCreationParams(
          PlatformCookieManagerCreationParams(
              webViewEnvironment: webViewEnvironment.platform));
    }
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager.setCookie}
  Future<bool> setCookie(
          {required WebUri url,
          required String name,
          required String value,
          String path = "/",
          String? domain,
          int? expiresDate,
          int? maxAge,
          bool? isSecure,
          bool? isHttpOnly,
          HTTPCookieSameSitePolicy? sameSite,
          InAppWebViewController? webViewController}) =>
      platform.setCookie(
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
          webViewController: webViewController?.platform);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager.getCookies}
  Future<List<Cookie>> getCookies(
          {required WebUri url, InAppWebViewController? webViewController}) =>
      platform.getCookies(
          url: url, webViewController: webViewController?.platform);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager.getCookie}
  Future<Cookie?> getCookie(
          {required WebUri url,
          required String name,
          InAppWebViewController? webViewController}) =>
      platform.getCookie(
          url: url,
          name: name,
          webViewController: webViewController?.platform);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager.deleteCookie}
  Future<bool> deleteCookie(
          {required WebUri url,
          required String name,
          String path = "/",
          String? domain,
          InAppWebViewController? webViewController}) =>
      platform.deleteCookie(
          url: url,
          name: name,
          path: path,
          domain: domain,
          webViewController: webViewController?.platform);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager.deleteCookies}
  Future<bool> deleteCookies(
          {required WebUri url,
          String path = "/",
          String? domain,
          InAppWebViewController? webViewController}) =>
      platform.deleteCookies(
          url: url,
          path: path,
          domain: domain,
          webViewController: webViewController?.platform);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager.deleteAllCookies}
  Future<bool> deleteAllCookies() => platform.deleteAllCookies();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager.getAllCookies}
  Future<List<Cookie>> getAllCookies() => platform.getAllCookies();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformCookieManager.removeSessionCookies}
  Future<bool> removeSessionCookies() => platform.removeSessionCookies();
}
