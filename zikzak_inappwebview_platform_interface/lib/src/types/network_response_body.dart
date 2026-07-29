import 'dart:convert';

import '../web_uri.dart';

///Represents a fully captured response body.
///
///Delivered through `onNetworkLoadingFinished` after the body has been
///fully read, and accumulated into [NetworkEntry] instances by
///`NetworkCaptureController`.
class NetworkResponseBody {
  ///Internal correlation id shared with the originating request/response.
  String requestId;

  ///Response URL (may differ from the request URL after redirects).
  WebUri url;

  ///Response body as a string, truncated to
  ///`InAppWebViewSettings.networkCaptureMaxBodySize` characters when larger.
  ///When [isBase64] is `true`, this is the base64 encoding of a binary body.
  String body;

  ///Whether [body] is a base64-encoded binary payload.
  bool isBase64;

  ///Original body size (in characters for text bodies, in bytes for binary
  ///bodies), measured **before** truncation.
  int size;

  ///Whether [body] was truncated.
  bool truncated;

  ///The MIME type of the response, if known.
  String? mimeType;

  dynamic _decoded;
  bool _decodedComputed = false;

  NetworkResponseBody({
    this.requestId = '',
    required this.url,
    this.body = '',
    this.isBase64 = false,
    this.size = 0,
    this.truncated = false,
    this.mimeType,
  });

  ///The parsed JSON value of [body], when the body is valid JSON
  ///(and not base64-encoded / truncated in a way that breaks parsing).
  ///Returns `null` otherwise. The result is cached.
  dynamic get decoded {
    if (!_decodedComputed) {
      _decodedComputed = true;
      _decoded = null;
      if (!isBase64 && body.isNotEmpty) {
        try {
          _decoded = jsonDecode(body);
        } catch (_) {
          _decoded = null;
        }
      }
    }
    return _decoded;
  }

  ///Decodes a base64-encoded binary [body] into bytes.
  ///Returns `null` when [isBase64] is `false`.
  List<int>? get bytes {
    if (!isBase64) {
      return null;
    }
    try {
      return base64Decode(body);
    } catch (_) {
      return null;
    }
  }

  ///Gets a possible [NetworkResponseBody] instance from a [Map] value.
  static NetworkResponseBody? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final urlValue = map['url'];
    if (urlValue == null) {
      return null;
    }
    return NetworkResponseBody(
      requestId: map['requestId'] ?? '',
      url: urlValue is WebUri ? urlValue : WebUri(urlValue.toString()),
      body: map['body'] ?? '',
      isBase64: map['isBase64'] ?? false,
      size: map['size'] ?? 0,
      truncated: map['truncated'] ?? false,
      mimeType: map['mimeType'],
    );
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'url': url.toString(),
      'body': body,
      'isBase64': isBase64,
      'size': size,
      'truncated': truncated,
      'mimeType': mimeType,
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'NetworkResponseBody{requestId: $requestId, url: $url, '
        'isBase64: $isBase64, size: $size, truncated: $truncated, '
        'mimeType: $mimeType}';
  }
}
