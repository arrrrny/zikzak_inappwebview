import 'dart:js_interop';

import 'package:flutter_test/flutter_test.dart';
import 'package:web/web.dart' as web;
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_web/src/in_app_webview_web_controller.dart';

/// Behavioral tests for spec 001 (Screenshot and PDF Export) on the Web package.
///
/// Web screenshot/pdf are explicitly out of scope per `spec.md`, so the Dart
/// overrides are stubs that return null. This test locks that contract: calling
/// the override must complete and return null without throwing.

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InAppWebViewWebController screenshot/pdf stubs (spec 001)', () {
    test('U39 takeScreenshot returns null without throwing', () async {
      final controller = InAppWebViewWebController(
        PlatformInAppWebViewControllerCreationParams(id: 0),
        web.HTMLIFrameElement(),
      );
      addTearDown(controller.dispose);

      await expectLater(
        controller.takeScreenshot(),
        completion(isNull),
      );
    });
  });
}
