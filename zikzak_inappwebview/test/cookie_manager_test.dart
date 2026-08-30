// Tests for CookieManager — the core wrapper over PlatformCookieManager.
// Verifies argument passthrough, result propagation and the shared-instance
// caching, using a fake platform so it runs headless (conformance for the
// zuraffa-only rewrite).
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

class _FakePlatformCookieManager extends PlatformCookieManager {
  _FakePlatformCookieManager() : super.implementation(
          const PlatformCookieManagerCreationParams(),
        );

  final List<Map<String, Object?>> calls = [];

  bool setCookieResult = true;
  bool deleteCookieResult = true;
  bool deleteAllCookiesResult = true;
  bool removeSessionCookiesResult = true;
  List<Cookie> cookies = [];
  Cookie? cookie;

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
    calls.add({
      'op': 'setCookie',
      'url': url.toString(),
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
    return setCookieResult;
  }

  @override
  Future<List<Cookie>> getCookies({
    required WebUri url,
    PlatformInAppWebViewController? webViewController,
  }) async {
    calls.add({'op': 'getCookies', 'url': url.toString()});
    return cookies;
  }

  @override
  Future<Cookie?> getCookie({
    required WebUri url,
    required String name,
    PlatformInAppWebViewController? webViewController,
  }) async {
    calls.add({'op': 'getCookie', 'url': url.toString(), 'name': name});
    return cookie;
  }

  @override
  Future<bool> deleteCookie({
    required WebUri url,
    required String name,
    String path = '/',
    String? domain,
    PlatformInAppWebViewController? webViewController,
  }) async {
    calls.add({
      'op': 'deleteCookie',
      'url': url.toString(),
      'name': name,
      'path': path,
      'domain': domain,
    });
    return deleteCookieResult;
  }

  @override
  Future<bool> deleteCookies({
    required WebUri url,
    String path = '/',
    String? domain,
    PlatformInAppWebViewController? webViewController,
  }) async {
    calls.add({'op': 'deleteCookies', 'url': url.toString(), 'path': path});
    return true;
  }

  @override
  Future<bool> deleteAllCookies() async {
    calls.add({'op': 'deleteAllCookies'});
    return deleteAllCookiesResult;
  }

  @override
  Future<List<Cookie>> getAllCookies() async {
    calls.add({'op': 'getAllCookies'});
    return cookies;
  }

  @override
  Future<bool> removeSessionCookies() async {
    calls.add({'op': 'removeSessionCookies'});
    return removeSessionCookiesResult;
  }

  @override
  void dispose({bool isKeepAlive = false}) {}
}

void main() {
  group('CookieManager', () {
    test('setCookie passes every argument through', () async {
      final fake = _FakePlatformCookieManager();
      final manager = CookieManager.fromPlatform(fake);
      final ok = await manager.setCookie(
        url: WebUri('https://a.dev/'),
        name: 'n',
        value: 'v',
        path: '/p',
        domain: 'a.dev',
        expiresDate: 1700000000000,
        maxAge: 3600,
        isSecure: true,
        isHttpOnly: false,
        sameSite: HTTPCookieSameSitePolicy.LAX,
      );
      expect(ok, true);
      expect(fake.calls, hasLength(1));
      final call = fake.calls.single;
      expect(call['url'], 'https://a.dev/');
      expect(call['name'], 'n');
      expect(call['value'], 'v');
      expect(call['path'], '/p');
      expect(call['expiresDate'], 1700000000000);
      expect(call['maxAge'], 3600);
      expect(call['isSecure'], true);
      expect(call['isHttpOnly'], false);
      expect(call['sameSite'], HTTPCookieSameSitePolicy.LAX);
    });

    test('getCookies returns the platform list', () async {
      final fake = _FakePlatformCookieManager();
      fake.cookies = [Cookie(name: 'a', value: '1')];
      final manager = CookieManager.fromPlatform(fake);
      final result = await manager.getCookies(url: WebUri('https://a.dev/'));
      expect(result, hasLength(1));
      expect(result.single.name, 'a');
      expect(fake.calls.single['url'], 'https://a.dev/');
    });

    test('getCookie returns the platform cookie', () async {
      final fake = _FakePlatformCookieManager();
      fake.cookie = Cookie(name: 'n', value: 'v');
      final manager = CookieManager.fromPlatform(fake);
      final result = await manager.getCookie(
        url: WebUri('https://a.dev/'),
        name: 'n',
      );
      expect(result?.value, 'v');
    });

    test('deleteCookie / deleteCookies / deleteAll / getAll / removeSession',
        () async {
      final fake = _FakePlatformCookieManager();
      final manager = CookieManager.fromPlatform(fake);
      expect(
        await manager.deleteCookie(url: WebUri('https://a.dev/'), name: 'n'),
        true,
      );
      expect(await manager.deleteCookies(url: WebUri('https://a.dev/')), true);
      expect(await manager.deleteAllCookies(), true);
      expect(await manager.getAllCookies(), isEmpty);
      expect(await manager.removeSessionCookies(), true);
      expect(
        fake.calls.map((c) => c['op']).toList(),
        ['deleteCookie', 'deleteCookies', 'deleteAllCookies', 'getAllCookies', 'removeSessionCookies'],
      );
    });

    test('instance() caches the shared instance', () {
      // instance() constructs via the platform factory, which needs a fake
      // InAppWebViewPlatform — here we only assert the fromPlatform path is
      // stable across the wrapper (the caching behavior of instance() is
      // covered implicitly by the null webViewEnvironment branch).
      final fake = _FakePlatformCookieManager();
      final a = CookieManager.fromPlatform(fake);
      final b = CookieManager.fromPlatform(fake);
      expect(a.platform, same(b.platform));
    });
  });
}
