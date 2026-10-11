import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Records dispose invocations for [HeadlessInAppWebView] guard tests.
///
/// Only [dispose] is exercised by these tests; all other members fall back to
/// the base class's `UnimplementedError` defaults.
class _FakeHeadlessPlatform extends PlatformHeadlessInAppWebView {
  _FakeHeadlessPlatform()
    : super.implementation(
        PlatformHeadlessInAppWebViewCreationParams(
          controllerFromPlatform: (_) => throw UnimplementedError(),
        ),
      );

  int disposeCount = 0;
  bool lastKeepAlive = true;
  bool ran = false;

  @override
  Future<void> run() async {
    ran = true;
  }

  @override
  bool isRunning() => ran;

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

    test('U3: a second dispose() call is a no-op (idempotent)', () async {
      final platform = _FakeHeadlessPlatform();
      final headless = HeadlessInAppWebView.fromPlatform(platform: platform);

      await headless.dispose();
      await headless.dispose();

      expect(platform.disposeCount, 1);
    });

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

    test(
      'U5: dispose(isKeepAlive: false) after dispose(isKeepAlive: true) forwards false and fully releases (bug #295)',
      () async {
        final platform = _FakeHeadlessPlatform();
        final headless = HeadlessInAppWebView.fromPlatform(platform: platform);

        await headless.dispose(isKeepAlive: true);
        await headless.dispose();

        expect(
          platform.disposeCount,
          2,
          reason:
              'the plain dispose after a keepAlive dispose must reach '
              'the platform to release the retained native view (FR-007)',
        );
        expect(
          platform.lastKeepAlive,
          isFalse,
          reason: 'the release dispose forwards isKeepAlive: false',
        );
      },
    );

    test(
      'U5b: a repeated dispose(isKeepAlive: true) while keepAlive is held is a no-op (idempotent)',
      () async {
        final platform = _FakeHeadlessPlatform();
        final headless = HeadlessInAppWebView.fromPlatform(platform: platform);

        await headless.dispose(isKeepAlive: true);
        await headless.dispose(isKeepAlive: true);

        expect(
          platform.disposeCount,
          1,
          reason:
              'an identical keepAlive repeat must not re-reach the platform',
        );
      },
    );

    test(
      'U5c: after a plain dispose fully released the view, a later keepAlive dispose is a no-op',
      () async {
        final platform = _FakeHeadlessPlatform();
        final headless = HeadlessInAppWebView.fromPlatform(platform: platform);

        await headless.dispose();
        await headless.dispose(isKeepAlive: true);

        expect(
          platform.disposeCount,
          1,
          reason: 'released is terminal: the native view cannot be re-retained',
        );
      },
    );

    test(
      'U2: dispose() after run() forwards to platform.dispose(isKeepAlive: false) exactly once',
      () async {
        final platform = _FakeHeadlessPlatform();
        final headless = HeadlessInAppWebView.fromPlatform(platform: platform);

        await headless.run();
        await headless.dispose();

        expect(
          platform.disposeCount,
          1,
          reason: 'a single dispose after run reaches the platform once',
        );
        expect(
          platform.lastKeepAlive,
          isFalse,
          reason: 'default dispose forwards isKeepAlive: false',
        );
      },
    );
  });
}
