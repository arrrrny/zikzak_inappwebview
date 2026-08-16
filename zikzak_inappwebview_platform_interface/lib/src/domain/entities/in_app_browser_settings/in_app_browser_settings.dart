import 'package:zorphy_annotation/zorphy_annotation.dart';
import 'dart:ui';

import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

import '../in_app_webview_rect/in_app_webview_rect.dart';
import '../enums/modal_presentation_style.dart';
import '../enums/modal_transition_style.dart';
import '../enums/window_style_mask.dart';
import '../enums/window_titlebar_separator_style.dart';
import '../enums/window_type.dart';
import '../../../util.dart';

import '../../../in_app_webview/in_app_webview_settings.dart';

part 'in_app_browser_settings.zorphy.dart';
part 'in_app_browser_settings.g.dart';

///Class that represents the settings that can be used for an [InAppBrowser] instance.
class InAppBrowserClassSettings {
  ///Browser settings.
  late InAppBrowserSettings browserSettings;

  ///WebView settings.
  late InAppWebViewSettings webViewSettings;

  InAppBrowserClassSettings({
    InAppBrowserSettings? browserSettings,
    InAppWebViewSettings? webViewSettings,
  }) {
    this.browserSettings = browserSettings ?? InAppBrowserSettings();
    this.webViewSettings = webViewSettings ?? InAppWebViewSettings();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> settings = {};

    settings.addAll(browserSettings.toJson());
    settings.addAll(webViewSettings.toJson());

    return settings;
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }

  factory InAppBrowserClassSettings.fromMap(
    Map<String, dynamic> settings, {
    InAppBrowserClassSettings? instance,
  }) {
    if (instance == null) {
      instance = InAppBrowserClassSettings();
    }
    instance.browserSettings =
        InAppBrowserSettings.fromJson(settings) ?? InAppBrowserSettings();
    instance.webViewSettings =
        InAppWebViewSettings.fromMap(settings) ?? InAppWebViewSettings();
    return instance;
  }

  InAppBrowserClassSettings copy() {
    return InAppBrowserClassSettings.fromMap(toMap());
  }
}

///This class represents all [InAppBrowser] settings available.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $InAppBrowserSettings {
  ///Set to `true` to create the browser and load the page, but not show it. Omit or set to `false` to have the browser open and load normally.
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get hidden;
  ///Set to `true` to hide the toolbar at the top of the WebView. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get hideToolbarTop;
  ///Set the custom background color of the toolbar at the top.
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get toolbarTopBackgroundColor;
  ///Set to `true` to hide the url bar on the toolbar at the top. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get hideUrlBar;
  ///Set to `true` to hide the progress bar when the WebView is loading a page. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get hideProgressBar;
  ///Set to `true` to hide the default menu items. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get hideDefaultMenuItems;
  ///Set to `true` to set the toolbar at the top translucent. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get toolbarTopTranslucent;
  ///Set the tint color to apply to the navigation bar background.
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get toolbarTopBarTintColor;
  ///Set the tint color to apply to the navigation items and bar button items.
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get toolbarTopTintColor;
  ///Set to `true` to hide the toolbar at the bottom of the WebView. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get hideToolbarBottom;
  ///Set the custom background color of the toolbar at the bottom.
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get toolbarBottomBackgroundColor;
  ///Set the tint color to apply to the bar button items.
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get toolbarBottomTintColor;
  ///Set to `true` to set the toolbar at the bottom translucent. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get toolbarBottomTranslucent;
  ///Set the custom text for the close button.
  String? get closeButtonCaption;
  ///Set the custom color for the close button.
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get closeButtonColor;
  ///Set to `true` to hide the close button. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get hideCloseButton;
  ///Set the custom color for the menu button.
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get menuButtonColor;
  ///Set the custom modal presentation style when presenting the WebView. The default value is [ModalPresentationStyle.FULL_SCREEN].
  @JsonKey(defaultValue: ModalPresentationStyle.FULL_SCREEN, fromJson: _presentationStyleFromJson, toJson: _presentationStyleToJson)
  ModalPresentationStyle? get presentationStyle;
  ///Set to the custom transition style when presenting the WebView. The default value is [ModalTransitionStyle.COVER_VERTICAL].
  @JsonKey(defaultValue: ModalTransitionStyle.COVER_VERTICAL, fromJson: _transitionStyleFromJson, toJson: _transitionStyleToJson)
  ModalTransitionStyle? get transitionStyle;
  ///Set to `true` if you want the title should be displayed. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get hideTitleBar;
  ///Set the action bar's title.
  String? get toolbarTopFixedTitle;
  ///Set to `false` to not close the InAppBrowser when the user click on the Android back button and the WebView cannot go back to the history. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get closeOnCannotGoBack;
  ///Set to `false` to block the InAppBrowser WebView going back when the user click on the Android back button. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get allowGoBackWithBackButton;
  ///Set to `true` to close the InAppBrowser when the user click on the Android back button. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get shouldCloseOnBackButtonPressed;
  ///How the browser window should be added to the main window.
  ///The default value is [WindowType.WINDOW].
  @JsonKey(fromJson: _windowTypeFromJson, toJson: _windowTypeToJson)
  WindowType? get windowType;
  ///The window’s alpha value.
  ///The default value is `1.0`.
  @JsonKey(defaultValue: 1.0)
  double? get windowAlphaValue;
  ///Flags that describe the window’s current style, such as if it’s resizable or in full-screen mode.
  @JsonKey(fromJson: _windowStyleMaskFromJson, toJson: _windowStyleMaskToJson)
  WindowStyleMask? get windowStyleMask;
  ///The type of separator that the app displays between the title bar and content of a window.
  @JsonKey(fromJson: _windowTitlebarSeparatorStyleFromJson, toJson: _windowTitlebarSeparatorStyleToJson)
  WindowTitlebarSeparatorStyle? get windowTitlebarSeparatorStyle;
  ///Sets the origin and size of the window’s frame rectangle according to a given frame rectangle,
  ///thereby setting its position and size onscreen.
  @JsonKey(fromJson: _windowFrameFromJson, toJson: _windowFrameToJson)
  InAppWebViewRect? get windowFrame;
}

Color_? _colorFromJson(Object? value) {
  if (value == null) return null;
  final color = UtilColor.fromStringRepresentation(value as String);
  return color == null ? null : Color_(color.value);
}

Object? _colorToJson(Color_? color) => color?.toHex();

ModalPresentationStyle? _presentationStyleFromJson(Object? value) =>
    modalPresentationStyleFromWire(value);

Object? _presentationStyleToJson(ModalPresentationStyle? value) =>
    modalPresentationStyleToWire(value);

ModalTransitionStyle? _transitionStyleFromJson(Object? value) =>
    modalTransitionStyleFromWire(value);

Object? _transitionStyleToJson(ModalTransitionStyle? value) =>
    modalTransitionStyleToWire(value);

WindowType? _windowTypeFromJson(Object? value) => windowTypeFromWire(value);

Object? _windowTypeToJson(WindowType? value) => windowTypeToWire(value);

WindowStyleMask? _windowStyleMaskFromJson(Object? value) =>
    windowStyleMaskFromWire(value);

Object? _windowStyleMaskToJson(WindowStyleMask? value) =>
    windowStyleMaskToWire(value);

WindowTitlebarSeparatorStyle? _windowTitlebarSeparatorStyleFromJson(
  Object? value,
) =>
    windowTitlebarSeparatorStyleFromWire(value);

Object? _windowTitlebarSeparatorStyleToJson(
  WindowTitlebarSeparatorStyle? value,
) =>
    windowTitlebarSeparatorStyleToWire(value);

InAppWebViewRect? _windowFrameFromJson(Object? value) => value == null
    ? null
    : InAppWebViewRect.fromJson((value as Map).cast<String, dynamic>());

Object? _windowFrameToJson(InAppWebViewRect? value) => value?.toJson();
