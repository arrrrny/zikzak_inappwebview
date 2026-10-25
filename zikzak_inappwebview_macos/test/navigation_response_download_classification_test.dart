// Bug #374 regression contract: with `useOnDownloadStart` enabled, the macOS
// `decidePolicyFor navigationResponse` classified EVERY main-frame response
// whose MIME type did not start with `text/` as a download — it fired
// `onDownloadStartRequest` and cancelled the navigation, so JSON, image and
// PDF responses never rendered even though WebKit reports
// `canShowMIMEType == true` for them.
//
// WebKit's own rule is the one the other branch already uses: only hand a
// response to the download pipeline when the web view cannot show it, or when
// the server marks it as an attachment via `Content-Disposition`. This test
// encodes that rule as a source scan of the Swift delegate (the package's
// tests are source contracts — no Xcode or device required).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Strips line/block comments and string literals so only real code tokens
/// are scanned. Handles Swift block-comment nesting and triple-quoted
/// strings (same technique as `download_start_request_parity_test.dart`).
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

/// Brace-matches the block starting at [braceStart], skipping Swift string
/// literals (incl. triple-quoted), line comments and nested block comments.
String? bracedBlockFrom({required String source, required int braceStart}) {
  if (braceStart < 0 || braceStart >= source.length) return null;
  var depth = 0;
  var i = braceStart;
  while (i < source.length) {
    final ch = source[i];
    final rest = source.substring(i);
    if (rest.startsWith('/*')) {
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

String? bracedBlockAfter(String source, String marker) {
  final idx = source.indexOf(marker);
  if (idx == -1) return null;
  return bracedBlockFrom(source: source, braceStart: source.indexOf('{', idx));
}

void main() {
  final packageDir = Directory.current.path;
  final swiftFile = File(
    '$packageDir/macos/zikzak_inappwebview_macos/Sources/'
    'zikzak_inappwebview_macos/InAppWebView.swift',
  );

  late String raw;

  setUpAll(() {
    expect(
      swiftFile.existsSync(),
      isTrue,
      reason: 'macOS InAppWebView.swift not found from cwd $packageDir',
    );
    raw = swiftFile.readAsStringSync();
  });

  group('navigationResponse download classification (bug #374)', () {
    late String bodyRaw;
    late String bodyCode;

    setUpAll(() {
      bodyRaw =
          bracedBlockAfter(
            raw,
            'decidePolicyFor navigationResponse: WKNavigationResponse',
          ) ??
          '';
      bodyCode = stripSwiftNonCode(bodyRaw);
      expect(
        bodyRaw,
        isNotEmpty,
        reason:
            'InAppWebView must implement decidePolicyFor navigationResponse',
      );
    });

    test('a displayable response is not classified as a download by its MIME '
        'type', () {
      expect(
        bodyCode,
        isNot(contains('starts(with:')),
        reason:
            'the bug: the displayable branch keyed on '
            '`!mimeType.starts(with: "text/")`, so JSON/image/PDF main-frame '
            'responses were cancelled as downloads. Only canShowMIMEType == '
            'false may classify a response by its type',
      );
    });

    test(
      'the displayable branch still honors Content-Disposition: attachment',
      () {
        final mimeBranch = bracedBlockAfter(
          bodyRaw,
          'if !navigationResponse.canShowMIMEType',
        );
        expect(
          mimeBranch,
          isNotNull,
          reason: 'the non-displayable branch must survive the fix',
        );
        expect(
          mimeBranch!,
          contains('decisionHandler(.download)'),
          reason:
              'a response the web view cannot show must reach WebKit\'s '
              'download pipeline',
        );

        // Everything after the non-displayable branch is the displayable path
        // (written either as `else { … }` or as a sequential check); that is
        // where the classification rule lives.
        final afterMimeIdx = bodyRaw.indexOf(mimeBranch) + mimeBranch.length;
        final displayableRaw = bodyRaw.substring(afterMimeIdx);
        final displayableCode = stripSwiftNonCode(displayableRaw);
        expect(
          displayableRaw,
          isNotEmpty,
          reason:
              'the displayable path must exist after the canShowMIMEType '
              'branch',
        );

        expect(
          displayableCode,
          contains('forHTTPHeaderField:'),
          reason:
              'a displayable response may only be treated as a download when '
              'its headers say so — read Content-Disposition',
        );
        expect(
          displayableRaw,
          contains('"Content-Disposition"'),
          reason:
              'the attachment check must read the Content-Disposition header',
        );
        expect(
          displayableRaw.toLowerCase(),
          contains('"attachment"'),
          reason:
              'only a Content-Disposition of attachment may cancel a '
              'displayable navigation',
        );
        expect(
          displayableCode,
          contains('decisionHandler(.cancel)'),
          reason:
              'an attachment still has to be cancelled so the Dart side '
              'owns the bytes',
        );
        expect(
          displayableCode,
          contains('onDownloadStartRequest'),
          reason: 'an attachment still has to report onDownloadStartRequest',
        );
      },
    );

    test(
      'an attachment download reports the response own content disposition',
      () {
        expect(
          stripSwiftNonCode(bodyRaw).replaceAll(RegExp(r'\s+'), ' '),
          isNot(contains('contentDisposition: nil')),
          reason:
              'the attachment branch reads Content-Disposition; reporting nil '
              'would drop the only header that justified the download',
        );
      },
    );

    test('everything else falls through to decisionHandler(.allow)', () {
      expect(
        bodyCode,
        contains('decisionHandler(.allow)'),
        reason:
            'a displayable, non-attachment response must render in the '
            'web view (this is the #374 regression)',
      );
    });
  });
}
