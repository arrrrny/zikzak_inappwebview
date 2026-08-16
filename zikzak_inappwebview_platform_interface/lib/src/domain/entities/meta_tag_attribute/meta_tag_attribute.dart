import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../meta_tag/meta_tag.dart';

part 'meta_tag_attribute.zorphy.dart';
part 'meta_tag_attribute.g.dart';

///Class that represents an attribute of a `<meta>` HTML tag. It is used by the [MetaTag] class.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $MetaTagAttribute {
  ///The attribute name.
  String? get name;

  ///The attribute value.
  String? get value;
}
