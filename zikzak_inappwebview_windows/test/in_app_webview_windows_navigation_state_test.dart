import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_windows/src/in_app_webview_windows_controller.dart';

/// `webview_windows` publishes the current URL, the loading state and the
/// history depth only as EventChannel messages — there is no synchronous
/// getter. These tests therefore drive a real, initialized [WebviewController]
/// through that channel rather than poking at private state, so what is
/// asserted is the actual event-to-getter wiring.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pluginChannel = MethodChannel('io.jns.webview.win');
  const textureId = 7;
  const eventChannelName = 'io.jns.webview.win/$textureId/events';
  // An EventChannel sends its own `listen`/`cancel` over a MethodChannel of the
  // same name, which is the side the mock handler has to answer.
  const eventChannel = MethodChannel(eventChannelName);

  late InAppWebViewWindowsController controller;
  var controllerDisposed = false;

  /// Disposes the controller exactly once, then flushes the queue.
  ///
  /// `WebviewController.dispose()` is asynchronous and reaches the platform
  /// channel, so it has to complete while the mock handler is still installed —
  /// otherwise the teardown races it and reports a MissingPluginException after
  /// the test has already passed.
  Future<void> disposeController() async {
    if (controllerDisposed) return;
    controllerDisposed = true;
    controller.dispose();
    await pumpEventQueue();
  }

  /// Pushes one native event onto the EventChannel stream and lets the
  /// controller's listener run.
  Future<void> emit(Map<String, dynamic> event) async {
    final data = const StandardMethodCodec().encodeSuccessEnvelope(event);
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(eventChannelName, data, (_) {});
    await pumpEventQueue();
  }

  setUp(() async {
    controllerDisposed = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pluginChannel, (call) async {
          if (call.method == 'initialize') return {'textureId': textureId};
          return null;
        });
    // Answer the EventChannel's own `listen`/`cancel` calls.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(eventChannel, (call) async => null);

    final webview = WebviewController();
    await webview.initialize();
    controller = InAppWebViewWindowsController(
      PlatformInAppWebViewControllerCreationParams(id: 0),
      webview,
    );
  });

  tearDown(() async {
    await disposeController();
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(pluginChannel, null);
    messenger.setMockMethodCallHandler(eventChannel, null);
  });

  group('navigation state before any event', () {
    test('getUrl is null rather than a guessed value', () async {
      expect(await controller.getUrl(), isNull);
    });

    test('getProgress starts at 0, not at a placeholder 100', () async {
      expect(
        await controller.getProgress(),
        0,
        reason:
            'reporting 100 before anything has loaded tells the host the page '
            'is finished when it has not started',
      );
    });

    test('canGoBack/canGoForward are false instead of throwing', () async {
      expect(await controller.canGoBack(), isFalse);
      expect(await controller.canGoForward(), isFalse);
    });
  });

  group('getUrl', () {
    test('tracks the latest urlChanged value', () async {
      await emit({'type': 'urlChanged', 'value': 'https://example.com/a'});
      expect((await controller.getUrl())?.toString(), 'https://example.com/a');

      await emit({'type': 'urlChanged', 'value': 'https://example.com/b'});
      expect((await controller.getUrl())?.toString(), 'https://example.com/b');
    });

    test('shares one cache with currentUrl', () async {
      await emit({'type': 'urlChanged', 'value': 'https://example.com/c'});

      expect(
        controller.currentUrl,
        'https://example.com/c',
        reason:
            'the widget reads currentUrl for onLoadStart/onLoadStop; getUrl '
            'must not drift away from the value the callbacks were given',
      );
      expect((await controller.getUrl())?.toString(), controller.currentUrl);
    });
  });

  group('getProgress', () {
    test('mirrors the loading state (webview_windows has no percentage)', () async {
      await emit({
        'type': 'loadingStateChanged',
        'value': LoadingState.loading.index,
      });
      expect(await controller.getProgress(), 0);

      await emit({
        'type': 'loadingStateChanged',
        'value': LoadingState.navigationCompleted.index,
      });
      expect(await controller.getProgress(), 100);
    });

    test('keeps its last value on LoadingState.none', () async {
      await emit({
        'type': 'loadingStateChanged',
        'value': LoadingState.navigationCompleted.index,
      });
      await emit({
        'type': 'loadingStateChanged',
        'value': LoadingState.none.index,
      });

      expect(
        await controller.getProgress(),
        100,
        reason:
            'none means "no change", matching dispatchLoadingStateChange, which '
            'emits no callbacks for it',
      );
    });
  });

  group('canGoBack / canGoForward', () {
    test('mirror historyChanged', () async {
      await emit({
        'type': 'historyChanged',
        'value': {'canGoBack': true, 'canGoForward': false},
      });
      expect(await controller.canGoBack(), isTrue);
      expect(await controller.canGoForward(), isFalse);

      await emit({
        'type': 'historyChanged',
        'value': {'canGoBack': false, 'canGoForward': true},
      });
      expect(await controller.canGoBack(), isFalse);
      expect(await controller.canGoForward(), isTrue);
    });
  });

  group('dispose', () {
    test('stops tracking without throwing', () async {
      await emit({'type': 'urlChanged', 'value': 'https://example.com/d'});

      await disposeController();

      // A disposed controller must not re-arm on later events, and cancelling
      // the single-subscription url stream twice must be harmless.
      await emit({'type': 'urlChanged', 'value': 'https://example.com/e'});
      expect(controller.currentUrl, 'https://example.com/d');
    });
  });
}
