// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trusted_web_activity_immersive_display_mode.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///Class that represents the default display mode of a Trusted Web Activity.
///The system UI (status bar, navigation bar) is shown, and the browser toolbar is hidden while the user is on a verified origin.
class TrustedWebActivityImmersiveDisplayMode
    implements TrustedWebActivityDisplayMode {
  static final String _type = "IMMERSIVE_MODE";

  ///The constant defining how to deal with display cutouts.
  LayoutInDisplayCutoutMode displayCutoutMode;

  ///Whether the Trusted Web Activity should be in sticky immersive mode.
  bool isSticky;
  TrustedWebActivityImmersiveDisplayMode({
    required this.isSticky,
    this.displayCutoutMode = LayoutInDisplayCutoutMode.DEFAULT,
  }) {}

  ///Gets a possible [TrustedWebActivityImmersiveDisplayMode] instance from a [Map] value.
  static TrustedWebActivityImmersiveDisplayMode? fromMap(
    Map<String, dynamic>? map,
  ) {
    if (map == null) {
      return null;
    }
    final instance = TrustedWebActivityImmersiveDisplayMode(
      isSticky: map['isSticky'],
    );
    instance.displayCutoutMode = LayoutInDisplayCutoutMode.values[map['displayCutoutMode'] as int];
    return instance;
  }

  @ExchangeableObjectMethod(toMapMergeWith: true)
  Map<String, dynamic> _toMapMergeWith() {
    return {"type": _type};
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "displayCutoutMode": displayCutoutMode.index,
      "isSticky": isSticky,
      ..._toMapMergeWith(),
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  TrustedWebActivityImmersiveDisplayMode copyWith() {
    return TrustedWebActivityImmersiveDisplayMode(
      isSticky: isSticky,
      displayCutoutMode: displayCutoutMode,
    );
  }

  @override
  TrustedWebActivityImmersiveDisplayMode copyWithTrustedWebActivityDisplayMode() {
    return copyWith();
  }

  @override
  Map<String, dynamic> toJsonLean() {
    return toMap();
  }

  @override
  String toString() {
    return 'TrustedWebActivityImmersiveDisplayMode{displayCutoutMode: $displayCutoutMode, isSticky: $isSticky}';
  }
}
