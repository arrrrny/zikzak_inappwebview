// Issue #351 regression contract (macOS). `webAuthenticationSupport` accepts
// FOR_BROWSER (wire value 2) on the Dart side, but the macOS creation path
// gated the whole apply block on `== 1`, so a requested FOR_BROWSER fell
// through with no error and no log — the reported silent drop.
//
// macOS exposes no public `WKWebViewConfiguration.webAuthenticationSupport` on
// any SDK (the symbol is absent from every WebKit header in the macOS 26.2
// SDK, and `responds(to: Selector("webAuthenticationSupport"))` is false at
// runtime), so FOR_BROWSER cannot be applied by any implementation — and
// neither can FOR_APP, whose KVC path is behind that same false guard. What a
// plugin CAN do is stop lying about it: report the request, and report the
// applied level. These contracts pin both surfaces.
//
// Executable on any host (no Xcode required) — the #316/#327/#328/#331
// source-contract precedent. These read the Swift sources as text, so they are
// evidence about code shape; the CI build-macos job is what proves the package
// compiles.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Strips line/block comments and string literals so only real code tokens are
/// scanned; a commented-out diagnostic or the warning's own message text must
/// not be able to satisfy a contract. Ported from swift_sourceframe_kvc_test.
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

/// Locates the macOS package root (`macos/zikzak_inappwebview_macos`) relative
/// to the current working directory, walking up at most a few levels so the
/// test works when invoked from the package dir or the repo root.
Directory packageMacosDir() {
  var dir = Directory.current;
  for (var hop = 0; hop < 5; hop++) {
    final candidate = Directory('${dir.path}/macos/zikzak_inappwebview_macos');
    if (candidate.existsSync()) return candidate;
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  fail(
    'Could not locate macos/zikzak_inappwebview_macos under or above '
    '${Directory.current.path}',
  );
}

/// Index of the `}` matching the `{` at [open], or -1 when unterminated.
int matchingBrace(String code, int open) {
  var depth = 0;
  for (var i = open; i < code.length; i++) {
    if (code[i] == '{') {
      depth++;
    } else if (code[i] == '}') {
      depth--;
      if (depth == 0) return i;
    }
  }
  return -1;
}

/// The text between the `{` that opens the block at or after [start] and its
/// matching `}`. Empty when unterminated, so a caller's lookup fails loudly
/// instead of silently passing.
String blockBody(String code, int start) {
  final open = code.indexOf('{', start);
  if (open == -1) return '';
  final close = matchingBrace(code, open);
  return close == -1 ? '' : code.substring(open + 1, close);
}

/// The text following the `else` that belongs to the `if` whose body ends at
/// [close], or '' when that `if` has no `else`.
String elseBodyAfter(String code, int close) {
  final after = code.substring(close);
  final at = after.indexOf('else');
  if (at == -1) return '';
  return blockBody(after, at);
}

void main() {
  group('webAuthenticationSupport reporting (bug #351)', () {
    late String webViewSource;
    late String settingsSource;
    late String webViewCode;
    late String settingsCode;

    /// The designated `init` — the creation path that builds the
    /// `WKWebViewConfiguration`, between it and the next top-level member.
    late String initCode;

    setUp(() {
      final sources =
          '${packageMacosDir().path}/Sources/zikzak_inappwebview_macos';
      webViewSource = File('$sources/InAppWebView.swift').readAsStringSync();
      settingsSource = File(
        '$sources/InAppWebViewSettings.swift',
      ).readAsStringSync();
      webViewCode = stripSwiftNonCode(webViewSource);
      settingsCode = stripSwiftNonCode(settingsSource);

      final initStart = webViewCode.indexOf('\n    init(');
      expect(
        initStart,
        greaterThanOrEqualTo(0),
        reason: 'InAppWebView designated init not found',
      );
      final nextMember = webViewCode.indexOf('\n    public override init(');
      initCode = webViewCode.substring(
        initStart,
        nextMember == -1 ? webViewCode.length : nextMember,
      );
    });

    test('AC1: creating a WebView with FOR_BROWSER reports the value instead of '
        'dropping it silently', () {
      final diagnostic = RegExp(
        r'webAuthnSupport\s*==\s*2\s*\{',
      ).firstMatch(initCode);
      expect(
        diagnostic,
        isNotNull,
        reason:
            'macOS must act on webAuthenticationSupport == 2 (FOR_BROWSER) at '
            'least by reporting it. A requested FOR_BROWSER currently falls '
            'through the creation path untouched — no error, no log — which '
            'is the silent drop reported in issue #351.',
      );

      expect(
        blockBody(initCode, diagnostic!.start).contains('print('),
        isTrue,
        reason:
            'The FOR_BROWSER branch must emit a native diagnostic via '
            '`print(`, matching the warning idiom the same setting already '
            'uses in setSettings (InAppWebView.swift:1870) and the iOS '
            'counterpart for issue #352.',
      );
    }, timeout: const Timeout(Duration(minutes: 2)));

    test(
      'AC2: the FOR_BROWSER report is live on every macOS version and is not '
      'dead code',
      () {
        final forBrowser = RegExp(
          r'webAuthnSupport\s*==\s*2\s*\{',
        ).firstMatch(initCode);
        expect(forBrowser, isNotNull);

        // Dead code is not a diagnostic: value 1 and value 2 are mutually
        // exclusive, so the report cannot live inside the FOR_APP branch.
        final forApp = initCode.indexOf('webAuthnSupport == 1');
        expect(
          forApp,
          greaterThanOrEqualTo(0),
          reason: 'FOR_APP branch not found in the creation path',
        );
        expect(
          blockBody(initCode, forApp).contains('webAuthnSupport == 2'),
          isFalse,
          reason:
              'The FOR_BROWSER diagnostic cannot live inside the FOR_APP '
              'branch, or it is unreachable dead code.',
        );

        // FOR_BROWSER is unsupported on every macOS version, so gating the
        // report behind the availability check would leave macOS 13.0-13.2
        // dropping the value without a word.
        final availability = initCode.indexOf('#available(macOS 13.3, *)');
        expect(availability, greaterThanOrEqualTo(0));
        expect(
          blockBody(initCode, availability).contains('webAuthnSupport == 2'),
          isFalse,
          reason:
              'The FOR_BROWSER diagnostic must not sit inside the macOS 13.3 '
              'availability block: FOR_BROWSER is unavailable on every macOS '
              'version, so an older OS must still be told it was dropped.',
        );
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test('AC3: the report names the level it refused and the platform', () {
      final at = webViewSource.indexOf('webAuthnSupport == 2');
      expect(
        at,
        greaterThanOrEqualTo(0),
        reason: 'FOR_BROWSER branch not found in InAppWebView.swift',
      );
      // String literals were stripped above, so assert the message on the
      // raw source: it has to identify the value, or a developer reading the
      // log cannot tell what was dropped.
      final message = webViewSource.substring(
        at,
        at + 800 > webViewSource.length ? webViewSource.length : at + 800,
      );
      expect(
        message.contains('FOR_BROWSER'),
        isTrue,
        reason:
            'The warning must name FOR_BROWSER so the log identifies the '
            'value that was not applied.',
      );
      expect(
        message.contains('macOS'),
        isTrue,
        reason:
            'The warning must state that the level is unsupported on macOS.',
      );
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('AC4: FOR_APP reports that it was not applied when WebKit exposes no '
        'such key', () {
      final forApp = initCode.indexOf('webAuthnSupport == 1');
      expect(forApp, greaterThanOrEqualTo(0));

      // FOR_APP is inert wherever `responds(to:)` is false, which is every
      // current macOS — the selector is not in any SDK. The KVC write is
      // inside that guard, so without an else arm FOR_APP is dropped as
      // silently as FOR_BROWSER was.
      final guard = initCode.indexOf(
        'configuration.responds(to: selector)',
        forApp,
      );
      expect(
        guard,
        greaterThanOrEqualTo(0),
        reason: 'responds(to:) guard not found in the FOR_APP branch',
      );
      final open = initCode.indexOf('{', guard);
      expect(open, greaterThanOrEqualTo(0));
      final close = matchingBrace(initCode, open);
      expect(close, greaterThanOrEqualTo(0));

      final onUnsupported = elseBodyAfter(initCode, close);
      expect(
        onUnsupported.contains('print('),
        isTrue,
        reason:
            'The FOR_APP path must report that the setting was not applied '
            'when WKWebViewConfiguration does not respond to '
            'webAuthenticationSupport — today the KVC write is silently '
            'skipped and a caller has no way to tell (issue #351).',
      );
    }, timeout: const Timeout(Duration(minutes: 2)));

    test(
      'AC5: getRealSettings reports the applied level, not the requested one',
      () {
        final readBack = settingsCode.indexOf('func getRealSettings');
        expect(
          readBack,
          greaterThanOrEqualTo(0),
          reason: 'getRealSettings() not found',
        );
        final region = settingsCode.substring(readBack);

        final guard = region.indexOf('if configuration.responds(to: selector)');
        expect(
          guard,
          greaterThanOrEqualTo(0),
          reason: 'read-back guard not found',
        );
        // String literals are blanked by stripSwiftNonCode, so the assignment
        // key reads as `realSettings[""]` in the stripped code.
        expect(
          blockBody(region, guard).contains('realSettings[""]'),
          isTrue,
          reason:
              'When WebKit does expose the setting, getRealSettings() keeps '
              'mirroring the applied boundKeychainForPasskeys flag.',
        );

        // realSettings is seeded from toMap() — the *requested* settings — so a
        // skipped block leaves the request echoed back: a WebView that was
        // never actually configured claims FOR_BROWSER. The read-back must
        // report NONE instead, which is the one thing it can report honestly
        // about a setting macOS never applied.
        final open = region.indexOf('{', guard);
        final close = matchingBrace(region, open);
        expect(close, greaterThanOrEqualTo(0));
        final onUnsupported = elseBodyAfter(region, close);
        expect(
          onUnsupported.contains('realSettings[""] = 0'),
          isTrue,
          reason:
              'When the read-back guard is false, getRealSettings() must report '
              'NONE (0) rather than echoing the requested level out of '
              'toMap() — a WebView that was never configured must not claim '
              'WebAuthn support it does not have (issue #351).',
        );
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}
