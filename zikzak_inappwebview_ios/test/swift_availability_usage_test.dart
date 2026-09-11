// Bug #316 regression contract (AC1): every `#available(iOS …, *)` /
// `#unavailable(iOS …, *)` occurrence in the iOS package's Swift sources must be
// the direct condition of an `if`, `guard` or `while` statement. Swift rejects
// availability used as a boolean operand ("#available may only be used as
// condition of an 'if', 'guard' or 'while' statement") — the exact compile error
// reported in issue #316 at InAppWebView.swift:887
// (`!dataStoreWasSelected && (!hasValidPersistentId || !#available(iOS 17.0, *))`).
//
// This test encodes that grammar rule as a source scan so the bug class cannot
// silently return; it is executable on any host (no Xcode required).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Allowed tokens directly preceding an availability condition:
/// - `if`, `guard`, `while` — statement keywords;
/// - `,` — later element of an if/guard condition list
///   (e.g. `guard let id = x, #available(iOS 17.0, *) else …`);
/// - `(` — start of the condition slot itself (`if #available(…)`);
/// - `:` — case label inside availability `#if`-style contexts is not valid,
///   but kept out on purpose.
const _validPredecessors = {'if', 'guard', 'while', ',', '('};

/// Allowed tokens directly following the closing paren of an availability
/// condition: `,` (more condition elements), `{` (statement body), `else`
/// (guard trailing clause). Anything else means the condition was used as an
/// expression operand (boolean operators, ternary, nested parens, assignment…).
const _validSuccessors = {',', '{', 'else'};

/// Strips line/block comments and string literals so only real code tokens are
/// scanned. Handles Swift block-comment nesting and triple-quoted strings.
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
        if (source[j] == r'\\') {
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

/// Returns `file:line` violations where an availability condition is used
/// outside a direct if/guard/while condition slot.
List<String> scanAvailabilityUsage(String source) {
  final code = stripSwiftNonCode(source);
  final violations = <String>[];
  final pattern = RegExp(r'#(un)?available\s*\(');
  for (final match in pattern.allMatches(code)) {
    final line = '\n'.allMatches(code.substring(0, match.start)).length + 1;

    // Token immediately before the condition (skip horizontal whitespace).
    var pre = match.start - 1;
    while (pre >= 0 && (code[pre] == ' ' || code[pre] == '\t')) {
      pre--;
    }
    final prevChar = pre >= 0 ? code[pre] : '';
    var prevToken = '';
    if (RegExp(r'[A-Za-z_]').hasMatch(prevChar)) {
      var s = pre;
      while (s >= 0 && RegExp(r'[A-Za-z_]').hasMatch(code[s])) {
        s--;
      }
      prevToken = code.substring(s + 1, pre + 1);
    } else {
      prevToken = prevChar;
    }

    // First token after the matching close paren (skip whitespace).
    var depth = 0;
    var j = match.end - 1; // at the opening paren
    while (j < code.length) {
      if (code[j] == '(') depth++;
      if (code[j] == ')') {
        depth--;
        if (depth == 0) break;
      }
      j++;
    }
    var k = j + 1;
    while (k < code.length && (code[k] == ' ' || code[k] == '\t')) {
      k++;
    }
    var nextToken = '';
    if (k < code.length && RegExp(r'[A-Za-z_]').hasMatch(code[k])) {
      var e = k;
      while (e < code.length && RegExp(r'[A-Za-z_]').hasMatch(code[e])) {
        e++;
      }
      nextToken = code.substring(k, e);
    } else if (k < code.length) {
      nextToken = code[k];
    }

    final badPredecessor = !_validPredecessors.contains(prevToken);
    final badSuccessor = !_validSuccessors.contains(nextToken);
    if (badPredecessor || badSuccessor) {
      violations.add(
        'line $line: availability condition preceded by `$prevToken` and '
        'followed by `$nextToken`',
      );
    }
  }
  return violations;
}

/// Returns the text between the `{` that opens the braces-delimited block at or
/// after [start] and its matching `}`. Returns the empty string when the block
/// is unterminated, so the caller's index lookups fail loudly rather than
/// silently passing.
String functionBody(String code, int start) {
  final open = code.indexOf('{', start);
  if (open == -1) return '';
  var depth = 0;
  for (var i = open; i < code.length; i++) {
    if (code[i] == '{') {
      depth++;
    } else if (code[i] == '}') {
      depth--;
      if (depth == 0) return code.substring(open + 1, i);
    }
  }
  return '';
}

/// Number of `{`-blocks still open at [index] in [code] — the brace depth of
/// the character at that position.
int braceDepthAt(String code, int index) {
  var depth = 0;
  for (var i = 0; i < index && i < code.length; i++) {
    if (code[i] == '{') {
      depth++;
    } else if (code[i] == '}') {
      depth--;
    }
  }
  return depth;
}

/// Locates the iOS package root (`ios/zikzak_inappwebview_ios`) relative to the
/// current working directory, walking up at most a few levels so the test works
/// when invoked from the package dir or the repo root.
Directory packageIosDir() {
  var dir = Directory.current;
  for (var hop = 0; hop < 5; hop++) {
    final candidate = Directory(
      '${dir.path}/ios/zikzak_inappwebview_ios',
    );
    if (candidate.existsSync()) return candidate;
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  fail(
    'Could not locate ios/zikzak_inappwebview_ios under or above '
    '${Directory.current.path}',
  );
}

List<File> swiftFilesUnder(Directory root) {
  final files = <File>[];
  final entities = root.listSync(recursive: true);
  for (final e in entities) {
    if (e is File && e.path.endsWith('.swift')) files.add(e);
  }
  files.sort((a, b) => a.path.compareTo(b.path));
  return files;
}

void main() {
  test(
    'no #available/#unavailable used outside if/guard/while conditions '
    '(bug #316, InAppWebView.swift:887 class)',
    () {
      final iosDir = packageIosDir();
      final sourcesDir = Directory('${iosDir.path}/Sources');
      expect(sourcesDir.existsSync(), isTrue,
          reason: 'Swift sources dir missing: ${sourcesDir.path}');

      final violations = <String>[];
      for (final file in swiftFilesUnder(sourcesDir)) {
        final rel = file.path.replaceFirst('${iosDir.path}/', '');
        for (final v in scanAvailabilityUsage(file.readAsStringSync())) {
          violations.add('$rel:$v');
        }
      }

      expect(violations, isEmpty,
          reason:
              '#available/#unavailable may only be the direct condition of an '
              "'if', 'guard' or 'while' statement. Violations (relative to "
              '$iosDir.path):');
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'data-store selection flag is visible to the iOS 11 cookie setup block',
    () {
      final iosDir = packageIosDir();
      final source = File(
        '${iosDir.path}/Sources/zikzak_inappwebview_ios/'
        'InAppWebView/InAppWebView.swift',
      ).readAsStringSync();
      final code = stripSwiftNonCode(source);
      final functionStart = code.indexOf(
        'public static func preWKWebViewConfiguration',
      );
      expect(functionStart, greaterThanOrEqualTo(0));
      final functionSource = functionBody(code, functionStart);

      final declaration = functionSource.indexOf(
        'var dataStoreWasSelected = false',
      );
      final ios9ConfigurationBlock = functionSource.indexOf(
        'if #available(iOS 9.0, *) {',
      );
      final cookieSetupUse = functionSource.indexOf(
        'if !dataStoreWasSelected {',
      );

      expect(declaration, greaterThanOrEqualTo(0));
      expect(ios9ConfigurationBlock, greaterThanOrEqualTo(0));
      expect(cookieSetupUse, greaterThan(ios9ConfigurationBlock));
      // Textual order alone is not the invariant: a declaration nested inside a
      // sibling block that closes before the iOS 9 block is still "above" it,
      // yet is out of scope for the iOS 11 cookie block and fails to compile.
      // Equal brace depth proves the declaration sits in the scope that
      // encloses both availability blocks.
      expect(
        braceDepthAt(functionSource, declaration),
        equals(braceDepthAt(functionSource, ios9ConfigurationBlock)),
        reason:
            'The flag is read by a later iOS 11 availability block, so it must '
            'be declared in their shared settings scope — a sibling of the '
            'iOS 9 block, not nested inside another block that closes before '
            'it.',
      );
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
