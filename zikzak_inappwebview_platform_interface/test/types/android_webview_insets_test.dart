import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('AndroidWebViewInsets', () {
    test('toNativeValue/fromNativeValue round-trip every value', () {
      for (final v in AndroidWebViewInsets.values) {
        final native = v.toNativeValue();
        expect(native, isNotEmpty);
        final back = AndroidWebViewInsets.fromNativeValue(native);
        expect(back, v);
      }
    });

    test('fromNativeValue returns null for unknown', () {
      expect(AndroidWebViewInsets.fromNativeValue('nope'), isNull);
      expect(AndroidWebViewInsets.fromNativeValue(null), isNull);
    });

    test('exposes the expected set of values', () {
      expect(
        AndroidWebViewInsets.values.map((e) => e.toNativeValue()).toSet(),
        {
          'ime',
          'systemBars',
          'systemGestures',
          'mandatorySystemGestures',
          'tappableElement',
          'displayCutout',
        },
      );
    });

    test('equality is by value', () {
      expect(AndroidWebViewInsets.ime, AndroidWebViewInsets.ime);
      expect(AndroidWebViewInsets.ime == AndroidWebViewInsets.systemBars, isFalse);
    });
  });

  group('InAppWebViewSettings.insetsForWebContentToIgnore', () {
    test('defaults to null', () {
      expect(InAppWebViewSettings().insetsForWebContentToIgnore, isNull);
    });

    test('toMap/fromMap round-trips the list as native strings', () {
      final settings = InAppWebViewSettings(
        insetsForWebContentToIgnore: [
          AndroidWebViewInsets.systemBars,
          AndroidWebViewInsets.ime,
          AndroidWebViewInsets.displayCutout,
        ],
      );
      final map = settings.toMap();
      expect(map['insetsForWebContentToIgnore'], [
        'systemBars',
        'ime',
        'displayCutout',
      ]);
      final back = InAppWebViewSettings.fromMap(
        Map<String, dynamic>.from(map),
      )!;
      expect(
        back.insetsForWebContentToIgnore,
        [
          AndroidWebViewInsets.systemBars,
          AndroidWebViewInsets.ime,
          AndroidWebViewInsets.displayCutout,
        ],
      );
    });

    test('toMap serializes null as absent (null)', () {
      final map = InAppWebViewSettings().toMap();
      expect(map['insetsForWebContentToIgnore'], isNull);
    });

    test('fromMap handles absent key as null', () {
      final back = InAppWebViewSettings.fromMap(<String, dynamic>{})!;
      expect(back.insetsForWebContentToIgnore, isNull);
    });
  });
}
