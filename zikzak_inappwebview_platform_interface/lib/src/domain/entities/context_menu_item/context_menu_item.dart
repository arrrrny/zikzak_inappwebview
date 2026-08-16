// Hand-written (migration skip/fork — see PROGRESS.md migration map):
// ContextMenuItem carries a Function()-typed action callback that the zorphy
// generator cannot express (issue: function-typed getters break the
// generated source). Plain Dart class preserving the public API (id, title,
// action) and the wire format of the old codegen (only id + title on the
// wire; the fork's constructor asserts are dev-time validation only).

///Class that represents a menu item of a [ContextMenu].
class ContextMenuItem {
  ///Menu item ID. It cannot be `null` and it can be a [String] or an [int].
  ///
  ///**NOTE for Android**: it must be an [int] value.
  dynamic id;

  ///Menu item title.
  String title;

  ///Menu item action that will be called when an user clicks on it.
  Function()? action;

  ContextMenuItem({this.id, required this.title, this.action});

  ///Gets a possible [ContextMenuItem] instance from a [Map] value.
  static ContextMenuItem? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return ContextMenuItem(id: map['id'], title: map['title']);
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {"id": id, "title": title};
  }

  ///Gets a possible [ContextMenuItem] instance from a [Map] value.
  static ContextMenuItem? fromJson(Map<String, dynamic>? map) => fromMap(map);

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }
}
