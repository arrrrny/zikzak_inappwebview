// Migrated from @ExchangeableObject codegen by zorphy_migrator — post-processed
// for zikzak_inappwebview: sibling-entity (URLRequest/SecurityOrigin) wire glue.

import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../url_request/url_request.dart';
import '../security_origin/security_origin.dart';

part 'frame_info.zorphy.dart';
part 'frame_info.g.dart';

///An object that contains information about a frame on a webpage.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $FrameInfo {
  ///A Boolean value indicating whether the frame is the web site's main frame or a subframe.
  bool get isMainFrame;

  ///The frame’s current request.
  @JsonKey(fromJson: _requestFromJson, toJson: _requestToJson)
  URLRequest? get request;

  ///The frame’s security origin.
  @JsonKey(fromJson: _securityOriginFromJson, toJson: _securityOriginToJson)
  SecurityOrigin? get securityOrigin;
}

URLRequest? _requestFromJson(Object? value) => value == null
    ? null
    : URLRequest.fromJson((value as Map).cast<String, dynamic>());

Object? _requestToJson(URLRequest? request) => request?.toJson();

SecurityOrigin? _securityOriginFromJson(Object? value) => value == null
    ? null
    : SecurityOrigin.fromJson((value as Map).cast<String, dynamic>());

Object? _securityOriginToJson(SecurityOrigin? securityOrigin) =>
    securityOrigin?.toJson();
