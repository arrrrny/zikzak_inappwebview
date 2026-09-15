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
  }, skip: !Platform.isIOS);

  testWidgets('iOS cancels custom schemes that no host policy handles', (
    WidgetTester tester,
  ) async {
    final created = Completer<InAppWebViewController>();
    final loaded = Completer<void>();
    var loadStops = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InAppWebView(
            initialSettings: InAppWebViewSettings(
              useShouldOverrideUrlLoading: false,
            ),
            onWebViewCreated: (controller) {
              created.complete(controller);
            },
            onLoadStop: (controller, url) {
              loadStops++;
              if (!loaded.isCompleted) loaded.complete();
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

    final urlBefore = await controller.getUrl();
    final loadStopsBefore = loadStops;

    await controller.evaluateJavascript(
      source: "window.location.href = 'weixin://wap/pay?token=test';",
    );
    await tester.pump(const Duration(seconds: 2));
    await Future<void>.delayed(const Duration(seconds: 2));

    expect(loadStops, loadStopsBefore);
    expect(await controller.getUrl(), urlBefore);
  }, skip: !Platform.isIOS);

  testWidgets('iOS honours a host policy that allows a custom scheme', (
    WidgetTester tester,
  ) async {
    final created = Completer<InAppWebViewController>();
    final loaded = Completer<void>();
    final allowedThrough = Completer<String>();

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
            onReceivedError: (controller, request, error) {
              // An allowed custom scheme reaches WebKit, which cannot load it
              // and fails the navigation. A cancelled one never gets that far.
              if (!allowedThrough.isCompleted) {
                allowedThrough.complete(
                  request.url?.toString() ?? error.description,
                );
              }
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async =>
                NavigationActionPolicy.ALLOW,
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
      await allowedThrough.future.timeout(const Duration(seconds: 20)),
      isNotEmpty,
    );
  }, skip: !Platform.isIOS);
}
