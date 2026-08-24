// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'trusted_web_activity_display_mode.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class TrustedWebActivityDisplayMode {
  TrustedWebActivityDisplayMode();

  factory TrustedWebActivityDisplayMode.fromJson(Map<String, dynamic> json) =>
      _$TrustedWebActivityDisplayModeFromJson(json);

  TrustedWebActivityDisplayMode copyWith() {
    return TrustedWebActivityDisplayMode();
  }

  TrustedWebActivityDisplayMode copyWithTrustedWebActivityDisplayMode() {
    return copyWith();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrustedWebActivityDisplayMode;
  }

  @override
  int get hashCode {
    return 0;
  }

  @override
  String toString() {
    return 'TrustedWebActivityDisplayMode()';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$TrustedWebActivityDisplayModeToJson(
      this,
    );
    _sanitizeJson(data);
    return data;
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

extension TrustedWebActivityDisplayModeSerialization
    on TrustedWebActivityDisplayMode {
  Map<String, dynamic> toJson() {
    return _$TrustedWebActivityDisplayModeToJson(this);
  }
}

extension TrustedWebActivityDisplayModeCompareE
    on TrustedWebActivityDisplayMode {
  Map<String, dynamic> compareToTrustedWebActivityDisplayMode(
    TrustedWebActivityDisplayMode other,
  ) {
    final Map<String, dynamic> diff = {};
    return diff;
  }
}
