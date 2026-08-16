// Migrated from @ExchangeableObject codegen by zorphy_migrator — hand-written
// entity (the migrator flagged the custom @ExchangeableObjectConstructor +
// deserializer as manual): fork constructor defaults preserved via @JsonKey
// defaultValue; the ctor asserts (startAnimations/exitAnimations length 2 —
// dev-time validation only) are dropped. Wire matches the old codegen:
// still-codegen types keep their fromNativeValue/fromMap/toMap API, Color_
// as hex, displayMode via the polymorphic type-key deserializer.

import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../../../types/main.dart';
import '../../../util.dart';

part 'chrome_safari_browser_settings.zorphy.dart';
part 'chrome_safari_browser_settings.g.dart';

///Class that represents the ChromeSafariBrowser settings.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $ChromeSafariBrowserSettings {
  @JsonKey(
    defaultValue: CustomTabsShareState.SHARE_STATE_DEFAULT,
    fromJson: _shareStateFromJson,
    toJson: _shareStateToJson,
  )
  CustomTabsShareState? get shareState;
  @JsonKey(defaultValue: true)
  bool? get showTitle;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get toolbarBackgroundColor;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get navigationBarColor;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get navigationBarDividerColor;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get secondaryToolbarColor;
  @JsonKey(defaultValue: false)
  bool? get enableUrlBarHiding;
  @JsonKey(defaultValue: false)
  bool? get instantAppsEnabled;
  String? get packageName;
  @JsonKey(defaultValue: false)
  bool? get keepAliveEnabled;
  @JsonKey(defaultValue: false)
  bool? get isSingleInstance;
  @JsonKey(defaultValue: false)
  bool? get noHistory;
  @JsonKey(defaultValue: false)
  bool? get isTrustedWebActivity;
  @JsonKey(defaultValue: const [])
  List<String>? get additionalTrustedOrigins;
  @JsonKey(fromJson: _displayModeFromJson, toJson: _displayModeToJson)
  TrustedWebActivityDisplayMode? get displayMode;
  @JsonKey(
    defaultValue: TrustedWebActivityScreenOrientation.DEFAULT,
    fromJson: _screenOrientationFromJson,
    toJson: _screenOrientationToJson,
  )
  TrustedWebActivityScreenOrientation? get screenOrientation;
  @JsonKey(fromJson: _startAnimationsFromJson, toJson: _startAnimationsToJson)
  List<AndroidResource>? get startAnimations;
  @JsonKey(fromJson: _exitAnimationsFromJson, toJson: _exitAnimationsToJson)
  List<AndroidResource>? get exitAnimations;
  @JsonKey(defaultValue: false)
  bool? get alwaysUseBrowserUI;
  @JsonKey(defaultValue: false)
  bool? get entersReaderIfAvailable;
  @JsonKey(defaultValue: false)
  bool? get barCollapsingEnabled;
  @JsonKey(
    defaultValue: DismissButtonStyle.DONE,
    fromJson: _dismissButtonStyleFromJson,
    toJson: _dismissButtonStyleToJson,
  )
  DismissButtonStyle? get dismissButtonStyle;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get preferredBarTintColor;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get preferredControlTintColor;
  @JsonKey(
    defaultValue: ModalPresentationStyle.FULL_SCREEN,
    fromJson: _presentationStyleFromJson,
    toJson: _presentationStyleToJson,
  )
  ModalPresentationStyle? get presentationStyle;
  @JsonKey(
    defaultValue: ModalTransitionStyle.COVER_VERTICAL,
    fromJson: _transitionStyleFromJson,
    toJson: _transitionStyleToJson,
  )
  ModalTransitionStyle? get transitionStyle;
  @JsonKey(fromJson: _activityButtonFromJson, toJson: _activityButtonToJson)
  ActivityButton? get activityButton;
  @JsonKey(fromJson: _eventAttributionFromJson, toJson: _eventAttributionToJson)
  UIEventAttribution? get eventAttribution;
}

Color_? _colorFromJson(Object? value) {
  if (value == null) return null;
  final color = UtilColor.fromStringRepresentation(value as String);
  return color == null ? null : Color_(color.value);
}

Object? _colorToJson(Color_? color) => color?.toHex();

CustomTabsShareState? _shareStateFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < CustomTabsShareState.values.length
      ? CustomTabsShareState.values[value]
      : null;
}

Object? _shareStateToJson(CustomTabsShareState? shareState) => shareState?.index;

TrustedWebActivityScreenOrientation? _screenOrientationFromJson(
  Object? value,
) {
  if (value is! int) return null;
  return value >= 0 && value < TrustedWebActivityScreenOrientation.values.length
      ? TrustedWebActivityScreenOrientation.values[value]
      : null;
}

Object? _screenOrientationToJson(
  TrustedWebActivityScreenOrientation? screenOrientation,
) => screenOrientation?.index;

DismissButtonStyle? _dismissButtonStyleFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < DismissButtonStyle.values.length
      ? DismissButtonStyle.values[value]
      : null;
}

Object? _dismissButtonStyleToJson(DismissButtonStyle? dismissButtonStyle) =>
    dismissButtonStyle?.index;

ModalPresentationStyle? _presentationStyleFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < ModalPresentationStyle.values.length
      ? ModalPresentationStyle.values[value]
      : null;
}

Object? _presentationStyleToJson(ModalPresentationStyle? presentationStyle) =>
    presentationStyle?.index;

ModalTransitionStyle? _transitionStyleFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < ModalTransitionStyle.values.length
      ? ModalTransitionStyle.values[value]
      : null;
}

Object? _transitionStyleToJson(ModalTransitionStyle? transitionStyle) =>
    transitionStyle?.index;

ActivityButton? _activityButtonFromJson(Object? value) => value == null
    ? null
    : ActivityButton.fromJson((value as Map).cast<String, dynamic>());

Object? _activityButtonToJson(ActivityButton? activityButton) =>
    activityButton?.toJson();

UIEventAttribution? _eventAttributionFromJson(Object? value) => value == null
    ? null
    : UIEventAttribution.fromJson((value as Map).cast<String, dynamic>());

Object? _eventAttributionToJson(UIEventAttribution? eventAttribution) =>
    eventAttribution?.toJson();

///The old wire deserialized the polymorphic display mode by its `type` key.
TrustedWebActivityDisplayMode? _displayModeFromJson(Object? value) {
  final displayMode = value as Map<String, dynamic>?;
  if (displayMode == null) {
    return null;
  }
  // The concrete display-mode classes are still codegen; dispatch on the
  // type-key wire to restore the concrete subtype.
  switch (displayMode['type']) {
    case 'IMMERSIVE_MODE':
      return TrustedWebActivityImmersiveDisplayMode.fromMap(displayMode);
    case 'DEFAULT_MODE':
    default:
      return TrustedWebActivityDefaultDisplayMode();
  }
}

Object? _displayModeToJson(TrustedWebActivityDisplayMode? displayMode) =>
    displayMode?.toJson();

List<AndroidResource>? _startAnimationsFromJson(Object? value) {
  if (value is! List) return null;
  return value
      .map((e) => AndroidResource.fromJson((e as Map).cast<String, dynamic>())!)
      .toList();
}

Object? _startAnimationsToJson(List<AndroidResource>? startAnimations) =>
    startAnimations?.map((e) => e.toJson()).toList();

List<AndroidResource>? _exitAnimationsFromJson(Object? value) {
  if (value is! List) return null;
  return value
      .map((e) => AndroidResource.fromJson((e as Map).cast<String, dynamic>())!)
      .toList();
}

Object? _exitAnimationsToJson(List<AndroidResource>? exitAnimations) =>
    exitAnimations?.map((e) => e.toJson()).toList();
