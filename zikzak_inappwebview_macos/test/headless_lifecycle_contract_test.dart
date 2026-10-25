// Issue #371 — the headless WebView lifecycle contract, macOS side.
//
// macOS already had a shared-channel `dispose`, but it only dropped the map
// entry; it never tore the instance down. The contract test below pins both
// halves: the Dart path uses the shared channel, and the Swift `dispose(id:)`
// forwards to the instance's own `dispose()`.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_macos/src/in_app_webview/headless_in_app_webview.dart';
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

Map<String, String> managerSwiftSource() {
  final root = Directory('macos/zikzak_inappwebview_macos/Sources');
  for (final entity in root.listSync(recursive: true)) {
    if (entity is File &&
        entity.path.endsWith('HeadlessInAppWebViewManager.swift')) {
      return {entity.path: entity.readAsStringSync()};
    }
  }
  return {};
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MacOSHeadlessInAppWebView disposal (issue #371 R1/R6)', () {
    late _SharedChannelProbe probe;

    setUp(() {
      probe = _SharedChannelProbe()..install();
    });

    tearDown(() {
      probe.uninstall();
    });

    MacOSHeadlessInAppWebView buildHeadless() => MacOSHeadlessInAppWebView(
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
          reason: 'R1: the shared manager channel must be the dispose path',
        );
        expect((disposeCalls.single.arguments as Map)['id'], headless.id);
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

  group('macOS native headless lifecycle (issue #371 source contract)', () {
    test('shared dispose tears the instance down instead of dropping it', () {
      final sources = managerSwiftSource();
      expect(sources, isNotEmpty, reason: 'manager source not found');
      final source = sources.values.single;

      final disposeBody = RegExp(
        r'public func dispose\(id: String\) \{(.*?)\n    \}',
        dotAll: true,
      ).firstMatch(source)?.group(1);
      expect(
        disposeBody,
        isNotNull,
        reason: 'the shared dispose(id:) entrypoint must exist',
      );
      expect(
        disposeBody,
        contains('dispose()'),
        reason:
            'R1: dropping the map entry leaves the native WebView alive; '
            'the instance must be disposed',
      );
    });

    test('the manager never force-unwraps channel arguments', () {
      final source = managerSwiftSource().values.single;
      expect(source, isNot(contains('id!')));
      expect(source, isNot(contains('params!')));
    });

    test('the manager caps live headless WebViews', () {
      final source = managerSwiftSource().values.single;
      expect(source, contains('maxLiveWebViews'), reason: 'R4');
      expect(source, contains('FlutterError'), reason: 'R4: fail loudly');
    });
  });
}
