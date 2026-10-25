// Issue #371 — the headless WebView lifecycle contract, iOS side.
//
// Two halves, both executable without a device:
//
//  * the Dart half drives the real [IOSHeadlessInAppWebView] against a mocked
//    method channel and asserts that disposal now goes through the SHARED
//    manager channel (the only channel the native manager routes on), and that
//    a failing native dispose is recorded instead of swallowed;
//  * the Swift half is a source contract over the native manager, because the
//    behavior it pins (shared-channel `dispose`, no force-unwraps, an
//    off-screen container, a live-instance cap) only shows up at runtime on a
//    device the pool does not have.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_ios/src/in_app_webview/headless_in_app_webview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

const _sharedChannelName = 'wtf.zikzak/flutter_headless_inappwebview';

/// Records the method calls that reach the shared headless manager channel.
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

/// The package's Swift sources, as `relative path → file contents`.
Map<String, String> swiftSources() {
  final root = Directory('ios/zikzak_inappwebview_ios/Sources');
  final out = <String, String>{};
  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.swift')) continue;
    out[entity.path] = entity.readAsStringSync();
  }
  return out;
}

Map<String, String> managerSources() {
  final sources = swiftSources();
  return {
    for (final entry in sources.entries)
      if (entry.key.contains('/HeadlessInAppWebView/')) entry.key: entry.value,
  };
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IOSHeadlessInAppWebView disposal (issue #371 R1/R6)', () {
    late _SharedChannelProbe probe;

    setUp(() {
      probe = _SharedChannelProbe()..install();
    });

    tearDown(() {
      probe.uninstall();
    });

    IOSHeadlessInAppWebView buildHeadless() => IOSHeadlessInAppWebView(
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
      probe.uninstall();
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
      probe.install();
    });

    test('lastDisposeError is null after a successful dispose', () async {
      final headless = buildHeadless();
      await headless.run();

      await headless.dispose();

      expect(headless.lastDisposeError, isNull);
    });
  });

  group('iOS native headless lifecycle (issue #371 source contract)', () {
    test('the manager routes dispose and reads the id defensively', () {
      final managers = managerSources();
      expect(managers, isNotEmpty, reason: 'no HeadlessInAppWebView sources');

      final managerPath = managers.keys.firstWhere(
        (p) => p.endsWith('HeadlessInAppWebViewManager.swift'),
      );
      final manager = managers[managerPath]!;

      expect(
        manager,
        contains('case "dispose"'),
        reason: 'R1: the shared manager channel must accept dispose',
      );
      expect(
        manager,
        isNot(contains('as! String')),
        reason: 'R2: a shared-channel call without an id must not trap',
      );
      expect(
        manager,
        isNot(contains('arguments!')),
        reason: 'R2: channel arguments must not be force-unwrapped',
      );
      expect(
        manager,
        contains('maxLiveWebViews'),
        reason: 'R4: the manager must cap live headless WebViews',
      );
      expect(
        manager,
        contains('FlutterError'),
        reason: 'R4: exceeding the cap must fail loudly, not silently grow',
      );
    });

    test('headless views are hosted in a dedicated off-screen container', () {
      final sources = swiftSources();
      final headlessPath = sources.keys.firstWhere(
        (p) => p.endsWith('HeadlessInAppWebView/HeadlessInAppWebView.swift'),
      );
      final headless = sources[headlessPath]!;

      expect(
        headless,
        isNot(contains('insertSubview(view, at: 0)')),
        reason: 'R3: a headless view must never be parked in the key window',
      );
      expect(
        headless,
        contains('HeadlessWebViewContainer'),
        reason: 'R3: the view is hosted by the dedicated container',
      );
      expect(
        sources.keys.any((p) => p.endsWith('HeadlessWebViewContainer.swift')),
        isTrue,
        reason: 'R3: the container must exist as its own source file',
      );
    });
  });
}
