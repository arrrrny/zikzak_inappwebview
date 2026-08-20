// Wire-format regression test for InAppWebViewSettings enum fields.
//
// Pins the consumer-visible contract that the Dart side's `toMap()` emits
// INTEGER wire values (not enum-name strings) for every enum-typed setting
// consumed by the Android parser as `(Integer) value` — now defensively
// coerced via `ISettings.coerceInteger` (see issue #245 and the matching
// Java-side fix in zikzak_inappwebview_android).
//
// Why this matters: on the 5.x line (master, post-zorphy migration) the
// model layer moved to `json_serializable` and the `@JsonKey` annotations
// on these enum fields lost their integer serialization, defaulting to
// `json_serializable`'s string-name enum maps. The Android parser then
// crashed with `ClassCastException: String cannot be cast to Integer` at
// `InAppWebViewSettings.parse(InAppWebViewSettings.java:332)` (issue #245).
//
// This test guards the 4.x development line against the same regression:
// if anyone migrates `InAppWebViewSettings` to `json_serializable` and
// forgets to add `toJson`/`fromJson` converters, this test will fail on
// the Dart side before the bug can reach a device.
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/src/in_app_webview/in_app_webview_settings.dart';
import 'package:zikzak_inappwebview_platform_interface/src/types/action_mode_menu_item.dart';
import 'package:zikzak_inappwebview_platform_interface/src/types/cache_mode.dart';
import 'package:zikzak_inappwebview_platform_interface/src/types/force_dark.dart';
import 'package:zikzak_inappwebview_platform_interface/src/types/force_dark_strategy.dart';
import 'package:zikzak_inappwebview_platform_interface/src/types/mixed_content_mode.dart';
import 'package:zikzak_inappwebview_platform_interface/src/types/over_scroll_mode.dart';
import 'package:zikzak_inappwebview_platform_interface/src/types/scrollbar_style.dart';
import 'package:zikzak_inappwebview_platform_interface/src/types/user_preferred_content_mode.dart';
import 'package:zikzak_inappwebview_platform_interface/src/types/vertical_scrollbar_position.dart';
import 'package:zikzak_inappwebview_platform_interface/src/types/web_authentication_support.dart';

void main() {
  // Each entry: (field name, non-default enum value, expected int wire value).
  // The non-default value is chosen so that if the wire format ever regresses
  // to enum-name strings (e.g. "OFF" → "0"), the assertion fails immediately.
  final cases = <(String, Object?, int)>[
    ('forceDark', ForceDark.OFF, 0),
    ('forceDark', ForceDark.AUTO, 1),
    ('forceDark', ForceDark.ON, 2),
    ('forceDarkStrategy', ForceDarkStrategy.WEB_THEME_DARKENING_ONLY, 1),
    ('mixedContentMode', MixedContentMode.MIXED_CONTENT_NEVER_ALLOW, 1),
    ('cacheMode', CacheMode.LOAD_CACHE_ELSE_NETWORK, 1),
    ('cacheMode', CacheMode.LOAD_DEFAULT, -1),
    ('disabledActionModeMenuItems', ActionModeMenuItem.MENU_ITEM_SHARE, 1),
    ('disabledActionModeMenuItems', ActionModeMenuItem.MENU_ITEM_PROCESS_TEXT, 4),
    ('overScrollMode', OverScrollMode.NEVER, 2),
    ('scrollBarStyle', ScrollBarStyle.SCROLLBARS_INSIDE_OVERLAY, 0),
    ('verticalScrollbarPosition',
        VerticalScrollbarPosition.SCROLLBAR_POSITION_LEFT, 1),
    ('preferredContentMode', UserPreferredContentMode.DESKTOP, 2),
    ('webAuthenticationSupport', WebAuthenticationSupport.FOR_BROWSER, 2),
  ];

  group('InAppWebViewSettings — enum wire format (issue #245)', () {
    test('toMap emits INTEGER values (never String) for every enum field', () {
      for (final (field, enumValue, expectedWire) in cases) {
        final settings = InAppWebViewSettings();
        // ignore: avoid_dynamic_calls
        // Set the field via the public setter (reflected field).
        // The generated settings model exposes writable fields directly.
        switch (field) {
          case 'forceDark':
            settings.forceDark = enumValue as ForceDark?;
            break;
          case 'forceDarkStrategy':
            settings.forceDarkStrategy = enumValue as ForceDarkStrategy?;
            break;
          case 'mixedContentMode':
            settings.mixedContentMode = enumValue as MixedContentMode?;
            break;
          case 'cacheMode':
            settings.cacheMode = enumValue as CacheMode?;
            break;
          case 'disabledActionModeMenuItems':
            settings.disabledActionModeMenuItems =
                enumValue as ActionModeMenuItem?;
            break;
          case 'overScrollMode':
            settings.overScrollMode = enumValue as OverScrollMode?;
            break;
          case 'scrollBarStyle':
            settings.scrollBarStyle = enumValue as ScrollBarStyle?;
            break;
          case 'verticalScrollbarPosition':
            settings.verticalScrollbarPosition =
                enumValue as VerticalScrollbarPosition?;
            break;
          case 'preferredContentMode':
            settings.preferredContentMode =
                enumValue as UserPreferredContentMode?;
            break;
          case 'webAuthenticationSupport':
            settings.webAuthenticationSupport =
                enumValue as WebAuthenticationSupport?;
            break;
          default:
            fail('Unknown field "$field" — extend the switch.');
        }

        final map = settings.toMap();
        final wire = map[field];

        // The wire value MUST be an int — the Android parser casts to
        // (Integer). A String here is exactly the regression that broke
        // 5.0.0 (issue #245).
        expect(
          wire,
          isA<int>(),
          reason:
              '$field wire value must be int (got ${wire.runtimeType}: $wire). '
              'A String wire value crashes Android InAppWebViewSettings.parse '
              'with ClassCastException (issue #245).',
        );
        expect(wire, expectedWire, reason: '$field wire value mismatch');
      }
    });

    test('toMap omits null enum fields (no wire payload to mis-cast)', () {
      final settings = InAppWebViewSettings()
        ..forceDark = null
        ..cacheMode = null
        ..mixedContentMode = null
        ..disabledActionModeMenuItems = null
        ..forceDarkStrategy = null
        ..overScrollMode = null
        ..scrollBarStyle = null
        ..verticalScrollbarPosition = null
        ..preferredContentMode = null
        ..webAuthenticationSupport = null;

      final map = settings.toMap();
      for (final field in [
        'forceDark',
        'cacheMode',
        'mixedContentMode',
        'disabledActionModeMenuItems',
        'forceDarkStrategy',
        'overScrollMode',
        'scrollBarStyle',
        'verticalScrollbarPosition',
        'preferredContentMode',
        'webAuthenticationSupport',
      ]) {
        expect(map[field], isNull, reason: '$field should be null');
      }
    });

    test('fromMap round-trips every enum value (int → enum → int)', () {
      for (final (field, enumValue, expectedWire) in cases) {
        final roundTrip = InAppWebViewSettings.fromMap({field: expectedWire})!;
        // Verify the field round-tripped back to the same enum.
        switch (field) {
          case 'forceDark':
            expect(roundTrip.forceDark, enumValue);
            break;
          case 'forceDarkStrategy':
            expect(roundTrip.forceDarkStrategy, enumValue);
            break;
          case 'mixedContentMode':
            expect(roundTrip.mixedContentMode, enumValue);
            break;
          case 'cacheMode':
            expect(roundTrip.cacheMode, enumValue);
            break;
          case 'disabledActionModeMenuItems':
            expect(roundTrip.disabledActionModeMenuItems, enumValue);
            break;
          case 'overScrollMode':
            expect(roundTrip.overScrollMode, enumValue);
            break;
          case 'scrollBarStyle':
            expect(roundTrip.scrollBarStyle, enumValue);
            break;
          case 'verticalScrollbarPosition':
            expect(roundTrip.verticalScrollbarPosition, enumValue);
            break;
          case 'preferredContentMode':
            expect(roundTrip.preferredContentMode, enumValue);
            break;
          case 'webAuthenticationSupport':
            expect(roundTrip.webAuthenticationSupport, enumValue);
            break;
          default:
            fail('Unknown field "$field" — extend the switch.');
        }
      }
    });
  });
}
