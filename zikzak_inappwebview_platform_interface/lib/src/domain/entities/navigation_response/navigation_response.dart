// Migrated from @ExchangeableObject codegen by zorphy_migrator — post-processed
// for zikzak_inappwebview: sibling-entity (URLResponse) wire glue.

import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../url_response/url_response.dart';

part 'navigation_response.zorphy.dart';
part 'navigation_response.g.dart';

///Class that represents the navigation response used by the [PlatformWebViewCreationParams.onNavigationResponse] event.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $NavigationResponse {
  ///The URL for the response.
  @JsonKey(fromJson: _responseFromJson, toJson: _responseToJson)
  URLResponse? get response;

  ///A Boolean value that indicates whether the response targets the web view’s main frame.
  bool get isForMainFrame;

  ///A Boolean value that indicates whether WebKit is capable of displaying the response’s MIME type natively.
  bool get canShowMIMEType;
}

URLResponse? _responseFromJson(Object? value) => value == null
    ? null
    : URLResponse.fromJson((value as Map).cast<String, dynamic>());

Object? _responseToJson(URLResponse? response) => response?.toJson();
