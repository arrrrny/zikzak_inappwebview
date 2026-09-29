// Issue #338 regression contract: macOS `InAppWebViewSettings.contentBlockers`
// is declared and (reflection-)decoded but never consumed — nothing in the
// macOS Swift sources compiles or adds a WKContentRuleList, so the setting is
// silently inert on macOS while it works on iOS (the iOS updateSettings
// branch serializes the rules and compiles them through
// WKContentRuleListStore.default().compileContentRuleList, then adds the
// result to the configuration's userContentController).
//
// The macOS SPM package cannot host unit tests (its only dependency is the
// ephemeral FlutterFramework, generated inside a Flutter build), so — like
// the #327 KVC contract and the #317 initializer-parity tests — this test
// encodes the rule as a source scan executable on any host: the macOS
// InAppWebView settings path must mirror the iOS updateSettings branch.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Strips line/block comments and string literals so only real code tokens
/// are scanned. Ported from the sibling swift_sourceframe_kvc_test (which
/// ported it from the iOS package's swift_availability_usage_test); handles
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

void main() {
  final inAppWebViewSwift = File(
    'macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/'
    'InAppWebView.swift',
  );

  group('macOS contentBlockers → WKContentRuleList (issue #338)', () {
    late String source;

    setUpAll(() {
      expect(
        inAppWebViewSwift.existsSync(),
        isTrue,
        reason:
            'InAppWebView.swift not found relative to package root '
            '(cwd: ${Directory.current.path})',
      );
      source = stripSwiftNonCode(inAppWebViewSwift.readAsStringSync());
    });

    test('compiles contentBlockers through WKContentRuleListStore', () {
      expect(
        RegExp(
          r'WKContentRuleListStore\s*\.\s*default\(\)\s*\.\s*compileContentRuleList',
        ).hasMatch(source),
        isTrue,
        reason:
            'the macOS settings path must compile contentBlockers into a '
            'WKContentRuleList via WKContentRuleListStore.default(), '
            'mirroring the iOS updateSettings branch',
      );
    });

    test('adds the compiled rule list to the userContentController', () {
      expect(
        RegExp(
          r'userContentController\s*\.\s*add\(\s*contentRuleList',
        ).hasMatch(source),
        isTrue,
        reason:
            'the compiled WKContentRuleList must be added to the '
            "configuration's userContentController, mirroring iOS",
      );
    });

    test('clears stale rule lists before applying new ones', () {
      expect(
        source.contains('removeAllContentRuleLists()'),
        isTrue,
        reason:
            'applying new contentBlockers must removeAllContentRuleLists() '
            'first so rules dropped from the settings stop blocking '
            '(mirrors iOS)',
      );
    });
  });
}
