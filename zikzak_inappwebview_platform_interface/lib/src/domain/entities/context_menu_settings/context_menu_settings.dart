import 'package:zorphy_annotation/zorphy_annotation.dart';

part 'context_menu_settings.zorphy.dart';
part 'context_menu_settings.g.dart';

///Class that represents available settings used by [ContextMenu].
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $ContextMenuSettings {
  ///Whether all the default system context menu items should be hidden or not. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool get hideDefaultSystemContextMenuItems;
}
