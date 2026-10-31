// Issue #398 — the Android JS-bridge registration guard contract.
//
// The Dart half has no way to execute the Java side on this host, so this is a
// source contract over the native registration sites, mirroring the
// `headless_lifecycle_contract_test.dart` approach: it asserts the shape of
// the Java sources that carry the fix.
//
// R1-R3: every `WebViewCompat.addDocumentStartJavaScript` site in
//        UserContentController is wrapped in `try/catch (RuntimeException)`,
//        logs, and on failure leaves the handler unregistered (not in
//        `scriptHandlerMap` / `contentWorldsCreatorScript == null`) so a later
//        add can retry. Chromium's browser process may not have finished
//        starting on release cold starts ("Must be started before we block!").
// R4:    the deferred-registration `Runnable` posted from the
//        InAppWebView constructor is guarded the same way — an uncaught throw
//        inside a posted Runnable takes down the main thread.
// R5:    `dispose()` no longer calls `clearCache(true)`: the WebView HTTP
//        cache is per-application, so clearing it on every disposal wipes the
//        cache of every other WebView in the app. Explicit clearing stays
//        available via `clearAllCache()`.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _uccPath =
    'android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/'
    'types/UserContentController.java';
const _viewPath =
    'android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/'
    'webview/in_app_webview/InAppWebView.java';

final _tryPattern = RegExp(r'\btry\s*\{');
final _catchPattern = RegExp(r'catch\s*\(\s*RuntimeException');

/// Replaces the contents of Java comments, string literals and char literals
/// with spaces, preserving length so indices still map 1:1 onto [source].
/// Brace counting on raw Java text would mis-balance on a `{`/`}` inside a
/// comment or a string literal (e.g. a log message like "expected {foo}").
String _maskedForBraces(String source) {
  final out = StringBuffer();
  var i = 0;
  void skip(int count) {
    out.write(' ' * count);
    i += count;
  }

  while (i < source.length) {
    final c = source[i];
    if (c == '/' && i + 1 < source.length && source[i + 1] == '/') {
      final end = source.indexOf('\n', i);
      skip((end < 0 ? source.length : end) - i);
      continue;
    }
    if (c == '/' && i + 1 < source.length && source[i + 1] == '*') {
      final end = source.indexOf('*/', i + 2);
      skip((end < 0 ? source.length : end + 2) - i);
      continue;
    }
    if (c == '"' || c == "'") {
      var j = i + 1;
      while (j < source.length) {
        if (source[j] == r'\') {
          j += 2;
        } else if (source[j] == c) {
          j += 1;
          break;
        } else {
          j += 1;
        }
      }
      skip(j - i);
      continue;
    }
    out.write(c);
    i++;
  }
  return out.toString();
}

/// Returns the brace-balanced block that opens at the first `{` at or after
/// the first match of [start] in [source], starting from [from]. Brace
/// counting runs on a comment/literal-masked copy; the returned text is the
/// original source.
String _block(String source, Pattern start, {int from = 0}) {
  final mask = _maskedForBraces(source);
  final declIndex = mask.indexOf(start, from);
  if (declIndex < 0) {
    fail('pattern not found: $start');
  }
  final open = mask.indexOf('{', declIndex);
  var depth = 0;
  for (var i = open; i < mask.length; i++) {
    if (mask[i] == '{') {
      depth++;
    } else if (mask[i] == '}') {
      depth--;
      if (depth == 0) {
        return source.substring(declIndex, i + 1);
      }
    }
  }
  fail('unbalanced braces for pattern: $start');
}

/// Returns every brace-balanced block opened by a match of [start].
Iterable<String> _blocks(String source, Pattern start) sync* {
  var from = 0;
  while (true) {
    final declIndex = source.indexOf(start, from);
    if (declIndex < 0) return;
    final block = _block(source, start, from: from);
    yield block;
    from = source.indexOf(block, declIndex) + block.length;
  }
}

void main() {
  final ucc = File(_uccPath).readAsStringSync();
  final view = File(_viewPath).readAsStringSync();

  group('issue #398 R1 — updateContentWorldsCreatorScript guard', () {
    final body = _block(ucc, 'private void updateContentWorldsCreatorScript()');

    test(
      'addDocumentStartJavaScript is wrapped in try/catch (RuntimeException)',
      () {
        final tryBlock = _block(body, _tryPattern);
        expect(tryBlock, contains('WebViewCompat.addDocumentStartJavaScript'));
        expect(_catchPattern.hasMatch(body), isTrue);
      },
    );

    test('on failure the handler is released so a later add can retry', () {
      final catchBlock = _block(body, _catchPattern);
      expect(catchBlock, contains('contentWorldsCreatorScript = null'));
    });

    test('the failure is logged', () {
      final catchBlock = _block(body, _catchPattern);
      expect(catchBlock, contains('Log.e('));
    });
  });

  group('issue #398 R2 — addUserOnlyScript guard', () {
    final body = _block(ucc, 'public boolean addUserOnlyScript(');

    test('addDocumentStartJavaScript and the map put are inside one try', () {
      final tryBlock = _block(body, _tryPattern);
      expect(tryBlock, contains('WebViewCompat.addDocumentStartJavaScript'));
      expect(tryBlock, contains('scriptHandlerMap.put'));
      expect(_catchPattern.hasMatch(body), isTrue);
    });

    test(
      'the failure is logged and leaves the script out of scriptHandlerMap',
      () {
        final catchBlock = _block(body, _catchPattern);
        expect(catchBlock, contains('Log.e('));
        expect(catchBlock, isNot(contains('scriptHandlerMap.put')));
      },
    );
  });

  group('issue #398 R3 — addPluginScript guard', () {
    final body = _block(ucc, 'public boolean addPluginScript(');

    test('addDocumentStartJavaScript and the map put are inside one try', () {
      final tryBlock = _block(body, _tryPattern);
      expect(tryBlock, contains('WebViewCompat.addDocumentStartJavaScript'));
      expect(tryBlock, contains('scriptHandlerMap.put'));
      expect(_catchPattern.hasMatch(body), isTrue);
    });

    test(
      'the failure is logged and leaves the script out of scriptHandlerMap',
      () {
        final catchBlock = _block(body, _catchPattern);
        expect(catchBlock, contains('Log.e('));
        expect(catchBlock, isNot(contains('scriptHandlerMap.put')));
      },
    );
  });

  group('issue #398 R4 — deferred bridge registration Runnable guard', () {
    test('the posted Runnable that registers the JS bridge and user scripts is '
        'guarded by try/catch (RuntimeException) and logs', () {
      final runnables = _blocks(
        view,
        'post(new Runnable',
      ).where((b) => b.contains('prepareAndAddUserScripts')).toList();
      expect(
        runnables,
        hasLength(1),
        reason: 'the deferred-registration Runnable must be unique',
      );
      final runnable = runnables.single;
      expect(runnable, contains('addJavascriptInterface('));
      // The bridge registration and the script preparation are guarded by
      // separate try/catch (RuntimeException) blocks so the two failure
      // classes stay distinguishable in the logs.
      final bridgeTry = _block(runnable, _tryPattern);
      expect(bridgeTry, contains('addJavascriptInterface('));
      final scriptsTry = _block(
        runnable,
        _tryPattern,
        from: runnable.indexOf(bridgeTry) + bridgeTry.length,
      );
      expect(scriptsTry, contains('prepareAndAddUserScripts()'));
      expect(_catchPattern.allMatches(runnable), hasLength(2));
      final catchBlock = _block(runnable, _catchPattern);
      expect(catchBlock, contains('Log.e('));
    });
  });

  group('issue #398 R5 — dispose() no longer clears the app-wide cache', () {
    test('dispose() clears history but never calls clearCache', () {
      final dispose = _block(view, 'public void dispose()');
      expect(dispose, contains('clearHistory()'));
      expect(
        dispose.contains('clearCache('),
        isFalse,
        reason:
            'the WebView HTTP cache is per-application: clearing it on every '
            'disposal wipes the cache of every other WebView in the app; '
            'explicit clearing stays available via clearAllCache()',
      );
    });
  });
}
