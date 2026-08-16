// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chrome_safari_browser_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChromeSafariBrowserSettings _$ChromeSafariBrowserSettingsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ChromeSafariBrowserSettings', json, ($checkedConvert) {
  final val = ChromeSafariBrowserSettings(
    shareState: $checkedConvert('shareState', (v) => _shareStateFromJson(v)),
    showTitle: $checkedConvert('showTitle', (v) => v as bool? ?? true),
    toolbarBackgroundColor: $checkedConvert(
      'toolbarBackgroundColor',
      (v) => _colorFromJson(v),
    ),
    navigationBarColor: $checkedConvert(
      'navigationBarColor',
      (v) => _colorFromJson(v),
    ),
    navigationBarDividerColor: $checkedConvert(
      'navigationBarDividerColor',
      (v) => _colorFromJson(v),
    ),
    secondaryToolbarColor: $checkedConvert(
      'secondaryToolbarColor',
      (v) => _colorFromJson(v),
    ),
    enableUrlBarHiding: $checkedConvert(
      'enableUrlBarHiding',
      (v) => v as bool? ?? false,
    ),
    instantAppsEnabled: $checkedConvert(
      'instantAppsEnabled',
      (v) => v as bool? ?? false,
    ),
    packageName: $checkedConvert('packageName', (v) => v as String?),
    keepAliveEnabled: $checkedConvert(
      'keepAliveEnabled',
      (v) => v as bool? ?? false,
    ),
    isSingleInstance: $checkedConvert(
      'isSingleInstance',
      (v) => v as bool? ?? false,
    ),
    noHistory: $checkedConvert('noHistory', (v) => v as bool? ?? false),
    isTrustedWebActivity: $checkedConvert(
      'isTrustedWebActivity',
      (v) => v as bool? ?? false,
    ),
    additionalTrustedOrigins: $checkedConvert(
      'additionalTrustedOrigins',
      (v) => (v as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    ),
    displayMode: $checkedConvert('displayMode', (v) => _displayModeFromJson(v)),
    screenOrientation: $checkedConvert(
      'screenOrientation',
      (v) => _screenOrientationFromJson(v),
    ),
    startAnimations: $checkedConvert(
      'startAnimations',
      (v) => _startAnimationsFromJson(v),
    ),
    exitAnimations: $checkedConvert(
      'exitAnimations',
      (v) => _exitAnimationsFromJson(v),
    ),
    alwaysUseBrowserUI: $checkedConvert(
      'alwaysUseBrowserUI',
      (v) => v as bool? ?? false,
    ),
    entersReaderIfAvailable: $checkedConvert(
      'entersReaderIfAvailable',
      (v) => v as bool? ?? false,
    ),
    barCollapsingEnabled: $checkedConvert(
      'barCollapsingEnabled',
      (v) => v as bool? ?? false,
    ),
    dismissButtonStyle: $checkedConvert(
      'dismissButtonStyle',
      (v) => _dismissButtonStyleFromJson(v),
    ),
    preferredBarTintColor: $checkedConvert(
      'preferredBarTintColor',
      (v) => _colorFromJson(v),
    ),
    preferredControlTintColor: $checkedConvert(
      'preferredControlTintColor',
      (v) => _colorFromJson(v),
    ),
    presentationStyle: $checkedConvert(
      'presentationStyle',
      (v) => _presentationStyleFromJson(v),
    ),
    transitionStyle: $checkedConvert(
      'transitionStyle',
      (v) => _transitionStyleFromJson(v),
    ),
    activityButton: $checkedConvert(
      'activityButton',
      (v) => _activityButtonFromJson(v),
    ),
    eventAttribution: $checkedConvert(
      'eventAttribution',
      (v) => _eventAttributionFromJson(v),
    ),
  );
  return val;
});

Map<String, dynamic> _$ChromeSafariBrowserSettingsToJson(
  ChromeSafariBrowserSettings instance,
) => <String, dynamic>{
  'shareState': _shareStateToJson(instance.shareState),
  'showTitle': instance.showTitle,
  'toolbarBackgroundColor': _colorToJson(instance.toolbarBackgroundColor),
  'navigationBarColor': _colorToJson(instance.navigationBarColor),
  'navigationBarDividerColor': _colorToJson(instance.navigationBarDividerColor),
  'secondaryToolbarColor': _colorToJson(instance.secondaryToolbarColor),
  'enableUrlBarHiding': instance.enableUrlBarHiding,
  'instantAppsEnabled': instance.instantAppsEnabled,
  'packageName': instance.packageName,
  'keepAliveEnabled': instance.keepAliveEnabled,
  'isSingleInstance': instance.isSingleInstance,
  'noHistory': instance.noHistory,
  'isTrustedWebActivity': instance.isTrustedWebActivity,
  'additionalTrustedOrigins': instance.additionalTrustedOrigins,
  'displayMode': _displayModeToJson(instance.displayMode),
  'screenOrientation': _screenOrientationToJson(instance.screenOrientation),
  'startAnimations': _startAnimationsToJson(instance.startAnimations),
  'exitAnimations': _exitAnimationsToJson(instance.exitAnimations),
  'alwaysUseBrowserUI': instance.alwaysUseBrowserUI,
  'entersReaderIfAvailable': instance.entersReaderIfAvailable,
  'barCollapsingEnabled': instance.barCollapsingEnabled,
  'dismissButtonStyle': _dismissButtonStyleToJson(instance.dismissButtonStyle),
  'preferredBarTintColor': _colorToJson(instance.preferredBarTintColor),
  'preferredControlTintColor': _colorToJson(instance.preferredControlTintColor),
  'presentationStyle': _presentationStyleToJson(instance.presentationStyle),
  'transitionStyle': _transitionStyleToJson(instance.transitionStyle),
  'activityButton': _activityButtonToJson(instance.activityButton),
  'eventAttribution': _eventAttributionToJson(instance.eventAttribution),
};
