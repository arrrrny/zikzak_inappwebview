// Bug #327 regression contract (AC1–AC3): the Swift overlay declares
// `WKNavigationAction.sourceFrame` (and its `request`/`securityOrigin`)
// non-optional, but WebKit can deliver a nil runtime object on macOS 15.x.
// Direct member access then performs an unconditional ObjC bridge that traps
// (EXC_BREAKPOINT in URLRequest._unconditionallyBridgeFromObjectiveC, main
// thread — issue #327). Every macOS-package read of a navigation action's
// source frame must therefore go through the KVC-based accessor that yields
// nil instead of trapping, mirroring the `value(forKey: "request")` read the
// package already ships in WKFrameInfo.toMap().
//
// This test encodes that rule as a source scan so the bug class cannot
// silently return; it is executable on any host (no Xcode required).
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

List<File> swiftFilesUnder(Directory root) {
  final files = <File>[];
  for (final e in root.listSync(recursive: true)) {
    if (e is File && e.path.endsWith('.swift')) files.add(e);
  }
  files.sort((a, b) => a.path.compareTo(b.path));
  return files;
}

void main() {
  group('sourceFrame KVC contract (bug #327)', () {
    test(
      'AC1: no dot-member access of a navigation action source frame in '
      'macOS Swift sources',
      () {
        final macosDir = packageMacosDir();
        final sourcesDir = Directory('${macosDir.path}/Sources');
        expect(sourcesDir.existsSync(), isTrue,
            reason: 'Swift sources dir missing: ${sourcesDir.path}');

        final violations = <String>[];
        final dotAccess = RegExp(r'\.sourceFrame\b');
        for (final file in swiftFilesUnder(sourcesDir)) {
          final rel = file.path.replaceFirst('${macosDir.path}/', '');
          final code = stripSwiftNonCode(file.readAsStringSync());
          for (final match in dotAccess.allMatches(code)) {
            final line =
                '\n'.allMatches(code.substring(0, match.start)).length + 1;
            violations.add('$rel:$line');
          }
        }

        expect(violations, isEmpty,
            reason:
                'A navigation action source frame must never be read through '
                'dot-member access: the Swift overlay declares it '
                'non-optional while WebKit can deliver nil at runtime '
                '(macOS 15.x), and the unconditional bridge traps '
                '(EXC_BREAKPOINT). Read it via the KVC-based accessor '
                '(sourceFrameMap) instead. Violations (relative to '
                '$macosDir.path):');
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test(
      'AC2: a KVC-based sourceFrameMap accessor exists and reads the frame '
      'and its members via valueForKey',
      () {
        final macosDir = packageMacosDir();
        final sourcesDir = Directory('${macosDir.path}/Sources');
        final candidates = swiftFilesUnder(sourcesDir)
            .where((f) => f.readAsStringSync().contains('func sourceFrameMap()'))
            .toList();

        expect(candidates.length, 1,
            reason: 'exactly one sourceFrameMap accessor definition expected');
        final raw = candidates.first.readAsStringSync();
        for (final kvcKey in ['value(forKey: "sourceFrame")', 'value(forKey: "request")']) {
          expect(raw.contains(kvcKey), isTrue,
              reason:
                  'the accessor must read members via KVC ($kvcKey) so a nil '
                  'runtime object yields nil instead of trapping; found in '
                  '${candidates.first.path}');
        }
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test(
      'AC3: both navigation callbacks (decidePolicy + create window) consume '
      'the accessor',
      () {
        final macosDir = packageMacosDir();
        final sourcesDir = Directory('${macosDir.path}/Sources');
        var callSites = 0;
        for (final file in swiftFilesUnder(sourcesDir)) {
          callSites +=
              RegExp(r'\.sourceFrameMap\(\)').allMatches(file.readAsStringSync()).length;
        }

        expect(callSites, 2,
            reason:
                'decidePolicyForNavigationAction and createWebViewWith both '
                'previously read the source frame unconditionally (the two '
                'crash sites of issue #327); each must consume '
                'sourceFrameMap() exactly once');
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}
