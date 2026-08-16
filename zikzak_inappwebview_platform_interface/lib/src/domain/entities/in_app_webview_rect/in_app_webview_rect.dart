import 'package:zorphy_annotation/zorphy_annotation.dart';

part 'in_app_webview_rect.zorphy.dart';
part 'in_app_webview_rect.g.dart';

///A class that represents a structure that contains the location and dimensions of a rectangle.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $InAppWebViewRect {
  ///x position
  double get x;

  ///y position
  double get y;

  ///rect width
  double get width;

  ///rect height
  double get height;
}
