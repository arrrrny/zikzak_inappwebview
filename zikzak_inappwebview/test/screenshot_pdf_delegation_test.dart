import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'package:zikzak_inappwebview/src/in_app_webview/apple/in_app_webview_controller.dart';

import 'src/fake_platform_controller.dart';

/// Behavioral tests for spec 001 (Screenshot and PDF Export).
///
/// These prove delegation: `InAppWebViewController.takeScreenshot` /
/// `createPdf` must forward to the platform interface with the identical
/// configuration object and propagate the returned bytes. The shared
/// [FakePlatformInAppWebViewController] records each call so delegation is
/// observable, mirroring the pattern in `domain_controllers_behavioral_test.dart`.

void main() {
  group('InAppWebViewController screenshot/pdf delegation (spec 001)', () {
    test('U6 takeScreenshot delegates to platform with the screenshotConfiguration',
        () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = InAppWebViewController.fromPlatform(platform: fake);
      final config = ScreenshotConfiguration();

      await controller.takeScreenshot(screenshotConfiguration: config);

      final calls = fake.recorded('takeScreenshot');
      expect(calls, hasLength(1),
          reason: 'takeScreenshot must reach the platform exactly once');
      expect(calls.single.args['screenshotConfiguration'], same(config),
          reason: 'the same ScreenshotConfiguration object must be forwarded');
    });

    test('U7 takeScreenshot returns the platform Uint8List or null', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = InAppWebViewController.fromPlatform(platform: fake);

      final bytes = Uint8List.fromList([1, 2, 3, 4]);
      fake.nextBytes = bytes;
      final result = await controller
          .takeScreenshot(screenshotConfiguration: ScreenshotConfiguration());
      expect(result, equals(bytes),
          reason: 'the Uint8List the platform returns must be propagated as-is');

      fake.nextBytes = null;
      final nullResult = await controller
          .takeScreenshot(screenshotConfiguration: ScreenshotConfiguration());
      expect(nullResult, isNull,
          reason: 'a null platform result must pass through as null');
    });

    test(
        'U34 deprecated IOSInAppWebViewController forwards takeScreenshot to its platform controller',
        () async {
      final fake = FakePlatformInAppWebViewController();
      final deprecated = IOSInAppWebViewController(controller: fake);
      final config = ScreenshotConfiguration();

      await deprecated.takeScreenshot(screenshotConfiguration: config);

      final calls = fake.recorded('takeScreenshot');
      expect(calls, hasLength(1),
          reason: 'the deprecated facade must reach the platform exactly once');
      expect(calls.single.args['screenshotConfiguration'], same(config),
          reason: 'the same ScreenshotConfiguration object must be forwarded');
    });
  });
}
