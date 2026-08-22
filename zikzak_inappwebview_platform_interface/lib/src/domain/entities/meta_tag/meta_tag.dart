import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../meta_tag_attribute/meta_tag_attribute.dart';

part 'meta_tag.zorphy.dart';
part 'meta_tag.g.dart';

///Class that represents a `<meta>` HTML tag. It is used by the [PlatformInAppWebViewController.getMetaTags] method.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $MetaTag {
  ///The meta tag name value.
  String? get name;

  ///The meta tag content value.
  String? get content;

  ///The meta tag attributes list.
  List<MetaTagAttribute>? get attrs;
}
