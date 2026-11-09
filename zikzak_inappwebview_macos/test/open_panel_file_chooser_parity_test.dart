// Bug #408 regression contract: `<input type="file">` is dead on macOS —
// WKWebView asks its WKUIDelegate for a picker via
// `webView(_:runOpenPanelWith:...)`; the delegate never implemented it, so
// WebKit dropped the activation and no NSOpenPanel ever appeared. File
// uploads were impossible in every app embedding the macOS webview.
//
// This test encodes the fix as a source scan so the delegate method cannot
// silently disappear; it is executable on any host (no Xcode required).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Strips line/block comments and string literals so only real code tokens
/// are scanned. Ported from the package's swift_sourceframe_kvc_test; handles
/// Swift block-comment nesting and triple-quoted strings.
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

/// Extracts the body of the first Swift function whose (comment-stripped)
/// source contains [marker], brace-matched from the opening `{` that follows
/// the marker's enclosing declaration.
String? functionBodyContaining(String strippedSource, String marker) {
  final idx = strippedSource.indexOf(marker);
  if (idx == -1) return null;
  return bracedBlockFrom(
    source: strippedSource,
    braceStart: strippedSource.indexOf('{', idx),
  );
}

/// Brace-matches the block starting at [braceStart], skipping Swift string
/// literals (incl. triple-quoted), line comments and (nested) block comments.
String? bracedBlockFrom({required String source, required int braceStart}) {
  if (braceStart < 0 || braceStart >= source.length) return null;
  var depth = 0;
  var i = braceStart;
  while (i < source.length) {
    final ch = source[i];
    final rest = source.substring(i);
    if (rest.startsWith('/*')) {
      // Block comment (Swift nests them).
      var blockDepth = 0;
      while (i < source.length) {
        final r = source.substring(i);
        if (r.startsWith('/*')) {
          blockDepth++;
          i += 2;
        } else if (r.startsWith('*/')) {
          blockDepth--;
          i += 2;
          if (blockDepth == 0) break;
        } else {
          i++;
        }
      }
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
      continue;
    }
    if (ch == '"') {
      var j = i + 1;
      while (j < source.length) {
        if (source[j] == r'\') {
          j += 2;
          continue;
        }
        if (source[j] == '"' || source[j] == '\n') break;
        j++;
      }
      i = j + 1;
      continue;
    }
    if (ch == '{') {
      depth++;
    } else if (ch == '}') {
      depth--;
      if (depth == 0) {
        return source.substring(braceStart, i + 1);
      }
    }
    i++;
  }
  return null;
}

void main() {
  final packageDir = Directory.current.path;
  final sourcesDir = Directory(
    '$packageDir/macos/zikzak_inappwebview_macos/Sources/'
    'zikzak_inappwebview_macos',
  );

  late String inAppWebViewSwift;

  setUpAll(() {
    expect(
      sourcesDir.existsSync(),
      isTrue,
      reason:
          'Swift sources dir not found relative to package root '
          '(cwd: $packageDir)',
    );
    inAppWebViewSwift = stripSwiftNonCode(
      File('${sourcesDir.path}/InAppWebView.swift').readAsStringSync(),
    );
  });

  group('open panel / file input chooser (bug #408)', () {
    test('AC1: InAppWebView implements the WKUIDelegate open-panel method', () {
      final body = functionBodyContaining(
        inAppWebViewSwift,
        'runOpenPanelWith parameters: WKOpenPanelParameters',
      );
      expect(
        body,
        isNotNull,
        reason:
            'WKWebView asks the UI delegate for a file picker via '
            'webView(_:runOpenPanelWith:...); without the implementation '
            'WebKit drops the <input type="file"> activation and no panel '
            'ever opens (issue #408)',
      );
      expect(
        inAppWebViewSwift,
        contains('completionHandler: @escaping ([URL]?) -> Void'),
      );
    });

    test(
      'AC2: the delegate method maps WKOpenPanelParameters onto NSOpenPanel',
      () {
        final body = functionBodyContaining(
          inAppWebViewSwift,
          'runOpenPanelWith parameters: WKOpenPanelParameters',
        );
        expect(body, isNotNull);
        expect(
          body!,
          contains('NSOpenPanel()'),
          reason: 'the default presentation must be a real NSOpenPanel',
        );
        expect(
          body,
          contains(
            'allowsMultipleSelection = parameters.allowsMultipleSelection',
          ),
          reason:
              'the panel must honor the multiple-selection flag WebKit '
              'derives from the input element',
        );
        expect(
          body,
          contains('canChooseFiles = true'),
          reason: 'a file input picks files',
        );
        expect(
          body,
          contains('canChooseDirectories = false'),
          reason:
              'a file input must not pick directories — the other half of '
              'the mapping this AC pins',
        );
      },
    );

    test('AC3: OK resolves with the picked URLs, cancel resolves with nil', () {
      final body = functionBodyContaining(
        inAppWebViewSwift,
        'runOpenPanelWith parameters: WKOpenPanelParameters',
      );
      expect(body, isNotNull);
      final b = body!;
      expect(
        b,
        contains('completionHandler(urls)'),
        reason: 'a confirmed pick must hand the URLs back to WebKit',
      );
      expect(
        b,
        contains('completionHandler(nil)'),
        reason:
            'a cancel must also call the completion handler — leaving it '
            'uncalled hangs the activation',
      );
    });

    test('AC4: the panel presentation sits behind an injectable seam', () {
      final body = functionBodyContaining(
        inAppWebViewSwift,
        'runOpenPanelWith parameters: WKOpenPanelParameters',
      );
      expect(body, isNotNull);
      final b = body!;
      expect(
        inAppWebViewSwift,
        contains('openPanelPresenter'),
        reason:
            'CI substitutes a fixed-URL picker through the '
            'openPanelPresenter seam (issue #408 regression-test proposal)',
      );
      final seamIdx = b.indexOf('openPanelPresenter');
      final panelIdx = b.indexOf('NSOpenPanel()');
      expect(seamIdx, greaterThanOrEqualTo(0));
      expect(
        panelIdx,
        greaterThan(seamIdx),
        reason:
            'the injectable presenter must win over the default panel '
            'presentation',
      );
    });
  });
}
