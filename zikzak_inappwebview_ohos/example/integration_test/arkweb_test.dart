import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('the first document retains early scripts, JS replies and native cookie scopes', (tester) async {
    final created = Completer<PlatformInAppWebViewController>();
    final loaded = Completer<void>();
    final reply = Completer<dynamic>();
    final navigation = Completer<String>();
    final view = PlatformInAppWebViewWidget(PlatformInAppWebViewWidgetCreationParams(
      initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
      initialData: InAppWebViewInitialData(
        data: '''<html><head><script>window.inlineSawStart=window.start;</script></head><body><h1>ArkWeb</h1><script>window.zikzak_inappwebview.callHandler('echo',{number:7,text:'中文'}).then(value=>window.zikzak_inappwebview.callHandler('done',value));</script></body></html>''',
        baseUrl: WebUri('https://zikzak-fixture.invalid/'),
        historyUrl: WebUri('https://zikzak-fixture.invalid/'),
      ),
      initialUserScripts: UnmodifiableListView([
        UserScript(source: "window.start='before-inline';", injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START),
      ]),
      onWebViewCreated: (dynamic controller) {
        final platform = controller as PlatformInAppWebViewController;
        platform.addJavaScriptHandler(handlerName: 'echo', callback: (args) => {'received': args.single, 'reply': 'Dart'});
        platform.addJavaScriptHandler(handlerName: 'done', callback: (args) { reply.complete(args.single); return null; });
        created.complete(platform);
      },
      onLoadStop: (_, _) => loaded.complete(),
      shouldOverrideUrlLoading: (_, action) async {
        navigation.complete(action.request.url.toString());
        return NavigationActionPolicy.CANCEL;
      },
    ));
    addTearDown(view.dispose);
    await tester.pumpWidget(Directionality(textDirection: TextDirection.ltr, child: Builder(builder: view.build)));
    final controller = await created.future;
    await loaded.future;
    expect(await controller.evaluateJavascript(source: 'window.inlineSawStart'), 'before-inline');
    expect(await reply.future, {'received': {'number': 7, 'text': '中文'}, 'reply': 'Dart'});
    expect(await controller.evaluateJavascript(source: '({nested:[42,true,"珞家"]})'), {'nested': [42, true, '珞家']});

    final cookies = PlatformCookieManager(const PlatformCookieManagerCreationParams());
    final url = WebUri('https://zikzak-fixture.invalid/auth/login');
    await cookies.setCookie(url: url, name: 'session', value: 'root', path: '/', isHttpOnly: true, isSecure: true);
    await cookies.setCookie(url: url, name: 'session', value: 'auth', path: '/auth', isHttpOnly: true, isSecure: true);
    expect((await cookies.getCookies(url: url)).map((cookie) => cookie.value), ['auth', 'root']);
    expect((await cookies.getCookies(url: url)).first.isHttpOnly, isTrue);
    await cookies.deleteCookie(url: url, name: 'session', path: '/auth');
    await cookies.deleteCookie(url: url, name: 'session', path: '/');
    expect(await cookies.getCookies(url: url), isEmpty);

    await controller.setSettings(settings: InAppWebViewSettings(javaScriptEnabled: true, userAgent: 'ZikzakArkWebFixture/1'));
    expect(await controller.evaluateJavascript(source: 'navigator.userAgent'), 'ZikzakArkWebFixture/1');
    await controller.evaluateJavascript(source: "location.href='https://blocked.zikzak-fixture.invalid/';");
    expect(await navigation.future, 'https://blocked.zikzak-fixture.invalid/');
    expect((await controller.getUrl())?.host, 'zikzak-fixture.invalid');
  });
}
