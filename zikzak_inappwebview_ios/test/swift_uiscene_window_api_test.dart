// Issue #355 source contract: the plugin must not reach for the window through
// the UIApplication/AppDelegate legacy accessors — `UIApplicationDelegate.window`
// is `nil` once an app adopts the UIScene lifecycle (mandatory with the iOS 27
// SDK), and `UIApplication.shared.keyWindow` / `UIApplication.shared.windows`
// are deprecated in its favour. Every window lookup in the iOS sources has to
// go through the scene lifecycle (`UIApplication.shared.connectedScenes` →
// `UIWindowScene.keyWindow`), so the exact failure the issue reports — a
// makeKeyAndVisible / presentationAnchor call that silently no-ops — cannot
// come back through a new call site either.
//
// This test encodes that rule as a source scan; it is executable on any host
// (no Xcode required), mirroring the swift_availability_usage_test.dart style.
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

/// Strips line/block comments and string literals so only real code tokens are
/// scanned. Block comments nest, matching Swift's grammar.
///
/// Known limitation: Swift raw string literals (`#"…"#`, `####…"…"####`) and
/// quote characters inside `\(...)` interpolation are not tokenized, so quotes
/// inside such constructs can make the scanner mis-skip or mis-tokenize.
/// Improbable in this codebase; extend the scanner if such sources appear.
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
      out.write('  ');
      continue;
    }
    if (source.startsWith('//', i)) {
      final end = source.indexOf('\n', i);
      i = end == -1 ? source.length : end;
      continue;
    }
    if (source.startsWith('"', i)) {
      var j = i + 1;
      while (j < source.length && source[j] != '"' && source[j] != '\n') {
        if (source[j] == r'\') {
          j++;
        }
        j++;
      }
      i = j + 1 > source.length ? source.length : j + 1;
      out.write('""');
      continue;
    }
    out.write(source[i]);
    i++;
  }
  return out.toString();
}

/// `file:line` occurrences of the pre-UIScene window accessors that issue #355
/// migrates away from.
List<String> scanLegacyWindowAccess(Map<String, String> sources) {
  final patterns = {
    'UIApplicationDelegate.window': RegExp(r'delegate\??\.window\b'),
    'UIApplication.shared.keyWindow': RegExp(
      r'UIApplication\.shared\.keyWindow',
    ),
    'UIApplication.shared.windows': RegExp(r'UIApplication\.shared\.windows\b'),
  };
  final violations = <String>[];
  for (final entry in sources.entries) {
    final code = stripSwiftNonCode(entry.value);
    patterns.forEach((label, pattern) {
      for (final match in pattern.allMatches(code)) {
        final line = '\n'.allMatches(code.substring(0, match.start)).length + 1;
        violations.add('$label at ${entry.key}:$line');
      }
    });
  }
  return violations;
}

/// The call sites the issue names (plus the ones carrying the identical
/// pattern) — each must resolve its window through the shared scene-based
/// lookup instead of a deprecated accessor.
const _migratedCallSites = [
  'InAppBrowser/InAppBrowserNavigationController.swift',
  'InAppBrowser/InAppBrowserWebViewController.swift',
  'UIApplication/VisibleViewController.swift',
  'HeadlessInAppWebView/HeadlessInAppWebView.swift',
  'WebAuthenticationSession/WebAuthenticationSession.swift',
];

void main() {
  group('UIScene window API migration (issue #355)', () {
    test('no legacy window accessor remains in the iOS sources', () {
      final violations = scanLegacyWindowAccess(swiftSources());
      expect(violations, isEmpty, reason: violations.join('\n'));
    });

    test('window lookups go through the scene-based key window helper', () {
      final sources = swiftSources();
      final helper = sources.entries.where(
        (e) => e.key.endsWith('UIApplication/SceneKeyWindow.swift'),
      );
      expect(
        helper,
        isNotEmpty,
        reason:
            'the shared sceneKeyWindow helper must live under '
            'Sources/zikzak_inappwebview_ios/UIApplication/',
      );
      final helperCode = stripSwiftNonCode(helper.single.value);
      expect(
        helperCode,
        contains('connectedScenes'),
        reason: 'the helper resolves the window through the scene lifecycle',
      );
      expect(
        helperCode,
        contains('UIWindowScene'),
        reason: 'the helper looks up a UIWindowScene, not the app delegate',
      );

      for (final callSite in _migratedCallSites) {
        final path = sources.keys.where((p) => p.endsWith(callSite)).toList()
          ..sort();
        expect(path, isNotEmpty, reason: 'missing Swift source: $callSite');
        expect(
          stripSwiftNonCode(sources[path.single]!),
          contains('sceneKeyWindow'),
          reason: '$callSite must resolve its window via sceneKeyWindow',
        );
      }
    });
  });
}
