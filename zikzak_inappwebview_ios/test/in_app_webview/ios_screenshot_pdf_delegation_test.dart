import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_ios/zikzak_inappwebview_ios.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Behavioral tests for spec 001 (Screenshot and PDF Export) on the iOS package.
///
/// These prove delegation and error propagation for
/// [IOSInAppWebViewController.createPdf]. The shared [_FakeChannel] records each
/// outgoing call and can throw a configured error, mirroring the Android
/// delegation test in `zikzak_inappwebview_android/test/in_app_webview/
/// android_screenshot_pdf_delegation_test.dart`.
///
/// The controller is constructed with a real channel (so its constructor-side
/// `initMethodCallHandler` registration succeeds under the test binding), then
/// its `channel` is replaced with [_FakeChannel] to drive outgoing calls.

class _FakeChannel extends MethodChannel {
  _FakeChannel() : super('fake.screenshot.pdf.ios');

  final List<MethodCall> calls = [];
  dynamic nextResult;
  Object? nextError;

  @override
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) async {
    calls.add(MethodCall(method, arguments));
    if (nextError != null) {
      throw nextError!;
    }
    return nextResult as T?;
  }

  @override
  void setMethodCallHandler(Future<dynamic> Function(MethodCall call)? handler) {
    // Delegation tests drive outgoing calls only; ignore incoming handlers.
  }
}

IOSInAppWebViewController _newController(_FakeChannel channel) {
  final controller = IOSInAppWebViewController(
    IOSInAppWebViewControllerCreationParams(id: null),
  );
  // Replace the real channel with the recording fake before any method call.
  controller.channel = channel;
  return controller;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IOSInAppWebViewController screenshot/pdf delegation (spec 001)', () {
    test(
        'U44 createPdf propagates a clear UNSUPPORTED_IOS_VERSION error instead '
        'of silently returning null', () async {
      final fake = _FakeChannel();
      final controller = _newController(fake);

      fake.nextError = PlatformException(
        code: 'UNSUPPORTED_IOS_VERSION',
        message: 'createPdf requires iOS 14.0 or later',
      );

      await expectLater(
        () => controller.createPdf(pdfConfiguration: PDFConfiguration()),
        throwsA(
          isA<PlatformException>()
              .having((e) => e.code, 'code', 'UNSUPPORTED_IOS_VERSION')
              .having(
                (e) => e.message,
                'message',
                contains('iOS 14.0'),
              ),
        ),
        reason: 'createPdf must surface the native clear error rather than '
            'swallowing it into a null return',
      );
    });
  });
}
