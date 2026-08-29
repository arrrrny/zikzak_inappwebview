import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Records dispose invocations for [InAppWebViewController] and [InAppWebView]
/// forwarding tests. Only [dispose] is exercised; all other members fall back to
/// the base class's `UnimplementedError` defaults.
class _FakePlatformController extends PlatformInAppWebViewController {
  _FakePlatformController()
      : super.implementation(
          const PlatformInAppWebViewControllerCreationParams(id: 'c1'),
        );

  int disposeCount = 0;
  bool lastKeepAlive = false;

  @override
  Future<void> dispose({bool isKeepAlive = false}) async {
    disposeCount++;
    lastKeepAlive = isKeepAlive;
  }
}

void main() {
  group('InAppWebViewController / InAppWebView dispose forwarding (spec 013)', () {
    test(
      'U8: InAppWebViewController.dispose(isKeepAlive: true) forwards to platform.dispose(isKeepAlive: true)',
      () {
        final platform = _FakePlatformController();
        final controller =
            InAppWebViewController.fromPlatform(platform: platform);

        controller.dispose(isKeepAlive: true);

        expect(platform.disposeCount, 1);
        expect(platform.lastKeepAlive, isTrue);
      },
    );
  });
}
