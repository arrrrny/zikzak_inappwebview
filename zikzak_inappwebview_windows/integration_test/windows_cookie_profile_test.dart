import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_windows/zikzak_inappwebview_windows.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'native CookieManager and visible WebView share HttpOnly sessions',
    (tester) async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));
      final requests = StreamController<HttpRequest>.broadcast();
      addTearDown(requests.close);
      server.listen((incoming) async {
        requests.add(incoming);
        incoming.response.write('<!doctype html><title>Session</title>');
        await incoming.response.close();
      });
      final url = WebUri('http://127.0.0.1:${server.port}/');
      ZikzakInAppWebViewWindows.registerWith();
      final environment = await tester.runAsync(
        () => PlatformWebViewEnvironment.static().create(
          settings: WebViewEnvironmentSettings(
            userDataFolder: Platform.environment['WEBVIEW2_USER_DATA_FOLDER']!,
          ),
        ),
      );
      final cookies = PlatformCookieManager(
        PlatformCookieManagerCreationParams(webViewEnvironment: environment),
      );
      expect(
        await tester.runAsync(
          () => cookies.setCookie(
            url: url,
            name: 'SESSION',
            value: 'native-token',
            isHttpOnly: true,
          ),
        ),
        isTrue,
      );
      final ready = Completer<PlatformInAppWebViewController>();
      final loaded = Completer<void>();
      final browser = PlatformInAppWebViewWidget(
        PlatformInAppWebViewWidgetCreationParams(
          webViewEnvironment: environment,
          onWebViewCreated: (controller) =>
              ready.complete(controller as PlatformInAppWebViewController),
          onLoadStop: (_, _) => loaded.complete(),
        ),
      );
      await tester.pumpWidget(
        MaterialApp(home: Builder(builder: browser.build)),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        final controller = await ready.future.timeout(
          const Duration(seconds: 30),
        );
        final request = requests.stream.firstWhere(
          (request) => request.uri.path == '/',
        );
        await controller.loadUrl(urlRequest: URLRequest(url: url));
        expect(
          (await request.timeout(const Duration(seconds: 20))).headers
              .value('cookie'),
          contains('SESSION=native-token'),
        );
        await loaded.future.timeout(const Duration(seconds: 20));
        expect(
          await controller.evaluateJavascript(source: 'document.cookie'),
          isNot(contains('SESSION=')),
        );
        expect(
          (await cookies.getCookie(url: url, name: 'SESSION'))?.isHttpOnly,
          isTrue,
        );
        await cookies.deleteAllCookies();
        expect(await cookies.getCookies(url: url), isEmpty);
      });
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(() => environment!.dispose());
    },
  );
}
