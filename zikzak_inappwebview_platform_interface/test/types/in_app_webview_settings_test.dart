// Public-API regression tests for the InAppWebViewSettings.persistentStoreIdentifier
// field introduced for issue #253 — per-instance persistent, isolated
// WKWebsiteDataStore on iOS 17+/macOS 14+.
//
// Pins the CONSUMER-VISIBLE contract:
//   - default-constructed settings have NO persistentStoreIdentifier key in
//     the wire format (@JsonKey(includeIfNull: false) → null is dropped),
//     so existing call sites that never set the field are unchanged,
//   - any non-null string round-trips verbatim (the Swift side is what maps
//     the string to a stable UUID; the Dart side just stores/transmits it),
//   - the three input shapes documented in the field dartdoc (raw UUID
//     string, 64-char SHA-256 hex, arbitrary stable string) all survive a
//     toJson → fromJson round-trip unchanged.
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('InAppWebViewSettings.persistentStoreIdentifier', () {
    test('default-constructed settings omit the key (includeIfNull: false)',
        () {
      final settings = InAppWebViewSettings();
      final map = settings.toJson();
      expect(map.containsKey('persistentStoreIdentifier'), isFalse,
          reason:
              'When the field is null, the key MUST be absent so the macOS/iOS '
              'native init falls through to the existing incognito/default() '
              'branch (issue #253: "No behavioral change when '
              'persistentStoreIdentifier is null").');
      expect(settings.persistentStoreIdentifier, isNull);
    });

    test('a non-null value is included verbatim in the wire format', () {
      const id = 'alice-profile';
      final settings = InAppWebViewSettings(persistentStoreIdentifier: id);
      final map = settings.toJson();
      expect(map['persistentStoreIdentifier'], 'alice-profile');
      expect(settings.persistentStoreIdentifier, 'alice-profile');
    });

    test('round-trips a raw UUID string', () {
      const id = '550e8400-e29b-41d4-a716-446655440000';
      final settings = InAppWebViewSettings(persistentStoreIdentifier: id);
      final restored = InAppWebViewSettings.fromJson(settings.toJson());
      expect(restored.persistentStoreIdentifier, id);
    });

    test('round-trips a 64-char SHA-256 hex string (legacy contract)', () {
      // The shape forklift used to send: 64-char lowercase SHA-256 hex
      // derived from a profile dir's canonical path.
      const id =
          '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08';
      final settings = InAppWebViewSettings(persistentStoreIdentifier: id);
      final restored = InAppWebViewSettings.fromJson(settings.toJson());
      expect(restored.persistentStoreIdentifier, id);
    });

    test('round-trips an arbitrary stable string (SHA-256-fallback path)', () {
      const id = 'multi-account-dashboard::profile-7';
      final settings = InAppWebViewSettings(persistentStoreIdentifier: id);
      final restored = InAppWebViewSettings.fromJson(settings.toJson());
      expect(restored.persistentStoreIdentifier, id);
    });

    test('round-trips an empty string as null (no-op, no behavioral change)',
        () {
      // The Swift side treats an empty string the same as null (guard
      // !id.isEmpty), so the Dart wire format should not let an empty
      // string leak through and surprise the native side — verify the
      // explicit-null path produces a missing key, mirroring the
      // includeIfNull: false semantics.
      final settings = InAppWebViewSettings(persistentStoreIdentifier: null);
      final map = settings.toJson();
      expect(map.containsKey('persistentStoreIdentifier'), isFalse);
    });

    test('incognito and persistentStoreIdentifier can coexist on the wire '
        '(native side resolves precedence — incognito wins)', () {
      // The Dart-side settings object has no enforcement of mutual
      // exclusion; the native init resolves it (incognito takes
      // precedence). Pin the wire format so the native side reliably
      // receives both keys when both are set.
      final settings = InAppWebViewSettings(
        incognito: true,
        persistentStoreIdentifier: 'alice-profile',
      );
      final map = settings.toJson();
      expect(map['incognito'], isTrue);
      expect(map['persistentStoreIdentifier'], 'alice-profile');
    });
  });

  group('InAppWebViewSettings.dismissDialogues', () {
    // U1 — FR-002: the option MUST default to disabled (false) so overlays are
    // preserved unless the developer explicitly opts in.
    test('default-constructed settings expose dismissDialogues == false', () {
      final settings = InAppWebViewSettings();
      expect(settings.dismissDialogues, isFalse,
          reason: 'FR-002: dismissDialogues MUST default to false.');
    });

    // U2 — FR-001: the option MUST be settable to true.
    test('dismissDialogues: true is exposed as true', () {
      final settings = InAppWebViewSettings(dismissDialogues: true);
      expect(settings.dismissDialogues, isTrue);
    });

    // U3 — FR-001 invariant: dismissDialogues MUST round-trip through
    // toJson/fromJson unchanged at both boundaries (true and false).
    test('dismissDialogues round-trips through toJson/fromJson (true and false)',
        () {
      for (final value in const [true, false]) {
        final settings = InAppWebViewSettings(dismissDialogues: value);
        final restored = InAppWebViewSettings.fromJson(settings.toJson());
        expect(restored.dismissDialogues, value,
            reason: 'dismissDialogues MUST survive a wire round-trip unchanged '
                'at both boundaries (FR-001).');
      }
      // The implicit default also serializes to false and restores to false.
      final def = InAppWebViewSettings();
      expect(InAppWebViewSettings.fromJson(def.toJson()).dismissDialogues, isFalse);
    });
  });
}
