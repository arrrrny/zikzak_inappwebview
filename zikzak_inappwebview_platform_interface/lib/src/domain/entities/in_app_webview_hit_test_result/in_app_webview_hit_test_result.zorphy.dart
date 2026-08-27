// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'in_app_webview_hit_test_result.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class InAppWebViewHitTestResult {
  InAppWebViewHitTestResult({
    InAppWebViewHitTestResultType? this.type,
    String? this.extra,
  });

  factory InAppWebViewHitTestResult.fromJson(Map<String, dynamic> json) =>
      _$InAppWebViewHitTestResultFromJson(json);

  @JsonKey(toJson: _typeToJson, fromJson: _typeFromJson)
  final InAppWebViewHitTestResultType? type;

  final String? extra;

  InAppWebViewHitTestResult copyWith({
    InAppWebViewHitTestResultType? type,
    String? extra,
  }) {
    return InAppWebViewHitTestResult(
      type: type ?? this.type,
      extra: extra ?? this.extra,
    );
  }

  InAppWebViewHitTestResult copyWithInAppWebViewHitTestResult({
    InAppWebViewHitTestResultType? type,
    String? extra,
  }) {
    return copyWith(type: type, extra: extra);
  }

  InAppWebViewHitTestResult patchWithInAppWebViewHitTestResult([
    InAppWebViewHitTestResultPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? InAppWebViewHitTestResultPatch();
    final _patchMap = _patcher.patchMap;
    return InAppWebViewHitTestResult(
      type: _patchMap.containsKey(InAppWebViewHitTestResult$.type)
          ? ((_patchMap[InAppWebViewHitTestResult$.type] is Function)
                    ? _patchMap[InAppWebViewHitTestResult$.type](this.type)
                    : (_patchMap[InAppWebViewHitTestResult$.type] is Patch)
                    ? _patchMap[InAppWebViewHitTestResult$.type].applyTo(
                        this.type,
                      )
                    : _patchMap[InAppWebViewHitTestResult$.type])
                as InAppWebViewHitTestResultType?
          : this.type,
      extra: _patchMap.containsKey(InAppWebViewHitTestResult$.extra)
          ? ((_patchMap[InAppWebViewHitTestResult$.extra] is Function)
                    ? _patchMap[InAppWebViewHitTestResult$.extra](this.extra)
                    : (_patchMap[InAppWebViewHitTestResult$.extra] is Patch)
                    ? _patchMap[InAppWebViewHitTestResult$.extra].applyTo(
                        this.extra,
                      )
                    : _patchMap[InAppWebViewHitTestResult$.extra])
                as String?
          : this.extra,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InAppWebViewHitTestResult &&
        type == other.type &&
        extra == other.extra;
  }

  @override
  int get hashCode {
    return Object.hash(this.type, this.extra);
  }

  @override
  String toString() {
    return 'InAppWebViewHitTestResult(' +
        'type: ${type}' +
        ', ' +
        'extra: ${extra})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$InAppWebViewHitTestResultToJson(this);
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

extension InAppWebViewHitTestResultPropertyHelpers
    on InAppWebViewHitTestResult {
  bool get hasType {
    return this.type != null;
  }

  bool get noType {
    return this.type == null;
  }

  InAppWebViewHitTestResultType get typeRequired {
    return this.type ?? (throw StateError('type is required but was null'));
  }

  bool get isTypeUNKNOWN_TYPE {
    return this.type == InAppWebViewHitTestResultType.UNKNOWN_TYPE;
  }

  bool get isTypePHONE_TYPE {
    return this.type == InAppWebViewHitTestResultType.PHONE_TYPE;
  }

  bool get isTypeGEO_TYPE {
    return this.type == InAppWebViewHitTestResultType.GEO_TYPE;
  }

  bool get isTypeEMAIL_TYPE {
    return this.type == InAppWebViewHitTestResultType.EMAIL_TYPE;
  }

  bool get isTypeIMAGE_TYPE {
    return this.type == InAppWebViewHitTestResultType.IMAGE_TYPE;
  }

  bool get isTypeSRC_ANCHOR_TYPE {
    return this.type == InAppWebViewHitTestResultType.SRC_ANCHOR_TYPE;
  }

  bool get isTypeSRC_IMAGE_ANCHOR_TYPE {
    return this.type == InAppWebViewHitTestResultType.SRC_IMAGE_ANCHOR_TYPE;
  }

  bool get isTypeEDIT_TEXT_TYPE {
    return this.type == InAppWebViewHitTestResultType.EDIT_TEXT_TYPE;
  }

  bool get hasExtra {
    return this.extra?.isNotEmpty == true;
  }

  bool get noExtra {
    return this.extra?.isEmpty ?? true;
  }

  String get extraRequired {
    return this.extra ?? (throw StateError('extra is required but was null'));
  }
}

extension InAppWebViewHitTestResultSerialization on InAppWebViewHitTestResult {
  Map<String, dynamic> toJson() {
    return _$InAppWebViewHitTestResultToJson(this);
  }
}

enum InAppWebViewHitTestResult$ { type, extra }

class InAppWebViewHitTestResultPatch
    extends PatchBase<InAppWebViewHitTestResult, InAppWebViewHitTestResult$> {
  InAppWebViewHitTestResult applyTo(InAppWebViewHitTestResult entity) {
    return entity.patchWithInAppWebViewHitTestResult(this);
  }

  InAppWebViewHitTestResultPatch withType(
    InAppWebViewHitTestResultType? value,
  ) {
    patchMap[InAppWebViewHitTestResult$.type] = value;
    return this;
  }

  InAppWebViewHitTestResultPatch withExtra(String? value) {
    patchMap[InAppWebViewHitTestResult$.extra] = value;
    return this;
  }
}

/// Field descriptors for [InAppWebViewHitTestResult] query construction
abstract final class InAppWebViewHitTestResultFields {
  static const type =
      Field<InAppWebViewHitTestResult, InAppWebViewHitTestResultType?>(
        'type',
        _$type,
      );

  static const extra = Field<InAppWebViewHitTestResult, String?>(
    'extra',
    _$extra,
  );

  static InAppWebViewHitTestResultType? _$type(InAppWebViewHitTestResult e) {
    return e.type;
  }

  static String? _$extra(InAppWebViewHitTestResult e) {
    return e.extra;
  }
}

extension InAppWebViewHitTestResultCompareE on InAppWebViewHitTestResult {
  Map<String, dynamic> compareToInAppWebViewHitTestResult(
    InAppWebViewHitTestResult other,
  ) {
    final Map<String, dynamic> diff = {};

    if (type != other.type) {
      diff['type'] = () => other.type;
    }

    if (extra != other.extra) {
      diff['extra'] = () => other.extra;
    }
    return diff;
  }
}
