// Tests for ProxyController + TracingController — thin core wrappers over
// their platform controllers. Verifies arg passthrough (ProxySettings →
// platform, TracingSettings + filePath → platform) and result propagation
// with fake platforms (conformance for the zuraffa-only rewrite).
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

class _FakePlatformProxyController extends PlatformProxyController {
  _FakePlatformProxyController() : super.implementation(
          const PlatformProxyControllerCreationParams(),
        );

  ProxySettings? lastSettings;
  int setOverrideCount = 0;
  int clearOverrideCount = 0;

  @override
  Future<void> setProxyOverride({required ProxySettings settings}) async {
    lastSettings = settings;
    setOverrideCount++;
  }

  @override
  Future<void> clearProxyOverride() async {
    clearOverrideCount++;
  }

  @override
  void dispose({bool isKeepAlive = false}) {}
}

class _FakePlatformTracingController extends PlatformTracingController {
  _FakePlatformTracingController() : super.implementation(
          const PlatformTracingControllerCreationParams(),
        );

  TracingSettings? lastSettings;
  String? lastFilePath;
  bool stopResult = true;

  @override
  Future<void> start({required TracingSettings settings}) async {
    lastSettings = settings;
  }

  @override
  Future<bool> stop({String? filePath}) async {
    lastFilePath = filePath;
    return stopResult;
  }

  @override
  void dispose({bool isKeepAlive = false}) {}
}

void main() {
  group('ProxyController', () {
    test('setProxyOverride forwards the settings object', () async {
      final fake = _FakePlatformProxyController();
      final controller = ProxyController.fromPlatform(fake);
      final settings = ProxySettings(
        androidProxySettings: AndroidProxySettings(
          bypassRules: ['*example.com'],
          bypassSimpleHostnames: true,
        ),
        iOSProxySettings: IOSProxySettings(
          proxyUrl: 'https://proxy.dev:8080',
          allowFailover: true,
        ),
      );
      await controller.setProxyOverride(settings: settings);
      expect(fake.setOverrideCount, 1);
      expect(fake.lastSettings, same(settings));
      expect(fake.lastSettings?.androidProxySettings?.bypassRules,
          ['*example.com']);
      expect(fake.lastSettings?.iOSProxySettings?.proxyUrl,
          'https://proxy.dev:8080');
    });

    test('clearProxyOverride delegates', () async {
      final fake = _FakePlatformProxyController();
      final controller = ProxyController.fromPlatform(fake);
      await controller.clearProxyOverride();
      expect(fake.clearOverrideCount, 1);
    });

    test('AndroidProxySettings + IOSProxySettings wire', () {
      final android = AndroidProxySettings(
        bypassRules: ['*example.com'],
        bypassSimpleHostnames: true,
      );
      expect(android.toJson(), {
        'bypassRules': ['*example.com'],
        'directs': [],
        'proxyRules': [],
        'bypassSimpleHostnames': true,
        'removeImplicitRules': null,
        'reverseBypassEnabled': false,
      });

      final ios = IOSProxySettings(
        proxyUrl: 'http://proxy.dev:8080',
        allowFailover: true,
        excludedDomains: ['a.dev'],
        matchDomains: ['b.dev'],
      );
      expect(ios.toJson(), {
        'proxyUrl': 'http://proxy.dev:8080',
        'allowFailover': true,
        'excludedDomains': ['a.dev'],
        'matchDomains': ['b.dev'],
      });
    });
  });

  group('TracingController', () {
    test('start forwards the settings; stop forwards the file path', () async {
      final fake = _FakePlatformTracingController();
      final controller = TracingController.fromPlatform(fake);
      final settings = TracingSettings(
        categories: [
          TracingCategory.CATEGORIES_ANDROID_WEBVIEW,
          TracingCategory.CATEGORIES_RENDERING,
        ],
        tracingMode: TracingMode.RECORD_CONTINUOUSLY,
      );
      await controller.start(settings: settings);
      expect(fake.lastSettings, same(settings));
      expect(await controller.stop(filePath: '/tmp/trace.json'), true);
      expect(fake.lastFilePath, '/tmp/trace.json');
    });
  });
}
