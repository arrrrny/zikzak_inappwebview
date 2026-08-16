import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../../../web_uri.dart';

part 'request_focus_node_href_result.zorphy.dart';
part 'request_focus_node_href_result.g.dart';

///Class that represents the result used by the [PlatformInAppWebViewController.requestFocusNodeHref] method.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $RequestFocusNodeHrefResult {
  ///The anchor's href attribute.
  @JsonKey(fromJson: _urlFromJson, toJson: _urlToJson)
  WebUri? get url;
  ///The anchor's text.
  String? get title;
  ///The image's src attribute.
  String? get src;
}
WebUri? _urlFromJson(Object? value) =>
    value == null ? null : WebUri(value as String);

Object? _urlToJson(WebUri? value) => value?.toString();
