import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

import 'context_menu.dart';

part 'context_menu_settings.g.dart';

///Class that represents available settings used by [ContextMenu].
@ExchangeableObject(copyMethod: true)
class ContextMenuSettings_ {
  ///Whether all the default system context menu items should be hidden or not. The default value is `false`.
  bool hideDefaultSystemContextMenuItems;

  ContextMenuSettings_({this.hideDefaultSystemContextMenuItems = false});
}
