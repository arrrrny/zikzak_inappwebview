// Issue #371 — the headless WebView lifecycle contract, Android side.
//
// Mirrors the iOS contract test: the Dart half drives the real
// [AndroidHeadlessInAppWebView] against a mocked shared channel, the Java half
// is a source contract over the native manager and the headless view.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_android/src/in_app_webview/headless_in_app_webview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

const _sharedChannelName = 'wtf.zikzak/flutter_headless_inappwebview';

class _SharedChannelProbe {
  final calls = <MethodCall>[];

  void install() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel(_sharedChannelName), (
          call,
        ) async {
          calls.add(call);
          return true;
        });
  }

  void uninstall() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel(_sharedChannelName),
          null,
        );
  }
}

Map<String, String> javaSources() {
  final root = Directory(
    'android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/'
    'headless_in_app_webview',
  );
  final out = <String, String>{};
  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.java')) continue;
    out[entity.path] = entity.readAsStringSync();
  }
  return out;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AndroidHeadlessInAppWebView disposal (issue #371 R1/R6)', () {
    late _SharedChannelProbe probe;

    setUp(() {
      probe = _SharedChannelProbe()..install();
    });

    tearDown(() {
      probe.uninstall();
    });

    AndroidHeadlessInAppWebView buildHeadless() => AndroidHeadlessInAppWebView(
      PlatformHeadlessInAppWebViewCreationParams(
        initialUrlRequest: URLRequest(url: WebUri('https://example.com')),
      ),
    );

    test(
      'dispose is sent on the shared manager channel with the instance id',
      () async {
        final headless = buildHeadless();
        await headless.run();
        probe.calls.clear();

        await headless.dispose();

        final disposeCalls = probe.calls.where((c) => c.method == 'dispose');
        expect(
          disposeCalls,
          hasLength(1),
          reason:
              'R1: the shared manager channel must be the dispose path '
              '(the per-instance channel is not routed by the native manager)',
        );
        expect(
          (disposeCalls.single.arguments as Map)['id'],
          headless.id,
          reason: 'the shared channel routes on the id argument',
        );
      },
    );

    test('a failing native dispose is recorded, not swallowed', () async {
      final headless = buildHeadless();
      await headless.run();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel(_sharedChannelName), (
            call,
          ) async {
            if (call.method == 'dispose') {
              throw PlatformException(code: 'dispose_failed');
            }
            return true;
          });

      await headless.dispose();

      expect(
        headless.lastDisposeError,
        isA<PlatformException>(),
        reason: 'R6: a failed native dispose must be inspectable by the caller',
      );
    });
  });

  group('Android native headless lifecycle (issue #371 source contract)', () {
    test(
      'the manager routes dispose, reads the id defensively and caps live views',
      () {
        final sources = javaSources();
        final managerPath = sources.keys.firstWhere(
          (p) => p.endsWith('HeadlessInAppWebViewManager.java'),
        );
        final manager = sources[managerPath]!;

        expect(manager, contains('case "dispose"'), reason: 'R1');
        expect(
          manager,
          isNot(contains('(String) call.argument("id")')),
          reason: 'R2: the id must be read without an unchecked cast throwing',
        );
        expect(manager, contains('call.argument("id")'), reason: 'R2');
        expect(manager, contains('maxLiveWebViews'), reason: 'R4');
        expect(manager, contains('result.error('), reason: 'R4: fail loudly');
      },
    );

    test('the headless view lives in a dedicated off-screen container', () {
      final sources = javaSources();
      final viewPath = sources.keys.firstWhere(
        (p) => p.endsWith('HeadlessInAppWebView.java'),
      );
      final view = sources[viewPath]!;

      expect(
        view,
        isNot(contains('mainView.addView(view, 0)')),
        reason: 'R3: never a child of the activity content view',
      );
      expect(
        view,
        contains('HeadlessWebViewContainer'),
        reason: 'R3: the dedicated container hosts the view',
      );
      expect(
        sources.keys.any((p) => p.endsWith('HeadlessWebViewContainer.java')),
        isTrue,
        reason: 'R3: the container must exist as its own source file',
      );
    });
  });
}
