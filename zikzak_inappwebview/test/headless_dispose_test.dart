import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Minimal platform fake that records how many times [dispose] is invoked.
///
/// All other members fall back to the base class's `UnimplementedError`
/// defaults, which is fine because the test only exercises [dispose].
class _FakeHeadlessPlatform extends PlatformHeadlessInAppWebView {
  _FakeHeadlessPlatform()
      : super.implementation(PlatformHeadlessInAppWebViewCreationParams(
          controllerFromPlatform: (_) => throw UnimplementedError(),
        ));

  int disposeCount = 0;

  @override
  Future<void> dispose({bool isKeepAlive = false}) async {
    disposeCount++;
  }
}

void main() {
  test(
    'HeadlessInAppWebView.dispose delegates to the platform once per call',
    () async {
      final platform = _FakeHeadlessPlatform();
      final headless = HeadlessInAppWebView.fromPlatform(platform: platform);

      await headless.dispose();
      expect(platform.disposeCount, 1);

      // Spec 013 restored the umbrella-level double-dispose guard: a second
      // dispose is a no-op and does not reach the platform again.
      await headless.dispose();
      expect(platform.disposeCount, 1);
    },
  );
}
