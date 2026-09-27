// Bug #339 regression contract: `useOnDownloadStart` is dead on macOS —
// `onDownloadStartRequest` is never dispatched because the native Swift half
// of the download chain is missing entirely from the macOS package, while the
// same suite ships the full working chain on iOS in the exact same version.
// The Dart API and the settings flag exist (`InAppWebViewSettings.swift:9`
// declares `useOnDownloadStart`, the headless Dart params accept
// `onDownloadStartRequest`), but no Swift code reads the flag and no
// `WKDownload`/`WKDownloadDelegate` plumbing exists, so the event can never
// fire and the documented iOS/macOS parity contract is broken.
//
// This test encodes that rule as a source scan so the bug class cannot
// silently return; it is executable on any host (no Xcode required).
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

/// Like [functionBodyContaining] but searches the RAW source (needed when
/// the marker only appears inside a string literal, e.g.
/// `invokeMethod("shouldOverrideUrlLoading", ...)`). Braces inside string
/// literals and comments are skipped during matching.
String? functionBodyContainingRaw(String rawSource, String marker) {
  final idx = rawSource.indexOf(marker);
  if (idx == -1) return null;
  var braceStart = rawSource.indexOf('{', idx);
  if (braceStart == -1) return null;
  return bracedBlockFrom(source: rawSource, braceStart: braceStart);
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
  late String inAppWebViewSwiftRaw;
  late String channelDelegateSwift;
  late String channelDelegateSwiftRaw;

  setUpAll(() {
    expect(
      sourcesDir.existsSync(),
      isTrue,
      reason:
          'Swift sources dir not found relative to package root '
          '(cwd: $packageDir)',
    );
    final inAppWebViewRaw = File(
      '${sourcesDir.path}/InAppWebView.swift',
    ).readAsStringSync();
    inAppWebViewSwiftRaw = inAppWebViewRaw;
    inAppWebViewSwift = stripSwiftNonCode(inAppWebViewRaw);
    channelDelegateSwiftRaw = File(
      '${sourcesDir.path}/WebViewChannelDelegate.swift',
    ).readAsStringSync();
    channelDelegateSwift = stripSwiftNonCode(channelDelegateSwiftRaw);
  });

  group('onDownloadStartRequest iOS↔macOS parity (bug #339)', () {
    test('AC1: a DownloadStartRequest Swift type exists in the macOS package '
        'and maps the documented event payload fields', () {
      final typeFile = File(
        '${sourcesDir.path}/Types/DownloadStartRequest.swift',
      );
      expect(
        typeFile.existsSync(),
        isTrue,
        reason:
            'the macOS package must ship the DownloadStartRequest type '
            '(iOS has it at Types/DownloadStartRequest.swift)',
      );
      final raw = typeFile.readAsStringSync();
      final code = stripSwiftNonCode(raw);
      expect(code, contains('class DownloadStartRequest: NSObject'));
      expect(code, contains('func toMap'));
      // The payload keys are string literals, so scan the raw source for
      // them (comment-stripping blanks string literals).
      for (final field in [
        '"url"',
        '"userAgent"',
        '"contentDisposition"',
        '"mimeType"',
        '"contentLength"',
        '"suggestedFilename"',
        '"textEncodingName"',
      ]) {
        expect(
          raw,
          contains(field),
          reason:
              'DownloadStartRequest.toMap() must expose $field to match '
              'the platform-interface entity the Dart side decodes',
        );
      }
    });

    test('AC2: macOS InAppWebView adopts WKDownloadDelegate', () {
      final classDecl = RegExp(
        r'public\s+class\s+InAppWebView\s*:\s*[^{]*WKDownloadDelegate',
      ).hasMatch(inAppWebViewSwift);
      expect(
        classDecl,
        isTrue,
        reason:
            'InAppWebView must adopt WKDownloadDelegate so WebKit can '
            'hand over downloads started via .download policy '
            '(iOS parity)',
      );
    });

    test('AC3: decidePolicyFor navigationResponse detects downloads and honors '
        'useOnDownloadStart', () {
      final body = functionBodyContaining(
        inAppWebViewSwift,
        'decidePolicyFor navigationResponse: WKNavigationResponse',
      );
      expect(
        body,
        isNotNull,
        reason:
            'InAppWebView must implement decidePolicyFor '
            'navigationResponse',
      );
      expect(
        body!,
        contains('useOnDownloadStart'),
        reason:
            'the setting flag must gate download detection; before the '
            'fix no Swift code read useOnDownloadStart',
      );
      expect(
        body,
        contains('canShowMIMEType'),
        reason:
            'non-displayable MIME types must take the .download path '
            '(iOS parity)',
      );
      expect(
        body,
        contains('decisionHandler(.download)'),
        reason:
            'a non-displayable response must be handed to WebKit\'s '
            'download pipeline instead of unconditionally .allow',
      );
      expect(
        body,
        contains('onDownloadStartRequest'),
        reason:
            'the fallback mime-type detection path must dispatch the '
            'onDownloadStartRequest event',
      );
    });

    test('AC4: WKDownloadDelegate destination callback dispatches the event '
        'and cancels the native download so Dart owns the bytes', () {
      final destination = functionBodyContaining(
        inAppWebViewSwift,
        'decideDestinationUsing response: URLResponse',
      );
      expect(
        destination,
        isNotNull,
        reason:
            'WKDownloadDelegate.download(_:decideDestinationUsing:...) '
            'must be implemented (iOS parity)',
      );
      expect(
        destination!,
        contains('onDownloadStartRequest'),
        reason: 'the destination callback must dispatch the event',
      );
      expect(
        destination,
        contains('completionHandler(nil)'),
        reason:
            'the native download must be cancelled (completionHandler'
            '(nil)) so the Dart side can stream the bytes itself, '
            'matching the iOS implementation',
      );

      final didBecome = functionBodyContaining(
        inAppWebViewSwift,
        'didBecome download: WKDownload',
      );
      expect(
        didBecome,
        isNotNull,
        reason:
            'webView(_:navigationResponse:didBecome:) must be '
            'implemented (iOS parity)',
      );
      expect(
        didBecome!,
        contains('onDownloadStartRequest'),
        reason: 'didBecome must dispatch the event',
      );
    });

    test('AC5: WebViewChannelDelegate bridges onDownloadStartRequest to the '
        'method channel', () {
      expect(
        channelDelegateSwift,
        contains(
          'public func onDownloadStartRequest(request: DownloadStartRequest)',
        ),
        reason:
            'the channel delegate must expose onDownloadStartRequest '
            '(iOS WebViewChannelDelegate.swift:768 parity)',
      );
      // The event name is a string literal — scan the raw source.
      expect(
        channelDelegateSwiftRaw,
        contains('invokeMethod("onDownloadStartRequest"'),
        reason: 'the bridge must invoke the onDownloadStartRequest method',
      );
    });

    test('AC6: shouldOverrideUrlLoading maps NavigationActionPolicy.DOWNLOAD '
        '(2) to .download instead of silently downgrading to .cancel', () {
      // The marker lives inside a string literal, so search the raw
      // source with the quoted literal (skips the comment mention above
      // the call); braces inside literals/comments are skipped.
      final body = functionBodyContainingRaw(
        inAppWebViewSwiftRaw,
        '"shouldOverrideUrlLoading"',
      );
      expect(
        body,
        isNotNull,
        reason: 'InAppWebView must dispatch shouldOverrideUrlLoading',
      );
      expect(
        body!,
        contains('policy = .download'),
        reason:
            'Dart policy 2 (DOWNLOAD) must resolve to '
            'WKNavigationActionPolicy.download (macOS 11.3+, below the '
            'macOS 12.0 floor), matching the Dart enum contract',
      );
      expect(
        body,
        isNot(contains('case 0, 2:')),
        reason:
            'the old `case 0, 2:` fallback that silently downgraded '
            'DOWNLOAD to CANCEL must be gone',
      );
      // Pin BOTH normalization branches: the Int branch and the NSNumber
      // branch must each map 2 to .download. (A mutant that downgrades only
      // the Int branch survives a bare `contains('policy = .download')`
      // because the NSNumber branch still satisfies it.)
      final intIdx = body.indexOf('if let action = result as? Int');
      expect(
        intIdx,
        isNot(-1),
        reason: 'the Int branch of the policy result handler must exist',
      );
      final intBlock = bracedBlockFrom(
        source: body,
        braceStart: body.indexOf('{', intIdx),
      );
      expect(
        intBlock,
        isNotNull,
        reason: 'the Int branch switch body must be extractable',
      );
      expect(
        intBlock!,
        contains('case 2:'),
        reason: 'the Int branch must handle policy value 2 (DOWNLOAD)',
      );
      expect(
        intBlock,
        contains('policy = .download'),
        reason:
            'the Int branch must resolve policy 2 to '
            'WKNavigationActionPolicy.download',
      );
      final nsIdx = body.indexOf('else if let action = result as? NSNumber');
      expect(
        nsIdx,
        isNot(-1),
        reason: 'the NSNumber normalization branch must exist',
      );
      final nsBlock = bracedBlockFrom(
        source: body,
        braceStart: body.indexOf('{', nsIdx),
      );
      expect(nsBlock, isNotNull);
      // Strip line comments BEFORE collapsing whitespace (after collapsing,
      // `//.*` would run to the end of the string), then normalize spaces.
      final nsNormalized = nsBlock!
          .replaceAll(RegExp(r'//[^\n]*'), '')
          .replaceAll(RegExp(r'\s+'), ' ');
      expect(
        nsNormalized,
        contains('case 2: policy = .download'),
        reason:
            'the NSNumber branch must resolve policy 2 to '
            'WKNavigationActionPolicy.download (the Flutter channel may '
            'surface the int as NSNumber on macOS)',
      );
    });

    test('AC7: the macOS Dart controller routes the onDownloadStartRequest '
        'channel event to the user callback', () {
      final controllerFile = File(
        '$packageDir/lib/src/in_app_webview/in_app_webview_controller.dart',
      );
      expect(controllerFile.existsSync(), isTrue);
      final code = controllerFile.readAsStringSync();
      expect(
        RegExp(r"case\s+'onDownloadStartRequest':").hasMatch(code),
        isTrue,
        reason:
            'MacOSInAppWebViewController.handleMethod must handle '
            "'onDownloadStartRequest'; without the case the Swift event "
            'falls into the default branch and the user callback never '
            'fires',
      );
      expect(
        code,
        contains('DownloadStartRequest.fromJson'),
        reason: 'the event payload must be decoded',
      );
    });
  });
}
