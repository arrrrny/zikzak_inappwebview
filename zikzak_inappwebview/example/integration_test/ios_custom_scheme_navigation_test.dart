import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('iOS forwards custom schemes to shouldOverrideUrlLoading', (
    WidgetTester tester,
  ) async {
    if (!Platform.isIOS) return;

    final created = Completer<InAppWebViewController>();
    final loaded = Completer<void>();
    final intercepted = Completer<String>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InAppWebView(
            initialSettings: InAppWebViewSettings(
              useShouldOverrideUrlLoading: true,
            ),
            onWebViewCreated: (controller) {
              created.complete(controller);
            },
            onLoadStop: (controller, url) {
              if (!loaded.isCompleted) loaded.complete();
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url?.toString() ?? '';
              if (url.startsWith('weixin://')) {
                if (!intercepted.isCompleted) intercepted.complete(url);
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },
          ),
        ),
      ),
    );

    final controller = await created.future.timeout(
      const Duration(seconds: 120),
    );
    await controller.loadData(data: '<html><body>custom scheme</body></html>');
    await loaded.future.timeout(const Duration(seconds: 120));

    await controller.evaluateJavascript(
      source: "window.location.href = 'weixin://wap/pay?token=test';",
    );

    expect(
      await intercepted.future.timeout(const Duration(seconds: 10)),
      'weixin://wap/pay?token=test',
    );
  });
}
