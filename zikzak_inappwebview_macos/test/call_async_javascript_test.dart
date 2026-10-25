import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_macos/src/in_app_webview/in_app_webview_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('dev.zuzu/zikzak_inappwebview_12345');

  late MacOSInAppWebViewController controller;
  late List<MethodCall> calls;

  setUp(() {
    calls = <MethodCall>[];
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
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    controller.dispose();
  });

  void mockChannel(Object? Function(MethodCall call) handler) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return handler(call);
        });
  }

  group('callAsyncJavaScript', () {
    test('is overridden and does not throw UnimplementedError', () async {
      mockChannel((call) => null);

      await expectLater(
        controller.callAsyncJavaScript(functionBody: 'return 1;'),
        completes,
      );
    });

    test(
      'forwards functionBody, arguments and contentWorld to the channel',
      () async {
        mockChannel((call) => <String, dynamic>{'value': 1, 'error': null});

        await controller.callAsyncJavaScript(
          functionBody: 'return a + b;',
          arguments: <String, dynamic>{'a': 1, 'b': 2},
          contentWorld: ContentWorld.PAGE,
        );

        expect(calls, hasLength(1));
        expect(calls.single.method, 'callAsyncJavaScript');
        final args = calls.single.arguments as Map;
        expect(args['functionBody'], 'return a + b;');
        expect(args['arguments'], <String, dynamic>{'a': 1, 'b': 2});
        expect(args['contentWorld'], <String, dynamic>{'name': 'page'});
      },
    );

    test('sends a null contentWorld when none is given', () async {
      mockChannel((call) => <String, dynamic>{'value': 1, 'error': null});

      await controller.callAsyncJavaScript(functionBody: 'return 1;');

      final args = calls.single.arguments as Map;
      expect(args['contentWorld'], isNull);
    });

    test('decodes a resolved promise value', () async {
      mockChannel(
        (call) => <String, dynamic>{'value': 'async-result', 'error': null},
      );

      final result = await controller.callAsyncJavaScript(
        functionBody: 'return Promise.resolve("async-result");',
      );

      expect(result, isNotNull);
      expect(result!.value, 'async-result');
      expect(result.error, isNull);
    });

    test(
      'surfaces a JS exception as result.error instead of throwing',
      () async {
        mockChannel(
          (call) => <String, dynamic>{
            'value': null,
            'error': 'ReferenceError: Can\'t find variable: nope',
          },
        );

        final result = await controller.callAsyncJavaScript(
          functionBody: 'return nope;',
        );

        expect(result, isNotNull);
        expect(result!.value, isNull);
        expect(result.error, 'ReferenceError: Can\'t find variable: nope');
      },
    );

    test('returns null when the native side answers null', () async {
      mockChannel((call) => null);

      final result = await controller.callAsyncJavaScript(
        functionBody: 'return 1;',
        contentWorld: ContentWorld.world(name: 'custom'),
      );

      expect(result, isNull);
    });
  });
}
