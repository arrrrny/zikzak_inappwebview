// Hand-written (migration skip/fork — see PROGRESS.md migration map):
// InAppBrowserMenuItem carries a Function()-typed onClick callback that the
// zorphy generator cannot express (zorphy #89). Plain Dart class preserving
// the public API and the old wire (id, title, polymorphic icon, iconColor as
// hex, order, showAsAction; onClick excluded).

import 'dart:typed_data';

import '../../../types/main.dart';
import '../../../util.dart';

dynamic _serializeIcon(dynamic icon) {
  return icon is Uint8List ? icon : icon?.toMap();
}

dynamic _deserializeIcon(dynamic icon) {
  if (icon is Uint8List) {
    return icon;
  }
  if (icon is Map<String, dynamic>) {
    final iconMap = icon as Map<String, dynamic>;
    if (iconMap.containsKey('defType')) {
      return AndroidResource.fromMap(iconMap);
    }
    if (iconMap.containsKey('systemName')) {
      return UIImage.fromMap(iconMap);
    }
  }
  return null;
}

///Class that represents a menu item of the InAppBrowser.
class InAppBrowserMenuItem {
  ///The menu item id.
  int id;

  ///The menu item title.
  String title;

  ///The menu item icon. It can be a [Uint8List], an [AndroidResource] or a [UIImage].
  dynamic icon;

  ///The menu item icon color.
  Color_? iconColor;

  ///The menu item order.
  int? order;

  ///Whether the menu item should be shown as an action.
  bool showAsAction;

  ///Callback function to be invoked when the menu item is clicked.
  void Function()? onClick;

  InAppBrowserMenuItem({
    required this.id,
    required this.title,
    this.icon,
    this.iconColor,
    this.order,
    this.showAsAction = false,
    this.onClick,
  });

  ///Gets a possible [InAppBrowserMenuItem] instance from a [Map] value.
  static InAppBrowserMenuItem? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return InAppBrowserMenuItem(
      id: map['id'],
      title: map['title'],
      icon: _deserializeIcon(map['icon']),
      iconColor: map['iconColor'] != null
          ? Color_(UtilColor.fromStringRepresentation(map['iconColor'])!.value)
          : null,
      order: map['order'],
      showAsAction: map['showAsAction'] ?? false,
    );
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "icon": _serializeIcon(icon),
      "iconColor": iconColor?.toHex(),
      "order": order,
      "showAsAction": showAsAction,
    };
  }

  ///Gets a possible [InAppBrowserMenuItem] instance from a [Map] value.
  static InAppBrowserMenuItem? fromJson(Map<String, dynamic>? map) =>
      fromMap(map);

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }
}
