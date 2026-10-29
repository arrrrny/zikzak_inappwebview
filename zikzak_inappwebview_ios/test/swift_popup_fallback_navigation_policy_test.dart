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
/// are scanned. Block comments nest, matching Swift's grammar. String
/// literals are skipped in every Swift form: single-line, multiline
/// (`"""`), raw (`#"..."#`, any number of `#`s) and raw multiline.
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
      i = source.startsWith('"""', i)
          ? _skipMultilineString(source, i)
          : _skipSingleLineString(source, i);
    } else if (source[i] == '#') {
      final hashes = _rawStringHashes(source, i);
      if (hashes > 0) {
        i = _skipRawString(source, i, hashes);
      } else {
        out.write(source[i]);
        i++;
      }
    } else {
      out.write(source[i]);
      i++;
    }
  }
  return out.toString();
}

/// The number of `#`s at [i] when they open a raw string literal (i.e. are
/// immediately followed by a quote); 0 when they are plain code, as in the
/// `#available` / `#if` directives.
int _rawStringHashes(String source, int i) {
  var hashes = 0;
  while (source.startsWith('#', i + hashes)) {
    hashes++;
  }
  return source.startsWith('"', i + hashes) ? hashes : 0;
}

/// Whether [count] `#`s sit at [i].
bool _hasHashes(String source, int i, int count) {
  for (var h = 0; h < count; h++) {
    if (!source.startsWith('#', i + h)) {
      return false;
    }
  }
  return true;
}

/// The index just past a single-line string literal opening at [i]; `\\`
/// escapes the next character.
int _skipSingleLineString(String source, int i) {
  i++;
  while (i < source.length && source[i] != '"') {
    i += source[i] == '\\' ? 2 : 1;
  }
  return i + 1;
}

/// The index just past a multiline string literal opening at [i] with `"""`.
/// Escapes work as in single-line literals; the first unescaped `"""` closes
/// the literal, so `\\` before a quote cannot swallow the delimiter.
int _skipMultilineString(String source, int i) {
  i += 3;
  while (i < source.length && !source.startsWith('"""', i)) {
    i += source[i] == '\\' ? 2 : 1;
  }
  return i + 3;
}

/// The index just past a raw string literal opening at [i] with [hashes]
/// `#`s (single-line or multiline). The delimiter closes on the quote (or
/// `"""`) followed by exactly [hashes] `#`s; `\` followed by [hashes] `#`s
/// escapes the next character, so an embedded quote does not close the
/// literal.
int _skipRawString(String source, int i, int hashes) {
  final multiline = source.startsWith('"""', i + hashes);
  i += hashes + (multiline ? 3 : 1);
  while (i < source.length) {
    if (source[i] == '\\') {
      i += _hasHashes(source, i + 1, hashes) &&
              source.startsWith('"', i + 1 + hashes)
          ? 1 + hashes + 1
          : 1;
    } else if (multiline
        ? source.startsWith('"""', i) && _hasHashes(source, i + 3, hashes)
        : source[i] == '"' && _hasHashes(source, i + 1, hashes)) {
      return i + (multiline ? 3 : 1) + hashes;
    } else {
      i++;
    }
  }
  return source.length;
}

/// Returns the brace-balanced block that opens at the first `{` at or after
/// the first match of [start] in [source], starting from [from].
String _block(String source, Pattern start, {int from = 0}) {
  final declIndex = source.indexOf(start, from);
  if (declIndex < 0) {
    fail('pattern not found: $start');
  }
  final open = source.indexOf('{', declIndex);
  if (open < 0) {
    fail('no opening brace after pattern: $start');
  }
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

  group('stripSwiftNonCode — Swift literal forms', () {
    test('a multiline string does not swallow the code that follows it', () {
      const src = 'let a = """\nplain body\n"""\nlet b = 2;\n// tail\nlet c = 1;';
      final stripped = stripSwiftNonCode(src);
      expect(stripped, contains('let b = 2;'));
      expect(stripped, contains('let c = 1;'));
      expect(stripped, isNot(contains('plain body')));
    });

    test('comment markers inside a multiline string are not comments', () {
      const src =
          'let a = """\n// looks like a comment\n/* and this */\n""";\nlet b = 2;';
      final stripped = stripSwiftNonCode(src);
      expect(stripped, contains('let b = 2;'));
      expect(stripped, isNot(contains('looks like a comment')));
      expect(stripped, isNot(contains('and this')));
    });

    test('a raw string keeps embedded quotes out of the scan', () {
      const src = 'let a = #"raw "quoted" body"#;\nlet b = 3;';
      final stripped = stripSwiftNonCode(src);
      expect(stripped, contains('let b = 3;'));
      expect(stripped, isNot(contains('quoted')));
    });

    test('a raw multiline string is skipped to its own delimiter', () {
      const src = 'let a = #"""\n// inner\n"""#\nlet b = 4;';
      final stripped = stripSwiftNonCode(src);
      expect(stripped, contains('let b = 4;'));
      expect(stripped, isNot(contains('inner')));
    });

    test('an escaped quote does not end a raw string early', () {
      const src = r'let a = #"esc \#" quote"#; let b = 5;';
      final stripped = stripSwiftNonCode(src);
      expect(stripped, contains('let b = 5;'));
    });

    test('a hash that does not open a string stays in the scan', () {
      expect(stripSwiftNonCode('if #available(iOS 14.0, *) { run() }'),
          contains('#available(iOS 14.0, *)'));
    });
  });

  group('_block — failure modes', () {
    test('fails with a clean message when no brace follows the pattern', () {
      expect(
          () => _block('pattern without braces', 'pattern'),
          throwsA(predicate(
              (e) => '$e'.contains('no opening brace after pattern'))));
    });
  });
}
