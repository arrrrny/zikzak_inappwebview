// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_browser_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InAppBrowserSettings _$InAppBrowserSettingsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('InAppBrowserSettings', json, ($checkedConvert) {
  final val = InAppBrowserSettings(
    hidden: $checkedConvert('hidden', (v) => v as bool? ?? false),
    hideToolbarTop: $checkedConvert(
      'hideToolbarTop',
      (v) => v as bool? ?? false,
    ),
    toolbarTopBackgroundColor: $checkedConvert(
      'toolbarTopBackgroundColor',
      (v) => _colorFromJson(v),
    ),
    hideUrlBar: $checkedConvert('hideUrlBar', (v) => v as bool? ?? false),
    hideProgressBar: $checkedConvert(
      'hideProgressBar',
      (v) => v as bool? ?? false,
    ),
    hideDefaultMenuItems: $checkedConvert(
      'hideDefaultMenuItems',
      (v) => v as bool? ?? false,
    ),
    toolbarTopTranslucent: $checkedConvert(
      'toolbarTopTranslucent',
      (v) => v as bool? ?? true,
    ),
    toolbarTopBarTintColor: $checkedConvert(
      'toolbarTopBarTintColor',
      (v) => _colorFromJson(v),
    ),
    toolbarTopTintColor: $checkedConvert(
      'toolbarTopTintColor',
      (v) => _colorFromJson(v),
    ),
    hideToolbarBottom: $checkedConvert(
      'hideToolbarBottom',
      (v) => v as bool? ?? false,
    ),
    toolbarBottomBackgroundColor: $checkedConvert(
      'toolbarBottomBackgroundColor',
      (v) => _colorFromJson(v),
    ),
    toolbarBottomTintColor: $checkedConvert(
      'toolbarBottomTintColor',
      (v) => _colorFromJson(v),
    ),
    toolbarBottomTranslucent: $checkedConvert(
      'toolbarBottomTranslucent',
      (v) => v as bool? ?? true,
    ),
    closeButtonCaption: $checkedConvert(
      'closeButtonCaption',
      (v) => v as String?,
    ),
    closeButtonColor: $checkedConvert(
      'closeButtonColor',
      (v) => _colorFromJson(v),
    ),
    hideCloseButton: $checkedConvert(
      'hideCloseButton',
      (v) => v as bool? ?? false,
    ),
    menuButtonColor: $checkedConvert(
      'menuButtonColor',
      (v) => _colorFromJson(v),
    ),
    presentationStyle: $checkedConvert(
      'presentationStyle',
      (v) => v == null
          ? ModalPresentationStyle.FULL_SCREEN
          : _presentationStyleFromJson(v),
    ),
    transitionStyle: $checkedConvert(
      'transitionStyle',
      (v) => v == null
          ? ModalTransitionStyle.COVER_VERTICAL
          : _transitionStyleFromJson(v),
    ),
    hideTitleBar: $checkedConvert('hideTitleBar', (v) => v as bool? ?? false),
    toolbarTopFixedTitle: $checkedConvert(
      'toolbarTopFixedTitle',
      (v) => v as String?,
    ),
    closeOnCannotGoBack: $checkedConvert(
      'closeOnCannotGoBack',
      (v) => v as bool? ?? true,
    ),
    allowGoBackWithBackButton: $checkedConvert(
      'allowGoBackWithBackButton',
      (v) => v as bool? ?? true,
    ),
    shouldCloseOnBackButtonPressed: $checkedConvert(
      'shouldCloseOnBackButtonPressed',
      (v) => v as bool? ?? false,
    ),
    windowType: $checkedConvert('windowType', (v) => _windowTypeFromJson(v)),
    windowAlphaValue: $checkedConvert(
      'windowAlphaValue',
      (v) => (v as num?)?.toDouble() ?? 1.0,
    ),
    windowStyleMask: $checkedConvert(
      'windowStyleMask',
      (v) => _windowStyleMaskFromJson(v),
    ),
    windowTitlebarSeparatorStyle: $checkedConvert(
      'windowTitlebarSeparatorStyle',
      (v) => _windowTitlebarSeparatorStyleFromJson(v),
    ),
    windowFrame: $checkedConvert('windowFrame', (v) => _windowFrameFromJson(v)),
  );
  return val;
});

Map<String, dynamic> _$InAppBrowserSettingsToJson(
  InAppBrowserSettings instance,
) => <String, dynamic>{
  'hidden': instance.hidden,
  'hideToolbarTop': instance.hideToolbarTop,
  'toolbarTopBackgroundColor': _colorToJson(instance.toolbarTopBackgroundColor),
  'hideUrlBar': instance.hideUrlBar,
  'hideProgressBar': instance.hideProgressBar,
  'hideDefaultMenuItems': instance.hideDefaultMenuItems,
  'toolbarTopTranslucent': instance.toolbarTopTranslucent,
  'toolbarTopBarTintColor': _colorToJson(instance.toolbarTopBarTintColor),
  'toolbarTopTintColor': _colorToJson(instance.toolbarTopTintColor),
  'hideToolbarBottom': instance.hideToolbarBottom,
  'toolbarBottomBackgroundColor': _colorToJson(
    instance.toolbarBottomBackgroundColor,
  ),
  'toolbarBottomTintColor': _colorToJson(instance.toolbarBottomTintColor),
  'toolbarBottomTranslucent': instance.toolbarBottomTranslucent,
  'closeButtonCaption': instance.closeButtonCaption,
  'closeButtonColor': _colorToJson(instance.closeButtonColor),
  'hideCloseButton': instance.hideCloseButton,
  'menuButtonColor': _colorToJson(instance.menuButtonColor),
  'presentationStyle': _presentationStyleToJson(instance.presentationStyle),
  'transitionStyle': _transitionStyleToJson(instance.transitionStyle),
  'hideTitleBar': instance.hideTitleBar,
  'toolbarTopFixedTitle': instance.toolbarTopFixedTitle,
  'closeOnCannotGoBack': instance.closeOnCannotGoBack,
  'allowGoBackWithBackButton': instance.allowGoBackWithBackButton,
  'shouldCloseOnBackButtonPressed': instance.shouldCloseOnBackButtonPressed,
  'windowType': _windowTypeToJson(instance.windowType),
  'windowAlphaValue': instance.windowAlphaValue,
  'windowStyleMask': _windowStyleMaskToJson(instance.windowStyleMask),
  'windowTitlebarSeparatorStyle': _windowTitlebarSeparatorStyleToJson(
    instance.windowTitlebarSeparatorStyle,
  ),
  'windowFrame': _windowFrameToJson(instance.windowFrame),
};
