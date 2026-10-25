// Issue #371 — the headless WebView lifecycle, end to end on a real engine.
//
// The unit tests in `zikzak_inappwebview_ios/test` mock the method channel, and
// their source-shape companion only greps the Swift files: neither observes the
// native manager. This case drives the real one and covers all four primitives
// at once — two independent headless instances, a dispose that leaves its
// sibling working (R1), and the live-instance cap failing loudly (R4).
//
// Run on the iOS Simulator (the only platform where this layer works here):
//   cd zikzak_inappwebview/example
//   flutter test integration_test/headless_lifecycle_test.dart -d <device>
//
// The example resolves the platform packages from pub.dev by default, so the
// run must override `zikzak_inappwebview_ios` to this checkout — the same
// `pubspec_overrides.yaml` the CI `build-ios` job writes — or the cap half of
// this test exercises the published 6.2.2 native code, where the ceiling does
// not exist yet and the fourth instance is accepted:
//   dependency_overrides:
//     zikzak_inappwebview_ios:
//       path: ../../zikzak_inappwebview_ios
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const page = '<html><body><h1 id="title">headless</h1></body></html>';

  HeadlessInAppWebView build() => HeadlessInAppWebView(
    initialSize: const Size(320, 240),
    initialData: InAppWebViewInitialData(data: page),
  );

  testWidgets('two headless instances: dispose one, then hit the cap', (
    tester,
  ) async {
    final started = <HeadlessInAppWebView>[];
    addTearDown(() async {
      for (final webView in started) {
        await webView.dispose();
      }
    });

    Future<HeadlessInAppWebView> start() async {
      final webView = build();
      started.add(webView);
      await webView.run();
      return webView;
    }

    final first = await start();
    final second = await start();

    expect(
      await second.webViewController!.evaluateJavascript(source: '1 + 1'),
      2,
      reason: 'R3: a headless instance must live in a window that can run JS',
    );

    await first.dispose();
    expect(first.isRunning(), isFalse);
    expect(
      await second.webViewController!.evaluateJavascript(source: '2 + 2'),
      4,
      reason: 'R1: a shared-channel dispose must not tear down its siblings',
    );

    // 3 is the iOS/Android ceiling. `second` is live after the dispose above,
    // so two more fill it — and the next `run()` must be refused rather than
    // silently growing the process's renderer count.
    await start();
    await start();
    final overCap = build();
    addTearDown(overCap.dispose);
    await expectLater(
      overCap.run(),
      throwsA(
        isA<PlatformException>().having(
          (error) => error.code,
          'code',
          'headless_cap_exceeded',
        ),
      ),
      reason: 'R4: the fourth live instance must fail loudly, not be created',
    );
  });
}
