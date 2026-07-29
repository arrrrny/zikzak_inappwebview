import 'network_request.dart';
import 'network_response.dart';
import 'network_response_body.dart';

///A complete captured request-response pair.
///
///Accumulated by `NetworkCaptureController`. [response] and [responseBody]
///are `null` until the corresponding events arrive.
class NetworkEntry {
  ///The captured request. Always present.
  final NetworkRequest request;

  ///The captured response (status + headers), or `null` if the response
  ///has not arrived yet.
  NetworkResponse? response;

  ///The captured response body, or `null` if the body has not been captured
  ///(yet) — e.g. body capture disabled, binary body skipped, or the
  ///response MIME type did not match the configured MIME filter.
  NetworkResponseBody? responseBody;

  ///Error message when the request failed (network error, abort, timeout),
  ///or `null` when no error occurred.
  String? error;

  NetworkEntry({
    required this.request,
    this.response,
    this.responseBody,
    this.error,
  });

  ///Whether the request failed with an error.
  bool get hasError => error != null;

  ///Whether both the response and (when applicable) the body have arrived.
  bool get isComplete => response != null || hasError;

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'request': request.toMap(),
      'response': response?.toMap(),
      'responseBody': responseBody?.toMap(),
      'error': error,
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'NetworkEntry{request: $request, response: $response, '
        'responseBody: $responseBody, error: $error}';
  }
}
