

///Class that represents the constants for the underline style and strikethrough style attribute keys.
enum UnderlineStyle {
  ///Do not draw a line.
  STYLE_NONE,
  ///Draw a single line.
  SINGLE,
  ///Draw a thick line.
  THICK,
  ///Draw a double line.
  DOUBLE,
  ///Draw a line of dots.
  PATTERN_DOT,
  ///Draw a line of dashes.
  PATTERN_DASH,
  ///Draw a line of alternating dashes and dots.
  PATTERN_DASH_DOT,
  ///Draw a line of alternating dashes and two dots.
  PATTERN_DASH_DOT_DOT,
  ///Draw the line only beneath or through words, not whitespace.
  BY_WORD,
}


///underline_style wire values are NOT sequential (0, 1, 2, 9, 256, 512, 768, 1024, 32768) — a plain enum's `.index`
///does not match the old `_value`.


///UnderlineStyle wire values are NOT sequential (0, 1, 2, 9, 256, 512, 768, 1024, 32768).
const _underlineStyle_wire = [0, 1, 2, 9, 256, 512, 768, 1024, 32768];

UnderlineStyle? underlineStyleFromWire(Object? value) {
  if (value is! int) return null;
  final index = _underlineStyle_wire.indexOf(value);
  return index >= 0 ? UnderlineStyle.values[index] : null;
}

Object? underlineStyleToWire(UnderlineStyle? value) =>
    value == null ? null : _underlineStyle_wire[value.index];
