import '../web_uri.dart';
import 'resource_type.dart';

///Represents an outgoing network request captured by the Network Capture API.
///
///Delivered through `onNetworkRequest` and accumulated into
///[NetworkEntry] instances by `NetworkCaptureController`.
class NetworkRequest {
  ///Internal correlation id shared by the request, its response and its
  ///response body. Unique within a page load.
  String requestId;

  ///Full request URL (including query parameters).
  WebUri url;

  ///HTTP method (`GET`, `POST`, `PUT`, `DELETE`, ...).
  String method;

  ///All request headers.
  Map<String, String> headers;

  ///Request body for `POST`/`PUT`/etc. requests, serialized to a readable
  ///string. `null` for requests without a body or when the body is binary
  ///(see [bodyIsBinary]).
  String? body;

  ///Whether the request body was binary (e.g. `ArrayBuffer`, `Blob`).
  ///When `true`, [body] contains a short textual description instead of the
  ///raw content.
  bool bodyIsBinary;

  ///Classification of the resource (`xhr`, `fetch`, ...).
  ResourceType resourceType;

  ///When the request was initiated, in milliseconds since epoch.
  int timestamp;

  NetworkRequest({
    this.requestId = '',
    required this.url,
    this.method = 'GET',
    Map<String, String>? headers,
    this.body,
    this.bodyIsBinary = false,
    ResourceType? resourceType,
    int? timestamp,
  }) : headers = headers ?? <String, String>{},
       resourceType = resourceType ?? ResourceType.other,
       timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  ///Gets a possible [NetworkRequest] instance from a [Map] value.
  static NetworkRequest? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final urlValue = map['url'];
    if (urlValue == null) {
      return null;
    }
    return NetworkRequest(
      requestId: map['requestId'] ?? '',
      url: urlValue is WebUri ? urlValue : WebUri(urlValue.toString()),
      method: map['method'] ?? 'GET',
      headers: map['headers'] != null
          ? Map<String, String>.from(
              (map['headers'] as Map).map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : null,
      body: map['body'],
      bodyIsBinary: map['bodyIsBinary'] ?? false,
      resourceType: ResourceType.fromNativeValue(map['resourceType']),
      timestamp: map['timestamp'],
    );
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'url': url.toString(),
      'method': method,
      'headers': headers,
      'body': body,
      'bodyIsBinary': bodyIsBinary,
      'resourceType': resourceType.toNativeValue(),
      'timestamp': timestamp,
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'NetworkRequest{requestId: $requestId, url: $url, method: $method, '
        'headers: $headers, bodyIsBinary: $bodyIsBinary, '
        'resourceType: $resourceType, timestamp: $timestamp}';
  }
}
