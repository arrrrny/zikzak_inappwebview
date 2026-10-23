// Regression contract: WebView.storyboard must not declare an Interface
// Builder deployment target older than the SwiftPM package floor. The document
// shipped from upstream flutter_inappwebview with
// `<deployment version="2048" identifier="iOS"/>` — IB encodes the OS version
// as major * 1024 (+ minor * 64), so 2048 means iOS 2.0 — and every consumer
// build then warns "This file is set to build for a version older than the
// deployment target. Functionality may be limited."
//
// The storyboard only hosts InAppBrowserNavigationController and
// InAppBrowserWebViewController (no IB features newer than the package floor),
// so raising the declared version is safe and silences the warning.
//
// Executable on any host (no Xcode required) — the #316/#328/#331
// source-contract precedent.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Encodes an OS version the way Interface Builder encodes it into a
/// storyboard's `<deployment version="…">` attribute: major * 1024 + minor * 64.
int ibVersion(int major, [int minor = 0]) => major * 1024 + minor * 64;

/// Strips `//` line comments before a floor regex runs, so a commented-out
/// `.iOS("…")` line can never be mistaken for the real platform declaration.
/// Same helper as `ios_package_platform_test.dart` (the #316 precedent).
String stripSwiftLineComments(String source) {
  final out = StringBuffer();
  for (final line in source.split('\n')) {
    final idx = line.indexOf('//');
    out.writeln(idx == -1 ? line : line.substring(0, idx));
  }
  return out.toString();
}

File locate(String relativePath) {
  var dir = Directory.current;
  for (var hop = 0; hop < 5; hop++) {
    final candidate = File('${dir.path}/$relativePath');
    if (candidate.existsSync()) return candidate;
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  fail(
    'Could not locate $relativePath under or above '
    '${Directory.current.path}',
  );
}

void main() {
  test(
    'WebView.storyboard deployment target is not older than the package '
    'iOS floor',
    () {
      final storyboard = locate(
        'ios/zikzak_inappwebview_ios/Sources/'
        'zikzak_inappwebview_ios/Storyboards/WebView.storyboard',
      );
      // Attribute-order tolerant (review finding): match the element first,
      // then read each attribute separately, so an Interface Builder save that
      // reorders `version=` / `identifier=` does not fail with a misleading
      // "element not found" reason.
      final deployment = RegExp(
        r'<deployment\b[^>]*/>',
      ).firstMatch(storyboard.readAsStringSync());
      expect(deployment, isNotNull,
          reason: 'No <deployment …/> element found in ${storyboard.path}');
      final element = deployment!.group(0)!;
      final identifier = RegExp(
        r'identifier="([^"]*)"',
      ).firstMatch(element);
      expect(identifier?.group(1), 'iOS',
          reason: 'The <deployment> element in ${storyboard.path} does not '
              'declare identifier="iOS" — nothing to compare against the '
              'package iOS floor.');
      final version = RegExp(
        r'version="(\d+)"',
      ).firstMatch(element);
      expect(version, isNotNull,
          reason: 'The <deployment> element in ${storyboard.path} declares '
              'no version="…" attribute.');

      final declared = int.parse(version!.group(1)!);

      final packageSwift = locate('ios/zikzak_inappwebview_ios/Package.swift');
      // Strip Swift line comments before matching (parity with the #316
      // sibling test) so a commented-out `.iOS("…")` line is never read as
      // the floor.
      final floor = RegExp(
        r'\.iOS\("(\d+)\.(\d+)"\)',
      ).firstMatch(stripSwiftLineComments(packageSwift.readAsStringSync()));
      expect(floor, isNotNull,
          reason: 'No `.iOS("…")` platform declaration found in '
              '${packageSwift.path}');
      final floorMajor = int.parse(floor!.group(1)!);
      final floorMinor = int.parse(floor.group(2)!);
      final floorEncoded = ibVersion(floorMajor, floorMinor);

      expect(
        declared,
        greaterThanOrEqualTo(floorEncoded),
        reason:
            'WebView.storyboard declares IB deployment version $declared '
            '(iOS ${declared ~/ 1024}.${(declared % 1024) ~/ 64}), older than '
            'the package floor iOS $floorMajor.$floorMinor '
            '(encoded $floorEncoded). Xcode then warns "This file is set to '
            'build for a version older than the deployment target" for every '
            'consumer build. Update the <deployment> element to at least '
            'version="$floorEncoded".',
      );
    },
  );
}
