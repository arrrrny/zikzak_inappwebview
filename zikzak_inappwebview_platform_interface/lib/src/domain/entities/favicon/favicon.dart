import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../../../web_uri.dart';

part 'favicon.zorphy.dart';
part 'favicon.g.dart';

///Class that represents a favicon of a website. It is used by [PlatformInAppWebViewController.getFavicons] method.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $Favicon {
  ///The url of the favicon image.
  @JsonKey(fromJson: _urlFromJson, toJson: _urlToJson)
  WebUri get url;
  ///The relationship between the current web page and the favicon image.
  String? get rel;
  ///The width of the favicon image.
  int? get width;
  ///The height of the favicon image.
  int? get height;
}
WebUri _urlFromJson(Object? value) => WebUri(value as String);

Object? _urlToJson(WebUri value) => value.toString();
