import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

part 'attributed_string_text_effect_style.g.dart';

///Class that represents the supported proxy types.
@ExchangeableEnum()
class AttributedStringTextEffectStyle_ {
  // ignore: unused_field
  final String _value;
  const AttributedStringTextEffectStyle_._internal(this._value);

  ///A graphical text effect that gives glyphs the appearance of letterpress printing, which involves pressing the type into the paper.
  static const LETTERPRESS_STYLE =
      const AttributedStringTextEffectStyle_._internal("letterpressStyle");
}
