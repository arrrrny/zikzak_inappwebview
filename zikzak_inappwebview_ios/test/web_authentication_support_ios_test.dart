// Issue #352 regression contract (iOS). `webAuthenticationSupport` accepts
// FOR_BROWSER (wire value 2) on the Dart side, but the iOS apply path only ever
// reached for FOR_APP (1), behind a `responds(to:)` guard — and runtime
// verification shows that guard is false on every tested iOS runtime, so
// nothing was ever applied: a requested 2 fell through with no error and no
// log, a requested FOR_APP fell the same way, and `getRealSettings()` echoed
// the *requested* level back out of its `toMap()` seed.
//
// Like macOS (#351), iOS exposes no `webAuthenticationSupport` key at all —
// verified at runtime: `WKWebViewConfiguration().responds(to:
// Selector("webAuthenticationSupport"))` is false inside the iOS 26.3
// simulator runtime, and the symbol is absent from every WebKit header. The
// private WKWebViewWebAuthenticationSupport carries only
// `boundKeychainForPasskeys`, the app-bound model, and that object is only
// reachable through the key that does not exist. Neither non-NONE level can be
// honored by any implementation on iOS — the defect is that the drop was
// silent and the read-back lied. These contracts pin the surfaces that make
// the limitation observable: creation-time native diagnostics for both levels
// (matching Android's InAppWebView.java:762-770 behavior) and an honest
// read-back.
//
// Executable on any host (no Xcode required) — the #316/#328/#331 source-contract
// precedent. These read the Swift sources as text, so they are evidence about
// code shape; the CI build-ios job is what proves the package compiles.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Removes Swift string literals, `/* … */` blocks and `//` line comments so the
/// scan sees only executable code — neither a commented-out diagnostic nor the
/// warning's own message text can satisfy a contract below. Literals are
/// stripped before line comments so an `https://` inside a string is not
/// mistaken for the start of a comment.
String codeOnly(String source) {
  final noBlockComments =
      source.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), ' ');
  final noLiterals = noBlockComments.replaceAll(
    RegExp(r'"(?:[^"\\\n]|\\.)*"'),
    '""',
  );
  return noLiterals
      .split('\n')
      .map((line) => line.contains('//') ? line.split('//').first : line)
      .join('\n');
}

/// The text between the `{` that opens the braces-delimited block at or after
/// [start] and its matching `}`. Empty when unterminated, so a caller's lookup
/// fails loudly instead of silently passing.
String blockBody(String code, int start) {
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

/// The body of the `else` that follows the `if` whose body ends at [close], or
/// '' when there is no else.
String elseBodyAfter(String code, int close) {
  final after = code.substring(close);
  final at = after.indexOf('else');
  if (at == -1) return '';
  final open = after.indexOf('{', at);
  if (open == -1) return '';
  final closeIdx = matchingBrace(after, open);
  return closeIdx == -1 ? '' : after.substring(open + 1, closeIdx);
}

/// Locates the iOS package root (`ios/zikzak_inappwebview_ios`) relative to the
/// current working directory, walking up a few levels so the test works whether
/// invoked from the package dir or the repo root.
Directory packageIosDir() {
  var dir = Directory.current;
  for (var hop = 0; hop < 5; hop++) {
    final candidate = Directory('${dir.path}/ios/zikzak_inappwebview_ios');
    if (candidate.existsSync()) return candidate;
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  fail('Could not locate ios/zikzak_inappwebview_ios under or above '
      '${Directory.current.path}');
}

/// The contiguous `//` comment lines immediately above the line containing
/// [anchor], searching upwards from it. Used to pin the documentation attached
/// to a statement rather than prose anywhere in the file.
String commentBlockAbove(String source, String anchor) {
  final lines = source.split('\n');
  final at = lines.indexWhere((line) => line.contains(anchor));
  if (at == -1) return '';
  final collected = <String>[];
  for (var i = at - 1; i >= 0; i--) {
    final trimmed = lines[i].trim();
    if (!trimmed.startsWith('//')) break;
    collected.insert(0, trimmed);
  }
  return collected.join('\n');
}

void main() {
  test(
    'creating a WebView with FOR_BROWSER logs a native diagnostic instead of '
    'dropping the value silently (issue #352)',
    () {
      final source = File(
        '${packageIosDir().path}/Sources/zikzak_inappwebview_ios/'
        'InAppWebView/InAppWebView.swift',
      ).readAsStringSync();
      final code = codeOnly(source);

      // The diagnostic belongs to the creation path: preWKWebViewConfiguration
      // is what every WebView controller builds its configuration from, so this
      // fires once per WebView rather than on every settings change.
      final functionStart = code.indexOf(
        'public static func preWKWebViewConfiguration',
      );
      expect(functionStart, greaterThanOrEqualTo(0),
          reason: 'preWKWebViewConfiguration not found in InAppWebView.swift');
      final functionSource = blockBody(code, functionStart);

      final diagnostic = RegExp(
        r'if\s+settings\.webAuthenticationSupport\s*==\s*2\s*\{',
      ).firstMatch(functionSource);
      expect(
        diagnostic,
        isNotNull,
        reason:
            'iOS must act on webAuthenticationSupport == 2 (FOR_BROWSER) at '
            'least by reporting it. A requested FOR_BROWSER currently falls '
            'through preWKWebViewConfiguration untouched — no error, no log — '
            'and the WebView then reads back as NONE (issue #352).',
      );

      final diagnosticBody = blockBody(functionSource, diagnostic!.start);
      expect(
        diagnosticBody.contains('print('),
        isTrue,
        reason:
            'The FOR_BROWSER branch must emit a native diagnostic via '
            '`print(`, matching the warning idiom already used for the '
            'creation-time webAuthenticationSupport no-op in setSettings.',
      );

      // Dead code is not a diagnostic: neither the FOR_APP block nor the
      // availability block may enclose the warning. In particular the warning
      // must not be gated behind `#available(iOS 16.4, *)`, or iOS 15/16.0-16.3
      // keeps dropping the value without a word.
      final forApp = functionSource.indexOf(
        'if settings.webAuthenticationSupport == 1 {',
      );
      expect(forApp, greaterThanOrEqualTo(0));
      expect(
        blockBody(functionSource, forApp)
            .contains('webAuthenticationSupport == 2'),
        isFalse,
        reason:
            'The FOR_BROWSER diagnostic cannot live inside the FOR_APP branch '
            '(value 1 and value 2 are mutually exclusive), or it is '
            'unreachable dead code.',
      );
      final availability = functionSource.indexOf('#available(iOS 16.4, *) {');
      expect(availability, greaterThanOrEqualTo(0));
      expect(
        blockBody(functionSource, availability)
            .contains('webAuthenticationSupport == 2'),
        isFalse,
        reason:
            'The FOR_BROWSER diagnostic must not sit inside the iOS 16.4 '
            'availability block: FOR_BROWSER is unavailable on every iOS '
            'version, so an older OS must still be told the request was '
            'dropped.',
      );

      // FOR_APP is inert too: the same absent key means the KVC write never
      // runs, so the guard must carry an else that reports, and the gate
      // itself must carry a FOR_APP arm for iOS 16.3 and older, where the
      // in-block else never runs.
      final respondsGuard = functionSource.indexOf(
        'configuration.responds(to: selector)',
        forApp,
      );
      expect(
        respondsGuard,
        greaterThanOrEqualTo(0),
        reason: 'responds(to:) guard not found in the FOR_APP branch',
      );
      final guardOpen = functionSource.indexOf('{', respondsGuard);
      expect(guardOpen, greaterThanOrEqualTo(0));
      final guardClose = matchingBrace(functionSource, guardOpen);
      expect(guardClose, greaterThanOrEqualTo(0));
      expect(
        elseBodyAfter(functionSource, guardClose).contains('print('),
        isTrue,
        reason:
            'The FOR_APP path must report that the value was not applied '
            'when WKWebViewConfiguration does not respond to '
            'webAuthenticationSupport — runtime verification shows the guard '
            'is false on every current iOS, so without the else FOR_APP is '
            'dropped as silently as FOR_BROWSER was (issue #352).',
      );

      final gateOpen = functionSource.indexOf('{', availability);
      expect(gateOpen, greaterThanOrEqualTo(0));
      final gateClose = matchingBrace(functionSource, gateOpen);
      expect(gateClose, greaterThanOrEqualTo(0));
      final onOlder = elseBodyAfter(functionSource, gateClose);
      expect(
        onOlder.contains('print('),
        isTrue,
        reason:
            'The availability gate must carry its own FOR_APP report arm: on '
            'iOS 16.3 and older the in-block else is unreachable, so a '
            'requested FOR_APP would still be dropped without a word '
            '(issue #352).',
      );
      final elseClause = functionSource.substring(
        gateClose,
        gateClose + 200 > functionSource.length
            ? functionSource.length
            : gateClose + 200,
      );
      expect(
        elseClause.contains('settings.webAuthenticationSupport == 1'),
        isTrue,
        reason:
            'The pre-16.4 report arm must be gated on a requested FOR_APP '
            '(webAuthenticationSupport == 1) — other levels must stay '
            'unreported.',
      );

      // The warning text is stripped as a string literal above, so assert it on
      // the raw source — it has to name the level it refused and the OS, or a
      // developer reading the log cannot tell what was dropped.
      final rawFromGuard = source.substring(
        source.indexOf('webAuthenticationSupport == 2'),
        source.indexOf('webAuthenticationSupport == 2') + 600,
      );
      expect(
        rawFromGuard.contains('FOR_BROWSER'),
        isTrue,
        reason: 'The warning must name FOR_BROWSER so the log identifies the '
            'value that was dropped.',
      );
      expect(
        rawFromGuard.contains('iOS'),
        isTrue,
        reason:
            'The warning must state that the level is unsupported on iOS, '
            'mirroring Android\'s "requested but … is not supported" wording.',
      );
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'getRealSettings reports the applied WebAuthn level only, and says so '
    'where it mirrors (issue #352)',
    () {
      final settingsFile = File(
        '${packageIosDir().path}/Sources/zikzak_inappwebview_ios/'
        'InAppWebView/InAppWebViewSettings.swift',
      );
      final source = settingsFile.readAsStringSync();

      // Pin the applied-level mirror by whole trimmed statement, the way the
      // #331 contract pins `clipsToBounds = true`: this is the read-back that
      // turns a requested FOR_BROWSER into NONE, so it must stay a 1-or-0
      // report of what `boundKeychainForPasskeys` actually holds. The pin runs
      // on the raw source — a commented-out copy trims to a `//` prefix and so
      // cannot equal the bare statement — and no literal stripping happens
      // here, which would rewrite the `["webAuthenticationSupport"]` key.
      final statements = source
          .split('\n')
          .map((line) => line.trim())
          .map(
            (line) => line.endsWith(';')
                ? line.substring(0, line.length - 1).trim()
                : line,
          )
          .toList();
      expect(
        statements.contains(
          'realSettings["webAuthenticationSupport"] = boundValue ? 1 : 0',
        ),
        isTrue,
        reason:
            'The iOS read-back mirror must report the applied boundKeychain '
            'flag as FOR_APP (1) or NONE (0). A FOR_BROWSER request is never '
            'applied on iOS, so it cannot round-trip through getRealSettings '
            '(issue #352).',
      );

      // The lossy read-back is the other half of the report, so the mirror
      // must document it rather than leaving consumers to infer it.
      final documented =
          commentBlockAbove(source, 'realSettings["webAuthenticationSupport"] = boundValue');
      expect(
        documented.toLowerCase(),
        contains('applied'),
        reason:
            'The settings mirror must document that getRealSettings reports '
            'the APPLIED level only (issue #352).',
      );
      expect(
        documented.toUpperCase(),
        contains('FOR_BROWSER'),
        reason:
            'The settings mirror must name FOR_BROWSER as the value that '
            'cannot round-trip on iOS, so the read-back is not mistaken for a '
            'lossless round-trip (issue #352).',
      );

      // When the mirror cannot run — guard false, or below iOS 16.4 — the
      // read-back must report NONE (0) rather than echoing the requested
      // level out of its toMap() seed.
      final mirror = source.indexOf(
        'realSettings["webAuthenticationSupport"] = boundValue ? 1 : 0',
      );
      expect(mirror, greaterThanOrEqualTo(0));
      final gate = source.lastIndexOf('#available(iOS 16.4, *)', mirror);
      expect(
        gate,
        greaterThanOrEqualTo(0),
        reason: 'iOS 16.4 availability gate not found above the mirror',
      );
      final gateOpen = source.indexOf('{', gate);
      expect(gateOpen, greaterThanOrEqualTo(0));
      final gateClose = matchingBrace(source, gateOpen);
      expect(gateClose, greaterThanOrEqualTo(0));
      expect(
        elseBodyAfter(source, gateClose).contains(
          'realSettings["webAuthenticationSupport"] = 0',
        ),
        isTrue,
        reason:
            'The availability gate must report NONE (0) itself: on iOS 16.3 '
            'and older the read-back mirror never runs, so a requested '
            'FOR_APP or FOR_BROWSER would still echo back out of toMap() '
            '(issue #352).',
      );
      final respondsGuard = source.indexOf(
        'configuration.responds(to: selector)',
        gate,
      );
      expect(respondsGuard, greaterThanOrEqualTo(0));
      final guardOpen = source.indexOf('{', respondsGuard);
      expect(guardOpen, greaterThanOrEqualTo(0));
      final guardClose = matchingBrace(source, guardOpen);
      expect(guardClose, greaterThanOrEqualTo(0));
      expect(
        elseBodyAfter(source, guardClose).contains(
          'realSettings["webAuthenticationSupport"] = 0',
        ),
        isTrue,
        reason:
            'When the read-back guard is false, getRealSettings() must report '
            'NONE (0) rather than echoing the requested level out of toMap() '
            '— nothing was applied, so NONE is the only honest answer '
            '(issue #352).',
      );
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
