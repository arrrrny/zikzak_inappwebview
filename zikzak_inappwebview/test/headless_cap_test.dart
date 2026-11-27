import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

class _FakeInAppWebViewPlatform extends InAppWebViewPlatform {
  final List<String> events;

  _FakeInAppWebViewPlatform(this.events);

  @override
  Future<void> setHeadlessMaxLiveWebViews(int value) async {
    events.add('configure:$value');
  }
}

class _FakeHeadlessPlatform extends PlatformHeadlessInAppWebView {
  final List<String> events;

  _FakeHeadlessPlatform(this.events)
    : super.implementation(
        PlatformHeadlessInAppWebViewCreationParams(
          controllerFromPlatform: (_) => throw UnimplementedError(),
        ),
      );

  @override
  String get id => 'headless-cap-test';

  @override
  Future<void> run() async {
    events.add('run');
  }

  @override
  bool isRunning() => true;

  @override
  Future<void> dispose({bool isKeepAlive = false}) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  group('HeadlessInAppWebView live cap (issue 474)', () {
    test('defaults match the native platform ceilings', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(HeadlessInAppWebView.maxLiveWebViews, 3);

      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(HeadlessInAppWebView.maxLiveWebViews, 3);

      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      expect(HeadlessInAppWebView.maxLiveWebViews, 5);

      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      expect(HeadlessInAppWebView.maxLiveWebViews, 8);

      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      expect(HeadlessInAppWebView.maxLiveWebViews, 8);
    });

    test('rejects caps below one', () {
      expect(
        () => HeadlessInAppWebView.maxLiveWebViews = 0,
        throwsArgumentError,
      );
      expect(
        () => HeadlessInAppWebView.maxLiveWebViews = -1,
        throwsArgumentError,
      );
    });

    test('propagates the cap and updates registry defaults', () async {
      final events = <String>[];
      InAppWebViewPlatform.instance = _FakeInAppWebViewPlatform(events);

      HeadlessInAppWebView.maxLiveWebViews = 6;
      await Future<void>.delayed(Duration.zero);

      expect(HeadlessInAppWebView.maxLiveWebViews, 6);
      expect(events, ['configure:6']);
      expect(
        HeadlessWebViewRegistryConfig.platformDefaults().maxLiveInstances,
        6,
      );
    });

    test(
      'run observes the cap before native creation and blocks live changes',
      () async {
        final events = <String>[];
        InAppWebViewPlatform.instance = _FakeInAppWebViewPlatform(events);
        HeadlessInAppWebView.maxLiveWebViews = 6;
        final headless = HeadlessInAppWebView.fromPlatform(
          platform: _FakeHeadlessPlatform(events),
        );

        await headless.run();

        expect(events, ['configure:6', 'run']);
        expect(
          () => HeadlessInAppWebView.maxLiveWebViews = 7,
          throwsStateError,
        );

        await headless.dispose();
        HeadlessInAppWebView.maxLiveWebViews = 7;
        expect(HeadlessInAppWebView.maxLiveWebViews, 7);
      },
    );
  });
}
