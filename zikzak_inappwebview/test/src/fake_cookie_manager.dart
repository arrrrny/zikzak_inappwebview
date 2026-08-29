import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// A recording fake of [PlatformCookieManager] for behavioral tests of the
/// CookieController facade (spec 011, U46-U65).
///
/// Every method under test records its name and arguments in [calls] so a test
/// can assert that the facade forwarded to the shared [CookieManager] with
/// identical arguments and the same controller context. Methods that are not
/// exercised inherit the `throw UnimplementedError` body from the base class.
class FakePlatformCookieManager extends PlatformCookieManager {
  FakePlatformCookieManager()
      : super.implementation(const PlatformCookieManagerCreationParams());

  /// Ordered record of every recorded method call.
  final List<_CookieCall> calls = [];

  /// Configurable canned return values.
  List<Cookie> nextCookies = const [];
  Cookie? nextCookie;
  bool nextBool = true;

  List<_CookieCall> recorded(String name) =>
      calls.where((c) => c.method == name).toList();

  void _record(String method, [Map<String, Object?> args = const {}]) =>
      calls.add(_CookieCall(method, args));

  @override
  Future<List<Cookie>> getCookies({
    required WebUri url,
    PlatformInAppWebViewController? webViewController,
  }) async {
    _record('getCookies', {
      'url': url,
      'webViewController': webViewController,
    });
    return nextCookies;
  }

  @override
  Future<Cookie?> getCookie({
    required WebUri url,
    required String name,
    PlatformInAppWebViewController? webViewController,
  }) async {
    _record('getCookie', {
      'url': url,
      'name': name,
      'webViewController': webViewController,
    });
    return nextCookie;
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
    _record('setCookie', {
      'url': url,
      'name': name,
      'value': value,
      'path': path,
      'domain': domain,
      'expiresDate': expiresDate,
      'maxAge': maxAge,
      'isSecure': isSecure,
      'isHttpOnly': isHttpOnly,
      'sameSite': sameSite,
      'webViewController': webViewController,
    });
    return nextBool;
  }

  @override
  Future<bool> deleteCookie({
    required WebUri url,
    required String name,
    String path = "/",
    String? domain,
    PlatformInAppWebViewController? webViewController,
  }) async {
    _record('deleteCookie', {
      'url': url,
      'name': name,
      'path': path,
      'domain': domain,
      'webViewController': webViewController,
    });
    return nextBool;
  }

  @override
  Future<bool> deleteCookies({
    required WebUri url,
    String path = "/",
    String? domain,
    PlatformInAppWebViewController? webViewController,
  }) async {
    _record('deleteCookies', {
      'url': url,
      'path': path,
      'domain': domain,
      'webViewController': webViewController,
    });
    return nextBool;
  }

  @override
  Future<bool> deleteAllCookies() async {
    _record('deleteAllCookies');
    return nextBool;
  }

  @override
  Future<List<Cookie>> getAllCookies() async {
    _record('getAllCookies');
    return nextCookies;
  }

  @override
  Future<bool> removeSessionCookies() async {
    _record('removeSessionCookies');
    return nextBool;
  }

  @override
  void dispose({bool isKeepAlive = false}) {}
}

/// A single recorded cookie-method invocation.
class _CookieCall {
  const _CookieCall(this.method, this.args);
  final String method;
  final Map<String, Object?> args;
}
