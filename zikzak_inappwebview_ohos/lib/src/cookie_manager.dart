import 'dart:convert';
// `HttpDate` only: the RFC 1123 formatter the other implementations emit for
// `Expires`. `io.Cookie` is deliberately NOT used — its validating constructor
// rejects values every other platform hands to the engine as-is.
import 'dart:io' show HttpDate;

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
    // A plain `set-cookie` string, as every other implementation hands to its
    // native cookie store: `dart:io`'s `Cookie` validates name and value
    // against RFC 6265 in its constructor and throws `FormatException` for any
    // character outside `0x21-0x7E` minus `" , ; \`, or for non-ASCII — values
    // the engine itself would accept. The formatting is deliberately local
    // rather than routed through a validating object.
    final attributes = <String>[
      'Path=${path.isEmpty ? '/' : path}',
      if (domain != null) 'Domain=$domain',
      if (expiresDate != null)
        'Expires=${HttpDate.format(DateTime.fromMillisecondsSinceEpoch(expiresDate, isUtc: true))}',
      if (maxAge != null) 'Max-Age=$maxAge',
      if (isSecure ?? false) 'Secure',
      if (isHttpOnly ?? false) 'HttpOnly',
      if (sameSite != null)
        'SameSite=${httpCookieSameSitePolicyToWire(sameSite)}',
    ];
    return await _channel.invokeMethod<bool>(
          'setCookie',
          jsonEncode({
            'url': url.toString(),
            'cookie': '$name=$value; ${attributes.join('; ')}',
          }),
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
  }) => _deleteMatching(url: url, name: name, path: path, domain: domain);

  @override
  Future<bool> deleteCookies({
    required WebUri url,
    String path = '/',
    String? domain,
    PlatformInAppWebViewController? iosBelow11WebViewController,
    PlatformInAppWebViewController? webViewController,
  }) => _deleteMatching(url: url, path: path, domain: domain);

  Future<bool> _deleteMatching({
    required WebUri url,
    required String path,
    String? name,
    String? domain,
  }) async {
    final host = url.host.toLowerCase();
    final cookies = (await getAllCookies()).where((cookie) {
      final scope = cookie.domain?.toLowerCase();
      return (name == null || cookie.name == name) &&
          (cookie.path ?? '/') == path &&
          (domain != null
              ? scope == domain.toLowerCase()
              : scope == host || scope == '.$host');
    }).toList();
    if (cookies.isEmpty) return true;
    for (final cookie in cookies) {
      // ArkWeb reports host-only scopes without a leading dot. Preserve both
      // native scope and attributes when expiring the stored cookie.
      final scope = cookie.domain ?? '';
      final deleted = await setCookie(
        url: url,
        name: cookie.name,
        value: '',
        path: cookie.path ?? '/',
        domain: scope.startsWith('.') ? scope : null,
        maxAge: 0,
        isSecure: cookie.isSecure,
        isHttpOnly: cookie.isHttpOnly,
        sameSite: cookie.sameSite,
      );
      if (!deleted) return false;
    }
    final targets = cookies
        .map((cookie) => (cookie.name, cookie.domain, cookie.path ?? '/'))
        .toSet();
    return !(await getAllCookies()).any(
      (cookie) =>
          targets.contains((cookie.name, cookie.domain, cookie.path ?? '/')),
    );
  }

  @override
  Future<bool> deleteAllCookies() async =>
      await _channel.invokeMethod<bool>('deleteAllCookies') ?? false;
  @override
  void dispose({bool isKeepAlive = false}) {}
}
