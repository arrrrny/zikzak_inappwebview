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
      final match = RegExp(
        r'<deployment\s+version="(\d+)"\s+identifier="iOS"\s*/>',
      ).firstMatch(storyboard.readAsStringSync());
      expect(match, isNotNull,
          reason: 'No <deployment … identifier="iOS"/> element found in '
              '${storyboard.path}');

      final declared = int.parse(match!.group(1)!);

      final packageSwift = locate('ios/zikzak_inappwebview_ios/Package.swift');
      final floor = RegExp(
        r'\.iOS\("(\d+)\.(\d+)"\)',
      ).firstMatch(packageSwift.readAsStringSync());
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
