// Hand-written (migration skip/fork — see PROGRESS.md migration map):
// ChromeSafariBrowserActionButton carries a Function()-typed onClick
// callback that the zorphy generator cannot express (zorphy #89).
// Plain Dart class preserving the public API and the old wire (id, icon,
// description, shouldTint; onClick excluded).

import 'dart:typed_data';

import '../../../web_uri.dart';

///Class that represents an action button of the Chrome Custom Tabs.
class ChromeSafariBrowserActionButton {
  ///The action button id. It should be different from the [ChromeSafariBrowserMenuItem.id].
  int id;

  ///The icon byte data.
  Uint8List icon;

  ///The description for the button. To be used for accessibility.
  String description;

  ///Whether the action button should be tinted.
  bool shouldTint;

  ///Callback function to be invoked when the action button is clicked
  void Function(WebUri? url, String title)? onClick;

  ChromeSafariBrowserActionButton({
    required this.id,
    required this.icon,
    required this.description,
    this.onClick,
    this.shouldTint = false,
  });

  ///Gets a possible [ChromeSafariBrowserActionButton] instance from a [Map] value.
  static ChromeSafariBrowserActionButton? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return ChromeSafariBrowserActionButton(
      id: map['id'],
      icon: map['icon'],
      description: map['description'],
      shouldTint: map['shouldTint'] ?? false,
    );
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "icon": icon,
      "description": description,
      "shouldTint": shouldTint,
    };
  }

  ///Gets a possible [ChromeSafariBrowserActionButton] instance from a [Map] value.
  static ChromeSafariBrowserActionButton? fromJson(Map<String, dynamic>? map) =>
      fromMap(map);

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }
}
