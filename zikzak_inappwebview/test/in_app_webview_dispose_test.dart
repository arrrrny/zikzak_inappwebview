import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
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

/// Records dispose invocations for [InAppWebView] forwarding tests.
class _FakePlatformWidget extends PlatformInAppWebViewWidget {
  _FakePlatformWidget()
      : super.implementation(
          PlatformInAppWebViewWidgetCreationParams(),
        );

  int disposeCount = 0;
  bool lastKeepAlive = false;

  @override
  void dispose({bool isKeepAlive = false}) {
    disposeCount++;
    lastKeepAlive = isKeepAlive;
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();

  @override
  T controllerFromPlatform<T>(PlatformInAppWebViewController controller) =>
      throw UnimplementedError();
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

    test(
      'U9: a later dispose(isKeepAlive: false) after dispose(isKeepAlive: true) forwards false and fully releases',
      () {
        final platform = _FakePlatformController();
        final controller =
            InAppWebViewController.fromPlatform(platform: platform);

        controller.dispose(isKeepAlive: true);
        controller.dispose(isKeepAlive: false);

        expect(platform.disposeCount, 2);
        expect(platform.lastKeepAlive, isFalse,
            reason: 'the second (non-keepAlive) call must forward false');
      },
    );

    test(
      'U11: InAppWebView.dispose(isKeepAlive: true) forwards to platform.dispose(isKeepAlive: true)',
      () {
        final platform = _FakePlatformWidget();
        final webView = InAppWebView.fromPlatform(platform: platform);

        webView.dispose(isKeepAlive: true);

        expect(platform.disposeCount, 1);
        expect(platform.lastKeepAlive, isTrue);
      },
    );

    test(
      'U12: a later InAppWebView.dispose(isKeepAlive: false) after keepAlive forwards false and fully releases',
      () {
        final platform = _FakePlatformWidget();
        final webView = InAppWebView.fromPlatform(platform: platform);

        webView.dispose(isKeepAlive: true);
        webView.dispose(isKeepAlive: false);

        expect(platform.disposeCount, 2);
        expect(platform.lastKeepAlive, isFalse,
            reason: 'the second (non-keepAlive) call must forward false');
      },
    );
  });
}
