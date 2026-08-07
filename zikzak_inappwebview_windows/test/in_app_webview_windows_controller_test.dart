import 'package:flutter_test/flutter_test.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_windows/src/in_app_webview_windows_controller.dart';

/// Constructs a Windows controller backed by a real (but uninitialized)
/// [WebviewController]. The handler-map operations exercised below never
/// touch the platform channel, so this is safe to run on the Dart VM.
InAppWebViewWindowsController _buildController() {
  final params = PlatformInAppWebViewControllerCreationParams(id: 0);
  return InAppWebViewWindowsController(params, WebviewController());
}

void main() {
  group('addJavaScriptHandler', () {
    test('registers a handler that hasJavaScriptHandler reports', () {
      final controller = _buildController();
      addTearDown(controller.dispose);

      controller.addJavaScriptHandler(
        handlerName: 'testHandler',
        callback: (args) => 'ok: ${args.length}',
      );

      expect(controller.hasJavaScriptHandler(handlerName: 'testHandler'), true);
    });

    test('does not throw UnimplementedError (regression for issue #177)', () {
      final controller = _buildController();
      addTearDown(controller.dispose);

      // The defining symptom of issue #177 was that this call threw
      // UnimplementedError because the Windows controller did not override
      // addJavaScriptHandler. It must now complete synchronously without
      // throwing.
      expect(
        () => controller.addJavaScriptHandler(
          handlerName: 'noThrow',
          callback: (args) => null,
        ),
        returnsNormally,
      );
    });
  });

  group('hasJavaScriptHandler', () {
    test('returns false for an unregistered handler', () {
      final controller = _buildController();
      addTearDown(controller.dispose);

      expect(
        controller.hasJavaScriptHandler(handlerName: 'missing'),
        false,
      );
    });
  });

  group('removeJavaScriptHandler', () {
    test('returns the previously registered callback and clears the slot', () {
      final controller = _buildController();
      addTearDown(controller.dispose);

      dynamic received(List<dynamic> args) => 'pong';
      controller.addJavaScriptHandler(
        handlerName: 'ping',
        callback: received,
      );

      final removed = controller.removeJavaScriptHandler(handlerName: 'ping');
      expect(identical(removed, received), true);
      expect(controller.hasJavaScriptHandler(handlerName: 'ping'), false);
    });

    test('returns null when removing an unknown handler', () {
      final controller = _buildController();
      addTearDown(controller.dispose);

      expect(
        controller.removeJavaScriptHandler(handlerName: 'unknown'),
        isNull,
      );
    });
  });

  group('forbidden handler names', () {
    test('asserts when registering a reserved name', () {
      final controller = _buildController();
      addTearDown(controller.dispose);

      // The Windows controller must reject the same reserved names used by
      // the Android / iOS / macOS / Linux implementations so users cannot
      // shadow internal handlers.
      expect(
        () => controller.addJavaScriptHandler(
          handlerName: 'onLoadResource',
          callback: (args) => null,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('bridge idempotency', () {
    test('registers multiple handlers without re-installing the bridge', () {
      final controller = _buildController();
      addTearDown(controller.dispose);

      controller.addJavaScriptHandler(
        handlerName: 'first',
        callback: (args) => null,
      );
      // A second registration must be cheap and must not throw even though
      // the underlying WebviewController is not initialized on this platform.
      controller.addJavaScriptHandler(
        handlerName: 'second',
        callback: (args) => null,
      );

      expect(controller.hasJavaScriptHandler(handlerName: 'first'), true);
      expect(controller.hasJavaScriptHandler(handlerName: 'second'), true);
    });
  });
}
