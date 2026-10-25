import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_macos/src/in_app_webview/in_app_webview_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channelName = 'dev.zuzu/zikzak_inappwebview_12345';
  const channel = MethodChannel(channelName);

  late MacOSInAppWebViewController controller;
  late List<MethodCall> calls;
  Object? nativeResponse;

  setUp(() {
    calls = <MethodCall>[];
    nativeResponse = <String, dynamic>{'value': null, 'error': null};

    final widgetParams = PlatformInAppWebViewWidgetCreationParams(
      controllerFromPlatform: (c) => c,
    );
    final controllerParams = PlatformInAppWebViewControllerCreationParams(
      id: 12345,
      webviewParams: widgetParams,
    );
    controller = MacOSInAppWebViewController(controllerParams);

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
          calls.add(call);
          if (call.method == 'callAsyncJavaScript') {
            return nativeResponse;
          }
          return null;
        });
  });

  tearDown(() {
    controller.dispose();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('callAsyncJavaScript (issue #376)', () {
    test('is implemented instead of falling through to the stub', () async {
      // The platform-interface default throws UnimplementedError; the macOS
      // port must override it so macOS callers get a result, not a throw.
      nativeResponse = <String, dynamic>{'value': 42, 'error': null};

      final result = await controller.callAsyncJavaScript(
        functionBody: 'return 21 * 2;',
      );

      expect(result, isNotNull);
      expect(result!.value, equals(42));
      expect(result.error, isNull);
    });

    test('forwards functionBody, arguments and contentWorld', () async {
      final contentWorld = ContentWorld.world(name: 'forklift');
      final arguments = <String, dynamic>{
        'left': 20,
        'right': 22,
        'labels': <String>['a', 'b'],
      };

      await controller.callAsyncJavaScript(
        functionBody: 'return left + right;',
        arguments: arguments,
        contentWorld: contentWorld,
      );

      expect(calls, hasLength(1));
      final call = calls.single;
      expect(call.method, equals('callAsyncJavaScript'));
      final args = (call.arguments as Map).cast<String, dynamic>();
      expect(args['functionBody'], equals('return left + right;'));
      expect(args['arguments'], equals(arguments));
      expect(
        (args['contentWorld'] as Map).cast<String, dynamic>(),
        equals(contentWorld.toMap()),
      );
    });

    test('decodes the native failure as the error string', () async {
      nativeResponse = <String, dynamic>{
        'value': null,
        'error': 'ReferenceError: Can\'t find variable: nope',
      };

      final result = await controller.callAsyncJavaScript(
        functionBody: 'return nope;',
      );

      expect(result, isNotNull);
      expect(result!.value, isNull);
      expect(result.error, contains('ReferenceError'));
    });

    test('returns null when the native side answers null', () async {
      nativeResponse = null;

      final result = await controller.callAsyncJavaScript(
        functionBody: 'return 1;',
      );

      expect(result, isNull);
    });
  });
}
