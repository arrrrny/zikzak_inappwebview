// Bug #373 regression contract: the `evaluateJavascript` handler reported a
// thrown JS exception as WebKit's generic `localizedDescription` — the string
// "A JavaScript exception occurred" — with `details: nil`. The actionable
// fields (`WKJavaScriptExceptionMessage`, line, column, source URL) live in
// the error's `userInfo` and were discarded, so a Dart caller had nothing to
// bisect a failing `page.evaluate` with.
//
// The `callAsyncJavaScript` handler in the same file already extracts the
// message from `userInfo`; the `evaluateJavascript` failure paths must do the
// same, and carry the full context in `details`.
//
// This test encodes that rule as a source scan so the bug class cannot
// silently return; it is executable on any host (no Xcode required).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Strips line/block comments and string literals so only real code tokens
/// are scanned. Ported from the package's swift_sourceframe_kvc_test; handles
/// Swift block-comment nesting and triple-quoted strings.
String stripSwiftNonCode(String source) {
  final out = StringBuffer();
  var i = 0;
  var blockDepth = 0;
  while (i < source.length) {
    final rest = source.substring(i);
    if (blockDepth > 0) {
      if (rest.startsWith('/*')) {
        blockDepth++;
        i += 2;
      } else if (rest.startsWith('*/')) {
        blockDepth--;
        i += 2;
      } else {
        if (source[i] == '\n') out.write('\n');
        i++;
      }
      continue;
    }
    if (rest.startsWith('/*')) {
      blockDepth++;
      i += 2;
      out.write('  ');
      continue;
    }
    if (rest.startsWith('//')) {
      final end = source.indexOf('\n', i);
      i = end == -1 ? source.length : end;
      continue;
    }
    if (rest.startsWith('"""')) {
      final end = source.indexOf('"""', i + 3);
      i = end == -1 ? source.length : end + 3;
      out.write('""');
      continue;
    }
    if (source[i] == '"') {
      var j = i + 1;
      while (j < source.length) {
        if (source[j] == r'\') {
          j += 2;
          continue;
        }
        if (source[j] == '"' || source[j] == '\n') break;
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

/// Locates the macOS package root (`macos/zikzak_inappwebview_macos`) relative
/// to the current working directory, walking up at most a few levels so the
/// test works when invoked from the package dir or the repo root.
Directory packageMacosDir() {
  var dir = Directory.current;
  for (var hop = 0; hop < 5; hop++) {
    final candidate = Directory('${dir.path}/macos/zikzak_inappwebview_macos');
    if (candidate.existsSync()) return candidate;
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  fail(
    'Could not locate macos/zikzak_inappwebview_macos under or above '
    '${Directory.current.path}',
  );
}

/// The single Swift source that owns the macOS method-channel switch.
File sourceFile() {
  final file = File(
    '${packageMacosDir().path}/Sources/zikzak_inappwebview_macos/'
    'InAppWebView.swift',
  );
  expect(file.existsSync(), isTrue, reason: 'missing ${file.path}');
  return file;
}

/// The `case "evaluateJavascript":` arm of the channel switch — from that case
/// label up to the next case label at the same indentation.
///
/// Located on the RAW source (the case label is a string literal, so a scanner
/// that strips literals could never find it), then comment/string-stripped for
/// token assertions.
String evaluateJavascriptArm(String rawSource) {
  final label = 'case "evaluateJavascript":';
  final first = rawSource.indexOf(label);
  expect(
    first,
    isNot(-1),
    reason: 'the macOS channel switch has no evaluateJavascript arm',
  );
  expect(
    rawSource.indexOf(label, first + 1),
    -1,
    reason: 'expected exactly one evaluateJavascript arm',
  );
  final nextCase = RegExp(
    r'\n {8}case "',
  ).allMatches(rawSource.substring(first + 1));
  final end = nextCase.isEmpty
      ? rawSource.length
      : first + 1 + nextCase.first.start;
  return stripSwiftNonCode(rawSource.substring(first, end));
}

/// The body of a file-private Swift function, brace-balanced. Scanned raw:
/// the contracts below assert on string-literal keys, which
/// [stripSwiftNonCode] erases.
String functionBody(String code, String signature) {
  final start = code.indexOf(signature);
  expect(start, isNot(-1), reason: 'missing Swift function `$signature`');
  final open = code.indexOf('{', start);
  expect(open, isNot(-1), reason: '`$signature` has no body');
  var depth = 0;
  for (var i = open; i < code.length; i++) {
    if (code[i] == '{') depth++;
    if (code[i] == '}') {
      depth--;
      if (depth == 0) return code.substring(open, i + 1);
    }
  }
  fail('unbalanced braces in `$signature`');
}

void main() {
  group('evaluateJavascript JS-exception details (bug #373)', () {
    test('AC1: both failure paths report through the JS-exception builder, not '
        'the bare localizedDescription', () {
      final arm = evaluateJavascriptArm(sourceFile().readAsStringSync());

      // The two failure paths the issue names: the WKContentWorld outcome
      // and the plain (value, error) callback.
      expect(
        RegExp(r'\.failure').allMatches(arm).length,
        1,
        reason: 'expected the WKContentWorld outcome failure path',
      );
      expect(
        RegExp(r'if let error = error').allMatches(arm).length,
        1,
        reason: 'expected the plain completion-handler failure path',
      );
      expect(
        RegExp(r'javaScriptExceptionError\(').allMatches(arm).length,
        2,
        reason:
            'both evaluateJavascript failure paths must build their '
            'FlutterError via javaScriptExceptionError(error) so the '
            'WKJavaScriptExceptionMessage/line/column reach Dart',
      );
      expect(
        arm.contains('message: error.localizedDescription'),
        isFalse,
        reason:
            'the generic "A JavaScript exception occurred" message '
            'must not be the only thing a Dart caller sees',
      );
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('AC2: the builder reads WKJavaScriptExceptionMessage, with the same '
        'fallback chain callAsyncJavaScript uses', () {
      // The keys are string literals, so the body is scanned raw — a
      // literal-stripping scan could never see them (it would see `""`).
      final body = functionBody(
        sourceFile().readAsStringSync(),
        'func javaScriptExceptionError(',
      );
      for (final marker in [
        'WKJavaScriptExceptionMessage',
        'NSLocalizedDescription',
        'localizedDescription',
      ]) {
        expect(
          body.contains(marker),
          isTrue,
          reason:
              'javaScriptExceptionError must derive its message from '
              '$marker, mirroring the callAsyncJavaScript precedent',
        );
      }
      // The exception text must win over the generic description.
      expect(
        body.indexOf('WKJavaScriptExceptionMessage') <
            body.indexOf('NSLocalizedDescription'),
        isTrue,
        reason:
            'WKJavaScriptExceptionMessage must be tried before the '
            'generic NSLocalizedDescription fallback',
      );
    }, timeout: const Timeout(Duration(minutes: 2)));

    test(
      'AC3: the builder carries line, column and source URL in `details`',
      () {
        // The keys are string literals, so the body is scanned raw — a
        // literal-stripping scan could never see them (it would see `""`).
        final body = functionBody(
          sourceFile().readAsStringSync(),
          'func javaScriptExceptionError(',
        );
        for (final key in [
          'WKJavaScriptExceptionLineNumber',
          'WKJavaScriptExceptionColumnNumber',
          'WKJavaScriptExceptionSourceURL',
        ]) {
          expect(
            body.contains(key),
            isTrue,
            reason:
                'details must carry $key so a Dart caller can locate '
                'the throwing line without re-deriving it',
          );
        }
        expect(
          body.contains('details:'),
          isTrue,
          reason:
              'the builder must pass a non-nil details map for a JS '
              'exception',
        );
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}
