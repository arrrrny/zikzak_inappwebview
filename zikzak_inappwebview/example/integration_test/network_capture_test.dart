// Integration tests for the Network Capture API.
//
// Group A: deterministic tests against a local dart:io HTTP server whose
// pages issue fetch()/XHR calls — validates the full Dart→JS→Dart round-trip
// in a real WebView (Linux/WebKitGTK here; the engine is platform-independent
// JavaScript injection, so behavior carries over to Android/iOS/macOS).
//
// Group B: smoke tests against real internet endpoints (httpbin.org and a
// real SPA) to validate against production-grade traffic.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

/// Serves a test page plus API endpoints on 127.0.0.1 (ephemeral port).
class CaptureTestServer {
  late final HttpServer _server;
  final List<String> requestLog = [];

  static const jsonBody = '{"product":{"id":42,"name":"Sneaker","price":99.5}}';
  static const xhrBody = '{"reviewCount":128,"avg":4.7}';
  static const postResponse = '{"ok":true}';

  Future<CaptureTestServer> start() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server.listen(_handle);
    return this;
  }

  int get port => _server.port;
  String get baseUrl => 'http://127.0.0.1:$port';

  void _handle(HttpRequest req) {
    requestLog.add('${req.method} ${req.uri.path}');
    final res = req.response;
    void send(String body, String contentType,
        {int status = 200, Duration? delay}) {
      res.statusCode = status;
      res.headers.contentType = ContentType.parse(contentType);
      final go = () {
        res.write(body);
        res.close();
      };
      if (delay != null) {
        Future.delayed(delay, go);
      } else {
        go();
      }
    }

    switch (req.uri.path) {
      case '/':
        res.headers.contentType = ContentType.html;
        res.write('''
<!DOCTYPE html>
<html><head><title>capture test</title></head>
<body><h1>capture test</h1>
<script>
// 1. plain fetch GET (JSON)
fetch('/api/json');
// 2. fetch POST with JSON body
fetch('/api/post', {
  method: 'POST',
  headers: {'Content-Type': 'application/json', 'X-Custom': 'yes'},
  body: JSON.stringify({sku: 'ABC', qty: 2})
});
// 3. XHR GET with custom header
var xhr = new XMLHttpRequest();
xhr.open('GET', '/api/xhr-data');
xhr.setRequestHeader('X-Test', 'yes');
xhr.send();
// 4. non-API request (URL filter must exclude it)
fetch('/static/logo.txt');
// 5. large JSON (truncation test)
fetch('/api/big');
// 6. staggered request after 1200ms (waitForIdle test)
setTimeout(function () { fetch('/api/staggered'); }, 1200);
</script></body></html>''');
        res.close();
      case '/api/json':
        send(jsonBody, 'application/json');
      case '/api/post':
        send(postResponse, 'application/json');
      case '/api/xhr-data':
        send(xhrBody, 'application/json; charset=utf-8');
      case '/api/big':
        send('{"data":"${'x' * 20000}"}', 'application/json');
      case '/api/staggered':
        send('{"late":true}', 'application/json');
      case '/api/slow':
        send('{"slow":true}', 'application/json',
            delay: const Duration(seconds: 25));
      case '/static/logo.txt':
        send('LOGO', 'text/plain');
      default:
        send('{"error":"not found"}', 'application/json', status: 404);
    }
  }

  Future<void> stop() => _server.close(force: true);
}

/// Pumps an [InAppWebView] with the given settings/callbacks and returns
/// once the page's staggered request has landed (or the timeout hits).
Future<InAppWebViewController> pumpWebView(
  WidgetTester tester, {
  required String url,
  InAppWebViewSettings? settings,
  void Function(InAppWebViewController, NetworkRequest)? onNetworkRequest,
  void Function(InAppWebViewController, NetworkResponse)? onNetworkResponse,
  void Function(InAppWebViewController, NetworkResponseBody)?
      onNetworkLoadingFinished,
  Duration settle = const Duration(seconds: 4),
}) async {
  InAppWebViewController? controller;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(url)),
          initialSettings: settings,
          onWebViewCreated: (c) => controller = c,
          onNetworkRequest: onNetworkRequest,
          onNetworkResponse: onNetworkResponse,
          onNetworkLoadingFinished: onNetworkLoadingFinished,
        ),
      ),
    ),
  );
  await Future.delayed(settle);
  await tester.pump();
  return controller!;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('A. local server (deterministic)', () {
    late CaptureTestServer server;

    setUpAll(() async {
      server = await CaptureTestServer().start();
    });
    tearDownAll(() async {
      await server.stop();
    });

    testWidgets('A1: fetch + XHR + POST bodies captured end-to-end',
        (tester) async {
      await tester.runAsync(() async {
        final bodies = <NetworkResponseBody>[];
        final requests = <NetworkRequest>[];
        final responses = <NetworkResponse>[];

        await pumpWebView(
          tester,
          url: '${server.baseUrl}/',
          settings: InAppWebViewSettings(useNetworkCapture: true),
          onNetworkRequest: (c, r) => requests.add(r),
          onNetworkResponse: (c, r) => responses.add(r),
          onNetworkLoadingFinished: (c, b) => bodies.add(b),
        );

        NetworkRequest? byUrl(List<NetworkRequest> l, String p) =>
            l.where((e) => e.url.toString().contains(p)).firstOrNull;

        // --- fetch GET ---
        final fetchReq = byUrl(requests, '/api/json');
        expect(fetchReq, isNotNull, reason: 'fetch request not captured');
        expect(fetchReq!.method, 'GET');
        expect(fetchReq.resourceType, ResourceType.fetch);

        // --- fetch response ---
        final fetchResp = responses
            .where((e) => e.url.toString().contains('/api/json'))
            .firstOrNull;
        expect(fetchResp, isNotNull);
        expect(fetchResp!.statusCode, 200);
        expect(fetchResp.mimeType, 'application/json');

        // --- fetch body matches server payload (A5: content correctness) ---
        final fetchBody = bodies
            .where((e) => e.url.toString().contains('/api/json'))
            .firstOrNull;
        expect(fetchBody, isNotNull);
        expect(fetchBody!.body, CaptureTestServer.jsonBody);
        expect(fetchBody.truncated, isFalse);
        // A9: JSON auto-parse
        expect(fetchBody.decoded, isA<Map>());
        expect(fetchBody.decoded['product']['id'], 42);

        // --- XHR (A3) ---
        final xhrReq = byUrl(requests, '/api/xhr-data');
        expect(xhrReq, isNotNull, reason: 'XHR request not captured');
        expect(xhrReq!.resourceType, ResourceType.xhr);
        expect(xhrReq.headers['X-Test'], 'yes');
        final xhrResp = responses
            .where((e) => e.url.toString().contains('/api/xhr-data'))
            .firstOrNull;
        expect(xhrResp, isNotNull);
        expect(xhrResp!.mimeType, 'application/json');
        final xhrBody = bodies
            .where((e) => e.url.toString().contains('/api/xhr-data'))
            .firstOrNull;
        expect(xhrBody, isNotNull);
        expect(xhrBody!.body, CaptureTestServer.xhrBody);

        // --- POST body (A4) ---
        final postReq = byUrl(requests, '/api/post');
        expect(postReq, isNotNull, reason: 'POST request not captured');
        expect(postReq!.method, 'POST');
        expect(postReq.body, '{"sku":"ABC","qty":2}');

        // --- truncation ---
        final bigBody = bodies
            .where((e) => e.url.toString().contains('/api/big'))
            .firstOrNull;
        expect(bigBody, isNotNull);
        expect(bigBody!.truncated, isFalse, // default 50000 > 20000
            reason: '20KB body should not be truncated with default settings');
        expect(bigBody.size, greaterThan(20000));
      });
    }, timeout: const Timeout(Duration(seconds: 60)));

    testWidgets('A2: truncation with small maxBodySize', (tester) async {
      await tester.runAsync(() async {
        final bodies = <NetworkResponseBody>[];
        await pumpWebView(
          tester,
          url: '${server.baseUrl}/',
          settings: InAppWebViewSettings(
            useNetworkCapture: true,
            networkCaptureMaxBodySize: 1000,
          ),
          onNetworkLoadingFinished: (c, b) => bodies.add(b),
        );
        final bigBody = bodies
            .where((e) => e.url.toString().contains('/api/big'))
            .firstOrNull;
        expect(bigBody, isNotNull);
        expect(bigBody!.truncated, isTrue);
        expect(bigBody.size, greaterThan(20000));
        expect(bigBody.body, endsWith(' chars]'));
        expect(bigBody.body.length, lessThan(1100));
      });
    }, timeout: const Timeout(Duration(seconds: 60)));

    testWidgets('A3: URL filtering', (tester) async {
      await tester.runAsync(() async {
        final requests = <NetworkRequest>[];
        await pumpWebView(
          tester,
          url: '${server.baseUrl}/',
          settings: InAppWebViewSettings(
            useNetworkCapture: true,
            networkCaptureUrlPatterns: ['api'],
          ),
          onNetworkRequest: (c, r) => requests.add(r),
        );
        expect(requests, isNotEmpty);
        expect(
          requests.every((r) => r.url.toString().contains('api')),
          isTrue,
          reason: 'non-matching URL captured: '
              '${requests.map((r) => r.url).toList()}',
        );
        expect(
          requests.any((r) => r.url.toString().contains('/static/')),
          isFalse,
        );
      });
    }, timeout: const Timeout(Duration(seconds: 60)));

    testWidgets('A4: NetworkCaptureController parity, filters, clear',
        (tester) async {
      await tester.runAsync(() async {
        final collector = NetworkCaptureController();
        final callbackBodies = <NetworkResponseBody>[];
        await pumpWebView(
          tester,
          url: '${server.baseUrl}/',
          settings: InAppWebViewSettings(
            useNetworkCapture: true,
            networkCapture: collector,
          ),
          onNetworkLoadingFinished: (c, b) => callbackBodies.add(b),
        );

        final entries = await collector.getEntries();
        expect(entries.length, greaterThanOrEqualTo(5),
            reason: 'expected json/post/xhr-data/big/staggered entries, '
                'got ${entries.map((e) => e.request.url).toList()}');

        // parity: every callback body is attached to an entry
        final entryBodies = await collector.getBodies();
        expect(entryBodies.length, callbackBodies.length);

        // entry correlation
        final jsonEntry = entries
            .where((e) => e.request.url.toString().contains('/api/json'))
            .firstOrNull;
        expect(jsonEntry, isNotNull);
        expect(jsonEntry!.response?.statusCode, 200);
        expect(jsonEntry.responseBody?.decoded['product']['name'], 'Sneaker');

        // filters
        final postOnly = await collector.getEntries(urlPatterns: ['post']);
        expect(postOnly.length, 1);
        expect(postOnly.first.request.method, 'POST');
        final fetchOnly = await collector.getEntries(
            resourceTypes: [ResourceType.fetch], withBodyOnly: true);
        expect(
            fetchOnly.every((e) => e.request.resourceType ==
                    ResourceType.fetch &&
                e.responseBody != null),
            isTrue);
        final jsonOnly = await collector.getEntries(
            mimeTypes: ['application/json']);
        expect(jsonOnly.every((e) =>
            (e.response?.mimeType ?? '').contains('json') ||
            e.request.url.toString().contains('logo') == false), isTrue);

        // clear()
        collector.clear();
        expect(collector.count, 0);
        expect(await collector.getEntries(), isEmpty);
      });
    }, timeout: const Timeout(Duration(seconds: 60)));

    testWidgets('A5: waitForIdle resolves after staggered requests',
        (tester) async {
      await tester.runAsync(() async {
        final collector = NetworkCaptureController();
        await pumpWebView(
          tester,
          url: '${server.baseUrl}/',
          settings: InAppWebViewSettings(
            useNetworkCapture: true,
            networkCapture: collector,
          ),
          settle: const Duration(milliseconds: 300), // catch it mid-flight
        );
        await collector.waitForIdle(
          timeout: const Duration(seconds: 15),
          quietDuration: const Duration(milliseconds: 1500),
        );
        final entries = await collector.getEntries();
        expect(
          entries.any((e) => e.request.url.toString().contains('staggered')),
          isTrue,
          reason: 'waitForIdle returned before the staggered request',
        );
      });
    }, timeout: const Timeout(Duration(seconds: 60)));

    testWidgets('A6: waitForIdle times out on hanging request', (tester) async {
      await tester.runAsync(() async {
        final collector = NetworkCaptureController();
        // Load a page that immediately fires a 25s-hanging request
        final html = Uri.dataFromString(
          '<html><body><script>fetch("/api/slow");</script></body></html>',
          mimeType: 'text/html',
        ).toString();
        await pumpWebView(
          tester,
          url: '${server.baseUrl}/hang', // 404 but still a page? no — use data:
          settings: InAppWebViewSettings(
            useNetworkCapture: true,
            networkCapture: collector,
          ),
          settle: const Duration(milliseconds: 100),
        );
        // trigger the hanging fetch manually on the 404 page
        final controller = await pumpWebView(
          tester,
          url: '${server.baseUrl}/',
          settings: InAppWebViewSettings(
            useNetworkCapture: true,
            networkCapture: collector,
          ),
          settle: const Duration(milliseconds: 500),
        );
        await controller.evaluateJavascript(source: "fetch('/api/slow');");
        await Future.delayed(const Duration(milliseconds: 300));
        await expectLater(
          collector.waitForIdle(
            timeout: const Duration(seconds: 3),
            quietDuration: const Duration(milliseconds: 1500),
          ),
          throwsA(isA<TimeoutException>()),
        );
      });
    }, timeout: const Timeout(Duration(seconds: 60)));

    testWidgets('A7: HeadlessInAppWebView captures too', (tester) async {
      await tester.runAsync(() async {
        final collector = NetworkCaptureController();
        final headless = HeadlessInAppWebView(
          initialUrlRequest: URLRequest(url: WebUri('${server.baseUrl}/')),
          initialSettings: InAppWebViewSettings(
            useNetworkCapture: true,
            networkCapture: collector,
          ),
        );
        await headless.run();
        try {
          await collector.waitForIdle(
            timeout: const Duration(seconds: 15),
            quietDuration: const Duration(milliseconds: 2000),
          );
        } on TimeoutException {
          // proceed with what we have
        }
        final entries = await collector.getEntries();
        expect(entries.length, greaterThanOrEqualTo(5),
            reason:
                'headless captured: ${entries.map((e) => e.request.url).toList()}');
        final xhrEntry = entries
            .where((e) => e.request.resourceType == ResourceType.xhr)
            .firstOrNull;
        expect(xhrEntry, isNotNull);
        expect(xhrEntry!.responseBody?.body, CaptureTestServer.xhrBody);
        // controller accessor on the headless webview controller
        expect(headless.webViewController?.networkCaptureController,
            isNotNull);
        await headless.dispose();
      });
    }, timeout: const Timeout(Duration(seconds: 60)));
  });

  group('B. real internet (smoke)', () {
    testWidgets('B1: httpbin.org/json round-trip', (tester) async {
      await tester.runAsync(() async {
        final completer = Completer<NetworkResponseBody>();
        final collector = NetworkCaptureController();
        final headless = HeadlessInAppWebView(
          initialUrlRequest:
              URLRequest(url: WebUri('https://httpbin.org/json')),
          initialSettings: InAppWebViewSettings(
            useNetworkCapture: true,
            networkCapture: collector,
          ),
          onNetworkLoadingFinished: (c, b) {
            if (!completer.isCompleted) completer.complete(b);
          },
        );
        await headless.run();
        final body = await completer.future.timeout(
          const Duration(seconds: 30),
          onTimeout: () =>
              fail('onNetworkLoadingFinished did not fire within 30s'),
        );
        expect(body.body, isNotEmpty);
        expect(body.decoded, isA<Map>());
        await headless.dispose();
      });
    }, timeout: const Timeout(Duration(seconds: 60)));

    testWidgets('B2: real SPA captures XHR/fetch API calls', (tester) async {
      await tester.runAsync(() async {
        final collector = NetworkCaptureController();
        final headless = HeadlessInAppWebView(
          initialUrlRequest:
              URLRequest(url: WebUri('https://www.trendyol.com/sr?q=telefon')),
          initialSettings: InAppWebViewSettings(
            useNetworkCapture: true,
            networkCapture: collector,
            networkCaptureUrlPatterns: ['api', 'search', 'product'],
            networkCaptureMaxBodySize: 50000,
          ),
        );
        await headless.run();
        try {
          await collector.waitForIdle(
            timeout: const Duration(seconds: 25),
            quietDuration: const Duration(milliseconds: 3000),
          );
        } on TimeoutException {
          // acceptable — proceed with partial capture
        }
        final entries =
            await collector.getEntries(mimeTypes: ['application/json']);
        for (final e in entries.take(5)) {
          debugPrint('URL: ${e.request.url}');
          debugPrint('Status: ${e.response?.statusCode}');
          debugPrint('Body length: ${e.responseBody?.body.length}');
          debugPrint('---');
        }
        expect(entries.length, greaterThan(0),
            reason: 'no JSON API calls captured on trendyol');
        expect(entries.any((e) => e.responseBody != null), isTrue);
        await headless.dispose();
      });
    }, timeout: const Timeout(Duration(seconds: 90)));
  });
}
