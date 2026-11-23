import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

class OhosCookieManager extends PlatformCookieManager {
  OhosCookieManager(super.params) : super.implementation();
  static const _channel = MethodChannel('wtf.zikzak/arkweb_cookies');

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
    PlatformInAppWebViewController? iosBelow11WebViewController,
    PlatformInAppWebViewController? webViewController,
  }) async {
    final cookie = io.Cookie(name, value)..path = path;
    if (domain != null) cookie.domain = domain;
    if (expiresDate != null) {
      cookie.expires = DateTime.fromMillisecondsSinceEpoch(
        expiresDate,
        isUtc: true,
      );
    }
    if (maxAge != null) cookie.maxAge = maxAge;
    cookie.secure = isSecure ?? false;
    cookie.httpOnly = isHttpOnly ?? false;
    if (sameSite != null) {
      cookie.sameSite = switch (sameSite) {
        HTTPCookieSameSitePolicy.STRICT => io.SameSite.strict,
        HTTPCookieSameSitePolicy.LAX => io.SameSite.lax,
        _ => io.SameSite.none,
      };
    }
    return await _channel.invokeMethod<bool>(
          'setCookie',
          jsonEncode({'url': url.toString(), 'cookie': cookie.toString()}),
        ) ??
        false;
  }

  @override
  Future<List<Cookie>> getAllCookies() async {
    final encoded = await _channel.invokeMethod<String>('getAllCookies');
    final rows = jsonDecode(encoded ?? '[]') as List;
    return [
      for (final row in rows)
        Cookie(
          name: row['name'] as String,
          value: row['value'] as String,
          domain: row['domain'] as String,
          path: row['path'] as String,
          isSecure: row['isSecure'] as bool,
          isHttpOnly: row['isHttpOnly'] as bool,
          sameSite: switch (row['samesitePolicy']) {
            0 => HTTPCookieSameSitePolicy.NONE,
            1 => HTTPCookieSameSitePolicy.LAX,
            2 => HTTPCookieSameSitePolicy.STRICT,
            _ => null,
          },
          expiresDate: row['isSessionCookie'] == true
              ? null
              : DateTime.tryParse(row['expiresDate'] as String)
                    ?.millisecondsSinceEpoch,
        ),
    ];
  }

  @override
  Future<List<Cookie>> getCookies({
    required WebUri url,
    PlatformInAppWebViewController? iosBelow11WebViewController,
    PlatformInAppWebViewController? webViewController,
  }) async {
    final uri = Uri.parse(url.toString());
    final matches = (await getAllCookies()).where((cookie) {
      final domain = cookie.domain ?? '';
      final hostname = uri.host.toLowerCase();
      final hostMatches = domain.startsWith('.')
          ? hostname == domain.substring(1).toLowerCase() ||
                hostname.endsWith(domain.toLowerCase())
          : hostname == domain.toLowerCase();
      final scope = cookie.path ?? '/';
      final path = uri.path.isEmpty ? '/' : uri.path;
      final pathMatches =
          path == scope ||
          path.startsWith(scope.endsWith('/') ? scope : '$scope/');
      return hostMatches &&
          pathMatches &&
          (cookie.isSecure != true || uri.scheme == 'https');
    }).toList();
    matches.sort(
      (a, b) => (b.path?.length ?? 1).compareTo(a.path?.length ?? 1),
    );
    return matches;
  }

  @override
  Future<Cookie?> getCookie({
    required WebUri url,
    required String name,
    PlatformInAppWebViewController? iosBelow11WebViewController,
    PlatformInAppWebViewController? webViewController,
  }) async {
    final cookies = await getCookies(url: url);
    for (final cookie in cookies) {
      if (cookie.name == name) return cookie;
    }
    return null;
  }

  @override
  Future<bool> deleteCookie({
    required WebUri url,
    required String name,
    String path = '/',
    String? domain,
    PlatformInAppWebViewController? iosBelow11WebViewController,
    PlatformInAppWebViewController? webViewController,
  }) async {
    final scope = domain ?? url.host;
    // ArkWeb returns host-only domains without a leading dot. Adding Domain
    // would address a different cookie, so preserve the native scope exactly.
    await setCookie(
      url: url,
      name: name,
      value: '',
      path: path,
      domain: scope.startsWith('.') ? scope : null,
      maxAge: 0,
      isSecure: url.scheme == 'https',
      isHttpOnly: true,
    );
    return !(await getCookies(url: url)).any(
      (cookie) =>
          cookie.name == name && cookie.path == path && cookie.domain == scope,
    );
  }

  @override
  Future<bool> deleteCookies({
    required WebUri url,
    String path = '/',
    String? domain,
    PlatformInAppWebViewController? iosBelow11WebViewController,
    PlatformInAppWebViewController? webViewController,
  }) async {
    final cookies = await getCookies(url: url);
    for (final cookie in cookies) {
      if (domain != null && cookie.domain != domain) continue;
      if ((cookie.path ?? '/') != path) continue;
      final deleted = await deleteCookie(
        url: url,
        name: cookie.name,
        path: cookie.path ?? '/',
        domain: cookie.domain,
      );
      if (!deleted) return false;
    }
    return true;
  }

  @override
  Future<bool> deleteAllCookies() async =>
      await _channel.invokeMethod<bool>('deleteAllCookies') ?? false;
  @override
  void dispose({bool isKeepAlive = false}) {}
}
