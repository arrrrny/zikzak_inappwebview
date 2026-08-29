import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Records dispose invocations for [HeadlessInAppWebView] guard tests.
///
/// Only [dispose] is exercised by these tests; all other members fall back to
/// the base class's `UnimplementedError` defaults.
class _FakeHeadlessPlatform extends PlatformHeadlessInAppWebView {
  _FakeHeadlessPlatform()
      : super.implementation(PlatformHeadlessInAppWebViewCreationParams(
          controllerFromPlatform: (_) => throw UnimplementedError(),
        ));

  int disposeCount = 0;
  bool lastKeepAlive = true;

  @override
  Future<void> dispose({bool isKeepAlive = false}) async {
    disposeCount++;
    lastKeepAlive = isKeepAlive;
  }
}

void main() {
  group('HeadlessInAppWebView dispose guard (spec 013)', () {
    test(
      'U1: dispose before run forwards to platform.dispose(isKeepAlive: false) exactly once',
      () async {
        final platform = _FakeHeadlessPlatform();
        final headless = HeadlessInAppWebView.fromPlatform(platform: platform);

        await headless.dispose();

        expect(platform.disposeCount, 1);
        expect(platform.lastKeepAlive, isFalse);
      },
    );

    test(
      'U3: a second dispose() call is a no-op (idempotent)',
      () async {
        final platform = _FakeHeadlessPlatform();
        final headless = HeadlessInAppWebView.fromPlatform(platform: platform);

        await headless.dispose();
        await headless.dispose();

        expect(platform.disposeCount, 1);
      },
    );

    test(
      'U6: concurrent dispose() calls invoke platform.dispose at most once',
      () async {
        final platform = _FakeHeadlessPlatform();
        final headless = HeadlessInAppWebView.fromPlatform(platform: platform);

        await Future.wait([
          headless.dispose(),
          headless.dispose(),
          headless.dispose(),
        ]);

        expect(platform.disposeCount, 1);
      },
    );

    test(
      'U4: dispose(isKeepAlive: true) forwards true to platform.dispose',
      () async {
        final platform = _FakeHeadlessPlatform();
        final headless = HeadlessInAppWebView.fromPlatform(platform: platform);

        await headless.dispose(isKeepAlive: true);

        expect(platform.disposeCount, 1);
        expect(platform.lastKeepAlive, isTrue);
      },
    );
  });
}
