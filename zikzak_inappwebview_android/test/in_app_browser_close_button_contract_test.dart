// Issue #440 — the Android `InAppBrowserSettings.hideCloseButton` contract.
//
// The setting exists on the platform interface and on the wire (the entity
// emits `hideCloseButton` and `in_app_browser_close_button_wire_test.dart`
// pins that), but the Android side had no consumer: `InAppBrowserSettings`
// parsed 11 keys without it, and the close affordance (`R.id.action_close`)
// was gated by `hideDefaultMenuItems` alone — an all-or-nothing switch that
// also hides back/reload/forward/share.
//
// The contract below is about code SHAPE, not runtime behaviour, because this
// host has no Android SDK and no gradle wrapper: `zikzak_inappwebview_android`
// is outside the CI matrix and its Java is never compiled here. The precedent
// is `js_bridge_registration_guard_contract_test.dart` / the iOS
// `in_app_browser_close_button_contract_test.dart` (#438): a source contract is
// honest evidence about the shape of the fix, and the acceptance run on a
// device is what proves the behaviour.
//
// The shape it pins is the #439 one-writer shape: a single place resolves the
// close item's visibility, it is computed from BOTH flags, and it touches no
// other item — so a runtime `setSettings` toggle cannot diverge from the
// initial `onCreateOptionsMenu` state the way two inline writers did.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _settingsPath =
    'android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/'
    'in_app_browser/InAppBrowserSettings.java';
const _activityPath =
    'android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/'
    'in_app_browser/InAppBrowserActivity.java';

/// The menu items `hideDefaultMenuItems` owns; `action_close` is deliberately
/// not among them once `hideCloseButton` exists.
const _otherDefaultItems = [
  'action_go_back',
  'action_reload',
  'action_go_forward',
  'action_share',
];

File _locate(String relativePath) {
  var dir = Directory.current;
  for (var hop = 0; hop < 5; hop++) {
    final candidate = File('${dir.path}/$relativePath');
    if (candidate.existsSync()) return candidate;
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  fail(
    'Could not locate $relativePath under or above ${Directory.current.path}',
  );
}

/// Replaces the contents of Java comments and string/char literals with spaces,
/// preserving length so indices still map 1:1 onto [source]. Brace counting and
/// "is this item id referenced" questions run on this copy, so a commented-out
/// call or a mention inside a log message can never satisfy a contract.
String _masked(String source) {
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

/// The brace-balanced block that opens at the first `{` at or after the first
/// match of [start] in [source] (matched against a masked copy, so braces
/// inside comments or literals cannot unbalance it). The returned text is the
/// original source, so string literals survive for `R.id.*` lookups.
String _blockOf(String source, Pattern start, {int from = 0}) {
  final mask = _masked(source);
  final declIndex = mask.indexOf(start, from);
  if (declIndex < 0) fail('pattern not found: $start');
  final open = mask.indexOf('{', declIndex);
  var depth = 0;
  for (var i = open; i < mask.length; i++) {
    if (mask[i] == '{') {
      depth++;
    } else if (mask[i] == '}') {
      depth--;
      if (depth == 0) return source.substring(declIndex, i + 1);
    }
  }
  fail('unbalanced braces for pattern: $start');
}

/// A Java method declaration: line-anchored so a call, an `if`/`for` header
/// or an anonymous class instantiation cannot be mistaken for one, and the
/// visibility modifier is optional because a package-private writer is still a
/// method.
final _methodDecl = RegExp(
  r'^[ \t]*(?:(?:public|private|protected|static|final)\s+)*'
  r'[\w<>\[\],.?]+\s+(\w+)\s*\([^)]*\)\s*\{',
  multiLine: true,
);

/// Every method of [maskedSource] as `(name, body)`, where `body` is sliced
/// from the original source so literals stay readable.
List<({String name, String body})> _methods(String source) {
  final mask = _masked(source);
  final found = <({String name, String body})>[];
  for (final match in _methodDecl.allMatches(mask)) {
    final name = match.group(1)!;
    found.add((
      name: name,
      body: _blockOf(source, _methodDecl, from: match.start),
    ));
  }
  return found;
}

void main() {
  final settings = _locate(_settingsPath).readAsStringSync();
  final activity = _locate(_activityPath).readAsStringSync();
  final activityMask = _masked(activity);
  final methods = _methods(activity);

  String methodNamed(String name) {
    final matches = methods.where((m) => m.name == name).toList();
    expect(matches, hasLength(1), reason: 'expected exactly one $name method');
    return matches.single.body;
  }

  group('issue #440 — the settings map carries hideCloseButton', () {
    test('the field exists and defaults to false', () {
      expect(
        settings,
        matches(
          RegExp(r'Boolean\s+hideCloseButton\s*=\s*false\s*;'),
        ),
        reason: 'an absent key must keep the close button visible',
      );
    });

    test('parse reads the key off the wire', () {
      expect(
        settings,
        matches(
          RegExp(
            r'case\s+"hideCloseButton"\s*:\s*'
            r'hideCloseButton\s*=\s*\(Boolean\)\s*value\s*;',
          ),
        ),
      );
    });

    test('toMap reports it back so getSettings round-trips it', () {
      expect(settings, contains('settings.put("hideCloseButton"'));
    });
  });

  group('issue #440 — one writer decides the close item visibility', () {
    final closeSites = RegExp(
      r'findItem\(\s*R\.id\.action_close\s*\)',
    ).allMatches(activityMask).toList();

    test('exactly one site resolves the close menu item', () {
      expect(
        closeSites,
        hasLength(1),
        reason: 'two inline writers are how iOS diverged (#438); the '
            'visibility of action_close must be resolved in one place',
      );
    });

    test('the writer computes visibility from both flags', () {
      final site = closeSites.single;
      final writer = methods.singleWhere(
        (m) => m.body.contains('R.id.action_close'),
        orElse: () => fail(
          'the R.id.action_close site at offset ${site.start} is not inside a '
          'method',
        ),
      );
      final code = _masked(writer.body);
      expect(code, contains('setVisible('));
      expect(code, contains('hideCloseButton'));
      expect(
        code,
        contains('hideDefaultMenuItems'),
        reason: 'hideDefaultMenuItems keeps its all-items meaning',
      );
    });

    test('the writer touches no other menu item', () {
      final writer = methods.singleWhere(
        (m) => m.body.contains('R.id.action_close'),
      );
      final code = _masked(writer.body);
      for (final item in _otherDefaultItems) {
        expect(
          code,
          isNot(contains(item)),
          reason: 'hideCloseButton must not hide $item',
        );
      }
    });

    test('onCreateOptionsMenu applies it after the menu is inflated', () {
      final onCreate = methodNamed('onCreateOptionsMenu');
      final writerName = methods
          .singleWhere((m) => m.body.contains('R.id.action_close'))
          .name;
      final call = onCreate.indexOf('$writerName(');
      expect(call, isNonNegative, reason: 'the initial state must be applied');
      expect(
        call,
        greaterThan(onCreate.indexOf('inflate(')),
        reason: 'the menu item must exist before it is looked up',
      );
    });

    test('setSettings re-applies it, diff-guarded on hideCloseButton', () {
      final setSettings = methodNamed('setSettings');
      final writerName = methods
          .singleWhere((m) => m.body.contains('R.id.action_close'))
          .name;
      expect(setSettings, contains('newSettingsMap.get("hideCloseButton")'));
      expect(
        setSettings,
        contains('customSettings.hideCloseButton != '
            'newSettings.hideCloseButton'),
      );
      expect(setSettings, contains('$writerName('));
    });

    test('hideDefaultMenuItems still hides the other four items', () {
      final setSettings = methodNamed('setSettings');
      for (final item in _otherDefaultItems) {
        expect(
          setSettings,
          contains('R.id.$item'),
          reason: 'the all-items switch must keep owning $item',
        );
      }
      final onCreate = methodNamed('onCreateOptionsMenu');
      for (final item in _otherDefaultItems) {
        expect(onCreate, contains('R.id.$item'));
      }
    });
  });
}