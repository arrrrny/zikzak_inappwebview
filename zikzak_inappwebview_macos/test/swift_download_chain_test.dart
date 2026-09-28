// Issue #339 contract: the macOS package's `onDownloadStartRequest` event
// could never fire — the Dart callback and the `useOnDownloadStart` setting
// existed, but no native Swift download chain did (no WKDownload plumbing, no
// DownloadStartRequest type, no channel bridge; `decidePolicyFor
// navigationResponse` unconditionally allowed and `NavigationActionPolicy
// .DOWNLOAD` from `shouldOverrideUrlLoading` was downgraded to `.cancel`).
// The iOS sibling ships the full chain in the same suite, so this test
// encodes the mirrored contract as a source scan that is executable on any
// host (no Xcode required), in the style of swift_sourceframe_kvc_test.dart.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Strips line/block comments and string literals so only real code tokens
/// are scanned (same approach as swift_sourceframe_kvc_test.dart).
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

/// Comment-only variant: keeps string literals (AC1/AC6 assert on channel-map
/// keys and event names that only exist inside string literals) but strips
/// line/block comments so prose cannot satisfy the contract.
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
    if (source[i] == '"') {
      // copy the literal verbatim
      var j = i + 1;
      while (j < source.length) {
        if (source[j] == r'\') {
          j += 2;
          continue;
        }
        if (source[j] == '"' || source[j] == '\n') break;
        j++;
      }
      out.write(
        source.substring(i, j + 1 > source.length ? source.length : j + 1),
      );
      i = j + 1 > source.length ? source.length : j + 1;
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

/// Returns the brace-balanced body of the function whose declaration contains
/// [marker], starting from the first `{` at or after the marker.
String functionBody(String code, String marker) {
  final idx = code.indexOf(marker);
  if (idx == -1) return '';
  final open = code.indexOf('{', idx);
  if (open == -1) return '';
  var depth = 0;
  for (var i = open; i < code.length; i++) {
    if (code[i] == '{') depth++;
    if (code[i] == '}') {
      depth--;
      if (depth == 0) return code.substring(open, i + 1);
    }
  }
  return '';
}

void main() {
  final macosDir = packageMacosDir();
  final sourcesDir = Directory('${macosDir.path}/Sources');
  final inappwebviewSwift = stripSwiftNonCode(
    File(
      '${sourcesDir.path}/zikzak_inappwebview_macos/InAppWebView.swift',
    ).readAsStringSync(),
  );

  group('macOS download chain contract (issue #339)', () {
    test(
      'AC1: a DownloadStartRequest Swift type exists with the channel map keys',
      () {
        final candidates = <String>[];
        for (final e in sourcesDir.listSync(recursive: true)) {
          if (e is File && e.path.endsWith('.swift')) {
            final code = stripSwiftNonCode(e.readAsStringSync());
            if (code.contains('class DownloadStartRequest')) {
              candidates.add(e.path);
            }
          }
        }
        expect(
          candidates,
          hasLength(1),
          reason: 'exactly one DownloadStartRequest type expected',
        );
        final code = stripSwiftComments(
          File(candidates.first).readAsStringSync(),
        );
        for (final key in [
          'url',
          'userAgent',
          'contentDisposition',
          'mimeType',
          'contentLength',
          'suggestedFilename',
          'textEncodingName',
        ]) {
          expect(
            code.contains('"$key"'),
            isTrue,
            reason:
                'DownloadStartRequest.toMap must carry "$key" so the Dart '
                'DownloadStartRequest.fromJson can rebuild the entity '
                '(found in ${candidates.first})',
          );
        }
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test('AC2: InAppWebView adopts WKDownloadDelegate', () {
      final declMatch = RegExp(
        r'public class InAppWebView[^{]*WKDownloadDelegate[^{]*\{',
      ).firstMatch(inappwebviewSwift);
      expect(
        declMatch,
        isNotNull,
        reason:
            'the InAppWebView class declaration must conform to '
            'WKDownloadDelegate or no download callback can ever reach '
            'the channel',
      );
    });

    test('AC3: decidePolicyFor navigationResponse detects non-displayable '
        'responses and starts a download when useOnDownloadStart is on', () {
      final body = functionBody(
        inappwebviewSwift,
        'decidePolicyFor navigationResponse: WKNavigationResponse',
      );
      expect(
        body,
        isNotEmpty,
        reason: 'decidePolicyFor navigationResponse must exist',
      );
      expect(
        body.contains('canShowMIMEType'),
        isTrue,
        reason:
            'the response decision must consult canShowMIMEType (the '
            'iOS hook at InAppWebView.swift) instead of unconditionally '
            'allowing every navigation response',
      );
      expect(
        body.contains('.download'),
        isTrue,
        reason:
            'a response WebKit cannot display inline must resolve '
            'WKNavigationResponsePolicy.download so WebKit hands it to '
            'WKDownloadDelegate',
      );
      expect(
        body.contains('useOnDownloadStart'),
        isTrue,
        reason:
            'the download path must honor the useOnDownloadStart '
            'setting (it was declared but dead — issue #339)',
      );
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('AC4: WKDownloadDelegate callbacks dispatch onDownloadStartRequest to '
        'the channel delegate', () {
      expect(
        inappwebviewSwift.contains('decideDestinationUsing'),
        isTrue,
        reason:
            'download(_:decideDestinationUsing:) must be implemented or '
            'a started download has nowhere to report its response '
            '(iOS parity: InAppWebView.swift dispatches the event there '
            'and cancels the native transfer so Dart streams the bytes)',
      );
      expect(
        inappwebviewSwift.contains(
          'navigationResponse: WKNavigationResponse,\n        didBecome',
        ),
        isTrue,
        reason:
            'webView(_:navigationResponse:didBecome:) must be implemented: '
            'it is the callback WebKit invokes for a .download decision '
            'made in decidePolicyFor navigationResponse',
      );
      expect(
        inappwebviewSwift.contains(
          'navigationAction: WKNavigationAction,\n        didBecome',
        ),
        isTrue,
        reason:
            'webView(_:navigationAction:didBecome:) must be implemented: '
            'it is the callback WebKit invokes when shouldOverrideUrlLoading '
            'resolves NavigationActionPolicy.DOWNLOAD',
      );
      final didBecomeBodies = [
        functionBody(
          inappwebviewSwift,
          'navigationResponse: WKNavigationResponse,\n        didBecome',
        ),
        functionBody(
          inappwebviewSwift,
          'navigationAction: WKNavigationAction,\n        didBecome',
        ),
        functionBody(inappwebviewSwift, 'decideDestinationUsing'),
      ];
      for (final body in didBecomeBodies) {
        expect(
          body.contains('onDownloadStartRequest'),
          isTrue,
          reason:
              'every WKDownloadDelegate callback must dispatch '
              'onDownloadStartRequest (gated by useOnDownloadStart); '
              'body was: ${body.substring(0, body.length.clamp(0, 200))}',
        );
        expect(
          body.contains('useOnDownloadStart'),
          isTrue,
          reason:
              'the dispatch must be gated by the useOnDownloadStart '
              'setting, mirroring iOS',
        );
      }
    }, timeout: const Timeout(Duration(minutes: 2)));

    test(
      'AC5: shouldOverrideUrlLoading maps NavigationActionPolicy.DOWNLOAD (2) '
      'to .download, not .cancel',
      () {
        final body = functionBody(
          inappwebviewSwift,
          'decidePolicyFor navigationAction: WKNavigationAction',
        );
        expect(
          body,
          isNotEmpty,
          reason: 'decidePolicyFor navigationAction must exist',
        );
        final case2 = RegExp(r'case 2:\s*\n[^c]*?policy = \.download');
        expect(
          case2.hasMatch(body),
          isTrue,
          reason:
              'the Dart handler may return NavigationActionPolicy.DOWNLOAD '
              '(2); mapping it to .cancel silently blocks a navigation the '
              'user asked to download (issue #339 §5)',
        );
        expect(
          body.contains('not supported on macOS yet'),
          isFalse,
          reason: 'the stale downgrade comment must go with the fix',
        );
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test('AC6: WebViewChannelDelegate bridges onDownloadStartRequest to the '
        'method channel', () {
      final code = stripSwiftComments(
        File(
          '${sourcesDir.path}/zikzak_inappwebview_macos/WebViewChannelDelegate.swift',
        ).readAsStringSync(),
      );
      expect(
        code.contains(
          'func onDownloadStartRequest(request: DownloadStartRequest)',
        ),
        isTrue,
        reason:
            'the channel delegate must expose the typed bridge (iOS parity: '
            'WebViewChannelDelegate.swift onDownloadStartRequest)',
      );
      expect(
        code.contains('invokeMethod("onDownloadStartRequest"'),
        isTrue,
        reason:
            'the bridge must invoke the onDownloadStartRequest method on '
            'the Flutter channel — this is the event name the Dart '
            'controller dispatches on',
      );
    }, timeout: const Timeout(Duration(minutes: 2)));
  });
}
