import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

import 'context_menu.dart';
import '../util.dart';

part 'context_menu_item.g.dart';

///Class that represent an item of the [ContextMenu].
@ExchangeableObject()
class ContextMenuItem_ {
  ///Menu item ID. It cannot be `null` and it can be a [String] or an [int].
  ///
  ///**NOTE for Android**: it must be an [int] value.
  dynamic id;

  ///Menu item title.
  String title;

  ///Menu item action that will be called when an user clicks on it.
  Function()? action;

  @ExchangeableObjectConstructor()
  ContextMenuItem_({this.id, required this.title, this.action}) {
    if (Util.isAndroid) {
      assert(this.id is int);
    }
    assert(this.id != null && (this.id is int || this.id is String));
  }
}
