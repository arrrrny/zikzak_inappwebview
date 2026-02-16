import 'dart:ui';

import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

import '../types/in_app_webview_rect.dart';
import '../types/modal_presentation_style.dart';
import '../types/modal_transition_style.dart';
import '../types/window_style_mask.dart';
import '../types/window_titlebar_separator_style.dart';
import '../types/window_type.dart';
import '../util.dart';

import '../in_app_webview/in_app_webview_settings.dart';

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

    settings.addAll(browserSettings.toMap());
    settings.addAll(webViewSettings.toMap());

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
        InAppBrowserSettings.fromMap(settings) ?? InAppBrowserSettings();
    instance.webViewSettings =
        InAppWebViewSettings.fromMap(settings) ?? InAppWebViewSettings();
    return instance;
  }

  InAppBrowserClassSettings copy() {
    return InAppBrowserClassSettings.fromMap(toMap());
  }
}

///This class represents all [InAppBrowser] settings available.
@ExchangeableObject(copyMethod: true)
class InAppBrowserSettings_ {
  ///Set to `true` to create the browser and load the page, but not show it. Omit or set to `false` to have the browser open and load normally.
  ///The default value is `false`.
  @SupportedPlatforms(
    platforms: [
      AndroidPlatform(),
      IOSPlatform(),
      MacOSPlatform(),
      WindowsPlatform(),
    ],
  )
  bool? hidden;

  ///Set to `true` to hide the toolbar at the top of the WebView. The default value is `false`.
  @SupportedPlatforms(
    platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()],
  )
  bool? hideToolbarTop;

  ///Set the custom background color of the toolbar at the top.
  @SupportedPlatforms(
    platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()],
  )
  Color_? toolbarTopBackgroundColor;

  ///Set to `true` to hide the url bar on the toolbar at the top. The default value is `false`.
  @SupportedPlatforms(
    platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()],
  )
  bool? hideUrlBar;

  ///Set to `true` to hide the progress bar when the WebView is loading a page. The default value is `false`.
  @SupportedPlatforms(
    platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()],
  )
  bool? hideProgressBar;

  ///Set to `true` to hide the default menu items. The default value is `false`.
  @SupportedPlatforms(
    platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()],
  )
  bool? hideDefaultMenuItems;

  ///Set to `true` if you want the title should be displayed. The default value is `false`.
  @SupportedPlatforms(platforms: [AndroidPlatform()])
  bool? hideTitleBar;

  ///Set the action bar's title.
  @SupportedPlatforms(
    platforms: [AndroidPlatform(), MacOSPlatform(), WindowsPlatform()],
  )
  String? toolbarTopFixedTitle;

  ///Set to `false` to not close the InAppBrowser when the user click on the Android back button and the WebView cannot go back to the history. The default value is `true`.
  @SupportedPlatforms(platforms: [AndroidPlatform()])
  bool? closeOnCannotGoBack;

  ///Set to `false` to block the InAppBrowser WebView going back when the user click on the Android back button. The default value is `true`.
  @SupportedPlatforms(platforms: [AndroidPlatform()])
  bool? allowGoBackWithBackButton;

  ///Set to `true` to close the InAppBrowser when the user click on the Android back button. The default value is `false`.
  @SupportedPlatforms(platforms: [AndroidPlatform()])
  bool? shouldCloseOnBackButtonPressed;

  ///Set to `true` to set the toolbar at the top translucent. The default value is `true`.
  @SupportedPlatforms(platforms: [IOSPlatform()])
  bool? toolbarTopTranslucent;

  ///Set the tint color to apply to the navigation bar background.
  @SupportedPlatforms(platforms: [IOSPlatform()])
  Color_? toolbarTopBarTintColor;

  ///Set the tint color to apply to the navigation items and bar button items.
  @SupportedPlatforms(platforms: [IOSPlatform()])
  Color_? toolbarTopTintColor;

  ///Set to `true` to hide the toolbar at the bottom of the WebView. The default value is `false`.
  @SupportedPlatforms(platforms: [IOSPlatform()])
  bool? hideToolbarBottom;

  ///Set the custom background color of the toolbar at the bottom.
  @SupportedPlatforms(platforms: [IOSPlatform()])
  Color_? toolbarBottomBackgroundColor;

  ///Set the tint color to apply to the bar button items.
  @SupportedPlatforms(platforms: [IOSPlatform()])
  Color_? toolbarBottomTintColor;

  ///Set to `true` to set the toolbar at the bottom translucent. The default value is `true`.
  @SupportedPlatforms(platforms: [IOSPlatform()])
  bool? toolbarBottomTranslucent;

  ///Set the custom text for the close button.
  @SupportedPlatforms(platforms: [IOSPlatform()])
  String? closeButtonCaption;

  ///Set the custom color for the close button.
  @SupportedPlatforms(platforms: [IOSPlatform()])
  Color_? closeButtonColor;

  ///Set to `true` to hide the close button. The default value is `false`.
  @SupportedPlatforms(platforms: [IOSPlatform()])
  bool? hideCloseButton;

  ///Set the custom color for the menu button.
  @SupportedPlatforms(platforms: [IOSPlatform()])
  Color_? menuButtonColor;

  ///Set the custom modal presentation style when presenting the WebView. The default value is [ModalPresentationStyle.FULL_SCREEN].
  @SupportedPlatforms(platforms: [IOSPlatform()])
  ModalPresentationStyle_? presentationStyle;

  ///Set to the custom transition style when presenting the WebView. The default value is [ModalTransitionStyle.COVER_VERTICAL].
  @SupportedPlatforms(platforms: [IOSPlatform()])
  ModalTransitionStyle_? transitionStyle;

  ///How the browser window should be added to the main window.
  ///The default value is [WindowType.WINDOW].
  @SupportedPlatforms(platforms: [MacOSPlatform(), WindowsPlatform()])
  WindowType_? windowType;

  ///The window’s alpha value.
  ///The default value is `1.0`.
  @SupportedPlatforms(platforms: [MacOSPlatform(), WindowsPlatform()])
  double? windowAlphaValue;

  ///Flags that describe the window’s current style, such as if it’s resizable or in full-screen mode.
  @SupportedPlatforms(platforms: [MacOSPlatform()])
  WindowStyleMask_? windowStyleMask;

  ///The type of separator that the app displays between the title bar and content of a window.
  @SupportedPlatforms(platforms: [MacOSPlatform(available: '11.0')])
  WindowTitlebarSeparatorStyle_? windowTitlebarSeparatorStyle;

  ///Sets the origin and size of the window’s frame rectangle according to a given frame rectangle,
  ///thereby setting its position and size onscreen.
  @SupportedPlatforms(platforms: [MacOSPlatform(), WindowsPlatform()])
  InAppWebViewRect_? windowFrame;

  InAppBrowserSettings_({
    this.hidden = false,
    this.hideToolbarTop = false,
    this.toolbarTopBackgroundColor,
    this.hideUrlBar = false,
    this.hideProgressBar = false,
    this.hideDefaultMenuItems = false,
    this.toolbarTopTranslucent = true,
    this.toolbarTopTintColor,
    this.hideToolbarBottom = false,
    this.toolbarBottomBackgroundColor,
    this.toolbarBottomTintColor,
    this.toolbarBottomTranslucent = true,
    this.closeButtonCaption,
    this.closeButtonColor,
    this.hideCloseButton = false,
    this.menuButtonColor,
    this.presentationStyle = ModalPresentationStyle_.FULL_SCREEN,
    this.transitionStyle = ModalTransitionStyle_.COVER_VERTICAL,
    this.hideTitleBar = false,
    this.toolbarTopFixedTitle,
    this.closeOnCannotGoBack = true,
    this.allowGoBackWithBackButton = true,
    this.shouldCloseOnBackButtonPressed = false,
    this.windowType,
    this.windowAlphaValue = 1.0,
    this.windowStyleMask,
    this.windowTitlebarSeparatorStyle,
    this.windowFrame,
  });
}
