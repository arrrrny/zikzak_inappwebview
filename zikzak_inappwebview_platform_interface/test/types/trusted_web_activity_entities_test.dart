// Public-API regression tests for the TrustedWebActivity display-mode
// polymorphic family (hand-written fork — the concrete classes still emit a
// custom `type` wire key that the zorphy generator cannot express, see zorphy
// #103). Pins:
//   - TrustedWebActivityDefaultDisplayMode / ImmersiveDisplayMode wire
//   - ChromeSafariBrowserSettings.displayMode dispatch (type-key wire)
//   - TrustedWebActivityScreenOrientation index wire + default
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('TrustedWebActivityDisplayMode family', () {
    test('default mode wire is {"type": "DEFAULT_MODE"}', () {
      final m = TrustedWebActivityDefaultDisplayMode();
      expect(m.toJson(), {'type': 'DEFAULT_MODE'});
      expect(m.toMap(), {'type': 'DEFAULT_MODE'});
    });

    test('immersive mode wire carries the type key + fields', () {
      final m = TrustedWebActivityImmersiveDisplayMode(
        isSticky: true,
        displayCutoutMode: LayoutInDisplayCutoutMode.ALWAYS,
      );
      expect(m.toJson(), {
        'displayCutoutMode': 3,
        'isSticky': true,
        'type': 'IMMERSIVE_MODE',
      });
      final fromMap = TrustedWebActivityImmersiveDisplayMode.fromMap(m.toMap());
      expect(fromMap?.isSticky, true);
      expect(fromMap?.displayCutoutMode, LayoutInDisplayCutoutMode.ALWAYS);
      expect(
        TrustedWebActivityImmersiveDisplayMode.fromMap(null),
        isNull,
      );
    });

    test('displayMode round-trips through ChromeSafariBrowserSettings', () {
      final settings = ChromeSafariBrowserSettings(
        displayMode: TrustedWebActivityImmersiveDisplayMode(
          isSticky: false,
          displayCutoutMode: LayoutInDisplayCutoutMode.SHORT_EDGES,
        ),
      );
      final map = settings.toJson();
      expect(map['displayMode'], {
        'displayCutoutMode': 1,
        'isSticky': false,
        'type': 'IMMERSIVE_MODE',
      });
      final back = ChromeSafariBrowserSettings.fromJson(map);
      final mode = back.displayMode;
      expect(mode, isA<TrustedWebActivityImmersiveDisplayMode>());
      expect(
        (mode as TrustedWebActivityImmersiveDisplayMode).displayCutoutMode,
        LayoutInDisplayCutoutMode.SHORT_EDGES,
      );
    });

    test('displayMode fromJson dispatches on the type key', () {
      final settings = ChromeSafariBrowserSettings.fromJson({
        'displayMode': {'type': 'DEFAULT_MODE'},
      });
      expect(settings.displayMode, isA<TrustedWebActivityDefaultDisplayMode>());

      final nullMode = ChromeSafariBrowserSettings.fromJson({});
      expect(nullMode.displayMode, isNull);
    });
  });

  group('TrustedWebActivityScreenOrientation', () {
    test('index wire + default on settings', () {
      expect(TrustedWebActivityScreenOrientation.DEFAULT.index, 0);
      expect(TrustedWebActivityScreenOrientation.PORTRAIT_PRIMARY.index, 1);
      expect(TrustedWebActivityScreenOrientation.LANDSCAPE_PRIMARY.index, 3);
      expect(TrustedWebActivityScreenOrientation.LANDSCAPE_SECONDARY.index, 4);
      expect(TrustedWebActivityScreenOrientation.NATURAL.index, 8);
      final s = ChromeSafariBrowserSettings();
      expect(s.screenOrientation, TrustedWebActivityScreenOrientation.DEFAULT);
      final s2 = ChromeSafariBrowserSettings.fromJson({});
      expect(s2.screenOrientation, TrustedWebActivityScreenOrientation.DEFAULT);
      final s3 = ChromeSafariBrowserSettings.fromJson({'screenOrientation': 4});
      expect(s3.screenOrientation, TrustedWebActivityScreenOrientation.LANDSCAPE_SECONDARY);
    });
  });
}
