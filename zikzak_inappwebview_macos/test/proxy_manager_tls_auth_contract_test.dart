// Issue #387 source contract: ProxyController accepted `https://` proxy URLs
// and URLs carrying `user:pass@` credentials, but the resolved
// ProxyConfiguration honoured neither — an `https://` proxy was sent a
// plaintext CONNECT (no `tlsOptions:`), and URL userinfo was never read, so
// TLS-only proxies reset the connection and authenticated proxies answered
// 407 Proxy Authentication Required. Both failures were silent:
// `setProxyOverride` returned true and pages simply never loaded.
//
// These tests encode the fix as a source scan of ProxyManager.swift so the
// defect class cannot silently return; they are executable on any host (no
// Xcode required). They prove code *shape*, never that it compiles — the
// build-macos CI job remains the layer that type-checks these sources (see
// AGENTS.md). This file mirrors
// zikzak_inappwebview_ios/test/proxy_manager_tls_auth_contract_test.dart so
// both platform packages carry the identical contract.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Strips line comments and (nested) block comments so comment prose that
/// mentions the same tokens cannot satisfy the contracts below. String
/// literal contents are KEPT: the scheme gate `== "HTTPS"` is itself a string
/// literal the contracts must be able to see. ProxyManager.swift contains no
/// triple-quoted strings.
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
    if (source[i] == '"') {
      // Copy the whole string literal (delimiters and contents) verbatim.
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

/// Number of `{`-blocks still open at [index] in [code].
int braceDepthAt(String code, int index) {
  var depth = 0;
  for (var i = 0; i < index && i < code.length; i++) {
    if (code[i] == '{') {
      depth++;
    } else if (code[i] == '}') {
      depth--;
    }
  }
  return depth;
}

/// Locates the macOS package root (`macos/zikzak_inappwebview_macos`)
/// relative to the current working directory, walking up so the test works
/// when invoked from the package dir or the repo root.
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

/// The comment-stripped body of `resolveProxyConfiguration` — the function
/// both defects live in.
({String body, String raw}) resolveContract() {
  final file = File(
    '${packageDir().path}/Sources/zikzak_inappwebview_macos/ProxyManager.swift',
  );
  expect(
    file.existsSync(),
    isTrue,
    reason: 'ProxyManager.swift missing at ${file.path}',
  );
  final raw = file.readAsStringSync();
  final code = stripSwiftComments(raw);
  final start = code.indexOf('func resolveProxyConfiguration');
  expect(
    start,
    greaterThanOrEqualTo(0),
    reason: 'resolveProxyConfiguration not found in ProxyManager.swift',
  );
  final body = functionBody(code, start);
  expect(
    body,
    isNotEmpty,
    reason: 'resolveProxyConfiguration body is unterminated',
  );
  return (body: body, raw: raw);
}

void main() {
  group(
    'issue #387 source contract: TLS to https:// proxies, credentials from URL userinfo',
    () {
      test('an https:// proxy is created with TLS options — the plaintext '
          'CONNECT construction is gone', () {
        final contract = resolveContract();
        // The TLS decision is keyed on the URL scheme itself.
        expect(
          contract.body,
          contains('let isTlsProxy = schemeType == "HTTPS"'),
          reason:
              'https:// proxies must be detected by scheme; without it a '
              'TLS-only proxy is sent a plaintext CONNECT and resets the '
              'connection (issue #387, leg 1)',
        );
        // The CONNECT-proxy construction carries the TLS options.
        expect(
          RegExp(
            r'ProxyConfiguration\(\s*httpCONNECTProxy:\s*endpoint,\s*tlsOptions:',
          ).hasMatch(contract.body),
          isTrue,
          reason:
              'the httpCONNECTProxy initialisation must pass tlsOptions: — '
              'Network.framework supports TLS to an HTTP CONNECT proxy, the '
              'plugin just never asked for it',
        );
        // The old single-argument form must not survive anywhere in the
        // function: it is the exact construction that broke https://.
        expect(
          RegExp(
            r'ProxyConfiguration\(httpCONNECTProxy:\s*endpoint\)',
          ).hasMatch(contract.body),
          isFalse,
          reason:
              'the no-TLS single-argument httpCONNECTProxy construction '
              'is the defect being fixed',
        );
      });

      test('plain http and socks5 constructions keep the proxy leg TLS-free', () {
        final contract = resolveContract();
        // TLS options only when the URL says https://; nil otherwise.
        expect(
          RegExp(
            r'tlsOptions:\s*isTlsProxy\s*\?\s*NWProtocolTLS\.Options\(\)\s*:\s*nil',
          ).hasMatch(contract.body),
          isTrue,
          reason:
              'http:// and socks5:// must keep tlsOptions nil — no TLS '
              'to a plaintext proxy',
        );
        // The SOCKS v5 leg is unchanged: no TLS arguments on it.
        expect(
          RegExp(r'socksv5Proxy:\s*endpoint\)').hasMatch(contract.body),
          isTrue,
          reason: 'the socksv5Proxy construction must stay argument-free',
        );
      });

      test('URL userinfo is read and applied as proxy credentials', () {
        final contract = resolveContract();
        final guardIndex = contract.body.indexOf(
          'if let user = components.user, !user.isEmpty',
        );
        expect(
          guardIndex,
          greaterThanOrEqualTo(0),
          reason:
              'user:pass@ must be read from the URL — ProxySettings has no '
              'username/password fields, so the URL is the only credential '
              'carrier (issue #387, leg 2)',
        );
        final callIndex = contract.body.indexOf('.applyCredential(');
        expect(
          callIndex,
          greaterThan(guardIndex),
          reason:
              'ProxyConfiguration.applyCredential must be called — without '
              'it an authenticated proxy answers 407 and pages silently '
              'never load',
        );
        // The call must sit directly inside the userinfo guard, so a URL
        // without userinfo never reaches it.
        expect(
          braceDepthAt(contract.body, callIndex),
          equals(braceDepthAt(contract.body, guardIndex) + 1),
          reason:
              'applyCredential must only run for URLs that carry '
              'userinfo',
        );
      });

      test('credentials are percent-decoded exactly once', () {
        final contract = resolveContract();
        // URLComponents' `user`/`password` accessors already return
        // percent-decoded values. Applying `removingPercentEncoding` on
        // top would double-decode credentials containing a literal `%` —
        // a password written on the wire as `50%2525` (for `50%25`) would
        // be mangled to `50%`.
        expect(
          RegExp(r'username:\s*user\b').hasMatch(contract.body),
          isTrue,
          reason:
              'the decoded components.user value must be passed '
              'through as the username',
        );
        expect(
          RegExp(
            r'password:\s*components\.password\s*\?\?\s*""',
          ).hasMatch(contract.body),
          isTrue,
          reason:
              'the decoded components.password value (empty when '
              'absent) must be passed through as the password',
        );
        expect(
          contract.body.contains('.removingPercentEncoding'),
          isFalse,
          reason:
              'a second decoding pass on top of URLComponents\' decoded '
              'accessors corrupts credentials containing `%`',
        );
      });

      test(
        'the UNSUPPORTED_PROXY_SCHEME message states the real support matrix',
        () {
          final contract = resolveContract();
          final messageStart = contract.raw.indexOf('Proxy URL scheme must be');
          expect(
            messageStart,
            greaterThanOrEqualTo(0),
            reason: 'the unsupported-scheme message was removed',
          );
          final messageEnd = contract.raw.indexOf('"', messageStart);
          expect(messageEnd, greaterThan(messageStart));
          final message = contract.raw.substring(messageStart, messageEnd);
          for (final scheme in ['HTTP', 'HTTPS', 'SOCKS', 'SOCKS5']) {
            expect(
              message,
              contains(scheme),
              reason: 'the accepted-scheme list must stay complete',
            );
          }
          expect(
            message,
            contains('TLS'),
            reason: 'the message must say which schemes get TLS to the proxy',
          );
          expect(
            message.toLowerCase(),
            contains('credential'),
            reason:
                'the message must say how proxy authentication is '
                'supplied',
          );
        },
      );
    },
  );
}
