import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

///Marker substituted for any redacted secret value.
const String kRedactionMarker = '<redacted>';

///Headers whose values are always redacted at the source because they carry
///auth-shaped secrets (bearer tokens, proxy credentials, session cookies).
const List<String> _redactedHeaderKeys = <String>[
  'authorization',
  'proxy-authorization',
  'cookie',
  'set-cookie',
];

///Query/body parameter names whose values are always redacted at the source
///because they carry auth-shaped secrets (API keys, passwords, tokens).
const List<String> _redactedParamKeys = <String>[
  'api_key',
  'apikey',
  'password',
  'passwd',
  'secret',
  'token',
  'access_token',
  'refresh_token',
  'client_secret',
];

bool _isRedactableParam(String key) =>
    _redactedParamKeys.contains(key.toLowerCase());

Map<String, String> _redactHeaders(Map<String, String> headers) {
  if (headers.isEmpty) return headers;
  final out = <String, String>{};
  headers.forEach((key, value) {
    out[key] = _redactedHeaderKeys.contains(key.toLowerCase())
        ? kRedactionMarker
        : value;
  });
  return out;
}

///Redacts auth-shaped query parameters from a [WebUri], returning a new URI with
///the same structure but redacted param values (A15, source-level).
WebUri _redactUrl(WebUri url) {
  final queryParams = url.queryParameters;
  if (queryParams.isEmpty) return url;
  final redacted = <String, String>{};
  queryParams.forEach((key, value) {
    redacted[key] = _isRedactableParam(key) ? kRedactionMarker : value;
  });
  return WebUri.uri(url.replace(queryParameters: redacted));
}

///Redacts auth-shaped values from a `application/x-www-form-urlencoded` body
///string, leaving keys and non-secret params intact (A15, source-level).
String _redactFormBody(String body) {
  if (body.isEmpty) return body;
  return body.replaceAllMapped(RegExp(r'(^|&)([^=&]+)=([^&]*)'), (m) {
    final key = m.group(2)!;
    final value = m.group(3)!;
    if (_isRedactableParam(key)) {
      return '${m.group(1)}${key}=${kRedactionMarker}';
    }
    return m.group(0)!;
  });
}

///Redacts auth-shaped secrets from a captured [NetworkRequest] before any
///consumer (raw callbacks, controller, stream, distiller) observes it.
///
///Covers FR-007 / SC-004 behavior A13 (Authorization) and A14 (session
///Cookie) at the source. (FR-007 / SC-004)
NetworkRequest redactRequest(NetworkRequest request) {
  return NetworkRequest(
    requestId: request.requestId,
    url: _redactUrl(request.url),
    method: request.method,
    headers: _redactHeaders(request.headers),
    body: request.body == null ? null : _redactFormBody(request.body!),
    bodyIsBinary: request.bodyIsBinary,
    resourceType: request.resourceType,
    timestamp: request.timestamp,
  );
}

///Redacts auth-shaped secrets from a captured [NetworkResponse], including the
///`Set-Cookie` header that establishes a session (A14, source-level).
NetworkResponse redactResponse(NetworkResponse response) {
  return NetworkResponse(
    requestId: response.requestId,
    url: response.url,
    statusCode: response.statusCode,
    statusText: response.statusText,
    headers: _redactHeaders(response.headers),
    mimeType: response.mimeType,
    resourceType: response.resourceType,
    timestamp: response.timestamp,
    duration: response.duration,
    fromCache: response.fromCache,
    fromServiceWorker: response.fromServiceWorker,
  );
}

///Redacts auth-shaped secrets from a captured [NetworkResponseBody].
///
///Body content redaction (URL/body auth params, A15) is a separate behavior
///and is intentionally a pass-through here until that cycle lands.
NetworkResponseBody redactBody(NetworkResponseBody body) => body;
