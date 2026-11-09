import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_linux/src/in_app_webview/custom_platform_view.dart';
import 'package:zikzak_inappwebview_linux/src/in_app_webview/in_app_webview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  Future<Map> initialSettings(WidgetTester tester, LinuxInAppWebViewWidget widget) async {
    Widget? built;
    await tester.pumpWidget(Builder(builder: (context) {
      built = widget.build(context);
      return const SizedBox();
    }));
    return (built! as CustomPlatformView).creationParams['initialSettings'] as Map;
  }

  testWidgets('build enables the Ajax event keys for the set callbacks', (tester) async {
    final settings = await initialSettings(
      tester,
      LinuxInAppWebViewWidget(PlatformInAppWebViewWidgetCreationParams(
        onAjaxProgress: (c, request) async => null,
      )),
    );
    // zikzak's InAppWebViewSettings has no useOnAjaxProgress; without the key
    // native never reports progress (linux/plugin_scripts_js).
    expect(settings['useOnAjaxProgress'], true);
    expect(settings['useShouldInterceptAjaxRequest'], true);
    expect(settings.containsKey('useOnAjaxReadyStateChange'), isFalse);
  });

  testWidgets('build sends no Ajax event keys without the callbacks', (tester) async {
    final settings = await initialSettings(
      tester,
      LinuxInAppWebViewWidget(PlatformInAppWebViewWidgetCreationParams()),
    );
    expect(settings.containsKey('useOnAjaxReadyStateChange'), isFalse);
    expect(settings.containsKey('useOnAjaxProgress'), isFalse);
  });
}
