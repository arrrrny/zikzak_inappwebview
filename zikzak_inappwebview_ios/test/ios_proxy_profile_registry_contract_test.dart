// Issue #410 source contract: the iOS ProxyController used to drop
// `ProxySettings.profileId` entirely — the Dart side never put it on the
// method channel and the native side never read it — so the resolved
// ProxyConfiguration only ever reached `WKWebsiteDataStore.default()`.
// Every WebView created with a `persistentStoreIdentifier` (the consumer's
// per-profile data stores) used a custom `WKWebsiteDataStore` that never
// received any proxy configuration and egressed directly: enabling the
// global/managed proxy on iOS routed no traffic for isolated profiles. The
// macOS port already implements the correct design (a static per-profile
// registry applied at data-store creation); these tests pin the iOS port to
// that same contract so the defect class cannot silently return.
//
// Like proxy_manager_tls_auth_contract_test, these tests encode the fix as
// source scans (Dart + Swift) so they are executable on any host (no Xcode
// required). They prove code *shape*, never that it compiles — the
// build-ios CI job remains the layer that type-checks these sources.
//
// NOTE ON FAILURES: these are PIN tests, not behavior tests. An assertion
// that fails after a semantic-preserving refactor (a renamed local, a map
// written as a literal) means the SPELLING moved, not that the fix broke.
// Re-read the scanned function before "fixing" the test by pasting the new
// spelling back — the behavior the pin exists for is the thing to preserve.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Strips line comments and (nested) block comments so comment prose that
/// mentions the same tokens cannot satisfy the contracts below. String
/// literal contents are KEPT (channel-arg keys like "profileId" are string
/// literals the contracts must be able to see). Ported from
/// proxy_manager_tls_auth_contract_test.
String stripSwiftComments(String source) {
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
        if (source[i] == '\n') {
          out.write('\n');
        }
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
      final close = source.indexOf('"""', i + 3);
      final end = close == -1 ? source.length : close + 3;
      out.write(source.substring(i, end));
      i = end;
      continue;
    }
    if (source[i] == '"') {
      var j = i + 1;
      while (j < source.length) {
        if (source[j] == r'\') {
          j += 2;
          continue;
        }
        if (source[j] == '"' || source[j] == '\n') break;
        j++;
      }
      final end = (j < source.length && source[j] == '"')
          ? j + 1
          : source.length;
      out.write(source.substring(i, end));
      i = end;
      continue;
    }
    out.write(source[i]);
    i++;
  }
  return out.toString();
}

/// Strips Dart line comments and block comments (same rationale as
/// [stripSwiftComments]; no triple-quoted literals exist in the scanned
/// file, doc comments `///` are line comments).
String stripDartComments(String source) => stripSwiftComments(source);

/// Returns the text between the `{` that opens the braces-delimited block at
/// or after [start] and its matching `}`. Empty when unterminated, so the
/// caller's index lookups fail loudly rather than silently passing.
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

/// Returns the text of the `switch` case starting at [start], up to the next
/// `case "` marker (or the end of the source). [functionBody] stops at the
/// first `{`, which for a case body is the first `if`/`do` block — not the
/// whole case, so it cannot prove anything about the branches after it.
String caseSpan(String code, int start) {
  final next = code.indexOf('case "', start + 1);
  return code.substring(start, next == -1 ? code.length : next);
}

/// Locates the iOS package root (`ios/zikzak_inappwebview_ios`) relative to
/// the current working directory, walking up so the test also resolves when
/// invoked from a subdirectory of the package (ported from
/// proxy_manager_tls_auth_contract_test).
Directory packageDir() {
  const marker = 'ios/zikzak_inappwebview_ios';
  var dir = Directory.current;
  for (var hop = 0; hop < 6; hop++) {
    final candidate = Directory('${dir.path}/$marker');
    if (candidate.existsSync()) return candidate;
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  fail('Could not locate $marker under or above ${Directory.current.path}');
}

String readStripped(String path) {
  final file = File(path);
  expect(file.existsSync(), isTrue, reason: 'missing: ${file.path}');
  return stripSwiftComments(file.readAsStringSync());
}

void main() {
  group('issue #410 source contract: profileId reaches the channel and the per-profile registry', () {
    late String dartController;
    late String proxyManager;
    late String inAppWebView;

    setUpAll(() {
      final pkg = packageDir().path;
      dartController = stripDartComments(
        File('$pkg/../../lib/src/proxy_controller.dart').readAsStringSync(),
      );
      proxyManager = readStripped(
        '$pkg/Sources/zikzak_inappwebview_ios/ProxyManager.swift',
      );
      inAppWebView = readStripped(
        '$pkg/Sources/zikzak_inappwebview_ios/InAppWebView/InAppWebView.swift',
      );
    });

    test(
      'Dart IosProxyController.setProxyOverride forwards settings.profileId',
      () {
        final start = dartController.indexOf('setProxyOverride');
        expect(
          start,
          greaterThanOrEqualTo(0),
          reason: 'setProxyOverride not found',
        );
        final bodyStart = dartController.indexOf("async", start);
        final body = functionBody(dartController, bodyStart);
        expect(
          body,
          contains("args['profileId'] = settings.profileId"),
          reason: 'the profileId must cross the method channel — without it the native registry can never be keyed (issue #410)',
        );
      },
    );

    test('Dart IosProxyController.clearProxyOverride forwards the profileId argument', () {
      final start = dartController.indexOf('clearProxyOverride');
      expect(
        start,
        greaterThanOrEqualTo(0),
        reason: 'clearProxyOverride not found',
      );
      final bodyStart = dartController.indexOf("async", start);
      final body = functionBody(dartController, bodyStart);
      expect(
        body,
        contains("args['profileId'] = profileId"),
        reason: 'a per-profile clear must reach the native registry, not just wipe the default store (issue #410)',
      );
      expect(
        body,
        contains("invokeMethod('clearProxyOverride', args)"),
        reason: 'the argument-less channel call is the old default-store-only shape (issue #410)',
      );
    });

    test('Swift ProxyManager keeps the per-profile registry and honors profileId on set', () {
      expect(
        proxyManager,
        contains('static var profileProxies: [String: ProxyConfiguration]'),
        reason: 'the registry is the macOS-proven design the iOS port must mirror (issue #410)',
      );
      expect(
        proxyManager,
        contains('arguments?["profileId"] as? String'),
        reason:
            'the native side must read the profileId the Dart controller sends',
      );
      expect(
        proxyManager,
        contains('ProxyManager.profileProxies[pid] = proxyConfiguration'),
        reason: 'a setProxyOverride with a profileId must store the configuration for the WebView factory',
      );
    });

    test(
      'Swift ProxyManager scopes clears to the profile and exposes applyProxy',
      () {
        final clearStart = proxyManager.indexOf('case "clearProxyOverride"');
        expect(
          clearStart,
          greaterThanOrEqualTo(0),
          reason: 'clearProxyOverride case not found',
        );
        final clearBody = caseSpan(proxyManager, clearStart);
        expect(
          clearBody,
          contains('profileProxies.removeValue(forKey:'),
          reason: 'clearing one profile must not wipe the other profiles\' routes (issue #410)',
        );
        expect(
          clearBody,
          contains('ProxyManager.profileProxies.removeAll()'),
          reason: 'a global clear (no profileId) must wipe the whole registry (issue #410)',
        );
        expect(
          proxyManager,
          contains(
            'static func applyProxy(forIdentifier identifier: String, to dataStore: WKWebsiteDataStore)',
          ),
          reason: 'the WebView factory needs the macOS-style application seam (issue #410)',
        );
        expect(
          proxyManager,
          contains('dataStore.proxyConfigurations = [config]'),
          reason: 'applyProxy must write the stored configuration onto the custom data store',
        );
      },
    );

    test('a per-profile set never writes the shared store', () {
      final setStart = proxyManager.indexOf('case "setProxyOverride"');
      expect(
        setStart,
        greaterThanOrEqualTo(0),
        reason: 'setProxyOverride case not found',
      );
      final setBody = caseSpan(proxyManager, setStart);
      expect(
        setBody,
        contains(
          'WKWebsiteDataStore.default().proxyConfigurations = [proxyConfiguration]',
        ),
        reason: 'the identifier-less (shared) set is the only one that may write the default store',
      );
      // The default-store write must sit in the ELSE branch of the profileId
      // test, never on the common path: an unconditional write is exactly the
      // leak this pins against.
      final elseIndex = setBody.indexOf('} else {');
      expect(
        elseIndex,
        greaterThanOrEqualTo(0),
        reason: 'the shared/default branch is missing',
      );
      expect(
        setBody.indexOf('WKWebsiteDataStore.default().proxyConfigurations'),
        greaterThan(elseIndex),
        reason: 'a per-profile set must not stamp its route onto the shared store (issue #410)',
      );
    });

    test('registry keys are canonicalised the way persistentUUID trims', () {
      expect(
        proxyManager,
        contains('trimmingCharacters(in: .whitespacesAndNewlines)'),
        reason: 'a padded profileId must address the same entry as a padded persistentStoreIdentifier',
      );
      final applyStart = proxyManager.indexOf(
        'static func applyProxy(forIdentifier',
      );
      expect(
        applyStart,
        greaterThanOrEqualTo(0),
        reason: 'applyProxy not found',
      );
      final applyBody = functionBody(proxyManager, applyStart);
      expect(
        applyBody,
        contains('registryKey('),
        reason: 'the lookup key must go through the same canonicalisation as the store path',
      );
    });

    test('live stores of a profile receive a new override immediately', () {
      expect(
        proxyManager,
        contains('private static var liveStores'),
        reason: 'a toggle must reach data stores that already exist, not only future ones (issue #410)',
      );
      final applyStart = proxyManager.indexOf(
        'static func applyProxy(forIdentifier',
      );
      final applyBody = functionBody(proxyManager, applyStart);
      expect(
        applyBody,
        contains('registerLiveStore('),
        reason: 'applyProxy is the only place a store is created for a profile — it must register it',
      );
      final setStart = proxyManager.indexOf('case "setProxyOverride"');
      final setBody = caseSpan(proxyManager, setStart);
      expect(
        setBody,
        contains('applyProxyToLiveStores('),
        reason: 'setProxyOverride must push the configuration onto the profile\'s live stores',
      );
    });

    test(
      'the persistent-store creation site applies the registry to the store',
      () {
        expect(
          inAppWebView,
          contains('ProxyManager.applyProxy(forIdentifier: id, to: store)'),
          reason: 'a WebView created with a persistentStoreIdentifier must receive its profile\'s proxy at data-store creation — this is the exact line that was missing (issue #410)',
        );
        expect(
          inAppWebView,
          contains('configuration.websiteDataStore = store'),
          reason:
              'the proxied store must be the one assigned to the configuration',
        );
      },
    );
  });
}
