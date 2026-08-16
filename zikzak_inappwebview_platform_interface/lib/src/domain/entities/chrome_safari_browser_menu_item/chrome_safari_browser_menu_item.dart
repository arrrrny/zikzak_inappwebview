// Hand-written (migration skip/fork — see PROGRESS.md migration map):
// ChromeSafariBrowserMenuItem carries a Function()-typed onClick callback
// that the zorphy generator cannot express (zorphy #89).
// Plain Dart class preserving the public API and the old wire (id, label,
// image; onClick excluded).

import '../../../types/ui_image.dart';
import '../../../web_uri.dart';

///Class that represents a menu item of the Chrome Custom Tabs.
class ChromeSafariBrowserMenuItem {
  ///The menu item id.
  int id;

  ///The label of the menu item.
  String label;

  ///The image of the menu item.
  UIImage? image;

  ///Callback function to be invoked when the menu item is clicked.
  void Function(WebUri? url, String title)? onClick;

  ChromeSafariBrowserMenuItem({
    required this.id,
    required this.label,
    this.image,
    this.onClick,
  });

  ///Gets a possible [ChromeSafariBrowserMenuItem] instance from a [Map] value.
  static ChromeSafariBrowserMenuItem? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return ChromeSafariBrowserMenuItem(
      id: map['id'],
      label: map['label'],
      image: UIImage.fromMap(map['image']?.cast<String, dynamic>()),
    );
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {"id": id, "image": image?.toMap(), "label": label};
  }

  ///Gets a possible [ChromeSafariBrowserMenuItem] instance from a [Map] value.
  static ChromeSafariBrowserMenuItem? fromJson(Map<String, dynamic>? map) =>
      fromMap(map);

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }
}
