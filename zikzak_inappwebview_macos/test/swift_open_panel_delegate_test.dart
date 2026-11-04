// Issue #408 regression contract: WKWebView answers an <input type="file">
// activation by asking its WKUIDelegate to run an open panel
// (webView:runOpenPanelWith:initiatedByFrame:completionHandler:). The macOS
// InAppWebView implemented the JS-dialog half of the panel family
// (runJavaScriptAlertPanelWithMessage / ...ConfirmPanel / ...TextInputPanel)
// but never the open panel, so WebKit got no answer and silently dropped the
// activation — every file input on every site was dead (no panel, no event,
// the input stayed empty; TikTok Studio upload did nothing).
//
// This test encodes the delegate contract as a source scan so the missing
// implementation cannot silently return; it is executable on any host (no
// Xcode required).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Strips line/block comments and string literals so only real code tokens
/// are scanned. Ported from the sibling swift_sourceframe_kvc_test (which
/// ports the iOS package's swift_availability_usage_test); handles Swift
/// block-comment nesting and triple-quoted strings.
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

List<File> swiftFilesUnder(Directory root) {
  final files = <File>[];
  for (final e in root.listSync(recursive: true)) {
    if (e is File && e.path.endsWith('.swift')) files.add(e);
  }
  files.sort((a, b) => a.path.compareTo(b.path));
  return files;
}

void main() {
  group('open panel delegate contract (issue #408)', () {
    test(
      'AC1: the WKUIDelegate implements runOpenPanelWith with the WebKit '
      'signature',
      () {
        final macosDir = packageMacosDir();
        final sourcesDir = Directory('${macosDir.path}/Sources');
        expect(sourcesDir.existsSync(), isTrue,
            reason: 'Swift sources dir missing: ${sourcesDir.path}');

        final implementations = <String>[];
        final signature = RegExp(
            r'runOpenPanelWith\s+parameters:\s*WKOpenPanelParameters');
        for (final file in swiftFilesUnder(sourcesDir)) {
          final code = stripSwiftNonCode(file.readAsStringSync());
          if (signature.hasMatch(code)) implementations.add(file.path);
        }

        expect(implementations, hasLength(1),
            reason:
                'WKWebView asks its UI delegate to run the open panel on '
                '<input type="file"> activations; without exactly one '
                'runOpenPanelWith implementation WebKit gets no answer and '
                'silently drops the activation — every file input on every '
                'site stays dead (issue #408). Expected it in InAppWebView.swift '
                'next to the JS-dialog panel implementations.');
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test(
      'AC2: the panel is a real NSOpenPanel driven by the page parameters '
      '(multiple / webkitdirectory)',
      () {
        final macosDir = packageMacosDir();
        final sourcesDir = Directory('${macosDir.path}/Sources');
        final code = swiftFilesUnder(sourcesDir)
            .map((f) => stripSwiftNonCode(f.readAsStringSync()))
            .firstWhere((c) => c.contains('runOpenPanelWith'));

        expect(code.contains('NSOpenPanel()'), isTrue,
            reason:
                'the implementation must present a real NSOpenPanel — the '
                'macOS open panel users expect when a site activates a file '
                'input (issue #408)');
        expect(code.contains('openPanel.allowsMultipleSelection = '
            'parameters.allowsMultipleSelection'), isTrue,
            reason:
                'the input\'s `multiple` attribute must map to the panel\'s '
                'allowsMultipleSelection');
        expect(code.contains('openPanel.canChooseFiles = true'), isTrue,
            reason: 'file uploads pick files, not directories, by default');
        expect(code.contains(
            'openPanel.canChooseDirectories = parameters.allowsDirectories'),
            isTrue,
            reason:
                'webkitdirectory inputs must map to the panel\'s '
                'allowsDirectories');
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test(
      'AC3: the completion handler fires exactly once — chosen URLs on OK, '
      'empty on cancel',
      () {
        final macosDir = packageMacosDir();
        final sourcesDir = Directory('${macosDir.path}/Sources');
        final code = swiftFilesUnder(sourcesDir)
            .map((f) => stripSwiftNonCode(f.readAsStringSync()))
            .firstWhere((c) => c.contains('runOpenPanelWith'));

        expect(code.contains('completionHandler(openPanel.urls)'), isTrue,
            reason:
                'a picked selection must reach WebKit via the completion '
                'handler, or the input stays empty even after the user '
                'confirms (issue #408)');
        expect(
            RegExp(
              r'else\s*\{\s*completionHandler\(\[\]\)',
              multiLine: true,
            ).hasMatch(code),
            isTrue,
            reason:
                'cancel/dismiss must complete with an empty selection so '
                'WebKit is never left waiting on an unanswered picker');
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test(
      'AC4: headless webviews fail fast instead of surfacing a GUI panel',
      () {
        final macosDir = packageMacosDir();
        final sourcesDir = Directory('${macosDir.path}/Sources');
        final code = swiftFilesUnder(sourcesDir)
            .map((f) => stripSwiftNonCode(f.readAsStringSync()))
            .firstWhere((c) => c.contains('runOpenPanelWith'));

        expect(code.contains('if isHeadlessOffscreen'), isTrue,
            reason:
                'a headless webview has no user to pick files: it must cancel '
                'with an empty selection instead of surfacing a GUI panel '
                'from an automation context (mirrors the PasskeyBridge '
                'headless handling)');
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}
