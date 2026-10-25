// Issue #371 R5 — the render-finished primitives.
//
// `onLoadStop` fires on `didFinish`, before the page's own scripts have
// populated the DOM, so consumers hand-rolled polling. [WebViewRenderWait]
// turns that into a bounded, cancellable awaitable: a selector wait and a DOM
// settled wait, both driven over `evaluateJavascript`.
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// A controller whose JavaScript evaluation is scripted by the test.
class _ScriptedController extends PlatformInAppWebViewController {
  _ScriptedController(this._onEvaluate)
    : super.implementation(
        const PlatformInAppWebViewControllerCreationParams(id: 0),
      );

  final Future<dynamic> Function(String source) _onEvaluate;
  final List<String> sources = [];

  int get probes => sources.length;

  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) {
    sources.add(source);
    return _onEvaluate(source);
  }
}

InAppWebViewController _controllerWith(
  Future<dynamic> Function(String source) onEvaluate,
) => InAppWebViewController.fromPlatform(
  platform: _ScriptedController(onEvaluate),
);

_ScriptedController _platformOf(InAppWebViewController controller) =>
    controller.platform as _ScriptedController;

void main() {
  group('waitForSelector (issue #371 R5)', () {
    test('resolves satisfied once the selector exists', () async {
      var calls = 0;
      final controller = _controllerWith((_) async {
        calls++;
        return calls >= 3;
      });

      final wait = controller.waitForSelector(
        '#results',
        timeout: const Duration(seconds: 5),
        pollInterval: const Duration(milliseconds: 10),
      );
      final result = await wait.result;

      expect(result.status, WebViewRenderStatus.satisfied);
      expect(result.isSatisfied, isTrue);
      expect(_platformOf(controller).probes, 3);
    });

    test('is bounded: a selector that never appears times out', () async {
      final controller = _controllerWith((_) async => false);

      final stopwatch = Stopwatch()..start();
      final result = await controller
          .waitForSelector(
            '#never',
            timeout: const Duration(milliseconds: 150),
            pollInterval: const Duration(milliseconds: 20),
          )
          .result;
      stopwatch.stop();

      expect(result.status, WebViewRenderStatus.timedOut);
      expect(result.isSatisfied, isFalse);
      expect(
        stopwatch.elapsed,
        lessThan(const Duration(seconds: 3)),
        reason: 'the wait must not outlive its timeout',
      );
    });

    test(
      'is cancellable: cancel() stops the polling and reports cancelled',
      () async {
        final controller = _controllerWith((_) async => false);

        final wait = controller.waitForSelector(
          '#never',
          timeout: const Duration(seconds: 30),
          pollInterval: const Duration(milliseconds: 10),
        );
        await Future<void>.delayed(const Duration(milliseconds: 45));
        final probesAtCancel = _platformOf(controller).probes;

        wait.cancel();
        final result = await wait.result;
        await Future<void>.delayed(const Duration(milliseconds: 60));

        expect(result.status, WebViewRenderStatus.cancelled);
        expect(wait.isCancelled, isTrue);
        expect(
          _platformOf(controller).probes,
          probesAtCancel,
          reason: 'no probe may run after cancel()',
        );
      },
    );

    test(
      'cancel during an in-flight probe settles once and keeps the count',
      () async {
        // The probe outlives cancel(): the bug was that its late resolution
        // completed an already-completed future, and the resulting
        // `Bad state: Future already completed` escaped the unawaited run() as
        // an unhandled async error (issue #371 review).
        final controller = _controllerWith((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 40));
          return true;
        });

        final wait = controller.waitForSelector(
          '#late',
          timeout: const Duration(seconds: 30),
          pollInterval: const Duration(milliseconds: 10),
        );
        await Future<void>.delayed(const Duration(milliseconds: 5));
        wait.cancel();
        final result = await wait.result;

        // Let the in-flight probe resolve after the cancellation.
        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(result.status, WebViewRenderStatus.cancelled);
        expect(
          result.probeCount,
          1,
          reason: 'the cancelled result reports the probes that ran',
        );
      },
    );

    test('surfaces a JavaScript failure instead of hanging', () async {
      final controller = _controllerWith(
        (_) async => throw PlatformException(code: 'no_webview'),
      );

      final result = await controller
          .waitForSelector(
            '#results',
            timeout: const Duration(seconds: 5),
            pollInterval: const Duration(milliseconds: 10),
          )
          .result;

      expect(result.status, WebViewRenderStatus.failed);
      expect(result.error, isA<PlatformException>());
    });

    test('rejects an empty selector loudly', () {
      final controller = _controllerWith((_) async => true);

      expect(() => controller.waitForSelector('  '), throwsArgumentError);
    });
  });

  group('waitForDomSettled (issue #371 R5)', () {
    test(
      'resolves satisfied after the DOM fingerprint stops changing',
      () async {
        final fingerprints = <String>[
          '100:10',
          '180:12',
          '220:14',
          '220:14',
          '220:14',
        ];
        var index = 0;
        final controller = _controllerWith((_) async {
          final fingerprint =
              fingerprints[index.clamp(0, fingerprints.length - 1)];
          index++;
          return fingerprint.split(':').map(int.parse).toList();
        });

        final result = await controller
            .waitForDomSettled(
              timeout: const Duration(seconds: 5),
              pollInterval: const Duration(milliseconds: 5),
              stableSamples: 3,
            )
            .result;

        expect(result.status, WebViewRenderStatus.satisfied);
        expect(result.stableSamples, greaterThanOrEqualTo(3));
        expect(result.fingerprint, '220:14');
      },
    );

    test('is bounded and cancellable like the selector wait', () async {
      final controller = _controllerWith((_) async => null);

      final wait = controller.waitForDomSettled(
        timeout: const Duration(milliseconds: 120),
        pollInterval: const Duration(milliseconds: 20),
      );
      final result = await wait.result;

      expect(result.status, WebViewRenderStatus.timedOut);

      final cancelled = controller.waitForDomSettled(
        timeout: const Duration(seconds: 30),
        pollInterval: const Duration(milliseconds: 10),
      );
      await Future<void>.delayed(const Duration(milliseconds: 30));
      cancelled.cancel();

      expect((await cancelled.result).status, WebViewRenderStatus.cancelled);
    });
  });
}
