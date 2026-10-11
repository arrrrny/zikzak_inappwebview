// Bug #349 regression contract: on iOS, `InAppWebViewSettings.contentBlockers`
// silently blocked the INITIAL navigation. `makeInitialLoad` (platform views)
// and `InAppBrowserWebViewController.viewDidLoad` (InAppBrowser) issued the
// first navigation ONLY from inside the `WKContentRuleListStore
// .compileContentRuleList` completion handler, so the initial load was held
// hostage to WebKit's compilation callback:
//
//   - a compilation error printed and `return`ed — the initial navigation was
//     never issued (blank page, no onLoadStart, no onLoadError, no logs);
//   - a `(nil, nil)` completion crashed on `contentRuleList!`;
//   - the fixed persistent-store identifier "ContentBlockingRules" recompiled
//     across launches/webviews could leave the completion undelivered, which
//     silently orphaned the held initial load forever.
//
// The fix mirrors the macOS #338 machinery one-to-one: a single
// `applyContentBlockers` funnel (stale-completion token, guarded add,
// serialized compilations), a `loadAfterContentRuleLists` gate that holds the
// initial navigation until the compilation SETTLES (success OR error — the
// navigation can never be orphaned by the compile outcome), a content-derived
// SHA-256 store identifier so a distinct ruleset never collides with a stale
// store entry, and a diagnostic log in `URLRequest(fromPluginMap:)` for the
// about:blank fallback the issue calls out as the second path to the same
// invisible-blank symptom.
//
// This test encodes that contract as a source scan so the bug class cannot
// silently return; it is executable on any host (no Xcode required), the same
// gate style the package already ships for native parity bugs
// (swift_platform_view_clipping_test.dart, swift_availability_usage_test.dart).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Source text with comments removed, string literals PRESERVED, and all
/// whitespace runs collapsed to single spaces. Comment stripping handles
/// Swift block-comment nesting, line comments and triple-quoted strings.
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

/// Extracts the body of the function whose declaration matches [signature]
/// by brace matching on [source] (a comment-stripped, whitespace-collapsed
/// text). Returns null when the declaration is absent. String literal
/// contents are preserved by [stripCommentsKeepStrings]; braces cannot occur
/// inside the literals this fix asserts on.
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
  final webViewSwift = File(
    'ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/'
    'InAppWebView/InAppWebView.swift',
  );
  final controllerSwift = File(
    'ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/'
    'InAppWebView/FlutterWebViewController.swift',
  );
  final browserSwift = File(
    'ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/'
    'InAppBrowser/InAppBrowserWebViewController.swift',
  );
  final urlRequestSwift = File(
    'ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/'
    'Types/URLRequest.swift',
  );
  final settingsSwift = File(
    'ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/'
    'InAppWebView/InAppWebViewSettings.swift',
  );

  group('iOS contentBlockers initial-load safety (issue #349)', () {
    late String webViewCode; // comments stripped, strings kept
    late String controllerCode;
    late String browserCode;
    late String urlRequestCode;
    late String settingsCode;

    setUpAll(() {
      // `flutter test` runs with the package root as the working directory.
      expect(
        webViewSwift.existsSync(),
        isTrue,
        reason:
            'InAppWebView.swift not found relative to package root '
            '(cwd: ${Directory.current.path})',
      );
      webViewCode = stripCommentsKeepStrings(webViewSwift.readAsStringSync());
      controllerCode = stripCommentsKeepStrings(
        controllerSwift.readAsStringSync(),
      );
      browserCode = stripCommentsKeepStrings(browserSwift.readAsStringSync());
      urlRequestCode = stripCommentsKeepStrings(
        urlRequestSwift.readAsStringSync(),
      );
      settingsCode = stripCommentsKeepStrings(settingsSwift.readAsStringSync());
    });

    test('B1: makeInitialLoad holds the initial navigation only until the '
        'content-rule compilation settles — #349', () {
      final body = functionBody(
        controllerCode,
        'func makeInitialLoad(params: NSDictionary)',
      );
      expect(
        body,
        isNotNull,
        reason:
            'FlutterWebViewController.makeInitialLoad must exist — it '
            'issues the platform-view initial load',
      );
      expect(
        body!,
        contains('loadAfterContentRuleLists'),
        reason:
            'With contentBlockers set, the initial navigation must be routed '
            'through loadAfterContentRuleLists so it fires when the '
            'compilation SETTLES — the old code issued it only from inside '
            'the compileContentRuleList completion, so a compile error or an '
            'undelivered completion silently orphaned the first navigation '
            '(blank page, no onLoadStart/onLoadError) — bug #349',
      );
    });

    test('B2: makeInitialLoad keeps the no-blockers path intact — #349', () {
      final body = functionBody(
        controllerCode,
        'func makeInitialLoad(params: NSDictionary)',
      )!;
      // The no-blockers path must keep clearing stale rule lists and loading
      // directly (no gating) — this gate must not be satisfiable by deleting
      // the fast path.
      expect(
        body,
        contains('removeAllContentRuleLists()'),
        reason:
            'makeInitialLoad must still clear stale rule lists for the '
            'empty/absent contentBlockers case',
      );
      // Whitespace-tolerant: the Swift source line-wraps the call. The
      // character class before `load(` excludes `self.`/`self?.` receivers so
      // only the direct implicit-self (ungated) call satisfies this gate.
      expect(
        RegExp(
          r'[^?.\w]load\(\s*initialUrlRequest:\s*initialUrlRequest,\s*'
          r'initialFile:\s*initialFile,\s*initialData:\s*initialData',
        ).hasMatch(body),
        isTrue,
        reason:
            'makeInitialLoad must still load directly (ungated) when no '
            'contentBlockers are set — #349 must not slow down or rewire the '
            'null-contentBlockers path the issue reports as working',
      );
    });

    test('B3: makeInitialLoad compiles through the applyContentBlockers '
        'funnel, not an inline compile — #349', () {
      final body = functionBody(
        controllerCode,
        'func makeInitialLoad(params: NSDictionary)',
      )!;
      expect(
        body,
        contains('applyContentBlockers('),
        reason:
            'makeInitialLoad must delegate compilation to the shared '
            'applyContentBlockers funnel (token-guarded, main-thread '
            'completion) instead of an inline compile — the inline copy '
            'carried the contentRuleList! force unwrap and the error-path '
            'load drop of #349',
      );
      expect(
        body,
        isNot(contains('compileContentRuleList(')),
        reason:
            'The inline WKContentRuleListStore.compileContentRuleList call '
            'must move into the applyContentBlockers funnel; a second inline '
            'compile site would bypass the token guard and the pending-load '
            'settle logic (#349)',
      );
      expect(
        body,
        isNot(contains('contentRuleList!')),
        reason:
            'A (nil, nil) completion must not crash on a force-unwrapped '
            'contentRuleList (#349)',
      );
    });

    test('B4: applyContentBlockers funnel exists with the macOS #338 shape '
        '— #349', () {
      final body = functionBody(
        webViewCode,
        'func applyContentBlockers(_ contentBlockers: [[String: [String: Any]]])',
      );
      expect(
        body,
        isNotNull,
        reason:
            'InAppWebView.applyContentBlockers must exist on iOS — the '
            'single compile funnel for makeInitialLoad, setSettings and the '
            'InAppBrowser, mirroring the macOS #338 machinery',
      );
      expect(
        body!,
        contains('removeAllContentRuleLists()'),
        reason:
            'Stale rule lists must be dropped whenever the funnel runs, '
            'otherwise runtime updates would stack lists',
      );
      expect(
        body,
        contains('guard !contentBlockers.isEmpty'),
        reason:
            'An empty list must clear blocking without compiling an empty '
            'rule set (macOS #338 parity)',
      );
      expect(
        body,
        contains('JSONSerialization'),
        reason:
            'The decoded blockers must be serialized to the WebKit JSON rule '
            'format before compilation',
      );
      expect(
        body,
        contains('WKContentRuleListStore.default().compileContentRuleList('),
        reason:
            'The rule list must be compiled through '
            'WKContentRuleListStore.default().compileContentRuleList',
      );
      expect(
        body,
        contains('userContentController.add(contentRuleList'),
        reason:
            'A compiled-but-never-added rule list blocks nothing: the '
            'completion must add it to configuration.userContentController',
      );
      expect(
        body,
        isNot(contains('contentRuleList!')),
        reason:
            'The compiled list must be added through an optional bind, never '
            'a force unwrap — WebKit can deliver a (nil, nil) completion '
            '(#349)',
      );
      expect(
        body,
        contains('contentRuleListIdentifier(forRules:'),
        reason:
            'The store identifier must be derived from the rule content via '
            'the SHA-256 helper (see B6), not a fixed literal — #349',
      );
    });

    test('B5: the compile completion settles into the pending load on every '
        'outcome and is token-guarded — #349', () {
      final body = functionBody(
        webViewCode,
        'func applyContentBlockers(_ contentBlockers: [[String: [String: Any]]])',
      )!;
      final idxToken = body.indexOf(
        'token == self.contentRuleListCompileToken',
      );
      final idxFlagReset = body.indexOf('isCompilingContentRuleLists = false');
      final idxErrorBranch = body.indexOf('if let error = error');
      final idxAdd = body.indexOf('userContentController.add(contentRuleList');
      final idxPendingFire = body.indexOf('pendingContentRuleListLoad = nil');
      expect(
        idxToken,
        isNot(equals(-1)),
        reason:
            'A late completion from a superseded compilation must be dropped '
            'by the compile token (macOS #338 parity), or an older rule list '
            'would be re-added after a newer update removed it',
      );
      expect(
        idxFlagReset,
        isNot(equals(-1)),
        reason:
            'isCompilingContentRuleLists must be reset when the compilation '
            'settles, or every later loadAfterContentRuleLists call would '
            'hang',
      );
      expect(
        idxPendingFire,
        isNot(equals(-1)),
        reason:
            'The pending initial load must be fired when the compilation '
            'settles',
      );
      expect(
        idxToken,
        lessThan(idxFlagReset),
        reason: 'The stale-completion guard must run before the flag reset',
      );
      expect(
        idxFlagReset,
        lessThan(idxErrorBranch),
        reason:
            'The flag must reset BEFORE the error branch: an error '
            'outcome still settles the compilation',
      );
      expect(
        idxErrorBranch,
        lessThan(idxAdd),
        reason: 'The success path adds the compiled list',
      );
      expect(
        idxAdd,
        lessThan(idxPendingFire),
        reason:
            'The pending initial load fires last, on BOTH the success and '
            'the error outcome',
      );
      // The error branch must not early-return past the pending-load fire.
      final betweenErrorAndFire = body.substring(
        idxErrorBranch,
        idxPendingFire,
      );
      expect(
        betweenErrorAndFire.contains('return'),
        isFalse,
        reason:
            'The compile completion must NOT early-return on error before '
            'firing the pending load — that early return is exactly the '
            '#349 load drop (blank page, no logs)',
      );
    });

    test('B6: the fixed "ContentBlockingRules" store identifier is gone from '
        'the iOS sources — #349', () {
      // The fixed identifier is recompiled across app launches and webviews
      // against the persistent WKContentRuleListStore; WebKit can fail to
      // deliver that recompilation's completion, which silently orphaned the
      // initial load held on it. iOS now derives the identifier from the
      // rule content; the literal must be gone from every iOS compile site.
      expect(
        webViewCode.contains('"ContentBlockingRules"'),
        isFalse,
        reason:
            'InAppWebView.swift must no longer compile under the fixed '
            '"ContentBlockingRules" identifier (#349)',
      );
      expect(
        controllerCode.contains('"ContentBlockingRules"'),
        isFalse,
        reason:
            'FlutterWebViewController.swift must no longer compile under the '
            'fixed "ContentBlockingRules" identifier (#349)',
      );
      expect(
        browserCode.contains('"ContentBlockingRules"'),
        isFalse,
        reason:
            'InAppBrowserWebViewController.swift must no longer compile under '
            'the fixed "ContentBlockingRules" identifier (#349)',
      );
      expect(
        webViewCode.contains('contentRuleListIdentifier(forRules:') ||
            webViewCode.contains('SHA256.hash(data:'),
        isTrue,
        reason:
            'The replacement identifier must be derived from the compiled '
            'rule content (SHA-256 hex) so identical rulesets get a '
            'deterministic store hit and distinct rulesets never collide '
            'with a stale store entry',
      );
    });

    test('B7: setSettings funnels the contentBlockers key through '
        'applyContentBlockers — #349', () {
      final body = functionBody(
        webViewCode,
        'func setSettings(newSettings: InAppWebViewSettings, newSettingsMap: [String: Any])',
      );
      expect(
        body,
        isNotNull,
        reason:
            'InAppWebView.setSettings must exist — it is the funnel for '
            'runtime settings updates',
      );
      expect(
        body!,
        contains('newSettingsMap["contentBlockers"]'),
        reason:
            'setSettings must still react to the contentBlockers settings '
            'key',
      );
      expect(
        body,
        contains('applyContentBlockers('),
        reason:
            'setSettings must delegate the key to applyContentBlockers — its '
            'inline copy carried the same contentRuleList! force unwrap and '
            'fixed-identifier recompile hazards fixed for the initial load '
            'in #349',
      );
      expect(
        body,
        isNot(contains('compileContentRuleList(')),
        reason:
            'The inline compile block must move into the shared funnel; a '
            'duplicate compile site here would bypass the token guard and '
            'the pending-load settle logic (#349)',
      );
    });

    test('B8: the InAppBrowser initial load settles through the same '
        'funnel — #349', () {
      final body = functionBody(browserCode, 'func viewDidLoad()');
      expect(
        body,
        isNotNull,
        reason:
            'InAppBrowserWebViewController.viewDidLoad must exist — it '
            'issues the InAppBrowser initial load',
      );
      expect(
        body!,
        contains('applyContentBlockers('),
        reason:
            'The InAppBrowser viewDidLoad contentBlockers branch must use the '
            'shared applyContentBlockers funnel — its inline copy had the '
            'identical load-hostage-to-completion defect as makeInitialLoad '
            '(#349)',
      );
      expect(
        body,
        contains('loadAfterContentRuleLists'),
        reason:
            'The InAppBrowser initial navigation must fire when the '
            'compilation settles, not only on compile success (#349)',
      );
      expect(
        body,
        isNot(contains('contentRuleList!')),
        reason:
            'A (nil, nil) completion must not crash the InAppBrowser on a '
            'force-unwrapped contentRuleList (#349)',
      );
      expect(
        body,
        contains('initLoad()'),
        reason:
            'The InAppBrowser no-blockers path must keep loading directly '
            'through initLoad()',
      );
    });

    test('B9: URLRequest(fromPluginMap:) logs the rejected url before the '
        'about:blank fallback — #349', () {
      final body = functionBody(
        urlRequestCode,
        'init(fromPluginMap: [String:Any?])',
      );
      expect(
        body,
        isNotNull,
        reason: 'URLRequest.init(fromPluginMap:) must exist',
      );
      expect(
        body!,
        contains('self.init(url: url)'),
        reason:
            'The parse-success path must be preserved (the issue rules out '
            'URL parsing as the #349 trigger — do not regress it)',
      );
      expect(
        body,
        contains('about:blank'),
        reason: 'The fallback target must stay about:blank for compatibility',
      );
      expect(
        body,
        contains('rejected unparsable url'),
        reason:
            'The fallback must LOG the input it rejected — the issue flags '
            'this silent fallback as a second path to the same '
            'invisible-blank symptom and asks for the diagnostic',
      );
    });

    test('B10: the contentBlockers setting is still declared — #349', () {
      // The bug report is about how the setting is applied; this test must
      // not be satisfiable by deleting the declaration instead.
      expect(
        RegExp(
          r'var contentBlockers: \[\[String: \[String: Any\]\]\] = \[\]',
        ).hasMatch(settingsCode),
        isTrue,
        reason:
            'InAppWebViewSettings.contentBlockers ([[String: [String: Any]]]) '
            'must stay declared on iOS — removing it would break the '
            'platform-interface contract, not fix #349',
      );
    });
  });
}
