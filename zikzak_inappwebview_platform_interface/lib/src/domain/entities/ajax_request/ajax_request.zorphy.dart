// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'ajax_request.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class AjaxRequest {
  AjaxRequest({
    dynamic this.data,
    String? this.method,
    WebUri? this.url,
    bool? this.isAsync,
    String? this.user,
    String? this.password,
    bool? this.withCredentials,
    AjaxRequestHeaders? this.headers,
    AjaxRequestReadyState? this.readyState,
    int? this.status,
    WebUri? this.responseURL,
    String? this.responseType,
    dynamic this.response,
    String? this.responseText,
    String? this.responseXML,
    String? this.statusText,
    Map<String, dynamic>? this.responseHeaders,
    AjaxRequestEvent? this.event,
    AjaxRequestAction? action,
  }) : this.action = action ?? AjaxRequestAction.PROCEED;

  factory AjaxRequest.fromJson(Map<String, dynamic> json) =>
      _$AjaxRequestFromJson(json);

  final dynamic data;

  final String? method;

  @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson)
  final WebUri? url;

  final bool? isAsync;

  final String? user;

  final String? password;

  final bool? withCredentials;

  @JsonKey(toJson: _headersToJson, fromJson: _headersFromJson)
  final AjaxRequestHeaders? headers;

  @JsonKey(toJson: _readyStateToJson, fromJson: _readyStateFromJson)
  final AjaxRequestReadyState? readyState;

  final int? status;

  @JsonKey(toJson: _responseURLToJson, fromJson: _responseURLFromJson)
  final WebUri? responseURL;

  final String? responseType;

  final dynamic response;

  final String? responseText;

  final String? responseXML;

  final String? statusText;

  @JsonKey(toJson: _responseHeadersToJson, fromJson: _responseHeadersFromJson)
  final Map<String, dynamic>? responseHeaders;

  @JsonKey(toJson: _eventToJson, fromJson: _eventFromJson)
  final AjaxRequestEvent? event;

  @JsonKey(
    defaultValue: AjaxRequestAction.PROCEED,
    toJson: _actionToJson,
    fromJson: _actionFromJson,
  )
  final AjaxRequestAction? action;

  AjaxRequest copyWith({
    dynamic data,
    String? method,
    WebUri? url,
    bool? isAsync,
    String? user,
    String? password,
    bool? withCredentials,
    AjaxRequestHeaders? headers,
    AjaxRequestReadyState? readyState,
    int? status,
    WebUri? responseURL,
    String? responseType,
    dynamic response,
    String? responseText,
    String? responseXML,
    String? statusText,
    Map<String, dynamic>? responseHeaders,
    AjaxRequestEvent? event,
    AjaxRequestAction? action,
  }) {
    return AjaxRequest(
      data: data ?? this.data,
      method: method ?? this.method,
      url: url ?? this.url,
      isAsync: isAsync ?? this.isAsync,
      user: user ?? this.user,
      password: password ?? this.password,
      withCredentials: withCredentials ?? this.withCredentials,
      headers: headers ?? this.headers,
      readyState: readyState ?? this.readyState,
      status: status ?? this.status,
      responseURL: responseURL ?? this.responseURL,
      responseType: responseType ?? this.responseType,
      response: response ?? this.response,
      responseText: responseText ?? this.responseText,
      responseXML: responseXML ?? this.responseXML,
      statusText: statusText ?? this.statusText,
      responseHeaders: responseHeaders ?? this.responseHeaders,
      event: event ?? this.event,
      action: action ?? this.action,
    );
  }

  AjaxRequest copyWithAjaxRequest({
    dynamic data,
    String? method,
    WebUri? url,
    bool? isAsync,
    String? user,
    String? password,
    bool? withCredentials,
    AjaxRequestHeaders? headers,
    AjaxRequestReadyState? readyState,
    int? status,
    WebUri? responseURL,
    String? responseType,
    dynamic response,
    String? responseText,
    String? responseXML,
    String? statusText,
    Map<String, dynamic>? responseHeaders,
    AjaxRequestEvent? event,
    AjaxRequestAction? action,
  }) {
    return copyWith(
      data: data,
      method: method,
      url: url,
      isAsync: isAsync,
      user: user,
      password: password,
      withCredentials: withCredentials,
      headers: headers,
      readyState: readyState,
      status: status,
      responseURL: responseURL,
      responseType: responseType,
      response: response,
      responseText: responseText,
      responseXML: responseXML,
      statusText: statusText,
      responseHeaders: responseHeaders,
      event: event,
      action: action,
    );
  }

  AjaxRequest patchWithAjaxRequest([AjaxRequestPatch? patchInput]) {
    final _patcher = patchInput ?? AjaxRequestPatch();
    final _patchMap = _patcher.patchMap;
    return AjaxRequest(
      data: _patchMap.containsKey(AjaxRequest$.data)
          ? (_patchMap[AjaxRequest$.data] is Function)
                ? _patchMap[AjaxRequest$.data](this.data)
                : (_patchMap[AjaxRequest$.data] is Patch)
                ? _patchMap[AjaxRequest$.data].applyTo(this.data)
                : _patchMap[AjaxRequest$.data]
          : this.data,
      method: _patchMap.containsKey(AjaxRequest$.method)
          ? (_patchMap[AjaxRequest$.method] is Function)
                ? _patchMap[AjaxRequest$.method](this.method)
                : (_patchMap[AjaxRequest$.method] is Patch)
                ? _patchMap[AjaxRequest$.method].applyTo(this.method)
                : _patchMap[AjaxRequest$.method]
          : this.method,
      url: _patchMap.containsKey(AjaxRequest$.url)
          ? (_patchMap[AjaxRequest$.url] is Function)
                ? _patchMap[AjaxRequest$.url](this.url)
                : (_patchMap[AjaxRequest$.url] is Patch)
                ? _patchMap[AjaxRequest$.url].applyTo(this.url)
                : _patchMap[AjaxRequest$.url]
          : this.url,
      isAsync: _patchMap.containsKey(AjaxRequest$.isAsync)
          ? (_patchMap[AjaxRequest$.isAsync] is Function)
                ? _patchMap[AjaxRequest$.isAsync](this.isAsync)
                : (_patchMap[AjaxRequest$.isAsync] is Patch)
                ? _patchMap[AjaxRequest$.isAsync].applyTo(this.isAsync)
                : _patchMap[AjaxRequest$.isAsync]
          : this.isAsync,
      user: _patchMap.containsKey(AjaxRequest$.user)
          ? (_patchMap[AjaxRequest$.user] is Function)
                ? _patchMap[AjaxRequest$.user](this.user)
                : (_patchMap[AjaxRequest$.user] is Patch)
                ? _patchMap[AjaxRequest$.user].applyTo(this.user)
                : _patchMap[AjaxRequest$.user]
          : this.user,
      password: _patchMap.containsKey(AjaxRequest$.password)
          ? (_patchMap[AjaxRequest$.password] is Function)
                ? _patchMap[AjaxRequest$.password](this.password)
                : (_patchMap[AjaxRequest$.password] is Patch)
                ? _patchMap[AjaxRequest$.password].applyTo(this.password)
                : _patchMap[AjaxRequest$.password]
          : this.password,
      withCredentials: _patchMap.containsKey(AjaxRequest$.withCredentials)
          ? (_patchMap[AjaxRequest$.withCredentials] is Function)
                ? _patchMap[AjaxRequest$.withCredentials](this.withCredentials)
                : (_patchMap[AjaxRequest$.withCredentials] is Patch)
                ? _patchMap[AjaxRequest$.withCredentials].applyTo(
                    this.withCredentials,
                  )
                : _patchMap[AjaxRequest$.withCredentials]
          : this.withCredentials,
      headers: _patchMap.containsKey(AjaxRequest$.headers)
          ? (_patchMap[AjaxRequest$.headers] is Function)
                ? _patchMap[AjaxRequest$.headers](this.headers)
                : (_patchMap[AjaxRequest$.headers] is Patch)
                ? _patchMap[AjaxRequest$.headers].applyTo(this.headers)
                : _patchMap[AjaxRequest$.headers]
          : this.headers,
      readyState: _patchMap.containsKey(AjaxRequest$.readyState)
          ? (_patchMap[AjaxRequest$.readyState] is Function)
                ? _patchMap[AjaxRequest$.readyState](this.readyState)
                : (_patchMap[AjaxRequest$.readyState] is Patch)
                ? _patchMap[AjaxRequest$.readyState].applyTo(this.readyState)
                : _patchMap[AjaxRequest$.readyState]
          : this.readyState,
      status: _patchMap.containsKey(AjaxRequest$.status)
          ? (_patchMap[AjaxRequest$.status] is Function)
                ? _patchMap[AjaxRequest$.status](this.status)
                : (_patchMap[AjaxRequest$.status] is Patch)
                ? _patchMap[AjaxRequest$.status].applyTo(this.status)
                : _patchMap[AjaxRequest$.status]
          : this.status,
      responseURL: _patchMap.containsKey(AjaxRequest$.responseURL)
          ? (_patchMap[AjaxRequest$.responseURL] is Function)
                ? _patchMap[AjaxRequest$.responseURL](this.responseURL)
                : (_patchMap[AjaxRequest$.responseURL] is Patch)
                ? _patchMap[AjaxRequest$.responseURL].applyTo(this.responseURL)
                : _patchMap[AjaxRequest$.responseURL]
          : this.responseURL,
      responseType: _patchMap.containsKey(AjaxRequest$.responseType)
          ? (_patchMap[AjaxRequest$.responseType] is Function)
                ? _patchMap[AjaxRequest$.responseType](this.responseType)
                : (_patchMap[AjaxRequest$.responseType] is Patch)
                ? _patchMap[AjaxRequest$.responseType].applyTo(
                    this.responseType,
                  )
                : _patchMap[AjaxRequest$.responseType]
          : this.responseType,
      response: _patchMap.containsKey(AjaxRequest$.response)
          ? (_patchMap[AjaxRequest$.response] is Function)
                ? _patchMap[AjaxRequest$.response](this.response)
                : (_patchMap[AjaxRequest$.response] is Patch)
                ? _patchMap[AjaxRequest$.response].applyTo(this.response)
                : _patchMap[AjaxRequest$.response]
          : this.response,
      responseText: _patchMap.containsKey(AjaxRequest$.responseText)
          ? (_patchMap[AjaxRequest$.responseText] is Function)
                ? _patchMap[AjaxRequest$.responseText](this.responseText)
                : (_patchMap[AjaxRequest$.responseText] is Patch)
                ? _patchMap[AjaxRequest$.responseText].applyTo(
                    this.responseText,
                  )
                : _patchMap[AjaxRequest$.responseText]
          : this.responseText,
      responseXML: _patchMap.containsKey(AjaxRequest$.responseXML)
          ? (_patchMap[AjaxRequest$.responseXML] is Function)
                ? _patchMap[AjaxRequest$.responseXML](this.responseXML)
                : (_patchMap[AjaxRequest$.responseXML] is Patch)
                ? _patchMap[AjaxRequest$.responseXML].applyTo(this.responseXML)
                : _patchMap[AjaxRequest$.responseXML]
          : this.responseXML,
      statusText: _patchMap.containsKey(AjaxRequest$.statusText)
          ? (_patchMap[AjaxRequest$.statusText] is Function)
                ? _patchMap[AjaxRequest$.statusText](this.statusText)
                : (_patchMap[AjaxRequest$.statusText] is Patch)
                ? _patchMap[AjaxRequest$.statusText].applyTo(this.statusText)
                : _patchMap[AjaxRequest$.statusText]
          : this.statusText,
      responseHeaders: _patchMap.containsKey(AjaxRequest$.responseHeaders)
          ? (_patchMap[AjaxRequest$.responseHeaders] is Function)
                ? _patchMap[AjaxRequest$.responseHeaders](this.responseHeaders)
                : (_patchMap[AjaxRequest$.responseHeaders] is Patch)
                ? _patchMap[AjaxRequest$.responseHeaders].applyTo(
                    this.responseHeaders,
                  )
                : _patchMap[AjaxRequest$.responseHeaders]
          : this.responseHeaders,
      event: _patchMap.containsKey(AjaxRequest$.event)
          ? (_patchMap[AjaxRequest$.event] is Function)
                ? _patchMap[AjaxRequest$.event](this.event)
                : (_patchMap[AjaxRequest$.event] is Patch)
                ? _patchMap[AjaxRequest$.event].applyTo(this.event)
                : _patchMap[AjaxRequest$.event]
          : this.event,
      action: _patchMap.containsKey(AjaxRequest$.action)
          ? (_patchMap[AjaxRequest$.action] is Function)
                ? _patchMap[AjaxRequest$.action](this.action)
                : (_patchMap[AjaxRequest$.action] is Patch)
                ? _patchMap[AjaxRequest$.action].applyTo(this.action)
                : _patchMap[AjaxRequest$.action]
          : this.action,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AjaxRequest &&
        data == other.data &&
        method == other.method &&
        url == other.url &&
        isAsync == other.isAsync &&
        user == other.user &&
        password == other.password &&
        withCredentials == other.withCredentials &&
        headers == other.headers &&
        readyState == other.readyState &&
        status == other.status &&
        responseURL == other.responseURL &&
        responseType == other.responseType &&
        response == other.response &&
        responseText == other.responseText &&
        responseXML == other.responseXML &&
        statusText == other.statusText &&
        responseHeaders == other.responseHeaders &&
        event == other.event &&
        action == other.action;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.data,
      this.method,
      this.url,
      this.isAsync,
      this.user,
      this.password,
      this.withCredentials,
      this.headers,
      this.readyState,
      this.status,
      this.responseURL,
      this.responseType,
      this.response,
      this.responseText,
      this.responseXML,
      this.statusText,
      this.responseHeaders,
      this.event,
      this.action,
    );
  }

  @override
  String toString() {
    return 'AjaxRequest(' +
        'data: ${data}' +
        ', ' +
        'method: ${method}' +
        ', ' +
        'url: ${url}' +
        ', ' +
        'isAsync: ${isAsync}' +
        ', ' +
        'user: ${user}' +
        ', ' +
        'password: ${password}' +
        ', ' +
        'withCredentials: ${withCredentials}' +
        ', ' +
        'headers: ${headers}' +
        ', ' +
        'readyState: ${readyState}' +
        ', ' +
        'status: ${status}' +
        ', ' +
        'responseURL: ${responseURL}' +
        ', ' +
        'responseType: ${responseType}' +
        ', ' +
        'response: ${response}' +
        ', ' +
        'responseText: ${responseText}' +
        ', ' +
        'responseXML: ${responseXML}' +
        ', ' +
        'statusText: ${statusText}' +
        ', ' +
        'responseHeaders: ${responseHeaders}' +
        ', ' +
        'event: ${event}' +
        ', ' +
        'action: ${action})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$AjaxRequestToJson(this);
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

extension AjaxRequestPropertyHelpers on AjaxRequest {
  bool get hasMethod {
    return this.method?.isNotEmpty == true;
  }

  bool get noMethod {
    return this.method?.isEmpty ?? true;
  }

  String get methodRequired {
    return this.method ?? (throw StateError('method is required but was null'));
  }

  bool get hasUrl {
    return this.url != null;
  }

  bool get noUrl {
    return this.url == null;
  }

  WebUri get urlRequired {
    return this.url ?? (throw StateError('url is required but was null'));
  }

  bool get hasIsAsync {
    return this.isAsync != null;
  }

  bool get noIsAsync {
    return this.isAsync == null;
  }

  bool get isAsyncRequired {
    return this.isAsync ??
        (throw StateError('isAsync is required but was null'));
  }

  bool get hasUser {
    return this.user?.isNotEmpty == true;
  }

  bool get noUser {
    return this.user?.isEmpty ?? true;
  }

  String get userRequired {
    return this.user ?? (throw StateError('user is required but was null'));
  }

  bool get hasPassword {
    return this.password?.isNotEmpty == true;
  }

  bool get noPassword {
    return this.password?.isEmpty ?? true;
  }

  String get passwordRequired {
    return this.password ??
        (throw StateError('password is required but was null'));
  }

  bool get hasWithCredentials {
    return this.withCredentials != null;
  }

  bool get noWithCredentials {
    return this.withCredentials == null;
  }

  bool get withCredentialsRequired {
    return this.withCredentials ??
        (throw StateError('withCredentials is required but was null'));
  }

  bool get hasHeaders {
    return this.headers != null;
  }

  bool get noHeaders {
    return this.headers == null;
  }

  AjaxRequestHeaders get headersRequired {
    return this.headers ??
        (throw StateError('headers is required but was null'));
  }

  bool get hasReadyState {
    return this.readyState != null;
  }

  bool get noReadyState {
    return this.readyState == null;
  }

  AjaxRequestReadyState get readyStateRequired {
    return this.readyState ??
        (throw StateError('readyState is required but was null'));
  }

  bool get isReadyStateUNSENT {
    return this.readyState == AjaxRequestReadyState.UNSENT;
  }

  bool get isReadyStateOPENED {
    return this.readyState == AjaxRequestReadyState.OPENED;
  }

  bool get isReadyStateHEADERS_RECEIVED {
    return this.readyState == AjaxRequestReadyState.HEADERS_RECEIVED;
  }

  bool get isReadyStateLOADING {
    return this.readyState == AjaxRequestReadyState.LOADING;
  }

  bool get isReadyStateDONE {
    return this.readyState == AjaxRequestReadyState.DONE;
  }

  bool get hasStatus {
    return this.status != null;
  }

  bool get noStatus {
    return this.status == null;
  }

  int get statusRequired {
    return this.status ?? (throw StateError('status is required but was null'));
  }

  bool get hasResponseURL {
    return this.responseURL != null;
  }

  bool get noResponseURL {
    return this.responseURL == null;
  }

  WebUri get responseURLRequired {
    return this.responseURL ??
        (throw StateError('responseURL is required but was null'));
  }

  bool get hasResponseType {
    return this.responseType?.isNotEmpty == true;
  }

  bool get noResponseType {
    return this.responseType?.isEmpty ?? true;
  }

  String get responseTypeRequired {
    return this.responseType ??
        (throw StateError('responseType is required but was null'));
  }

  bool get hasResponseText {
    return this.responseText?.isNotEmpty == true;
  }

  bool get noResponseText {
    return this.responseText?.isEmpty ?? true;
  }

  String get responseTextRequired {
    return this.responseText ??
        (throw StateError('responseText is required but was null'));
  }

  bool get hasResponseXML {
    return this.responseXML?.isNotEmpty == true;
  }

  bool get noResponseXML {
    return this.responseXML?.isEmpty ?? true;
  }

  String get responseXMLRequired {
    return this.responseXML ??
        (throw StateError('responseXML is required but was null'));
  }

  bool get hasStatusText {
    return this.statusText?.isNotEmpty == true;
  }

  bool get noStatusText {
    return this.statusText?.isEmpty ?? true;
  }

  String get statusTextRequired {
    return this.statusText ??
        (throw StateError('statusText is required but was null'));
  }

  Map<String, dynamic> get responseHeadersRequired {
    return this.responseHeaders ??
        (throw StateError('responseHeaders is required but was null'));
  }

  bool get hasResponseHeaders {
    return this.responseHeaders?.isNotEmpty ?? false;
  }

  bool get noResponseHeaders {
    return this.responseHeaders?.isEmpty ?? true;
  }

  bool get hasAction {
    return this.action != null;
  }

  bool get noAction {
    return this.action == null;
  }

  AjaxRequestAction get actionRequired {
    return this.action ?? (throw StateError('action is required but was null'));
  }

  bool get isActionABORT {
    return this.action == AjaxRequestAction.ABORT;
  }

  bool get isActionPROCEED {
    return this.action == AjaxRequestAction.PROCEED;
  }
}

extension AjaxRequestSerialization on AjaxRequest {
  Map<String, dynamic> toJson() {
    return _$AjaxRequestToJson(this);
  }
}

enum AjaxRequest$ {
  data,
  method,
  url,
  isAsync,
  user,
  password,
  withCredentials,
  headers,
  readyState,
  status,
  responseURL,
  responseType,
  response,
  responseText,
  responseXML,
  statusText,
  responseHeaders,
  event,
  action,
}

class AjaxRequestPatch extends PatchBase<AjaxRequest, AjaxRequest$> {
  AjaxRequest applyTo(AjaxRequest entity) {
    return entity.patchWithAjaxRequest(this);
  }

  AjaxRequestPatch withData(dynamic? value) {
    patchMap[AjaxRequest$.data] = value;
    return this;
  }

  AjaxRequestPatch withMethod(String? value) {
    patchMap[AjaxRequest$.method] = value;
    return this;
  }

  AjaxRequestPatch withUrl(WebUri? value) {
    patchMap[AjaxRequest$.url] = value;
    return this;
  }

  AjaxRequestPatch withIsAsync(bool? value) {
    patchMap[AjaxRequest$.isAsync] = value;
    return this;
  }

  AjaxRequestPatch withUser(String? value) {
    patchMap[AjaxRequest$.user] = value;
    return this;
  }

  AjaxRequestPatch withPassword(String? value) {
    patchMap[AjaxRequest$.password] = value;
    return this;
  }

  AjaxRequestPatch withWithCredentials(bool? value) {
    patchMap[AjaxRequest$.withCredentials] = value;
    return this;
  }

  AjaxRequestPatch withHeaders(AjaxRequestHeaders? value) {
    patchMap[AjaxRequest$.headers] = value;
    return this;
  }

  AjaxRequestPatch withReadyState(AjaxRequestReadyState? value) {
    patchMap[AjaxRequest$.readyState] = value;
    return this;
  }

  AjaxRequestPatch withStatus(int? value) {
    patchMap[AjaxRequest$.status] = value;
    return this;
  }

  AjaxRequestPatch withResponseURL(WebUri? value) {
    patchMap[AjaxRequest$.responseURL] = value;
    return this;
  }

  AjaxRequestPatch withResponseType(String? value) {
    patchMap[AjaxRequest$.responseType] = value;
    return this;
  }

  AjaxRequestPatch withResponse(dynamic? value) {
    patchMap[AjaxRequest$.response] = value;
    return this;
  }

  AjaxRequestPatch withResponseText(String? value) {
    patchMap[AjaxRequest$.responseText] = value;
    return this;
  }

  AjaxRequestPatch withResponseXML(String? value) {
    patchMap[AjaxRequest$.responseXML] = value;
    return this;
  }

  AjaxRequestPatch withStatusText(String? value) {
    patchMap[AjaxRequest$.statusText] = value;
    return this;
  }

  AjaxRequestPatch withResponseHeaders(Map<String, dynamic>? value) {
    patchMap[AjaxRequest$.responseHeaders] = value;
    return this;
  }

  AjaxRequestPatch withEvent(AjaxRequestEvent? value) {
    patchMap[AjaxRequest$.event] = value;
    return this;
  }

  AjaxRequestPatch withAction(AjaxRequestAction? value) {
    patchMap[AjaxRequest$.action] = value;
    return this;
  }
}

/// Field descriptors for [AjaxRequest] query construction
abstract final class AjaxRequestFields {
  static const data = Field<AjaxRequest, dynamic>('data', _$data);

  static const method = Field<AjaxRequest, String?>('method', _$method);

  static const url = Field<AjaxRequest, WebUri?>('url', _$url);

  static const isAsync = Field<AjaxRequest, bool?>('isAsync', _$isAsync);

  static const user = Field<AjaxRequest, String?>('user', _$user);

  static const password = Field<AjaxRequest, String?>('password', _$password);

  static const withCredentials = Field<AjaxRequest, bool?>(
    'withCredentials',
    _$withCredentials,
  );

  static const headers = Field<AjaxRequest, AjaxRequestHeaders?>(
    'headers',
    _$headers,
  );

  static const readyState = Field<AjaxRequest, AjaxRequestReadyState?>(
    'readyState',
    _$readyState,
  );

  static const status = Field<AjaxRequest, int?>('status', _$status);

  static const responseURL = Field<AjaxRequest, WebUri?>(
    'responseURL',
    _$responseURL,
  );

  static const responseType = Field<AjaxRequest, String?>(
    'responseType',
    _$responseType,
  );

  static const response = Field<AjaxRequest, dynamic>('response', _$response);

  static const responseText = Field<AjaxRequest, String?>(
    'responseText',
    _$responseText,
  );

  static const responseXML = Field<AjaxRequest, String?>(
    'responseXML',
    _$responseXML,
  );

  static const statusText = Field<AjaxRequest, String?>(
    'statusText',
    _$statusText,
  );

  static const responseHeaders = Field<AjaxRequest, Map<String, dynamic>?>(
    'responseHeaders',
    _$responseHeaders,
  );

  static const event = Field<AjaxRequest, AjaxRequestEvent?>('event', _$event);

  static const action = Field<AjaxRequest, AjaxRequestAction?>(
    'action',
    _$action,
  );

  static dynamic _$data(AjaxRequest e) {
    return e.data;
  }

  static String? _$method(AjaxRequest e) {
    return e.method;
  }

  static WebUri? _$url(AjaxRequest e) {
    return e.url;
  }

  static bool? _$isAsync(AjaxRequest e) {
    return e.isAsync;
  }

  static String? _$user(AjaxRequest e) {
    return e.user;
  }

  static String? _$password(AjaxRequest e) {
    return e.password;
  }

  static bool? _$withCredentials(AjaxRequest e) {
    return e.withCredentials;
  }

  static AjaxRequestHeaders? _$headers(AjaxRequest e) {
    return e.headers;
  }

  static AjaxRequestReadyState? _$readyState(AjaxRequest e) {
    return e.readyState;
  }

  static int? _$status(AjaxRequest e) {
    return e.status;
  }

  static WebUri? _$responseURL(AjaxRequest e) {
    return e.responseURL;
  }

  static String? _$responseType(AjaxRequest e) {
    return e.responseType;
  }

  static dynamic _$response(AjaxRequest e) {
    return e.response;
  }

  static String? _$responseText(AjaxRequest e) {
    return e.responseText;
  }

  static String? _$responseXML(AjaxRequest e) {
    return e.responseXML;
  }

  static String? _$statusText(AjaxRequest e) {
    return e.statusText;
  }

  static Map<String, dynamic>? _$responseHeaders(AjaxRequest e) {
    return e.responseHeaders;
  }

  static AjaxRequestEvent? _$event(AjaxRequest e) {
    return e.event;
  }

  static AjaxRequestAction? _$action(AjaxRequest e) {
    return e.action;
  }
}

extension AjaxRequestCompareE on AjaxRequest {
  Map<String, dynamic> compareToAjaxRequest(AjaxRequest other) {
    final Map<String, dynamic> diff = {};

    if (data != other.data) {
      diff['data'] = () => other.data;
    }

    if (method != other.method) {
      diff['method'] = () => other.method;
    }

    if (url != other.url) {
      diff['url'] = () => other.url;
    }

    if (isAsync != other.isAsync) {
      diff['isAsync'] = () => other.isAsync;
    }

    if (user != other.user) {
      diff['user'] = () => other.user;
    }

    if (password != other.password) {
      diff['password'] = () => other.password;
    }

    if (withCredentials != other.withCredentials) {
      diff['withCredentials'] = () => other.withCredentials;
    }

    if (headers != other.headers) {
      diff['headers'] = () => other.headers;
    }

    if (readyState != other.readyState) {
      diff['readyState'] = () => other.readyState;
    }

    if (status != other.status) {
      diff['status'] = () => other.status;
    }

    if (responseURL != other.responseURL) {
      diff['responseURL'] = () => other.responseURL;
    }

    if (responseType != other.responseType) {
      diff['responseType'] = () => other.responseType;
    }

    if (response != other.response) {
      diff['response'] = () => other.response;
    }

    if (responseText != other.responseText) {
      diff['responseText'] = () => other.responseText;
    }

    if (responseXML != other.responseXML) {
      diff['responseXML'] = () => other.responseXML;
    }

    if (statusText != other.statusText) {
      diff['statusText'] = () => other.statusText;
    }

    if (responseHeaders != other.responseHeaders) {
      diff['responseHeaders'] = () => other.responseHeaders;
    }

    if (event != other.event) {
      diff['event'] = () => other.event;
    }

    if (action != other.action) {
      diff['action'] = () => other.action;
    }
    return diff;
  }
}
