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
      // contract.
      final code = source
          .split('\n')
          .map((line) => line.contains('//') ? line.split('//').first : line)
          .join('\n');

      final matches = RegExp(r'\bclipsToBounds\s*=\s*true\b').allMatches(code);
      expect(matches, isNotEmpty,
          reason:
              'InAppWebView must set clipsToBounds = true on its root view: '
              'the Flutter 3.47.x TLHC path can hand the native layer a wrong '
              'clip, and an unclipped WKWebView then paints over sibling '
              'Flutter content (issue #331 rendering confusion).');
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
