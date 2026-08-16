import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Compile-time assertion that [T] implements the [Disposable] interface.
///
/// If a wrapper class ever drops `implements Disposable`, this file stops
/// compiling, so `flutter analyze` and `flutter test` both fail.
void expectDisposable<T extends Disposable>() {}

/// Probe implementing [Disposable] with the canonical signature:
/// `void dispose({bool isKeepAlive = false})`.
///
/// If the interface ever drifts (for example the named parameter is
/// renamed or its type changes), this override stops being a valid
/// implementation and the file no longer compiles.
class _ProbeDisposable implements Disposable {
  @override
  void dispose({bool isKeepAlive = false}) {}
}

// -------------------------------------------------------------------
// Fakes
// -------------------------------------------------------------------

class _FakePlatformController extends PlatformInAppWebViewController {
  int disposeCallCount = 0;
  bool? lastIsKeepAlive;
  bool shouldThrowOnDispose = false;

  _FakePlatformController() : super.implementation(const PlatformInAppWebViewControllerCreationParams(id: 'fake'));

  @override
  void dispose({bool isKeepAlive = false}) {
    disposeCallCount++;
    if (shouldThrowOnDispose) {
      throw StateError('platform dispose error');
    }
    lastIsKeepAlive = isKeepAlive;
  }
}

class _FakePlatformHeadlessWebView extends PlatformHeadlessInAppWebView {
  int disposeCallCount = 0;
  bool? lastIsKeepAlive;
  bool shouldThrowOnDispose = false;

  _FakePlatformHeadlessWebView()
      : super.implementation(const PlatformHeadlessInAppWebViewCreationParams());

  @override
  String get id => 'fake-headless';

  @override
  Future<void> dispose({bool isKeepAlive = false}) async {
    disposeCallCount++;
    if (shouldThrowOnDispose) {
      throw StateError('platform dispose error');
    }
    lastIsKeepAlive = isKeepAlive;
  }

  @override
  Future<void> run() async {}

  @override
  bool isRunning() => false;

  @override
  Future<void> setSize(Size size) async {}

  @override
  Future<Size?> getSize() async => null;
}

class _FakePlatformLocalhostServer extends PlatformInAppLocalhostServer {
  int closeCallCount = 0;
  bool running = true;

  _FakePlatformLocalhostServer()
      : super.implementation(const PlatformInAppLocalhostServerCreationParams());

  @override
  Future<void> start() async { running = true; }

  @override
  Future<void> close() async { closeCallCount++; running = false; }

  @override
  bool isRunning() => running;
}

// -------------------------------------------------------------------
// Tests
// -------------------------------------------------------------------

void main() {
  group('Disposable pattern standardization', () {
    // ---------------------------------------------------------------
    // Compile-time checks
    // ---------------------------------------------------------------
    test('wrapper classes implement Disposable', () {
      expectDisposable<InAppWebViewController>();
      expectDisposable<InAppWebView>();
      expectDisposable<HeadlessInAppWebView>();
      expectDisposable<InAppLocalhostServer>();
    });

    test('Disposable declares the standardized dispose signature', () {
      final Disposable probe = _ProbeDisposable();
      final void Function({bool isKeepAlive}) dispose = probe.dispose;
      expect(dispose, isNotNull);
    });

    // ---------------------------------------------------------------
    // InAppWebViewController: double-dispose guard
    // ---------------------------------------------------------------
    group('InAppWebViewController dispose', () {
      test('dispose forwards isKeepAlive to platform', () {
        final fake = _FakePlatformController();
        final controller = InAppWebViewController.fromPlatform(platform: fake);

        controller.dispose(isKeepAlive: true);

        expect(fake.disposeCallCount, 1);
        expect(fake.lastIsKeepAlive, true);
      });

      test('double-dispose is idempotent', () {
        final fake = _FakePlatformController();
        final controller = InAppWebViewController.fromPlatform(platform: fake);

        controller.dispose();
        controller.dispose();
        controller.dispose(isKeepAlive: true);

        expect(fake.disposeCallCount, 1);
        expect(controller.disposed, true);
      });

      test('disposed getter reflects dispose state', () {
        final fake = _FakePlatformController();
        final controller = InAppWebViewController.fromPlatform(platform: fake);

        expect(controller.disposed, false);

        controller.dispose();

        expect(controller.disposed, true);
      });

      test('dispose exception marks disposed and suppresses retry', () {
        final fake = _FakePlatformController()..shouldThrowOnDispose = true;
        final controller = InAppWebViewController.fromPlatform(platform: fake);

        expect(() => controller.dispose(), throwsStateError);
        expect(controller.disposed, true);
        expect(fake.disposeCallCount, 1);

        // Second call must not throw and must not re-forward to platform.
        controller.dispose();
        expect(fake.disposeCallCount, 1);
      });
    });

    // ---------------------------------------------------------------
    // HeadlessInAppWebView: double-dispose guard + dispose-before-run
    // ---------------------------------------------------------------
    group('HeadlessInAppWebView dispose', () {
      test('dispose forwards isKeepAlive to platform', () async {
        final fake = _FakePlatformHeadlessWebView();
        final headless = HeadlessInAppWebView.fromPlatform(platform: fake);

        await headless.dispose(isKeepAlive: true);

        expect(fake.disposeCallCount, 1);
        expect(fake.lastIsKeepAlive, true);
      });

      test('double-dispose is idempotent', () async {
        final fake = _FakePlatformHeadlessWebView();
        final headless = HeadlessInAppWebView.fromPlatform(platform: fake);

        await headless.dispose();
        await headless.dispose();
        await headless.dispose(isKeepAlive: true);

        expect(fake.disposeCallCount, 1);
        expect(headless.disposed, true);
      });

      test('disposed getter reflects dispose state', () async {
        final fake = _FakePlatformHeadlessWebView();
        final headless = HeadlessInAppWebView.fromPlatform(platform: fake);

        expect(headless.disposed, false);

        await headless.dispose();

        expect(headless.disposed, true);
      });

      test('dispose before run does not leak', () async {
        final fake = _FakePlatformHeadlessWebView();
        final headless = HeadlessInAppWebView.fromPlatform(platform: fake);

        // Dispose without calling run() — should not throw.
        await headless.dispose();

        expect(fake.disposeCallCount, 1);
        expect(headless.disposed, true);
        expect(headless.isRunning(), false);
      });

      test('dispose after run cleans up correctly', () async {
        final fake = _FakePlatformHeadlessWebView();
        final headless = HeadlessInAppWebView.fromPlatform(platform: fake);

        await headless.run();
        await headless.dispose();

        expect(fake.disposeCallCount, 1);
        expect(headless.disposed, true);
      });

      test('dispose exception marks disposed and suppresses retry', () async {
        final fake = _FakePlatformHeadlessWebView()..shouldThrowOnDispose = true;
        final headless = HeadlessInAppWebView.fromPlatform(platform: fake);

        await expectLater(headless.dispose(), throwsA(isA<StateError>()));
        expect(headless.disposed, true);
        expect(fake.disposeCallCount, 1);

        // Second call must complete normally without re-forwarding.
        await headless.dispose();
        expect(fake.disposeCallCount, 1);
      });
    });

    // ---------------------------------------------------------------
    // InAppLocalhostServer: double-dispose guard (already existed)
    // ---------------------------------------------------------------
    group('InAppLocalhostServer dispose', () {
      test('double-dispose is idempotent', () async {
        final fake = _FakePlatformLocalhostServer();
        final server = InAppLocalhostServer.fromPlatform(fake);

        await server.start();
        server.dispose();
        server.dispose();

        expect(fake.closeCallCount, 1);
        expect(server.disposed, true);
      });

      test('dispose on non-running server is safe', () {
        final fake = _FakePlatformLocalhostServer();
        fake.running = false;
        final server = InAppLocalhostServer.fromPlatform(fake);

        server.dispose();

        expect(fake.closeCallCount, 0);
        expect(server.disposed, true);
      });

      test('disposed getter reflects dispose state', () async {
        final fake = _FakePlatformLocalhostServer();
        final server = InAppLocalhostServer.fromPlatform(fake);

        expect(server.disposed, false);

        await server.start();
        server.dispose();

        expect(server.disposed, true);
      });
    });

    // ---------------------------------------------------------------
    // isKeepAlive consistency
    // ---------------------------------------------------------------
    group('isKeepAlive behavior consistency', () {
      test('InAppWebViewController defaults isKeepAlive to false', () {
        final fake = _FakePlatformController();
        final controller = InAppWebViewController.fromPlatform(platform: fake);

        controller.dispose();

        expect(fake.lastIsKeepAlive, false);
      });

      test('HeadlessInAppWebView defaults isKeepAlive to false', () async {
        final fake = _FakePlatformHeadlessWebView();
        final headless = HeadlessInAppWebView.fromPlatform(platform: fake);

        await headless.dispose();

        expect(fake.lastIsKeepAlive, false);
      });
    });
  });
}