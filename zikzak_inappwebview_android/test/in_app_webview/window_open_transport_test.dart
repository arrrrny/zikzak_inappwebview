// Bug #357 regression contract: a `window.open()` popup is wired to its
// opener through a `WebView.WebViewTransport` carried in an `android.os.Message`
// parked in `InAppWebViewManager.windowWebViewMessages`. The consumer sites
// (`FlutterWebView.makeInitialLoad`, `InAppBrowserActivity`) invoked
// `((WebView.WebViewTransport) resultMsg.obj).setWebView(...)` unconditionally:
// once a message has been dispatched (`sendToTarget`) the Android Looper
// recycles it and `obj` becomes null, so any later platform-view creation for
// the same windowId (re-attachment, recreation) crashed with
// "Attempt to invoke virtual method 'void android.webkit.WebView$WebViewTransport.setWebView(android.webkit.WebView)'
// on a null object reference".
//
// The contract, encoded as a source scan so the bug class cannot silently
// return (executable on any host, no Android SDK required — same approach as
// the macOS package's Swift source-contract tests):
//   1. the transport must be extracted into a local and null-checked before
//      `setWebView` (a stale/recycled message carries a null obj);
//   2. the parked message must be consumed — removed from
//      `windowWebViewMessages` — when looked up, so a recycled message can
//      never be handed to a second creation;
//   3. when the transport is missing or stale the consumer must fall back to
//      the normal initial load path instead of leaving a dead popup.
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

/// Strips line/block comments and string literals so only real code tokens
/// are scanned (an assertion can never be satisfied by a comment or a
/// string that merely mentions the pattern).
String stripJavaNonCode(String source) {
  final out = StringBuffer();
  var i = 0;
  var blockDepth = 0;
  while (i < source.length) {
    final rest = source.substring(i);
    if (blockDepth > 0) {
      if (rest.startsWith('*/')) {
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
    out.write(source[i]);
    i++;
  }
  return out.toString();
}

void expectWindowTransportContract(String javaSource, String label) {
  // (1) No unconditional chained cast-and-call: that is the exact crash site.
  expect(
    javaSource.contains('((WebView.WebViewTransport) resultMsg.obj).setWebView'),
    isFalse,
    reason:
        '$label still invokes setWebView on a chained cast of resultMsg.obj; '
        'a recycled window message carries a null obj and crashes (issue #357).',
  );

  // (2) The transport is extracted into a local and null-checked first.
  expect(
    javaSource.contains(
      'WebView.WebViewTransport transport = (WebView.WebViewTransport) resultMsg.obj',
    ),
    isTrue,
    reason: '$label must extract the WebViewTransport into a local variable.',
  );
  expect(
    javaSource.contains('if (transport != null)'),
    isTrue,
    reason:
        '$label must guard the extracted WebViewTransport against null '
        '(stale/recycled window message, issue #357).',
  );

  // (3) The parked message is consumed on lookup so it can never be reused
  // after the Looper recycled it.
  expect(
    javaSource.contains('windowWebViewMessages.remove(windowId)'),
    isTrue,
    reason:
        '$label must remove the consumed window message from '
        'windowWebViewMessages; leaving it parked lets a later platform-view '
        'creation read a recycled (null-obj) message and crash (issue #357).',
  );

  // (4) When the transport is unavailable the normal initial load path still
  // runs — the popup must not end up silently dead.
  expect(
    javaSource.contains('windowTransportWired'),
    isTrue,
    reason:
        '$label must track whether the window transport was wired so the '
        'initialFile/initialData/initialUrlRequest fallback load still runs '
        'when it was not.',
  );
}

void main() {
  group('window.open transport contract (issue #357)', () {
    test('FlutterWebView.makeInitialLoad guards the WebViewTransport', () {
      expectWindowTransportContract(
        readJava('webview/in_app_webview/FlutterWebView.java'),
        'FlutterWebView.makeInitialLoad',
      );
    });

    test('InAppBrowserActivity windowId path guards the WebViewTransport', () {
      expectWindowTransportContract(
        readJava('in_app_browser/InAppBrowserActivity.java'),
        'InAppBrowserActivity',
      );
    });
  });
}
