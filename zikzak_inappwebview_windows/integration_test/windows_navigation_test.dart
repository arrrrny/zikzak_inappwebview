import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_windows/zikzak_inappwebview_windows.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('headers and persistent navigation policy reach native WebView2', (
    tester,
  ) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    final origin = 'http://127.0.0.1:${server.port}';
    final requests = StreamController<HttpRequest>.broadcast();
    final navigation = StreamController<NavigationAction>.broadcast();
    final finished = StreamController<String>.broadcast();
    addTearDown(requests.close);
    addTearDown(navigation.close);
    addTearDown(finished.close);
    final received = <String>[];
    server.listen((request) async {
      received.add(request.uri.path);
      requests.add(request);
      request.response.headers.contentType = ContentType.html;
      request.response.write('<html><title>Navigation contract</title></html>');
      await request.response.close();
    });
    ZikzakInAppWebViewWindows.registerWith();
    final environment = await tester.runAsync(
      () => PlatformWebViewEnvironment.static().create(
        settings: WebViewEnvironmentSettings(
          userDataFolder: Platform.environment['WEBVIEW2_USER_DATA_FOLDER']!,
        ),
      ),
    );
    var policy = NavigationActionPolicy.ALLOW;
    final ready = Completer<PlatformInAppWebViewController>();
    final browser = PlatformInAppWebViewWidget(
      PlatformInAppWebViewWidgetCreationParams(
        webViewEnvironment: environment,
        shouldOverrideUrlLoading: (_, action) async {
          navigation.add(action);
          return policy;
        },
        onLoadStop: (_, url) => finished.add(url.toString()),
        onWebViewCreated: (controller) =>
            ready.complete(controller as PlatformInAppWebViewController),
      ),
    );
    await tester.pumpWidget(MaterialApp(home: Builder(builder: browser.build)));
    final controller = (await tester.runAsync(
      () => ready.future.timeout(const Duration(seconds: 30)),
    ))!;
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      final first = requests.stream.firstWhere(
        (request) => request.uri.path == '/first',
      );
      final firstLoaded = finished.stream.firstWhere(
        (url) => url == '$origin/first',
      );
      await controller.loadUrl(
        urlRequest: URLRequest(
          url: WebUri('$origin/first'),
          headers: {'X-Native-Probe': 'headers'},
        ),
      );
      expect(
        (await first.timeout(const Duration(seconds: 20))).headers
            .value('X-Native-Probe'),
        'headers',
      );
      await firstLoaded.timeout(const Duration(seconds: 20));

      final secondPolicy = navigation.stream.firstWhere(
        (action) => action.request.url.toString() == '$origin/second',
      );
      final second = requests.stream.firstWhere(
        (request) => request.uri.path == '/second',
      );
      final secondLoaded = finished.stream.firstWhere(
        (url) => url == '$origin/second',
      );
      await controller.evaluateJavascript(
        source: "location.href = '$origin/second';",
      );
      expect(
        (await secondPolicy.timeout(const Duration(seconds: 20)))
            .isForMainFrame,
        isTrue,
      );
      expect(
        (await second.timeout(const Duration(seconds: 20))).headers
            .value('X-Native-Probe'),
        isNull,
      );
      await secondLoaded.timeout(const Duration(seconds: 20));

      policy = NavigationActionPolicy.CANCEL;
      final blocked = navigation.stream.firstWhere(
        (action) => action.request.url.toString() == '$origin/blocked',
      );
      await controller.evaluateJavascript(
        source: "location.href = '$origin/blocked';",
      );
      expect(
        (await blocked.timeout(const Duration(seconds: 20))).isForMainFrame,
        isTrue,
      );
      // Queueing through loadUrl waits for cancellation to settle. The next
      // successful HTTP load also proves that policy remains live after CANCEL.
      policy = NavigationActionPolicy.ALLOW;
      final last = requests.stream.firstWhere(
        (request) => request.uri.path == '/last',
      );
      final lastLoaded = finished.stream.firstWhere(
        (url) => url == '$origin/last',
      );
      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri('$origin/last')),
      );
      await last.timeout(const Duration(seconds: 20));
      await lastLoaded.timeout(const Duration(seconds: 20));
      expect(received, isNot(contains('/blocked')));
    });
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.runAsync(() => environment!.dispose());
  });
}
