/// GYM warmup rep #3 — JS bridge smoke call through the public controller
/// API (zikzak_inappwebview).
///
/// The issue asks for a bridge smoke call per package. Headless CI has no
/// device, so this rep drives the bridge the way the repo's own tests do
/// (see test/headless_dispose_test.dart): a faked platform controller
/// standing in for the native WebView. The rep boots an
/// [InAppWebViewController] on the fake and round-trips ONE JavaScript
/// evaluation through the public `JavaScriptController` facade — the
/// same call every operator writes first. `flutter test` is the grader
/// (exit 0 = rep OK).
///
/// Run from the plugin package root:
/// `flutter test .gym/warmup/03-bridge-smoke_test.dart`
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Minimal platform fake: records every evaluated source and echoes it
/// back — enough surface for a bridge smoke call.
class _FakePlatformController extends PlatformInAppWebViewController {
  _FakePlatformController()
      : super.implementation(
          const PlatformInAppWebViewControllerCreationParams(
            id: 'gym-smoke-webview',
          ),
        );

  final List<String> evaluatedSources = <String>[];

  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) async {
    evaluatedSources.add(source);
    return 'echo:$source';
  }
}

void main() {
  test(
    '03-bridge-smoke: evaluateJavascript round-trips through the public '
    'controller API',
    () async {
      final platform = _FakePlatformController();
      final controller = InAppWebViewController.fromPlatform(platform: platform);

      const source = 'window.gymEcho("ping")';
      final result = await controller.javaScript.evaluateJavascript(
        source: source,
      );

      expect(result, 'echo:$source',
          reason: 'the JS evaluation result must round-trip to the caller');
      expect(platform.evaluatedSources, <String>[source],
          reason: 'the platform must receive exactly the source that was '
              'sent through the public facade');
    },
  );
}
