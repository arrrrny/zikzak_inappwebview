// Bug #373 regression contract: the `evaluateJavascript` handler reported a
// thrown JS exception as WebKit's generic `localizedDescription` — the string
// "A JavaScript exception occurred" — with `details: nil`. The actionable
// fields (`WKJavaScriptExceptionMessage`, line, column, source URL) live in
// the error's `userInfo` and were discarded, so a Dart caller had nothing to
// bisect a failing `page.evaluate` with.
//
// This test encodes that rule as a source scan so the bug class cannot
// silently return; it is executable on any host (no Xcode required). The
// message derivation is shared by both evaluation arms, so the assertions
// follow it into `javaScriptExceptionMessage(_:)` rather than pinning the
// chain inside the error builder.
import 'package:flutter_test/flutter_test.dart';

import 'support/swift_source.dart';

/// The RAW slice of one `case "<label>":` arm — from that case label up to
/// the next case label at the same indentation. For assertions that must see
/// string-literal keys, which [stripSwiftNonCode] erases.
String channelArmSlice(String rawSource, String label) {
  final marker = 'case "$label":';
  final first = rawSource.indexOf(marker);
  expect(
    first,
    isNot(-1),
    reason: 'the macOS channel switch has no $label arm',
  );
  expect(
    rawSource.indexOf(marker, first + 1),
    -1,
    reason: 'expected exactly one $label arm',
  );
  final nextCase = RegExp(
    r'\n {8}case "',
  ).allMatches(rawSource.substring(first + 1));
  final end = nextCase.isEmpty
      ? rawSource.length
      : first + 1 + nextCase.first.start;
  return rawSource.substring(first, end);
}

/// One `case "<label>":` arm of the macOS channel switch, comment/string
/// stripped (see [channelArmSlice]).
///
/// Located on the RAW source (the case label is a string literal, so a scanner
/// that strips literals could never find it), then stripped for token
/// assertions.
String channelArm(String rawSource, String label) =>
    stripSwiftNonCode(channelArmSlice(rawSource, label));

void main() {
  group('evaluateJavascript JS-exception details (bug #373)', () {
    test('AC1: both failure paths report through the JS-exception builder, not '
        'the bare localizedDescription', () {
      final arm = channelArm(
        sourceFile().readAsStringSync(),
        'evaluateJavascript',
      );

      // The two failure paths the issue names: the WKContentWorld outcome
      // and the plain (value, error) callback.
      expect(
        RegExp(r'\.failure').allMatches(arm).length,
        1,
        reason: 'expected the WKContentWorld outcome failure path',
      );
      expect(
        RegExp(r'if let error = error').allMatches(arm).length,
        1,
        reason: 'expected the plain completion-handler failure path',
      );
      expect(
        RegExp(r'javaScriptExceptionError\(').allMatches(arm).length,
        2,
        reason:
            'both evaluateJavascript failure paths must build their '
            'FlutterError via javaScriptExceptionError(error) so the '
            'WKJavaScriptExceptionMessage/line/column reach Dart',
      );
      expect(
        arm.contains('message: error.localizedDescription'),
        isFalse,
        reason:
            'the generic "A JavaScript exception occurred" message '
            'must not be the only thing a Dart caller sees',
      );
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('AC2: the shared message derivation reads '
        'WKJavaScriptExceptionMessage, with the documented fallback chain', () {
      final raw = sourceFile().readAsStringSync();
      // The keys are string literals, so the body is scanned raw — a
      // literal-stripping scan could never see them (it would see `""`).
      final body = functionBody(raw, 'func javaScriptExceptionMessage(');
      for (final marker in [
        'WKJavaScriptExceptionMessage',
        'NSLocalizedDescription',
        'localizedDescription',
      ]) {
        expect(
          body.contains(marker),
          isTrue,
          reason:
              'javaScriptExceptionMessage must derive its message from '
              '$marker, mirroring the callAsyncJavaScript precedent',
        );
      }
      // The exception text must win over the generic description.
      expect(
        body.indexOf('WKJavaScriptExceptionMessage') <
            body.indexOf('NSLocalizedDescription'),
        isTrue,
        reason:
            'WKJavaScriptExceptionMessage must be tried before the '
            'generic NSLocalizedDescription fallback',
      );
      // Every term is coerced, so a non-String userInfo value can never cross
      // the channel raw.
      expect(
        RegExp(
          r'userInfo\["WKJavaScriptExceptionMessage"\] as\? String',
        ).hasMatch(body),
        isTrue,
        reason:
            'the exception-message term must be coerced with `as? String`; '
            'an untyped term crosses the channel as whatever WebKit handed '
            'over',
      );
      expect(
        functionBody(
          raw,
          'func javaScriptExceptionError(',
        ).contains('javaScriptExceptionMessage('),
        isTrue,
        reason:
            'the evaluateJavascript error builder must reuse the shared '
            'message derivation instead of re-deriving it',
      );
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('AC2b: the callAsyncJavaScript arm reuses the shared message '
        'derivation instead of keeping its own copy', () {
      final raw = sourceFile().readAsStringSync();
      // String-literal keys, so the arm is scanned raw.
      final arm = channelArmSlice(raw, 'callAsyncJavaScript');

      expect(
        arm.contains('body["error"] = javaScriptExceptionMessage(error)'),
        isTrue,
        reason:
            'callAsyncJavaScript must route its failure message through '
            'javaScriptExceptionMessage(error) — the envelope '
            '`body["error"]` must stay as it is, so the Dart-visible result '
            'shape does not change',
      );
      expect(
        arm.contains('WKJavaScriptExceptionMessage'),
        isFalse,
        reason:
            'the callAsyncJavaScript arm must not keep a second copy of '
            'the message chain: two copies in one file drift',
      );
    }, timeout: const Timeout(Duration(minutes: 2)));

    test(
      'AC3: the builder carries line, column and source URL in `details`',
      () {
        // The keys are string literals, so the body is scanned raw — a
        // literal-stripping scan could never see them (it would see `""`).
        final body = functionBody(
          sourceFile().readAsStringSync(),
          'func javaScriptExceptionError(',
        );
        for (final key in [
          'WKJavaScriptExceptionLineNumber',
          'WKJavaScriptExceptionColumnNumber',
          'WKJavaScriptExceptionSourceURL',
        ]) {
          expect(
            body.contains(key),
            isTrue,
            reason:
                'details must carry $key so a Dart caller can locate '
                'the throwing line without re-deriving it',
          );
        }
        expect(
          body.contains('details:'),
          isTrue,
          reason:
              'the builder must pass a non-nil details map for a JS '
              'exception',
        );
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}
