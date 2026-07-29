import '../web_uri.dart';
import 'resource_type.dart';

///Represents a network response (status + headers) captured by the
///Network Capture API, before the body has been fully read.
///
///Delivered through `onNetworkResponse`. The corresponding body is
///delivered separately through `onNetworkLoadingFinished`.
class NetworkResponse {
  ///Internal correlation id shared with the originating [NetworkRequest].
  String requestId;

  ///Response URL. May differ from the request URL after redirects.
  WebUri url;

  ///HTTP status code (200, 404, 500, ...).
  int statusCode;

  ///HTTP status text, e.g. `"OK"`, `"Not Found"`.
  String statusText;

  ///All response headers.
  Map<String, String> headers;

  ///Response MIME type, e.g. `application/json`.
  String mimeType;

  ///Classification of the resource (`xhr`, `fetch`, ...).
  ResourceType resourceType;

  ///When the response was received, in milliseconds since epoch.
  int timestamp;

  ///Milliseconds from request start to response received.
  int duration;

  ///Whether the response was served from the browser cache.
  ///
  ///**NOTE**: with the JavaScript-injection-based capture engine this is a
  ///best-effort heuristic based on `PerformanceResourceTiming`
  ///(`transferSize == 0 && decodedBodySize > 0`).
  bool fromCache;

  ///Whether the response was served by a service worker.
  ///
  ///**NOTE**: not detectable from JavaScript injection; always `false`
  ///with the default capture engine.
  bool fromServiceWorker;

  NetworkResponse({
    this.requestId = '',
    required this.url,
    this.statusCode = 0,
    this.statusText = '',
    Map<String, String>? headers,
    this.mimeType = '',
    ResourceType? resourceType,
    int? timestamp,
    this.duration = 0,
    this.fromCache = false,
    this.fromServiceWorker = false,
  }) : headers = headers ?? <String, String>{},
       resourceType = resourceType ?? ResourceType.other,
       timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  ///Gets a possible [NetworkResponse] instance from a [Map] value.
  static NetworkResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final urlValue = map['url'];
    if (urlValue == null) {
      return null;
    }
    return NetworkResponse(
      requestId: map['requestId'] ?? '',
      url: urlValue is WebUri ? urlValue : WebUri(urlValue.toString()),
      statusCode: map['statusCode'] ?? 0,
      statusText: map['statusText'] ?? '',
      headers: map['headers'] != null
          ? Map<String, String>.from(
              (map['headers'] as Map).map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : null,
      mimeType: map['mimeType'] ?? '',
      resourceType: ResourceType.fromNativeValue(map['resourceType']),
      timestamp: map['timestamp'],
      duration: map['duration'] ?? 0,
      fromCache: map['fromCache'] ?? false,
      fromServiceWorker: map['fromServiceWorker'] ?? false,
    );
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'url': url.toString(),
      'statusCode': statusCode,
      'statusText': statusText,
      'headers': headers,
      'mimeType': mimeType,
      'resourceType': resourceType.toNativeValue(),
      'timestamp': timestamp,
      'duration': duration,
      'fromCache': fromCache,
      'fromServiceWorker': fromServiceWorker,
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'NetworkResponse{requestId: $requestId, url: $url, '
        'statusCode: $statusCode, statusText: $statusText, '
        'mimeType: $mimeType, resourceType: $resourceType, '
        'timestamp: $timestamp, duration: $duration, '
        'fromCache: $fromCache, fromServiceWorker: $fromServiceWorker}';
  }
}
