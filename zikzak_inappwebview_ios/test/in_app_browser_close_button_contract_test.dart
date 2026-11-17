// Issue #438 regression contract (iOS): `InAppBrowserSettings.hideCloseButton`
// had no single writer on the native side. The close button's presence was
// decided inline in `prepareWebView()` — which `loadView()` calls, i.e. before
// the controller is presented and before UIKit installs the navigation bar's
// items from `navigationItem` during the appearance transition — and a second,
// divergent writer lived in `setSettings()`, which assigned
// `navigationItem.rightBarButtonItems` wholesale and so dropped the menu button
// (and any `showAsAction` menu item) whenever `hideCloseButton` was toggled at
// runtime.
//
// The contract: ONE writer, `applyCloseButtonVisibility()`, that touches only
// the close button and leaves every other right-hand item alone, called from
// all three points that can change what is on screen —
//
//   * `prepareWebView()` (the initial state),
//   * `viewWillAppear(_:)` (re-applied once the navigation item is installed),
//   * `setSettings(...)` (the runtime update).
//
// Executable on any host (no Xcode required) — the #316/#328/#331/#349
// source-contract precedent. These read the Swift sources as text, so they are
// evidence about code shape; the CI `build-ios` job is what proves the package
// compiles.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _controllerPath =
    'ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/'
    'InAppBrowser/InAppBrowserWebViewController.swift';

File locate(String relativePath) {
  var dir = Directory.current;
  for (var hop = 0; hop < 5; hop++) {
    final candidate = File('${dir.path}/$relativePath');
    if (candidate.existsSync()) return candidate;
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  fail(
    'Could not locate $relativePath under or above '
    '${Directory.current.path}',
  );
}

/// Swift source with `//` line comments, nested `/* … */` blocks and string
/// literals removed, so only executable code is scanned — a commented-out
/// assignment or a doc comment can never satisfy a contract below.
String codeOnly(String source) {
  final out = StringBuffer();
  var i = 0;
  var blockDepth = 0;
  while (i < source.length) {
    if (blockDepth > 0) {
      if (source.startsWith('/*', i)) {
        blockDepth++;
        i += 2;
      } else if (source.startsWith('*/', i)) {
        blockDepth--;
        i += 2;
      } else {
        if (source[i] == '\n') out.write('\n');
        i++;
      }
      continue;
    }
    if (source.startsWith('/*', i)) {
      blockDepth = 1;
      i += 2;
      continue;
    }
    if (source.startsWith('//', i)) {
      while (i < source.length && source[i] != '\n') {
        i++;
      }
      continue;
    }
    if (source[i] == '"') {
      // Swift string literal: plain, raw (#"…"#) and triple-quoted forms.
      var hashes = 0;
      while (i < source.length && source[i] == '#') {
        hashes++;
        i++;
      }
      if (i >= source.length) break;
      final triple = source.startsWith('"""', i);
      final closing = triple ? '"""' : '"';
      final terminator = '$closing${'#' * hashes}';
      i += closing.length;
      while (i < source.length && !source.startsWith(terminator, i)) {
        if (source[i] == '\\' && !triple && hashes == 0) {
          i += 2;
        } else {
          if (source[i] == '\n') out.write('\n');
          i++;
        }
      }
      i += terminator.length;
      out.write('""');
      continue;
    }
    out.write(source[i]);
    i++;
  }
  return out.toString();
}

/// The body of the first function whose declaration starts with [signature],
/// brace-matched so nested closures and `if` blocks stay inside. Returns null
/// when the function is absent.
String? functionBody(String code, String signature) {
  final start = code.indexOf(signature);
  if (start < 0) return null;
  final open = code.indexOf('{', start);
  if (open < 0) return null;
  var depth = 0;
  for (var i = open; i < code.length; i++) {
    if (code[i] == '{') {
      depth++;
    } else if (code[i] == '}') {
      depth--;
      if (depth == 0) return code.substring(open + 1, i);
    }
  }
  return null;
}

void main() {
  late final String code;

  setUpAll(() {
    code = codeOnly(locate(_controllerPath).readAsStringSync());
  });

  group('close button visibility has one writer (FR-438)', () {
    test('applyCloseButtonVisibility exists and reads hideCloseButton', () {
      final body = functionBody(
        code,
        'func applyCloseButtonVisibility(hideCloseButton: Bool? = nil)',
      );
      expect(
        body,
        isNotNull,
        reason: 'the single writer of the close button presence is missing',
      );
      expect(body, contains('browserSettings?.hideCloseButton'));
      // It removes only the close button ...
      expect(body, contains('removeAll { \$0 === closeButton }'));
      // ... and re-inserts it at the front, never clobbering other items.
      expect(body, contains('insert(closeButton, at: 0)'));
      expect(body, contains('navigationItem.rightBarButtonItems = items'));
    });

    test('prepareWebView delegates instead of deciding inline', () {
      final body = functionBody(code, 'func prepareWebView()');
      expect(body, isNotNull);
      expect(
        body,
        contains('applyCloseButtonVisibility()'),
        reason: 'the initial state must go through the single writer',
      );
      expect(
        body,
        isNot(contains('if !browserSettings.hideCloseButton')),
        reason: 'the close button presence is decided in two places again',
      );
    });

    test('viewWillAppear re-applies it after the item is installed', () {
      final body = functionBody(code, 'func viewWillAppear(_ animated: Bool)');
      expect(
        body,
        isNotNull,
        reason: 'nothing re-applies the decision at appearance time',
      );
      expect(body, contains('super.viewWillAppear(animated)'));
      expect(body, contains('applyCloseButtonVisibility()'));
    });

    test('setSettings delegates instead of assigning the array wholesale', () {
      final body = functionBody(
        code,
        'func setSettings(newSettings: InAppBrowserSettings',
      );
      expect(body, isNotNull);
      expect(
        body,
        contains(
          'applyCloseButtonVisibility(hideCloseButton: '
          'newSettings.hideCloseButton)',
        ),
        reason: 'the runtime update must go through the single writer',
      );
      expect(
        body,
        isNot(contains('navigationItem.rightBarButtonItems =')),
        reason: 'setSettings still drops the menu button with the close button',
      );
    });

    test('every closeButton replacement removes the outgoing item first', () {
      // The identity dedupe in applyCloseButtonVisibility only recognises the
      // CURRENT closeButton, so a reassignment that leaves the previous item in
      // rightBarButtonItems renders a second, dead close button on the next
      // appearance (#439 review). Both reassignment sites must therefore drop
      // the outgoing item or route through a setter that does.
      final setter = functionBody(code, 'func setCloseButton(_ newButton: UIBarButtonItem)');
      expect(
        setter,
        isNotNull,
        reason: 'a single setter must own the outgoing-item removal',
      );
      expect(
        setter,
        matches(
          RegExp(
            r'removeAll\s*\{\s*\$0\s*===\s*closeButton\s*\}',
          ),
        ),
        reason: 'setCloseButton must remove the outgoing item from the bar',
      );

      final setSettings = functionBody(
        code,
        'func setSettings(newSettings: InAppBrowserSettings',
      );
      expect(
        setSettings,
        isNotNull,
        reason: 'setSettings must not reassign closeButton directly',
      );
      expect(
        setSettings,
        isNot(
          matches(
            RegExp(r'closeButton\s*=\s*UIBarButtonItem'),
          ),
        ),
        reason:
            'setSettings still reassigns closeButton, so a caption change '
            'leaves the old item in the bar (two close buttons)',
      );
      expect(
        setSettings,
        contains('setCloseButton('),
        reason: 'the caption replacement must go through the setter',
      );
      expect(
        setSettings,
        contains('setDefaultCloseButton()'),
        reason: 'the empty-caption replacement must go through setDefaultCloseButton',
      );

      final setDefault = functionBody(code, 'func setDefaultCloseButton()');
      expect(
        setDefault,
        isNotNull,
        reason: 'setDefaultCloseButton must not reassign closeButton directly',
      );
      expect(
        setDefault,
        isNot(
          matches(
            RegExp(r'closeButton\s*=\s*UIBarButtonItem'),
          ),
        ),
        reason:
            'setDefaultCloseButton still reassigns closeButton, so a reset '
            'leaves the old item in the bar (two close buttons)',
      );
      expect(
        setDefault,
        contains('setCloseButton('),
        reason: 'the default replacement must go through the setter',
      );

      final prepare = functionBody(code, 'func prepareWebView()');
      expect(prepare, isNotNull);
      expect(
        prepare,
        isNot(
          matches(
            RegExp(r'closeButton\s*=\s*UIBarButtonItem'),
          ),
        ),
        reason: 'prepareWebView still reassigns closeButton directly',
      );
      expect(
        prepare,
        contains('setCloseButton('),
        reason: 'the initial caption must go through the setter',
      );
    });

    test('the Swift settings class still parses hideCloseButton', () {
      final settings = locate(
        'ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/'
        'InAppBrowser/InAppBrowserSettings.swift',
      ).readAsStringSync();
      expect(codeOnly(settings), contains('var hideCloseButton = false'));
    });
  });
}
