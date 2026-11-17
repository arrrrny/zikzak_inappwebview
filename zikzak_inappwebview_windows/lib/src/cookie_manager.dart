import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'webview_environment.dart';

/// Native WebView2 cookies, including HttpOnly and session cookies. Browser
/// cookie selection stays in WebView2 rather than being reproduced in Dart.
class WindowsCookieManager extends PlatformCookieManager {
  WindowsCookieManager(super.params) : super.implementation();

  Future<dynamic> _call(
    String method,
    Map<String, dynamic> parameters, [
    PlatformInAppWebViewController? controller,
  ]) async {
    await WindowsWebViewEnvironment.initializeShared(
      settings: params.webViewEnvironment?.settings,
    );
    if (controller != null) {
      return controller.callDevToolsProtocolMethod(
        methodName: method,
        parameters: parameters,
      );
    }
    final native = await WindowsWebViewEnvironment.cookieController();
    return native.callDevToolsProtocolMethod(method, parameters);
  }

  static Cookie _decode(Map<dynamic, dynamic> cookie) {
    final expires = cookie['expires'] as num?;
    return Cookie(
      name: cookie['name'] as String,
      value: cookie['value'] as String,
      domain: cookie['domain'] as String?,
      path: cookie['path'] as String?,
      isSecure: cookie['secure'] as bool?,
      isHttpOnly: cookie['httpOnly'] as bool?,
      isSessionOnly: cookie['session'] as bool?,
      expiresDate: expires != null && expires >= 0
          ? (expires * 1000).round()
          : null,
      sameSite: switch (cookie['sameSite']) {
        'Strict' => HTTPCookieSameSitePolicy.STRICT,
        'Lax' => HTTPCookieSameSitePolicy.LAX,
        'None' => HTTPCookieSameSitePolicy.NONE,
        _ => null,
      },
    );
  }

  @override
  Future<bool> setCookie({
    required WebUri url,
    required String name,
    required String value,
    String path = '/',
    String? domain,
    int? expiresDate,
    int? maxAge,
    bool? isSecure,
    bool? isHttpOnly,
    HTTPCookieSameSitePolicy? sameSite,
    PlatformInAppWebViewController? webViewController,
  }) async {
    final result = await _call('Network.setCookie', {
      'url': url.toString(),
      'name': name,
      'value': value,
      'path': path,
      if (domain != null) 'domain': domain,
      if (isSecure != null) 'secure': isSecure,
      if (isHttpOnly != null) 'httpOnly': isHttpOnly,
      if (maxAge != null)
        'expires': DateTime.now().millisecondsSinceEpoch / 1000 + maxAge
      else if (expiresDate != null)
        'expires': expiresDate / 1000,
      if (sameSite != null)
        'sameSite': switch (sameSite) {
          HTTPCookieSameSitePolicy.STRICT => 'Strict',
          HTTPCookieSameSitePolicy.LAX => 'Lax',
          HTTPCookieSameSitePolicy.NONE => 'None',
        },
    }, webViewController);
    return result['success'] == true;
  }

  @override
  Future<List<Cookie>> getCookies({
    required WebUri url,
    PlatformInAppWebViewController? webViewController,
  }) async {
    final result = await _call('Network.getCookies', {
      'urls': [url.toString()],
    }, webViewController);
    return (result['cookies'] as List).cast<Map>().map(_decode).toList();
  }

  @override
  Future<Cookie?> getCookie({
    required WebUri url,
    required String name,
    PlatformInAppWebViewController? webViewController,
  }) async {
    for (final cookie in await getCookies(
      url: url,
      webViewController: webViewController,
    )) {
      if (cookie.name == name) return cookie;
    }
    return null;
  }

  @override
  Future<List<Cookie>> getAllCookies() async {
    final result = await _call('Storage.getCookies', {});
    return (result['cookies'] as List).cast<Map>().map(_decode).toList();
  }

  @override
  Future<bool> deleteCookie({
    required WebUri url,
    required String name,
    String path = '/',
    String? domain,
    PlatformInAppWebViewController? webViewController,
  }) async {
    await _call('Network.deleteCookies', {
      'name': name,
      'domain': domain ?? url.host,
      'path': path,
    }, webViewController);
    return true;
  }

  @override
  Future<bool> deleteCookies({
    required WebUri url,
    String path = '/',
    String? domain,
    PlatformInAppWebViewController? webViewController,
  }) async {
    final scope = WebUri.uri(Uri.parse(url.toString()).replace(path: path));
    for (final cookie in await getCookies(
      url: scope,
      webViewController: webViewController,
    )) {
      if ((domain == null || cookie.domain == domain) && cookie.path == path) {
        await deleteCookie(
          url: url,
          name: cookie.name,
          domain: cookie.domain,
          path: path,
          webViewController: webViewController,
        );
      }
    }
    return true;
  }

  @override
  Future<bool> deleteAllCookies() async {
    await _call('Network.clearBrowserCookies', {});
    return true;
  }

  @override
  Future<bool> removeSessionCookies() async {
    var removed = false;
    for (final cookie in await getAllCookies()) {
      if (cookie.isSessionOnly == true) {
        await _call('Network.deleteCookies', {
          'name': cookie.name,
          'domain': cookie.domain,
          'path': cookie.path,
        });
        removed = true;
      }
    }
    return removed;
  }

  @override
  void dispose({bool isKeepAlive = false}) {}
}
