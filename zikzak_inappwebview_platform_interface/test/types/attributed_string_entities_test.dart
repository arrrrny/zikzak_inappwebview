// Public-API regression tests for the AttributedString valueObject + its
// enums (AttributedStringTextEffectStyle, UnderlineStyle). Zorphy entities.
//
// Pins the CURRENT committed wire contract:
//   - colors serialize to '#AARRGGBB' hex strings
//   - strikethroughStyle uses the wire-int helper (0,1,2,9,256,...)
//   - textEffect + underlineStyle use name-based enum maps ('LETTERPRESS_STYLE',
//     'STYLE_NONE', ...)
//   - `string` is required → fromJson({}) throws on a missing key
//   - round-trip + copyWith
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('AttributedString', () {
    test('string is required and defaults serialize', () {
      final a = AttributedString(string: 'hello');
      expect(a.string, 'hello');
      expect(a.toJson()['string'], 'hello');
      // fromJson missing required `string` throws (not null-tolerant).
      expect(() => AttributedString.fromJson({}), throwsA(anything));
    });

    test('colors serialize as #AARRGGBB hex strings', () {
      final a = AttributedString(
        string: 's',
        backgroundColor: Color_(0xFF00FF00),
        foregroundColor: Color_(0xFF0000FF),
      );
      final map = a.toJson();
      expect(map['backgroundColor'], '#ff00ff00');
      expect(map['foregroundColor'], '#ff0000ff');

      final back = AttributedString.fromJson({
        'string': 's',
        'backgroundColor': '#ff112233',
      });
      expect(back.backgroundColor?.toHex(), '#ff112233');
    });

    test('double/int fields pass through + round-trip', () {
      final a = AttributedString(
        string: 's',
        baselineOffset: 1.5,
        expansion: 0.25,
        kern: 2.0,
        ligature: 2,
        obliqueness: -1.0,
        strokeWidth: 3.0,
      );
      final map = a.toJson();
      expect(map['baselineOffset'], 1.5);
      expect(map['expansion'], 0.25);
      expect(map['kern'], 2.0);
      expect(map['ligature'], 2);
      expect(map['obliqueness'], -1.0);
      expect(map['strokeWidth'], 3.0);

      final back = AttributedString.fromJson(a.toJson());
      expect(back.baselineOffset, 1.5);
      expect(back.ligature, 2);
    });

    test('strikethroughStyle uses the wire-int helper', () {
      final a = AttributedString(string: 's', strikethroughStyle: UnderlineStyle.DOUBLE);
      // wire [0,1,2,9,256,...].index of 9 == DOUBLE == 3
      expect(a.toJson()['strikethroughStyle'], 9);

      final back = AttributedString.fromJson({'string': 's', 'strikethroughStyle': 9});
      expect(back.strikethroughStyle, UnderlineStyle.DOUBLE);
    });

    test('textEffect + underlineStyle use name-based enum maps', () {
      final a = AttributedString(
        string: 's',
        textEffect: AttributedStringTextEffectStyle.LETTERPRESS_STYLE,
        underlineStyle: UnderlineStyle.SINGLE,
      );
      expect(a.toJson()['textEffect'], 'LETTERPRESS_STYLE');
      expect(a.toJson()['underlineStyle'], 'SINGLE');

      final back = AttributedString.fromJson({
        'string': 's',
        'textEffect': 'LETTERPRESS_STYLE',
        'underlineStyle': 'SINGLE',
      });
      expect(back.textEffect, AttributedStringTextEffectStyle.LETTERPRESS_STYLE);
      expect(back.underlineStyle, UnderlineStyle.SINGLE);
    });

    test('round-trip keeps value + copyWith', () {
      final a = AttributedString(string: 'hi', foregroundColor: Color_(0xFFFF0000));
      final back = AttributedString.fromJson(a.toJson());
      expect(back.string, 'hi');
      expect(back.foregroundColor?.toHex(), '#ffff0000');
      expect(a.copyWith(string: 'yo').string, 'yo');
      expect(a.copyWith().string, 'hi');
    });
  });

  group('UnderlineStyle wire values (0,1,2,9,256,...)', () {
    test('wire helper round-trips the odd values', () {
      expect(underlineStyleToWire(UnderlineStyle.STYLE_NONE), 0);
      expect(underlineStyleToWire(UnderlineStyle.SINGLE), 1);
      expect(underlineStyleToWire(UnderlineStyle.THICK), 2);
      expect(underlineStyleToWire(UnderlineStyle.DOUBLE), 9);
      expect(underlineStyleToWire(UnderlineStyle.BY_WORD), 32768);

      expect(underlineStyleFromWire(9), UnderlineStyle.DOUBLE);
      expect(underlineStyleFromWire(256), UnderlineStyle.PATTERN_DOT);
      expect(underlineStyleFromWire('x'), isNull);
      expect(underlineStyleFromWire(999999), isNull);
    });
  });
}
