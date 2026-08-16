// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'in_app_webview_initial_data.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class InAppWebViewInitialData {
  InAppWebViewInitialData({
    required String this.data,
    String? mimeType,
    String? encoding,
    WebUri? this.baseUrl,
    WebUri? this.historyUrl,
  }) : this.mimeType = mimeType ?? "text/html",
       this.encoding = encoding ?? "utf8";

  factory InAppWebViewInitialData.fromJson(Map<String, dynamic> json) =>
      _$InAppWebViewInitialDataFromJson(json);

  final String data;

  @JsonKey(defaultValue: "text/html")
  final String mimeType;

  @JsonKey(defaultValue: "utf8")
  final String encoding;

  @JsonKey(toJson: _baseUrlToJson, fromJson: _baseUrlFromJson)
  final WebUri? baseUrl;

  @JsonKey(toJson: _historyUrlToJson, fromJson: _historyUrlFromJson)
  final WebUri? historyUrl;

  InAppWebViewInitialData copyWith({
    String? data,
    String? mimeType,
    String? encoding,
    WebUri? baseUrl,
    WebUri? historyUrl,
  }) {
    return InAppWebViewInitialData(
      data: data ?? this.data,
      mimeType: mimeType ?? this.mimeType,
      encoding: encoding ?? this.encoding,
      baseUrl: baseUrl ?? this.baseUrl,
      historyUrl: historyUrl ?? this.historyUrl,
    );
  }

  InAppWebViewInitialData copyWithInAppWebViewInitialData({
    String? data,
    String? mimeType,
    String? encoding,
    WebUri? baseUrl,
    WebUri? historyUrl,
  }) {
    return copyWith(
      data: data,
      mimeType: mimeType,
      encoding: encoding,
      baseUrl: baseUrl,
      historyUrl: historyUrl,
    );
  }

  InAppWebViewInitialData patchWithInAppWebViewInitialData([
    InAppWebViewInitialDataPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? InAppWebViewInitialDataPatch();
    final _patchMap = _patcher.patchMap;
    return InAppWebViewInitialData(
      data: _patchMap.containsKey(InAppWebViewInitialData$.data)
          ? (_patchMap[InAppWebViewInitialData$.data] is Function)
                ? _patchMap[InAppWebViewInitialData$.data](this.data)
                : (_patchMap[InAppWebViewInitialData$.data] is Patch)
                ? _patchMap[InAppWebViewInitialData$.data].applyTo(this.data)
                : _patchMap[InAppWebViewInitialData$.data]
          : this.data,
      mimeType: _patchMap.containsKey(InAppWebViewInitialData$.mimeType)
          ? (_patchMap[InAppWebViewInitialData$.mimeType] is Function)
                ? _patchMap[InAppWebViewInitialData$.mimeType](this.mimeType)
                : (_patchMap[InAppWebViewInitialData$.mimeType] is Patch)
                ? _patchMap[InAppWebViewInitialData$.mimeType].applyTo(
                    this.mimeType,
                  )
                : _patchMap[InAppWebViewInitialData$.mimeType]
          : this.mimeType,
      encoding: _patchMap.containsKey(InAppWebViewInitialData$.encoding)
          ? (_patchMap[InAppWebViewInitialData$.encoding] is Function)
                ? _patchMap[InAppWebViewInitialData$.encoding](this.encoding)
                : (_patchMap[InAppWebViewInitialData$.encoding] is Patch)
                ? _patchMap[InAppWebViewInitialData$.encoding].applyTo(
                    this.encoding,
                  )
                : _patchMap[InAppWebViewInitialData$.encoding]
          : this.encoding,
      baseUrl: _patchMap.containsKey(InAppWebViewInitialData$.baseUrl)
          ? (_patchMap[InAppWebViewInitialData$.baseUrl] is Function)
                ? _patchMap[InAppWebViewInitialData$.baseUrl](this.baseUrl)
                : (_patchMap[InAppWebViewInitialData$.baseUrl] is Patch)
                ? _patchMap[InAppWebViewInitialData$.baseUrl].applyTo(
                    this.baseUrl,
                  )
                : _patchMap[InAppWebViewInitialData$.baseUrl]
          : this.baseUrl,
      historyUrl: _patchMap.containsKey(InAppWebViewInitialData$.historyUrl)
          ? (_patchMap[InAppWebViewInitialData$.historyUrl] is Function)
                ? _patchMap[InAppWebViewInitialData$.historyUrl](
                    this.historyUrl,
                  )
                : (_patchMap[InAppWebViewInitialData$.historyUrl] is Patch)
                ? _patchMap[InAppWebViewInitialData$.historyUrl].applyTo(
                    this.historyUrl,
                  )
                : _patchMap[InAppWebViewInitialData$.historyUrl]
          : this.historyUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InAppWebViewInitialData &&
        data == other.data &&
        mimeType == other.mimeType &&
        encoding == other.encoding &&
        baseUrl == other.baseUrl &&
        historyUrl == other.historyUrl;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.data,
      this.mimeType,
      this.encoding,
      this.baseUrl,
      this.historyUrl,
    );
  }

  @override
  String toString() {
    return 'InAppWebViewInitialData(' +
        'data: ${data}' +
        ', ' +
        'mimeType: ${mimeType}' +
        ', ' +
        'encoding: ${encoding}' +
        ', ' +
        'baseUrl: ${baseUrl}' +
        ', ' +
        'historyUrl: ${historyUrl})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$InAppWebViewInitialDataToJson(this);
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

extension InAppWebViewInitialDataPropertyHelpers on InAppWebViewInitialData {
  bool get hasData {
    return this.data.isNotEmpty;
  }

  bool get noData {
    return this.data.isEmpty;
  }

  bool get hasMimeType {
    return this.mimeType.isNotEmpty;
  }

  bool get noMimeType {
    return this.mimeType.isEmpty;
  }

  bool get hasEncoding {
    return this.encoding.isNotEmpty;
  }

  bool get noEncoding {
    return this.encoding.isEmpty;
  }

  bool get hasBaseUrl {
    return this.baseUrl != null;
  }

  bool get noBaseUrl {
    return this.baseUrl == null;
  }

  WebUri get baseUrlRequired {
    return this.baseUrl ??
        (throw StateError('baseUrl is required but was null'));
  }

  bool get hasHistoryUrl {
    return this.historyUrl != null;
  }

  bool get noHistoryUrl {
    return this.historyUrl == null;
  }

  WebUri get historyUrlRequired {
    return this.historyUrl ??
        (throw StateError('historyUrl is required but was null'));
  }
}

extension InAppWebViewInitialDataSerialization on InAppWebViewInitialData {
  Map<String, dynamic> toJson() {
    return _$InAppWebViewInitialDataToJson(this);
  }
}

enum InAppWebViewInitialData$ { data, mimeType, encoding, baseUrl, historyUrl }

class InAppWebViewInitialDataPatch
    extends PatchBase<InAppWebViewInitialData, InAppWebViewInitialData$> {
  InAppWebViewInitialData applyTo(InAppWebViewInitialData entity) {
    return entity.patchWithInAppWebViewInitialData(this);
  }

  InAppWebViewInitialDataPatch withData(String? value) {
    patchMap[InAppWebViewInitialData$.data] = value;
    return this;
  }

  InAppWebViewInitialDataPatch withMimeType(String? value) {
    patchMap[InAppWebViewInitialData$.mimeType] = value;
    return this;
  }

  InAppWebViewInitialDataPatch withEncoding(String? value) {
    patchMap[InAppWebViewInitialData$.encoding] = value;
    return this;
  }

  InAppWebViewInitialDataPatch withBaseUrl(WebUri? value) {
    patchMap[InAppWebViewInitialData$.baseUrl] = value;
    return this;
  }

  InAppWebViewInitialDataPatch withHistoryUrl(WebUri? value) {
    patchMap[InAppWebViewInitialData$.historyUrl] = value;
    return this;
  }
}

/// Field descriptors for [InAppWebViewInitialData] query construction
abstract final class InAppWebViewInitialDataFields {
  static const data = Field<InAppWebViewInitialData, String>('data', _$data);

  static const mimeType = Field<InAppWebViewInitialData, String>(
    'mimeType',
    _$mimeType,
  );

  static const encoding = Field<InAppWebViewInitialData, String>(
    'encoding',
    _$encoding,
  );

  static const baseUrl = Field<InAppWebViewInitialData, WebUri?>(
    'baseUrl',
    _$baseUrl,
  );

  static const historyUrl = Field<InAppWebViewInitialData, WebUri?>(
    'historyUrl',
    _$historyUrl,
  );

  static String _$data(InAppWebViewInitialData e) {
    return e.data;
  }

  static String _$mimeType(InAppWebViewInitialData e) {
    return e.mimeType;
  }

  static String _$encoding(InAppWebViewInitialData e) {
    return e.encoding;
  }

  static WebUri? _$baseUrl(InAppWebViewInitialData e) {
    return e.baseUrl;
  }

  static WebUri? _$historyUrl(InAppWebViewInitialData e) {
    return e.historyUrl;
  }
}

extension InAppWebViewInitialDataCompareE on InAppWebViewInitialData {
  Map<String, dynamic> compareToInAppWebViewInitialData(
    InAppWebViewInitialData other,
  ) {
    final Map<String, dynamic> diff = {};

    if (data != other.data) {
      diff['data'] = () => other.data;
    }

    if (mimeType != other.mimeType) {
      diff['mimeType'] = () => other.mimeType;
    }

    if (encoding != other.encoding) {
      diff['encoding'] = () => other.encoding;
    }

    if (baseUrl != other.baseUrl) {
      diff['baseUrl'] = () => other.baseUrl;
    }

    if (historyUrl != other.historyUrl) {
      diff['historyUrl'] = () => other.historyUrl;
    }
    return diff;
  }
}
