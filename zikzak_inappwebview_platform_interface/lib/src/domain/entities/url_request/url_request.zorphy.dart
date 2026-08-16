// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'url_request.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class URLRequest {
  URLRequest({
    WebUri? this.url,
    String? this.method,
    Map<String, String>? this.headers,
    Uint8List? this.body,
    bool? this.allowsCellularAccess,
    bool? this.allowsConstrainedNetworkAccess,
    bool? this.allowsExpensiveNetworkAccess,
    URLRequestCachePolicy? this.cachePolicy,
    bool? this.httpShouldHandleCookies,
    bool? this.httpShouldUsePipelining,
    URLRequestNetworkServiceType? this.networkServiceType,
    double? this.timeoutInterval,
    WebUri? this.mainDocumentURL,
    bool? this.assumesHTTP3Capable,
    URLRequestAttribution? this.attribution,
  });

  factory URLRequest.fromJson(Map<String, dynamic> json) =>
      _$URLRequestFromJson(json);

  @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson)
  final WebUri? url;

  final String? method;

  @JsonKey(toJson: _headersToJson, fromJson: _headersFromJson)
  final Map<String, String>? headers;

  @JsonKey(toJson: _bodyToJson, fromJson: _bodyFromJson)
  final Uint8List? body;

  final bool? allowsCellularAccess;

  final bool? allowsConstrainedNetworkAccess;

  final bool? allowsExpensiveNetworkAccess;

  @JsonKey(toJson: _cachePolicyToJson, fromJson: _cachePolicyFromJson)
  final URLRequestCachePolicy? cachePolicy;

  final bool? httpShouldHandleCookies;

  final bool? httpShouldUsePipelining;

  @JsonKey(
    toJson: _networkServiceTypeToJson,
    fromJson: _networkServiceTypeFromJson,
  )
  final URLRequestNetworkServiceType? networkServiceType;

  final double? timeoutInterval;

  @JsonKey(toJson: _mainDocumentURLToJson, fromJson: _mainDocumentURLFromJson)
  final WebUri? mainDocumentURL;

  final bool? assumesHTTP3Capable;

  @JsonKey(toJson: _attributionToJson, fromJson: _attributionFromJson)
  final URLRequestAttribution? attribution;

  URLRequest copyWith({
    WebUri? url,
    String? method,
    Map<String, String>? headers,
    Uint8List? body,
    bool? allowsCellularAccess,
    bool? allowsConstrainedNetworkAccess,
    bool? allowsExpensiveNetworkAccess,
    URLRequestCachePolicy? cachePolicy,
    bool? httpShouldHandleCookies,
    bool? httpShouldUsePipelining,
    URLRequestNetworkServiceType? networkServiceType,
    double? timeoutInterval,
    WebUri? mainDocumentURL,
    bool? assumesHTTP3Capable,
    URLRequestAttribution? attribution,
  }) {
    return URLRequest(
      url: url ?? this.url,
      method: method ?? this.method,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      allowsCellularAccess: allowsCellularAccess ?? this.allowsCellularAccess,
      allowsConstrainedNetworkAccess:
          allowsConstrainedNetworkAccess ?? this.allowsConstrainedNetworkAccess,
      allowsExpensiveNetworkAccess:
          allowsExpensiveNetworkAccess ?? this.allowsExpensiveNetworkAccess,
      cachePolicy: cachePolicy ?? this.cachePolicy,
      httpShouldHandleCookies:
          httpShouldHandleCookies ?? this.httpShouldHandleCookies,
      httpShouldUsePipelining:
          httpShouldUsePipelining ?? this.httpShouldUsePipelining,
      networkServiceType: networkServiceType ?? this.networkServiceType,
      timeoutInterval: timeoutInterval ?? this.timeoutInterval,
      mainDocumentURL: mainDocumentURL ?? this.mainDocumentURL,
      assumesHTTP3Capable: assumesHTTP3Capable ?? this.assumesHTTP3Capable,
      attribution: attribution ?? this.attribution,
    );
  }

  URLRequest copyWithURLRequest({
    WebUri? url,
    String? method,
    Map<String, String>? headers,
    Uint8List? body,
    bool? allowsCellularAccess,
    bool? allowsConstrainedNetworkAccess,
    bool? allowsExpensiveNetworkAccess,
    URLRequestCachePolicy? cachePolicy,
    bool? httpShouldHandleCookies,
    bool? httpShouldUsePipelining,
    URLRequestNetworkServiceType? networkServiceType,
    double? timeoutInterval,
    WebUri? mainDocumentURL,
    bool? assumesHTTP3Capable,
    URLRequestAttribution? attribution,
  }) {
    return copyWith(
      url: url,
      method: method,
      headers: headers,
      body: body,
      allowsCellularAccess: allowsCellularAccess,
      allowsConstrainedNetworkAccess: allowsConstrainedNetworkAccess,
      allowsExpensiveNetworkAccess: allowsExpensiveNetworkAccess,
      cachePolicy: cachePolicy,
      httpShouldHandleCookies: httpShouldHandleCookies,
      httpShouldUsePipelining: httpShouldUsePipelining,
      networkServiceType: networkServiceType,
      timeoutInterval: timeoutInterval,
      mainDocumentURL: mainDocumentURL,
      assumesHTTP3Capable: assumesHTTP3Capable,
      attribution: attribution,
    );
  }

  URLRequest patchWithURLRequest([URLRequestPatch? patchInput]) {
    final _patcher = patchInput ?? URLRequestPatch();
    final _patchMap = _patcher.patchMap;
    return URLRequest(
      url: _patchMap.containsKey(URLRequest$.url)
          ? (_patchMap[URLRequest$.url] is Function)
                ? _patchMap[URLRequest$.url](this.url)
                : (_patchMap[URLRequest$.url] is Patch)
                ? _patchMap[URLRequest$.url].applyTo(this.url)
                : _patchMap[URLRequest$.url]
          : this.url,
      method: _patchMap.containsKey(URLRequest$.method)
          ? (_patchMap[URLRequest$.method] is Function)
                ? _patchMap[URLRequest$.method](this.method)
                : (_patchMap[URLRequest$.method] is Patch)
                ? _patchMap[URLRequest$.method].applyTo(this.method)
                : _patchMap[URLRequest$.method]
          : this.method,
      headers: _patchMap.containsKey(URLRequest$.headers)
          ? (_patchMap[URLRequest$.headers] is Function)
                ? _patchMap[URLRequest$.headers](this.headers)
                : (_patchMap[URLRequest$.headers] is Patch)
                ? _patchMap[URLRequest$.headers].applyTo(this.headers)
                : _patchMap[URLRequest$.headers]
          : this.headers,
      body: _patchMap.containsKey(URLRequest$.body)
          ? (_patchMap[URLRequest$.body] is Function)
                ? _patchMap[URLRequest$.body](this.body)
                : (_patchMap[URLRequest$.body] is Patch)
                ? _patchMap[URLRequest$.body].applyTo(this.body)
                : _patchMap[URLRequest$.body]
          : this.body,
      allowsCellularAccess:
          _patchMap.containsKey(URLRequest$.allowsCellularAccess)
          ? (_patchMap[URLRequest$.allowsCellularAccess] is Function)
                ? _patchMap[URLRequest$.allowsCellularAccess](
                    this.allowsCellularAccess,
                  )
                : (_patchMap[URLRequest$.allowsCellularAccess] is Patch)
                ? _patchMap[URLRequest$.allowsCellularAccess].applyTo(
                    this.allowsCellularAccess,
                  )
                : _patchMap[URLRequest$.allowsCellularAccess]
          : this.allowsCellularAccess,
      allowsConstrainedNetworkAccess:
          _patchMap.containsKey(URLRequest$.allowsConstrainedNetworkAccess)
          ? (_patchMap[URLRequest$.allowsConstrainedNetworkAccess] is Function)
                ? _patchMap[URLRequest$.allowsConstrainedNetworkAccess](
                    this.allowsConstrainedNetworkAccess,
                  )
                : (_patchMap[URLRequest$.allowsConstrainedNetworkAccess]
                      is Patch)
                ? _patchMap[URLRequest$.allowsConstrainedNetworkAccess].applyTo(
                    this.allowsConstrainedNetworkAccess,
                  )
                : _patchMap[URLRequest$.allowsConstrainedNetworkAccess]
          : this.allowsConstrainedNetworkAccess,
      allowsExpensiveNetworkAccess:
          _patchMap.containsKey(URLRequest$.allowsExpensiveNetworkAccess)
          ? (_patchMap[URLRequest$.allowsExpensiveNetworkAccess] is Function)
                ? _patchMap[URLRequest$.allowsExpensiveNetworkAccess](
                    this.allowsExpensiveNetworkAccess,
                  )
                : (_patchMap[URLRequest$.allowsExpensiveNetworkAccess] is Patch)
                ? _patchMap[URLRequest$.allowsExpensiveNetworkAccess].applyTo(
                    this.allowsExpensiveNetworkAccess,
                  )
                : _patchMap[URLRequest$.allowsExpensiveNetworkAccess]
          : this.allowsExpensiveNetworkAccess,
      cachePolicy: _patchMap.containsKey(URLRequest$.cachePolicy)
          ? (_patchMap[URLRequest$.cachePolicy] is Function)
                ? _patchMap[URLRequest$.cachePolicy](this.cachePolicy)
                : (_patchMap[URLRequest$.cachePolicy] is Patch)
                ? _patchMap[URLRequest$.cachePolicy].applyTo(this.cachePolicy)
                : _patchMap[URLRequest$.cachePolicy]
          : this.cachePolicy,
      httpShouldHandleCookies:
          _patchMap.containsKey(URLRequest$.httpShouldHandleCookies)
          ? (_patchMap[URLRequest$.httpShouldHandleCookies] is Function)
                ? _patchMap[URLRequest$.httpShouldHandleCookies](
                    this.httpShouldHandleCookies,
                  )
                : (_patchMap[URLRequest$.httpShouldHandleCookies] is Patch)
                ? _patchMap[URLRequest$.httpShouldHandleCookies].applyTo(
                    this.httpShouldHandleCookies,
                  )
                : _patchMap[URLRequest$.httpShouldHandleCookies]
          : this.httpShouldHandleCookies,
      httpShouldUsePipelining:
          _patchMap.containsKey(URLRequest$.httpShouldUsePipelining)
          ? (_patchMap[URLRequest$.httpShouldUsePipelining] is Function)
                ? _patchMap[URLRequest$.httpShouldUsePipelining](
                    this.httpShouldUsePipelining,
                  )
                : (_patchMap[URLRequest$.httpShouldUsePipelining] is Patch)
                ? _patchMap[URLRequest$.httpShouldUsePipelining].applyTo(
                    this.httpShouldUsePipelining,
                  )
                : _patchMap[URLRequest$.httpShouldUsePipelining]
          : this.httpShouldUsePipelining,
      networkServiceType: _patchMap.containsKey(URLRequest$.networkServiceType)
          ? (_patchMap[URLRequest$.networkServiceType] is Function)
                ? _patchMap[URLRequest$.networkServiceType](
                    this.networkServiceType,
                  )
                : (_patchMap[URLRequest$.networkServiceType] is Patch)
                ? _patchMap[URLRequest$.networkServiceType].applyTo(
                    this.networkServiceType,
                  )
                : _patchMap[URLRequest$.networkServiceType]
          : this.networkServiceType,
      timeoutInterval: _patchMap.containsKey(URLRequest$.timeoutInterval)
          ? (_patchMap[URLRequest$.timeoutInterval] is Function)
                ? _patchMap[URLRequest$.timeoutInterval](this.timeoutInterval)
                : (_patchMap[URLRequest$.timeoutInterval] is Patch)
                ? _patchMap[URLRequest$.timeoutInterval].applyTo(
                    this.timeoutInterval,
                  )
                : _patchMap[URLRequest$.timeoutInterval]
          : this.timeoutInterval,
      mainDocumentURL: _patchMap.containsKey(URLRequest$.mainDocumentURL)
          ? (_patchMap[URLRequest$.mainDocumentURL] is Function)
                ? _patchMap[URLRequest$.mainDocumentURL](this.mainDocumentURL)
                : (_patchMap[URLRequest$.mainDocumentURL] is Patch)
                ? _patchMap[URLRequest$.mainDocumentURL].applyTo(
                    this.mainDocumentURL,
                  )
                : _patchMap[URLRequest$.mainDocumentURL]
          : this.mainDocumentURL,
      assumesHTTP3Capable:
          _patchMap.containsKey(URLRequest$.assumesHTTP3Capable)
          ? (_patchMap[URLRequest$.assumesHTTP3Capable] is Function)
                ? _patchMap[URLRequest$.assumesHTTP3Capable](
                    this.assumesHTTP3Capable,
                  )
                : (_patchMap[URLRequest$.assumesHTTP3Capable] is Patch)
                ? _patchMap[URLRequest$.assumesHTTP3Capable].applyTo(
                    this.assumesHTTP3Capable,
                  )
                : _patchMap[URLRequest$.assumesHTTP3Capable]
          : this.assumesHTTP3Capable,
      attribution: _patchMap.containsKey(URLRequest$.attribution)
          ? (_patchMap[URLRequest$.attribution] is Function)
                ? _patchMap[URLRequest$.attribution](this.attribution)
                : (_patchMap[URLRequest$.attribution] is Patch)
                ? _patchMap[URLRequest$.attribution].applyTo(this.attribution)
                : _patchMap[URLRequest$.attribution]
          : this.attribution,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is URLRequest &&
        url == other.url &&
        method == other.method &&
        headers == other.headers &&
        body == other.body &&
        allowsCellularAccess == other.allowsCellularAccess &&
        allowsConstrainedNetworkAccess ==
            other.allowsConstrainedNetworkAccess &&
        allowsExpensiveNetworkAccess == other.allowsExpensiveNetworkAccess &&
        cachePolicy == other.cachePolicy &&
        httpShouldHandleCookies == other.httpShouldHandleCookies &&
        httpShouldUsePipelining == other.httpShouldUsePipelining &&
        networkServiceType == other.networkServiceType &&
        timeoutInterval == other.timeoutInterval &&
        mainDocumentURL == other.mainDocumentURL &&
        assumesHTTP3Capable == other.assumesHTTP3Capable &&
        attribution == other.attribution;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.url,
      this.method,
      this.headers,
      this.body,
      this.allowsCellularAccess,
      this.allowsConstrainedNetworkAccess,
      this.allowsExpensiveNetworkAccess,
      this.cachePolicy,
      this.httpShouldHandleCookies,
      this.httpShouldUsePipelining,
      this.networkServiceType,
      this.timeoutInterval,
      this.mainDocumentURL,
      this.assumesHTTP3Capable,
      this.attribution,
    );
  }

  @override
  String toString() {
    return 'URLRequest(' +
        'url: ${url}' +
        ', ' +
        'method: ${method}' +
        ', ' +
        'headers: ${headers}' +
        ', ' +
        'body: ${body}' +
        ', ' +
        'allowsCellularAccess: ${allowsCellularAccess}' +
        ', ' +
        'allowsConstrainedNetworkAccess: ${allowsConstrainedNetworkAccess}' +
        ', ' +
        'allowsExpensiveNetworkAccess: ${allowsExpensiveNetworkAccess}' +
        ', ' +
        'cachePolicy: ${cachePolicy}' +
        ', ' +
        'httpShouldHandleCookies: ${httpShouldHandleCookies}' +
        ', ' +
        'httpShouldUsePipelining: ${httpShouldUsePipelining}' +
        ', ' +
        'networkServiceType: ${networkServiceType}' +
        ', ' +
        'timeoutInterval: ${timeoutInterval}' +
        ', ' +
        'mainDocumentURL: ${mainDocumentURL}' +
        ', ' +
        'assumesHTTP3Capable: ${assumesHTTP3Capable}' +
        ', ' +
        'attribution: ${attribution})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$URLRequestToJson(this);
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

extension URLRequestPropertyHelpers on URLRequest {
  bool get hasUrl {
    return this.url != null;
  }

  bool get noUrl {
    return this.url == null;
  }

  WebUri get urlRequired {
    return this.url ?? (throw StateError('url is required but was null'));
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

  bool get hasBody {
    return this.body != null;
  }

  bool get noBody {
    return this.body == null;
  }

  Uint8List get bodyRequired {
    return this.body ?? (throw StateError('body is required but was null'));
  }

  bool get hasAllowsCellularAccess {
    return this.allowsCellularAccess != null;
  }

  bool get noAllowsCellularAccess {
    return this.allowsCellularAccess == null;
  }

  bool get allowsCellularAccessRequired {
    return this.allowsCellularAccess ??
        (throw StateError('allowsCellularAccess is required but was null'));
  }

  bool get hasAllowsConstrainedNetworkAccess {
    return this.allowsConstrainedNetworkAccess != null;
  }

  bool get noAllowsConstrainedNetworkAccess {
    return this.allowsConstrainedNetworkAccess == null;
  }

  bool get allowsConstrainedNetworkAccessRequired {
    return this.allowsConstrainedNetworkAccess ??
        (throw StateError(
          'allowsConstrainedNetworkAccess is required but was null',
        ));
  }

  bool get hasAllowsExpensiveNetworkAccess {
    return this.allowsExpensiveNetworkAccess != null;
  }

  bool get noAllowsExpensiveNetworkAccess {
    return this.allowsExpensiveNetworkAccess == null;
  }

  bool get allowsExpensiveNetworkAccessRequired {
    return this.allowsExpensiveNetworkAccess ??
        (throw StateError(
          'allowsExpensiveNetworkAccess is required but was null',
        ));
  }

  bool get hasCachePolicy {
    return this.cachePolicy != null;
  }

  bool get noCachePolicy {
    return this.cachePolicy == null;
  }

  URLRequestCachePolicy get cachePolicyRequired {
    return this.cachePolicy ??
        (throw StateError('cachePolicy is required but was null'));
  }

  bool get isCachePolicyUSE_PROTOCOL_CACHE_POLICY {
    return this.cachePolicy == URLRequestCachePolicy.USE_PROTOCOL_CACHE_POLICY;
  }

  bool get isCachePolicyRELOAD_IGNORING_LOCAL_CACHE_DATA {
    return this.cachePolicy ==
        URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_CACHE_DATA;
  }

  bool get isCachePolicyRETURN_CACHE_DATA_ELSE_LOAD {
    return this.cachePolicy ==
        URLRequestCachePolicy.RETURN_CACHE_DATA_ELSE_LOAD;
  }

  bool get isCachePolicyRETURN_CACHE_DATA_DONT_LOAD {
    return this.cachePolicy ==
        URLRequestCachePolicy.RETURN_CACHE_DATA_DONT_LOAD;
  }

  bool get isCachePolicyRELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA {
    return this.cachePolicy ==
        URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA;
  }

  bool get isCachePolicyRELOAD_REVALIDATING_CACHE_DATA {
    return this.cachePolicy ==
        URLRequestCachePolicy.RELOAD_REVALIDATING_CACHE_DATA;
  }

  bool get hasHttpShouldHandleCookies {
    return this.httpShouldHandleCookies != null;
  }

  bool get noHttpShouldHandleCookies {
    return this.httpShouldHandleCookies == null;
  }

  bool get httpShouldHandleCookiesRequired {
    return this.httpShouldHandleCookies ??
        (throw StateError('httpShouldHandleCookies is required but was null'));
  }

  bool get hasHttpShouldUsePipelining {
    return this.httpShouldUsePipelining != null;
  }

  bool get noHttpShouldUsePipelining {
    return this.httpShouldUsePipelining == null;
  }

  bool get httpShouldUsePipeliningRequired {
    return this.httpShouldUsePipelining ??
        (throw StateError('httpShouldUsePipelining is required but was null'));
  }

  bool get hasNetworkServiceType {
    return this.networkServiceType != null;
  }

  bool get noNetworkServiceType {
    return this.networkServiceType == null;
  }

  URLRequestNetworkServiceType get networkServiceTypeRequired {
    return this.networkServiceType ??
        (throw StateError('networkServiceType is required but was null'));
  }

  bool get isNetworkServiceTypeDEFAULT {
    return this.networkServiceType == URLRequestNetworkServiceType.DEFAULT;
  }

  bool get isNetworkServiceTypeVIDEO {
    return this.networkServiceType == URLRequestNetworkServiceType.VIDEO;
  }

  bool get isNetworkServiceTypeBACKGROUND {
    return this.networkServiceType == URLRequestNetworkServiceType.BACKGROUND;
  }

  bool get isNetworkServiceTypeVOICE {
    return this.networkServiceType == URLRequestNetworkServiceType.VOICE;
  }

  bool get isNetworkServiceTypeRESPONSIVE_DATA {
    return this.networkServiceType ==
        URLRequestNetworkServiceType.RESPONSIVE_DATA;
  }

  bool get isNetworkServiceTypeAV_STREAMING {
    return this.networkServiceType == URLRequestNetworkServiceType.AV_STREAMING;
  }

  bool get isNetworkServiceTypeRESPONSIVE_AV {
    return this.networkServiceType ==
        URLRequestNetworkServiceType.RESPONSIVE_AV;
  }

  bool get isNetworkServiceTypeCALL_SIGNALING {
    return this.networkServiceType ==
        URLRequestNetworkServiceType.CALL_SIGNALING;
  }

  bool get hasTimeoutInterval {
    return this.timeoutInterval != null;
  }

  bool get noTimeoutInterval {
    return this.timeoutInterval == null;
  }

  double get timeoutIntervalRequired {
    return this.timeoutInterval ??
        (throw StateError('timeoutInterval is required but was null'));
  }

  bool get hasMainDocumentURL {
    return this.mainDocumentURL != null;
  }

  bool get noMainDocumentURL {
    return this.mainDocumentURL == null;
  }

  WebUri get mainDocumentURLRequired {
    return this.mainDocumentURL ??
        (throw StateError('mainDocumentURL is required but was null'));
  }

  bool get hasAssumesHTTP3Capable {
    return this.assumesHTTP3Capable != null;
  }

  bool get noAssumesHTTP3Capable {
    return this.assumesHTTP3Capable == null;
  }

  bool get assumesHTTP3CapableRequired {
    return this.assumesHTTP3Capable ??
        (throw StateError('assumesHTTP3Capable is required but was null'));
  }

  bool get hasAttribution {
    return this.attribution != null;
  }

  bool get noAttribution {
    return this.attribution == null;
  }

  URLRequestAttribution get attributionRequired {
    return this.attribution ??
        (throw StateError('attribution is required but was null'));
  }

  bool get isAttributionDEVELOPER {
    return this.attribution == URLRequestAttribution.DEVELOPER;
  }

  bool get isAttributionUSER {
    return this.attribution == URLRequestAttribution.USER;
  }
}

extension URLRequestSerialization on URLRequest {
  Map<String, dynamic> toJson() {
    return _$URLRequestToJson(this);
  }
}

enum URLRequest$ {
  url,
  method,
  headers,
  body,
  allowsCellularAccess,
  allowsConstrainedNetworkAccess,
  allowsExpensiveNetworkAccess,
  cachePolicy,
  httpShouldHandleCookies,
  httpShouldUsePipelining,
  networkServiceType,
  timeoutInterval,
  mainDocumentURL,
  assumesHTTP3Capable,
  attribution,
}

class URLRequestPatch extends PatchBase<URLRequest, URLRequest$> {
  URLRequest applyTo(URLRequest entity) {
    return entity.patchWithURLRequest(this);
  }

  URLRequestPatch withUrl(WebUri? value) {
    patchMap[URLRequest$.url] = value;
    return this;
  }

  URLRequestPatch withMethod(String? value) {
    patchMap[URLRequest$.method] = value;
    return this;
  }

  URLRequestPatch withHeaders(Map<String, String>? value) {
    patchMap[URLRequest$.headers] = value;
    return this;
  }

  URLRequestPatch withBody(Uint8List? value) {
    patchMap[URLRequest$.body] = value;
    return this;
  }

  URLRequestPatch withAllowsCellularAccess(bool? value) {
    patchMap[URLRequest$.allowsCellularAccess] = value;
    return this;
  }

  URLRequestPatch withAllowsConstrainedNetworkAccess(bool? value) {
    patchMap[URLRequest$.allowsConstrainedNetworkAccess] = value;
    return this;
  }

  URLRequestPatch withAllowsExpensiveNetworkAccess(bool? value) {
    patchMap[URLRequest$.allowsExpensiveNetworkAccess] = value;
    return this;
  }

  URLRequestPatch withCachePolicy(URLRequestCachePolicy? value) {
    patchMap[URLRequest$.cachePolicy] = value;
    return this;
  }

  URLRequestPatch withHttpShouldHandleCookies(bool? value) {
    patchMap[URLRequest$.httpShouldHandleCookies] = value;
    return this;
  }

  URLRequestPatch withHttpShouldUsePipelining(bool? value) {
    patchMap[URLRequest$.httpShouldUsePipelining] = value;
    return this;
  }

  URLRequestPatch withNetworkServiceType(URLRequestNetworkServiceType? value) {
    patchMap[URLRequest$.networkServiceType] = value;
    return this;
  }

  URLRequestPatch withTimeoutInterval(double? value) {
    patchMap[URLRequest$.timeoutInterval] = value;
    return this;
  }

  URLRequestPatch withMainDocumentURL(WebUri? value) {
    patchMap[URLRequest$.mainDocumentURL] = value;
    return this;
  }

  URLRequestPatch withAssumesHTTP3Capable(bool? value) {
    patchMap[URLRequest$.assumesHTTP3Capable] = value;
    return this;
  }

  URLRequestPatch withAttribution(URLRequestAttribution? value) {
    patchMap[URLRequest$.attribution] = value;
    return this;
  }
}

/// Field descriptors for [URLRequest] query construction
abstract final class URLRequestFields {
  static const url = Field<URLRequest, WebUri?>('url', _$url);

  static const method = Field<URLRequest, String?>('method', _$method);

  static const headers = Field<URLRequest, Map<String, String>?>(
    'headers',
    _$headers,
  );

  static const body = Field<URLRequest, Uint8List?>('body', _$body);

  static const allowsCellularAccess = Field<URLRequest, bool?>(
    'allowsCellularAccess',
    _$allowsCellularAccess,
  );

  static const allowsConstrainedNetworkAccess = Field<URLRequest, bool?>(
    'allowsConstrainedNetworkAccess',
    _$allowsConstrainedNetworkAccess,
  );

  static const allowsExpensiveNetworkAccess = Field<URLRequest, bool?>(
    'allowsExpensiveNetworkAccess',
    _$allowsExpensiveNetworkAccess,
  );

  static const cachePolicy = Field<URLRequest, URLRequestCachePolicy?>(
    'cachePolicy',
    _$cachePolicy,
  );

  static const httpShouldHandleCookies = Field<URLRequest, bool?>(
    'httpShouldHandleCookies',
    _$httpShouldHandleCookies,
  );

  static const httpShouldUsePipelining = Field<URLRequest, bool?>(
    'httpShouldUsePipelining',
    _$httpShouldUsePipelining,
  );

  static const networkServiceType =
      Field<URLRequest, URLRequestNetworkServiceType?>(
        'networkServiceType',
        _$networkServiceType,
      );

  static const timeoutInterval = Field<URLRequest, double?>(
    'timeoutInterval',
    _$timeoutInterval,
  );

  static const mainDocumentURL = Field<URLRequest, WebUri?>(
    'mainDocumentURL',
    _$mainDocumentURL,
  );

  static const assumesHTTP3Capable = Field<URLRequest, bool?>(
    'assumesHTTP3Capable',
    _$assumesHTTP3Capable,
  );

  static const attribution = Field<URLRequest, URLRequestAttribution?>(
    'attribution',
    _$attribution,
  );

  static WebUri? _$url(URLRequest e) {
    return e.url;
  }

  static String? _$method(URLRequest e) {
    return e.method;
  }

  static Map<String, String>? _$headers(URLRequest e) {
    return e.headers;
  }

  static Uint8List? _$body(URLRequest e) {
    return e.body;
  }

  static bool? _$allowsCellularAccess(URLRequest e) {
    return e.allowsCellularAccess;
  }

  static bool? _$allowsConstrainedNetworkAccess(URLRequest e) {
    return e.allowsConstrainedNetworkAccess;
  }

  static bool? _$allowsExpensiveNetworkAccess(URLRequest e) {
    return e.allowsExpensiveNetworkAccess;
  }

  static URLRequestCachePolicy? _$cachePolicy(URLRequest e) {
    return e.cachePolicy;
  }

  static bool? _$httpShouldHandleCookies(URLRequest e) {
    return e.httpShouldHandleCookies;
  }

  static bool? _$httpShouldUsePipelining(URLRequest e) {
    return e.httpShouldUsePipelining;
  }

  static URLRequestNetworkServiceType? _$networkServiceType(URLRequest e) {
    return e.networkServiceType;
  }

  static double? _$timeoutInterval(URLRequest e) {
    return e.timeoutInterval;
  }

  static WebUri? _$mainDocumentURL(URLRequest e) {
    return e.mainDocumentURL;
  }

  static bool? _$assumesHTTP3Capable(URLRequest e) {
    return e.assumesHTTP3Capable;
  }

  static URLRequestAttribution? _$attribution(URLRequest e) {
    return e.attribution;
  }
}

extension URLRequestCompareE on URLRequest {
  Map<String, dynamic> compareToURLRequest(URLRequest other) {
    final Map<String, dynamic> diff = {};

    if (url != other.url) {
      diff['url'] = () => other.url;
    }

    if (method != other.method) {
      diff['method'] = () => other.method;
    }

    if (headers != other.headers) {
      diff['headers'] = () => other.headers;
    }

    if (body != other.body) {
      diff['body'] = () => other.body;
    }

    if (allowsCellularAccess != other.allowsCellularAccess) {
      diff['allowsCellularAccess'] = () => other.allowsCellularAccess;
    }

    if (allowsConstrainedNetworkAccess !=
        other.allowsConstrainedNetworkAccess) {
      diff['allowsConstrainedNetworkAccess'] = () =>
          other.allowsConstrainedNetworkAccess;
    }

    if (allowsExpensiveNetworkAccess != other.allowsExpensiveNetworkAccess) {
      diff['allowsExpensiveNetworkAccess'] = () =>
          other.allowsExpensiveNetworkAccess;
    }

    if (cachePolicy != other.cachePolicy) {
      diff['cachePolicy'] = () => other.cachePolicy;
    }

    if (httpShouldHandleCookies != other.httpShouldHandleCookies) {
      diff['httpShouldHandleCookies'] = () => other.httpShouldHandleCookies;
    }

    if (httpShouldUsePipelining != other.httpShouldUsePipelining) {
      diff['httpShouldUsePipelining'] = () => other.httpShouldUsePipelining;
    }

    if (networkServiceType != other.networkServiceType) {
      diff['networkServiceType'] = () => other.networkServiceType;
    }

    if (timeoutInterval != other.timeoutInterval) {
      diff['timeoutInterval'] = () => other.timeoutInterval;
    }

    if (mainDocumentURL != other.mainDocumentURL) {
      diff['mainDocumentURL'] = () => other.mainDocumentURL;
    }

    if (assumesHTTP3Capable != other.assumesHTTP3Capable) {
      diff['assumesHTTP3Capable'] = () => other.assumesHTTP3Capable;
    }

    if (attribution != other.attribution) {
      diff['attribution'] = () => other.attribution;
    }
    return diff;
  }
}
