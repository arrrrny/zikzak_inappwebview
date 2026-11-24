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
  }) async {
    final scope = domain ?? url.host;
    // Match the STORED row rather than inventing attributes. Forcing
    // `HttpOnly` (or deriving `Secure` from the URL's scheme) mutates a
    // different jar entry on engines that key a cookie on its attributes, so
    // the delete silently misses the cookie the caller can see.
    //
    // The lookup reads the RAW inventory (`getAllCookies`), not
    // `getCookies(url:)`: that view drops `Secure` cookies for an `http://`
    // URL, and deleting one of those is legal — deletion needs no TLS.
    final inventory = await getAllCookies();
    List<Cookie> rowsFor(String candidate) => inventory
        .where(
          (cookie) =>
              cookie.name == name &&
              (cookie.path ?? '/') == path &&
              cookie.domain == candidate,
        )
        .toList();
    // A direct call with no `domain` addresses the host-only variant; a cookie
    // actually stored as `Domain=.example.com` needs the dotted scope, so fall
    // back to it when the host-only scope has no row.
    final stored = rowsFor(scope);
    final resolvedScope = stored.isNotEmpty
        ? scope
        : (domain == null &&
                  url.host.isNotEmpty &&
                  rowsFor('.${url.host}').isNotEmpty
              ? '.${url.host}'
              : scope);
    final attributes = stored.isNotEmpty
        ? stored.first
        : (rowsFor(resolvedScope).isNotEmpty
              ? rowsFor(resolvedScope).first
              : null);
    await setCookie(
      url: url,
      name: name,
      value: '',
      path: path,
      domain: resolvedScope.startsWith('.') ? resolvedScope : null,
      maxAge: 0,
      isSecure: attributes?.isSecure ?? (url.scheme == 'https'),
      isHttpOnly: attributes?.isHttpOnly ?? false,
      sameSite: attributes?.sameSite,
    );
    return !(await getAllCookies()).any(
      (cookie) =>
          cookie.name == name &&
          cookie.path == path &&
          cookie.domain == resolvedScope,
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
