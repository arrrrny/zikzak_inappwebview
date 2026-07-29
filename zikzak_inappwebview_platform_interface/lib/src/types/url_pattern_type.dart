///How URL patterns of the Network Capture API are interpreted.
class UrlPatternType {
  final String _value;
  final String _nativeValue;
  const UrlPatternType._internal(this._value, this._nativeValue);

  ///Each pattern is matched as a plain substring of the request URL
  ///(`url.contains(pattern)`). This is the default.
  static const substring = UrlPatternType._internal('substring', 'substring');

  ///Each pattern is compiled as a regular expression and tested against the
  ///request URL.
  static const regex = UrlPatternType._internal('regex', 'regex');

  ///Set of all values of [UrlPatternType].
  static final Set<UrlPatternType> values = [
    UrlPatternType.substring,
    UrlPatternType.regex,
  ].toSet();

  ///Gets a possible [UrlPatternType] instance from [String] value.
  static UrlPatternType? fromValue(String? value) {
    if (value != null) {
      try {
        return UrlPatternType.values.firstWhere(
          (element) => element.toValue() == value,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [UrlPatternType] instance from a native value.
  static UrlPatternType? fromNativeValue(String? value) => fromValue(value);

  ///Gets [String] value.
  String toValue() => _value;

  ///Gets [String] native value.
  String toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() => _value;
}
