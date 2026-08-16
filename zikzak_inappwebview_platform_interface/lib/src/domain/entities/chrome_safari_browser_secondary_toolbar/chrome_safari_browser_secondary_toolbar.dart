// Hand-written (migration skip/fork — see PROGRESS.md migration map):
// ChromeSafariBrowserSecondaryToolbar + ChromeSafariBrowserSecondaryToolbarClickableID
// carry Function()-typed onClick callbacks that the zorphy generator cannot
// express (zorphy #89). Plain Dart classes preserving the public API and the
// old wire (layout + clickableIDs; onClick excluded).

import '../android_resource/android_resource.dart';
import '../../../web_uri.dart';

///Class that represents the secondary toolbar of the Chrome Custom Tabs.
class ChromeSafariBrowserSecondaryToolbar {
  ///The android layout resource.
  AndroidResource layout;

  ///The IDs of clickable views. The `onClick` event of these views will be handled by custom tabs.
  List<ChromeSafariBrowserSecondaryToolbarClickableID> clickableIDs;

  ChromeSafariBrowserSecondaryToolbar({
    required this.layout,
    this.clickableIDs = const [],
  });

  ///Gets a possible [ChromeSafariBrowserSecondaryToolbar] instance from a [Map] value.
  static ChromeSafariBrowserSecondaryToolbar? fromMap(
    Map<String, dynamic>? map,
  ) {
    if (map == null) {
      return null;
    }
    return ChromeSafariBrowserSecondaryToolbar(
      layout: AndroidResource.fromJson(map['layout']?.cast<String, dynamic>())!,
      clickableIDs: (map['clickableIDs'] as List? ?? [])
          .map(
            (e) => ChromeSafariBrowserSecondaryToolbarClickableID.fromMap(
              e?.cast<String, dynamic>(),
            )!,
          )
          .toList(),
    );
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "layout": layout.toJson(),
      "clickableIDs": clickableIDs.map((e) => e.toJson()).toList(),
    };
  }

  ///Gets a possible [ChromeSafariBrowserSecondaryToolbar] instance from a [Map] value.
  static ChromeSafariBrowserSecondaryToolbar? fromJson(
    Map<String, dynamic>? map,
  ) => fromMap(map);

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }
}

///Class that represents a clickable ID of the secondary toolbar.
class ChromeSafariBrowserSecondaryToolbarClickableID {
  ///The android id resource
  AndroidResource id;

  ///Callback function to be invoked when the item is clicked
  void Function(WebUri?)? onClick;

  ChromeSafariBrowserSecondaryToolbarClickableID({
    required this.id,
    this.onClick,
  });

  ///Gets a possible [ChromeSafariBrowserSecondaryToolbarClickableID] instance from a [Map] value.
  static ChromeSafariBrowserSecondaryToolbarClickableID? fromMap(
    Map<String, dynamic>? map,
  ) {
    if (map == null) {
      return null;
    }
    return ChromeSafariBrowserSecondaryToolbarClickableID(
      id: AndroidResource.fromJson(map['id']?.cast<String, dynamic>())!,
    );
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {"id": id.toJson()};
  }

  ///Gets a possible [ChromeSafariBrowserSecondaryToolbarClickableID] instance from a [Map] value.
  static ChromeSafariBrowserSecondaryToolbarClickableID? fromJson(
    Map<String, dynamic>? map,
  ) => fromMap(map);

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }
}
