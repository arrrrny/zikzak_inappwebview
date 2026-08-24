// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'fetch_request.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class FetchRequest {
  FetchRequest({
    WebUri? this.url,
    String? this.method,
    Map<String, dynamic>? this.headers,
    dynamic this.body,
    String? this.mode,
    FetchRequestCredential? this.credentials,
    String? this.cache,
    String? this.redirect,
    String? this.referrer,
    ReferrerPolicy? this.referrerPolicy,
    String? this.integrity,
    bool? this.keepalive,
    FetchRequestAction? action,
  }) : this.action = action ?? FetchRequestAction.PROCEED;

  factory FetchRequest.fromJson(Map<String, dynamic> json) =>
      _$FetchRequestFromJson(json);

  @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson)
  final WebUri? url;

  final String? method;

  @JsonKey(toJson: _headersToJson, fromJson: _headersFromJson)
  final Map<String, dynamic>? headers;

  final dynamic body;

  final String? mode;

  @JsonKey(toJson: _credentialsToJson, fromJson: _credentialsFromJson)
  final FetchRequestCredential? credentials;

  final String? cache;

  final String? redirect;

  final String? referrer;

  @JsonKey(toJson: _referrerPolicyToJson, fromJson: _referrerPolicyFromJson)
  final ReferrerPolicy? referrerPolicy;

  final String? integrity;

  final bool? keepalive;

  @JsonKey(
    defaultValue: FetchRequestAction.PROCEED,
    toJson: _actionToJson,
    fromJson: _actionFromJson,
  )
  final FetchRequestAction? action;

  FetchRequest copyWith({
    WebUri? url,
    String? method,
    Map<String, dynamic>? headers,
    dynamic body,
    String? mode,
    FetchRequestCredential? credentials,
    String? cache,
    String? redirect,
    String? referrer,
    ReferrerPolicy? referrerPolicy,
    String? integrity,
    bool? keepalive,
    FetchRequestAction? action,
  }) {
    return FetchRequest(
      url: url ?? this.url,
      method: method ?? this.method,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      mode: mode ?? this.mode,
      credentials: credentials ?? this.credentials,
      cache: cache ?? this.cache,
      redirect: redirect ?? this.redirect,
      referrer: referrer ?? this.referrer,
      referrerPolicy: referrerPolicy ?? this.referrerPolicy,
      integrity: integrity ?? this.integrity,
      keepalive: keepalive ?? this.keepalive,
      action: action ?? this.action,
    );
  }

  FetchRequest copyWithFetchRequest({
    WebUri? url,
    String? method,
    Map<String, dynamic>? headers,
    dynamic body,
    String? mode,
    FetchRequestCredential? credentials,
    String? cache,
    String? redirect,
    String? referrer,
    ReferrerPolicy? referrerPolicy,
    String? integrity,
    bool? keepalive,
    FetchRequestAction? action,
  }) {
    return copyWith(
      url: url,
      method: method,
      headers: headers,
      body: body,
      mode: mode,
      credentials: credentials,
      cache: cache,
      redirect: redirect,
      referrer: referrer,
      referrerPolicy: referrerPolicy,
      integrity: integrity,
      keepalive: keepalive,
      action: action,
    );
  }

  FetchRequest patchWithFetchRequest([FetchRequestPatch? patchInput]) {
    final _patcher = patchInput ?? FetchRequestPatch();
    final _patchMap = _patcher.patchMap;
    return FetchRequest(
      url: _patchMap.containsKey(FetchRequest$.url)
          ? ((_patchMap[FetchRequest$.url] is Function)
                    ? _patchMap[FetchRequest$.url](this.url)
                    : (_patchMap[FetchRequest$.url] is Patch)
                    ? _patchMap[FetchRequest$.url].applyTo(this.url)
                    : _patchMap[FetchRequest$.url])
                as WebUri?
          : this.url,
      method: _patchMap.containsKey(FetchRequest$.method)
          ? ((_patchMap[FetchRequest$.method] is Function)
                    ? _patchMap[FetchRequest$.method](this.method)
                    : (_patchMap[FetchRequest$.method] is Patch)
                    ? _patchMap[FetchRequest$.method].applyTo(this.method)
                    : _patchMap[FetchRequest$.method])
                as String?
          : this.method,
      headers: _patchMap.containsKey(FetchRequest$.headers)
          ? ((_patchMap[FetchRequest$.headers] is Function)
                    ? _patchMap[FetchRequest$.headers](this.headers)
                    : (_patchMap[FetchRequest$.headers] is Patch)
                    ? _patchMap[FetchRequest$.headers].applyTo(this.headers)
                    : _patchMap[FetchRequest$.headers])
                as Map<String, dynamic>?
          : this.headers,
      body: _patchMap.containsKey(FetchRequest$.body)
          ? ((_patchMap[FetchRequest$.body] is Function)
                    ? _patchMap[FetchRequest$.body](this.body)
                    : (_patchMap[FetchRequest$.body] is Patch)
                    ? _patchMap[FetchRequest$.body].applyTo(this.body)
                    : _patchMap[FetchRequest$.body])
                as dynamic
          : this.body,
      mode: _patchMap.containsKey(FetchRequest$.mode)
          ? ((_patchMap[FetchRequest$.mode] is Function)
                    ? _patchMap[FetchRequest$.mode](this.mode)
                    : (_patchMap[FetchRequest$.mode] is Patch)
                    ? _patchMap[FetchRequest$.mode].applyTo(this.mode)
                    : _patchMap[FetchRequest$.mode])
                as String?
          : this.mode,
      credentials: _patchMap.containsKey(FetchRequest$.credentials)
          ? ((_patchMap[FetchRequest$.credentials] is Function)
                    ? _patchMap[FetchRequest$.credentials](this.credentials)
                    : (_patchMap[FetchRequest$.credentials] is Patch)
                    ? _patchMap[FetchRequest$.credentials].applyTo(
                        this.credentials,
                      )
                    : _patchMap[FetchRequest$.credentials])
                as FetchRequestCredential?
          : this.credentials,
      cache: _patchMap.containsKey(FetchRequest$.cache)
          ? ((_patchMap[FetchRequest$.cache] is Function)
                    ? _patchMap[FetchRequest$.cache](this.cache)
                    : (_patchMap[FetchRequest$.cache] is Patch)
                    ? _patchMap[FetchRequest$.cache].applyTo(this.cache)
                    : _patchMap[FetchRequest$.cache])
                as String?
          : this.cache,
      redirect: _patchMap.containsKey(FetchRequest$.redirect)
          ? ((_patchMap[FetchRequest$.redirect] is Function)
                    ? _patchMap[FetchRequest$.redirect](this.redirect)
                    : (_patchMap[FetchRequest$.redirect] is Patch)
                    ? _patchMap[FetchRequest$.redirect].applyTo(this.redirect)
                    : _patchMap[FetchRequest$.redirect])
                as String?
          : this.redirect,
      referrer: _patchMap.containsKey(FetchRequest$.referrer)
          ? ((_patchMap[FetchRequest$.referrer] is Function)
                    ? _patchMap[FetchRequest$.referrer](this.referrer)
                    : (_patchMap[FetchRequest$.referrer] is Patch)
                    ? _patchMap[FetchRequest$.referrer].applyTo(this.referrer)
                    : _patchMap[FetchRequest$.referrer])
                as String?
          : this.referrer,
      referrerPolicy: _patchMap.containsKey(FetchRequest$.referrerPolicy)
          ? ((_patchMap[FetchRequest$.referrerPolicy] is Function)
                    ? _patchMap[FetchRequest$.referrerPolicy](
                        this.referrerPolicy,
                      )
                    : (_patchMap[FetchRequest$.referrerPolicy] is Patch)
                    ? _patchMap[FetchRequest$.referrerPolicy].applyTo(
                        this.referrerPolicy,
                      )
                    : _patchMap[FetchRequest$.referrerPolicy])
                as ReferrerPolicy?
          : this.referrerPolicy,
      integrity: _patchMap.containsKey(FetchRequest$.integrity)
          ? ((_patchMap[FetchRequest$.integrity] is Function)
                    ? _patchMap[FetchRequest$.integrity](this.integrity)
                    : (_patchMap[FetchRequest$.integrity] is Patch)
                    ? _patchMap[FetchRequest$.integrity].applyTo(this.integrity)
                    : _patchMap[FetchRequest$.integrity])
                as String?
          : this.integrity,
      keepalive: _patchMap.containsKey(FetchRequest$.keepalive)
          ? ((_patchMap[FetchRequest$.keepalive] is Function)
                    ? _patchMap[FetchRequest$.keepalive](this.keepalive)
                    : (_patchMap[FetchRequest$.keepalive] is Patch)
                    ? _patchMap[FetchRequest$.keepalive].applyTo(this.keepalive)
                    : _patchMap[FetchRequest$.keepalive])
                as bool?
          : this.keepalive,
      action: _patchMap.containsKey(FetchRequest$.action)
          ? ((_patchMap[FetchRequest$.action] is Function)
                    ? _patchMap[FetchRequest$.action](this.action)
                    : (_patchMap[FetchRequest$.action] is Patch)
                    ? _patchMap[FetchRequest$.action].applyTo(this.action)
                    : _patchMap[FetchRequest$.action])
                as FetchRequestAction?
          : this.action,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FetchRequest &&
        url == other.url &&
        method == other.method &&
        headers == other.headers &&
        body == other.body &&
        mode == other.mode &&
        credentials == other.credentials &&
        cache == other.cache &&
        redirect == other.redirect &&
        referrer == other.referrer &&
        referrerPolicy == other.referrerPolicy &&
        integrity == other.integrity &&
        keepalive == other.keepalive &&
        action == other.action;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.url,
      this.method,
      this.headers,
      this.body,
      this.mode,
      this.credentials,
      this.cache,
      this.redirect,
      this.referrer,
      this.referrerPolicy,
      this.integrity,
      this.keepalive,
      this.action,
    );
  }

  @override
  String toString() {
    return 'FetchRequest(' +
        'url: ${url}' +
        ', ' +
        'method: ${method}' +
        ', ' +
        'headers: ${headers}' +
        ', ' +
        'body: ${body}' +
        ', ' +
        'mode: ${mode}' +
        ', ' +
        'credentials: ${credentials}' +
        ', ' +
        'cache: ${cache}' +
        ', ' +
        'redirect: ${redirect}' +
        ', ' +
        'referrer: ${referrer}' +
        ', ' +
        'referrerPolicy: ${referrerPolicy}' +
        ', ' +
        'integrity: ${integrity}' +
        ', ' +
        'keepalive: ${keepalive}' +
        ', ' +
        'action: ${action})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$FetchRequestToJson(this);
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

extension FetchRequestPropertyHelpers on FetchRequest {
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

  Map<String, dynamic> get headersRequired {
    return this.headers ??
        (throw StateError('headers is required but was null'));
  }

  bool get hasHeaders {
    return this.headers?.isNotEmpty ?? false;
  }

  bool get noHeaders {
    return this.headers?.isEmpty ?? true;
  }

  bool get hasMode {
    return this.mode?.isNotEmpty == true;
  }

  bool get noMode {
    return this.mode?.isEmpty ?? true;
  }

  String get modeRequired {
    return this.mode ?? (throw StateError('mode is required but was null'));
  }

  bool get hasCredentials {
    return this.credentials != null;
  }

  bool get noCredentials {
    return this.credentials == null;
  }

  FetchRequestCredential get credentialsRequired {
    return this.credentials ??
        (throw StateError('credentials is required but was null'));
  }

  bool get hasCache {
    return this.cache?.isNotEmpty == true;
  }

  bool get noCache {
    return this.cache?.isEmpty ?? true;
  }

  String get cacheRequired {
    return this.cache ?? (throw StateError('cache is required but was null'));
  }

  bool get hasRedirect {
    return this.redirect?.isNotEmpty == true;
  }

  bool get noRedirect {
    return this.redirect?.isEmpty ?? true;
  }

  String get redirectRequired {
    return this.redirect ??
        (throw StateError('redirect is required but was null'));
  }

  bool get hasReferrer {
    return this.referrer?.isNotEmpty == true;
  }

  bool get noReferrer {
    return this.referrer?.isEmpty ?? true;
  }

  String get referrerRequired {
    return this.referrer ??
        (throw StateError('referrer is required but was null'));
  }

  bool get hasReferrerPolicy {
    return this.referrerPolicy != null;
  }

  bool get noReferrerPolicy {
    return this.referrerPolicy == null;
  }

  ReferrerPolicy get referrerPolicyRequired {
    return this.referrerPolicy ??
        (throw StateError('referrerPolicy is required but was null'));
  }

  bool get isReferrerPolicyNO_REFERRER {
    return this.referrerPolicy == ReferrerPolicy.NO_REFERRER;
  }

  bool get isReferrerPolicyNO_REFERRER_WHEN_DOWNGRADE {
    return this.referrerPolicy == ReferrerPolicy.NO_REFERRER_WHEN_DOWNGRADE;
  }

  bool get isReferrerPolicyORIGIN {
    return this.referrerPolicy == ReferrerPolicy.ORIGIN;
  }

  bool get isReferrerPolicyORIGIN_WHEN_CROSS_ORIGIN {
    return this.referrerPolicy == ReferrerPolicy.ORIGIN_WHEN_CROSS_ORIGIN;
  }

  bool get isReferrerPolicySAME_ORIGIN {
    return this.referrerPolicy == ReferrerPolicy.SAME_ORIGIN;
  }

  bool get isReferrerPolicySTRICT_ORIGIN {
    return this.referrerPolicy == ReferrerPolicy.STRICT_ORIGIN;
  }

  bool get isReferrerPolicySTRICT_ORIGIN_WHEN_CROSS_ORIGIN {
    return this.referrerPolicy ==
        ReferrerPolicy.STRICT_ORIGIN_WHEN_CROSS_ORIGIN;
  }

  bool get isReferrerPolicyUNSAFE_URL {
    return this.referrerPolicy == ReferrerPolicy.UNSAFE_URL;
  }

  bool get hasIntegrity {
    return this.integrity?.isNotEmpty == true;
  }

  bool get noIntegrity {
    return this.integrity?.isEmpty ?? true;
  }

  String get integrityRequired {
    return this.integrity ??
        (throw StateError('integrity is required but was null'));
  }

  bool get hasKeepalive {
    return this.keepalive != null;
  }

  bool get noKeepalive {
    return this.keepalive == null;
  }

  bool get keepaliveRequired {
    return this.keepalive ??
        (throw StateError('keepalive is required but was null'));
  }

  bool get hasAction {
    return this.action != null;
  }

  bool get noAction {
    return this.action == null;
  }

  FetchRequestAction get actionRequired {
    return this.action ?? (throw StateError('action is required but was null'));
  }

  bool get isActionABORT {
    return this.action == FetchRequestAction.ABORT;
  }

  bool get isActionPROCEED {
    return this.action == FetchRequestAction.PROCEED;
  }
}

extension FetchRequestSerialization on FetchRequest {
  Map<String, dynamic> toJson() {
    return _$FetchRequestToJson(this);
  }
}

enum FetchRequest$ {
  url,
  method,
  headers,
  body,
  mode,
  credentials,
  cache,
  redirect,
  referrer,
  referrerPolicy,
  integrity,
  keepalive,
  action,
}

class FetchRequestPatch extends PatchBase<FetchRequest, FetchRequest$> {
  FetchRequest applyTo(FetchRequest entity) {
    return entity.patchWithFetchRequest(this);
  }

  FetchRequestPatch withUrl(WebUri? value) {
    patchMap[FetchRequest$.url] = value;
    return this;
  }

  FetchRequestPatch withMethod(String? value) {
    patchMap[FetchRequest$.method] = value;
    return this;
  }

  FetchRequestPatch withHeaders(Map<String, dynamic>? value) {
    patchMap[FetchRequest$.headers] = value;
    return this;
  }

  FetchRequestPatch withBody(dynamic value) {
    patchMap[FetchRequest$.body] = value;
    return this;
  }

  FetchRequestPatch withMode(String? value) {
    patchMap[FetchRequest$.mode] = value;
    return this;
  }

  FetchRequestPatch withCredentials(FetchRequestCredential? value) {
    patchMap[FetchRequest$.credentials] = value;
    return this;
  }

  FetchRequestPatch withCache(String? value) {
    patchMap[FetchRequest$.cache] = value;
    return this;
  }

  FetchRequestPatch withRedirect(String? value) {
    patchMap[FetchRequest$.redirect] = value;
    return this;
  }

  FetchRequestPatch withReferrer(String? value) {
    patchMap[FetchRequest$.referrer] = value;
    return this;
  }

  FetchRequestPatch withReferrerPolicy(ReferrerPolicy? value) {
    patchMap[FetchRequest$.referrerPolicy] = value;
    return this;
  }

  FetchRequestPatch withIntegrity(String? value) {
    patchMap[FetchRequest$.integrity] = value;
    return this;
  }

  FetchRequestPatch withKeepalive(bool? value) {
    patchMap[FetchRequest$.keepalive] = value;
    return this;
  }

  FetchRequestPatch withAction(FetchRequestAction? value) {
    patchMap[FetchRequest$.action] = value;
    return this;
  }
}

/// Field descriptors for [FetchRequest] query construction
abstract final class FetchRequestFields {
  static const url = Field<FetchRequest, WebUri?>('url', _$url);

  static const method = Field<FetchRequest, String?>('method', _$method);

  static const headers = Field<FetchRequest, Map<String, dynamic>?>(
    'headers',
    _$headers,
  );

  static const body = Field<FetchRequest, dynamic>('body', _$body);

  static const mode = Field<FetchRequest, String?>('mode', _$mode);

  static const credentials = Field<FetchRequest, FetchRequestCredential?>(
    'credentials',
    _$credentials,
  );

  static const cache = Field<FetchRequest, String?>('cache', _$cache);

  static const redirect = Field<FetchRequest, String?>('redirect', _$redirect);

  static const referrer = Field<FetchRequest, String?>('referrer', _$referrer);

  static const referrerPolicy = Field<FetchRequest, ReferrerPolicy?>(
    'referrerPolicy',
    _$referrerPolicy,
  );

  static const integrity = Field<FetchRequest, String?>(
    'integrity',
    _$integrity,
  );

  static const keepalive = Field<FetchRequest, bool?>('keepalive', _$keepalive);

  static const action = Field<FetchRequest, FetchRequestAction?>(
    'action',
    _$action,
  );

  static WebUri? _$url(FetchRequest e) {
    return e.url;
  }

  static String? _$method(FetchRequest e) {
    return e.method;
  }

  static Map<String, dynamic>? _$headers(FetchRequest e) {
    return e.headers;
  }

  static dynamic _$body(FetchRequest e) {
    return e.body;
  }

  static String? _$mode(FetchRequest e) {
    return e.mode;
  }

  static FetchRequestCredential? _$credentials(FetchRequest e) {
    return e.credentials;
  }

  static String? _$cache(FetchRequest e) {
    return e.cache;
  }

  static String? _$redirect(FetchRequest e) {
    return e.redirect;
  }

  static String? _$referrer(FetchRequest e) {
    return e.referrer;
  }

  static ReferrerPolicy? _$referrerPolicy(FetchRequest e) {
    return e.referrerPolicy;
  }

  static String? _$integrity(FetchRequest e) {
    return e.integrity;
  }

  static bool? _$keepalive(FetchRequest e) {
    return e.keepalive;
  }

  static FetchRequestAction? _$action(FetchRequest e) {
    return e.action;
  }
}

extension FetchRequestCompareE on FetchRequest {
  Map<String, dynamic> compareToFetchRequest(FetchRequest other) {
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

    if (mode != other.mode) {
      diff['mode'] = () => other.mode;
    }

    if (credentials != other.credentials) {
      diff['credentials'] = () => other.credentials;
    }

    if (cache != other.cache) {
      diff['cache'] = () => other.cache;
    }

    if (redirect != other.redirect) {
      diff['redirect'] = () => other.redirect;
    }

    if (referrer != other.referrer) {
      diff['referrer'] = () => other.referrer;
    }

    if (referrerPolicy != other.referrerPolicy) {
      diff['referrerPolicy'] = () => other.referrerPolicy;
    }

    if (integrity != other.integrity) {
      diff['integrity'] = () => other.integrity;
    }

    if (keepalive != other.keepalive) {
      diff['keepalive'] = () => other.keepalive;
    }

    if (action != other.action) {
      diff['action'] = () => other.action;
    }
    return diff;
  }
}
