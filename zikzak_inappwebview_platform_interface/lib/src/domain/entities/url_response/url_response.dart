// Migrated from @ExchangeableObject codegen by zorphy_migrator — post-processed
// for zikzak_inappwebview: WebUri + Map<String,String> wire glue.

import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../../../web_uri.dart';

part 'url_response.zorphy.dart';
part 'url_response.g.dart';

///The metadata associated with the response to a URL load request, independent of protocol and URL scheme.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $URLResponse {
  ///The URL for the response.
  @JsonKey(fromJson: _urlFromJson, toJson: _urlToJson)
  WebUri? get url;

  ///The expected length of the response’s content.
  int get expectedContentLength;

  ///The MIME type of the response.
  String? get mimeType;

  ///A suggested filename for the response data.
  String? get suggestedFilename;

  ///The name of the text encoding provided by the response’s originating source.
  String? get textEncodingName;

  ///All HTTP header fields of the response.
  @JsonKey(fromJson: _headersFromJson, toJson: _headersToJson)
  Map<String, String>? get headers;

  ///The response’s HTTP status code.
  int? get statusCode;
}

WebUri? _urlFromJson(Object? value) =>
    value == null ? null : WebUri(value as String);

Object? _urlToJson(WebUri? value) => value?.toString();

Map<String, String>? _headersFromJson(Object? value) =>
    value == null ? null : (value as Map).cast<String, String>();

Object? _headersToJson(Map<String, String>? headers) => headers;
