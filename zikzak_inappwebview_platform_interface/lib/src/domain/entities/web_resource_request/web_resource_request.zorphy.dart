// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'web_resource_request.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class WebResourceRequest {
  WebResourceRequest({
    WebUri? this.url,
    Map<String, String>? this.headers,
    String? this.method,
    bool? this.hasGesture,
    bool? this.isForMainFrame,
    bool? this.isRedirect,
  });

  factory WebResourceRequest.fromJson(Map<String, dynamic> json) =>
      _$WebResourceRequestFromJson(json);

  @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson)
  final WebUri? url;

  @JsonKey(toJson: _headersToJson, fromJson: _headersFromJson)
  final Map<String, String>? headers;

  final String? method;

  final bool? hasGesture;

  final bool? isForMainFrame;

  final bool? isRedirect;

  WebResourceRequest copyWith({
    WebUri? url,
    Map<String, String>? headers,
    String? method,
    bool? hasGesture,
    bool? isForMainFrame,
    bool? isRedirect,
  }) {
    return WebResourceRequest(
      url: url ?? this.url,
      headers: headers ?? this.headers,
      method: method ?? this.method,
      hasGesture: hasGesture ?? this.hasGesture,
      isForMainFrame: isForMainFrame ?? this.isForMainFrame,
      isRedirect: isRedirect ?? this.isRedirect,
    );
  }

  WebResourceRequest copyWithWebResourceRequest({
    WebUri? url,
    Map<String, String>? headers,
    String? method,
    bool? hasGesture,
    bool? isForMainFrame,
    bool? isRedirect,
  }) {
    return copyWith(
      url: url,
      headers: headers,
      method: method,
      hasGesture: hasGesture,
      isForMainFrame: isForMainFrame,
      isRedirect: isRedirect,
    );
  }

  WebResourceRequest patchWithWebResourceRequest([
    WebResourceRequestPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? WebResourceRequestPatch();
    final _patchMap = _patcher.patchMap;
    return WebResourceRequest(
      url: _patchMap.containsKey(WebResourceRequest$.url)
          ? ((_patchMap[WebResourceRequest$.url] is Function)
                    ? _patchMap[WebResourceRequest$.url](this.url)
                    : (_patchMap[WebResourceRequest$.url] is Patch)
                    ? _patchMap[WebResourceRequest$.url].applyTo(this.url)
                    : _patchMap[WebResourceRequest$.url])
                as WebUri?
          : this.url,
      headers: _patchMap.containsKey(WebResourceRequest$.headers)
          ? ((_patchMap[WebResourceRequest$.headers] is Function)
                    ? _patchMap[WebResourceRequest$.headers](this.headers)
                    : (_patchMap[WebResourceRequest$.headers] is Patch)
                    ? _patchMap[WebResourceRequest$.headers].applyTo(
                        this.headers,
                      )
                    : _patchMap[WebResourceRequest$.headers])
                as Map<String, String>?
          : this.headers,
      method: _patchMap.containsKey(WebResourceRequest$.method)
          ? ((_patchMap[WebResourceRequest$.method] is Function)
                    ? _patchMap[WebResourceRequest$.method](this.method)
                    : (_patchMap[WebResourceRequest$.method] is Patch)
                    ? _patchMap[WebResourceRequest$.method].applyTo(this.method)
                    : _patchMap[WebResourceRequest$.method])
                as String?
          : this.method,
      hasGesture: _patchMap.containsKey(WebResourceRequest$.hasGesture)
          ? ((_patchMap[WebResourceRequest$.hasGesture] is Function)
                    ? _patchMap[WebResourceRequest$.hasGesture](this.hasGesture)
                    : (_patchMap[WebResourceRequest$.hasGesture] is Patch)
                    ? _patchMap[WebResourceRequest$.hasGesture].applyTo(
                        this.hasGesture,
                      )
                    : _patchMap[WebResourceRequest$.hasGesture])
                as bool?
          : this.hasGesture,
      isForMainFrame: _patchMap.containsKey(WebResourceRequest$.isForMainFrame)
          ? ((_patchMap[WebResourceRequest$.isForMainFrame] is Function)
                    ? _patchMap[WebResourceRequest$.isForMainFrame](
                        this.isForMainFrame,
                      )
                    : (_patchMap[WebResourceRequest$.isForMainFrame] is Patch)
                    ? _patchMap[WebResourceRequest$.isForMainFrame].applyTo(
                        this.isForMainFrame,
                      )
                    : _patchMap[WebResourceRequest$.isForMainFrame])
                as bool?
          : this.isForMainFrame,
      isRedirect: _patchMap.containsKey(WebResourceRequest$.isRedirect)
          ? ((_patchMap[WebResourceRequest$.isRedirect] is Function)
                    ? _patchMap[WebResourceRequest$.isRedirect](this.isRedirect)
                    : (_patchMap[WebResourceRequest$.isRedirect] is Patch)
                    ? _patchMap[WebResourceRequest$.isRedirect].applyTo(
                        this.isRedirect,
                      )
                    : _patchMap[WebResourceRequest$.isRedirect])
                as bool?
          : this.isRedirect,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WebResourceRequest &&
        url == other.url &&
        headers == other.headers &&
        method == other.method &&
        hasGesture == other.hasGesture &&
        isForMainFrame == other.isForMainFrame &&
        isRedirect == other.isRedirect;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.url,
      this.headers,
      this.method,
      this.hasGesture,
      this.isForMainFrame,
      this.isRedirect,
    );
  }

  @override
  String toString() {
    return 'WebResourceRequest(' +
        'url: ${url}' +
        ', ' +
        'headers: ${headers}' +
        ', ' +
        'method: ${method}' +
        ', ' +
        'hasGesture: ${hasGesture}' +
        ', ' +
        'isForMainFrame: ${isForMainFrame}' +
        ', ' +
        'isRedirect: ${isRedirect})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$WebResourceRequestToJson(this);
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

extension WebResourceRequestPropertyHelpers on WebResourceRequest {
  bool get hasUrl {
    return this.url != null;
  }

  bool get noUrl {
    return this.url == null;
  }

  WebUri get urlRequired {
    return this.url ?? (throw StateError('url is required but was null'));
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

  bool get hasMethod {
    return this.method?.isNotEmpty == true;
  }

  bool get noMethod {
    return this.method?.isEmpty ?? true;
  }

  String get methodRequired {
    return this.method ?? (throw StateError('method is required but was null'));
  }

  bool get hasHasGesture {
    return this.hasGesture != null;
  }

  bool get noHasGesture {
    return this.hasGesture == null;
  }

  bool get hasGestureRequired {
    return this.hasGesture ??
        (throw StateError('hasGesture is required but was null'));
  }

  bool get hasIsForMainFrame {
    return this.isForMainFrame != null;
  }

  bool get noIsForMainFrame {
    return this.isForMainFrame == null;
  }

  bool get isForMainFrameRequired {
    return this.isForMainFrame ??
        (throw StateError('isForMainFrame is required but was null'));
  }

  bool get hasIsRedirect {
    return this.isRedirect != null;
  }

  bool get noIsRedirect {
    return this.isRedirect == null;
  }

  bool get isRedirectRequired {
    return this.isRedirect ??
        (throw StateError('isRedirect is required but was null'));
  }
}

extension WebResourceRequestSerialization on WebResourceRequest {
  Map<String, dynamic> toJson() {
    return _$WebResourceRequestToJson(this);
  }
}

enum WebResourceRequest$ {
  url,
  headers,
  method,
  hasGesture,
  isForMainFrame,
  isRedirect,
}

class WebResourceRequestPatch
    extends PatchBase<WebResourceRequest, WebResourceRequest$> {
  WebResourceRequest applyTo(WebResourceRequest entity) {
    return entity.patchWithWebResourceRequest(this);
  }

  WebResourceRequestPatch withUrl(WebUri? value) {
    patchMap[WebResourceRequest$.url] = value;
    return this;
  }

  WebResourceRequestPatch withHeaders(Map<String, String>? value) {
    patchMap[WebResourceRequest$.headers] = value;
    return this;
  }

  WebResourceRequestPatch withMethod(String? value) {
    patchMap[WebResourceRequest$.method] = value;
    return this;
  }

  WebResourceRequestPatch withHasGesture(bool? value) {
    patchMap[WebResourceRequest$.hasGesture] = value;
    return this;
  }

  WebResourceRequestPatch withIsForMainFrame(bool? value) {
    patchMap[WebResourceRequest$.isForMainFrame] = value;
    return this;
  }

  WebResourceRequestPatch withIsRedirect(bool? value) {
    patchMap[WebResourceRequest$.isRedirect] = value;
    return this;
  }
}

/// Field descriptors for [WebResourceRequest] query construction
abstract final class WebResourceRequestFields {
  static const url = Field<WebResourceRequest, WebUri?>('url', _$url);

  static const headers = Field<WebResourceRequest, Map<String, String>?>(
    'headers',
    _$headers,
  );

  static const method = Field<WebResourceRequest, String?>('method', _$method);

  static const hasGesture = Field<WebResourceRequest, bool?>(
    'hasGesture',
    _$hasGesture,
  );

  static const isForMainFrame = Field<WebResourceRequest, bool?>(
    'isForMainFrame',
    _$isForMainFrame,
  );

  static const isRedirect = Field<WebResourceRequest, bool?>(
    'isRedirect',
    _$isRedirect,
  );

  static WebUri? _$url(WebResourceRequest e) {
    return e.url;
  }

  static Map<String, String>? _$headers(WebResourceRequest e) {
    return e.headers;
  }

  static String? _$method(WebResourceRequest e) {
    return e.method;
  }

  static bool? _$hasGesture(WebResourceRequest e) {
    return e.hasGesture;
  }

  static bool? _$isForMainFrame(WebResourceRequest e) {
    return e.isForMainFrame;
  }

  static bool? _$isRedirect(WebResourceRequest e) {
    return e.isRedirect;
  }
}

extension WebResourceRequestCompareE on WebResourceRequest {
  Map<String, dynamic> compareToWebResourceRequest(WebResourceRequest other) {
    final Map<String, dynamic> diff = {};

    if (url != other.url) {
      diff['url'] = () => other.url;
    }

    if (headers != other.headers) {
      diff['headers'] = () => other.headers;
    }

    if (method != other.method) {
      diff['method'] = () => other.method;
    }

    if (hasGesture != other.hasGesture) {
      diff['hasGesture'] = () => other.hasGesture;
    }

    if (isForMainFrame != other.isForMainFrame) {
      diff['isForMainFrame'] = () => other.isForMainFrame;
    }

    if (isRedirect != other.isRedirect) {
      diff['isRedirect'] = () => other.isRedirect;
    }
    return diff;
  }
}
