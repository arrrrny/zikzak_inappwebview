// Bug #460 regression contract: on iOS, `await HeadlessInAppWebView.run()`
// never completed for an instance created with settings and callbacks but no
// `initialUrlRequest`, `initialFile`, or `initialData`.
//
// `HeadlessInAppWebViewManager.run(...)` installed
// `webView.firstNavigationCompleted` and deferred its FlutterResult to that
// signal. The signal fires only from `didFinish` / `didFail`, and
// `FlutterWebViewController.load(...)` starts a navigation only for initial
// file/data/URL input — with all three absent it starts nothing, so the signal
// could never fire and the Dart `run()` future stayed pending for the life of
// the process (the caller's later `loadUrl` was never reached).
//
// The fix mirrors the Android manager, which has always completed immediately
// on that branch ("nothing to wait for if no initial load was requested"). A
// later `loadUrl` cannot be dropped by completing early: every load is queued
// behind `InAppWebView`'s own WebContent readiness gate (`performLoad`).
//
// This test encodes that contract as a source scan so the bug class cannot
// silently return; it is executable on any host (no Xcode required), the same
// gate style the package already ships for native parity bugs
// (content_blockers_initial_load_test.dart, swift_platform_view_clipping_test.dart).
// The behavioural companion is
// `zikzak_inappwebview/example/integration_test/headless_no_initial_load_test.dart`,
// which drives the real native manager on the iOS Simulator.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Source text with comments removed, string literals PRESERVED, and all
/// whitespace runs collapsed to single spaces. Comment stripping handles
/// Swift block-comment nesting, line comments and triple-quoted strings.
String stripCommentsKeepStrings(String source) {
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
      out.write('  ');
      i += 2;
      continue;
    }
    if (rest.startsWith('//')) {
      final end = source.indexOf('\n', i);
      i = end == -1 ? source.length : end;
      continue;
    }
    if (rest.startsWith('"""')) {
      final end = source.indexOf('"""', i + 3);
      out.write(source.substring(i, end == -1 ? source.length : end + 3));
      i = end == -1 ? source.length : end + 3;
      continue;
    }
    if (source[i] == '"') {
      // Regular string literal: keep content, skip escapes.
      out.write('"');
      var j = i + 1;
      while (j < source.length) {
        if (source[j] == r'\') {
          out.write(source.substring(j, j + 2));
          j += 2;
          continue;
        }
        out.write(source[j]);
        if (source[j] == '"') {
          j++;
          break;
        }
        j++;
      }
      i = j;
      continue;
    }
    out.write(source[i]);
    i++;
  }
  return out.toString().replaceAll(RegExp(r'\s+'), ' ');
}

/// Extracts the body of the function whose declaration matches [signature]
/// by brace matching on [source] (a comment-stripped, whitespace-collapsed
/// text). Returns null when the declaration is absent.
String? functionBody(String source, String signature) {
  final declStart = source.indexOf(signature);
  if (declStart == -1) return null;
  final openBrace = source.indexOf('{', declStart + signature.length);
  if (openBrace == -1) return null;
  var depth = 0;
  for (var i = openBrace; i < source.length; i++) {
    if (source[i] == '{') {
      depth++;
    } else if (source[i] == '}') {
      depth--;
      if (depth == 0) {
        return source.substring(openBrace + 1, i);
      }
    }
  }
  return null;
}

void main() {
  // `flutter test` runs with the package root as the working directory.
  final managerSwift = File(
    'ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/'
    'HeadlessInAppWebView/HeadlessInAppWebViewManager.swift',
  );
  final controllerSwift = File(
    'ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/'
    'InAppWebView/FlutterWebViewController.swift',
  );

  group('iOS headless run() with no initial load (issue #460)', () {
    late String managerCode;
    late String controllerCode;

    setUpAll(() {
      expect(
        managerSwift.existsSync(),
        isTrue,
        reason:
            'HeadlessInAppWebViewManager.swift not found relative to package '
            'root (cwd: ${Directory.current.path})',
      );
      expect(
        controllerSwift.existsSync(),
        isTrue,
        reason:
            'FlutterWebViewController.swift not found relative to package '
            'root (cwd: ${Directory.current.path})',
      );
      managerCode = stripCommentsKeepStrings(managerSwift.readAsStringSync());
      controllerCode = stripCommentsKeepStrings(
        controllerSwift.readAsStringSync(),
      );
    });

    test('R1: run() completes by itself when no initial load is requested '
        '— #460', () {
      final body = functionBody(
        managerCode,
        'func run(id: String, params: [String: Any?]',
      );
      expect(
        body,
        isNotNull,
        reason:
            'HeadlessInAppWebViewManager.run(id:params:completion:) must '
            'exist — it is the native handler behind HeadlessInAppWebView.run()',
      );

      expect(
        body!,
        contains('hasInitialLoad'),
        reason:
            'run() must ask whether an initial navigation will actually be '
            'issued before arming a navigation-based gate — with no initial '
            'file/data/URL, `load(...)` starts nothing, so a gate armed on '
            '`firstNavigationCompleted` can never fire and run() hangs forever '
            '(#460)',
      );

      final idxDecide = body.indexOf('hasInitialLoad');
      final idxGate = body.indexOf('firstNavigationCompleted');
      expect(
        idxGate,
        isNot(equals(-1)),
        reason:
            'The initial-load readiness gate must stay armed for instances '
            'that DO request an initial load (acceptance criterion 2 of #460)',
      );
      expect(
        idxDecide,
        lessThan(idxGate),
        reason:
            'The no-initial-load decision must be made BEFORE the navigation '
            'gate is installed — arming the gate first is exactly the #460 '
            'hang',
      );

      final noLoadIndex = body.indexOf('!hasInitialLoad');
      expect(
        noLoadIndex,
        isNot(equals(-1)),
        reason:
            'There must be an explicit no-initial-load branch: that is the '
            'branch that hands control back to the caller instead of waiting '
            'for a navigation event that can never arrive',
      );
      expect(
        body.indexOf('completion()', noLoadIndex),
        isNot(equals(-1)),
        reason:
            'The no-initial-load branch must complete run() on its own: '
            'deferring it to a navigation event is the #460 hang. Android '
            'already does this ("nothing to wait for if no initial load was '
            'requested"), and a later loadUrl is still safe because every load '
            'is queued behind InAppWebView.performLoad\'s WebContent readiness '
            'gate',
      );
    });

    test('R2: the initial-load navigation gate is left intact — #460 '
        '(acceptance criterion 2)', () {
      final body = functionBody(
        managerCode,
        'func run(id: String, params: [String: Any?]',
      )!;

      expect(
        body,
        contains('flutterWebView.makeInitialLoad'),
        reason:
            'run() must still issue the initial load for instances that '
            'request one — the fix must not drop the load to make the gate '
            'pass',
      );
      final idxGate = body.indexOf('firstNavigationCompleted');
      expect(
        idxGate,
        isNot(equals(-1)),
        reason:
            'The navigation gate must stay armed for instances that DO '
            'request an initial load (acceptance criterion 2 of #460)',
      );
      // A makeInitialLoad AFTER the gate arm proves the loading path still
      // arms the gate before issuing its navigation — otherwise a fast
      // didFinish could be missed and run() would hang the other way.
      expect(
        body.indexOf('makeInitialLoad(params:', idxGate),
        isNot(equals(-1)),
        reason:
            'The gate must still be armed BEFORE the initial load is issued on '
            'the loading path, or a fast didFinish could be missed and run() '
            'would hang for initial-load instances (regressing #460 the other '
            'way)',
      );
      expect(
        body,
        contains('gateFired'),
        reason:
            'The once-only guard on the navigation gate must stay: didFinish '
            'and didFail can both fire for one navigation',
      );
    });

    test('R3: hasInitialLoad mirrors the loader\'s own conditions — #460', () {
      final helper = functionBody(
        controllerCode,
        'static func hasInitialLoad(params: NSDictionary)',
      );
      expect(
        helper,
        isNotNull,
        reason:
            'FlutterWebViewController.hasInitialLoad(params:) must exist next '
            'to `load(...)` — the place the initial navigation is actually '
            'decided — so the readiness gate and the loader cannot disagree',
      );
      for (final key in [
        '"initialFile"',
        '"initialData"',
        '"initialUrlRequest"',
      ]) {
        expect(
          helper!,
          contains(key),
          reason:
              'hasInitialLoad must consider $key: `load(...)` starts a '
              'navigation for each of these three inputs',
        );
      }

      final loadBody = functionBody(controllerCode, 'func load(');
      expect(
        loadBody,
        isNotNull,
        reason: 'FlutterWebViewController.load(...) must still exist',
      );
      // `load(...)` takes these as PARAMETERS, so its branches prove the
      // initial URL/file/data paths by consuming the names it was given.
      for (final branch in [
        'try webView.loadFile(assetFilePath: initialFile)',
        'webView.loadData(',
        'webView.loadUrl(urlRequest: urlRequest',
      ]) {
        expect(
          loadBody!,
          contains(branch),
          reason:
              'load(...) must keep its $branch branch: the issue asks for the '
              'existing initial URL/file/data readiness behaviour to remain '
              'intact',
        );
      }
    });

    test('R4: the no-initial-load branch does not invent a timeout constant '
        '— #460', () {
      final body = functionBody(
        managerCode,
        'func run(id: String, params: [String: Any?]',
      )!;

      expect(
        body,
        isNot(contains('asyncAfter')),
        reason:
            'The fix must be signal/condition-driven, not a magic timeout: a '
            'timer that fires late would complete run() before the WebView '
            'exists, and one that fires early would report a hang as success',
      );
      expect(
        body,
        isNot(contains('Timer.scheduledTimer')),
        reason: 'Same rule as above: no timeout constant in the gate (#460)',
      );
    });
  });
}
