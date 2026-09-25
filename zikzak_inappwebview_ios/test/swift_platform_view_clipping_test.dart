// Bug #331 regression contract: the WKWebView the plugin hands to Flutter is a
// platform view whose native rendering must never escape the bounds Flutter
// allocates for it. UIView.clipsToBounds defaults to NO and WebKit does not
// guarantee clipping on the root view either; on the Flutter 3.47.x TLHC
// compositing path a mis-clipped native layer paints over sibling Flutter
// content (the "rendering layer confusion" of issue #331). The web view root
// must therefore set clipsToBounds = true unconditionally.
//
// Executable on any host (no Xcode required) — the #316/#328 source-contract
// precedent.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'platform view clips its own rendering to its Flutter bounds (bug #331)',
    () {
      var dir = Directory.current;
      File? sourceFile;
      for (var hop = 0; hop < 5; hop++) {
        final candidate = File(
          '${dir.path}/ios/zikzak_inappwebview_ios/Sources/'
          'zikzak_inappwebview_ios/InAppWebView/InAppWebView.swift',
        );
        if (candidate.existsSync()) {
          sourceFile = candidate;
          break;
        }
        final parent = dir.parent;
        if (parent.path == dir.path) break;
        dir = parent;
      }
      expect(sourceFile, isNotNull,
          reason: 'InAppWebView.swift not found under or above '
              '${Directory.current.path}');

      final source = sourceFile!.readAsStringSync();
      // Strip line comments so a commented-out assignment cannot satisfy the
      // contract. NOTE: this naive split also truncates `https://` inside
      // string literals — harmless for this contract (the statements it pins
      // never live inside a string literal), so do not "fix" the stripping
      // without re-proving the contract still fails on a commented-out or
      // opt-out assignment.
      final code = source
          .split('\n')
          .map((line) => line.contains('//') ? line.split('//').first : line)
          .join('\n');

      // Pin the root-view assignment by whole trimmed statement, not by a
      // regex anywhere in the file: `\b` matches right after a `.`, so a
      // future unrelated `scrollView.clipsToBounds = true` would satisfy a
      // regex match while the root view stays unclipped — a false green for
      // exactly the regression this test exists to catch. The lines that
      // legitimately trim to `clipsToBounds = true` are the root assignments
      // (the designated-initializer belt-and-braces and prepare()).
      final codeLines = code
          .split('\n')
          .map((line) => line.trim())
          .map(
            (line) => line.endsWith(';')
                ? line.substring(0, line.length - 1).trim()
                : line,
          )
          .toList();

      expect(
        codeLines.contains('clipsToBounds = true'),
        isTrue,
        reason:
            'InAppWebView must set clipsToBounds = true on its root view: '
            'the Flutter 3.47.x TLHC path can hand the native layer a wrong '
            'clip, and an unclipped WKWebView then paints over sibling '
            'Flutter content (issue #331 rendering confusion).',
      );
      expect(
        codeLines.where((line) => line == 'clipsToBounds = false'),
        isEmpty,
        reason: 'Nothing may un-clip the platform view root: a '
            '`clipsToBounds = false` on the root view reintroduces the '
            'issue #331 native-paint-over-Flutter-content defect.',
      );
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
