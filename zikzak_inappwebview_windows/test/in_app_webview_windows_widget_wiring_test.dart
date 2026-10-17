import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_windows/webview_windows.dart' show LoadingState, Webview;
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_windows/src/in_app_webview_windows_platform.dart';

/// Drives the real `InAppWebViewWindowsWidget` over mocked `webview_windows`
/// channels.
///
/// The URLs handed to `onLoadStart`/`onLoadStop` are read from the controller's
/// cache ([InAppWebViewWindowsController.currentUrl]) instead of a second
/// subscription to the single-subscription `url` stream, so these tests pin
/// that wiring — and the teardown that cancels it — end to end, rather than
/// asserting on `currentUrl` and `dispatchLoadingStateChange` separately.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pluginChannel = MethodChannel('io.jns.webview.win');
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  const textureId = 7;
  const eventChannelName = 'io.jns.webview.win/$textureId/events';
  const eventChannel = MethodChannel(eventChannelName);
  // The `Webview` widget reports its size back over a per-texture channel.
  const textureChannel = MethodChannel('io.jns.webview.win/$textureId');

  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late Directory tempDir;
  late List<Map<String, Object?>> calls;
  late PlatformInAppWebViewController platformController;

  /// Advances the real event loop and renders, repeatedly.
  ///
  /// `testWidgets` runs its body in a fake-async zone, while `initPlatformState`
  /// does real file I/O (it probes the WebView2 user-data folder) and real
  /// channel round trips; those only make progress inside `runAsync`, and each
  /// hop has to be rendered by a `pump`.
  Future<void> turnEventLoop(WidgetTester tester, {int turns = 20}) async {
    for (var i = 0; i < turns; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump();
    }
  }

  Future<void> pumpUntilInitialized(WidgetTester tester) async {
    for (var i = 0; i < 100; i++) {
      if (find.byType(Webview).evaluate().isNotEmpty) return;
      await turnEventLoop(tester, turns: 1);
    }
    fail('the Windows webview never finished initializing');
  }

  /// Pushes one native event onto the EventChannel stream and lets the
  /// widget's listeners run.
  Future<void> emit(WidgetTester tester, Map<String, dynamic> event) async {
    final data = const StandardMethodCodec().encodeSuccessEnvelope(event);
    await tester.runAsync(() async {
      await messenger.handlePlatformMessage(eventChannelName, data, (_) {});
    });
    await turnEventLoop(tester, turns: 3);
  }

  Future<void> pumpWebView(WidgetTester tester) async {
    final platformWidget = InAppWebViewWindowsWidget(
      PlatformInAppWebViewWidgetCreationParams(
        windowId: 0,
        onWebViewCreated: (controller) => platformController = controller,
        onLoadStart: (controller, url) =>
            calls.add({'name': 'onLoadStart', 'url': url?.toString()}),
        onLoadStop: (controller, url) =>
            calls.add({'name': 'onLoadStop', 'url': url?.toString()}),
        onProgressChanged: (controller, progress) =>
            calls.add({'name': 'onProgressChanged', 'progress': progress}),
      ),
    );

    await tester.pumpWidget(
      Builder(builder: (context) => platformWidget.build(context)),
    );
    await pumpUntilInitialized(tester);
  }

  /// Unmounts while the channel handlers are still installed, so the teardown
  /// this test is about can actually reach the platform channel.
  Future<void> unmountWebView(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await turnEventLoop(tester);
  }

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('zikzak-win-widget');
    calls = [];
    messenger.setMockMethodCallHandler(pluginChannel, (call) async {
      if (call.method == 'initialize') return {'textureId': textureId};
      return null;
    });
    messenger.setMockMethodCallHandler(eventChannel, (call) async => null);
    messenger.setMockMethodCallHandler(textureChannel, (call) async => null);
    messenger.setMockMethodCallHandler(
      pathProviderChannel,
      (call) async => tempDir.path,
    );
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(pluginChannel, null);
    messenger.setMockMethodCallHandler(eventChannel, null);
    messenger.setMockMethodCallHandler(textureChannel, null);
    messenger.setMockMethodCallHandler(pathProviderChannel, null);
    tempDir.deleteSync(recursive: true);
  });

  testWidgets('onLoadStart is given the url the controller cached', (
    tester,
  ) async {
    await pumpWebView(tester);

    await emit(tester, {
      'type': 'urlChanged',
      'value': 'https://example.com/wired',
    });
    await emit(tester, {
      'type': 'loadingStateChanged',
      'value': LoadingState.loading.index,
    });

    final loadStarts = calls.where((c) => c['name'] == 'onLoadStart').toList();
    expect(loadStarts, hasLength(1));
    expect(
      loadStarts.single['url'],
      'https://example.com/wired',
      reason:
          'the widget reads currentUrl; a wrong receiver here passes null to '
          'onLoadStart/onLoadStop and fails silently',
    );
    expect(
      loadStarts.single['url'],
      (await platformController.getUrl())?.toString(),
      reason: 'onLoadStart and getUrl must not drift apart',
    );

    await unmountWebView(tester);
  });

  testWidgets('unmounting the widget disposes the platform controller', (
    tester,
  ) async {
    await pumpWebView(tester);

    platformController.addJavaScriptHandler(
      handlerName: 'probe',
      callback: (args) => null,
    );
    expect(platformController.hasJavaScriptHandler(handlerName: 'probe'), isTrue);

    await unmountWebView(tester);

    expect(
      platformController.hasJavaScriptHandler(handlerName: 'probe'),
      isFalse,
      reason:
          'the platform controller owns the url/loadingState/historyChanged '
          'subscriptions, and the raw WebviewController never closes those '
          'stream controllers — without forwarding teardown to it, the '
          'listeners outlive the unmounted widget',
    );
  });
}
