import 'package:zorphy_annotation/zorphy_annotation.dart';

part 'window_features.zorphy.dart';
part 'window_features.g.dart';

///Class that specifies optional attributes for the containing window when a new web view is requested.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $WindowFeatures {
  ///A Boolean value indicating whether the containing window should be resizable, or `null` if resizability is not specified.
  bool? get allowsResizing;

  ///A Double value specifying the height of the containing window, or `null` if the height is not specified.
  double? get height;

  ///A Boolean value indicating whether the menu bar should be visible, or `null` if menu bar visibility is not specified.
  bool? get menuBarVisibility;

  ///A Boolean value indicating whether the status bar should be visible, or `null` if status bar visibility is not specified.
  bool? get statusBarVisibility;

  ///A Boolean value indicating whether toolbars should be visible, or `null` if toolbars visibility is not specified.
  bool? get toolbarsVisibility;

  ///A Double value specifying the width of the containing window, or `null` if the width is not specified.
  double? get width;

  ///A Double value specifying the x-coordinate of the containing window, or `null` if the x-coordinate is not specified.
  double? get x;

  ///A Double value specifying the y-coordinate of the containing window, or `null` if the y-coordinate is not specified.
  double? get y;
}
