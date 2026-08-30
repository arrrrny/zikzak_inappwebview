import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_android/zikzak_inappwebview_android.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Behavioral tests for spec 001 (Screenshot and PDF Export) on the Android
/// package.
///
/// These prove delegation: [AndroidInAppWebViewController.createPdf] /
/// [AndroidInAppWebViewController.takeScreenshot] must forward to the method
/// channel with the identical configuration object and propagate the returned
/// bytes. The shared [_FakeChannel] records each outgoing call and returns a
/// configurable value, mirroring the umbrella delegation test in
/// `zikzak_inappwebview/test/screenshot_pdf_delegation_test.dart`.
///
/// The controller is constructed with a real channel (so its constructor-side
/// `initMethodCallHandler` registration succeeds under the test binding), then
/// its `channel` is replaced with [_FakeChannel] to capture the outgoing
/// `invokeMethod` calls that the screenshot/pdf methods make.

class _FakeChannel extends MethodChannel {
  _FakeChannel() : super('fake.screenshot.pdf');

  final List<MethodCall> calls = [];
  dynamic nextResult;

  @override
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) async {
    calls.add(MethodCall(method, arguments));
    return nextResult as T?;
  }

  @override
  void setMethodCallHandler(Future<dynamic> Function(MethodCall call)? handler) {
    // Delegation tests drive outgoing calls only; ignore incoming handlers.
  }
}

AndroidInAppWebViewController _newController(_FakeChannel channel) {
  final controller = AndroidInAppWebViewController(
    AndroidInAppWebViewControllerCreationParams(id: null),
  );
  // Replace the real channel with the recording fake before any method call.
  controller.channel = channel;
  return controller;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AndroidInAppWebViewController screenshot/pdf delegation (spec 001)', () {
    test('U16 createPdf delegates to channel with pdfConfiguration.toJson()',
        () async {
      final fake = _FakeChannel();
      final controller = _newController(fake);
      final config = PDFConfiguration();

      await controller.createPdf(pdfConfiguration: config);

      expect(fake.calls, hasLength(1),
          reason: 'createPdf must reach the method channel exactly once');
      expect(fake.calls.single.method, equals('createPdf'),
          reason: 'the channel method must be the literal "createPdf"');
      expect(
        fake.calls.single.arguments['pdfConfiguration'],
        equals(config.toJson()),
        reason: 'pdfConfiguration must be forwarded as its JSON map',
      );
    });

    test('U17 createPdf returns the channel Uint8List or null', () async {
      final fake = _FakeChannel();
      final controller = _newController(fake);

      final bytes = Uint8List.fromList([10, 20, 30]);
      fake.nextResult = bytes;
      final result = await controller.createPdf(pdfConfiguration: PDFConfiguration());
      expect(result, equals(bytes),
          reason: 'the Uint8List the channel returns must be propagated as-is');

      fake.nextResult = null;
      final nullResult =
          await controller.createPdf(pdfConfiguration: PDFConfiguration());
      expect(nullResult, isNull,
          reason: 'a null channel result must pass through as null');
    });

    test(
        'U41 Android takeScreenshot delegates screenshotConfiguration and returns the channel bytes or null',
        () async {
      final fake = _FakeChannel();
      final controller = _newController(fake);
      final config = ScreenshotConfiguration();

      await controller.takeScreenshot(screenshotConfiguration: config);

      expect(fake.calls, hasLength(1),
          reason: 'takeScreenshot must reach the method channel exactly once');
      expect(fake.calls.single.method, equals('takeScreenshot'),
          reason: 'the channel method must be the literal "takeScreenshot"');
      expect(
        fake.calls.single.arguments['screenshotConfiguration'],
        equals(config.toJson()),
        reason: 'screenshotConfiguration must be forwarded as its JSON map',
      );

      final bytes = Uint8List.fromList([7, 8, 9]);
      fake.nextResult = bytes;
      final result =
          await controller.takeScreenshot(screenshotConfiguration: ScreenshotConfiguration());
      expect(result, equals(bytes),
          reason: 'the Uint8List the channel returns must be propagated as-is');

      fake.nextResult = null;
      final nullResult = await controller
          .takeScreenshot(screenshotConfiguration: ScreenshotConfiguration());
      expect(nullResult, isNull,
          reason: 'a null channel result must pass through as null');
    });
  });
}
