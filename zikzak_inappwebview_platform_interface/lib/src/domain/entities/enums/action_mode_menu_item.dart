///Class used to disable the action mode menu items.
enum ActionModeMenuItem {
  ///No menu items should be disabled.
  MENU_ITEM_NONE,

  ///Disable menu item "Share".
  MENU_ITEM_SHARE,

  ///Disable menu item "Web Search".
  MENU_ITEM_WEB_SEARCH,

  ///Disable all the action mode menu items for text processing.
  MENU_ITEM_PROCESS_TEXT,
}

///action_mode_menu_item wire values are NOT sequential (0, 1, 2, 4) — a plain enum's `.index`
///does not match the old `_value`.

///ActionModeMenuItem wire values are NOT sequential (0, 1, 2, 4) — lookup by value.
const _actionModeMenuItem_wire = [0, 1, 2, 4];

ActionModeMenuItem? actionModeMenuItemFromWire(Object? value) {
  if (value is! int) return null;
  final index = _actionModeMenuItem_wire.indexOf(value);
  return index >= 0 ? ActionModeMenuItem.values[index] : null;
}

Object? actionModeMenuItemToWire(ActionModeMenuItem? value) =>
    value == null ? null : _actionModeMenuItem_wire[value.index];
