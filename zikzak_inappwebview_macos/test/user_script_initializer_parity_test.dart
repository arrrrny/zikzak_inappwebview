import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Issue #317 — macOS `UserScript` initializer
/// `init(source:injectionTime:forMainFrameOnly:in:)` not implemented.
///
/// The macOS `UserScript` subclass of `WKUserScript` declares its own
/// designated initializers, so Swift does NOT inherit the superclass
/// initializer `init(source:injectionTime:forMainFrameOnly:in:)` unless it is
/// explicitly overridden. The iOS package overrides it; macOS did not, which
/// is the initializer the issue reports as not implemented and the reason
/// `initialUserScripts` cannot round-trip with full `WKUserScript` API parity
/// on macOS.
///
/// These tests read the native macOS source and enforce iOS↔macOS initializer
/// parity, so the initializer named in #317 cannot silently regress.
void main() {
  final userScriptSwift = File(
    'macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/'
    'Types/UserScript.swift',
  );

  group('native macOS UserScript initializers (issue #317)', () {
    late String source;

    setUpAll(() {
      // `flutter test` runs with the package root as the working directory.
      expect(
        userScriptSwift.existsSync(),
        isTrue,
        reason: 'UserScript.swift not found relative to package root '
            '(cwd: ${Directory.current.path})',
      );
      source = userScriptSwift.readAsStringSync();
    });

    test('overrides init(source:injectionTime:forMainFrameOnly:)', () {
      expect(
        RegExp(
          r'public\s+override\s+init\(\s*'
          r'source:\s*String,\s*'
          r'injectionTime:\s*WKUserScriptInjectionTime,\s*'
          r'forMainFrameOnly:\s*Bool\s*\)',
        ).hasMatch(source),
        isTrue,
        reason: 'the base 3-argument WKUserScript initializer must be '
            'overridden by the UserScript subclass',
      );
    });

    test(
      'overrides init(source:injectionTime:forMainFrameOnly:in:) — #317',
      () {
        expect(
          RegExp(
            r'public\s+override\s+init\(\s*'
            r'source:\s*String,\s*'
            r'injectionTime:\s*WKUserScriptInjectionTime,\s*'
            r'forMainFrameOnly:\s*Bool,\s*'
            r'in\s+contentWorld:\s*WKContentWorld\s*\)',
          ).hasMatch(source),
          isTrue,
          reason:
              'the contentWorld initializer without groupName, named in issue '
              '#317, must be implemented on macOS for iOS parity; a subclass '
              'that declares designated initializers does not inherit it',
        );
      },
    );

    test('declares init(groupName:source:injectionTime:forMainFrameOnly:)', () {
      expect(
        RegExp(
          r'public\s+init\(\s*'
          r'groupName:\s*String\?,\s*'
          r'source:\s*String,\s*'
          r'injectionTime:\s*WKUserScriptInjectionTime,\s*'
          r'forMainFrameOnly:\s*Bool\s*\)',
        ).hasMatch(source),
        isTrue,
        reason: 'groupName-tracking initializer (issue #197 support) '
            'must remain declared',
      );
    });

    test(
      'declares init(groupName:source:injectionTime:forMainFrameOnly:in:)',
      () {
        expect(
          RegExp(
            r'public\s+init\(\s*'
            r'groupName:\s*String\?,\s*'
            r'source:\s*String,\s*'
            r'injectionTime:\s*WKUserScriptInjectionTime,\s*'
            r'forMainFrameOnly:\s*Bool,\s*'
            r'in\s+contentWorld:\s*WKContentWorld\s*\)',
          ).hasMatch(source),
          isTrue,
          reason: 'groupName + contentWorld initializer must remain declared',
        );
      },
    );

    test('the #317 override delegates to super with the contentWorld form', () {
      // The override body must chain to
      // `super.init(source:injectionTime:forMainFrameOnly:in:contentWorld:)`
      // and record the content world, exactly like the iOS implementation.
      final overrideWithContentWorld = RegExp(
        r'public\s+override\s+init\(\s*'
        r'source:\s*String,\s*'
        r'injectionTime:\s*WKUserScriptInjectionTime,\s*'
        r'forMainFrameOnly:\s*Bool,\s*'
        r'in\s+contentWorld:\s*WKContentWorld\s*\)\s*\{([\s\S]*?)\n    \}',
      );
      final match = overrideWithContentWorld.firstMatch(source);
      expect(match, isNotNull, reason: '#317 initializer must exist');
      final body = match!.group(1)!;
      expect(
        body,
        contains('super.init('),
        reason: 'must chain to the WKUserScript superclass initializer',
      );
      expect(
        body,
        contains('in: contentWorld'),
        reason: 'must chain to the contentWorld superclass initializer form',
      );
      expect(
        body,
        contains('self.contentWorld = contentWorld'),
        reason: 'must record the content world like the iOS implementation',
      );
    });

    test('fromMap keeps deserializing contentWorld scripts over the channel',
        () {
      // Guard the platform-channel deserialization entry point that the
      // issue's crash flows through: it must keep constructing UserScript
      // values with the contentWorld form when the map carries one.
      expect(source, contains('public static func fromMap(map:'));
      expect(source, contains('WKContentWorld.fromMap(map: contentWorldMap)'));
      expect(
        source,
        contains('forMainFrameOnly: forMainFrameOnly, in: contentWorld)'),
        reason: 'fromMap must construct contentWorld-carrying scripts via the '
            'contentWorld initializer form',
      );
    });
  });
}
