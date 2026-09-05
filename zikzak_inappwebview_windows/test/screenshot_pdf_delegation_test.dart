import 'package:flutter_test/flutter_test.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_windows/src/in_app_webview_windows_controller.dart';

/// Behavioral tests for spec 001 (Screenshot and PDF Export) on the Windows
/// package.
///
/// Windows screenshot/pdf are explicitly out of scope per `spec.md`, so the Dart
/// overrides are stubs that return null. These tests lock that contract: calling
/// the override must complete and return null without throwing a
/// [UnimplementedError] or touching a platform channel. This mirrors the
/// green-on-first-run characterization style used for the Android/Linux
/// delegation tests.

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InAppWebViewWindowsController screenshot/pdf stubs (spec 001)', () {
    test('U38 takeScreenshot returns null without throwing', () async {
      final controller = InAppWebViewWindowsController(
        PlatformInAppWebViewControllerCreationParams(id: 0),
        WebviewController(),
      );
      addTearDown(controller.dispose);

      // takeScreenshot on Windows is a stub: it must complete and return null
      // rather than throw (regression guard against issue #177-style gaps).
      await expectLater(controller.takeScreenshot(), completion(isNull));
    });
  });
}
