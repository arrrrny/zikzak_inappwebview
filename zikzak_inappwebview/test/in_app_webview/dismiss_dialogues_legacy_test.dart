import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'package:zikzak_inappwebview/src/in_app_webview/dismiss_dialogues_legacy.dart';

/// Minimal [PlatformInAppWebViewController] fake that records injected scripts
/// and optionally throws, so the legacy dismissal driver can be exercised
/// without a real WebView.
class _FakePlatformController extends Fake
    implements PlatformInAppWebViewController {
  /// Sources passed to [evaluateJavascript].
  final List<String> evaluatedSources = <String>[];

  /// When true, [evaluateJavascript] throws instead of succeeding.
  bool throwOnEvaluate = false;

  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) async {
    evaluatedSources.add(source);
    if (throwOnEvaluate) throw StateError('injected script failed');
    return null;
  }
}

InAppWebViewController _controller(_FakePlatformController platform) =>
    InAppWebViewController.fromPlatform(platform: platform);

void main() {
  group('legacyDismissDialogues (U3-U8 characterization)', () {
    // U3 / FR-003, FR-004 — removes every fixed/sticky element.
    test('legacyDismissDialoguesJs removes elements whose position is fixed or sticky', () {
      final js = legacyDismissDialoguesJs();
      expect(js, contains("document.querySelectorAll('*')"),
          reason: 'must scan every element');
      expect(js, contains('window.getComputedStyle(el)'),
          reason: 'must read computed position');
      expect(js, contains("style.position === 'fixed'"));
      expect(js, contains("style.position === 'sticky'"));
      expect(js, contains('el.remove()'),
          reason: 'matching elements must be removed');
    });

    // U4 / FR-005 — resets overflow/margin on documentElement and body.
    test('legacyDismissDialoguesJs resets overflow and margin to empty on documentElement and body', () {
      final js = legacyDismissDialoguesJs();
      expect(js, contains("document.documentElement.style.overflow = '';"));
      expect(js, contains("document.documentElement.style.margin = '';"));
      expect(js, contains("document.body.style.overflow = '';"));
      expect(js, contains("document.body.style.margin = '';"));
    });

    // U5 / FR-006, US3-S1 — retries 3x with an 800ms gap.
    test('runLegacyDismissDialogues injects the script exactly 3 times with the 800ms retry delay', () async {
      final platform = _FakePlatformController();
      await runLegacyDismissDialogues(
        _controller(platform),
        retryDelay: Duration.zero,
      );
      expect(platform.evaluatedSources.length, 3,
          reason: 'the legacy loop attempts three times');
      expect(legacyDismissRetryDelay, const Duration(milliseconds: 800),
          reason: 'default gap between attempts is 800ms');
    });

    // U6 / FR-007, US2-S1 — no injection unless dismissDialogues is true.
    test('shouldDismissDialogues is false unless dismissDialogues is explicitly true', () {
      expect(shouldDismissDialogues(null), isFalse);
      expect(shouldDismissDialogues(InAppWebViewSettings()), isFalse);
      expect(
        shouldDismissDialogues(InAppWebViewSettings(dismissDialogues: false)),
        isFalse,
      );
      expect(
        shouldDismissDialogues(InAppWebViewSettings(dismissDialogues: true)),
        isTrue,
      );
    });

    // U7 / FR-008 — JS errors are swallowed; the web view is not broken.
    test('removal errors are swallowed (inner catch + driver try/catch) and never propagate', () async {
      // The emitted script tolerates per-element DOM errors.
      expect(legacyDismissDialoguesJs(), contains('catch(e)'),
          reason: 'the IIFE swallows per-element errors');

      // The Dart driver swallows platform-side errors entirely.
      final platform = _FakePlatformController()..throwOnEvaluate = true;
      await runLegacyDismissDialogues(
        _controller(platform),
        retryDelay: Duration.zero,
      );
      expect(platform.evaluatedSources, isNotEmpty,
          reason: 'injection was attempted before the error was swallowed');
    });

    // U8 / FR-009 — only the top-level document is touched; frames are not.
    test('legacyDismissDialoguesJs traverses only the top-level document (no iframe/frames)', () {
      final js = legacyDismissDialoguesJs();
      expect(js, contains('document.querySelectorAll'),
          reason: 'targets the top-level document');
      expect(js, isNot(contains('iframe')),
          reason: 'must not reach into iframes');
      expect(js, isNot(contains('contentDocument')));
      expect(js, isNot(contains('window.frames')));
      expect(js, isNot(contains('.frames')));
    });
  });
}
