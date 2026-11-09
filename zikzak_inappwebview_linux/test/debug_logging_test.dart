// Native info logging follows PlatformInAppWebViewController.debugLoggingSettings:
// every call that creates something native carries the current `enabled`
// value as `debugLoggingEnabled` (read by linux/utils/log.h).
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_linux/src/in_app_browser/in_app_browser.dart';
import 'package:zikzak_inappwebview_linux/src/in_app_webview/custom_platform_view.dart';
import 'package:zikzak_inappwebview_linux/src/in_app_webview/headless_in_app_webview.dart';
import 'package:zikzak_inappwebview_linux/src/in_app_webview/in_app_webview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final settings = PlatformInAppWebViewController.debugLoggingSettings;
  final originalEnabled = settings.enabled;

  tearDown(() => settings.enabled = originalEnabled);

  for (final enabled in [true, false]) {
    group('debugLoggingSettings.enabled = $enabled', () {
      setUp(() => settings.enabled = enabled);

      testWidgets('createInAppWebView carries the flag', (tester) async {
        Widget? built;
        await tester.pumpWidget(Builder(builder: (context) {
          built = LinuxInAppWebViewWidget(
            PlatformInAppWebViewWidgetCreationParams(),
          ).build(context);
          return const SizedBox();
        }));
        final params = (built! as CustomPlatformView).creationParams as Map;
        expect(params['debugLoggingEnabled'], enabled);
      });

      test('headless run carries the flag', () async {
        const channel = MethodChannel('wtf.zikzak/flutter_headless_inappwebview');
        final calls = <MethodCall>[];
        messenger.setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return null;
        });
        addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

        final headless = LinuxHeadlessInAppWebView(
          LinuxHeadlessInAppWebViewCreationParams(),
        );
        final instance = MethodChannel(
          'wtf.zikzak/flutter_headless_inappwebview_${headless.id}',
        );
        messenger.setMockMethodCallHandler(instance, (_) async => null);
        addTearDown(() => messenger.setMockMethodCallHandler(instance, null));
        await headless.run();
        await headless.dispose();

        final run = calls.singleWhere((c) => c.method == 'run');
        expect((run.arguments as Map)['debugLoggingEnabled'], enabled);
      });

      test('InAppBrowser open carries the flag', () async {
        const channel = MethodChannel('wtf.zikzak/zikzak_inappbrowser');
        final calls = <MethodCall>[];
        messenger.setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return null;
        });
        addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

        final browser = LinuxInAppBrowser(PlatformInAppBrowserCreationParams());
        await browser.openUrlRequest(
          urlRequest: URLRequest(url: WebUri('https://example.com/')),
        );

        final open = calls.singleWhere((c) => c.method == 'open');
        expect((open.arguments as Map)['debugLoggingEnabled'], enabled);
      });
    });
  }
}
