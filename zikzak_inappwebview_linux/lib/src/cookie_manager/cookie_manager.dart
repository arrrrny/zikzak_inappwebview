import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../util/wire.dart';

/// Object specifying creation parameters for creating a [LinuxCookieManager].
///
/// When adding additional fields make sure they can be null or have a default
/// value to avoid breaking changes. See [PlatformCookieManagerCreationParams] for
/// more information.
class LinuxCookieManagerCreationParams
    extends PlatformCookieManagerCreationParams {
  /// Creates a new [LinuxCookieManagerCreationParams] instance.
  const LinuxCookieManagerCreationParams();

  /// Creates a [LinuxCookieManagerCreationParams] instance based on [PlatformCookieManagerCreationParams].
  factory LinuxCookieManagerCreationParams.fromPlatformCookieManagerCreationParams(
    PlatformCookieManagerCreationParams params,
  ) {
    return const LinuxCookieManagerCreationParams();
  }
}

/// Implementation of [PlatformCookieManager] for Linux using WebKitGTK.
class LinuxCookieManager extends PlatformCookieManager {
  static const MethodChannel _channel = MethodChannel(
    'wtf.zikzak/zikzak_inappwebview_cookiemanager',
  );

  /// Constructs a [LinuxCookieManager].
  LinuxCookieManager(PlatformCookieManagerCreationParams params)
    : super.implementation(
        params is LinuxCookieManagerCreationParams
            ? params
            : LinuxCookieManagerCreationParams.fromPlatformCookieManagerCreationParams(
                params,
              ),
      );

  static final LinuxCookieManager _instance = LinuxCookieManager(
    const LinuxCookieManagerCreationParams(),
  );

  /// The [LinuxCookieManager] singleton instance.
  static LinuxCookieManager instance() => _instance;

  /// Creates and returns a new [LinuxCookieManager] for static methods.
  factory LinuxCookieManager.static() => _instance;

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
    @Deprecated("Use webViewController instead")
    PlatformInAppWebViewController? iosBelow11WebViewController,
    PlatformInAppWebViewController? webViewController,
  }) async {
    // Native never reads maxAge, so convert it to an absolute expiry
    // (milliseconds since epoch) unless the caller gave expiresDate.
    final effectiveExpires = expiresDate ??
        (maxAge != null
            ? DateTime.now().millisecondsSinceEpoch + maxAge * 1000
            : null);
    final Map<String, dynamic> cookie = {
      'name': name,
      'value': value,
      'path': path,
      'domain': ?domain,
      'expiresDate': ?effectiveExpires,
      'isSecure': ?isSecure,
      'isHttpOnly': ?isHttpOnly,
      if (sameSite != null) 'sameSite': httpCookieSameSitePolicyToWire(sameSite),
    };

    final result = await _channel.invokeMethod<bool>('setCookie', {
      'url': url.toString(),
      'cookie': cookie,
    });

    return result ?? false;
  }

  @override
  Future<List<Cookie>> getCookies({
    required WebUri url,
    @Deprecated("Use webViewController instead")
    PlatformInAppWebViewController? iosBelow11WebViewController,
    PlatformInAppWebViewController? webViewController,
  }) async {
    final result = await _channel.invokeMethod<List<dynamic>>('getCookies', {
      'url': url.toString(),
    });

    if (result == null) {
      return [];
    }

    return result
        .cast<Map<dynamic, dynamic>>()
        .map((cookieMap) => fromWire(cookieMap, Cookie.fromJson)!)
        .toList();
  }

  @override
  Future<Cookie?> getCookie({
    required WebUri url,
    required String name,
    @Deprecated("Use webViewController instead")
    PlatformInAppWebViewController? iosBelow11WebViewController,
    PlatformInAppWebViewController? webViewController,
  }) async {
    final result = await _channel.invokeMethod<Map<dynamic, dynamic>?>(
      'getCookie',
      {'url': url.toString(), 'name': name},
    );

    if (result == null) {
      return null;
    }

    return fromWire(result, Cookie.fromJson);
  }

  @override
  Future<bool> deleteCookie({
    required WebUri url,
    required String name,
    String path = "/",
    String? domain,
    @Deprecated("Use webViewController instead")
    PlatformInAppWebViewController? iosBelow11WebViewController,
    PlatformInAppWebViewController? webViewController,
  }) async {
    final result = await _channel.invokeMethod<bool>('deleteCookie', {
      'url': url.toString(),
      'name': name,
      'path': path,
      'domain': domain ?? '',
    });

    return result ?? false;
  }

  @override
  Future<bool> deleteCookies({
    required WebUri url,
    String path = "/",
    String? domain,
    @Deprecated("Use webViewController instead")
    PlatformInAppWebViewController? iosBelow11WebViewController,
    PlatformInAppWebViewController? webViewController,
  }) async {
    final result = await _channel.invokeMethod<bool>('deleteCookies', {
      'url': url.toString(),
      'path': path,
      'domain': domain ?? '',
    });

    return result ?? false;
  }

  @override
  Future<bool> deleteAllCookies() async {
    final result = await _channel.invokeMethod<bool>('deleteAllCookies');
    return result ?? false;
  }

  /// The cookie manager is a singleton on a static channel; nothing to release.
  @override
  void dispose({bool isKeepAlive = false}) {}

  @override
  Future<List<Cookie>> getAllCookies() async {
    final result = await _channel.invokeMethod<List<dynamic>>('getAllCookies');

    if (result == null) {
      return [];
    }

    return result
        .cast<Map<dynamic, dynamic>>()
        .map((cookieMap) => fromWire(cookieMap, Cookie.fromJson)!)
        .toList();
  }
}
