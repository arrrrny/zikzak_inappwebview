// Issue #395 source contract: the fullscreen-window detection must not ship
// private UIKit class names. `isVideoPlayerWindow` resolved
// `_UIAlertControllerShimPresenterWindow`, `UITextEffectsWindow`,
// `UIRemoteKeyboardWindow` and `PGHostedWindow` through `NSClassFromString`,
// and apps embedding them were rejected under App Review Guideline 2.5.1
// (non-public APIs, class `PGHostedWindow`) — see
// pichillilorenzo/flutter_inappwebview#2754. Upstream v6.2.0-beta.3 replaced
// the list with a public-API-only heuristic (`isFullscreenMediaWindow`): a
// window counts as fullscreen media only when it shares the web view's
// `windowScene`, covers at least 90% of the screen's width and height, has
// `windowLevel >= .normal` — which also rejects the headless host window at
// level `normal - 1` — and its class name does not look like a keyboard,
// text-effects, alert, status-bar or accessibility window.
//
// `WKWebView.fullscreenState` is observed via KVO on iOS 16+ as the primary
// enter/exit path, the UIWindow visibility notifications stay as the
// fallback, the window that entered fullscreen is tracked so the exit event
// fires for it, and enter/exit are guarded with `inFullscreen` so the KVO and
// notification paths cannot double-fire.
//
// This test encodes those rules as a source scan; it is executable on any
// host (no Xcode required), mirroring the swift_uiscene_window_api_test.dart
// style.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

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

/// Strips line/block comments and string literals so only real code tokens
/// are scanned. Block comments nest, matching Swift's grammar.
String stripSwiftNonCode(String source) {
  final out = StringBuffer();
  var i = 0;
  var blockDepth = 0;
  while (i < source.length) {
    if (blockDepth > 0) {
      if (source.startsWith('/*', i)) {
        blockDepth++;
        i += 2;
      } else if (source.startsWith('*/', i)) {
        blockDepth--;
        i += 2;
      } else {
        if (source[i] == '\n') out.write('\n');
        i++;
      }
      continue;
    }
    if (source.startsWith('/*', i)) {
      blockDepth++;
      i += 2;
    } else if (source.startsWith('//', i)) {
      while (i < source.length && source[i] != '\n') {
        i++;
      }
    } else if (source[i] == '"') {
      // Skip a string literal; `\\` escapes the next character.
      i++;
      while (i < source.length && source[i] != '"') {
        i += source[i] == '\\' ? 2 : 1;
      }
      i++;
    } else {
      out.write(source[i]);
      i++;
    }
  }
  return out.toString();
}

void main() {
  final sources = swiftSources();
  final viewEntry = sources.entries
      .singleWhere((e) => e.key.endsWith('InAppWebView/InAppWebView.swift'));
  final view = viewEntry.value;

  group('issue #395 R1 — no private window class names in the binary', () {
    for (final privateClass in [
      '_UIAlertControllerShimPresenterWindow',
      'UITextEffectsWindow',
      'UIRemoteKeyboardWindow',
      'PGHostedWindow',
    ]) {
      test('$privateClass appears in no Swift source', () {
        for (final entry in sources.entries) {
          expect(stripSwiftNonCode(entry.value), isNot(contains(privateClass)),
              reason:
                  '${entry.key} references the non-public class $privateClass; '
                  'resolving it (directly or via NSClassFromString) triggers '
                  'App Review 2.5.1 rejections (flutter_inappwebview#2754)');
        }
      });
    }

    test('NSClassFromString is no longer used for window detection', () {
      expect(stripSwiftNonCode(view), isNot(contains('NSClassFromString')),
          reason: 'isVideoPlayerWindow resolved private classes through '
              'NSClassFromString; the replacement heuristic reads public '
              'window properties only');
    });
  });

  group('issue #395 R2 — public-API fullscreen heuristic', () {
    test('isFullscreenMediaWindow replaces isVideoPlayerWindow', () {
      expect(stripSwiftNonCode(view), contains('isFullscreenMediaWindow'),
          reason: 'the upstream v6.2.0-beta.3 public-API heuristic');
      expect(stripSwiftNonCode(view), isNot(contains('isVideoPlayerWindow')),
          reason: 'the private-API-based detector must be gone');
    });

    test(
        'the heuristic checks the window scene, screen coverage, window level '
        'and system-window class names', () {
      final code = stripSwiftNonCode(view);
      expect(code, contains('windowScene'),
          reason: 'the window must share the web view\'s windowScene');
      expect(code, contains('0.9'),
          reason: 'at least 90% of the screen\'s width and height');
      expect(code, contains('windowLevel >= .normal'),
          reason: 'fullscreen media windows sit at or above .normal; this '
              'also rejects the headless host window at level normal - 1');
      // The exclusion list lives inside string literals, which the code
      // scanner strips — assert it against the raw source instead.
      for (final systemWindow in [
        'Keyboard',
        'TextEffects',
        'Alert',
        'StatusBar',
        'Accessibility',
      ]) {
        expect(view, contains('contains("$systemWindow")'),
            reason: '$systemWindow windows must be excluded by class-name '
                'inspection, not by private class resolution');
      }
    });
  });

  group('issue #395 R3 — fullscreenState KVO on iOS 16+', () {
    test('fullscreenState is observed, handled and unregistered', () {
      final code = stripSwiftNonCode(view);
      expect(
          code,
          contains(
              'addObserver(self,\n                forKeyPath: #keyPath(WKWebView.fullscreenState)'),
          reason: 'the KVO observer is the primary enter/exit path on iOS 16+');
      expect(code, contains('removeObserver(self, forKeyPath: #keyPath(WKWebView.fullscreenState))'),
          reason: 'dispose() must unregister the observer');
      expect(code, contains('.enteringFullscreen'));
      expect(code, contains('.exitingFullscreen'));
    });

    test('the window that entered fullscreen is tracked for the exit event',
        () {
      final code = stripSwiftNonCode(view);
      expect(code, contains('var fullscreenWindow: UIWindow?'));
      expect(code, contains('fullscreenWindow = notification.object as? UIWindow'),
          reason: 'onEnterFullscreen tracks the window so onExitFullscreen '
              'recognises it even when the heuristic would not re-qualify it');
      expect(code, contains('fullscreenWindow = nil'),
          reason: 'the tracked window is released on exit');
      expect(code, contains('fullscreenWindow === hiddenWindow'),
          reason: 'the exit event fires for the tracked window');
    });

    test('enter and exit are guarded with inFullscreen to avoid double-firing',
        () {
      final code = stripSwiftNonCode(view);
      expect(code, contains('guard !inFullscreen else { return }'));
      expect(code, contains('guard inFullscreen else { return }'));
    });
  });

  group('issue #395 R4 — UIWindow visibility notifications stay registered',
      () {
    test('didBecomeVisible/didBecomeHidden drive the fullscreen handlers', () {
      final code = stripSwiftNonCode(view);
      expect(code, contains('UIWindow.didBecomeVisibleNotification'));
      expect(code, contains('UIWindow.didBecomeHiddenNotification'));
      expect(code, contains('func onEnterFullscreen(_ notification: Notification)'));
      expect(code, contains('func onExitFullscreen(_ notification: Notification)'));
    });
  });
}
