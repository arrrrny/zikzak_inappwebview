// Bug #362 regression contract: `InAppWebViewChromeClient.onCreateWindow`
// must consume exactly ONE window id per window request, and the counter must
// start at 0 so the FIRST request reports `windowId: 1` to Dart via its
// `CreateWindowAction`.
//
// `window.open()` called from JavaScript produces no hit-test URL, so the
// method's UNKNOWN_TYPE branch captures the popup URL through a temporary
// WebView and dispatches a second `CreateWindowAction` from its
// `shouldOverrideUrlLoading` callback. That callback used to allocate a SECOND
// id from `InAppWebViewManager.windowAutoincrementId` and pass it to the
// action, discarding the id allocated at the top of `onCreateWindow` — so the
// first `window.open()` popup reached Dart with `windowId: 2` (issue #362).
// (On 6.2.0 the same callback also re-parked the already-dispatched
// `resultMsg` in `windowWebViewMessages`; the recycled message's null obj then
// crashed `FlutterWebView.makeInitialLoad` with the NullPointerException in
// the issue — #357 removed that re-parking, this contract closes the id side.)
//
// Encoded as a source scan so the bug class cannot silently return (same
// approach as `window_open_transport_test.dart`: executable on any host, no
// Android SDK required).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Java source root of the Android platform package, resolved from the
/// package root (the cwd `flutter test` runs in).
final String javaRoot = Directory.current.path;

String readJava(String relativePath) {
  final file = File(
    '$javaRoot/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/$relativePath',
  );
  return stripJavaNonCode(file.readAsStringSync());
}

/// Strips line/block comments, string literals, char literals and text blocks
/// so only real code tokens are scanned (an assertion can never be satisfied
/// by a comment or a string that merely mentions the pattern).
String stripJavaNonCode(String source) {
  final out = StringBuffer();
  var i = 0;
  var blockDepth = 0;
  while (i < source.length) {
    if (blockDepth > 0) {
      if (source.startsWith('*/', i)) {
        blockDepth--;
        i += 2;
      } else {
        if (source[i] == '\n') out.write('\n');
        i++;
      }
      continue;
    }
    if (source.startsWith('/*', i)) {
      blockDepth++;
      i += 2;
      continue;
    }
    if (source.startsWith('//', i)) {
      final end = source.indexOf('\n', i);
      i = end == -1 ? source.length : end;
      continue;
    }
    if (source.startsWith('"""', i)) {
      var j = i + 3;
      while (j < source.length) {
        if (source[j] == r'\') {
          j += 2;
          continue;
        }
        if (source.startsWith('"""', j)) break;
        j++;
      }
      i = j + 3;
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
        if (source[j] == '"') break;
        j++;
      }
      i = j + 1;
      out.write('""');
      continue;
    }
    if (source[i] == "'") {
      var j = i + 1;
      while (j < source.length) {
        if (source[j] == r'\') {
          j += 2;
          continue;
        }
        if (source[j] == "'") break;
        j++;
      }
      i = j + 1;
      out.write("''");
      continue;
    }
    out.write(source[i]);
    i++;
  }
  return out.toString();
}

/// Extracts a method body (signature through its matching closing brace) by
/// brace matching. Comments and literals must already be stripped so braces
/// are structural.
String extractMethodBody(String source, String signatureFragment) {
  final start = source.indexOf(signatureFragment);
  expect(
    start,
    isNot(-1),
    reason: 'Method containing "$signatureFragment" must exist.',
  );
  final open = source.indexOf('{', start);
  expect(open, isNot(-1), reason: 'Method must have a body.');
  var depth = 0;
  for (var i = open; i < source.length; i++) {
    if (source[i] == '{') depth++;
    if (source[i] == '}') {
      depth--;
      if (depth == 0) return source.substring(open, i + 1);
    }
  }
  fail('Unbalanced braces while extracting "$signatureFragment".');
}

void main() {
  group('window.open id allocation contract (issue #362)', () {
    test(
      'the window id counter starts at 0 so the first request reports 1',
      () {
        final manager = readJava('webview/InAppWebViewManager.java');
        expect(
          manager.contains('public int windowAutoincrementId = 0;'),
          isTrue,
          reason:
              'InAppWebViewManager.windowAutoincrementId must start at 0: the '
              'first allocated id (incremented before use) is then 1, which is '
              'the windowId the first window.open() popup must report '
              '(issue #362).',
        );
      },
    );

    test('onCreateWindow consumes exactly one id per window request', () {
      final source = readJava(
        'webview/in_app_webview/InAppWebViewChromeClient.java',
      );
      final body = extractMethodBody(source, 'boolean onCreateWindow(');
      final allocations = 'windowAutoincrementId++'.allMatches(body).length;
      expect(
        allocations,
        equals(1),
        reason:
            'onCreateWindow must allocate exactly one window id per request. '
            'A second allocation (historically inside the UNKNOWN_TYPE '
            'URL-capture branch) burns an id and makes the first '
            'window.open() popup report windowId 2 instead of 1 — the exact '
            'symptom of issue #362.',
      );
    });
  });
}
