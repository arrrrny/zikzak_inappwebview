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

///Redacts auth-shaped secrets from a captured [NetworkRequest] before any
///consumer (raw callbacks, controller, stream, distiller) observes it.
///
///Covers FR-007 / SC-004 behavior A13 (Authorization) and A14 (session
///Cookie) at the source. (FR-007 / SC-004)
NetworkRequest redactRequest(NetworkRequest request) {
  return NetworkRequest(
    requestId: request.requestId,
    url: request.url,
    method: request.method,
    headers: _redactHeaders(request.headers),
    body: request.body,
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
