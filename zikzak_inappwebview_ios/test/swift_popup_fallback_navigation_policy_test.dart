// Issue #394 source contract: the `createWebViewWith` popup fallback must not
// bypass the navigation policy. When `onCreateWindow` is not handled, the
// fallback loads the popup request in the same WebView; it used to go through
// `loadUrl(urlRequest:allowingReadAccessTo:)`, which sets
// `isNavigatingWithCustomAction = true`, and `decidePolicyFor` then returns
// `.allow` immediately — before `URLValidationManager` and before the Dart
// `shouldOverrideUrlLoading` callback. Apps using `shouldOverrideUrlLoading`
// as a navigation allow-list (or handing custom schemes to the OS) were
// silently bypassed for `window.open` popups, and for `target=_blank` links
// whenever their policy allowed non-main-frame actions. In
// flutter_inappwebview 6.1.5 the same fallback went through `decidePolicyFor`.
//
// The fix: `loadUrl` gains an `overridingNavigationPolicy` argument. The
// Dart-facing entry points keep `true` (the `isNavigatingWithCustomAction`
// bypass exists so a load initiated from Dart does not re-trigger the app's
// own policy, issue #132), while the native `createWebViewWith` fallback
// passes `false` so the popup navigation is decided by the normal policy
// path.
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

/// Returns the brace-balanced block that opens at the first `{` at or after
/// the first match of [start] in [source], starting from [from].
String _block(String source, Pattern start, {int from = 0}) {
  final declIndex = source.indexOf(start, from);
  if (declIndex < 0) {
    fail('pattern not found: $start');
  }
  final open = source.indexOf('{', declIndex);
  var depth = 0;
  for (var i = open; i < source.length; i++) {
    if (source[i] == '{') {
      depth++;
    } else if (source[i] == '}') {
      depth--;
      if (depth == 0) {
        return source.substring(declIndex, i + 1);
      }
    }
  }
  fail('unbalanced braces for pattern: $start');
}

/// Collapses whitespace runs so assertions survive formatting differences.
String collapseWhitespace(String source) =>
    source.replaceAll(RegExp(r'\s+'), ' ').trim();

void main() {
  final sources = swiftSources();
  final viewEntry = sources.entries
      .singleWhere((e) => e.key.endsWith('InAppWebView/InAppWebView.swift'));
  final view = collapseWhitespace(stripSwiftNonCode(viewEntry.value));

  group('issue #394 — popup fallback respects the navigation policy', () {
    test(
        'the createWebViewWith fallback loads with overridingNavigationPolicy '
        'false', () {
      expect(
          view,
          contains(
              'self?.loadUrl(urlRequest: navigationAction.request, '
              'allowingReadAccessTo: nil, overridingNavigationPolicy: false)'),
          reason: 'the popup fallback must be decided by decidePolicyFor '
              '(URLValidationManager + shouldOverrideUrlLoading), not exempted '
              'from it');
    });

    test(
        'loadUrl sets isNavigatingWithCustomAction only under '
        'overridingNavigationPolicy', () {
      final loadUrl = collapseWhitespace(_block(
          collapseWhitespace(view),
          'func loadUrl( urlRequest: URLRequest, allowingReadAccessTo: URL?, overridingNavigationPolicy: Bool )'));
      expect(loadUrl, contains('overridingNavigationPolicy'));
      // The flag write sits inside the conditional, not at the top of the
      // closure: the unconditional form would reintroduce the bypass for the
      // popup fallback.
      expect(
          loadUrl,
          contains(
              'if overridingNavigationPolicy { self.isNavigatingWithCustomAction = true }'));
    });

    test(
        'the Dart-facing loadUrl entry point keeps the navigation-policy '
        'override', () {
      // The one-argument-plus-read-access wrapper must keep passing true: a
      // load initiated from Dart must not re-trigger the app's own
      // shouldOverrideUrlLoading (issue #132 behaviour).
      expect(
          view,
          contains(
              'loadUrl( urlRequest: urlRequest, allowingReadAccessTo: allowingReadAccessTo, overridingNavigationPolicy: true )'));
    });
  });
}
