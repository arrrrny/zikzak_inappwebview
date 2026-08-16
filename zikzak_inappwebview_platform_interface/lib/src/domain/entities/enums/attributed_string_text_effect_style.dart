///Class that represents the supported proxy types.
enum AttributedStringTextEffectStyle {
  ///A graphical text effect that gives glyphs the appearance of letterpress printing, which involves pressing the type into the paper.
  LETTERPRESS_STYLE,
}

///AttributedStringTextEffectStyle wire values are strings — lookup by value.
const _attributedStringTextEffectStyle_wire = ['NONE', 'LETTERPRESS_STYLE'];

AttributedStringTextEffectStyle? attributedStringTextEffectStyleFromWire(
  Object? value,
) {
  if (value is! String) return null;
  final index = _attributedStringTextEffectStyle_wire.indexOf(value);
  return index >= 0 ? AttributedStringTextEffectStyle.values[index] : null;
}

Object? attributedStringTextEffectStyleToWire(
  AttributedStringTextEffectStyle? value,
) => value == null ? null : _attributedStringTextEffectStyle_wire[value.index];
