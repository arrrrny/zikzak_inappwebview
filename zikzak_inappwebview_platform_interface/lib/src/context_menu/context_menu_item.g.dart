// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context_menu_item.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///Class that represent an item of the [ContextMenu].
class ContextMenuItem {
  ///Menu item action that will be called when an user clicks on it.
  dynamic Function()? action;

  ///Menu item ID. It cannot be `null` and it can be a [String] or an [int].
  ///
  ///**NOTE for Android**: it must be an [int] value.
  dynamic id;

  ///Menu item title.
  String title;
  ContextMenuItem({this.id, required this.title, this.action}) {
    if (Util.isAndroid) {
      assert(this.id is int);
    }
    assert(this.id != null && (this.id is int || this.id is String));
  }

  ///Gets a possible [ContextMenuItem] instance from a [Map] value.
  static ContextMenuItem? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ContextMenuItem(id: map['id'], title: map['title']);
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {"id": id, "title": title};
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ContextMenuItem{id: $id, title: $title}';
  }
}
