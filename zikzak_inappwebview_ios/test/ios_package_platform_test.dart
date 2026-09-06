// Bug #316 regression contract (AC3): the SwiftPM package minimum for iOS must
// stay at or below 15.0 so `FlutterGeneratedPluginSwiftPackage` accepts app
// targets on iOS 15.0 (and 16.0+). The reported failure was:
// "The package product 'zikzak-inappwebview-ios' requires minimum platform
// version 16.0 for the iOS platform, but this target supports 15.0."
//
// This test parses Package.swift directly so the floor cannot silently rise; it
// is executable on any host (no Xcode required).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

String stripSwiftLineComments(String source) {
  final out = StringBuffer();
  for (final line in source.split('\n')) {
    final idx = line.indexOf('//');
    out.writeln(idx == -1 ? line : line.substring(0, idx));
  }
  return out.toString();
}

/// Locates `ios/zikzak_inappwebview_ios/Package.swift` walking up from the
/// current directory (works from the package dir or the repo root).
File packageSwiftFile() {
  var dir = Directory.current;
  for (var hop = 0; hop < 5; hop++) {
    final candidate = File(
      '${dir.path}/ios/zikzak_inappwebview_ios/Package.swift',
    );
    if (candidate.existsSync()) return candidate;
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  fail(
    'Could not locate ios/zikzak_inappwebview_ios/Package.swift under or '
    'above ${Directory.current.path}',
  );
}

void main() {
  test(
    'Package.swift declares an iOS platform minimum compatible with iOS 15.0 '
    'app targets (bug #316)',
    () {
      final file = packageSwiftFile();
      final code = stripSwiftLineComments(file.readAsStringSync());
      final matches =
          RegExp(r'\.iOS\("(\d+)\.(\d+)"\)').allMatches(code).toList();

      expect(matches, isNotEmpty,
          reason: 'No `.iOS("…")` platform declaration found in '
              '${file.path}');

      for (final m in matches) {
        final major = int.parse(m.group(1)!);
        final minor = int.parse(m.group(2)!);
        final declared = '$major.$minor';
        final tooHigh = major > 15 || (major == 15 && minor > 0);
        expect(tooHigh, isFalse,
            reason:
                'iOS platform minimum $declared exceeds 15.0 — apps targeting '
                'iOS 15.0 are rejected by FlutterGeneratedPluginSwiftPackage '
                '(bug #316). If a newer API is required, guard it with '
                '#available instead of raising the package floor.');
      }
    },
  );
}
