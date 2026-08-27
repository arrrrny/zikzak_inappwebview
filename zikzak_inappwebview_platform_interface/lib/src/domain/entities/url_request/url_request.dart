// Migrated from @ExchangeableObject codegen by zorphy_migrator — post-processed
// for zikzak_inappwebview: WebUri / Uint8List / Map / int-wire enum glue
// (URLRequestNetworkServiceType keeps its non-sequential `_value` wire).

import 'dart:typed_data';
import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../../../web_uri.dart';
import '../enums/url_request_cache_policy.dart';
import '../enums/url_request_network_service_type.dart';
import '../enums/url_request_attribution.dart';

part 'url_request.zorphy.dart';
part 'url_request.g.dart';

///A URL load request that is independent of protocol or URL scheme.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $URLRequest {
  ///The URL of the request. Setting this to `null` will load `about:blank`.
  @JsonKey(fromJson: _urlFromJson, toJson: _urlToJson)
  WebUri? get url;

  ///The HTTP request method.
  ///
  ///**NOTE for Android**: it supports only "GET" and "POST" methods.
  String? get method;

  ///A dictionary containing all of the HTTP header fields for a request.
  @JsonKey(fromJson: _headersFromJson, toJson: _headersToJson)
  Map<String, String>? get headers;

  ///The data sent as the message body of a request, such as for an HTTP POST request.
  @JsonKey(fromJson: _bodyFromJson, toJson: _bodyToJson)
  Uint8List? get body;

  ///A Boolean value indicating whether the request is allowed to use the built-in cellular radios to satisfy the request.
  bool? get allowsCellularAccess;

  ///A Boolean value that indicates whether the request may use the network when the user has specified Low Data Mode.
  bool? get allowsConstrainedNetworkAccess;

  ///A Boolean value that indicates whether connections may use a network interface that the system considers expensive.
  bool? get allowsExpensiveNetworkAccess;

  ///The request’s cache policy.
  @JsonKey(fromJson: _cachePolicyFromJson, toJson: _cachePolicyToJson)
  URLRequestCachePolicy? get cachePolicy;

  ///A Boolean value indicating whether cookies will be sent with and set for this request.
  bool? get httpShouldHandleCookies;

  ///A Boolean value indicating whether the request should transmit before the previous response is received.
  bool? get httpShouldUsePipelining;

  ///The service type associated with this request.
  @JsonKey(
    fromJson: _networkServiceTypeFromJson,
    toJson: _networkServiceTypeToJson,
  )
  URLRequestNetworkServiceType? get networkServiceType;

  ///The timeout interval of the request.
  ///
  /// On iOS/macOS this maps to the native `URLRequest.timeoutInterval`.
  /// On Android this triggers a `WebView.stopLoading()` after the interval,
  /// so whatever HTML has been rendered so far is available for extraction
  /// (smart timeout — no hard failure).
  double? get timeoutInterval;

  ///The main document URL associated with this request.
  ///This URL is used for the cookie “same domain as main document” policy.
  @JsonKey(fromJson: _mainDocumentURLFromJson, toJson: _mainDocumentURLToJson)
  WebUri? get mainDocumentURL;

  ///`true` if server endpoint is known to support HTTP/3. Enables QUIC racing
  ///without HTTP/3 service discovery. Defaults to `false`.
  ///The default may be `true` in a future OS update.
  bool? get assumesHTTP3Capable;

  ///The entities that can make a network request.
  ///
  ///If you don’t set a value, the system assumes [URLRequestAttribution.DEVELOPER].
  @JsonKey(fromJson: _attributionFromJson, toJson: _attributionToJson)
  URLRequestAttribution? get attribution;
}

WebUri? _urlFromJson(Object? value) =>
    value == null ? null : WebUri(value as String);

Object? _urlToJson(WebUri? value) => value?.toString();

Map<String, String>? _headersFromJson(Object? value) =>
    value == null ? null : (value as Map).cast<String, String>();

Object? _headersToJson(Map<String, String>? headers) => headers;

Uint8List? _bodyFromJson(Object? value) {
  if (value == null) return null;
  if (value is Uint8List) return value;
  if (value is List) {
    try {
      return Uint8List.fromList(value.cast<int>());
    } catch (_) {
      return null;
    }
  }
  return null;
}

Object? _bodyToJson(Uint8List? body) => body;

URLRequestCachePolicy? _cachePolicyFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < URLRequestCachePolicy.values.length
      ? URLRequestCachePolicy.values[value]
      : null;
}

Object? _cachePolicyToJson(URLRequestCachePolicy? cachePolicy) =>
    cachePolicy?.index;

///The old `URLRequestNetworkServiceType` wire values are NOT sequential
///(0, 2, 3, 4, 6, 8, 9, 11), so a plain enum's `.index` cannot reproduce the
///wire — these helpers keep the original `_value` ints.
const _networkServiceTypeWire = [0, 2, 3, 4, 6, 8, 9, 11];

URLRequestNetworkServiceType? _networkServiceTypeFromJson(Object? value) {
  if (value is! int) return null;
  final index = _networkServiceTypeWire.indexOf(value);
  return index >= 0 ? URLRequestNetworkServiceType.values[index] : null;
}

Object? _networkServiceTypeToJson(URLRequestNetworkServiceType? type) =>
    type == null ? null : _networkServiceTypeWire[type.index];

WebUri? _mainDocumentURLFromJson(Object? value) =>
    value == null ? null : WebUri(value as String);

Object? _mainDocumentURLToJson(WebUri? value) => value?.toString();

URLRequestAttribution? _attributionFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < URLRequestAttribution.values.length
      ? URLRequestAttribution.values[value]
      : null;
}

Object? _attributionToJson(URLRequestAttribution? attribution) =>
    attribution?.index;
