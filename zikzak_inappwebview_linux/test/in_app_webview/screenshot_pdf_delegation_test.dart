import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_linux/src/in_app_webview/in_app_webview_controller.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Behavioral tests for spec 001 (Screenshot and PDF Export) on the Linux
/// package.
///
/// These prove delegation: [LinuxInAppWebViewController.createPdf] /
/// [LinuxInAppWebViewController.takeScreenshot] must forward to the method
/// channel with the identical configuration object and propagate the returned
/// bytes. The shared mock on the real channel name records each outgoing call
/// and returns a configurable value, mirroring the Android delegation test in
/// `zikzak_inappwebview_android/test/in_app_webview/android_screenshot_pdf_delegation_test.dart`.
///
/// The controller builds its own private `_channel` from `params.id`, so the
/// mock is registered on that exact channel name after construction. Because
/// [TestDefaultBinaryMessenger] mock handlers take precedence over a channel's
/// `setMethodCallHandler`, the outgoing `invokeMethod` calls are captured.

const String _kChannelName = 'dev.zuzu/zikzak_inappwebview_0';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LinuxInAppWebViewController screenshot/pdf delegation (spec 001)', () {
    late List<MethodCall> calls;
    late Uint8List? nextResult;

    LinuxInAppWebViewController _newController() {
      final controller = LinuxInAppWebViewController(
        PlatformInAppWebViewControllerCreationParams(id: 0),
      );
      TestDefaultBinaryMessengerBinding
          .instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel(_kChannelName),
        (call) async {
          calls.add(call);
          return nextResult;
        },
      );
      return controller;
    }

    setUp(() {
      calls = [];
      nextResult = null;
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding
          .instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel(_kChannelName),
        null,
      );
    });

    test('U25 createPdf delegates to channel with pdfConfiguration.toJson()',
        () async {
      final controller = _newController();
      final config = PDFConfiguration();

      await controller.createPdf(pdfConfiguration: config);

      expect(calls, hasLength(1),
          reason: 'createPdf must reach the method channel exactly once');
      expect(calls.single.method, equals('createPdf'),
          reason: 'the channel method must be the literal "createPdf"');
      expect(
        calls.single.arguments['pdfConfiguration'],
        equals(config.toJson()),
        reason: 'pdfConfiguration must be forwarded as its JSON map',
      );
    });

    test(
        'U26 takeScreenshot delegates to channel with screenshotConfiguration.toJson()',
        () async {
      final controller = _newController();
      final config = ScreenshotConfiguration();

      await controller.takeScreenshot(screenshotConfiguration: config);

      expect(calls, hasLength(1),
          reason: 'takeScreenshot must reach the method channel exactly once');
      expect(calls.single.method, equals('takeScreenshot'),
          reason: 'the channel method must be the literal "takeScreenshot"');
      expect(
        calls.single.arguments['screenshotConfiguration'],
        equals(config.toJson()),
        reason: 'screenshotConfiguration must be forwarded as its JSON map',
      );
    });

    test('U27 overrides return the channel Uint8List or null', () async {
      final controller = _newController();

      final bytes = Uint8List.fromList([10, 20, 30]);
      nextResult = bytes;
      final pdfResult = await controller.createPdf(pdfConfiguration: PDFConfiguration());
      expect(pdfResult, equals(bytes),
          reason: 'the Uint8List the channel returns must be propagated as-is');

      final shotResult =
          await controller.takeScreenshot(screenshotConfiguration: ScreenshotConfiguration());
      expect(shotResult, equals(bytes),
          reason: 'takeScreenshot must also propagate the channel Uint8List');

      nextResult = null;
      final nullPdf =
          await controller.createPdf(pdfConfiguration: PDFConfiguration());
      expect(nullPdf, isNull,
          reason: 'a null channel result must pass through as null');
      final nullShot = await controller
          .takeScreenshot(screenshotConfiguration: ScreenshotConfiguration());
      expect(nullShot, isNull,
          reason: 'a null channel result must pass through as null for both methods');
    });
  });
}
