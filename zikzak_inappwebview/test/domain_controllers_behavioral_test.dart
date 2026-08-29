import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'src/fake_platform_controller.dart';

/// Behavioral tests for the domain controller split (spec 011).
///
/// These prove delegation: a facade method must forward to the parent
/// [InAppWebViewController] and ultimately to the platform with identical
/// arguments and return value. The [FakePlatformInAppWebViewController] records
/// each call so delegation is observable (the compile-probe tests in
/// `domain_controllers_test.dart` only verify symbols exist).

InAppWebViewController _controller(FakePlatformInAppWebViewController fake) =>
    InAppWebViewController.fromPlatform(platform: fake);

/// Spy facades that count how many times the monolith routed a call *through*
/// the domain facade. Used by the U5–U9 monolith-delegation tests: if a monolith
/// method calls `platform.xxx()` directly it bypasses the facade and the counter
/// stays at 0, proving (when the assertion expects 1) that delegation happens.
class _SpyNavigationController extends NavigationController {
  _SpyNavigationController(super.controller);
  int loadUrlCount = 0;
  int getUrlCount = 0;
  int reloadCount = 0;

  @override
  Future<void> loadUrl({
    required URLRequest urlRequest,
    WebUri? allowingReadAccessTo,
  }) {
    loadUrlCount++;
    return super.loadUrl(
      urlRequest: urlRequest,
      allowingReadAccessTo: allowingReadAccessTo,
    );
  }

  @override
  Future<WebUri?> getUrl() {
    getUrlCount++;
    return super.getUrl();
  }

  @override
  Future<void> reload() {
    reloadCount++;
    return super.reload();
  }
}

class _SpyJavaScriptController extends JavaScriptController {
  _SpyJavaScriptController(super.controller);
  int evaluateCount = 0;

  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) {
    evaluateCount++;
    return super.evaluateJavascript(source: source, contentWorld: contentWorld);
  }
}

class _SpySettingsController extends SettingsController {
  _SpySettingsController(super.controller);
  int getSettingsCount = 0;

  @override
  Future<InAppWebViewSettings?> getSettings() {
    getSettingsCount++;
    return super.getSettings();
  }
}

class _SpyMonolith extends InAppWebViewController {
  late final _SpyNavigationController _nav;
  late final _SpyJavaScriptController _js;
  late final _SpySettingsController _settings;

  _SpyMonolith(FakePlatformInAppWebViewController platform)
      : super.fromPlatform(platform: platform) {
    _nav = _SpyNavigationController(this);
    _js = _SpyJavaScriptController(this);
    _settings = _SpySettingsController(this);
  }

  @override
  NavigationController get navigation => _nav;
  @override
  JavaScriptController get javaScript => _js;
  @override
  SettingsController get settings => _settings;
}

void main() {
  group('NavigationController delegates to parent (U10-U28)', () {
    test('U10 loadUrl delegates to parent with identical arguments', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);
      final urlRequest = URLRequest(url: WebUri('https://example.com'));
      final access = WebUri('https://assets.example.com');

      await controller.navigation.loadUrl(
        urlRequest: urlRequest,
        allowingReadAccessTo: access,
      );

      final calls = fake.recorded('loadUrl');
      expect(calls, hasLength(1));
      expect(calls.single.args['urlRequest'], urlRequest);
      expect(calls.single.args['allowingReadAccessTo'], access);
    });

    test('U11 postUrl delegates to parent with identical arguments', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);
      final url = WebUri('https://example.com');
      final postData = Uint8List.fromList([1, 2, 3]);

      await controller.navigation.postUrl(url: url, postData: postData);

      final calls = fake.recorded('postUrl');
      expect(calls, hasLength(1));
      expect(calls.single.args['url'], url);
      expect(calls.single.args['postData'], postData);
    });

    test('U12 loadData delegates to parent with identical arguments', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);
      final urlRequest = WebUri('https://example.com');

      await controller.navigation.loadData(
        data: '<html></html>',
        mimeType: 'text/html',
        encoding: 'utf8',
        baseUrl: urlRequest,
        historyUrl: urlRequest,
        allowingReadAccessTo: urlRequest,
      );

      final calls = fake.recorded('loadData');
      expect(calls, hasLength(1));
      final args = calls.single.args;
      expect(args['data'], '<html></html>');
      expect(args['mimeType'], 'text/html');
      expect(args['encoding'], 'utf8');
      expect(args['baseUrl'], urlRequest);
      expect(args['historyUrl'], urlRequest);
      expect(args['allowingReadAccessTo'], urlRequest);
    });

    test('U13 loadFile delegates to parent with identical argument', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);

      await controller.navigation.loadFile(assetFilePath: 'assets/page.html');

      final calls = fake.recorded('loadFile');
      expect(calls, hasLength(1));
      expect(calls.single.args['assetFilePath'], 'assets/page.html');
    });

    test('U14 loadSimulatedRequest delegates to parent identically', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);
      final urlRequest = URLRequest(url: WebUri('https://example.com'));
      final data = Uint8List.fromList([9, 9]);
      final response = URLResponse(
        url: WebUri('https://example.com'),
        expectedContentLength: 0,
      );

      await controller.navigation.loadSimulatedRequest(
        urlRequest: urlRequest,
        data: data,
        urlResponse: response,
      );

      final calls = fake.recorded('loadSimulatedRequest');
      expect(calls, hasLength(1));
      final args = calls.single.args;
      expect(args['urlRequest'], urlRequest);
      expect(args['data'], data);
      // NOTE: the monolithic controller drops urlResponse before reaching the
      // platform, so the facade inherits that behavior (FR-005: identical to the
      // monolithic method). The argument is therefore forwarded to the parent
      // but not to the platform call.
      expect(args['urlResponse'], isNull);
    });

    test('U15 reload delegates to parent', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);

      await controller.navigation.reload();

      expect(fake.recorded('reload'), hasLength(1));
    });

    test('U16 reloadFromOrigin delegates to parent', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);

      await controller.navigation.reloadFromOrigin();

      expect(fake.recorded('reloadFromOrigin'), hasLength(1));
    });

    test('U17 stopLoading delegates to parent', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);

      await controller.navigation.stopLoading();

      expect(fake.recorded('stopLoading'), hasLength(1));
    });

    test('U18 isLoading delegates to parent and returns same value', () async {
      final fake = FakePlatformInAppWebViewController()..nextBool = false;
      final controller = _controller(fake);

      expect(await controller.navigation.isLoading(), isFalse);
      expect(fake.recorded('isLoading'), hasLength(1));
    });

    test('U19 goBack delegates to parent', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);

      await controller.navigation.goBack();

      expect(fake.recorded('goBack'), hasLength(1));
    });

    test('U20 goForward delegates to parent', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);

      await controller.navigation.goForward();

      expect(fake.recorded('goForward'), hasLength(1));
    });

    test('U21 goBackOrForward delegates to parent with same steps', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);

      await controller.navigation.goBackOrForward(steps: -3);

      final calls = fake.recorded('goBackOrForward');
      expect(calls, hasLength(1));
      expect(calls.single.args['steps'], -3);
    });

    test('U22 canGoBack delegates to parent and returns same value', () async {
      final fake = FakePlatformInAppWebViewController()..nextBool = false;
      final controller = _controller(fake);

      expect(await controller.navigation.canGoBack(), isFalse);
      expect(fake.recorded('canGoBack'), hasLength(1));
    });

    test('U23 canGoForward delegates to parent and returns same value', () async {
      final fake = FakePlatformInAppWebViewController()..nextBool = true;
      final controller = _controller(fake);

      expect(await controller.navigation.canGoForward(), isTrue);
      expect(fake.recorded('canGoForward'), hasLength(1));
    });

    test('U24 canGoBackOrForward delegates to parent with same steps', () async {
      final fake = FakePlatformInAppWebViewController()..nextBool = true;
      final controller = _controller(fake);

      expect(await controller.navigation.canGoBackOrForward(steps: 5), isTrue);
      final calls = fake.recorded('canGoBackOrForward');
      expect(calls, hasLength(1));
      expect(calls.single.args['steps'], 5);
    });

    test('U25 goTo delegates to parent with same history item', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);
      final item = WebHistoryItem(url: WebUri('https://example.com'));

      await controller.navigation.goTo(historyItem: item);

      final calls = fake.recorded('goTo');
      expect(calls, hasLength(1));
      expect(calls.single.args['historyItem'], item);
    });

    test('U26 getCopyBackForwardList delegates to parent and returns same',
        () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);

      expect(await controller.navigation.getCopyBackForwardList(), isNull);
      expect(fake.recorded('getCopyBackForwardList'), hasLength(1));
    });

    test('U27 clearHistory delegates to parent', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);

      await controller.navigation.clearHistory();

      expect(fake.recorded('clearHistory'), hasLength(1));
    });

    test('U28 getUrl delegates to parent and returns same URL', () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri('https://example.com/page');
      final controller = _controller(fake);

      expect(await controller.navigation.getUrl(),
          WebUri('https://example.com/page'));
      expect(fake.recorded('getUrl'), hasLength(1));
    });
  });

  group('SettingsController delegates to parent (U66-U67)', () {
    test('U66 getSettings delegates to parent and returns same value', () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextSettings = InAppWebViewSettings();
      final controller = _controller(fake);

      expect(await controller.settings.getSettings(),
          isA<InAppWebViewSettings>());
      expect(fake.recorded('getSettings'), hasLength(1));
    });

    test('U67 setSettings delegates to parent with identical settings', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);
      final settings = InAppWebViewSettings(useOnLoadResource: true);

      await controller.settings.setSettings(settings: settings);

      final calls = fake.recorded('setSettings');
      expect(calls, hasLength(1));
      expect(calls.single.args['settings'], settings);
    });
  });

  group('Monolith delegates to domain facades (U5-U9)', () {
    test('U5 navigation methods hop through the navigation facade', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _SpyMonolith(fake);
      final urlRequest = URLRequest(url: WebUri('https://example.com'));

      await controller.loadUrl(urlRequest: urlRequest);
      await controller.getUrl();
      await controller.reload();

      expect(controller._nav.loadUrlCount, 1,
          reason: 'monolith.loadUrl must route through navigation facade');
      expect(controller._nav.getUrlCount, 1,
          reason: 'monolith.getUrl must route through navigation facade');
      expect(controller._nav.reloadCount, 1,
          reason: 'monolith.reload must route through navigation facade');
      // Each still reaches the platform exactly once with identical args.
      expect(fake.recorded('loadUrl'), hasLength(1));
      expect(fake.recorded('loadUrl').single.args['urlRequest'], urlRequest);
      expect(fake.recorded('getUrl'), hasLength(1));
      expect(fake.recorded('reload'), hasLength(1));
    });

    test('U6 JavaScript methods hop through the javaScript facade', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _SpyMonolith(fake);

      await controller.evaluateJavascript(source: '1+1');

      expect(controller._js.evaluateCount, 1,
          reason: 'monolith.evaluateJavascript must route through javaScript facade');
      expect(fake.recorded('evaluateJavascript'), hasLength(1));
      expect(fake.recorded('evaluateJavascript').single.args['source'], '1+1');
    });

    test('U8 settings methods hop through the settings facade', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _SpyMonolith(fake);

      await controller.getSettings();

      expect(controller._settings.getSettingsCount, 1,
          reason: 'monolith.getSettings must route through settings facade');
      expect(fake.recorded('getSettings'), hasLength(1));
    });

    test('U7 cookie operations are exposed only via the cookies facade, '
        'not as monolith methods', () async {
      // The monolith does not (and should not) carry cookie methods directly;
      // they live on the `cookies` facade. The facade call below compiles only
      // because `cookies` exists; a `controller.getCookies(...)` would not.
      final fake = FakePlatformInAppWebViewController();
      final controller = _SpyMonolith(fake);

      final cookies = await controller.cookies.getCookies();
      expect(cookies, isEmpty);
    });

    test('U9 public method surface is unchanged: monolith still exposes the '
        'full cross-domain surface and behaves identically', () async {
      final fake = FakePlatformInAppWebViewController()
        ..nextUrl = WebUri('https://example.com/u9');
      final controller = _controller(fake);

      // Navigation, JS and settings entry points all present on the monolith.
      expect(controller.loadUrl, isA<Function>());
      expect(controller.evaluateJavascript, isA<Function>());
      expect(controller.getSettings, isA<Function>());
      expect(controller.getUrl, isA<Function>());

      // And each still produces identical platform results.
      expect(await controller.getUrl(), WebUri('https://example.com/u9'));
      expect(fake.recorded('getUrl'), hasLength(1));
    });
  });
}
