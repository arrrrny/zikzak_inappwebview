import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_macos/src/in_app_webview/in_app_webview_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MacOSInAppWebViewController controller;

  setUp(() {
    final widgetParams = PlatformInAppWebViewWidgetCreationParams(
      controllerFromPlatform: (c) => c,
    );
    final controllerParams = PlatformInAppWebViewControllerCreationParams(
      id: 12345,
      webviewParams: widgetParams,
    );
    controller = MacOSInAppWebViewController(controllerParams);
  });

  tearDown(() {
    controller.dispose();
  });

  group('addJavaScriptHandler', () {
    test('stores a handler that can be checked with hasJavaScriptHandler', () {
      controller.addJavaScriptHandler(
        handlerName: 'testHandler',
        callback: (args) async => 'result',
      );
      expect(
        controller.hasJavaScriptHandler(handlerName: 'testHandler'),
        isTrue,
      );
    });

    test('handler returns the correct result via removeJavaScriptHandler', () {
      controller.addJavaScriptHandler(
        handlerName: 'anotherHandler',
        callback: (args) async => 42,
      );
      final removed = controller.removeJavaScriptHandler(
        handlerName: 'anotherHandler',
      );
      expect(removed, isNotNull);
      expect(
        controller.hasJavaScriptHandler(handlerName: 'anotherHandler'),
        isFalse,
      );
    });

    test('replacing an existing handler overwrites it', () {
      controller.addJavaScriptHandler(
        handlerName: 'overwrite',
        callback: (args) async => 'first',
      );
      controller.addJavaScriptHandler(
        handlerName: 'overwrite',
        callback: (args) async => 'second',
      );
      expect(controller.hasJavaScriptHandler(handlerName: 'overwrite'), isTrue);
    });
  });

  group('removeJavaScriptHandler', () {
    test('returns null when handler does not exist', () {
      final result = controller.removeJavaScriptHandler(
        handlerName: 'nonExistent',
      );
      expect(result, isNull);
    });

    test('returns the callback when handler exists', () {
      controller.addJavaScriptHandler(
        handlerName: 'removable',
        callback: (args) async => true,
      );
      final removed = controller.removeJavaScriptHandler(
        handlerName: 'removable',
      );
      expect(removed, isNotNull);
      expect(removed!, isA<JavaScriptHandlerCallback>());
    });

    test('handler no longer exists after removal', () {
      controller.addJavaScriptHandler(
        handlerName: 'temp',
        callback: (args) async => 'value',
      );
      controller.removeJavaScriptHandler(handlerName: 'temp');
      expect(controller.hasJavaScriptHandler(handlerName: 'temp'), isFalse);
    });
  });

  group('hasJavaScriptHandler', () {
    test('returns false for never-added handler', () {
      expect(
        controller.hasJavaScriptHandler(handlerName: 'neverAdded'),
        isFalse,
      );
    });

    test('returns true after adding, false after removing', () {
      controller.addJavaScriptHandler(
        handlerName: 'toggle',
        callback: (args) async => 'on',
      );
      expect(controller.hasJavaScriptHandler(handlerName: 'toggle'), isTrue);
      controller.removeJavaScriptHandler(handlerName: 'toggle');
      expect(controller.hasJavaScriptHandler(handlerName: 'toggle'), isFalse);
    });
  });

  group('dispose', () {
    test('clears all handlers', () {
      controller.addJavaScriptHandler(
        handlerName: 'persist',
        callback: (args) async => 'value',
      );
      controller.addJavaScriptHandler(
        handlerName: 'persist2',
        callback: (args) async => 'value2',
      );
      controller.dispose();
      expect(controller.hasJavaScriptHandler(handlerName: 'persist'), isFalse);
      expect(controller.hasJavaScriptHandler(handlerName: 'persist2'), isFalse);
    });
  });
}
