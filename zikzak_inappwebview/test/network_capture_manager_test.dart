// Tests for NetworkCaptureManager — the platform-independent Dart engine of
// the Network Capture API (JS interceptor injection, handler wiring, event
// routing/dedup into NetworkCaptureController).
//
// Uses a fake PlatformInAppWebViewController that records handler
// registration and lets tests fire captured events through the registered
// JavaScript handler callback.
import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

class _FakePlatformController extends PlatformInAppWebViewController {
  _FakePlatformController() : super.implementation(
          const PlatformInAppWebViewControllerCreationParams(id: 'test'),
        );

  final Map<String, JavaScriptHandlerCallback> handlers = {};
  final List<String> evaluateCalls = [];
  final List<String> removedHandlers = [];

  @override
  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  }) {
    handlers[handlerName] = callback;
  }

  @override
  JavaScriptHandlerCallback? removeJavaScriptHandler({
    required String handlerName,
  }) {
    removedHandlers.add(handlerName);
    return handlers.remove(handlerName);
  }

  @override
  bool hasJavaScriptHandler({required String handlerName}) =>
      handlers.containsKey(handlerName);

  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) async {
    evaluateCalls.add(source);
    return null;
  }

  @override
  void dispose({bool isKeepAlive = false}) {}
}

InAppWebViewController _controller(_FakePlatformController fake) =>
    InAppWebViewController.fromPlatform(platform: fake);

Map<String, dynamic> _payload(Map<String, dynamic> extra) => {
      'pageId': 'p1',
      'seq': 1,
      ...extra,
    };

void main() {
  group('NetworkCaptureManager.maybeCreate', () {
    test('null/false settings with no callbacks -> null', () {
      expect(NetworkCaptureManager.maybeCreate(settings: null), isNull);
      expect(
        NetworkCaptureManager.maybeCreate(
          settings: InAppWebViewSettings(useNetworkCapture: false),
        ),
        isNull,
      );
    });

    test('useNetworkCapture true -> manager', () {
      final m = NetworkCaptureManager.maybeCreate(
        settings: InAppWebViewSettings(useNetworkCapture: true),
      );
      expect(m, isNotNull);
      expect(m!.collector, isA<NetworkCaptureController>());
    });

    test('null setting + callbacks -> manager (auto-enabled)', () {
      final m = NetworkCaptureManager.maybeCreate(
        settings: InAppWebViewSettings(),
        onNetworkRequest: (c, r) {},
      );
      expect(m, isNotNull);
    });

    test('user-provided networkCapture collector is reused', () {
      final collector = NetworkCaptureController();
      final m = NetworkCaptureManager.maybeCreate(
        settings: InAppWebViewSettings(networkCapture: collector),
      );
      expect(identical(m!.collector, collector), isTrue);
    });
  });

  group('NetworkCaptureManager.buildUserScript + mergeUserScripts', () {
    test('interceptor script carries the settings config', () {
      final m = NetworkCaptureManager.maybeCreate(
        settings: InAppWebViewSettings(
          useNetworkCapture: true,
          networkCaptureMaxBodySize: 1234,
          networkCaptureBodies: false,
          networkCaptureUrlPatterns: ['/api'],
          networkCaptureUrlPatternType: UrlPatternType.regex,
          networkCaptureResourceTypes: [ResourceType.xhr],
        ),
      )!;
      final script = m.buildUserScript();
      expect(script.groupName, 'zikzakNetworkCapture');
      expect(script.injectionTime, UserScriptInjectionTime.AT_DOCUMENT_START);
      expect(script.forMainFrameOnly, false);
      final src = script.source;
      expect(src, contains('"maxBodySize":1234'));
      expect(src, contains('"captureBodies":false'));
      expect(src, contains('"urlPatterns":["/api"]'));
      expect(src, contains('"patternType":"regex"'));
      expect(src, contains('"resourceTypes":["xhr"]'));
    });

    test('mergeUserScripts prepends the interceptor or passes through', () {
      final existing = UserScript(
        source: 'console.log(1)',
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
      );
      final list = [existing];
      final m = NetworkCaptureManager.maybeCreate(
        settings: InAppWebViewSettings(useNetworkCapture: true),
      )!;
      final merged = NetworkCaptureManager.mergeUserScripts(
        UnmodifiableListView<UserScript>(list),
        m,
      );
      expect(merged, hasLength(2));
      // The interceptor is APPENDED after the user-provided scripts.
      expect(merged!.first, same(existing));
      expect(merged.last.groupName, 'zikzakNetworkCapture');

      expect(
        NetworkCaptureManager.mergeUserScripts(
          UnmodifiableListView<UserScript>(list),
          null,
        ),
        isNotNull,
      );
    });
  });

  group('NetworkCaptureManager.attach/detach', () {
    test('attach registers the handler + registry; of() resolves', () async {
      final fake = _FakePlatformController();
      final controller = _controller(fake);
      final m = NetworkCaptureManager.maybeCreate(
        settings: InAppWebViewSettings(useNetworkCapture: true),
      )!;
      m.attach(controller);
      expect(fake.handlers.containsKey('__zikzakNetworkCapture__'), isTrue);
      expect(NetworkCaptureManager.of(controller), same(m));
      // flush triggered an evaluateJavascript
      expect(fake.evaluateCalls, isNotEmpty);
      expect(
        fake.evaluateCalls.first,
        contains('__zikzakNetworkCapture__.ready'),
      );
    });

    test('detach removes the handler + registry', () async {
      final fake = _FakePlatformController();
      final controller = _controller(fake);
      final m = NetworkCaptureManager.maybeCreate(
        settings: InAppWebViewSettings(useNetworkCapture: true),
      )!;
      m.attach(controller);
      m.detach(controller);
      expect(fake.handlers.containsKey('__zikzakNetworkCapture__'), isFalse);
      expect(fake.removedHandlers, contains('__zikzakNetworkCapture__'));
      expect(NetworkCaptureManager.of(controller), isNull);
    });
  });

  group('NetworkCaptureManager event routing', () {
    test('request events reach the collector + callback', () async {
      final fake = _FakePlatformController();
      final controller = _controller(fake);
      final collector = NetworkCaptureController();
      final requests = <NetworkRequest>[];
      final m = NetworkCaptureManager.maybeCreate(
        settings: InAppWebViewSettings(networkCapture: collector),
        onNetworkRequest: (c, r) => requests.add(r),
      )!;
      m.attach(controller);
      final handler = fake.handlers['__zikzakNetworkCapture__']!;

      await handler([
        _payload({
          'kind': 'request',
          'requestId': 'r1',
          'url': 'https://api.dev/users',
          'method': 'GET',
        }),
      ]);
      expect(collector.count, 1);
      expect(requests, hasLength(1));
      expect(requests.single.requestId, 'r1');
      expect(requests.single.url.toString(), 'https://api.dev/users');
    });

    test('response/body/error events route to the collector', () async {
      final fake = _FakePlatformController();
      final controller = _controller(fake);
      final collector = NetworkCaptureController();
      final m = NetworkCaptureManager.maybeCreate(
        settings: InAppWebViewSettings(networkCapture: collector),
      )!;
      m.attach(controller);
      final handler = fake.handlers['__zikzakNetworkCapture__']!;

      await handler([
        _payload({
          'kind': 'request',
          'requestId': 'r1',
          'url': 'https://api.dev/users',
        }),
      ]);
      await handler([
        _payload({
          'seq': 2,
          'kind': 'response',
          'requestId': 'r1',
          'url': 'https://api.dev/users',
          'statusCode': 200,
          'mimeType': 'application/json',
        }),
      ]);
      await handler([
        _payload({
          'seq': 3,
          'kind': 'body',
          'requestId': 'r1',
          'url': 'https://api.dev/users',
          'body': '{"ok":true}',
          'isBase64': false,
          'size': 9,
          'truncated': false,
        }),
      ]);
      await handler([
        _payload({'seq': 4, 'kind': 'request', 'requestId': 'r2', 'url': 'https://api.dev/fail'}),
      ]);
      await handler([
        _payload({'seq': 5, 'kind': 'error', 'requestId': 'r2', 'error': 'timeout'}),
      ]);

      final entries = await collector.getEntries();
      expect(entries, hasLength(2));
      final ok = entries.firstWhere((e) => e.request.requestId == 'r1');
      expect(ok.response?.statusCode, 200);
      expect(ok.responseBody?.decoded, {'ok': true});
      final failed = entries.firstWhere((e) => e.request.requestId == 'r2');
      expect(failed.hasError, true);
      expect(failed.error, 'timeout');
    });

    test('deduplicates identical pageId:seq events (bounded queue)', () async {
      final fake = _FakePlatformController();
      final controller = _controller(fake);
      final collector = NetworkCaptureController();
      final requests = <NetworkRequest>[];
      final m = NetworkCaptureManager.maybeCreate(
        settings: InAppWebViewSettings(networkCapture: collector),
        onNetworkRequest: (c, r) => requests.add(r),
      )!;
      m.attach(controller);
      final handler = fake.handlers['__zikzakNetworkCapture__']!;
      final payload = _payload({
        'kind': 'request',
        'requestId': 'r1',
        'url': 'https://api.dev/users',
      });

      await handler([payload]);
      await handler([payload]);
      await handler([payload]);
      expect(collector.count, 1);
      expect(requests, hasLength(1));
    });

    test('malformed payloads are ignored', () async {
      final fake = _FakePlatformController();
      final controller = _controller(fake);
      final collector = NetworkCaptureController();
      final m = NetworkCaptureManager.maybeCreate(
        settings: InAppWebViewSettings(networkCapture: collector),
      )!;
      m.attach(controller);
      final handler = fake.handlers['__zikzakNetworkCapture__']!;

      await handler([]); // no payload
      await handler(['not-a-map']); // non-map payload
      await handler([_payload({'kind': 'request'})]); // missing url -> null
      expect(collector.count, 0);
    });
  });
}
