// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'attributed_string.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class AttributedString {
  AttributedString({
    required String this.string,
    Color? this.backgroundColor,
    double? this.baselineOffset,
    double? this.expansion,
    Color? this.foregroundColor,
    double? this.kern,
    int? this.ligature,
    double? this.obliqueness,
    Color? this.strikethroughColor,
    UnderlineStyle? this.strikethroughStyle,
    Color? this.strokeColor,
    double? this.strokeWidth,
    AttributedStringTextEffectStyle? this.textEffect,
    Color? this.underlineColor,
    UnderlineStyle? this.underlineStyle,
  });

  factory AttributedString.fromJson(Map<String, dynamic> json) =>
      _$AttributedStringFromJson(json);

  final String string;

  @JsonKey(toJson: _backgroundColorToJson, fromJson: _backgroundColorFromJson)
  final Color? backgroundColor;

  final double? baselineOffset;

  final double? expansion;

  @JsonKey(toJson: _foregroundColorToJson, fromJson: _foregroundColorFromJson)
  final Color? foregroundColor;

  final double? kern;

  final int? ligature;

  final double? obliqueness;

  @JsonKey(
    toJson: _strikethroughColorToJson,
    fromJson: _strikethroughColorFromJson,
  )
  final Color? strikethroughColor;

  @JsonKey(
    toJson: _strikethroughStyleToJson,
    fromJson: _strikethroughStyleFromJson,
  )
  final UnderlineStyle? strikethroughStyle;

  @JsonKey(toJson: _strokeColorToJson, fromJson: _strokeColorFromJson)
  final Color? strokeColor;

  final double? strokeWidth;

  final AttributedStringTextEffectStyle? textEffect;

  @JsonKey(toJson: _underlineColorToJson, fromJson: _underlineColorFromJson)
  final Color? underlineColor;

  final UnderlineStyle? underlineStyle;

  AttributedString copyWith({
    String? string,
    Color? backgroundColor,
    double? baselineOffset,
    double? expansion,
    Color? foregroundColor,
    double? kern,
    int? ligature,
    double? obliqueness,
    Color? strikethroughColor,
    UnderlineStyle? strikethroughStyle,
    Color? strokeColor,
    double? strokeWidth,
    AttributedStringTextEffectStyle? textEffect,
    Color? underlineColor,
    UnderlineStyle? underlineStyle,
  }) {
    return AttributedString(
      string: string ?? this.string,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      baselineOffset: baselineOffset ?? this.baselineOffset,
      expansion: expansion ?? this.expansion,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      kern: kern ?? this.kern,
      ligature: ligature ?? this.ligature,
      obliqueness: obliqueness ?? this.obliqueness,
      strikethroughColor: strikethroughColor ?? this.strikethroughColor,
      strikethroughStyle: strikethroughStyle ?? this.strikethroughStyle,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      textEffect: textEffect ?? this.textEffect,
      underlineColor: underlineColor ?? this.underlineColor,
      underlineStyle: underlineStyle ?? this.underlineStyle,
    );
  }

  AttributedString copyWithAttributedString({
    String? string,
    Color? backgroundColor,
    double? baselineOffset,
    double? expansion,
    Color? foregroundColor,
    double? kern,
    int? ligature,
    double? obliqueness,
    Color? strikethroughColor,
    UnderlineStyle? strikethroughStyle,
    Color? strokeColor,
    double? strokeWidth,
    AttributedStringTextEffectStyle? textEffect,
    Color? underlineColor,
    UnderlineStyle? underlineStyle,
  }) {
    return copyWith(
      string: string,
      backgroundColor: backgroundColor,
      baselineOffset: baselineOffset,
      expansion: expansion,
      foregroundColor: foregroundColor,
      kern: kern,
      ligature: ligature,
      obliqueness: obliqueness,
      strikethroughColor: strikethroughColor,
      strikethroughStyle: strikethroughStyle,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      textEffect: textEffect,
      underlineColor: underlineColor,
      underlineStyle: underlineStyle,
    );
  }

  AttributedString patchWithAttributedString([
    AttributedStringPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? AttributedStringPatch();
    final _patchMap = _patcher.patchMap;
    return AttributedString(
      string: _patchMap.containsKey(AttributedString$.string)
          ? (_patchMap[AttributedString$.string] is Function)
                ? _patchMap[AttributedString$.string](this.string)
                : (_patchMap[AttributedString$.string] is Patch)
                ? _patchMap[AttributedString$.string].applyTo(this.string)
                : _patchMap[AttributedString$.string]
          : this.string,
      backgroundColor: _patchMap.containsKey(AttributedString$.backgroundColor)
          ? (_patchMap[AttributedString$.backgroundColor] is Function)
                ? _patchMap[AttributedString$.backgroundColor](
                    this.backgroundColor,
                  )
                : (_patchMap[AttributedString$.backgroundColor] is Patch)
                ? _patchMap[AttributedString$.backgroundColor].applyTo(
                    this.backgroundColor,
                  )
                : _patchMap[AttributedString$.backgroundColor]
          : this.backgroundColor,
      baselineOffset: _patchMap.containsKey(AttributedString$.baselineOffset)
          ? (_patchMap[AttributedString$.baselineOffset] is Function)
                ? _patchMap[AttributedString$.baselineOffset](
                    this.baselineOffset,
                  )
                : (_patchMap[AttributedString$.baselineOffset] is Patch)
                ? _patchMap[AttributedString$.baselineOffset].applyTo(
                    this.baselineOffset,
                  )
                : _patchMap[AttributedString$.baselineOffset]
          : this.baselineOffset,
      expansion: _patchMap.containsKey(AttributedString$.expansion)
          ? (_patchMap[AttributedString$.expansion] is Function)
                ? _patchMap[AttributedString$.expansion](this.expansion)
                : (_patchMap[AttributedString$.expansion] is Patch)
                ? _patchMap[AttributedString$.expansion].applyTo(this.expansion)
                : _patchMap[AttributedString$.expansion]
          : this.expansion,
      foregroundColor: _patchMap.containsKey(AttributedString$.foregroundColor)
          ? (_patchMap[AttributedString$.foregroundColor] is Function)
                ? _patchMap[AttributedString$.foregroundColor](
                    this.foregroundColor,
                  )
                : (_patchMap[AttributedString$.foregroundColor] is Patch)
                ? _patchMap[AttributedString$.foregroundColor].applyTo(
                    this.foregroundColor,
                  )
                : _patchMap[AttributedString$.foregroundColor]
          : this.foregroundColor,
      kern: _patchMap.containsKey(AttributedString$.kern)
          ? (_patchMap[AttributedString$.kern] is Function)
                ? _patchMap[AttributedString$.kern](this.kern)
                : (_patchMap[AttributedString$.kern] is Patch)
                ? _patchMap[AttributedString$.kern].applyTo(this.kern)
                : _patchMap[AttributedString$.kern]
          : this.kern,
      ligature: _patchMap.containsKey(AttributedString$.ligature)
          ? (_patchMap[AttributedString$.ligature] is Function)
                ? _patchMap[AttributedString$.ligature](this.ligature)
                : (_patchMap[AttributedString$.ligature] is Patch)
                ? _patchMap[AttributedString$.ligature].applyTo(this.ligature)
                : _patchMap[AttributedString$.ligature]
          : this.ligature,
      obliqueness: _patchMap.containsKey(AttributedString$.obliqueness)
          ? (_patchMap[AttributedString$.obliqueness] is Function)
                ? _patchMap[AttributedString$.obliqueness](this.obliqueness)
                : (_patchMap[AttributedString$.obliqueness] is Patch)
                ? _patchMap[AttributedString$.obliqueness].applyTo(
                    this.obliqueness,
                  )
                : _patchMap[AttributedString$.obliqueness]
          : this.obliqueness,
      strikethroughColor:
          _patchMap.containsKey(AttributedString$.strikethroughColor)
          ? (_patchMap[AttributedString$.strikethroughColor] is Function)
                ? _patchMap[AttributedString$.strikethroughColor](
                    this.strikethroughColor,
                  )
                : (_patchMap[AttributedString$.strikethroughColor] is Patch)
                ? _patchMap[AttributedString$.strikethroughColor].applyTo(
                    this.strikethroughColor,
                  )
                : _patchMap[AttributedString$.strikethroughColor]
          : this.strikethroughColor,
      strikethroughStyle:
          _patchMap.containsKey(AttributedString$.strikethroughStyle)
          ? (_patchMap[AttributedString$.strikethroughStyle] is Function)
                ? _patchMap[AttributedString$.strikethroughStyle](
                    this.strikethroughStyle,
                  )
                : (_patchMap[AttributedString$.strikethroughStyle] is Patch)
                ? _patchMap[AttributedString$.strikethroughStyle].applyTo(
                    this.strikethroughStyle,
                  )
                : _patchMap[AttributedString$.strikethroughStyle]
          : this.strikethroughStyle,
      strokeColor: _patchMap.containsKey(AttributedString$.strokeColor)
          ? (_patchMap[AttributedString$.strokeColor] is Function)
                ? _patchMap[AttributedString$.strokeColor](this.strokeColor)
                : (_patchMap[AttributedString$.strokeColor] is Patch)
                ? _patchMap[AttributedString$.strokeColor].applyTo(
                    this.strokeColor,
                  )
                : _patchMap[AttributedString$.strokeColor]
          : this.strokeColor,
      strokeWidth: _patchMap.containsKey(AttributedString$.strokeWidth)
          ? (_patchMap[AttributedString$.strokeWidth] is Function)
                ? _patchMap[AttributedString$.strokeWidth](this.strokeWidth)
                : (_patchMap[AttributedString$.strokeWidth] is Patch)
                ? _patchMap[AttributedString$.strokeWidth].applyTo(
                    this.strokeWidth,
                  )
                : _patchMap[AttributedString$.strokeWidth]
          : this.strokeWidth,
      textEffect: _patchMap.containsKey(AttributedString$.textEffect)
          ? (_patchMap[AttributedString$.textEffect] is Function)
                ? _patchMap[AttributedString$.textEffect](this.textEffect)
                : (_patchMap[AttributedString$.textEffect] is Patch)
                ? _patchMap[AttributedString$.textEffect].applyTo(
                    this.textEffect,
                  )
                : _patchMap[AttributedString$.textEffect]
          : this.textEffect,
      underlineColor: _patchMap.containsKey(AttributedString$.underlineColor)
          ? (_patchMap[AttributedString$.underlineColor] is Function)
                ? _patchMap[AttributedString$.underlineColor](
                    this.underlineColor,
                  )
                : (_patchMap[AttributedString$.underlineColor] is Patch)
                ? _patchMap[AttributedString$.underlineColor].applyTo(
                    this.underlineColor,
                  )
                : _patchMap[AttributedString$.underlineColor]
          : this.underlineColor,
      underlineStyle: _patchMap.containsKey(AttributedString$.underlineStyle)
          ? (_patchMap[AttributedString$.underlineStyle] is Function)
                ? _patchMap[AttributedString$.underlineStyle](
                    this.underlineStyle,
                  )
                : (_patchMap[AttributedString$.underlineStyle] is Patch)
                ? _patchMap[AttributedString$.underlineStyle].applyTo(
                    this.underlineStyle,
                  )
                : _patchMap[AttributedString$.underlineStyle]
          : this.underlineStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AttributedString &&
        string == other.string &&
        backgroundColor == other.backgroundColor &&
        baselineOffset == other.baselineOffset &&
        expansion == other.expansion &&
        foregroundColor == other.foregroundColor &&
        kern == other.kern &&
        ligature == other.ligature &&
        obliqueness == other.obliqueness &&
        strikethroughColor == other.strikethroughColor &&
        strikethroughStyle == other.strikethroughStyle &&
        strokeColor == other.strokeColor &&
        strokeWidth == other.strokeWidth &&
        textEffect == other.textEffect &&
        underlineColor == other.underlineColor &&
        underlineStyle == other.underlineStyle;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.string,
      this.backgroundColor,
      this.baselineOffset,
      this.expansion,
      this.foregroundColor,
      this.kern,
      this.ligature,
      this.obliqueness,
      this.strikethroughColor,
      this.strikethroughStyle,
      this.strokeColor,
      this.strokeWidth,
      this.textEffect,
      this.underlineColor,
      this.underlineStyle,
    );
  }

  @override
  String toString() {
    return 'AttributedString(' +
        'string: ${string}' +
        ', ' +
        'backgroundColor: ${backgroundColor}' +
        ', ' +
        'baselineOffset: ${baselineOffset}' +
        ', ' +
        'expansion: ${expansion}' +
        ', ' +
        'foregroundColor: ${foregroundColor}' +
        ', ' +
        'kern: ${kern}' +
        ', ' +
        'ligature: ${ligature}' +
        ', ' +
        'obliqueness: ${obliqueness}' +
        ', ' +
        'strikethroughColor: ${strikethroughColor}' +
        ', ' +
        'strikethroughStyle: ${strikethroughStyle}' +
        ', ' +
        'strokeColor: ${strokeColor}' +
        ', ' +
        'strokeWidth: ${strokeWidth}' +
        ', ' +
        'textEffect: ${textEffect}' +
        ', ' +
        'underlineColor: ${underlineColor}' +
        ', ' +
        'underlineStyle: ${underlineStyle})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$AttributedStringToJson(this);
    return _sanitizeJson(data);
  }

  dynamic _sanitizeJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      json.remove('__typename');
      return json..forEach((key, value) {
        json[key] = _sanitizeJson(value);
      });
    } else if (json is List) {
      return json.map((e) => _sanitizeJson(e)).toList();
    }
    return json;
  }
}

extension AttributedStringPropertyHelpers on AttributedString {
  bool get hasString {
    return this.string.isNotEmpty;
  }

  bool get noString {
    return this.string.isEmpty;
  }

  bool get hasBackgroundColor {
    return this.backgroundColor != null;
  }

  bool get noBackgroundColor {
    return this.backgroundColor == null;
  }

  Color get backgroundColorRequired {
    return this.backgroundColor ??
        (throw StateError('backgroundColor is required but was null'));
  }

  bool get hasBaselineOffset {
    return this.baselineOffset != null;
  }

  bool get noBaselineOffset {
    return this.baselineOffset == null;
  }

  double get baselineOffsetRequired {
    return this.baselineOffset ??
        (throw StateError('baselineOffset is required but was null'));
  }

  bool get hasExpansion {
    return this.expansion != null;
  }

  bool get noExpansion {
    return this.expansion == null;
  }

  double get expansionRequired {
    return this.expansion ??
        (throw StateError('expansion is required but was null'));
  }

  bool get hasForegroundColor {
    return this.foregroundColor != null;
  }

  bool get noForegroundColor {
    return this.foregroundColor == null;
  }

  Color get foregroundColorRequired {
    return this.foregroundColor ??
        (throw StateError('foregroundColor is required but was null'));
  }

  bool get hasKern {
    return this.kern != null;
  }

  bool get noKern {
    return this.kern == null;
  }

  double get kernRequired {
    return this.kern ?? (throw StateError('kern is required but was null'));
  }

  bool get hasLigature {
    return this.ligature != null;
  }

  bool get noLigature {
    return this.ligature == null;
  }

  int get ligatureRequired {
    return this.ligature ??
        (throw StateError('ligature is required but was null'));
  }

  bool get hasObliqueness {
    return this.obliqueness != null;
  }

  bool get noObliqueness {
    return this.obliqueness == null;
  }

  double get obliquenessRequired {
    return this.obliqueness ??
        (throw StateError('obliqueness is required but was null'));
  }

  bool get hasStrikethroughColor {
    return this.strikethroughColor != null;
  }

  bool get noStrikethroughColor {
    return this.strikethroughColor == null;
  }

  Color get strikethroughColorRequired {
    return this.strikethroughColor ??
        (throw StateError('strikethroughColor is required but was null'));
  }

  bool get hasStrikethroughStyle {
    return this.strikethroughStyle != null;
  }

  bool get noStrikethroughStyle {
    return this.strikethroughStyle == null;
  }

  UnderlineStyle get strikethroughStyleRequired {
    return this.strikethroughStyle ??
        (throw StateError('strikethroughStyle is required but was null'));
  }

  bool get isStrikethroughStyleSTYLE_NONE {
    return this.strikethroughStyle == UnderlineStyle.STYLE_NONE;
  }

  bool get isStrikethroughStyleSINGLE {
    return this.strikethroughStyle == UnderlineStyle.SINGLE;
  }

  bool get isStrikethroughStyleTHICK {
    return this.strikethroughStyle == UnderlineStyle.THICK;
  }

  bool get isStrikethroughStyleDOUBLE {
    return this.strikethroughStyle == UnderlineStyle.DOUBLE;
  }

  bool get isStrikethroughStylePATTERN_DOT {
    return this.strikethroughStyle == UnderlineStyle.PATTERN_DOT;
  }

  bool get isStrikethroughStylePATTERN_DASH {
    return this.strikethroughStyle == UnderlineStyle.PATTERN_DASH;
  }

  bool get isStrikethroughStylePATTERN_DASH_DOT {
    return this.strikethroughStyle == UnderlineStyle.PATTERN_DASH_DOT;
  }

  bool get isStrikethroughStylePATTERN_DASH_DOT_DOT {
    return this.strikethroughStyle == UnderlineStyle.PATTERN_DASH_DOT_DOT;
  }

  bool get isStrikethroughStyleBY_WORD {
    return this.strikethroughStyle == UnderlineStyle.BY_WORD;
  }

  bool get hasStrokeColor {
    return this.strokeColor != null;
  }

  bool get noStrokeColor {
    return this.strokeColor == null;
  }

  Color get strokeColorRequired {
    return this.strokeColor ??
        (throw StateError('strokeColor is required but was null'));
  }

  bool get hasStrokeWidth {
    return this.strokeWidth != null;
  }

  bool get noStrokeWidth {
    return this.strokeWidth == null;
  }

  double get strokeWidthRequired {
    return this.strokeWidth ??
        (throw StateError('strokeWidth is required but was null'));
  }

  bool get hasTextEffect {
    return this.textEffect != null;
  }

  bool get noTextEffect {
    return this.textEffect == null;
  }

  AttributedStringTextEffectStyle get textEffectRequired {
    return this.textEffect ??
        (throw StateError('textEffect is required but was null'));
  }

  bool get isTextEffectLETTERPRESS_STYLE {
    return this.textEffect == AttributedStringTextEffectStyle.LETTERPRESS_STYLE;
  }

  bool get hasUnderlineColor {
    return this.underlineColor != null;
  }

  bool get noUnderlineColor {
    return this.underlineColor == null;
  }

  Color get underlineColorRequired {
    return this.underlineColor ??
        (throw StateError('underlineColor is required but was null'));
  }

  bool get hasUnderlineStyle {
    return this.underlineStyle != null;
  }

  bool get noUnderlineStyle {
    return this.underlineStyle == null;
  }

  UnderlineStyle get underlineStyleRequired {
    return this.underlineStyle ??
        (throw StateError('underlineStyle is required but was null'));
  }

  bool get isUnderlineStyleSTYLE_NONE {
    return this.underlineStyle == UnderlineStyle.STYLE_NONE;
  }

  bool get isUnderlineStyleSINGLE {
    return this.underlineStyle == UnderlineStyle.SINGLE;
  }

  bool get isUnderlineStyleTHICK {
    return this.underlineStyle == UnderlineStyle.THICK;
  }

  bool get isUnderlineStyleDOUBLE {
    return this.underlineStyle == UnderlineStyle.DOUBLE;
  }

  bool get isUnderlineStylePATTERN_DOT {
    return this.underlineStyle == UnderlineStyle.PATTERN_DOT;
  }

  bool get isUnderlineStylePATTERN_DASH {
    return this.underlineStyle == UnderlineStyle.PATTERN_DASH;
  }

  bool get isUnderlineStylePATTERN_DASH_DOT {
    return this.underlineStyle == UnderlineStyle.PATTERN_DASH_DOT;
  }

  bool get isUnderlineStylePATTERN_DASH_DOT_DOT {
    return this.underlineStyle == UnderlineStyle.PATTERN_DASH_DOT_DOT;
  }

  bool get isUnderlineStyleBY_WORD {
    return this.underlineStyle == UnderlineStyle.BY_WORD;
  }
}

extension AttributedStringSerialization on AttributedString {
  Map<String, dynamic> toJson() {
    return _$AttributedStringToJson(this);
  }
}

enum AttributedString$ {
  string,
  backgroundColor,
  baselineOffset,
  expansion,
  foregroundColor,
  kern,
  ligature,
  obliqueness,
  strikethroughColor,
  strikethroughStyle,
  strokeColor,
  strokeWidth,
  textEffect,
  underlineColor,
  underlineStyle,
}

class AttributedStringPatch
    extends PatchBase<AttributedString, AttributedString$> {
  AttributedString applyTo(AttributedString entity) {
    return entity.patchWithAttributedString(this);
  }

  AttributedStringPatch withString(String? value) {
    patchMap[AttributedString$.string] = value;
    return this;
  }

  AttributedStringPatch withBackgroundColor(Color? value) {
    patchMap[AttributedString$.backgroundColor] = value;
    return this;
  }

  AttributedStringPatch withBaselineOffset(double? value) {
    patchMap[AttributedString$.baselineOffset] = value;
    return this;
  }

  AttributedStringPatch withExpansion(double? value) {
    patchMap[AttributedString$.expansion] = value;
    return this;
  }

  AttributedStringPatch withForegroundColor(Color? value) {
    patchMap[AttributedString$.foregroundColor] = value;
    return this;
  }

  AttributedStringPatch withKern(double? value) {
    patchMap[AttributedString$.kern] = value;
    return this;
  }

  AttributedStringPatch withLigature(int? value) {
    patchMap[AttributedString$.ligature] = value;
    return this;
  }

  AttributedStringPatch withObliqueness(double? value) {
    patchMap[AttributedString$.obliqueness] = value;
    return this;
  }

  AttributedStringPatch withStrikethroughColor(Color? value) {
    patchMap[AttributedString$.strikethroughColor] = value;
    return this;
  }

  AttributedStringPatch withStrikethroughStyle(UnderlineStyle? value) {
    patchMap[AttributedString$.strikethroughStyle] = value;
    return this;
  }

  AttributedStringPatch withStrokeColor(Color? value) {
    patchMap[AttributedString$.strokeColor] = value;
    return this;
  }

  AttributedStringPatch withStrokeWidth(double? value) {
    patchMap[AttributedString$.strokeWidth] = value;
    return this;
  }

  AttributedStringPatch withTextEffect(AttributedStringTextEffectStyle? value) {
    patchMap[AttributedString$.textEffect] = value;
    return this;
  }

  AttributedStringPatch withUnderlineColor(Color? value) {
    patchMap[AttributedString$.underlineColor] = value;
    return this;
  }

  AttributedStringPatch withUnderlineStyle(UnderlineStyle? value) {
    patchMap[AttributedString$.underlineStyle] = value;
    return this;
  }
}

/// Field descriptors for [AttributedString] query construction
abstract final class AttributedStringFields {
  static const string = Field<AttributedString, String>('string', _$string);

  static const backgroundColor = Field<AttributedString, Color?>(
    'backgroundColor',
    _$backgroundColor,
  );

  static const baselineOffset = Field<AttributedString, double?>(
    'baselineOffset',
    _$baselineOffset,
  );

  static const expansion = Field<AttributedString, double?>(
    'expansion',
    _$expansion,
  );

  static const foregroundColor = Field<AttributedString, Color?>(
    'foregroundColor',
    _$foregroundColor,
  );

  static const kern = Field<AttributedString, double?>('kern', _$kern);

  static const ligature = Field<AttributedString, int?>('ligature', _$ligature);

  static const obliqueness = Field<AttributedString, double?>(
    'obliqueness',
    _$obliqueness,
  );

  static const strikethroughColor = Field<AttributedString, Color?>(
    'strikethroughColor',
    _$strikethroughColor,
  );

  static const strikethroughStyle = Field<AttributedString, UnderlineStyle?>(
    'strikethroughStyle',
    _$strikethroughStyle,
  );

  static const strokeColor = Field<AttributedString, Color?>(
    'strokeColor',
    _$strokeColor,
  );

  static const strokeWidth = Field<AttributedString, double?>(
    'strokeWidth',
    _$strokeWidth,
  );

  static const textEffect =
      Field<AttributedString, AttributedStringTextEffectStyle?>(
        'textEffect',
        _$textEffect,
      );

  static const underlineColor = Field<AttributedString, Color?>(
    'underlineColor',
    _$underlineColor,
  );

  static const underlineStyle = Field<AttributedString, UnderlineStyle?>(
    'underlineStyle',
    _$underlineStyle,
  );

  static String _$string(AttributedString e) {
    return e.string;
  }

  static Color? _$backgroundColor(AttributedString e) {
    return e.backgroundColor;
  }

  static double? _$baselineOffset(AttributedString e) {
    return e.baselineOffset;
  }

  static double? _$expansion(AttributedString e) {
    return e.expansion;
  }

  static Color? _$foregroundColor(AttributedString e) {
    return e.foregroundColor;
  }

  static double? _$kern(AttributedString e) {
    return e.kern;
  }

  static int? _$ligature(AttributedString e) {
    return e.ligature;
  }

  static double? _$obliqueness(AttributedString e) {
    return e.obliqueness;
  }

  static Color? _$strikethroughColor(AttributedString e) {
    return e.strikethroughColor;
  }

  static UnderlineStyle? _$strikethroughStyle(AttributedString e) {
    return e.strikethroughStyle;
  }

  static Color? _$strokeColor(AttributedString e) {
    return e.strokeColor;
  }

  static double? _$strokeWidth(AttributedString e) {
    return e.strokeWidth;
  }

  static AttributedStringTextEffectStyle? _$textEffect(AttributedString e) {
    return e.textEffect;
  }

  static Color? _$underlineColor(AttributedString e) {
    return e.underlineColor;
  }

  static UnderlineStyle? _$underlineStyle(AttributedString e) {
    return e.underlineStyle;
  }
}

extension AttributedStringCompareE on AttributedString {
  Map<String, dynamic> compareToAttributedString(AttributedString other) {
    final Map<String, dynamic> diff = {};

    if (string != other.string) {
      diff['string'] = () => other.string;
    }

    if (backgroundColor != other.backgroundColor) {
      diff['backgroundColor'] = () => other.backgroundColor;
    }

    if (baselineOffset != other.baselineOffset) {
      diff['baselineOffset'] = () => other.baselineOffset;
    }

    if (expansion != other.expansion) {
      diff['expansion'] = () => other.expansion;
    }

    if (foregroundColor != other.foregroundColor) {
      diff['foregroundColor'] = () => other.foregroundColor;
    }

    if (kern != other.kern) {
      diff['kern'] = () => other.kern;
    }

    if (ligature != other.ligature) {
      diff['ligature'] = () => other.ligature;
    }

    if (obliqueness != other.obliqueness) {
      diff['obliqueness'] = () => other.obliqueness;
    }

    if (strikethroughColor != other.strikethroughColor) {
      diff['strikethroughColor'] = () => other.strikethroughColor;
    }

    if (strikethroughStyle != other.strikethroughStyle) {
      diff['strikethroughStyle'] = () => other.strikethroughStyle;
    }

    if (strokeColor != other.strokeColor) {
      diff['strokeColor'] = () => other.strokeColor;
    }

    if (strokeWidth != other.strokeWidth) {
      diff['strokeWidth'] = () => other.strokeWidth;
    }

    if (textEffect != other.textEffect) {
      diff['textEffect'] = () => other.textEffect;
    }

    if (underlineColor != other.underlineColor) {
      diff['underlineColor'] = () => other.underlineColor;
    }

    if (underlineStyle != other.underlineStyle) {
      diff['underlineStyle'] = () => other.underlineStyle;
    }
    return diff;
  }
}
