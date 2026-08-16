// Tests for ProcessGlobalConfig — the process-global WebView configuration
// (Android). Verifies the singleton + apply delegation to the platform
// implementation.
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

class _FakeProcessGlobalConfig extends PlatformProcessGlobalConfig {
  _FakeProcessGlobalConfig() : super.implementation(
          const PlatformProcessGlobalConfigCreationParams(),
        );

  ProcessGlobalConfigSettings? lastSettings;
  int applyCount = 0;

  @override
  Future<void> apply({required ProcessGlobalConfigSettings settings}) async {
    lastSettings = settings;
    applyCount++;
  }

  @override
  void dispose({bool isKeepAlive = false}) {}
}

void main() {
  group('ProcessGlobalConfig', () {
    test('apply delegates to the platform implementation', () async {
      final fake = _FakeProcessGlobalConfig();
      final config = ProcessGlobalConfig.fromPlatform(fake);
      final settings = ProcessGlobalConfigSettings(
        dataDirectorySuffix: 'my-suffix',
      );
      await config.apply(settings: settings);
      expect(fake.applyCount, 1);
      expect(fake.lastSettings?.dataDirectorySuffix, 'my-suffix');
    });
  });
}
