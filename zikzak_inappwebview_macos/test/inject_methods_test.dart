import 'dart:convert';

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

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
          calls.add(call);
          return true;
        });
  });

  tearDown(() {
    controller.dispose();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('inject-* methods (issue #416)', () {
    test('injectCSSCode is implemented instead of the stub throw', () async {
      // The platform-interface default throws UnimplementedError; the
      // macOS port must forward to the implemented native case.
      await controller.injectCSSCode(source: 'body { background: red; }');

      expect(calls, hasLength(1));
      final call = calls.single;
      expect(call.method, equals('injectCSSCode'));
      final args = (call.arguments as Map).cast<String, dynamic>();
      expect(args['source'], equals('body { background: red; }'));
    });

    test(
      'injectCSSFileFromUrl forwards the url and the link attributes',
      () async {
        final attributes = CSSLinkHtmlTagAttributes(id: 'theme');
        await controller.injectCSSFileFromUrl(
          urlFile: WebUri('https://example.com/style.css'),
          cssLinkHtmlTagAttributes: attributes,
        );

        expect(calls, hasLength(1));
        final call = calls.single;
        expect(call.method, equals('injectCSSFileFromUrl'));
        final args = (call.arguments as Map).cast<String, dynamic>();
        expect(args['urlFile'], equals('https://example.com/style.css'));
        expect(
          (args['cssLinkHtmlTagAttributes'] as Map).cast<String, dynamic>(),
          equals(attributes.toJson()),
        );

        // Default path: no attributes, so the native side must receive null.
        calls.clear();
        await controller.injectCSSFileFromUrl(
          urlFile: WebUri('https://example.com/other.css'),
        );
        final bare = (calls.single.arguments as Map).cast<String, dynamic>();
        expect(bare['cssLinkHtmlTagAttributes'], isNull);
      },
    );

    test(
      'injectJavascriptFileFromUrl forwards the url and the tag attributes',
      () async {
        final attributes = ScriptHtmlTagAttributes(id: 'lib');
        await controller.injectJavascriptFileFromUrl(
          urlFile: WebUri('https://example.com/app.js'),
          scriptHtmlTagAttributes: attributes,
        );

        expect(calls, hasLength(1));
        final call = calls.single;
        expect(call.method, equals('injectJavascriptFileFromUrl'));
        final args = (call.arguments as Map).cast<String, dynamic>();
        expect(args['urlFile'], equals('https://example.com/app.js'));
        expect(
          (args['scriptHtmlTagAttributes'] as Map).cast<String, dynamic>(),
          equals(attributes.toMap()),
        );

        // Default path: no attributes, so the native side must receive null.
        calls.clear();
        await controller.injectJavascriptFileFromUrl(
          urlFile: WebUri('https://example.com/other.js'),
        );
        final bare = (calls.single.arguments as Map).cast<String, dynamic>();
        expect(bare['scriptHtmlTagAttributes'], isNull);
      },
    );

    test(
      'ScriptHtmlTagAttributes onLoad/onError fire via the callHandler bridge',
      () async {
        // Issue #416 wiring: the native side emits
        // callHandler('onInjectedScriptLoaded'/'onInjectedScriptError', [id])
        // when scriptHtmlTagAttributes.id is set; the controller must route
        // those back to the registered attributes' callbacks.
        var loaded = false;
        var errored = false;
        await controller.injectJavascriptFileFromUrl(
          urlFile: WebUri('https://example.com/app.js'),
          scriptHtmlTagAttributes: ScriptHtmlTagAttributes(
            id: 'lib',
            onLoad: () => loaded = true,
            onError: () => errored = true,
          ),
        );

        Future<void> sendBridge(String handlerName, String id) {
          return TestDefaultBinaryMessengerBinding
              .instance
              .defaultBinaryMessenger
              .handlePlatformMessage(
                channelName,
                const StandardMethodCodec().encodeMethodCall(
                  MethodCall('callHandler', {
                    'handlerName': handlerName,
                    'args': '["$id"]',
                  }),
                ),
                (_) {},
              );
        }

        await sendBridge('onInjectedScriptLoaded', 'lib');
        expect(loaded, isTrue, reason: 'onLoad must fire on the bridge call');
        expect(errored, isFalse);

        await sendBridge('onInjectedScriptError', 'lib');
        expect(errored, isTrue, reason: 'onError must fire on the bridge call');

        // An unregistered id must be a no-op, never a throw.
        loaded = false;
        await sendBridge('onInjectedScriptLoaded', 'unknown');
        expect(loaded, isFalse);
      },
    );
  });

  group('inject-* asset variants (issue #419)', () {
    // The asset variants must not throw UnimplementedError. The native
    // macOS side has no inject*FileFromAsset channel cases — the contract
    // (mirroring the iOS controller) is pure Dart: load the asset string
    // with rootBundle, then dispatch through the already-implemented
    // injectCSSCode / evaluateJavascript channel calls.
    const cssAssetPath = 'assets/test/issue-419-style.css';
    const jsAssetPath = 'assets/test/issue-419-app.js';

    setUp(() {
      final assets = <String, String>{
        cssAssetPath: 'body { background: green; }',
        jsAssetPath: 'console.log("issue-419");',
      };
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
            if (message == null) {
              return null;
            }
            final requested = utf8.decode(message.buffer.asUint8List());
            final content = assets[requested];
            if (content == null) {
              return null;
            }
            return ByteData.sublistView(
              Uint8List.fromList(utf8.encode(content)),
            );
          });
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler('flutter/assets', null);
      });
    });

    test(
      'injectCSSFileFromAsset loads the asset and forwards via injectCSSCode',
      () async {
        await controller.injectCSSFileFromAsset(assetFilePath: cssAssetPath);

        expect(calls, hasLength(1));
        final call = calls.single;
        expect(call.method, equals('injectCSSCode'));
        final args = (call.arguments as Map).cast<String, dynamic>();
        expect(args['source'], equals('body { background: green; }'));
      },
    );

    test('injectJavascriptFileFromAsset loads the asset and forwards via evaluateJavascript', () async {
      final result = await controller.injectJavascriptFileFromAsset(
        assetFilePath: jsAssetPath,
      );

      // The mocked channel returns true, and evaluateJavascript must
      // surface it through the asset variant.
      expect(result, isTrue);
      expect(calls, hasLength(1));
      final call = calls.single;
      expect(call.method, equals('evaluateJavascript'));
      final args = (call.arguments as Map).cast<String, dynamic>();
      expect(args['source'], equals('console.log("issue-419");'));
    });
  });
}
