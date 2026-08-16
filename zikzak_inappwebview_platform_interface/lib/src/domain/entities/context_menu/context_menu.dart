// Hand-written (migration skip/fork — see PROGRESS.md migration map):
// ContextMenu carries FUNCTION-typed callback fields that the zorphy
// generator cannot express (issue: function-typed getters break the
// generated source). Plain Dart class preserving the public API (callbacks,
// settings, menuItems) and the wire format of the old codegen (only
// menuItems + settings on the wire).

import '../../../types/in_app_webview_hit_test_result.dart';
import '../context_menu_item/context_menu_item.dart';
import '../context_menu_settings/context_menu_settings.dart';

///Class that represents the context menu of a WebView.
class ContextMenu {
  ///Event fired when the context menu for this WebView is being built.
  ///
  ///[hitTestResult] represents the hit result for hitting an HTML elements.
  final void Function(InAppWebViewHitTestResult hitTestResult)?
  onCreateContextMenu;

  ///Event fired when the context menu for this WebView is being hidden.
  final void Function()? onHideContextMenu;

  ///Event fired when a context menu item has been clicked.
  ///
  ///[contextMenuItemClicked] represents the [ContextMenuItem] clicked.
  final void Function(ContextMenuItem contextMenuItemClicked)?
  onContextMenuActionItemClicked;

  ///Context menu settings.
  final ContextMenuSettings? settings;

  ///List of the custom [ContextMenuItem].
  final List<ContextMenuItem> menuItems;

  ContextMenu({
    this.menuItems = const [],
    this.onCreateContextMenu,
    this.onHideContextMenu,
    this.settings,
    this.onContextMenuActionItemClicked,
  });

  ///Gets a possible [ContextMenu] instance from a [Map] value.
  static ContextMenu? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return ContextMenu(
      menuItems: (map['menuItems'] as List? ?? [])
          .map((e) => ContextMenuItem.fromMap(e?.cast<String, dynamic>())!)
          .toList(),
      settings: ContextMenuSettings.fromJson(
        map['settings']?.cast<String, dynamic>(),
      ),
    );
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "menuItems": menuItems.map((e) => e.toMap()).toList(),
      "settings": settings?.toJson(),
    };
  }

  ///Gets a possible [ContextMenu] instance from a [Map] value.
  static ContextMenu? fromJson(Map<String, dynamic>? map) => fromMap(map);

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }
}
