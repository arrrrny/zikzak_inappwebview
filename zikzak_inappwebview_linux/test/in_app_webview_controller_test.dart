// Channel-args tests for the Linux platform controller: verifies the exact
// MethodChannel method names + argument maps serialized for the native side
// (loadUrl, evaluateJavascript, navigation queries) and the handleMethod
// deserialization paths (onLoadStart/onLoadStop/onCallJsHandler) — the
// Dart/native wire contract for the zuraffa-only rewrite.
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_linux/src/in_app_webview/in_app_webview_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MethodChannel channel;
  late List<MethodCall> calls;
  late LinuxInAppWebViewController controller;

  LinuxInAppWebViewController _build({
    PlatformInAppWebViewWidgetCreationParams Function()? widgetParams,
  }) {
    final params = PlatformInAppWebViewControllerCreationParams(
      id: 12345,
      webviewParams: widgetParams != null
          ? widgetParams()
          : PlatformInAppWebViewWidgetCreationParams(
              controllerFromPlatform: (c) => c,
            ),
    );
    return LinuxInAppWebViewController.fromInAppBrowser(params, channel);
  }

  setUp(() {
    channel = MethodChannel('test-linux-channel');
    calls = [];
    channel.setMockMethodCallHandler((call) async {
      calls.add(call);
      switch (call.method) {
        case 'canGoBack':
        case 'canGoForward':
        case 'isLoading':
          return true;
        default:
          return null;
      }
    });
    controller = _build();
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  group('channel-arg serialization', () {
    test('loadUrl serializes urlRequest + allowingReadAccessTo', () async {
      await controller.loadUrl(
        urlRequest: URLRequest(
          url: WebUri('https://a.dev/page?x=1'),
          headers: {'x-a': 'b'},
        ),
        allowingReadAccessTo: WebUri('https://b.dev/'),
      );
      expect(calls.single.method, 'loadUrl');
      final args = calls.single.arguments as Map;
      final urlRequest = args['urlRequest'] as Map;
      expect(urlRequest['url'], 'https://a.dev/page?x=1');
      expect(urlRequest['headers'], {'x-a': 'b'});
      expect(args['allowingReadAccessTo'], 'https://b.dev/');
    });

    test('evaluateJavascript serializes source + contentWorld', () async {
      await controller.evaluateJavascript(
        source: 'document.title',
        contentWorld: ContentWorld.world(name: 'w'),
      );
      expect(calls.single.method, 'evaluateJavascript');
      final args = calls.single.arguments as Map;
      expect(args['source'], 'document.title');
      expect(args['contentWorld'], {'name': 'w'});
    });

    test('navigation queries delegate with no args + typed result', () async {
      expect(await controller.canGoBack(), true);
      expect(await controller.canGoForward(), true);
      expect(await controller.isLoading(), true);
      expect(calls.map((c) => c.method).toList(),
          ['canGoBack', 'canGoForward', 'isLoading']);
    });

    test('loadUrl with null urlRequest fields', () async {
      await controller.loadUrl(urlRequest: URLRequest(url: WebUri('https://a.dev/')));
      final args = calls.single.arguments as Map;
      final urlRequest = args['urlRequest'] as Map;
      expect(urlRequest['url'], 'https://a.dev/');
      expect(urlRequest['headers'], isNull);
    });
  });

  group('handleMethod deserialization', () {
    test('onLoadStart + onLoadStop deliver WebUri', () async {
      final loaded = <WebUri?>[];
      final stopped = <WebUri?>[];
      controller = _build(
        widgetParams: () => PlatformInAppWebViewWidgetCreationParams(
          controllerFromPlatform: (c) => c,
          onLoadStart: (c, url) => loaded.add(url),
          onLoadStop: (c, url) => stopped.add(url),
        ),
      );
      await controller.handleMethod(
        MethodCall('onLoadStart', {'url': 'https://a.dev/'}),
      );
      await controller.handleMethod(MethodCall('onLoadStop', {'url': null}));
      expect(loaded.single?.toString(), 'https://a.dev/');
      expect(stopped.single, isNull);
    });

    test('onCallJsHandler routes to the registered handler', () async {
      final received = <List<dynamic>>[];
      controller.addJavaScriptHandler(
        handlerName: 'h',
        callback: (args) {
          received.add(args);
          return 'result';
        },
      );
      final result = await controller.handleMethod(
        MethodCall('onCallJsHandler', {
          'handlerName': 'h',
          'args': ['a', 1],
        }),
      );
      expect(received.single, ['a', 1]);
      expect(result, 'result');

      final missing = await controller.handleMethod(
        MethodCall('onCallJsHandler', {
          'handlerName': 'nope',
          'args': [],
        }),
      );
      expect(missing, isNull);
    });
  });
}
