import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../src/fake_platform_controller.dart';
import '../src/fake_cookie_manager.dart';

/// Acceptance tests for spec 011 (Split InAppWebViewController into
/// Domain-Specific Controllers).
///
/// These artifacts close the A1–A5 acceptance criteria by driving the real
/// public entry point — an [InAppWebViewController] constructed through
/// [InAppWebViewController.fromPlatform] exactly as a consumer package would —
/// and asserting that the cross-domain surface (monolith methods) and the
/// domain facades (`navigation`, `javaScript`, `cookies`, `settings`) behave
/// identically against the platform. A6 (runtime non-null platform delegates on
/// a real Android/iOS device) is environment-gated and tracked separately.
///
/// Convention match: reuses the recording [FakePlatformInAppWebViewController]
/// and [FakePlatformCookieManager] from `test/src/*` and the same
/// `recorded(name)` assertion style as the behavioral suites.

/// Minimal platform whose cookie-manager factory returns a controllable fake,
/// so the un-injected `CookieManager.instance()` path used by the default
/// `controller.cookies` getter resolves deterministically.
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

void main() {
  // Shared fake cookie manager backing the default `controller.cookies` getter.
  final cookieFake = FakePlatformCookieManager();
  setUpAll(() {
    InAppWebViewPlatform.instance = _TestPlatform(cookieFake);
  });
  tearDown(() {
    cookieFake.calls.clear();
  });

  group('A1 backward compatibility: monolithic surface unchanged', () {
    test('A1 existing consumer code calling monolith methods compiles and routes '
        'to the platform identically after the split', () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri('https://example.com/a1');
      final controller = _controller(fake);

      // A consumer calls the grouped methods directly on the monolith, exactly
      // as before the split.
      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri('https://example.com/a1')),
      );
      await controller.evaluateJavascript(source: '1+1');
      await controller.reload();
      final url = await controller.getUrl();

      // Results are identical to the pre-split behavior: each call reaches the
      // platform exactly once with the same arguments.
      expect(fake.recorded('loadUrl'), hasLength(1));
      expect(fake.recorded('evaluateJavascript'), hasLength(1));
      expect(fake.recorded('reload'), hasLength(1));
      expect(url, WebUri('https://example.com/a1'));
    });

    test('A1 public surface is unchanged: all cross-domain entry points exist',
        () async {
      final controller = _controller(FakePlatformInAppWebViewController());

      expect(controller.loadUrl, isA<Function>());
      expect(controller.getUrl, isA<Function>());
      expect(controller.evaluateJavascript, isA<Function>());
      expect(controller.getSettings, isA<Function>());
      expect(controller.cookies, isA<CookieController>());
      expect(controller.navigation, isA<NavigationController>());
      expect(controller.javaScript, isA<JavaScriptController>());
      expect(controller.settings, isA<SettingsController>());
    });
  });

  group('A2 navigation facade equivalence', () {
    test('A2 controller.navigation.* produces identical platform calls as the '
        'monolithic method', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);
      final urlRequest = URLRequest(url: WebUri('https://example.com/a2'));

      // Facade path.
      await controller.navigation.loadUrl(urlRequest: urlRequest);
      // Monolith path.
      await controller.loadUrl(urlRequest: urlRequest);

      final calls = fake.recorded('loadUrl');
      expect(calls, hasLength(2));
      expect(calls[0].args['urlRequest'], urlRequest);
      expect(calls[1].args['urlRequest'], urlRequest);
    });
  });

  group('A3 JavaScript facade equivalence', () {
    test('A3 controller.javaScript.* produces identical platform calls as the '
        'monolithic method', () async {
      final fake = FakePlatformInAppWebViewController()..nextEvaluate = 2;
      final controller = _controller(fake);

      final viaFacade =
          await controller.javaScript.evaluateJavascript(source: '1+1');
      final viaMonolith =
          await controller.evaluateJavascript(source: '1+1');

      expect(viaFacade, 2);
      expect(viaMonolith, 2);
      final calls = fake.recorded('evaluateJavascript');
      expect(calls, hasLength(2));
      expect(calls.every((c) => c.args['source'] == '1+1'), isTrue);
    });
  });

  group('A4 cookie facade default-to-current-URL semantics', () {
    test('A4 controller.cookies.getCookies() defers to current URL and resolves '
        'via the shared CookieManager', () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri('https://example.com/a4');
      final controller = _controller(fake);
      cookieFake.nextCookies = [Cookie(name: 'a', value: '1')];

      final result = await controller.cookies.getCookies();

      expect(result, hasLength(1));
      expect(result.single.name, 'a');
      final calls = cookieFake.recorded('getCookies');
      expect(calls, hasLength(1));
      expect(calls.single.args['url'], WebUri('https://example.com/a4'));
      expect(calls.single.args['webViewController'], same(fake));
    });
  });

  group('A5 settings facade equivalence', () {
    test('A5 controller.settings.* produces identical platform calls as the '
        'monolithic method', () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextSettings = InAppWebViewSettings();
      final controller = _controller(fake);
      final settings = InAppWebViewSettings(useOnLoadResource: true);

      // Facade read/write.
      await controller.settings.setSettings(settings: settings);
      await controller.settings.getSettings();
      // Monolith read/write.
      await controller.setSettings(settings: settings);
      await controller.getSettings();

      expect(fake.recorded('setSettings'), hasLength(2));
      expect(fake.recorded('getSettings'), hasLength(2));
      expect(
        fake.recorded('setSettings').every((c) => c.args['settings'] == settings),
        isTrue,
      );
    });
  });
}
