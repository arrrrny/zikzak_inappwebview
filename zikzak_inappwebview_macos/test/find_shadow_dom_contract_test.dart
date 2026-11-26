// Bug #1155 macOS find-in-page regression contract (source-level).
//
// The macOS find is a JavaScript DOM-walk bridge
// (FindInteractionJS.swift). Two user-visible symptoms on the GitHub JSON
// viewer (a shadow-DOM / nested-root SPA) trace to that walker:
//
//   1. A term that is plainly visible is never matched (`gemini` not found)
//      because `_findAllAsyncForElement` recurses `element.childNodes` only —
//      the light DOM — and never descends into `element.shadowRoot` or a
//      same-origin iframe's `contentDocument`. Content rendered through a
//      shadow root is invisible to the walker.
//   2. The reported match count and the highlights `_findNext` cycles can
//      disagree (`0/0` while arrows still move) because the two code paths
//      read `_searchResultCount` at different moments.
//
// Executable on any host (no Xcode required) — the #316/#328/#331
// source-contract precedent (see swift_platform_view_clipping_test.dart).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late String source;

  setUpAll(() {
    var dir = Directory.current;
    File? sourceFile;
    for (var hop = 0; hop < 6; hop++) {
      final candidate = File(
        '${dir.path}/macos/zikzak_inappwebview_macos/Sources/'
        'zikzak_inappwebview_macos/FindInteractionJS.swift',
      );
      if (candidate.existsSync()) {
        sourceFile = candidate;
        break;
      }
      final parent = dir.parent;
      if (parent.path == dir.path) break;
      dir = parent;
    }
    expect(
      sourceFile,
      isNotNull,
      reason:
          'FindInteractionJS.swift not found under or above '
          '${Directory.current.path}',
    );
    source = sourceFile!.readAsStringSync();
  });

  test(
    'find walker descends into shadow roots (visible shadow-DOM text is matched, #1155)',
    () {
      // The element-node branch must recurse into `element.shadowRoot` when
      // one exists, not only `element.childNodes`.
      expect(
        source,
        matches(
          RegExp(r'shadowRoot'),
        ),
        reason:
            'FindInteractionJS.swift never references shadowRoot — text '
            'rendered through a shadow DOM (GitHub JSON/blob viewer) is '
            'invisible to the find walker, so a visible term is not matched '
            '(#1155 symptom 1).',
      );
    },
  );

  test(
    'find walker descends into same-origin iframe documents (#1155)',
    () {
      // The element-node branch must also cross into a same-origin iframe's
      // `contentDocument` so text inside a nested browsing context is found.
      expect(
        source,
        matches(
          RegExp(r'contentDocument'),
        ),
        reason:
            'FindInteractionJS.swift never references contentDocument — '
            'text inside a same-origin iframe is invisible to the find '
            'walker (#1155 symptom 1, nested-root case).',
      );
    },
  );

  test(
    'find-all posts the final match count after the walk completes (#1155)',
    () {
      // `_findAllAsync` must set `_isDoneCounting = true` and post the result
      // in the same turn the count is final, so the reported numberOfMatches
      // equals what `_findNext` cycles (no lone `0/0`, #1155 symptom 2).
      final findAllBody = _functionBody(source, '_findAllAsync');
      expect(
        findAllBody,
        isNotNull,
        reason: '_findAllAsync function not found in FindInteractionJS.swift',
      );
      expect(
        findAllBody,
        contains('_isDoneCounting = true'),
        reason:
            '_findAllAsync must mark counting done before posting the result '
            'so the reported count is final (#1155 symptom 2).',
      );
      expect(
        findAllBody,
        contains('numberOfMatches'),
        reason:
            '_findAllAsync must post numberOfMatches with the result '
            'message (#1155 symptom 2).',
      );
    },
  );
}

/// The body of `window.<bridge>.<name> = function(...) { ... }`, brace-matched
/// from the first `{` after the named function. Returns null when absent.
String? _functionBody(String source, String name) {
  final at = source.indexOf('.$name = function');
  if (at < 0) return null;
  final open = source.indexOf('{', at);
  if (open < 0) return null;
  var depth = 0;
  for (var i = open; i < source.length; i++) {
    final ch = source[i];
    if (ch == '{') depth++;
    if (ch == '}') {
      depth--;
      if (depth == 0) return source.substring(open, i + 1);
    }
  }
  return null;
}