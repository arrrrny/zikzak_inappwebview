// Channel-args tests for the Linux platform controller: verifies the exact
// MethodChannel method names + argument maps serialized for the native side
// (loadUrl, evaluateJavascript, navigation queries) and the handleMethod
// deserialization paths (onLoadStart/onLoadStop/onCallJsHandler) — the
// Dart/native wire contract of the WPE port (linux/in_app_webview/
// webview_channel_delegate.cc).
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_linux/src/in_app_webview/in_app_webview_controller.dart';
import 'package:zikzak_inappwebview_linux/src/web_message/web_message_listener.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('wtf.zikzak/zikzak_inappwebview_12345');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late List<MethodCall> calls;
  late LinuxInAppWebViewController controller;

  LinuxInAppWebViewController build({
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
    return LinuxInAppWebViewController(params);
  }

  setUp(() {
    calls = [];
    messenger.setMockMethodCallHandler(channel, (call) async {
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
    controller = build();
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
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
      expect(calls.map((c) => c.method).toList(), [
        'canGoBack',
        'canGoForward',
        'isLoading',
      ]);
    });

    test('loadUrl with null urlRequest fields', () async {
      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri('https://a.dev/')),
      );
      final args = calls.single.arguments as Map;
      final urlRequest = args['urlRequest'] as Map;
      expect(urlRequest['url'], 'https://a.dev/');
      expect(urlRequest['headers'], isNull);
    });

    test('addUserScript sends the page content world by default', () async {
      await controller.addUserScript(
        userScript: UserScript(
          source: 's',
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
        ),
      );
      expect(calls.single.method, 'addUserScript');
      final userScript = (calls.single.arguments as Map)['userScript'] as Map;
      expect(userScript['contentWorld'], {'name': 'page'});
      expect(userScript['injectionTime'], 1);
    });
  });

  group('setSettings', () {
    test('re-sends the Ajax event keys for the widget callbacks', () async {
      controller = build(
        widgetParams: () => PlatformInAppWebViewWidgetCreationParams(
          onAjaxReadyStateChange: (c, request) async => null,
          onAjaxProgress: (c, request) async => null,
        ),
      );
      await controller.setSettings(
        settings: InAppWebViewSettings(useShouldInterceptAjaxRequest: true),
      );
      final settings = (calls.single.arguments as Map)['settings'] as Map;
      expect(settings['useOnAjaxReadyStateChange'], true);
      expect(settings['useOnAjaxProgress'], true);
    });

    test('sends no Ajax event keys without the callbacks', () async {
      await controller.setSettings(settings: InAppWebViewSettings());
      final settings = (calls.single.arguments as Map)['settings'] as Map;
      expect(settings.containsKey('useOnAjaxReadyStateChange'), isFalse);
      expect(settings.containsKey('useOnAjaxProgress'), isFalse);
    });
  });

  group('web message listener', () {
    test('addWebMessageListener sends the map native parses', () async {
      final listener = LinuxWebMessageListener(
        PlatformWebMessageListenerCreationParams(
          jsObjectName: 'bridge',
          allowedOriginRules: {'https://a.dev'},
        ),
      );
      await controller.addWebMessageListener(listener);
      expect(calls.single.method, 'addWebMessageListener');
      final map = (calls.single.arguments as Map)['webMessageListener'] as Map;
      // linux/in_app_webview/webview_channel_delegate.cc (addWebMessageListener)
      // reads jsObjectName and allowedOriginRules (a list of strings);
      // linux/web_message/web_message_listener.cc (fromFlValue) also reads id.
      expect(map['jsObjectName'], 'bridge');
      expect(map['allowedOriginRules'], ['https://a.dev']);
      expect(map['id'], isA<String>());
      listener.dispose();
    });
  });

  group('handleMethod deserialization', () {
    test('onLoadStart + onLoadStop deliver WebUri', () async {
      final loaded = <WebUri?>[];
      final stopped = <WebUri?>[];
      controller = build(
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
      // Native sends the JavaScript arguments JSON-encoded in data.args
      // (linux/types/javascript_handler_function_data.cc) and expects a
      // JSON-encoded result.
      final result = await controller.handleMethod(
        MethodCall('onCallJsHandler', {
          'handlerName': 'h',
          'data': {
            'origin': 'https://a.dev',
            'requestUrl': 'https://a.dev/',
            'isMainFrame': true,
            'args': jsonEncode(['a', 1]),
          },
        }),
      );
      expect(received.single, ['a', 1]);
      expect(result, jsonEncode('result'));

      final missing = await controller.handleMethod(
        MethodCall('onCallJsHandler', {
          'handlerName': 'nope',
          'data': {'args': '[]'},
        }),
      );
      expect(missing, isNull);
    });

    test('onReceivedError maps the native error code', () async {
      final errors = <WebResourceError>[];
      controller = build(
        widgetParams: () => PlatformInAppWebViewWidgetCreationParams(
          onReceivedError: (c, request, error) => errors.add(error),
        ),
      );
      await controller.handleMethod(
        MethodCall('onReceivedError', {
          'request': {'url': 'https://a.dev/', 'isForMainFrame': true},
          'error': {'description': 'cancelled', 'type': 302},
        }),
      );
      expect(errors.single.type, WebResourceErrorType.CANCELLED);
      expect(errors.single.description, 'cancelled');
    });

    test('onReceivedClientCertRequest answers in the native shape', () async {
      controller = build(
        widgetParams: () => PlatformInAppWebViewWidgetCreationParams(
          onReceivedClientCertRequest: (c, challenge) async =>
              ClientCertResponse(
                certificatePath: '/c.p12',
                action: ClientCertResponseAction.PROCEED,
              ),
        ),
      );
      final result = await controller.handleMethod(
        MethodCall('onReceivedClientCertRequest', {
          'protectionSpace': {'host': 'a.dev', 'port': 443},
          'isProxy': false,
          'principals': <String>[],
          'keyTypes': <String>[],
        }),
      );
      expect((result as Map)['selectedCertificate'], -1);
      expect(result['action'], 1);
      expect(result['certificatePath'], '/c.p12');
    });

    test('onPermissionRequest decodes native resource ints', () async {
      final requests = <PermissionRequest>[];
      controller = build(
        widgetParams: () => PlatformInAppWebViewWidgetCreationParams(
          onPermissionRequest: (c, request) async {
            requests.add(request);
            return PermissionResponse(action: PermissionResponseAction.GRANT);
          },
        ),
      );
      final result = await controller.handleMethod(
        MethodCall('onPermissionRequest', {
          'origin': 'https://a.dev',
          'resources': [2],
          'frame': null,
        }),
      );
      expect(requests.single.resources, [
        PermissionResourceType.CAMERA_AND_MICROPHONE,
      ]);
      expect((result as Map)['action'], 1);
    });

    test('onShowFileChooser answers null', () async {
      expect(
        await controller.handleMethod(
          MethodCall('onShowFileChooser', {'mode': 0}),
        ),
        isNull,
      );
    });
  });
}
