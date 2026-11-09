// Lifecycle tests for LinuxHeadlessInAppWebView: run() must reach the shared
// 'wtf.zikzak/flutter_headless_inappwebview' channel with a generated id
// instead of throwing UnimplementedError from the platform-interface's
// PlatformHeadlessInAppWebView.id getter (#405), and dispose() must tear the
// same id down. The native side (linux/headless_in_app_webview/) handles only
// `run` on the shared channel; `dispose` goes to the instance channel
// 'wtf.zikzak/flutter_headless_inappwebview_<id>' the native headless WebView
// registers for that id.
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_linux/src/in_app_webview/headless_in_app_webview.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const sharedChannel = MethodChannel(
    'wtf.zikzak/flutter_headless_inappwebview',
  );
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late List<MethodCall> sharedCalls;
  // Calls on every per-instance channel, keyed by channel name.
  late Map<String, List<MethodCall>> instanceCalls;
  late List<MethodChannel> instanceChannels;

  MethodChannel instanceChannel(String id) =>
      MethodChannel('wtf.zikzak/flutter_headless_inappwebview_$id');

  void mockInstance(LinuxHeadlessInAppWebView headless) {
    final channel = instanceChannel(headless.id);
    instanceChannels.add(channel);
    messenger.setMockMethodCallHandler(channel, (call) async {
      instanceCalls.putIfAbsent(channel.name, () => []).add(call);
      return null;
    });
  }

  setUp(() {
    sharedCalls = [];
    instanceCalls = {};
    instanceChannels = [];
    messenger.setMockMethodCallHandler(sharedChannel, (call) async {
      sharedCalls.add(call);
      return null;
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(sharedChannel, null);
    for (final channel in instanceChannels) {
      messenger.setMockMethodCallHandler(channel, null);
    }
  });

  LinuxHeadlessInAppWebView build() {
    final headless = LinuxHeadlessInAppWebView(
      LinuxHeadlessInAppWebViewCreationParams(),
    );
    mockInstance(headless);
    return headless;
  }

  group('headless lifecycle', () {
    test('run() reaches the shared channel with a generated id', () async {
      final headless = build();
      await headless.run();

      expect(headless.id, isNotEmpty);
      expect(headless.isRunning(), isTrue);
      expect(sharedCalls.single.method, 'run');
      final args = sharedCalls.single.arguments as Map;
      expect(args['id'], headless.id);
      expect(args['params'], isMap);
      // The native side reads these fields off params: pin the bare-params
      // serialization so a regression that empties or renames them fails.
      expect(args['params']['initialUserScripts'], isEmpty);
      expect(args['params']['contextMenu'], isEmpty);
      expect(args['params']['initialSize'], {'width': -1.0, 'height': -1.0});

      await headless.dispose();
    });

    test('dispose() tears the same id down', () async {
      final headless = build();
      await headless.run();
      await headless.dispose();

      expect(headless.isRunning(), isFalse);
      expect(sharedCalls.map((c) => c.method).toList(), ['run']);
      expect(
        instanceCalls[instanceChannel(headless.id).name]!
            .map((c) => c.method)
            .toList(),
        ['dispose'],
      );
    });

    test('run() enables the Ajax event keys for the set callbacks', () async {
      final headless = LinuxHeadlessInAppWebView(
        LinuxHeadlessInAppWebViewCreationParams(
          onAjaxReadyStateChange: (c, request) async => null,
        ),
      );
      mockInstance(headless);
      await headless.run();
      final settings =
          (sharedCalls.single.arguments as Map)['params']['initialSettings'] as Map;
      // linux/in_app_webview/in_app_webview.cc only wraps readystatechange when
      // useOnAjaxReadyStateChange is true (and interception is enabled).
      expect(settings['useOnAjaxReadyStateChange'], true);
      expect(settings['useShouldInterceptAjaxRequest'], true);
      expect(settings.containsKey('useOnAjaxProgress'), isFalse);
      await headless.dispose();
    });

    test('a failed run() releases what it set up and can be retried', () async {
      var created = 0;
      final headless = LinuxHeadlessInAppWebView(
        LinuxHeadlessInAppWebViewCreationParams(
          onWebViewCreated: (_) => created++,
        ),
      );
      mockInstance(headless);
      var fail = true;
      messenger.setMockMethodCallHandler(sharedChannel, (call) async {
        sharedCalls.add(call);
        if (fail) throw PlatformException(code: 'boom');
        return null;
      });
      Future<void> nativeCreated() => messenger.handlePlatformMessage(
            instanceChannel(headless.id).name,
            const StandardMethodCodec()
                .encodeMethodCall(const MethodCall('onWebViewCreated')),
            (_) {},
          );

      await expectLater(headless.run(), throwsA(isA<PlatformException>()));
      expect(headless.isRunning(), isFalse);
      expect(headless.webViewController, isNull);
      await nativeCreated(); // the instance channel handler is gone
      expect(created, 0);

      fail = false;
      await headless.run();
      expect(headless.isRunning(), isTrue);
      expect(headless.webViewController, isNotNull);
      await nativeCreated();
      expect(created, 1);
      await headless.dispose();
    });

    test('distinct instances get distinct ids', () async {
      expect(build().id, isNot(equals(build().id)));
    });

    test(
      'dispose() while run() is in flight still tears the same id down',
      () async {
        final headless = build();
        // Park the mocked native startup so run() stays in flight while
        // dispose() is called: dispose() must wait on _runCompleter, and
        // run() must perform the deferred teardown itself.
        final runGate = Completer<void>();
        messenger.setMockMethodCallHandler(sharedChannel, (call) async {
          sharedCalls.add(call);
          if (call.method == 'run') {
            await runGate.future;
          }
          return null;
        });

        final runF = headless.run(); // parks inside the mocked invokeMethod
        final disposeF = headless.dispose(); // waits on _runCompleter
        expect(headless.isRunning(), isFalse, reason: 'run() is still parked');
        runGate.complete();
        await disposeF; // unblocks once run() finishes the deferred teardown
        await runF;

        expect(sharedCalls.map((c) => c.method).toList(), ['run']);
        expect(
          instanceCalls[instanceChannel(headless.id).name]!
              .map((c) => c.method)
              .toList(),
          ['dispose'],
        );
        expect(headless.isRunning(), isFalse);
      },
    );

    test('run() after dispose() is a channel-silent no-op', () async {
      final headless = build();
      await headless.run();
      await headless.dispose();
      sharedCalls.clear();
      instanceCalls.clear();

      await headless.run(); // _disposed: returns before any channel call

      expect(sharedCalls, isEmpty);
      expect(instanceCalls, isEmpty);
      expect(headless.isRunning(), isFalse);
    });
  });
}
