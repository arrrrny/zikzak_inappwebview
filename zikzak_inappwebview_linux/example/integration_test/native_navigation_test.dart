import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zikzak_inappwebview_linux/zikzak_inappwebview_linux.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'native navigation preserves authentication and document-start bridge',
    (tester) async {
      LinuxInAppWebViewPlatform.registerWith();
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));
      final requests = server.asBroadcastStream();
      final responses = requests.listen((request) {
        request.response.headers.contentType = ContentType.html;
        request.response.write('''<!doctype html><html><head><script>
window.pageSawDocumentStart = window.documentStartToken;
</script></head><body>Native navigation fixture<script>
window.receivedAuthentication = ${jsonEncode(request.headers.value('x-authentication'))};
window.receivedCookie = ${jsonEncode(request.headers.value('cookie'))};
</script></body></html>''');
        unawaited(request.response.close());
      });
      addTearDown(responses.cancel);
      final origin = 'http://127.0.0.1:${server.port}';
      final cookies = LinuxCookieManager(
        const LinuxCookieManagerCreationParams(),
      );
      expect(
        await cookies.setCookie(
          url: WebUri('$origin/authenticated'),
          name: 'session',
          value: 'native-session',
          isHttpOnly: true,
        ),
        isTrue,
      );
      final ready = Completer<PlatformInAppWebViewController>();
      final loaded = StreamController<String>.broadcast();
      addTearDown(loaded.close);
      final prevented = Completer<void>();
      Future<NavigationActionPolicy> Function() navigationPolicy = () async =>
          NavigationActionPolicy.ALLOW;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => LinuxInAppWebViewWidget(
                LinuxInAppWebViewWidgetCreationParams(
                  initialSettings: InAppWebViewSettings(
                    useShouldOverrideUrlLoading: true,
                  ),
                  initialUserScripts: UnmodifiableListView([
                    UserScript(
                      source:
                          'window.documentStartToken = "injected-before-page";',
                      injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
                    ),
                  ]),
                  onWebViewCreated: (controller) => ready.complete(controller),
                  onLoadStop: (_, url) => loaded.add(url.toString()),
                  shouldOverrideUrlLoading: (_, action) => navigationPolicy(),
                ),
              ).build(context),
            ),
          ),
        ),
      );
      final controller = await ready.future.timeout(
        const Duration(seconds: 30),
      );
      final firstLoaded = loaded.stream.firstWhere(
        (url) => url == '$origin/authenticated',
      );
      await controller.loadUrl(
        urlRequest: URLRequest(
          url: WebUri('$origin/authenticated'),
          headers: {'X-Authentication': 'native-token'},
        ),
      );
      await firstLoaded.timeout(const Duration(seconds: 30));
      final authHeader = await controller.evaluateJavascript(
        source: 'window.receivedAuthentication',
      );
      final cookieHeader = await controller.evaluateJavascript(
        source: 'window.receivedCookie',
      );
      final docStart = await controller.evaluateJavascript(
        source: 'window.pageSawDocumentStart',
      );
      expect(authHeader, 'native-token');
      expect(cookieHeader, 'session=native-session');
      expect(docStart, 'injected-before-page');
      expect(
        await controller.evaluateJavascript(source: 'document.cookie'),
        '',
      );
      final bridgeReply = Completer<List<dynamic>>();
      final bridgeResult = Completer<List<dynamic>>();
      controller.addJavaScriptHandler(
        handlerName: 'nativeProbeResult',
        callback: (args) {
          bridgeResult.complete(args);
          return null;
        },
      );
      controller.addJavaScriptHandler(
        handlerName: 'nativeProbe',
        callback: (args) {
          bridgeReply.complete(args);
          return 'native-reply';
        },
      );
      await controller.evaluateJavascript(
        source:
            'window.zikzak_inappwebview.callHandler("nativeProbe", "from-page")'
            '.then(reply => window.zikzak_inappwebview.callHandler("nativeProbeResult", reply))',
      );
      final bridgeArgs = await bridgeReply.future.timeout(
        const Duration(seconds: 30),
      );
      final bridgeResultArgs = await bridgeResult.future.timeout(
        const Duration(seconds: 30),
      );
      expect(bridgeArgs, ['from-page']);
      expect(bridgeResultArgs, ['native-reply']);
      final plainLoaded = loaded.stream.firstWhere(
        (url) => url == '$origin/plain',
      );
      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri('$origin/plain')),
      );
      await plainLoaded.timeout(const Duration(seconds: 30));
      final plainAuthHeader = await controller.evaluateJavascript(
        source: 'window.receivedAuthentication',
      );
      expect(plainAuthHeader, isNull);
      navigationPolicy = () async {
        if (!prevented.isCompleted) prevented.complete();
        return NavigationActionPolicy.CANCEL;
      };
      await controller.evaluateJavascript(
        source: 'window.location.href = "$origin/blocked";',
      );
      await prevented.future.timeout(const Duration(seconds: 30));
      final currentUrl = (await controller.getUrl()).toString();
      expect(currentUrl, '$origin/plain');
      binding.reportData = {
        'headersPreserved': authHeader == 'native-token',
        'plainNavigationClearsHeaders': plainAuthHeader == null,
        'httpOnlyCookieSent': cookieHeader == 'session=native-session',
        'documentStartScriptObserved': docStart == 'injected-before-page',
        'bridgeRoundTrip': bridgeResultArgs.contains('native-reply'),
        'navigationPrevented':
            prevented.isCompleted && currentUrl == '$origin/plain',
      };
      await tester.pumpWidget(const SizedBox.shrink());
      final outPath =
          Platform.environment['NATIVE_RESULT_PATH'] ??
          'native-navigation-result.json';
      await File(outPath).writeAsString(jsonEncode(binding.reportData));
    },
  );
}
