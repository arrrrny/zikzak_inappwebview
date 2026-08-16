// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'url_response.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class URLResponse {
  URLResponse({
    WebUri? this.url,
    required int this.expectedContentLength,
    String? this.mimeType,
    String? this.suggestedFilename,
    String? this.textEncodingName,
    Map<String, String>? this.headers,
    int? this.statusCode,
  });

  factory URLResponse.fromJson(Map<String, dynamic> json) =>
      _$URLResponseFromJson(json);

  @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson)
  final WebUri? url;

  final int expectedContentLength;

  final String? mimeType;

  final String? suggestedFilename;

  final String? textEncodingName;

  @JsonKey(toJson: _headersToJson, fromJson: _headersFromJson)
  final Map<String, String>? headers;

  final int? statusCode;

  URLResponse copyWith({
    WebUri? url,
    int? expectedContentLength,
    String? mimeType,
    String? suggestedFilename,
    String? textEncodingName,
    Map<String, String>? headers,
    int? statusCode,
  }) {
    return URLResponse(
      url: url ?? this.url,
      expectedContentLength:
          expectedContentLength ?? this.expectedContentLength,
      mimeType: mimeType ?? this.mimeType,
      suggestedFilename: suggestedFilename ?? this.suggestedFilename,
      textEncodingName: textEncodingName ?? this.textEncodingName,
      headers: headers ?? this.headers,
      statusCode: statusCode ?? this.statusCode,
    );
  }

  URLResponse copyWithURLResponse({
    WebUri? url,
    int? expectedContentLength,
    String? mimeType,
    String? suggestedFilename,
    String? textEncodingName,
    Map<String, String>? headers,
    int? statusCode,
  }) {
    return copyWith(
      url: url,
      expectedContentLength: expectedContentLength,
      mimeType: mimeType,
      suggestedFilename: suggestedFilename,
      textEncodingName: textEncodingName,
      headers: headers,
      statusCode: statusCode,
    );
  }

  URLResponse patchWithURLResponse([URLResponsePatch? patchInput]) {
    final _patcher = patchInput ?? URLResponsePatch();
    final _patchMap = _patcher.patchMap;
    return URLResponse(
      url: _patchMap.containsKey(URLResponse$.url)
          ? (_patchMap[URLResponse$.url] is Function)
                ? _patchMap[URLResponse$.url](this.url)
                : (_patchMap[URLResponse$.url] is Patch)
                ? _patchMap[URLResponse$.url].applyTo(this.url)
                : _patchMap[URLResponse$.url]
          : this.url,
      expectedContentLength:
          _patchMap.containsKey(URLResponse$.expectedContentLength)
          ? (_patchMap[URLResponse$.expectedContentLength] is Function)
                ? _patchMap[URLResponse$.expectedContentLength](
                    this.expectedContentLength,
                  )
                : (_patchMap[URLResponse$.expectedContentLength] is Patch)
                ? _patchMap[URLResponse$.expectedContentLength].applyTo(
                    this.expectedContentLength,
                  )
                : _patchMap[URLResponse$.expectedContentLength]
          : this.expectedContentLength,
      mimeType: _patchMap.containsKey(URLResponse$.mimeType)
          ? (_patchMap[URLResponse$.mimeType] is Function)
                ? _patchMap[URLResponse$.mimeType](this.mimeType)
                : (_patchMap[URLResponse$.mimeType] is Patch)
                ? _patchMap[URLResponse$.mimeType].applyTo(this.mimeType)
                : _patchMap[URLResponse$.mimeType]
          : this.mimeType,
      suggestedFilename: _patchMap.containsKey(URLResponse$.suggestedFilename)
          ? (_patchMap[URLResponse$.suggestedFilename] is Function)
                ? _patchMap[URLResponse$.suggestedFilename](
                    this.suggestedFilename,
                  )
                : (_patchMap[URLResponse$.suggestedFilename] is Patch)
                ? _patchMap[URLResponse$.suggestedFilename].applyTo(
                    this.suggestedFilename,
                  )
                : _patchMap[URLResponse$.suggestedFilename]
          : this.suggestedFilename,
      textEncodingName: _patchMap.containsKey(URLResponse$.textEncodingName)
          ? (_patchMap[URLResponse$.textEncodingName] is Function)
                ? _patchMap[URLResponse$.textEncodingName](
                    this.textEncodingName,
                  )
                : (_patchMap[URLResponse$.textEncodingName] is Patch)
                ? _patchMap[URLResponse$.textEncodingName].applyTo(
                    this.textEncodingName,
                  )
                : _patchMap[URLResponse$.textEncodingName]
          : this.textEncodingName,
      headers: _patchMap.containsKey(URLResponse$.headers)
          ? (_patchMap[URLResponse$.headers] is Function)
                ? _patchMap[URLResponse$.headers](this.headers)
                : (_patchMap[URLResponse$.headers] is Patch)
                ? _patchMap[URLResponse$.headers].applyTo(this.headers)
                : _patchMap[URLResponse$.headers]
          : this.headers,
      statusCode: _patchMap.containsKey(URLResponse$.statusCode)
          ? (_patchMap[URLResponse$.statusCode] is Function)
                ? _patchMap[URLResponse$.statusCode](this.statusCode)
                : (_patchMap[URLResponse$.statusCode] is Patch)
                ? _patchMap[URLResponse$.statusCode].applyTo(this.statusCode)
                : _patchMap[URLResponse$.statusCode]
          : this.statusCode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is URLResponse &&
        url == other.url &&
        expectedContentLength == other.expectedContentLength &&
        mimeType == other.mimeType &&
        suggestedFilename == other.suggestedFilename &&
        textEncodingName == other.textEncodingName &&
        headers == other.headers &&
        statusCode == other.statusCode;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.url,
      this.expectedContentLength,
      this.mimeType,
      this.suggestedFilename,
      this.textEncodingName,
      this.headers,
      this.statusCode,
    );
  }

  @override
  String toString() {
    return 'URLResponse(' +
        'url: ${url}' +
        ', ' +
        'expectedContentLength: ${expectedContentLength}' +
        ', ' +
        'mimeType: ${mimeType}' +
        ', ' +
        'suggestedFilename: ${suggestedFilename}' +
        ', ' +
        'textEncodingName: ${textEncodingName}' +
        ', ' +
        'headers: ${headers}' +
        ', ' +
        'statusCode: ${statusCode})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$URLResponseToJson(this);
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

extension URLResponsePropertyHelpers on URLResponse {
  bool get hasUrl {
    return this.url != null;
  }

  bool get noUrl {
    return this.url == null;
  }

  WebUri get urlRequired {
    return this.url ?? (throw StateError('url is required but was null'));
  }

  bool get hasMimeType {
    return this.mimeType?.isNotEmpty == true;
  }

  bool get noMimeType {
    return this.mimeType?.isEmpty ?? true;
  }

  String get mimeTypeRequired {
    return this.mimeType ??
        (throw StateError('mimeType is required but was null'));
  }

  bool get hasSuggestedFilename {
    return this.suggestedFilename?.isNotEmpty == true;
  }

  bool get noSuggestedFilename {
    return this.suggestedFilename?.isEmpty ?? true;
  }

  String get suggestedFilenameRequired {
    return this.suggestedFilename ??
        (throw StateError('suggestedFilename is required but was null'));
  }

  bool get hasTextEncodingName {
    return this.textEncodingName?.isNotEmpty == true;
  }

  bool get noTextEncodingName {
    return this.textEncodingName?.isEmpty ?? true;
  }

  String get textEncodingNameRequired {
    return this.textEncodingName ??
        (throw StateError('textEncodingName is required but was null'));
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
}

extension URLResponseSerialization on URLResponse {
  Map<String, dynamic> toJson() {
    return _$URLResponseToJson(this);
  }
}

enum URLResponse$ {
  url,
  expectedContentLength,
  mimeType,
  suggestedFilename,
  textEncodingName,
  headers,
  statusCode,
}

class URLResponsePatch extends PatchBase<URLResponse, URLResponse$> {
  URLResponse applyTo(URLResponse entity) {
    return entity.patchWithURLResponse(this);
  }

  URLResponsePatch withUrl(WebUri? value) {
    patchMap[URLResponse$.url] = value;
    return this;
  }

  URLResponsePatch withExpectedContentLength(int? value) {
    patchMap[URLResponse$.expectedContentLength] = value;
    return this;
  }

  URLResponsePatch withMimeType(String? value) {
    patchMap[URLResponse$.mimeType] = value;
    return this;
  }

  URLResponsePatch withSuggestedFilename(String? value) {
    patchMap[URLResponse$.suggestedFilename] = value;
    return this;
  }

  URLResponsePatch withTextEncodingName(String? value) {
    patchMap[URLResponse$.textEncodingName] = value;
    return this;
  }

  URLResponsePatch withHeaders(Map<String, String>? value) {
    patchMap[URLResponse$.headers] = value;
    return this;
  }

  URLResponsePatch withStatusCode(int? value) {
    patchMap[URLResponse$.statusCode] = value;
    return this;
  }
}

/// Field descriptors for [URLResponse] query construction
abstract final class URLResponseFields {
  static const url = Field<URLResponse, WebUri?>('url', _$url);

  static const expectedContentLength = Field<URLResponse, int>(
    'expectedContentLength',
    _$expectedContentLength,
  );

  static const mimeType = Field<URLResponse, String?>('mimeType', _$mimeType);

  static const suggestedFilename = Field<URLResponse, String?>(
    'suggestedFilename',
    _$suggestedFilename,
  );

  static const textEncodingName = Field<URLResponse, String?>(
    'textEncodingName',
    _$textEncodingName,
  );

  static const headers = Field<URLResponse, Map<String, String>?>(
    'headers',
    _$headers,
  );

  static const statusCode = Field<URLResponse, int?>(
    'statusCode',
    _$statusCode,
  );

  static WebUri? _$url(URLResponse e) {
    return e.url;
  }

  static int _$expectedContentLength(URLResponse e) {
    return e.expectedContentLength;
  }

  static String? _$mimeType(URLResponse e) {
    return e.mimeType;
  }

  static String? _$suggestedFilename(URLResponse e) {
    return e.suggestedFilename;
  }

  static String? _$textEncodingName(URLResponse e) {
    return e.textEncodingName;
  }

  static Map<String, String>? _$headers(URLResponse e) {
    return e.headers;
  }

  static int? _$statusCode(URLResponse e) {
    return e.statusCode;
  }
}

extension URLResponseCompareE on URLResponse {
  Map<String, dynamic> compareToURLResponse(URLResponse other) {
    final Map<String, dynamic> diff = {};

    if (url != other.url) {
      diff['url'] = () => other.url;
    }

    if (expectedContentLength != other.expectedContentLength) {
      diff['expectedContentLength'] = () => other.expectedContentLength;
    }

    if (mimeType != other.mimeType) {
      diff['mimeType'] = () => other.mimeType;
    }

    if (suggestedFilename != other.suggestedFilename) {
      diff['suggestedFilename'] = () => other.suggestedFilename;
    }

    if (textEncodingName != other.textEncodingName) {
      diff['textEncodingName'] = () => other.textEncodingName;
    }

    if (headers != other.headers) {
      diff['headers'] = () => other.headers;
    }

    if (statusCode != other.statusCode) {
      diff['statusCode'] = () => other.statusCode;
    }
    return diff;
  }
}
