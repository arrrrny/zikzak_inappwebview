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

/// Returns the brace-balanced block that opens at the first `{` at or after
/// the first match of [start] in [source], starting from [from].
String _block(String source, Pattern start, {int from = 0}) {
  final declIndex = source.indexOf(start, from);
  if (declIndex < 0) {
    fail('pattern not found: $start');
  }
  final open = source.indexOf('{', declIndex);
  var depth = 0;
  for (var i = open; i < source.length; i++) {
    if (source[i] == '{') {
      depth++;
    } else if (source[i] == '}') {
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
      final tryBlock = _block(runnable, _tryPattern);
      expect(tryBlock, contains('addJavascriptInterface('));
      expect(tryBlock, contains('prepareAndAddUserScripts()'));
      expect(_catchPattern.hasMatch(runnable), isTrue);
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
