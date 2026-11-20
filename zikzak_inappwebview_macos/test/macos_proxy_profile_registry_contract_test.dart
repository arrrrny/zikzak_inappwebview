// Issue zuraffa_browser#1066 source contract: the macOS ProxyManager only
// ever applied a per-profile proxy at data-store CREATION — a registry entry
// written by `setProxyOverride` reached stores made afterwards, so the
// running `WKWebsiteDataStore` of an isolated profile never learned a new
// route and its already-open tabs kept egressing on the old one no matter how
// many times the app reloaded them (the "proxy applies only to new tabs"
// defect). The iOS port fixed the same shape in zikzak_inappwebview#410 with
// a weak `liveStores` registry: registered in `applyProxy(forIdentifier:to:)`
// when a store is created, pushed by `setProxyOverride`, cleared
// symmetrically by `clearProxyOverride`. The macOS port now carries that
// design too; these tests pin it so the parity cannot silently regress.
//
// They also pin the shared-store scoping: a PER-PROFILE set must not write
// `WKWebsiteDataStore.default().proxyConfigurations` — that leak is exactly
// why the consumer's proxy planner (bug #159) had to re-assert the shared
// store after every per-profile command.
//
// Like proxy_manager_tls_auth_contract_test, these tests encode the fix as
// source scans (Dart + Swift) so they are executable on any host (no Xcode
// required). They prove code *shape*, never that it compiles — the
// build-macos CI job remains the layer that type-checks these sources (see
// AGENTS.md). This file mirrors
// zikzak_inappwebview_ios/test/ios_proxy_profile_registry_contract_test.dart
// so both platform packages carry the identical contract.
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
    'issue zuraffa_browser#1066 source contract: live stores and shared-store scoping (iOS #410 parity)',
    () {
      late String dartController;
      late String proxyManager;
      late String inAppWebView;

      setUpAll(() {
        final pkg = packageDir().path;
        dartController = stripDartComments(
          File('$pkg/../../lib/src/proxy_controller.dart').readAsStringSync(),
        );
        proxyManager = readStripped(
          '$pkg/Sources/zikzak_inappwebview_macos/ProxyManager.swift',
        );
        inAppWebView = readStripped(
          '$pkg/Sources/zikzak_inappwebview_macos/InAppWebView.swift',
        );
      });

      test('Dart controller forwards settings.profileId on set', () {
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
          reason:
              'the profileId must cross the method channel — without it the native registry can never be keyed (issue zuraffa_browser#1066)',
        );
      });

      test('Dart controller forwards the profileId argument on clear', () {
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
          reason:
              'a per-profile clear must reach the native registry, not just wipe the default store (issue zuraffa_browser#1066)',
        );
        expect(
          body,
          contains("invokeMethod('clearProxyOverride', args)"),
          reason:
              'the argument-less channel call is the old default-store-only shape (issue zuraffa_browser#1066)',
        );
      });

      test('Swift ProxyManager keeps the per-profile registry and honors profileId on set', () {
        expect(
          proxyManager,
          contains('static var profileProxies: [String: ProxyConfiguration]'),
          reason:
              'the registry is the #410 design — the WebView factory applies it at data-store creation',
        );
        expect(
          proxyManager,
          contains('arguments?["profileId"] as? String'),
          reason: 'the native side must read the profileId the Dart controller sends',
        );
        expect(
          proxyManager,
          contains('ProxyManager.profileProxies[pid] = proxyConfiguration'),
          reason:
              'a setProxyOverride with a profileId must store the configuration for the WebView factory',
        );
      });

      test('live stores of a profile receive a new override immediately', () {
        expect(
          proxyManager,
          contains('private static var liveStores'),
          reason:
              'a toggle must reach data stores that already exist, not only future ones — the creation-time apply alone is the "proxy applies only to new tabs" defect (issue zuraffa_browser#1066; iOS parity zikzak_inappwebview#410)',
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
          contains('registerLiveStore('),
          reason:
              'applyProxy is the only place a store is created for a profile — it must register it as live (iOS #410 design)',
        );
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
              'setProxyOverride must push the configuration onto the profile\'s live stores — without it an isolated profile\'s running store never learns the new route (issue zuraffa_browser#1066)',
        );
      });

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
          reason:
              'the identifier-less (shared) set is the only one that may write the default store',
        );
        // The default-store write must sit in the ELSE branch of the profileId
        // test, never on the common path: an unconditional write is exactly
        // the cross-profile leak the consumer's proxy planner compensates for
        // (bug #159's class).
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
              'a per-profile set must not stamp its route onto the shared store (issue zuraffa_browser#1066, bug #159)',
        );
      });

      test('clears are symmetric: scoped clears wipe the profile, a bare clear wipes everything', () {
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
              'clearing one profile must not wipe the other profiles\' routes (iOS #410 design)',
        );
        expect(
          clearBody,
          contains('ProxyManager.profileProxies.removeAll()'),
          reason: 'a global clear (no profileId) must wipe the whole registry (iOS #410 design)',
        );
        expect(
          clearBody,
          contains('liveStores'),
          reason:
              'a cleared route must not survive in the profile\'s running stores — the same staleness on the way out (issue zuraffa_browser#1066)',
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
        final applyBody = functionBody(proxyManager, applyStart);
        expect(
          applyBody,
          contains('registryKey('),
          reason:
              'the lookup key must go through the same canonicalisation as the store path',
        );
      });

      test(
        'the persistent-store creation site applies the registry to the store',
        () {
          expect(
            inAppWebView,
            contains('ProxyManager.applyProxy(forIdentifier: id, to: store)'),
            reason:
                'a WebView created with a persistentStoreIdentifier must receive its profile\'s proxy at data-store creation — the fresh-store path the live push complements',
          );
          expect(
            inAppWebView,
            contains('configuration.websiteDataStore = store'),
            reason:
                'the proxied store must be the one assigned to the configuration',
          );
        },
      );
    },
  );
}
