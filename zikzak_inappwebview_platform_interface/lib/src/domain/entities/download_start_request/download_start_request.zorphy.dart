// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'download_start_request.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class DownloadStartRequest {
  DownloadStartRequest({
    required WebUri this.url,
    String? this.userAgent,
    String? this.contentDisposition,
    String? this.mimeType,
    required int this.contentLength,
    String? this.suggestedFilename,
    String? this.textEncodingName,
  });

  factory DownloadStartRequest.fromJson(Map<String, dynamic> json) =>
      _$DownloadStartRequestFromJson(json);

  @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson)
  final WebUri url;

  final String? userAgent;

  final String? contentDisposition;

  final String? mimeType;

  final int contentLength;

  final String? suggestedFilename;

  final String? textEncodingName;

  DownloadStartRequest copyWith({
    WebUri? url,
    String? userAgent,
    String? contentDisposition,
    String? mimeType,
    int? contentLength,
    String? suggestedFilename,
    String? textEncodingName,
  }) {
    return DownloadStartRequest(
      url: url ?? this.url,
      userAgent: userAgent ?? this.userAgent,
      contentDisposition: contentDisposition ?? this.contentDisposition,
      mimeType: mimeType ?? this.mimeType,
      contentLength: contentLength ?? this.contentLength,
      suggestedFilename: suggestedFilename ?? this.suggestedFilename,
      textEncodingName: textEncodingName ?? this.textEncodingName,
    );
  }

  DownloadStartRequest copyWithDownloadStartRequest({
    WebUri? url,
    String? userAgent,
    String? contentDisposition,
    String? mimeType,
    int? contentLength,
    String? suggestedFilename,
    String? textEncodingName,
  }) {
    return copyWith(
      url: url,
      userAgent: userAgent,
      contentDisposition: contentDisposition,
      mimeType: mimeType,
      contentLength: contentLength,
      suggestedFilename: suggestedFilename,
      textEncodingName: textEncodingName,
    );
  }

  DownloadStartRequest patchWithDownloadStartRequest([
    DownloadStartRequestPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? DownloadStartRequestPatch();
    final _patchMap = _patcher.patchMap;
    return DownloadStartRequest(
      url: _patchMap.containsKey(DownloadStartRequest$.url)
          ? (_patchMap[DownloadStartRequest$.url] is Function)
                ? _patchMap[DownloadStartRequest$.url](this.url)
                : (_patchMap[DownloadStartRequest$.url] is Patch)
                ? _patchMap[DownloadStartRequest$.url].applyTo(this.url)
                : _patchMap[DownloadStartRequest$.url]
          : this.url,
      userAgent: _patchMap.containsKey(DownloadStartRequest$.userAgent)
          ? (_patchMap[DownloadStartRequest$.userAgent] is Function)
                ? _patchMap[DownloadStartRequest$.userAgent](this.userAgent)
                : (_patchMap[DownloadStartRequest$.userAgent] is Patch)
                ? _patchMap[DownloadStartRequest$.userAgent].applyTo(
                    this.userAgent,
                  )
                : _patchMap[DownloadStartRequest$.userAgent]
          : this.userAgent,
      contentDisposition:
          _patchMap.containsKey(DownloadStartRequest$.contentDisposition)
          ? (_patchMap[DownloadStartRequest$.contentDisposition] is Function)
                ? _patchMap[DownloadStartRequest$.contentDisposition](
                    this.contentDisposition,
                  )
                : (_patchMap[DownloadStartRequest$.contentDisposition] is Patch)
                ? _patchMap[DownloadStartRequest$.contentDisposition].applyTo(
                    this.contentDisposition,
                  )
                : _patchMap[DownloadStartRequest$.contentDisposition]
          : this.contentDisposition,
      mimeType: _patchMap.containsKey(DownloadStartRequest$.mimeType)
          ? (_patchMap[DownloadStartRequest$.mimeType] is Function)
                ? _patchMap[DownloadStartRequest$.mimeType](this.mimeType)
                : (_patchMap[DownloadStartRequest$.mimeType] is Patch)
                ? _patchMap[DownloadStartRequest$.mimeType].applyTo(
                    this.mimeType,
                  )
                : _patchMap[DownloadStartRequest$.mimeType]
          : this.mimeType,
      contentLength: _patchMap.containsKey(DownloadStartRequest$.contentLength)
          ? (_patchMap[DownloadStartRequest$.contentLength] is Function)
                ? _patchMap[DownloadStartRequest$.contentLength](
                    this.contentLength,
                  )
                : (_patchMap[DownloadStartRequest$.contentLength] is Patch)
                ? _patchMap[DownloadStartRequest$.contentLength].applyTo(
                    this.contentLength,
                  )
                : _patchMap[DownloadStartRequest$.contentLength]
          : this.contentLength,
      suggestedFilename:
          _patchMap.containsKey(DownloadStartRequest$.suggestedFilename)
          ? (_patchMap[DownloadStartRequest$.suggestedFilename] is Function)
                ? _patchMap[DownloadStartRequest$.suggestedFilename](
                    this.suggestedFilename,
                  )
                : (_patchMap[DownloadStartRequest$.suggestedFilename] is Patch)
                ? _patchMap[DownloadStartRequest$.suggestedFilename].applyTo(
                    this.suggestedFilename,
                  )
                : _patchMap[DownloadStartRequest$.suggestedFilename]
          : this.suggestedFilename,
      textEncodingName:
          _patchMap.containsKey(DownloadStartRequest$.textEncodingName)
          ? (_patchMap[DownloadStartRequest$.textEncodingName] is Function)
                ? _patchMap[DownloadStartRequest$.textEncodingName](
                    this.textEncodingName,
                  )
                : (_patchMap[DownloadStartRequest$.textEncodingName] is Patch)
                ? _patchMap[DownloadStartRequest$.textEncodingName].applyTo(
                    this.textEncodingName,
                  )
                : _patchMap[DownloadStartRequest$.textEncodingName]
          : this.textEncodingName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DownloadStartRequest &&
        url == other.url &&
        userAgent == other.userAgent &&
        contentDisposition == other.contentDisposition &&
        mimeType == other.mimeType &&
        contentLength == other.contentLength &&
        suggestedFilename == other.suggestedFilename &&
        textEncodingName == other.textEncodingName;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.url,
      this.userAgent,
      this.contentDisposition,
      this.mimeType,
      this.contentLength,
      this.suggestedFilename,
      this.textEncodingName,
    );
  }

  @override
  String toString() {
    return 'DownloadStartRequest(' +
        'url: ${url}' +
        ', ' +
        'userAgent: ${userAgent}' +
        ', ' +
        'contentDisposition: ${contentDisposition}' +
        ', ' +
        'mimeType: ${mimeType}' +
        ', ' +
        'contentLength: ${contentLength}' +
        ', ' +
        'suggestedFilename: ${suggestedFilename}' +
        ', ' +
        'textEncodingName: ${textEncodingName})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$DownloadStartRequestToJson(this);
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

extension DownloadStartRequestPropertyHelpers on DownloadStartRequest {
  bool get hasUserAgent {
    return this.userAgent?.isNotEmpty == true;
  }

  bool get noUserAgent {
    return this.userAgent?.isEmpty ?? true;
  }

  String get userAgentRequired {
    return this.userAgent ??
        (throw StateError('userAgent is required but was null'));
  }

  bool get hasContentDisposition {
    return this.contentDisposition?.isNotEmpty == true;
  }

  bool get noContentDisposition {
    return this.contentDisposition?.isEmpty ?? true;
  }

  String get contentDispositionRequired {
    return this.contentDisposition ??
        (throw StateError('contentDisposition is required but was null'));
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
}

extension DownloadStartRequestSerialization on DownloadStartRequest {
  Map<String, dynamic> toJson() {
    return _$DownloadStartRequestToJson(this);
  }
}

enum DownloadStartRequest$ {
  url,
  userAgent,
  contentDisposition,
  mimeType,
  contentLength,
  suggestedFilename,
  textEncodingName,
}

class DownloadStartRequestPatch
    extends PatchBase<DownloadStartRequest, DownloadStartRequest$> {
  DownloadStartRequest applyTo(DownloadStartRequest entity) {
    return entity.patchWithDownloadStartRequest(this);
  }

  DownloadStartRequestPatch withUrl(WebUri? value) {
    patchMap[DownloadStartRequest$.url] = value;
    return this;
  }

  DownloadStartRequestPatch withUserAgent(String? value) {
    patchMap[DownloadStartRequest$.userAgent] = value;
    return this;
  }

  DownloadStartRequestPatch withContentDisposition(String? value) {
    patchMap[DownloadStartRequest$.contentDisposition] = value;
    return this;
  }

  DownloadStartRequestPatch withMimeType(String? value) {
    patchMap[DownloadStartRequest$.mimeType] = value;
    return this;
  }

  DownloadStartRequestPatch withContentLength(int? value) {
    patchMap[DownloadStartRequest$.contentLength] = value;
    return this;
  }

  DownloadStartRequestPatch withSuggestedFilename(String? value) {
    patchMap[DownloadStartRequest$.suggestedFilename] = value;
    return this;
  }

  DownloadStartRequestPatch withTextEncodingName(String? value) {
    patchMap[DownloadStartRequest$.textEncodingName] = value;
    return this;
  }
}

/// Field descriptors for [DownloadStartRequest] query construction
abstract final class DownloadStartRequestFields {
  static const url = Field<DownloadStartRequest, WebUri>('url', _$url);

  static const userAgent = Field<DownloadStartRequest, String?>(
    'userAgent',
    _$userAgent,
  );

  static const contentDisposition = Field<DownloadStartRequest, String?>(
    'contentDisposition',
    _$contentDisposition,
  );

  static const mimeType = Field<DownloadStartRequest, String?>(
    'mimeType',
    _$mimeType,
  );

  static const contentLength = Field<DownloadStartRequest, int>(
    'contentLength',
    _$contentLength,
  );

  static const suggestedFilename = Field<DownloadStartRequest, String?>(
    'suggestedFilename',
    _$suggestedFilename,
  );

  static const textEncodingName = Field<DownloadStartRequest, String?>(
    'textEncodingName',
    _$textEncodingName,
  );

  static WebUri _$url(DownloadStartRequest e) {
    return e.url;
  }

  static String? _$userAgent(DownloadStartRequest e) {
    return e.userAgent;
  }

  static String? _$contentDisposition(DownloadStartRequest e) {
    return e.contentDisposition;
  }

  static String? _$mimeType(DownloadStartRequest e) {
    return e.mimeType;
  }

  static int _$contentLength(DownloadStartRequest e) {
    return e.contentLength;
  }

  static String? _$suggestedFilename(DownloadStartRequest e) {
    return e.suggestedFilename;
  }

  static String? _$textEncodingName(DownloadStartRequest e) {
    return e.textEncodingName;
  }
}

extension DownloadStartRequestCompareE on DownloadStartRequest {
  Map<String, dynamic> compareToDownloadStartRequest(
    DownloadStartRequest other,
  ) {
    final Map<String, dynamic> diff = {};

    if (url != other.url) {
      diff['url'] = () => other.url;
    }

    if (userAgent != other.userAgent) {
      diff['userAgent'] = () => other.userAgent;
    }

    if (contentDisposition != other.contentDisposition) {
      diff['contentDisposition'] = () => other.contentDisposition;
    }

    if (mimeType != other.mimeType) {
      diff['mimeType'] = () => other.mimeType;
    }

    if (contentLength != other.contentLength) {
      diff['contentLength'] = () => other.contentLength;
    }

    if (suggestedFilename != other.suggestedFilename) {
      diff['suggestedFilename'] = () => other.suggestedFilename;
    }

    if (textEncodingName != other.textEncodingName) {
      diff['textEncodingName'] = () => other.textEncodingName;
    }
    return diff;
  }
}
