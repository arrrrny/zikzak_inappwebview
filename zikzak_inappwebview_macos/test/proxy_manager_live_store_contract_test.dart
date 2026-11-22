// Issue arrrrny/zuraffa_browser_backlog#24 source contract: a proxy change
// never reaches an already-created per-profile data store on macOS.
//
// `setProxyOverride` stored the resolved configuration in `profileProxies`
// (the registry the WebView factory reads at data-store CREATION) and wrote
// `WKWebsiteDataStore.default()`. A per-profile WebView owns a custom
// `WKWebsiteDataStore(forIdentifier:)` that is created once, at WebView init,
// so an override that arrives later — the user editing a profile's proxy in
// the browser's settings — was recorded for future stores and never applied
// to the store in use. WebKit only routes NEW loads through
// `proxyConfigurations` written after the store exists, so the user-visible
// symptom was "the proxy change is not immediate": the open tabs kept their
// old route until the profile's WebViews were recreated.
//
// The iOS port already carries the correct design (issue #410): a weak
// `liveStores` registry, populated by `applyProxy(forIdentifier:to:)` —
// the only place a profile's store is created — and rewritten by
// `setProxyOverride` / the profile-scoped `clearProxyOverride`. These tests
// pin the macOS port to that same contract so the defect class cannot
// silently return.
//
// Like proxy_manager_tls_auth_contract_test, these tests encode the fix as
// source scans (Swift) so they are executable on any host (no Xcode
// required). They prove code *shape*, never that it compiles — the
// build-macos CI job remains the layer that type-checks these sources (see
// AGENTS.md).
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
/// `case "` marker, the enclosing switch's `default:`, or the end of the
/// source — whichever comes first. [functionBody] stops at the first `{`,
/// which for a case body is the first `if`/`do` block — not the whole case, so
/// it cannot prove anything about the branches after it. Bounding at `default:`
/// as well as at the next `case "` is what keeps a LAST-case span (no
/// following `case "`) from swallowing the helper functions below the switch,
/// whose identical tokens would otherwise satisfy every assertion.
String caseSpan(String code, int start) {
  final next = code.indexOf('case "', start + 1);
  final def = code.indexOf('default:', start + 1);
  var end = code.length;
  if (next != -1 && next < end) end = next;
  if (def != -1 && def < end) end = def;
  return code.substring(start, end);
}

/// Locates the macOS package root (`macos/zikzak_inappwebview_macos`)
/// relative to the current working directory, walking up so the test also
/// resolves when invoked from a subdirectory of the package (ported from
/// proxy_manager_tls_auth_contract_test).
Directory packageDir() {
  const marker = 'macos/zikzak_inappwebview_macos';
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
  group(
    'backlog #24 source contract: a proxy change reaches live per-profile stores',
    () {
      late String proxyManager;
      late String inAppWebView;

      setUpAll(() {
        final pkg = packageDir().path;
        proxyManager = readStripped(
          '$pkg/Sources/zikzak_inappwebview_macos/ProxyManager.swift',
        );
        inAppWebView = readStripped(
          '$pkg/Sources/zikzak_inappwebview_macos/InAppWebView.swift',
        );
      });

      test('ProxyManager keeps a weak registry of the live per-profile stores', () {
        expect(
          proxyManager,
          matches(
            RegExp(
              r'private static var liveStores:?\s*\[String: NSHashTable<WKWebsiteDataStore>\]',
            ),
          ),
          reason:
              'without a live-store registry a toggle can only reach stores created after it (backlog #24)',
        );
      });

      test('registry keys are canonicalised the way persistentUUID trims', () {
        expect(
          proxyManager,
          contains('trimmingCharacters(in: .whitespacesAndNewlines)'),
          reason:
              'a padded profileId must address the same entry as a padded persistentStoreIdentifier',
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
          reason:
              'the lookup key must go through the same canonicalisation as the store path',
        );
      });

      test('applyProxy registers the store it configures as live', () {
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
          contains('registerLiveStore('),
          reason:
              'applyProxy is the only place a store is created for a profile — it must register it, or a later setProxyOverride cannot find it (backlog #24)',
        );
        expect(
          applyBody,
          contains('dataStore.proxyConfigurations = [config]'),
          reason:
              'applyProxy must still write the stored configuration onto the store it is given',
        );
      });

      test('a per-profile set pushes the configuration onto the live stores', () {
        final setStart = proxyManager.indexOf('case "setProxyOverride"');
        expect(
          setStart,
          greaterThanOrEqualTo(0),
          reason: 'setProxyOverride case not found',
        );
        final setBody = caseSpan(proxyManager, setStart);
        expect(
          setBody,
          contains('applyProxyToLiveStores('),
          reason:
              'setProxyOverride must push the configuration onto the profile\'s live stores — recording it only in the registry leaves every open tab on the old route (backlog #24)',
        );
      });

      test('a per-profile set never stamps its route onto the shared store', () {
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
          reason:
              'the identifier-less (shared) set is the only one that may write the default store',
        );
        // The default-store write must sit in the ELSE branch of the profileId
        // test, never on the common path: an unconditional write is exactly the
        // cross-profile leak this pins against (issue #410 / bug #159).
        final elseIndex = setBody.indexOf('} else {');
        expect(
          elseIndex,
          greaterThanOrEqualTo(0),
          reason: 'the shared/default branch is missing',
        );
        expect(
          setBody.indexOf('WKWebsiteDataStore.default().proxyConfigurations'),
          greaterThan(elseIndex),
          reason:
              'a per-profile set must not stamp its route onto the shared store (issue #410)',
        );
      });

      test('a profile-scoped clear releases that profile\'s live stores', () {
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
          reason:
              'clearing one profile must not wipe the other profiles\' routes (issue #410)',
        );
        expect(
          clearBody,
          contains('ProxyManager.profileProxies.removeAll()'),
          reason:
              'a global clear (no profileId) must wipe the whole registry (issue #410)',
        );
        // Assert the scoped live-store write by a shape only the clear
        // produces. `liveStores[key]?.allObjects` addresses one profile's
        // table; the set path goes through applyProxyToLiveStores and the
        // global branch iterates liveStores.values, so neither satisfies
        // this. A bare `contains('liveStores')` would also be satisfied by
        // the helper functions below the switch — which is exactly why the
        // earlier pin could not fail (see the caseSpan bound above).
        expect(
          clearBody,
          contains('liveStores[key]?.allObjects'),
          reason:
              'the scoped clear must reach THIS profile\'s live stores and keep '
              'its registry entry — a cleared proxy left on a running store is '
              'the same non-immediate bug in reverse, and dropping the entry '
              'orphans the store so the next set writes nothing (backlog #24)',
        );
        expect(
          clearBody,
          contains('proxyConfigurations = []'),
          reason:
              'clearing a profile must write an empty configuration onto the stores it just released',
        );
      });

      test('a global clear wipes every live store', () {
        final clearStart = proxyManager.indexOf('case "clearProxyOverride"');
        expect(
          clearStart,
          greaterThanOrEqualTo(0),
          reason: 'clearProxyOverride case not found',
        );
        final clearBody = caseSpan(proxyManager, clearStart);
        expect(
          clearBody,
          contains('liveStores.values'),
          reason:
              'a bare clear (no profileId) must reach every registered store, not only the default one (backlog #24)',
        );
        // Tie the prune assertion to its receiver. A bare `contains('removeAll()')`
        // is also satisfied by profileProxies.removeAll() in the scoped branch,
        // so deleting liveStores.removeAll() alone would leave this green — the
        // empty-table pruning its reason describes would then be pinned by
        // nothing. Scan from the profileProxies prune forward: the liveStores
        // prune must follow it in the global branch.
        final globalStart = clearBody.indexOf(
          'ProxyManager.profileProxies.removeAll()',
        );
        expect(
          globalStart,
          greaterThanOrEqualTo(0),
          reason: 'the global registry prune is missing',
        );
        expect(
          clearBody.substring(globalStart),
          contains('liveStores.removeAll()'),
          reason:
              'the global clear must prune the registry it just released — a weak table that is never pruned is a leak of empty entries',
        );
      });

      test('the persistent-store creation site registers the store', () {
        expect(
          inAppWebView,
          contains('ProxyManager.applyProxy(forIdentifier: id, to: store)'),
          reason:
              'a WebView created with a persistentStoreIdentifier must receive its profile\'s proxy at data-store creation',
        );
        expect(
          inAppWebView,
          contains('configuration.websiteDataStore = store'),
          reason:
              'the proxied store must be the one assigned to the configuration',
        );
      });
    },
  );
}