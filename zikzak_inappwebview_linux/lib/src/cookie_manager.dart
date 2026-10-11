import 'package:flutter/services.dart';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Implementation of [PlatformCookieManager] for Linux.
////
/// Wires cookie operations to the native WebKitGTK cookie manager
/// (WebKitCookieManager / SoupCookieManager) via [MethodChannel].
class LinuxCookieManager extends PlatformCookieManager {
  static final MethodChannel _channel = MethodChannel(
    'dev.zuzu/zikzak_inappwebview_cookiemanager',
  );

  static LinuxCookieManager? _instance;

  /// Constructs a [LinuxCookieManager].
  LinuxCookieManager(super.params) : super.implementation();

  /// Gets the [LinuxCookieManager] shared instance.
  static LinuxCookieManager instance() {
    return (_instance != null) ? _instance! : _init();
  }

  static LinuxCookieManager _init() {
    _instance = LinuxCookieManager(const PlatformCookieManagerCreationParams());
    return _instance!;
  }

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
    Map<String, dynamic> args = <String, dynamic>{};
    args['url'] = url.toString();
    args['name'] = name;
    args['value'] = value;
    args['path'] = path;
    args['domain'] = domain;
    args['expiresDate'] = expiresDate;
    args['maxAge'] = maxAge;
    args['isSecure'] = isSecure;
    args['isHttpOnly'] = isHttpOnly;
    args['sameSite'] = httpCookieSameSitePolicyToWire(sameSite);
    return await _channel.invokeMethod<bool>('setCookie', args) ?? false;
  }

  @override
  Future<List<Cookie>> getCookies({
    required WebUri url,
    PlatformInAppWebViewController? webViewController,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args['url'] = url.toString();
    List<dynamic> cookieListMap =
        await _channel.invokeMethod<List>('getCookies', args) ?? [];
    cookieListMap = cookieListMap.cast<Map<dynamic, dynamic>>();

    List<Cookie> cookies = [];
    for (final cookieMap in cookieListMap) {
      final map = (cookieMap as Map).cast<String, dynamic>();
      cookies.add(
        Cookie(
          name: map['name'],
          value: map['value'],
          expiresDate: map['expiresDate'],
          isSessionOnly: map['isSessionOnly'],
          domain: map['domain'],
          sameSite: httpCookieSameSitePolicyFromWire(map['sameSite']),
          isSecure: map['isSecure'],
          isHttpOnly: map['isHttpOnly'],
          path: map['path'],
        ),
      );
    }
    return cookies;
  }

  @override
  Future<Cookie?> getCookie({
    required WebUri url,
    required String name,
    PlatformInAppWebViewController? webViewController,
  }) async {
    final cookies = await getCookies(
      url: url,
      webViewController: webViewController,
    );
    for (final cookie in cookies) {
      if (cookie.name == name) return cookie;
    }
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
    Map<String, dynamic> args = <String, dynamic>{};
    args['url'] = url.toString();
    args['name'] = name;
    args['domain'] = domain;
    args['path'] = path;
    return await _channel.invokeMethod<bool>('deleteCookie', args) ?? false;
  }

  @override
  Future<bool> deleteCookies({
    required WebUri url,
    String path = "/",
    String? domain,
    PlatformInAppWebViewController? webViewController,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args['url'] = url.toString();
    args['domain'] = domain;
    args['path'] = path;
    return await _channel.invokeMethod<bool>('deleteCookies', args) ?? false;
  }

  @override
  Future<bool> deleteAllCookies() async {
    Map<String, dynamic> args = <String, dynamic>{};
    return await _channel.invokeMethod<bool>('deleteAllCookies', args) ?? false;
  }

  @override
  Future<List<Cookie>> getAllCookies() async {
    List<dynamic> cookieListMap =
        await _channel.invokeMethod<List>('getAllCookies') ?? [];
    cookieListMap = cookieListMap.cast<Map<dynamic, dynamic>>();

    List<Cookie> cookies = [];
    for (final cookieMap in cookieListMap) {
      final map = (cookieMap as Map).cast<String, dynamic>();
      cookies.add(
        Cookie(
          name: map['name'],
          value: map['value'],
          expiresDate: map['expiresDate'],
          isSessionOnly: map['isSessionOnly'],
          domain: map['domain'],
          sameSite: httpCookieSameSitePolicyFromWire(map['sameSite']),
          isSecure: map['isSecure'],
          isHttpOnly: map['isHttpOnly'],
          path: map['path'],
        ),
      );
    }
    return cookies;
  }

  @override
  Future<bool> removeSessionCookies() async {
    Map<String, dynamic> args = <String, dynamic>{};
    return await _channel.invokeMethod<bool>('removeSessionCookies', args) ??
        false;
  }

  @override
  Future<void> dispose({bool isKeepAlive = false}) async {
    // nothing to dispose — the MethodChannel is static
  }
}
