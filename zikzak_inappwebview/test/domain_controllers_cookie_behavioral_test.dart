import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview/src/in_app_webview/controllers/cookie_controller.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'src/fake_platform_controller.dart';
import 'src/fake_cookie_manager.dart';

/// Behavioral tests for the CookieController facade (spec 011, U46-U65).
///
/// Each test proves the facade forwards to the shared [CookieManager] with
/// identical arguments and the parent controller as context (via the recording
/// [FakePlatformCookieManager]), and that default-to-current-URL resolution and
/// graceful degradation are correct. U65 exercises the no-override path that
/// lazily resolves [CookieManager.instance()], which requires the global test
/// platform set in `setUpAll`.

/// Shared singleton-backed fake used only by U65 (the no-override path).
final _singletonFake = FakePlatformCookieManager();

/// Minimal platform whose cookie manager factory returns [_singletonFake], so
/// the un-injected [CookieManager.instance()] path in U65 resolves cleanly.
class _TestPlatform extends InAppWebViewPlatform {
  _TestPlatform(this.cookieManager);
  final PlatformCookieManager cookieManager;

  @override
  PlatformCookieManager createPlatformCookieManager(
    PlatformCookieManagerCreationParams params,
  ) =>
      cookieManager;
}

InAppWebViewController _controller(FakePlatformInAppWebViewController fake) =>
    InAppWebViewController.fromPlatform(platform: fake);

CookieController _cookies(
  InAppWebViewController controller,
  FakePlatformCookieManager fake,
) =>
    CookieController(
      controller,
      cookieManager: CookieManager.fromPlatform(fake),
    );

const _currentUrl = 'https://example.com/page';
const _otherUrl = 'https://other.com/c';

void main() {
  setUpAll(() {
    InAppWebViewPlatform.instance = _TestPlatform(_singletonFake);
  });

  group('CookieController delegates to CookieManager (U46-U65)', () {
    test('U46 getCookies without URL defers to getUrl() and passes controller ctx',
        () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri(_currentUrl);
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager()
        ..nextCookies = [Cookie(name: 'a', value: '1')];
      final cookies = _cookies(controller, cookieFake);

      final result = await cookies.getCookies();

      expect(result, hasLength(1));
      expect(result.single.name, 'a');
      final calls = cookieFake.recorded('getCookies');
      expect(calls, hasLength(1));
      expect(calls.single.args['url'], WebUri(_currentUrl));
      expect(calls.single.args['webViewController'], same(fake));
    });

    test('U47 getCookies with explicit URL uses it and ignores current URL',
        () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri(_currentUrl);
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager();
      final cookies = _cookies(controller, cookieFake);
      final explicit = WebUri(_otherUrl);

      await cookies.getCookies(url: explicit);

      final calls = cookieFake.recorded('getCookies');
      expect(calls, hasLength(1));
      expect(calls.single.args['url'], explicit);
      expect(fake.recorded('getUrl'), isEmpty);
    });

    test('U48 getCookies with no URL available returns [] (graceful)', () async {
      final fake = FakePlatformInAppWebViewController()..nextUrl = null;
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager();
      final cookies = _cookies(controller, cookieFake);

      final result = await cookies.getCookies();

      expect(result, isEmpty);
      expect(cookieFake.recorded('getCookies'), isEmpty);
    });

    test('U49 getCookie without URL defers to getUrl()', () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri(_currentUrl);
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager()
        ..nextCookie = Cookie(name: 'sid', value: 'v');
      final cookies = _cookies(controller, cookieFake);

      final got = await cookies.getCookie(name: 'sid');

      expect(got?.name, 'sid');
      final calls = cookieFake.recorded('getCookie');
      expect(calls, hasLength(1));
      expect(calls.single.args['url'], WebUri(_currentUrl));
      expect(calls.single.args['name'], 'sid');
    });

    test('U50 getCookie with explicit URL uses it and ignores current URL',
        () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri(_currentUrl);
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager();
      final cookies = _cookies(controller, cookieFake);
      final explicit = WebUri(_otherUrl);

      await cookies.getCookie(name: 'sid', url: explicit);

      final calls = cookieFake.recorded('getCookie');
      expect(calls, hasLength(1));
      expect(calls.single.args['url'], explicit);
      expect(fake.recorded('getUrl'), isEmpty);
    });

    test('U51 getCookie with no URL available returns null (graceful)', () async {
      final fake = FakePlatformInAppWebViewController()..nextUrl = null;
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager();
      final cookies = _cookies(controller, cookieFake);

      final got = await cookies.getCookie(name: 'sid');

      expect(got, isNull);
      expect(cookieFake.recorded('getCookie'), isEmpty);
    });

    test('U52 setCookie without URL defers to getUrl()', () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri(_currentUrl);
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager();
      final cookies = _cookies(controller, cookieFake);

      final ok = await cookies.setCookie(name: 'x', value: 'y');

      expect(ok, isTrue);
      final calls = cookieFake.recorded('setCookie');
      expect(calls, hasLength(1));
      expect(calls.single.args['url'], WebUri(_currentUrl));
      expect(calls.single.args['name'], 'x');
      expect(calls.single.args['value'], 'y');
    });

    test('U53 setCookie with explicit URL uses it and ignores current URL',
        () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri(_currentUrl);
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager();
      final cookies = _cookies(controller, cookieFake);
      final explicit = WebUri(_otherUrl);

      await cookies.setCookie(name: 'x', value: 'y', url: explicit);

      final calls = cookieFake.recorded('setCookie');
      expect(calls, hasLength(1));
      expect(calls.single.args['url'], explicit);
      expect(fake.recorded('getUrl'), isEmpty);
    });

    test('U54 setCookie with no URL available returns false (graceful)',
        () async {
      final fake = FakePlatformInAppWebViewController()..nextUrl = null;
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager();
      final cookies = _cookies(controller, cookieFake);

      final ok = await cookies.setCookie(name: 'x', value: 'y');

      expect(ok, isFalse);
      expect(cookieFake.recorded('setCookie'), isEmpty);
    });

    test('U55 deleteCookie without URL defers to getUrl()', () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri(_currentUrl);
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager();
      final cookies = _cookies(controller, cookieFake);

      final ok = await cookies.deleteCookie(name: 'x');

      expect(ok, isTrue);
      final calls = cookieFake.recorded('deleteCookie');
      expect(calls, hasLength(1));
      expect(calls.single.args['url'], WebUri(_currentUrl));
      expect(calls.single.args['name'], 'x');
    });

    test('U56 deleteCookie with explicit URL uses it and ignores current URL',
        () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri(_currentUrl);
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager();
      final cookies = _cookies(controller, cookieFake);
      final explicit = WebUri(_otherUrl);

      await cookies.deleteCookie(name: 'x', url: explicit);

      final calls = cookieFake.recorded('deleteCookie');
      expect(calls, hasLength(1));
      expect(calls.single.args['url'], explicit);
      expect(fake.recorded('getUrl'), isEmpty);
    });

    test('U57 deleteCookie with no URL available returns false (graceful)',
        () async {
      final fake = FakePlatformInAppWebViewController()..nextUrl = null;
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager();
      final cookies = _cookies(controller, cookieFake);

      final ok = await cookies.deleteCookie(name: 'x');

      expect(ok, isFalse);
      expect(cookieFake.recorded('deleteCookie'), isEmpty);
    });

    test('U58 deleteCookies without URL defers to getUrl()', () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri(_currentUrl);
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager();
      final cookies = _cookies(controller, cookieFake);

      final ok = await cookies.deleteCookies();

      expect(ok, isTrue);
      final calls = cookieFake.recorded('deleteCookies');
      expect(calls, hasLength(1));
      expect(calls.single.args['url'], WebUri(_currentUrl));
    });

    test('U59 deleteCookies with explicit URL uses it and ignores current URL',
        () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri(_currentUrl);
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager();
      final cookies = _cookies(controller, cookieFake);
      final explicit = WebUri(_otherUrl);

      await cookies.deleteCookies(url: explicit);

      final calls = cookieFake.recorded('deleteCookies');
      expect(calls, hasLength(1));
      expect(calls.single.args['url'], explicit);
      expect(fake.recorded('getUrl'), isEmpty);
    });

    test('U60 deleteCookies with no URL available returns false (graceful)',
        () async {
      final fake = FakePlatformInAppWebViewController()..nextUrl = null;
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager();
      final cookies = _cookies(controller, cookieFake);

      final ok = await cookies.deleteCookies();

      expect(ok, isFalse);
      expect(cookieFake.recorded('deleteCookies'), isEmpty);
    });

    test('U61 getAllCookies reads the shared store globally (not URL scoped)',
        () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri(_currentUrl);
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager()
        ..nextCookies = [
          Cookie(name: 'a', value: '1'),
          Cookie(name: 'b', value: '2'),
        ];
      final cookies = _cookies(controller, cookieFake);

      final result = await cookies.getAllCookies();

      expect(result, hasLength(2));
      expect(cookieFake.recorded('getAllCookies'), hasLength(1));
      expect(cookieFake.recorded('getCookies'), isEmpty);
    });

    test('U62 deleteAllCookies delegates to the shared store globally', () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri(_currentUrl);
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager();
      final cookies = _cookies(controller, cookieFake);

      final ok = await cookies.deleteAllCookies();

      expect(ok, isTrue);
      expect(cookieFake.recorded('deleteAllCookies'), hasLength(1));
    });

    test('U63 removeSessionCookies delegates to the shared store globally',
        () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri(_currentUrl);
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager();
      final cookies = _cookies(controller, cookieFake);

      final ok = await cookies.removeSessionCookies();

      expect(ok, isTrue);
      expect(cookieFake.recorded('removeSessionCookies'), hasLength(1));
    });

    test('U64 injected CookieManager override is used, singleton untouched',
        () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri(_currentUrl);
      final controller = _controller(fake);
      final cookieFake = FakePlatformCookieManager();
      final cookies = _cookies(controller, cookieFake);

      await cookies.setCookie(name: 'x', value: 'y');

      expect(cookieFake.recorded('setCookie'), hasLength(1));
      expect(_singletonFake.recorded('setCookie'), isEmpty);
    });

    test('U65 without override, CookieController lazily uses CookieManager.instance()',
        () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri(_currentUrl);
      final controller = _controller(fake);
      // No cookieManager override provided.
      final cookies = CookieController(controller);

      final result = await cookies.getCookies();

      expect(result, isEmpty); // singleton fake returns empty list
      final calls = _singletonFake.recorded('getCookies');
      expect(calls, hasLength(1));
      expect(calls.single.args['url'], WebUri(_currentUrl));
    });
  });
}
