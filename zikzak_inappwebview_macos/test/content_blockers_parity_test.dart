// Bug #338 regression contract (AC1): `InAppWebViewSettings.contentBlockers`
// was declared and decoded on macOS but never consumed — nothing compiled or
// added a `WKContentRuleList`, so the setting was silently inert on macOS
// while the identical setting works on iOS (WKContentRuleListStore.default()
// .compileContentRuleList + configuration.userContentController.add, in the
// iOS `updateSettings` branch). WebKit applies content rule lists before a
// request starts, which is exactly what the issue reports as missing.
//
// This test encodes that rule as a source scan so the bug class cannot
// silently return; it is executable on any host (no Xcode required), the same
// gate style the package already ships for native parity bugs
// (swift_sourceframe_kvc_test.dart, user_script_initializer_parity_test.dart).
//
// The scan asserts the iOS updateSettings branch shape, mirrored into the
// macOS `setSettings` funnel: every creation-time `initialSettings` and
// runtime `setSettings` call passes through it, and the InAppBrowser override
// delegates to super — so one branch covers platform views, the browser and
// headless webviews, on both creation and update paths (the iOS initial-load
// controllers reduce to the same calls).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Source text with comments removed, string literals PRESERVED, and all
/// whitespace runs collapsed to single spaces. Comment stripping handles
/// Swift block-comment nesting, line comments and triple-quoted strings
/// (ported from swift_sourceframe_kvc_test.dart's stripSwiftNonCode).
String stripCommentsKeepStrings(String source) {
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
      out.write('  ');
      i += 2;
      continue;
    }
    if (rest.startsWith('//')) {
      final end = source.indexOf('\n', i);
      i = end == -1 ? source.length : end;
      continue;
    }
    if (rest.startsWith('"""')) {
      final end = source.indexOf('"""', i + 3);
      out.write(source.substring(i, end == -1 ? source.length : end + 3));
      i = end == -1 ? source.length : end + 3;
      continue;
    }
    if (source[i] == '"') {
      // Regular string literal: keep content, skip escapes.
      out.write('"');
      var j = i + 1;
      while (j < source.length) {
        if (source[j] == r'\') {
          out.write(source.substring(j, j + 2));
          j += 2;
          continue;
        }
        out.write(source[j]);
        if (source[j] == '"') {
          j++;
          break;
        }
        j++;
      }
      i = j;
      continue;
    }
    out.write(source[i]);
    i++;
  }
  return out.toString().replaceAll(RegExp(r'\s+'), ' ');
}

/// Source text with string literal CONTENTS blanked (quotes kept) so brace
/// matching cannot be fooled by braces inside strings.
String blankStringContents(String source) {
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
      continue;
    }
    if (rest.startsWith('//')) {
      final end = source.indexOf('\n', i);
      i = end == -1 ? source.length : end;
      continue;
    }
    if (rest.startsWith('"""')) {
      final end = source.indexOf('"""', i + 3);
      out.write('""');
      i = end == -1 ? source.length : end + 3;
      continue;
    }
    if (source[i] == '"') {
      out.write('""');
      var j = i + 1;
      while (j < source.length) {
        if (source[j] == r'\') {
          j += 2;
          continue;
        }
        if (source[j] == '"') {
          j++;
          break;
        }
        j++;
      }
      i = j;
      continue;
    }
    out.write(source[i]);
    i++;
  }
  return out.toString();
}

/// Extracts the body of the function whose declaration matches [signature]
/// by brace matching on [source] (a comment-stripped, string-blanked text).
/// Returns null when the declaration is absent.
String? functionBody(String source, String signature) {
  final declStart = source.indexOf(signature);
  if (declStart == -1) return null;
  final openBrace = source.indexOf('{', declStart + signature.length);
  if (openBrace == -1) return null;
  var depth = 0;
  for (var i = openBrace; i < source.length; i++) {
    if (source[i] == '{') {
      depth++;
    } else if (source[i] == '}') {
      depth--;
      if (depth == 0) {
        return source.substring(openBrace + 1, i);
      }
    }
  }
  return null;
}

void main() {
  final macOSWebViewSwift = File(
    'macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/'
    'InAppWebView.swift',
  );
  final macOSSettingsSwift = File(
    'macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/'
    'InAppWebViewSettings.swift',
  );
  final iOSWebViewSwift = File(
    '../zikzak_inappwebview_ios/ios/zikzak_inappwebview_ios/Sources/'
    'zikzak_inappwebview_ios/InAppWebView/InAppWebView.swift',
  );

  group('native macOS contentBlockers consumption (issue #338)', () {
    late String macOSCode; // comments stripped, strings kept
    late String macOSBraces; // comments + string contents stripped
    late String settingsCode;
    late String iOSSetSettingsBody;

    setUpAll(() {
      // `flutter test` runs with the package root as the working directory.
      expect(
        macOSWebViewSwift.existsSync(),
        isTrue,
        reason:
            'InAppWebView.swift not found relative to package root '
            '(cwd: ${Directory.current.path})',
      );
      expect(settingsCode = macOSSettingsSwift.readAsStringSync(), isNotEmpty);
      expect(
        iOSWebViewSwift.existsSync(),
        isTrue,
        reason:
            'iOS InAppWebView.swift not found — parity cross-check '
            'requires the sibling package checkout',
      );
      macOSCode = stripCommentsKeepStrings(
        macOSWebViewSwift.readAsStringSync(),
      );
      macOSBraces = blankStringContents(macOSWebViewSwift.readAsStringSync());
      final iOSCode = stripCommentsKeepStrings(
        iOSWebViewSwift.readAsStringSync(),
      );
      // The issue calls it the "updateSettings branch"; in this tree the iOS
      // InAppWebView funnels both creation and runtime updates through
      // setSettings (same signature as macOS), and the contentBlockers block
      // lives there.
      iOSSetSettingsBody =
          functionBody(
            iOSCode,
            'func setSettings(newSettings: InAppWebViewSettings, newSettingsMap: [String: Any])',
          ) ??
          '';
    });

    test('InAppWebViewSettings still declares contentBlockers on macOS', () {
      // The bug report is about a decoded-but-unused setting; this test must
      // not be satisfiable by deleting the declaration instead of consuming
      // it. Mirrors the iOS declaration type exactly.
      expect(
        RegExp(
          r'var contentBlockers: \[\[String: \[String: Any\]\]\] = \[\]',
        ).hasMatch(settingsCode),
        isTrue,
        reason:
            'InAppWebViewSettings.contentBlockers '
            '([[String: [String: Any]]]) must stay declared on macOS — '
            'removing it would break the platform-interface contract, not '
            'fix #338',
      );
    });

    test('iOS setSettings branch (the parity target) still consumes '
        'contentBlockers', () {
      // If iOS ever stops being the reference implementation, this gate must
      // be re-derived — it must not silently rot into a trivially-true scan.
      expect(
        iOSSetSettingsBody,
        isNotNull,
        reason:
            'iOS setSettings must exist for the cross-check to mean '
            'anything',
      );
      expect(
        iOSSetSettingsBody,
        contains('newSettingsMap["contentBlockers"]'),
        reason:
            'iOS setSettings must react to the contentBlockers key '
            '(the reference branch for #338)',
      );
      expect(
        iOSSetSettingsBody,
        contains('compileContentRuleList('),
        reason: 'iOS setSettings must compile the rule list',
      );
      expect(
        iOSSetSettingsBody,
        contains('"ContentBlockingRules"'),
        reason:
            'iOS uses the ContentBlockingRules store identifier — macOS '
            'must share it',
      );
    });

    test('macOS setSettings reacts to the contentBlockers settings key — #338', () {
      final body = functionBody(
        macOSBraces,
        'func setSettings(newSettings: InAppWebViewSettings, newSettingsMap: [String: Any])',
      );
      expect(
        body,
        isNotNull,
        reason:
            'InAppWebView.setSettings must exist on macOS — it is the '
            'single funnel for creation-time initialSettings and runtime '
            'setSettings calls',
      );
      // Re-run the key check against the string-kept view (the blanked view
      // cannot see string literals).
      final keptBody = functionBody(
        macOSCode,
        'func setSettings(newSettings: InAppWebViewSettings, newSettingsMap: [String: Any])',
      );
      expect(
        keptBody,
        contains('newSettingsMap["contentBlockers"]'),
        reason:
            'setSettings must branch on the contentBlockers key like the iOS '
            'updateSettings branch does — the decoded setting was never '
            'consumed on macOS (#338)',
      );
    });

    test(
      'macOS setSettings clears stale rule lists before re-applying — #338',
      () {
        final keptBody = functionBody(
          macOSCode,
          'func setSettings(newSettings: InAppWebViewSettings, newSettingsMap: [String: Any])',
        )!;
        expect(
          keptBody,
          contains('removeAllContentRuleLists()'),
          reason:
              'Stale rule lists must be dropped whenever the contentBlockers '
              'key arrives (iOS parity: updateSettings calls '
              'userContentController.removeAllContentRuleLists() before '
              'compiling), otherwise runtime updates would stack lists',
        );
      },
    );

    test('macOS setSettings serializes and compiles the decoded blockers via '
        'WKContentRuleListStore — #338', () {
      final keptBody = functionBody(
        macOSCode,
        'func setSettings(newSettings: InAppWebViewSettings, newSettingsMap: [String: Any])',
      )!;
      expect(
        RegExp(
          r'JSONSerialization\.data\(\s*withJSONObject:\s*contentBlockers',
        ).hasMatch(keptBody),
        isTrue,
        reason:
            'The decoded [[String: [String: Any]]] blockers must be '
            'serialized to the WebKit JSON rule format before compilation',
      );
      expect(
        keptBody,
        contains('WKContentRuleListStore.default().compileContentRuleList('),
        reason:
            'The rule list must be compiled through '
            'WKContentRuleListStore.default().compileContentRuleList — the '
            'missing compilation IS bug #338',
      );
      expect(
        keptBody,
        contains('"ContentBlockingRules"'),
        reason:
            'The store identifier must match the iOS branch '
            '("ContentBlockingRules") so both platforms share one cached '
            'compilation',
      );
    });

    test('macOS setSettings adds the compiled list to the content controller — '
        '#338', () {
      final keptBody = functionBody(
        macOSCode,
        'func setSettings(newSettings: InAppWebViewSettings, newSettingsMap: [String: Any])',
      )!;
      expect(
        keptBody,
        contains('configuration.userContentController.add(contentRuleList'),
        reason:
            'A compiled-but-never-added rule list blocks nothing: the '
            'completion handler must add it to '
            'configuration.userContentController (iOS parity)',
      );
    });

    test('macOS setSettings skips compilation for an empty blockers list — '
        '#338', () {
      final keptBody = functionBody(
        macOSCode,
        'func setSettings(newSettings: InAppWebViewSettings, newSettingsMap: [String: Any])',
      )!;
      // Setting an empty list must CLEAR (removeAll runs on key presence)
      // without compiling an empty rule set — iOS guards with count > 0.
      expect(
        keptBody,
        contains('contentBlockers.count > 0'),
        reason:
            'The compile block must be guarded by contentBlockers.count > 0 '
            '(iOS parity): an empty list clears blocking instead of '
            'compiling an empty rule set',
      );
    });
  });
}
