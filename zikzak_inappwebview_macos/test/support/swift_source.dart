// Shared helpers for the package's Swift source-contract tests.
//
// Several regression contracts in this package are enforced by scanning the
// plugin's `.swift` sources as text, which keeps them executable on any host
// (no Xcode required). The scanning primitive started as a copy per test file
// and had already begun to diverge in its comments; new contracts import it
// from here instead.
//
// The older copies in `swift_sourceframe_kvc_test.dart`,
// `content_blockers_rule_list_test.dart`,
// `download_start_request_parity_test.dart` and
// `web_authentication_support_macos_test.dart` are deliberately left alone:
// moving them is a separate cleanup, not part of any one bug fix.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Strips line/block comments and string literals so only real code tokens
/// are scanned. Ported from the iOS package's swift_availability_usage_test;
/// handles Swift block-comment nesting and triple-quoted strings.
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
        // One backslash: raw r'\' is a 1-char string (r'\\' would be 2 chars
        // and can never equal the 1-char source[j], silently disabling the
        // escape skip).
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

/// The body of a Swift function, brace-balanced. Returned raw so contracts can
/// assert on string-literal keys, which [stripSwiftNonCode] erases.
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
