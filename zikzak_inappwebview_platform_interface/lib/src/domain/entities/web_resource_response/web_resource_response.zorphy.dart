// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'web_resource_response.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class WebResourceResponse {
  WebResourceResponse({
    String? contentType,
    String? contentEncoding,
    Uint8List? this.data,
    Map<String, String>? this.headers,
    int? this.statusCode,
    String? this.reasonPhrase,
  }) : this.contentType = contentType ?? '',
       this.contentEncoding = contentEncoding ?? 'utf-8';

  factory WebResourceResponse.fromJson(Map<String, dynamic> json) =>
      _$WebResourceResponseFromJson(json);

  @JsonKey(defaultValue: '')
  final String? contentType;

  @JsonKey(defaultValue: 'utf-8')
  final String? contentEncoding;

  @JsonKey(toJson: _dataToJson, fromJson: _dataFromJson)
  final Uint8List? data;

  @JsonKey(toJson: _headersToJson, fromJson: _headersFromJson)
  final Map<String, String>? headers;

  final int? statusCode;

  final String? reasonPhrase;

  WebResourceResponse copyWith({
    String? contentType,
    String? contentEncoding,
    Uint8List? data,
    Map<String, String>? headers,
    int? statusCode,
    String? reasonPhrase,
  }) {
    return WebResourceResponse(
      contentType: contentType ?? this.contentType,
      contentEncoding: contentEncoding ?? this.contentEncoding,
      data: data ?? this.data,
      headers: headers ?? this.headers,
      statusCode: statusCode ?? this.statusCode,
      reasonPhrase: reasonPhrase ?? this.reasonPhrase,
    );
  }

  WebResourceResponse copyWithWebResourceResponse({
    String? contentType,
    String? contentEncoding,
    Uint8List? data,
    Map<String, String>? headers,
    int? statusCode,
    String? reasonPhrase,
  }) {
    return copyWith(
      contentType: contentType,
      contentEncoding: contentEncoding,
      data: data,
      headers: headers,
      statusCode: statusCode,
      reasonPhrase: reasonPhrase,
    );
  }

  WebResourceResponse patchWithWebResourceResponse([
    WebResourceResponsePatch? patchInput,
  ]) {
    final _patcher = patchInput ?? WebResourceResponsePatch();
    final _patchMap = _patcher.patchMap;
    return WebResourceResponse(
      contentType: _patchMap.containsKey(WebResourceResponse$.contentType)
          ? ((_patchMap[WebResourceResponse$.contentType] is Function)
                    ? _patchMap[WebResourceResponse$.contentType](
                        this.contentType,
                      )
                    : (_patchMap[WebResourceResponse$.contentType] is Patch)
                    ? _patchMap[WebResourceResponse$.contentType].applyTo(
                        this.contentType,
                      )
                    : _patchMap[WebResourceResponse$.contentType])
                as String?
          : this.contentType,
      contentEncoding:
          _patchMap.containsKey(WebResourceResponse$.contentEncoding)
          ? ((_patchMap[WebResourceResponse$.contentEncoding] is Function)
                    ? _patchMap[WebResourceResponse$.contentEncoding](
                        this.contentEncoding,
                      )
                    : (_patchMap[WebResourceResponse$.contentEncoding] is Patch)
                    ? _patchMap[WebResourceResponse$.contentEncoding].applyTo(
                        this.contentEncoding,
                      )
                    : _patchMap[WebResourceResponse$.contentEncoding])
                as String?
          : this.contentEncoding,
      data: _patchMap.containsKey(WebResourceResponse$.data)
          ? ((_patchMap[WebResourceResponse$.data] is Function)
                    ? _patchMap[WebResourceResponse$.data](this.data)
                    : (_patchMap[WebResourceResponse$.data] is Patch)
                    ? _patchMap[WebResourceResponse$.data].applyTo(this.data)
                    : _patchMap[WebResourceResponse$.data])
                as Uint8List?
          : this.data,
      headers: _patchMap.containsKey(WebResourceResponse$.headers)
          ? ((_patchMap[WebResourceResponse$.headers] is Function)
                    ? _patchMap[WebResourceResponse$.headers](this.headers)
                    : (_patchMap[WebResourceResponse$.headers] is Patch)
                    ? _patchMap[WebResourceResponse$.headers].applyTo(
                        this.headers,
                      )
                    : _patchMap[WebResourceResponse$.headers])
                as Map<String, String>?
          : this.headers,
      statusCode: _patchMap.containsKey(WebResourceResponse$.statusCode)
          ? ((_patchMap[WebResourceResponse$.statusCode] is Function)
                    ? _patchMap[WebResourceResponse$.statusCode](
                        this.statusCode,
                      )
                    : (_patchMap[WebResourceResponse$.statusCode] is Patch)
                    ? _patchMap[WebResourceResponse$.statusCode].applyTo(
                        this.statusCode,
                      )
                    : _patchMap[WebResourceResponse$.statusCode])
                as int?
          : this.statusCode,
      reasonPhrase: _patchMap.containsKey(WebResourceResponse$.reasonPhrase)
          ? ((_patchMap[WebResourceResponse$.reasonPhrase] is Function)
                    ? _patchMap[WebResourceResponse$.reasonPhrase](
                        this.reasonPhrase,
                      )
                    : (_patchMap[WebResourceResponse$.reasonPhrase] is Patch)
                    ? _patchMap[WebResourceResponse$.reasonPhrase].applyTo(
                        this.reasonPhrase,
                      )
                    : _patchMap[WebResourceResponse$.reasonPhrase])
                as String?
          : this.reasonPhrase,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WebResourceResponse &&
        contentType == other.contentType &&
        contentEncoding == other.contentEncoding &&
        data == other.data &&
        headers == other.headers &&
        statusCode == other.statusCode &&
        reasonPhrase == other.reasonPhrase;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.contentType,
      this.contentEncoding,
      this.data,
      this.headers,
      this.statusCode,
      this.reasonPhrase,
    );
  }

  @override
  String toString() {
    return 'WebResourceResponse(' +
        'contentType: ${contentType}' +
        ', ' +
        'contentEncoding: ${contentEncoding}' +
        ', ' +
        'data: ${data}' +
        ', ' +
        'headers: ${headers}' +
        ', ' +
        'statusCode: ${statusCode}' +
        ', ' +
        'reasonPhrase: ${reasonPhrase})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$WebResourceResponseToJson(this);
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

extension WebResourceResponsePropertyHelpers on WebResourceResponse {
  bool get hasContentType {
    return this.contentType?.isNotEmpty == true;
  }

  bool get noContentType {
    return this.contentType?.isEmpty ?? true;
  }

  String get contentTypeRequired {
    return this.contentType ??
        (throw StateError('contentType is required but was null'));
  }

  bool get hasContentEncoding {
    return this.contentEncoding?.isNotEmpty == true;
  }

  bool get noContentEncoding {
    return this.contentEncoding?.isEmpty ?? true;
  }

  String get contentEncodingRequired {
    return this.contentEncoding ??
        (throw StateError('contentEncoding is required but was null'));
  }

  bool get hasData {
    return this.data != null;
  }

  bool get noData {
    return this.data == null;
  }

  Uint8List get dataRequired {
    return this.data ?? (throw StateError('data is required but was null'));
  }

  Map<String, String> get headersRequired {
    return this.headers ??
        (throw StateError('headers is required but was null'));
  }

  bool get hasHeaders {
    return this.headers?.isNotEmpty ?? false;
  }

  bool get noHeaders {
    return this.headers?.isEmpty ?? true;
  }

  bool get hasStatusCode {
    return this.statusCode != null;
  }

  bool get noStatusCode {
    return this.statusCode == null;
  }

  int get statusCodeRequired {
    return this.statusCode ??
        (throw StateError('statusCode is required but was null'));
  }

  bool get hasReasonPhrase {
    return this.reasonPhrase?.isNotEmpty == true;
  }

  bool get noReasonPhrase {
    return this.reasonPhrase?.isEmpty ?? true;
  }

  String get reasonPhraseRequired {
    return this.reasonPhrase ??
        (throw StateError('reasonPhrase is required but was null'));
  }
}

extension WebResourceResponseSerialization on WebResourceResponse {
  Map<String, dynamic> toJson() {
    return _$WebResourceResponseToJson(this);
  }
}

enum WebResourceResponse$ {
  contentType,
  contentEncoding,
  data,
  headers,
  statusCode,
  reasonPhrase,
}

class WebResourceResponsePatch
    extends PatchBase<WebResourceResponse, WebResourceResponse$> {
  WebResourceResponse applyTo(WebResourceResponse entity) {
    return entity.patchWithWebResourceResponse(this);
  }

  WebResourceResponsePatch withContentType(String? value) {
    patchMap[WebResourceResponse$.contentType] = value;
    return this;
  }

  WebResourceResponsePatch withContentEncoding(String? value) {
    patchMap[WebResourceResponse$.contentEncoding] = value;
    return this;
  }

  WebResourceResponsePatch withData(Uint8List? value) {
    patchMap[WebResourceResponse$.data] = value;
    return this;
  }

  WebResourceResponsePatch withHeaders(Map<String, String>? value) {
    patchMap[WebResourceResponse$.headers] = value;
    return this;
  }

  WebResourceResponsePatch withStatusCode(int? value) {
    patchMap[WebResourceResponse$.statusCode] = value;
    return this;
  }

  WebResourceResponsePatch withReasonPhrase(String? value) {
    patchMap[WebResourceResponse$.reasonPhrase] = value;
    return this;
  }
}

/// Field descriptors for [WebResourceResponse] query construction
abstract final class WebResourceResponseFields {
  static const contentType = Field<WebResourceResponse, String?>(
    'contentType',
    _$contentType,
  );

  static const contentEncoding = Field<WebResourceResponse, String?>(
    'contentEncoding',
    _$contentEncoding,
  );

  static const data = Field<WebResourceResponse, Uint8List?>('data', _$data);

  static const headers = Field<WebResourceResponse, Map<String, String>?>(
    'headers',
    _$headers,
  );

  static const statusCode = Field<WebResourceResponse, int?>(
    'statusCode',
    _$statusCode,
  );

  static const reasonPhrase = Field<WebResourceResponse, String?>(
    'reasonPhrase',
    _$reasonPhrase,
  );

  static String? _$contentType(WebResourceResponse e) {
    return e.contentType;
  }

  static String? _$contentEncoding(WebResourceResponse e) {
    return e.contentEncoding;
  }

  static Uint8List? _$data(WebResourceResponse e) {
    return e.data;
  }

  static Map<String, String>? _$headers(WebResourceResponse e) {
    return e.headers;
  }

  static int? _$statusCode(WebResourceResponse e) {
    return e.statusCode;
  }

  static String? _$reasonPhrase(WebResourceResponse e) {
    return e.reasonPhrase;
  }
}

extension WebResourceResponseCompareE on WebResourceResponse {
  Map<String, dynamic> compareToWebResourceResponse(WebResourceResponse other) {
    final Map<String, dynamic> diff = {};

    if (contentType != other.contentType) {
      diff['contentType'] = () => other.contentType;
    }

    if (contentEncoding != other.contentEncoding) {
      diff['contentEncoding'] = () => other.contentEncoding;
    }

    if (data != other.data) {
      diff['data'] = () => other.data;
    }

    if (headers != other.headers) {
      diff['headers'] = () => other.headers;
    }

    if (statusCode != other.statusCode) {
      diff['statusCode'] = () => other.statusCode;
    }

    if (reasonPhrase != other.reasonPhrase) {
      diff['reasonPhrase'] = () => other.reasonPhrase;
    }
    return diff;
  }
}
