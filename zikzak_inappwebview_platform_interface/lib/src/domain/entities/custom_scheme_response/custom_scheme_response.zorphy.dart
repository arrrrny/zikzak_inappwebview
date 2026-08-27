// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'custom_scheme_response.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class CustomSchemeResponse {
  CustomSchemeResponse({
    required Uint8List this.data,
    required String this.contentType,
    String? contentEncoding,
  }) : this.contentEncoding = contentEncoding ?? 'utf-8';

  factory CustomSchemeResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomSchemeResponseFromJson(json);

  @JsonKey(toJson: _dataToJson, fromJson: _dataFromJson)
  final Uint8List data;

  final String contentType;

  @JsonKey(defaultValue: 'utf-8')
  final String contentEncoding;

  CustomSchemeResponse copyWith({
    Uint8List? data,
    String? contentType,
    String? contentEncoding,
  }) {
    return CustomSchemeResponse(
      data: data ?? this.data,
      contentType: contentType ?? this.contentType,
      contentEncoding: contentEncoding ?? this.contentEncoding,
    );
  }

  CustomSchemeResponse copyWithCustomSchemeResponse({
    Uint8List? data,
    String? contentType,
    String? contentEncoding,
  }) {
    return copyWith(
      data: data,
      contentType: contentType,
      contentEncoding: contentEncoding,
    );
  }

  CustomSchemeResponse patchWithCustomSchemeResponse([
    CustomSchemeResponsePatch? patchInput,
  ]) {
    final _patcher = patchInput ?? CustomSchemeResponsePatch();
    final _patchMap = _patcher.patchMap;
    return CustomSchemeResponse(
      data: _patchMap.containsKey(CustomSchemeResponse$.data)
          ? (_patchMap[CustomSchemeResponse$.data] is Function)
                ? _patchMap[CustomSchemeResponse$.data](this.data)
                : (_patchMap[CustomSchemeResponse$.data] is Patch)
                ? _patchMap[CustomSchemeResponse$.data].applyTo(this.data)
                : _patchMap[CustomSchemeResponse$.data]
          : this.data,
      contentType: _patchMap.containsKey(CustomSchemeResponse$.contentType)
          ? (_patchMap[CustomSchemeResponse$.contentType] is Function)
                ? _patchMap[CustomSchemeResponse$.contentType](this.contentType)
                : (_patchMap[CustomSchemeResponse$.contentType] is Patch)
                ? _patchMap[CustomSchemeResponse$.contentType].applyTo(
                    this.contentType,
                  )
                : _patchMap[CustomSchemeResponse$.contentType]
          : this.contentType,
      contentEncoding:
          _patchMap.containsKey(CustomSchemeResponse$.contentEncoding)
          ? (_patchMap[CustomSchemeResponse$.contentEncoding] is Function)
                ? _patchMap[CustomSchemeResponse$.contentEncoding](
                    this.contentEncoding,
                  )
                : (_patchMap[CustomSchemeResponse$.contentEncoding] is Patch)
                ? _patchMap[CustomSchemeResponse$.contentEncoding].applyTo(
                    this.contentEncoding,
                  )
                : _patchMap[CustomSchemeResponse$.contentEncoding]
          : this.contentEncoding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomSchemeResponse &&
        data == other.data &&
        contentType == other.contentType &&
        contentEncoding == other.contentEncoding;
  }

  @override
  int get hashCode {
    return Object.hash(this.data, this.contentType, this.contentEncoding);
  }

  @override
  String toString() {
    return 'CustomSchemeResponse(' +
        'data: ${data}' +
        ', ' +
        'contentType: ${contentType}' +
        ', ' +
        'contentEncoding: ${contentEncoding})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$CustomSchemeResponseToJson(this);
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

extension CustomSchemeResponsePropertyHelpers on CustomSchemeResponse {
  bool get hasContentType {
    return this.contentType.isNotEmpty;
  }

  bool get noContentType {
    return this.contentType.isEmpty;
  }

  bool get hasContentEncoding {
    return this.contentEncoding.isNotEmpty;
  }

  bool get noContentEncoding {
    return this.contentEncoding.isEmpty;
  }
}

extension CustomSchemeResponseSerialization on CustomSchemeResponse {
  Map<String, dynamic> toJson() {
    return _$CustomSchemeResponseToJson(this);
  }
}

enum CustomSchemeResponse$ { data, contentType, contentEncoding }

class CustomSchemeResponsePatch
    extends PatchBase<CustomSchemeResponse, CustomSchemeResponse$> {
  CustomSchemeResponse applyTo(CustomSchemeResponse entity) {
    return entity.patchWithCustomSchemeResponse(this);
  }

  CustomSchemeResponsePatch withData(Uint8List? value) {
    patchMap[CustomSchemeResponse$.data] = value;
    return this;
  }

  CustomSchemeResponsePatch withContentType(String? value) {
    patchMap[CustomSchemeResponse$.contentType] = value;
    return this;
  }

  CustomSchemeResponsePatch withContentEncoding(String? value) {
    patchMap[CustomSchemeResponse$.contentEncoding] = value;
    return this;
  }
}

/// Field descriptors for [CustomSchemeResponse] query construction
abstract final class CustomSchemeResponseFields {
  static const data = Field<CustomSchemeResponse, Uint8List>('data', _$data);

  static const contentType = Field<CustomSchemeResponse, String>(
    'contentType',
    _$contentType,
  );

  static const contentEncoding = Field<CustomSchemeResponse, String>(
    'contentEncoding',
    _$contentEncoding,
  );

  static Uint8List _$data(CustomSchemeResponse e) {
    return e.data;
  }

  static String _$contentType(CustomSchemeResponse e) {
    return e.contentType;
  }

  static String _$contentEncoding(CustomSchemeResponse e) {
    return e.contentEncoding;
  }
}

extension CustomSchemeResponseCompareE on CustomSchemeResponse {
  Map<String, dynamic> compareToCustomSchemeResponse(
    CustomSchemeResponse other,
  ) {
    final Map<String, dynamic> diff = {};

    if (data != other.data) {
      diff['data'] = () => other.data;
    }

    if (contentType != other.contentType) {
      diff['contentType'] = () => other.contentType;
    }

    if (contentEncoding != other.contentEncoding) {
      diff['contentEncoding'] = () => other.contentEncoding;
    }
    return diff;
  }
}
