import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../../../web_uri.dart';

part 'request_image_ref_result.zorphy.dart';
part 'request_image_ref_result.g.dart';

///Class that represents the result used by the [PlatformInAppWebViewController.requestImageRef] method.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $RequestImageRefResult {
  ///The image's url.
  @JsonKey(fromJson: _urlFromJson, toJson: _urlToJson)
  WebUri? get url;
}
WebUri? _urlFromJson(Object? value) =>
    value == null ? null : WebUri(value as String);

Object? _urlToJson(WebUri? value) => value?.toString();
