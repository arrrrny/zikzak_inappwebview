// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'in_app_browser_settings.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class InAppBrowserSettings {
  InAppBrowserSettings({
    bool? hidden,
    bool? hideToolbarTop,
    Color? this.toolbarTopBackgroundColor,
    bool? hideUrlBar,
    bool? hideProgressBar,
    bool? hideDefaultMenuItems,
    bool? toolbarTopTranslucent,
    Color? this.toolbarTopBarTintColor,
    Color? this.toolbarTopTintColor,
    bool? hideToolbarBottom,
    Color? this.toolbarBottomBackgroundColor,
    Color? this.toolbarBottomTintColor,
    bool? toolbarBottomTranslucent,
    String? this.closeButtonCaption,
    Color? this.closeButtonColor,
    bool? hideCloseButton,
    Color? this.menuButtonColor,
    ModalPresentationStyle? presentationStyle,
    ModalTransitionStyle? transitionStyle,
    bool? hideTitleBar,
    String? this.toolbarTopFixedTitle,
    bool? closeOnCannotGoBack,
    bool? allowGoBackWithBackButton,
    bool? shouldCloseOnBackButtonPressed,
    WindowType? this.windowType,
    double? windowAlphaValue,
    WindowStyleMask? this.windowStyleMask,
    WindowTitlebarSeparatorStyle? this.windowTitlebarSeparatorStyle,
    InAppWebViewRect? this.windowFrame,
  }) : this.hidden = hidden ?? false,
       this.hideToolbarTop = hideToolbarTop ?? false,
       this.hideUrlBar = hideUrlBar ?? false,
       this.hideProgressBar = hideProgressBar ?? false,
       this.hideDefaultMenuItems = hideDefaultMenuItems ?? false,
       this.toolbarTopTranslucent = toolbarTopTranslucent ?? true,
       this.hideToolbarBottom = hideToolbarBottom ?? false,
       this.toolbarBottomTranslucent = toolbarBottomTranslucent ?? true,
       this.hideCloseButton = hideCloseButton ?? false,
       this.presentationStyle =
           presentationStyle ?? ModalPresentationStyle.FULL_SCREEN,
       this.transitionStyle =
           transitionStyle ?? ModalTransitionStyle.COVER_VERTICAL,
       this.hideTitleBar = hideTitleBar ?? false,
       this.closeOnCannotGoBack = closeOnCannotGoBack ?? true,
       this.allowGoBackWithBackButton = allowGoBackWithBackButton ?? true,
       this.shouldCloseOnBackButtonPressed =
           shouldCloseOnBackButtonPressed ?? false,
       this.windowAlphaValue = windowAlphaValue ?? 1.0;

  factory InAppBrowserSettings.fromJson(Map<String, dynamic> json) =>
      _$InAppBrowserSettingsFromJson(json);

  @JsonKey(defaultValue: false)
  final bool? hidden;

  @JsonKey(defaultValue: false)
  final bool? hideToolbarTop;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? toolbarTopBackgroundColor;

  @JsonKey(defaultValue: false)
  final bool? hideUrlBar;

  @JsonKey(defaultValue: false)
  final bool? hideProgressBar;

  @JsonKey(defaultValue: false)
  final bool? hideDefaultMenuItems;

  @JsonKey(defaultValue: true)
  final bool? toolbarTopTranslucent;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? toolbarTopBarTintColor;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? toolbarTopTintColor;

  @JsonKey(defaultValue: false)
  final bool? hideToolbarBottom;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? toolbarBottomBackgroundColor;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? toolbarBottomTintColor;

  @JsonKey(defaultValue: true)
  final bool? toolbarBottomTranslucent;

  final String? closeButtonCaption;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? closeButtonColor;

  @JsonKey(defaultValue: false)
  final bool? hideCloseButton;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? menuButtonColor;

  @JsonKey(
    defaultValue: ModalPresentationStyle.FULL_SCREEN,
    toJson: _presentationStyleToJson,
    fromJson: _presentationStyleFromJson,
  )
  final ModalPresentationStyle? presentationStyle;

  @JsonKey(
    defaultValue: ModalTransitionStyle.COVER_VERTICAL,
    toJson: _transitionStyleToJson,
    fromJson: _transitionStyleFromJson,
  )
  final ModalTransitionStyle? transitionStyle;

  @JsonKey(defaultValue: false)
  final bool? hideTitleBar;

  final String? toolbarTopFixedTitle;

  @JsonKey(defaultValue: true)
  final bool? closeOnCannotGoBack;

  @JsonKey(defaultValue: true)
  final bool? allowGoBackWithBackButton;

  @JsonKey(defaultValue: false)
  final bool? shouldCloseOnBackButtonPressed;

  @JsonKey(toJson: _windowTypeToJson, fromJson: _windowTypeFromJson)
  final WindowType? windowType;

  @JsonKey(defaultValue: 1.0)
  final double? windowAlphaValue;

  @JsonKey(toJson: _windowStyleMaskToJson, fromJson: _windowStyleMaskFromJson)
  final WindowStyleMask? windowStyleMask;

  @JsonKey(
    toJson: _windowTitlebarSeparatorStyleToJson,
    fromJson: _windowTitlebarSeparatorStyleFromJson,
  )
  final WindowTitlebarSeparatorStyle? windowTitlebarSeparatorStyle;

  @JsonKey(toJson: _windowFrameToJson, fromJson: _windowFrameFromJson)
  final InAppWebViewRect? windowFrame;

  InAppBrowserSettings copyWith({
    bool? hidden,
    bool? hideToolbarTop,
    Color? toolbarTopBackgroundColor,
    bool? hideUrlBar,
    bool? hideProgressBar,
    bool? hideDefaultMenuItems,
    bool? toolbarTopTranslucent,
    Color? toolbarTopBarTintColor,
    Color? toolbarTopTintColor,
    bool? hideToolbarBottom,
    Color? toolbarBottomBackgroundColor,
    Color? toolbarBottomTintColor,
    bool? toolbarBottomTranslucent,
    String? closeButtonCaption,
    Color? closeButtonColor,
    bool? hideCloseButton,
    Color? menuButtonColor,
    ModalPresentationStyle? presentationStyle,
    ModalTransitionStyle? transitionStyle,
    bool? hideTitleBar,
    String? toolbarTopFixedTitle,
    bool? closeOnCannotGoBack,
    bool? allowGoBackWithBackButton,
    bool? shouldCloseOnBackButtonPressed,
    WindowType? windowType,
    double? windowAlphaValue,
    WindowStyleMask? windowStyleMask,
    WindowTitlebarSeparatorStyle? windowTitlebarSeparatorStyle,
    InAppWebViewRect? windowFrame,
  }) {
    return InAppBrowserSettings(
      hidden: hidden ?? this.hidden,
      hideToolbarTop: hideToolbarTop ?? this.hideToolbarTop,
      toolbarTopBackgroundColor:
          toolbarTopBackgroundColor ?? this.toolbarTopBackgroundColor,
      hideUrlBar: hideUrlBar ?? this.hideUrlBar,
      hideProgressBar: hideProgressBar ?? this.hideProgressBar,
      hideDefaultMenuItems: hideDefaultMenuItems ?? this.hideDefaultMenuItems,
      toolbarTopTranslucent:
          toolbarTopTranslucent ?? this.toolbarTopTranslucent,
      toolbarTopBarTintColor:
          toolbarTopBarTintColor ?? this.toolbarTopBarTintColor,
      toolbarTopTintColor: toolbarTopTintColor ?? this.toolbarTopTintColor,
      hideToolbarBottom: hideToolbarBottom ?? this.hideToolbarBottom,
      toolbarBottomBackgroundColor:
          toolbarBottomBackgroundColor ?? this.toolbarBottomBackgroundColor,
      toolbarBottomTintColor:
          toolbarBottomTintColor ?? this.toolbarBottomTintColor,
      toolbarBottomTranslucent:
          toolbarBottomTranslucent ?? this.toolbarBottomTranslucent,
      closeButtonCaption: closeButtonCaption ?? this.closeButtonCaption,
      closeButtonColor: closeButtonColor ?? this.closeButtonColor,
      hideCloseButton: hideCloseButton ?? this.hideCloseButton,
      menuButtonColor: menuButtonColor ?? this.menuButtonColor,
      presentationStyle: presentationStyle ?? this.presentationStyle,
      transitionStyle: transitionStyle ?? this.transitionStyle,
      hideTitleBar: hideTitleBar ?? this.hideTitleBar,
      toolbarTopFixedTitle: toolbarTopFixedTitle ?? this.toolbarTopFixedTitle,
      closeOnCannotGoBack: closeOnCannotGoBack ?? this.closeOnCannotGoBack,
      allowGoBackWithBackButton:
          allowGoBackWithBackButton ?? this.allowGoBackWithBackButton,
      shouldCloseOnBackButtonPressed:
          shouldCloseOnBackButtonPressed ?? this.shouldCloseOnBackButtonPressed,
      windowType: windowType ?? this.windowType,
      windowAlphaValue: windowAlphaValue ?? this.windowAlphaValue,
      windowStyleMask: windowStyleMask ?? this.windowStyleMask,
      windowTitlebarSeparatorStyle:
          windowTitlebarSeparatorStyle ?? this.windowTitlebarSeparatorStyle,
      windowFrame: windowFrame ?? this.windowFrame,
    );
  }

  InAppBrowserSettings copyWithInAppBrowserSettings({
    bool? hidden,
    bool? hideToolbarTop,
    Color? toolbarTopBackgroundColor,
    bool? hideUrlBar,
    bool? hideProgressBar,
    bool? hideDefaultMenuItems,
    bool? toolbarTopTranslucent,
    Color? toolbarTopBarTintColor,
    Color? toolbarTopTintColor,
    bool? hideToolbarBottom,
    Color? toolbarBottomBackgroundColor,
    Color? toolbarBottomTintColor,
    bool? toolbarBottomTranslucent,
    String? closeButtonCaption,
    Color? closeButtonColor,
    bool? hideCloseButton,
    Color? menuButtonColor,
    ModalPresentationStyle? presentationStyle,
    ModalTransitionStyle? transitionStyle,
    bool? hideTitleBar,
    String? toolbarTopFixedTitle,
    bool? closeOnCannotGoBack,
    bool? allowGoBackWithBackButton,
    bool? shouldCloseOnBackButtonPressed,
    WindowType? windowType,
    double? windowAlphaValue,
    WindowStyleMask? windowStyleMask,
    WindowTitlebarSeparatorStyle? windowTitlebarSeparatorStyle,
    InAppWebViewRect? windowFrame,
  }) {
    return copyWith(
      hidden: hidden,
      hideToolbarTop: hideToolbarTop,
      toolbarTopBackgroundColor: toolbarTopBackgroundColor,
      hideUrlBar: hideUrlBar,
      hideProgressBar: hideProgressBar,
      hideDefaultMenuItems: hideDefaultMenuItems,
      toolbarTopTranslucent: toolbarTopTranslucent,
      toolbarTopBarTintColor: toolbarTopBarTintColor,
      toolbarTopTintColor: toolbarTopTintColor,
      hideToolbarBottom: hideToolbarBottom,
      toolbarBottomBackgroundColor: toolbarBottomBackgroundColor,
      toolbarBottomTintColor: toolbarBottomTintColor,
      toolbarBottomTranslucent: toolbarBottomTranslucent,
      closeButtonCaption: closeButtonCaption,
      closeButtonColor: closeButtonColor,
      hideCloseButton: hideCloseButton,
      menuButtonColor: menuButtonColor,
      presentationStyle: presentationStyle,
      transitionStyle: transitionStyle,
      hideTitleBar: hideTitleBar,
      toolbarTopFixedTitle: toolbarTopFixedTitle,
      closeOnCannotGoBack: closeOnCannotGoBack,
      allowGoBackWithBackButton: allowGoBackWithBackButton,
      shouldCloseOnBackButtonPressed: shouldCloseOnBackButtonPressed,
      windowType: windowType,
      windowAlphaValue: windowAlphaValue,
      windowStyleMask: windowStyleMask,
      windowTitlebarSeparatorStyle: windowTitlebarSeparatorStyle,
      windowFrame: windowFrame,
    );
  }

  InAppBrowserSettings patchWithInAppBrowserSettings([
    InAppBrowserSettingsPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? InAppBrowserSettingsPatch();
    final _patchMap = _patcher.patchMap;
    return InAppBrowserSettings(
      hidden: _patchMap.containsKey(InAppBrowserSettings$.hidden)
          ? (_patchMap[InAppBrowserSettings$.hidden] is Function)
                ? _patchMap[InAppBrowserSettings$.hidden](this.hidden)
                : (_patchMap[InAppBrowserSettings$.hidden] is Patch)
                ? _patchMap[InAppBrowserSettings$.hidden].applyTo(this.hidden)
                : _patchMap[InAppBrowserSettings$.hidden]
          : this.hidden,
      hideToolbarTop:
          _patchMap.containsKey(InAppBrowserSettings$.hideToolbarTop)
          ? (_patchMap[InAppBrowserSettings$.hideToolbarTop] is Function)
                ? _patchMap[InAppBrowserSettings$.hideToolbarTop](
                    this.hideToolbarTop,
                  )
                : (_patchMap[InAppBrowserSettings$.hideToolbarTop] is Patch)
                ? _patchMap[InAppBrowserSettings$.hideToolbarTop].applyTo(
                    this.hideToolbarTop,
                  )
                : _patchMap[InAppBrowserSettings$.hideToolbarTop]
          : this.hideToolbarTop,
      toolbarTopBackgroundColor:
          _patchMap.containsKey(InAppBrowserSettings$.toolbarTopBackgroundColor)
          ? (_patchMap[InAppBrowserSettings$.toolbarTopBackgroundColor]
                    is Function)
                ? _patchMap[InAppBrowserSettings$.toolbarTopBackgroundColor](
                    this.toolbarTopBackgroundColor,
                  )
                : (_patchMap[InAppBrowserSettings$.toolbarTopBackgroundColor]
                      is Patch)
                ? _patchMap[InAppBrowserSettings$.toolbarTopBackgroundColor]
                      .applyTo(this.toolbarTopBackgroundColor)
                : _patchMap[InAppBrowserSettings$.toolbarTopBackgroundColor]
          : this.toolbarTopBackgroundColor,
      hideUrlBar: _patchMap.containsKey(InAppBrowserSettings$.hideUrlBar)
          ? (_patchMap[InAppBrowserSettings$.hideUrlBar] is Function)
                ? _patchMap[InAppBrowserSettings$.hideUrlBar](this.hideUrlBar)
                : (_patchMap[InAppBrowserSettings$.hideUrlBar] is Patch)
                ? _patchMap[InAppBrowserSettings$.hideUrlBar].applyTo(
                    this.hideUrlBar,
                  )
                : _patchMap[InAppBrowserSettings$.hideUrlBar]
          : this.hideUrlBar,
      hideProgressBar:
          _patchMap.containsKey(InAppBrowserSettings$.hideProgressBar)
          ? (_patchMap[InAppBrowserSettings$.hideProgressBar] is Function)
                ? _patchMap[InAppBrowserSettings$.hideProgressBar](
                    this.hideProgressBar,
                  )
                : (_patchMap[InAppBrowserSettings$.hideProgressBar] is Patch)
                ? _patchMap[InAppBrowserSettings$.hideProgressBar].applyTo(
                    this.hideProgressBar,
                  )
                : _patchMap[InAppBrowserSettings$.hideProgressBar]
          : this.hideProgressBar,
      hideDefaultMenuItems:
          _patchMap.containsKey(InAppBrowserSettings$.hideDefaultMenuItems)
          ? (_patchMap[InAppBrowserSettings$.hideDefaultMenuItems] is Function)
                ? _patchMap[InAppBrowserSettings$.hideDefaultMenuItems](
                    this.hideDefaultMenuItems,
                  )
                : (_patchMap[InAppBrowserSettings$.hideDefaultMenuItems]
                      is Patch)
                ? _patchMap[InAppBrowserSettings$.hideDefaultMenuItems].applyTo(
                    this.hideDefaultMenuItems,
                  )
                : _patchMap[InAppBrowserSettings$.hideDefaultMenuItems]
          : this.hideDefaultMenuItems,
      toolbarTopTranslucent:
          _patchMap.containsKey(InAppBrowserSettings$.toolbarTopTranslucent)
          ? (_patchMap[InAppBrowserSettings$.toolbarTopTranslucent] is Function)
                ? _patchMap[InAppBrowserSettings$.toolbarTopTranslucent](
                    this.toolbarTopTranslucent,
                  )
                : (_patchMap[InAppBrowserSettings$.toolbarTopTranslucent]
                      is Patch)
                ? _patchMap[InAppBrowserSettings$.toolbarTopTranslucent]
                      .applyTo(this.toolbarTopTranslucent)
                : _patchMap[InAppBrowserSettings$.toolbarTopTranslucent]
          : this.toolbarTopTranslucent,
      toolbarTopBarTintColor:
          _patchMap.containsKey(InAppBrowserSettings$.toolbarTopBarTintColor)
          ? (_patchMap[InAppBrowserSettings$.toolbarTopBarTintColor]
                    is Function)
                ? _patchMap[InAppBrowserSettings$.toolbarTopBarTintColor](
                    this.toolbarTopBarTintColor,
                  )
                : (_patchMap[InAppBrowserSettings$.toolbarTopBarTintColor]
                      is Patch)
                ? _patchMap[InAppBrowserSettings$.toolbarTopBarTintColor]
                      .applyTo(this.toolbarTopBarTintColor)
                : _patchMap[InAppBrowserSettings$.toolbarTopBarTintColor]
          : this.toolbarTopBarTintColor,
      toolbarTopTintColor:
          _patchMap.containsKey(InAppBrowserSettings$.toolbarTopTintColor)
          ? (_patchMap[InAppBrowserSettings$.toolbarTopTintColor] is Function)
                ? _patchMap[InAppBrowserSettings$.toolbarTopTintColor](
                    this.toolbarTopTintColor,
                  )
                : (_patchMap[InAppBrowserSettings$.toolbarTopTintColor]
                      is Patch)
                ? _patchMap[InAppBrowserSettings$.toolbarTopTintColor].applyTo(
                    this.toolbarTopTintColor,
                  )
                : _patchMap[InAppBrowserSettings$.toolbarTopTintColor]
          : this.toolbarTopTintColor,
      hideToolbarBottom:
          _patchMap.containsKey(InAppBrowserSettings$.hideToolbarBottom)
          ? (_patchMap[InAppBrowserSettings$.hideToolbarBottom] is Function)
                ? _patchMap[InAppBrowserSettings$.hideToolbarBottom](
                    this.hideToolbarBottom,
                  )
                : (_patchMap[InAppBrowserSettings$.hideToolbarBottom] is Patch)
                ? _patchMap[InAppBrowserSettings$.hideToolbarBottom].applyTo(
                    this.hideToolbarBottom,
                  )
                : _patchMap[InAppBrowserSettings$.hideToolbarBottom]
          : this.hideToolbarBottom,
      toolbarBottomBackgroundColor:
          _patchMap.containsKey(
            InAppBrowserSettings$.toolbarBottomBackgroundColor,
          )
          ? (_patchMap[InAppBrowserSettings$.toolbarBottomBackgroundColor]
                    is Function)
                ? _patchMap[InAppBrowserSettings$.toolbarBottomBackgroundColor](
                    this.toolbarBottomBackgroundColor,
                  )
                : (_patchMap[InAppBrowserSettings$.toolbarBottomBackgroundColor]
                      is Patch)
                ? _patchMap[InAppBrowserSettings$.toolbarBottomBackgroundColor]
                      .applyTo(this.toolbarBottomBackgroundColor)
                : _patchMap[InAppBrowserSettings$.toolbarBottomBackgroundColor]
          : this.toolbarBottomBackgroundColor,
      toolbarBottomTintColor:
          _patchMap.containsKey(InAppBrowserSettings$.toolbarBottomTintColor)
          ? (_patchMap[InAppBrowserSettings$.toolbarBottomTintColor]
                    is Function)
                ? _patchMap[InAppBrowserSettings$.toolbarBottomTintColor](
                    this.toolbarBottomTintColor,
                  )
                : (_patchMap[InAppBrowserSettings$.toolbarBottomTintColor]
                      is Patch)
                ? _patchMap[InAppBrowserSettings$.toolbarBottomTintColor]
                      .applyTo(this.toolbarBottomTintColor)
                : _patchMap[InAppBrowserSettings$.toolbarBottomTintColor]
          : this.toolbarBottomTintColor,
      toolbarBottomTranslucent:
          _patchMap.containsKey(InAppBrowserSettings$.toolbarBottomTranslucent)
          ? (_patchMap[InAppBrowserSettings$.toolbarBottomTranslucent]
                    is Function)
                ? _patchMap[InAppBrowserSettings$.toolbarBottomTranslucent](
                    this.toolbarBottomTranslucent,
                  )
                : (_patchMap[InAppBrowserSettings$.toolbarBottomTranslucent]
                      is Patch)
                ? _patchMap[InAppBrowserSettings$.toolbarBottomTranslucent]
                      .applyTo(this.toolbarBottomTranslucent)
                : _patchMap[InAppBrowserSettings$.toolbarBottomTranslucent]
          : this.toolbarBottomTranslucent,
      closeButtonCaption:
          _patchMap.containsKey(InAppBrowserSettings$.closeButtonCaption)
          ? (_patchMap[InAppBrowserSettings$.closeButtonCaption] is Function)
                ? _patchMap[InAppBrowserSettings$.closeButtonCaption](
                    this.closeButtonCaption,
                  )
                : (_patchMap[InAppBrowserSettings$.closeButtonCaption] is Patch)
                ? _patchMap[InAppBrowserSettings$.closeButtonCaption].applyTo(
                    this.closeButtonCaption,
                  )
                : _patchMap[InAppBrowserSettings$.closeButtonCaption]
          : this.closeButtonCaption,
      closeButtonColor:
          _patchMap.containsKey(InAppBrowserSettings$.closeButtonColor)
          ? (_patchMap[InAppBrowserSettings$.closeButtonColor] is Function)
                ? _patchMap[InAppBrowserSettings$.closeButtonColor](
                    this.closeButtonColor,
                  )
                : (_patchMap[InAppBrowserSettings$.closeButtonColor] is Patch)
                ? _patchMap[InAppBrowserSettings$.closeButtonColor].applyTo(
                    this.closeButtonColor,
                  )
                : _patchMap[InAppBrowserSettings$.closeButtonColor]
          : this.closeButtonColor,
      hideCloseButton:
          _patchMap.containsKey(InAppBrowserSettings$.hideCloseButton)
          ? (_patchMap[InAppBrowserSettings$.hideCloseButton] is Function)
                ? _patchMap[InAppBrowserSettings$.hideCloseButton](
                    this.hideCloseButton,
                  )
                : (_patchMap[InAppBrowserSettings$.hideCloseButton] is Patch)
                ? _patchMap[InAppBrowserSettings$.hideCloseButton].applyTo(
                    this.hideCloseButton,
                  )
                : _patchMap[InAppBrowserSettings$.hideCloseButton]
          : this.hideCloseButton,
      menuButtonColor:
          _patchMap.containsKey(InAppBrowserSettings$.menuButtonColor)
          ? (_patchMap[InAppBrowserSettings$.menuButtonColor] is Function)
                ? _patchMap[InAppBrowserSettings$.menuButtonColor](
                    this.menuButtonColor,
                  )
                : (_patchMap[InAppBrowserSettings$.menuButtonColor] is Patch)
                ? _patchMap[InAppBrowserSettings$.menuButtonColor].applyTo(
                    this.menuButtonColor,
                  )
                : _patchMap[InAppBrowserSettings$.menuButtonColor]
          : this.menuButtonColor,
      presentationStyle:
          _patchMap.containsKey(InAppBrowserSettings$.presentationStyle)
          ? (_patchMap[InAppBrowserSettings$.presentationStyle] is Function)
                ? _patchMap[InAppBrowserSettings$.presentationStyle](
                    this.presentationStyle,
                  )
                : (_patchMap[InAppBrowserSettings$.presentationStyle] is Patch)
                ? _patchMap[InAppBrowserSettings$.presentationStyle].applyTo(
                    this.presentationStyle,
                  )
                : _patchMap[InAppBrowserSettings$.presentationStyle]
          : this.presentationStyle,
      transitionStyle:
          _patchMap.containsKey(InAppBrowserSettings$.transitionStyle)
          ? (_patchMap[InAppBrowserSettings$.transitionStyle] is Function)
                ? _patchMap[InAppBrowserSettings$.transitionStyle](
                    this.transitionStyle,
                  )
                : (_patchMap[InAppBrowserSettings$.transitionStyle] is Patch)
                ? _patchMap[InAppBrowserSettings$.transitionStyle].applyTo(
                    this.transitionStyle,
                  )
                : _patchMap[InAppBrowserSettings$.transitionStyle]
          : this.transitionStyle,
      hideTitleBar: _patchMap.containsKey(InAppBrowserSettings$.hideTitleBar)
          ? (_patchMap[InAppBrowserSettings$.hideTitleBar] is Function)
                ? _patchMap[InAppBrowserSettings$.hideTitleBar](
                    this.hideTitleBar,
                  )
                : (_patchMap[InAppBrowserSettings$.hideTitleBar] is Patch)
                ? _patchMap[InAppBrowserSettings$.hideTitleBar].applyTo(
                    this.hideTitleBar,
                  )
                : _patchMap[InAppBrowserSettings$.hideTitleBar]
          : this.hideTitleBar,
      toolbarTopFixedTitle:
          _patchMap.containsKey(InAppBrowserSettings$.toolbarTopFixedTitle)
          ? (_patchMap[InAppBrowserSettings$.toolbarTopFixedTitle] is Function)
                ? _patchMap[InAppBrowserSettings$.toolbarTopFixedTitle](
                    this.toolbarTopFixedTitle,
                  )
                : (_patchMap[InAppBrowserSettings$.toolbarTopFixedTitle]
                      is Patch)
                ? _patchMap[InAppBrowserSettings$.toolbarTopFixedTitle].applyTo(
                    this.toolbarTopFixedTitle,
                  )
                : _patchMap[InAppBrowserSettings$.toolbarTopFixedTitle]
          : this.toolbarTopFixedTitle,
      closeOnCannotGoBack:
          _patchMap.containsKey(InAppBrowserSettings$.closeOnCannotGoBack)
          ? (_patchMap[InAppBrowserSettings$.closeOnCannotGoBack] is Function)
                ? _patchMap[InAppBrowserSettings$.closeOnCannotGoBack](
                    this.closeOnCannotGoBack,
                  )
                : (_patchMap[InAppBrowserSettings$.closeOnCannotGoBack]
                      is Patch)
                ? _patchMap[InAppBrowserSettings$.closeOnCannotGoBack].applyTo(
                    this.closeOnCannotGoBack,
                  )
                : _patchMap[InAppBrowserSettings$.closeOnCannotGoBack]
          : this.closeOnCannotGoBack,
      allowGoBackWithBackButton:
          _patchMap.containsKey(InAppBrowserSettings$.allowGoBackWithBackButton)
          ? (_patchMap[InAppBrowserSettings$.allowGoBackWithBackButton]
                    is Function)
                ? _patchMap[InAppBrowserSettings$.allowGoBackWithBackButton](
                    this.allowGoBackWithBackButton,
                  )
                : (_patchMap[InAppBrowserSettings$.allowGoBackWithBackButton]
                      is Patch)
                ? _patchMap[InAppBrowserSettings$.allowGoBackWithBackButton]
                      .applyTo(this.allowGoBackWithBackButton)
                : _patchMap[InAppBrowserSettings$.allowGoBackWithBackButton]
          : this.allowGoBackWithBackButton,
      shouldCloseOnBackButtonPressed:
          _patchMap.containsKey(
            InAppBrowserSettings$.shouldCloseOnBackButtonPressed,
          )
          ? (_patchMap[InAppBrowserSettings$.shouldCloseOnBackButtonPressed]
                    is Function)
                ? _patchMap[InAppBrowserSettings$
                      .shouldCloseOnBackButtonPressed](
                    this.shouldCloseOnBackButtonPressed,
                  )
                : (_patchMap[InAppBrowserSettings$
                          .shouldCloseOnBackButtonPressed]
                      is Patch)
                ? _patchMap[InAppBrowserSettings$
                          .shouldCloseOnBackButtonPressed]
                      .applyTo(this.shouldCloseOnBackButtonPressed)
                : _patchMap[InAppBrowserSettings$
                      .shouldCloseOnBackButtonPressed]
          : this.shouldCloseOnBackButtonPressed,
      windowType: _patchMap.containsKey(InAppBrowserSettings$.windowType)
          ? (_patchMap[InAppBrowserSettings$.windowType] is Function)
                ? _patchMap[InAppBrowserSettings$.windowType](this.windowType)
                : (_patchMap[InAppBrowserSettings$.windowType] is Patch)
                ? _patchMap[InAppBrowserSettings$.windowType].applyTo(
                    this.windowType,
                  )
                : _patchMap[InAppBrowserSettings$.windowType]
          : this.windowType,
      windowAlphaValue:
          _patchMap.containsKey(InAppBrowserSettings$.windowAlphaValue)
          ? (_patchMap[InAppBrowserSettings$.windowAlphaValue] is Function)
                ? _patchMap[InAppBrowserSettings$.windowAlphaValue](
                    this.windowAlphaValue,
                  )
                : (_patchMap[InAppBrowserSettings$.windowAlphaValue] is Patch)
                ? _patchMap[InAppBrowserSettings$.windowAlphaValue].applyTo(
                    this.windowAlphaValue,
                  )
                : _patchMap[InAppBrowserSettings$.windowAlphaValue]
          : this.windowAlphaValue,
      windowStyleMask:
          _patchMap.containsKey(InAppBrowserSettings$.windowStyleMask)
          ? (_patchMap[InAppBrowserSettings$.windowStyleMask] is Function)
                ? _patchMap[InAppBrowserSettings$.windowStyleMask](
                    this.windowStyleMask,
                  )
                : (_patchMap[InAppBrowserSettings$.windowStyleMask] is Patch)
                ? _patchMap[InAppBrowserSettings$.windowStyleMask].applyTo(
                    this.windowStyleMask,
                  )
                : _patchMap[InAppBrowserSettings$.windowStyleMask]
          : this.windowStyleMask,
      windowTitlebarSeparatorStyle:
          _patchMap.containsKey(
            InAppBrowserSettings$.windowTitlebarSeparatorStyle,
          )
          ? (_patchMap[InAppBrowserSettings$.windowTitlebarSeparatorStyle]
                    is Function)
                ? _patchMap[InAppBrowserSettings$.windowTitlebarSeparatorStyle](
                    this.windowTitlebarSeparatorStyle,
                  )
                : (_patchMap[InAppBrowserSettings$.windowTitlebarSeparatorStyle]
                      is Patch)
                ? _patchMap[InAppBrowserSettings$.windowTitlebarSeparatorStyle]
                      .applyTo(this.windowTitlebarSeparatorStyle)
                : _patchMap[InAppBrowserSettings$.windowTitlebarSeparatorStyle]
          : this.windowTitlebarSeparatorStyle,
      windowFrame: _patchMap.containsKey(InAppBrowserSettings$.windowFrame)
          ? (_patchMap[InAppBrowserSettings$.windowFrame] is Function)
                ? _patchMap[InAppBrowserSettings$.windowFrame](this.windowFrame)
                : (_patchMap[InAppBrowserSettings$.windowFrame] is Patch)
                ? _patchMap[InAppBrowserSettings$.windowFrame].applyTo(
                    this.windowFrame,
                  )
                : _patchMap[InAppBrowserSettings$.windowFrame]
          : this.windowFrame,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InAppBrowserSettings &&
        hidden == other.hidden &&
        hideToolbarTop == other.hideToolbarTop &&
        toolbarTopBackgroundColor == other.toolbarTopBackgroundColor &&
        hideUrlBar == other.hideUrlBar &&
        hideProgressBar == other.hideProgressBar &&
        hideDefaultMenuItems == other.hideDefaultMenuItems &&
        toolbarTopTranslucent == other.toolbarTopTranslucent &&
        toolbarTopBarTintColor == other.toolbarTopBarTintColor &&
        toolbarTopTintColor == other.toolbarTopTintColor &&
        hideToolbarBottom == other.hideToolbarBottom &&
        toolbarBottomBackgroundColor == other.toolbarBottomBackgroundColor &&
        toolbarBottomTintColor == other.toolbarBottomTintColor &&
        toolbarBottomTranslucent == other.toolbarBottomTranslucent &&
        closeButtonCaption == other.closeButtonCaption &&
        closeButtonColor == other.closeButtonColor &&
        hideCloseButton == other.hideCloseButton &&
        menuButtonColor == other.menuButtonColor &&
        presentationStyle == other.presentationStyle &&
        transitionStyle == other.transitionStyle &&
        hideTitleBar == other.hideTitleBar &&
        toolbarTopFixedTitle == other.toolbarTopFixedTitle &&
        closeOnCannotGoBack == other.closeOnCannotGoBack &&
        allowGoBackWithBackButton == other.allowGoBackWithBackButton &&
        shouldCloseOnBackButtonPressed ==
            other.shouldCloseOnBackButtonPressed &&
        windowType == other.windowType &&
        windowAlphaValue == other.windowAlphaValue &&
        windowStyleMask == other.windowStyleMask &&
        windowTitlebarSeparatorStyle == other.windowTitlebarSeparatorStyle &&
        windowFrame == other.windowFrame;
  }

  @override
  int get hashCode {
    return Object.hash(
          this.hidden,
          this.hideToolbarTop,
          this.toolbarTopBackgroundColor,
          this.hideUrlBar,
          this.hideProgressBar,
          this.hideDefaultMenuItems,
          this.toolbarTopTranslucent,
          this.toolbarTopBarTintColor,
          this.toolbarTopTintColor,
          this.hideToolbarBottom,
          this.toolbarBottomBackgroundColor,
          this.toolbarBottomTintColor,
          this.toolbarBottomTranslucent,
          this.closeButtonCaption,
          this.closeButtonColor,
          this.hideCloseButton,
          this.menuButtonColor,
          this.presentationStyle,
          this.transitionStyle,
          this.hideTitleBar,
        ) ^
        Object.hash(
          this.toolbarTopFixedTitle,
          this.closeOnCannotGoBack,
          this.allowGoBackWithBackButton,
          this.shouldCloseOnBackButtonPressed,
          this.windowType,
          this.windowAlphaValue,
          this.windowStyleMask,
          this.windowTitlebarSeparatorStyle,
          this.windowFrame,
        );
  }

  @override
  String toString() {
    return 'InAppBrowserSettings(' +
        'hidden: ${hidden}' +
        ', ' +
        'hideToolbarTop: ${hideToolbarTop}' +
        ', ' +
        'toolbarTopBackgroundColor: ${toolbarTopBackgroundColor}' +
        ', ' +
        'hideUrlBar: ${hideUrlBar}' +
        ', ' +
        'hideProgressBar: ${hideProgressBar}' +
        ', ' +
        'hideDefaultMenuItems: ${hideDefaultMenuItems}' +
        ', ' +
        'toolbarTopTranslucent: ${toolbarTopTranslucent}' +
        ', ' +
        'toolbarTopBarTintColor: ${toolbarTopBarTintColor}' +
        ', ' +
        'toolbarTopTintColor: ${toolbarTopTintColor}' +
        ', ' +
        'hideToolbarBottom: ${hideToolbarBottom}' +
        ', ' +
        'toolbarBottomBackgroundColor: ${toolbarBottomBackgroundColor}' +
        ', ' +
        'toolbarBottomTintColor: ${toolbarBottomTintColor}' +
        ', ' +
        'toolbarBottomTranslucent: ${toolbarBottomTranslucent}' +
        ', ' +
        'closeButtonCaption: ${closeButtonCaption}' +
        ', ' +
        'closeButtonColor: ${closeButtonColor}' +
        ', ' +
        'hideCloseButton: ${hideCloseButton}' +
        ', ' +
        'menuButtonColor: ${menuButtonColor}' +
        ', ' +
        'presentationStyle: ${presentationStyle}' +
        ', ' +
        'transitionStyle: ${transitionStyle}' +
        ', ' +
        'hideTitleBar: ${hideTitleBar}' +
        ', ' +
        'toolbarTopFixedTitle: ${toolbarTopFixedTitle}' +
        ', ' +
        'closeOnCannotGoBack: ${closeOnCannotGoBack}' +
        ', ' +
        'allowGoBackWithBackButton: ${allowGoBackWithBackButton}' +
        ', ' +
        'shouldCloseOnBackButtonPressed: ${shouldCloseOnBackButtonPressed}' +
        ', ' +
        'windowType: ${windowType}' +
        ', ' +
        'windowAlphaValue: ${windowAlphaValue}' +
        ', ' +
        'windowStyleMask: ${windowStyleMask}' +
        ', ' +
        'windowTitlebarSeparatorStyle: ${windowTitlebarSeparatorStyle}' +
        ', ' +
        'windowFrame: ${windowFrame})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$InAppBrowserSettingsToJson(this);
    return _sanitizeJson(data);
  }

  dynamic _sanitizeJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      json.remove('__typename');
      return json..forEach((key, value) {
        json[key] = _sanitizeJson(value);
      });
    } else if (json is List) {
      return json.map((e) => _sanitizeJson(e)).toList();
    }
    return json;
  }
}

extension InAppBrowserSettingsPropertyHelpers on InAppBrowserSettings {
  bool get hasHidden {
    return this.hidden != null;
  }

  bool get noHidden {
    return this.hidden == null;
  }

  bool get hiddenRequired {
    return this.hidden ?? (throw StateError('hidden is required but was null'));
  }

  bool get hasHideToolbarTop {
    return this.hideToolbarTop != null;
  }

  bool get noHideToolbarTop {
    return this.hideToolbarTop == null;
  }

  bool get hideToolbarTopRequired {
    return this.hideToolbarTop ??
        (throw StateError('hideToolbarTop is required but was null'));
  }

  bool get hasToolbarTopBackgroundColor {
    return this.toolbarTopBackgroundColor != null;
  }

  bool get noToolbarTopBackgroundColor {
    return this.toolbarTopBackgroundColor == null;
  }

  Color get toolbarTopBackgroundColorRequired {
    return this.toolbarTopBackgroundColor ??
        (throw StateError(
          'toolbarTopBackgroundColor is required but was null',
        ));
  }

  bool get hasHideUrlBar {
    return this.hideUrlBar != null;
  }

  bool get noHideUrlBar {
    return this.hideUrlBar == null;
  }

  bool get hideUrlBarRequired {
    return this.hideUrlBar ??
        (throw StateError('hideUrlBar is required but was null'));
  }

  bool get hasHideProgressBar {
    return this.hideProgressBar != null;
  }

  bool get noHideProgressBar {
    return this.hideProgressBar == null;
  }

  bool get hideProgressBarRequired {
    return this.hideProgressBar ??
        (throw StateError('hideProgressBar is required but was null'));
  }

  bool get hasHideDefaultMenuItems {
    return this.hideDefaultMenuItems != null;
  }

  bool get noHideDefaultMenuItems {
    return this.hideDefaultMenuItems == null;
  }

  bool get hideDefaultMenuItemsRequired {
    return this.hideDefaultMenuItems ??
        (throw StateError('hideDefaultMenuItems is required but was null'));
  }

  bool get hasToolbarTopTranslucent {
    return this.toolbarTopTranslucent != null;
  }

  bool get noToolbarTopTranslucent {
    return this.toolbarTopTranslucent == null;
  }

  bool get toolbarTopTranslucentRequired {
    return this.toolbarTopTranslucent ??
        (throw StateError('toolbarTopTranslucent is required but was null'));
  }

  bool get hasToolbarTopBarTintColor {
    return this.toolbarTopBarTintColor != null;
  }

  bool get noToolbarTopBarTintColor {
    return this.toolbarTopBarTintColor == null;
  }

  Color get toolbarTopBarTintColorRequired {
    return this.toolbarTopBarTintColor ??
        (throw StateError('toolbarTopBarTintColor is required but was null'));
  }

  bool get hasToolbarTopTintColor {
    return this.toolbarTopTintColor != null;
  }

  bool get noToolbarTopTintColor {
    return this.toolbarTopTintColor == null;
  }

  Color get toolbarTopTintColorRequired {
    return this.toolbarTopTintColor ??
        (throw StateError('toolbarTopTintColor is required but was null'));
  }

  bool get hasHideToolbarBottom {
    return this.hideToolbarBottom != null;
  }

  bool get noHideToolbarBottom {
    return this.hideToolbarBottom == null;
  }

  bool get hideToolbarBottomRequired {
    return this.hideToolbarBottom ??
        (throw StateError('hideToolbarBottom is required but was null'));
  }

  bool get hasToolbarBottomBackgroundColor {
    return this.toolbarBottomBackgroundColor != null;
  }

  bool get noToolbarBottomBackgroundColor {
    return this.toolbarBottomBackgroundColor == null;
  }

  Color get toolbarBottomBackgroundColorRequired {
    return this.toolbarBottomBackgroundColor ??
        (throw StateError(
          'toolbarBottomBackgroundColor is required but was null',
        ));
  }

  bool get hasToolbarBottomTintColor {
    return this.toolbarBottomTintColor != null;
  }

  bool get noToolbarBottomTintColor {
    return this.toolbarBottomTintColor == null;
  }

  Color get toolbarBottomTintColorRequired {
    return this.toolbarBottomTintColor ??
        (throw StateError('toolbarBottomTintColor is required but was null'));
  }

  bool get hasToolbarBottomTranslucent {
    return this.toolbarBottomTranslucent != null;
  }

  bool get noToolbarBottomTranslucent {
    return this.toolbarBottomTranslucent == null;
  }

  bool get toolbarBottomTranslucentRequired {
    return this.toolbarBottomTranslucent ??
        (throw StateError('toolbarBottomTranslucent is required but was null'));
  }

  bool get hasCloseButtonCaption {
    return this.closeButtonCaption?.isNotEmpty == true;
  }

  bool get noCloseButtonCaption {
    return this.closeButtonCaption?.isEmpty ?? true;
  }

  String get closeButtonCaptionRequired {
    return this.closeButtonCaption ??
        (throw StateError('closeButtonCaption is required but was null'));
  }

  bool get hasCloseButtonColor {
    return this.closeButtonColor != null;
  }

  bool get noCloseButtonColor {
    return this.closeButtonColor == null;
  }

  Color get closeButtonColorRequired {
    return this.closeButtonColor ??
        (throw StateError('closeButtonColor is required but was null'));
  }

  bool get hasHideCloseButton {
    return this.hideCloseButton != null;
  }

  bool get noHideCloseButton {
    return this.hideCloseButton == null;
  }

  bool get hideCloseButtonRequired {
    return this.hideCloseButton ??
        (throw StateError('hideCloseButton is required but was null'));
  }

  bool get hasMenuButtonColor {
    return this.menuButtonColor != null;
  }

  bool get noMenuButtonColor {
    return this.menuButtonColor == null;
  }

  Color get menuButtonColorRequired {
    return this.menuButtonColor ??
        (throw StateError('menuButtonColor is required but was null'));
  }

  bool get hasPresentationStyle {
    return this.presentationStyle != null;
  }

  bool get noPresentationStyle {
    return this.presentationStyle == null;
  }

  ModalPresentationStyle get presentationStyleRequired {
    return this.presentationStyle ??
        (throw StateError('presentationStyle is required but was null'));
  }

  bool get isPresentationStyleFULL_SCREEN {
    return this.presentationStyle == ModalPresentationStyle.FULL_SCREEN;
  }

  bool get isPresentationStylePAGE_SHEET {
    return this.presentationStyle == ModalPresentationStyle.PAGE_SHEET;
  }

  bool get isPresentationStyleFORM_SHEET {
    return this.presentationStyle == ModalPresentationStyle.FORM_SHEET;
  }

  bool get isPresentationStyleCURRENT_CONTEXT {
    return this.presentationStyle == ModalPresentationStyle.CURRENT_CONTEXT;
  }

  bool get isPresentationStyleCUSTOM {
    return this.presentationStyle == ModalPresentationStyle.CUSTOM;
  }

  bool get isPresentationStyleOVER_FULL_SCREEN {
    return this.presentationStyle == ModalPresentationStyle.OVER_FULL_SCREEN;
  }

  bool get isPresentationStyleOVER_CURRENT_CONTEXT {
    return this.presentationStyle ==
        ModalPresentationStyle.OVER_CURRENT_CONTEXT;
  }

  bool get isPresentationStylePOPOVER {
    return this.presentationStyle == ModalPresentationStyle.POPOVER;
  }

  bool get isPresentationStyleNONE {
    return this.presentationStyle == ModalPresentationStyle.NONE;
  }

  bool get isPresentationStyleAUTOMATIC {
    return this.presentationStyle == ModalPresentationStyle.AUTOMATIC;
  }

  bool get hasTransitionStyle {
    return this.transitionStyle != null;
  }

  bool get noTransitionStyle {
    return this.transitionStyle == null;
  }

  ModalTransitionStyle get transitionStyleRequired {
    return this.transitionStyle ??
        (throw StateError('transitionStyle is required but was null'));
  }

  bool get isTransitionStyleCOVER_VERTICAL {
    return this.transitionStyle == ModalTransitionStyle.COVER_VERTICAL;
  }

  bool get isTransitionStyleFLIP_HORIZONTAL {
    return this.transitionStyle == ModalTransitionStyle.FLIP_HORIZONTAL;
  }

  bool get isTransitionStyleCROSS_DISSOLVE {
    return this.transitionStyle == ModalTransitionStyle.CROSS_DISSOLVE;
  }

  bool get isTransitionStylePARTIAL_CURL {
    return this.transitionStyle == ModalTransitionStyle.PARTIAL_CURL;
  }

  bool get hasHideTitleBar {
    return this.hideTitleBar != null;
  }

  bool get noHideTitleBar {
    return this.hideTitleBar == null;
  }

  bool get hideTitleBarRequired {
    return this.hideTitleBar ??
        (throw StateError('hideTitleBar is required but was null'));
  }

  bool get hasToolbarTopFixedTitle {
    return this.toolbarTopFixedTitle?.isNotEmpty == true;
  }

  bool get noToolbarTopFixedTitle {
    return this.toolbarTopFixedTitle?.isEmpty ?? true;
  }

  String get toolbarTopFixedTitleRequired {
    return this.toolbarTopFixedTitle ??
        (throw StateError('toolbarTopFixedTitle is required but was null'));
  }

  bool get hasCloseOnCannotGoBack {
    return this.closeOnCannotGoBack != null;
  }

  bool get noCloseOnCannotGoBack {
    return this.closeOnCannotGoBack == null;
  }

  bool get closeOnCannotGoBackRequired {
    return this.closeOnCannotGoBack ??
        (throw StateError('closeOnCannotGoBack is required but was null'));
  }

  bool get hasAllowGoBackWithBackButton {
    return this.allowGoBackWithBackButton != null;
  }

  bool get noAllowGoBackWithBackButton {
    return this.allowGoBackWithBackButton == null;
  }

  bool get allowGoBackWithBackButtonRequired {
    return this.allowGoBackWithBackButton ??
        (throw StateError(
          'allowGoBackWithBackButton is required but was null',
        ));
  }

  bool get hasShouldCloseOnBackButtonPressed {
    return this.shouldCloseOnBackButtonPressed != null;
  }

  bool get noShouldCloseOnBackButtonPressed {
    return this.shouldCloseOnBackButtonPressed == null;
  }

  bool get shouldCloseOnBackButtonPressedRequired {
    return this.shouldCloseOnBackButtonPressed ??
        (throw StateError(
          'shouldCloseOnBackButtonPressed is required but was null',
        ));
  }

  bool get hasWindowType {
    return this.windowType != null;
  }

  bool get noWindowType {
    return this.windowType == null;
  }

  WindowType get windowTypeRequired {
    return this.windowType ??
        (throw StateError('windowType is required but was null'));
  }

  bool get isWindowTypeWINDOW {
    return this.windowType == WindowType.WINDOW;
  }

  bool get isWindowTypeCHILD {
    return this.windowType == WindowType.CHILD;
  }

  bool get isWindowTypeTABBED {
    return this.windowType == WindowType.TABBED;
  }

  bool get hasWindowAlphaValue {
    return this.windowAlphaValue != null;
  }

  bool get noWindowAlphaValue {
    return this.windowAlphaValue == null;
  }

  double get windowAlphaValueRequired {
    return this.windowAlphaValue ??
        (throw StateError('windowAlphaValue is required but was null'));
  }

  bool get hasWindowStyleMask {
    return this.windowStyleMask != null;
  }

  bool get noWindowStyleMask {
    return this.windowStyleMask == null;
  }

  WindowStyleMask get windowStyleMaskRequired {
    return this.windowStyleMask ??
        (throw StateError('windowStyleMask is required but was null'));
  }

  bool get isWindowStyleMaskBORDERLESS {
    return this.windowStyleMask == WindowStyleMask.BORDERLESS;
  }

  bool get isWindowStyleMaskTITLED {
    return this.windowStyleMask == WindowStyleMask.TITLED;
  }

  bool get isWindowStyleMaskCLOSABLE {
    return this.windowStyleMask == WindowStyleMask.CLOSABLE;
  }

  bool get isWindowStyleMaskMINIATURIZABLE {
    return this.windowStyleMask == WindowStyleMask.MINIATURIZABLE;
  }

  bool get isWindowStyleMaskRESIZABLE {
    return this.windowStyleMask == WindowStyleMask.RESIZABLE;
  }

  bool get isWindowStyleMaskFULLSCREEN {
    return this.windowStyleMask == WindowStyleMask.FULLSCREEN;
  }

  bool get isWindowStyleMaskFULL_SIZE_CONTENT_VIEW {
    return this.windowStyleMask == WindowStyleMask.FULL_SIZE_CONTENT_VIEW;
  }

  bool get isWindowStyleMaskUTILITY_WINDOW {
    return this.windowStyleMask == WindowStyleMask.UTILITY_WINDOW;
  }

  bool get isWindowStyleMaskDOC_MODAL_WINDOW {
    return this.windowStyleMask == WindowStyleMask.DOC_MODAL_WINDOW;
  }

  bool get isWindowStyleMaskNONACTIVATING_PANEL {
    return this.windowStyleMask == WindowStyleMask.NONACTIVATING_PANEL;
  }

  bool get isWindowStyleMaskHUD_WINDOW {
    return this.windowStyleMask == WindowStyleMask.HUD_WINDOW;
  }

  bool get hasWindowTitlebarSeparatorStyle {
    return this.windowTitlebarSeparatorStyle != null;
  }

  bool get noWindowTitlebarSeparatorStyle {
    return this.windowTitlebarSeparatorStyle == null;
  }

  WindowTitlebarSeparatorStyle get windowTitlebarSeparatorStyleRequired {
    return this.windowTitlebarSeparatorStyle ??
        (throw StateError(
          'windowTitlebarSeparatorStyle is required but was null',
        ));
  }

  bool get isWindowTitlebarSeparatorStyleAUTOMATIC {
    return this.windowTitlebarSeparatorStyle ==
        WindowTitlebarSeparatorStyle.AUTOMATIC;
  }

  bool get isWindowTitlebarSeparatorStyleNONE {
    return this.windowTitlebarSeparatorStyle ==
        WindowTitlebarSeparatorStyle.NONE;
  }

  bool get isWindowTitlebarSeparatorStyleLINE {
    return this.windowTitlebarSeparatorStyle ==
        WindowTitlebarSeparatorStyle.LINE;
  }

  bool get isWindowTitlebarSeparatorStyleSHADOW {
    return this.windowTitlebarSeparatorStyle ==
        WindowTitlebarSeparatorStyle.SHADOW;
  }

  bool get hasWindowFrame {
    return this.windowFrame != null;
  }

  bool get noWindowFrame {
    return this.windowFrame == null;
  }

  InAppWebViewRect get windowFrameRequired {
    return this.windowFrame ??
        (throw StateError('windowFrame is required but was null'));
  }
}

extension InAppBrowserSettingsSerialization on InAppBrowserSettings {
  Map<String, dynamic> toJson() {
    return _$InAppBrowserSettingsToJson(this);
  }
}

enum InAppBrowserSettings$ {
  hidden,
  hideToolbarTop,
  toolbarTopBackgroundColor,
  hideUrlBar,
  hideProgressBar,
  hideDefaultMenuItems,
  toolbarTopTranslucent,
  toolbarTopBarTintColor,
  toolbarTopTintColor,
  hideToolbarBottom,
  toolbarBottomBackgroundColor,
  toolbarBottomTintColor,
  toolbarBottomTranslucent,
  closeButtonCaption,
  closeButtonColor,
  hideCloseButton,
  menuButtonColor,
  presentationStyle,
  transitionStyle,
  hideTitleBar,
  toolbarTopFixedTitle,
  closeOnCannotGoBack,
  allowGoBackWithBackButton,
  shouldCloseOnBackButtonPressed,
  windowType,
  windowAlphaValue,
  windowStyleMask,
  windowTitlebarSeparatorStyle,
  windowFrame,
}

class InAppBrowserSettingsPatch
    extends PatchBase<InAppBrowserSettings, InAppBrowserSettings$> {
  InAppBrowserSettings applyTo(InAppBrowserSettings entity) {
    return entity.patchWithInAppBrowserSettings(this);
  }

  InAppBrowserSettingsPatch withHidden(bool? value) {
    patchMap[InAppBrowserSettings$.hidden] = value;
    return this;
  }

  InAppBrowserSettingsPatch withHideToolbarTop(bool? value) {
    patchMap[InAppBrowserSettings$.hideToolbarTop] = value;
    return this;
  }

  InAppBrowserSettingsPatch withToolbarTopBackgroundColor(Color? value) {
    patchMap[InAppBrowserSettings$.toolbarTopBackgroundColor] = value;
    return this;
  }

  InAppBrowserSettingsPatch withHideUrlBar(bool? value) {
    patchMap[InAppBrowserSettings$.hideUrlBar] = value;
    return this;
  }

  InAppBrowserSettingsPatch withHideProgressBar(bool? value) {
    patchMap[InAppBrowserSettings$.hideProgressBar] = value;
    return this;
  }

  InAppBrowserSettingsPatch withHideDefaultMenuItems(bool? value) {
    patchMap[InAppBrowserSettings$.hideDefaultMenuItems] = value;
    return this;
  }

  InAppBrowserSettingsPatch withToolbarTopTranslucent(bool? value) {
    patchMap[InAppBrowserSettings$.toolbarTopTranslucent] = value;
    return this;
  }

  InAppBrowserSettingsPatch withToolbarTopBarTintColor(Color? value) {
    patchMap[InAppBrowserSettings$.toolbarTopBarTintColor] = value;
    return this;
  }

  InAppBrowserSettingsPatch withToolbarTopTintColor(Color? value) {
    patchMap[InAppBrowserSettings$.toolbarTopTintColor] = value;
    return this;
  }

  InAppBrowserSettingsPatch withHideToolbarBottom(bool? value) {
    patchMap[InAppBrowserSettings$.hideToolbarBottom] = value;
    return this;
  }

  InAppBrowserSettingsPatch withToolbarBottomBackgroundColor(Color? value) {
    patchMap[InAppBrowserSettings$.toolbarBottomBackgroundColor] = value;
    return this;
  }

  InAppBrowserSettingsPatch withToolbarBottomTintColor(Color? value) {
    patchMap[InAppBrowserSettings$.toolbarBottomTintColor] = value;
    return this;
  }

  InAppBrowserSettingsPatch withToolbarBottomTranslucent(bool? value) {
    patchMap[InAppBrowserSettings$.toolbarBottomTranslucent] = value;
    return this;
  }

  InAppBrowserSettingsPatch withCloseButtonCaption(String? value) {
    patchMap[InAppBrowserSettings$.closeButtonCaption] = value;
    return this;
  }

  InAppBrowserSettingsPatch withCloseButtonColor(Color? value) {
    patchMap[InAppBrowserSettings$.closeButtonColor] = value;
    return this;
  }

  InAppBrowserSettingsPatch withHideCloseButton(bool? value) {
    patchMap[InAppBrowserSettings$.hideCloseButton] = value;
    return this;
  }

  InAppBrowserSettingsPatch withMenuButtonColor(Color? value) {
    patchMap[InAppBrowserSettings$.menuButtonColor] = value;
    return this;
  }

  InAppBrowserSettingsPatch withPresentationStyle(
    ModalPresentationStyle? value,
  ) {
    patchMap[InAppBrowserSettings$.presentationStyle] = value;
    return this;
  }

  InAppBrowserSettingsPatch withTransitionStyle(ModalTransitionStyle? value) {
    patchMap[InAppBrowserSettings$.transitionStyle] = value;
    return this;
  }

  InAppBrowserSettingsPatch withHideTitleBar(bool? value) {
    patchMap[InAppBrowserSettings$.hideTitleBar] = value;
    return this;
  }

  InAppBrowserSettingsPatch withToolbarTopFixedTitle(String? value) {
    patchMap[InAppBrowserSettings$.toolbarTopFixedTitle] = value;
    return this;
  }

  InAppBrowserSettingsPatch withCloseOnCannotGoBack(bool? value) {
    patchMap[InAppBrowserSettings$.closeOnCannotGoBack] = value;
    return this;
  }

  InAppBrowserSettingsPatch withAllowGoBackWithBackButton(bool? value) {
    patchMap[InAppBrowserSettings$.allowGoBackWithBackButton] = value;
    return this;
  }

  InAppBrowserSettingsPatch withShouldCloseOnBackButtonPressed(bool? value) {
    patchMap[InAppBrowserSettings$.shouldCloseOnBackButtonPressed] = value;
    return this;
  }

  InAppBrowserSettingsPatch withWindowType(WindowType? value) {
    patchMap[InAppBrowserSettings$.windowType] = value;
    return this;
  }

  InAppBrowserSettingsPatch withWindowAlphaValue(double? value) {
    patchMap[InAppBrowserSettings$.windowAlphaValue] = value;
    return this;
  }

  InAppBrowserSettingsPatch withWindowStyleMask(WindowStyleMask? value) {
    patchMap[InAppBrowserSettings$.windowStyleMask] = value;
    return this;
  }

  InAppBrowserSettingsPatch withWindowTitlebarSeparatorStyle(
    WindowTitlebarSeparatorStyle? value,
  ) {
    patchMap[InAppBrowserSettings$.windowTitlebarSeparatorStyle] = value;
    return this;
  }

  InAppBrowserSettingsPatch withWindowFrame(InAppWebViewRect? value) {
    patchMap[InAppBrowserSettings$.windowFrame] = value;
    return this;
  }

  InAppBrowserSettingsPatch withWindowFramePatch(InAppWebViewRectPatch patch) {
    patchMap[InAppBrowserSettings$.windowFrame] = patch;
    return this;
  }

  InAppBrowserSettingsPatch withWindowFramePatchFunc(
    InAppWebViewRectPatch Function(InAppWebViewRectPatch) patch,
  ) {
    patchMap[InAppBrowserSettings$.windowFrame] = (dynamic current) {
      var currentPatch = InAppWebViewRectPatch();
      return patch(currentPatch).applyTo(current as InAppWebViewRect);
    };
    return this;
  }
}

/// Field descriptors for [InAppBrowserSettings] query construction
abstract final class InAppBrowserSettingsFields {
  static const hidden = Field<InAppBrowserSettings, bool?>('hidden', _$hidden);

  static const hideToolbarTop = Field<InAppBrowserSettings, bool?>(
    'hideToolbarTop',
    _$hideToolbarTop,
  );

  static const toolbarTopBackgroundColor = Field<InAppBrowserSettings, Color?>(
    'toolbarTopBackgroundColor',
    _$toolbarTopBackgroundColor,
  );

  static const hideUrlBar = Field<InAppBrowserSettings, bool?>(
    'hideUrlBar',
    _$hideUrlBar,
  );

  static const hideProgressBar = Field<InAppBrowserSettings, bool?>(
    'hideProgressBar',
    _$hideProgressBar,
  );

  static const hideDefaultMenuItems = Field<InAppBrowserSettings, bool?>(
    'hideDefaultMenuItems',
    _$hideDefaultMenuItems,
  );

  static const toolbarTopTranslucent = Field<InAppBrowserSettings, bool?>(
    'toolbarTopTranslucent',
    _$toolbarTopTranslucent,
  );

  static const toolbarTopBarTintColor = Field<InAppBrowserSettings, Color?>(
    'toolbarTopBarTintColor',
    _$toolbarTopBarTintColor,
  );

  static const toolbarTopTintColor = Field<InAppBrowserSettings, Color?>(
    'toolbarTopTintColor',
    _$toolbarTopTintColor,
  );

  static const hideToolbarBottom = Field<InAppBrowserSettings, bool?>(
    'hideToolbarBottom',
    _$hideToolbarBottom,
  );

  static const toolbarBottomBackgroundColor =
      Field<InAppBrowserSettings, Color?>(
        'toolbarBottomBackgroundColor',
        _$toolbarBottomBackgroundColor,
      );

  static const toolbarBottomTintColor = Field<InAppBrowserSettings, Color?>(
    'toolbarBottomTintColor',
    _$toolbarBottomTintColor,
  );

  static const toolbarBottomTranslucent = Field<InAppBrowserSettings, bool?>(
    'toolbarBottomTranslucent',
    _$toolbarBottomTranslucent,
  );

  static const closeButtonCaption = Field<InAppBrowserSettings, String?>(
    'closeButtonCaption',
    _$closeButtonCaption,
  );

  static const closeButtonColor = Field<InAppBrowserSettings, Color?>(
    'closeButtonColor',
    _$closeButtonColor,
  );

  static const hideCloseButton = Field<InAppBrowserSettings, bool?>(
    'hideCloseButton',
    _$hideCloseButton,
  );

  static const menuButtonColor = Field<InAppBrowserSettings, Color?>(
    'menuButtonColor',
    _$menuButtonColor,
  );

  static const presentationStyle =
      Field<InAppBrowserSettings, ModalPresentationStyle?>(
        'presentationStyle',
        _$presentationStyle,
      );

  static const transitionStyle =
      Field<InAppBrowserSettings, ModalTransitionStyle?>(
        'transitionStyle',
        _$transitionStyle,
      );

  static const hideTitleBar = Field<InAppBrowserSettings, bool?>(
    'hideTitleBar',
    _$hideTitleBar,
  );

  static const toolbarTopFixedTitle = Field<InAppBrowserSettings, String?>(
    'toolbarTopFixedTitle',
    _$toolbarTopFixedTitle,
  );

  static const closeOnCannotGoBack = Field<InAppBrowserSettings, bool?>(
    'closeOnCannotGoBack',
    _$closeOnCannotGoBack,
  );

  static const allowGoBackWithBackButton = Field<InAppBrowserSettings, bool?>(
    'allowGoBackWithBackButton',
    _$allowGoBackWithBackButton,
  );

  static const shouldCloseOnBackButtonPressed =
      Field<InAppBrowserSettings, bool?>(
        'shouldCloseOnBackButtonPressed',
        _$shouldCloseOnBackButtonPressed,
      );

  static const windowType = Field<InAppBrowserSettings, WindowType?>(
    'windowType',
    _$windowType,
  );

  static const windowAlphaValue = Field<InAppBrowserSettings, double?>(
    'windowAlphaValue',
    _$windowAlphaValue,
  );

  static const windowStyleMask = Field<InAppBrowserSettings, WindowStyleMask?>(
    'windowStyleMask',
    _$windowStyleMask,
  );

  static const windowTitlebarSeparatorStyle =
      Field<InAppBrowserSettings, WindowTitlebarSeparatorStyle?>(
        'windowTitlebarSeparatorStyle',
        _$windowTitlebarSeparatorStyle,
      );

  static const windowFrame = Field<InAppBrowserSettings, InAppWebViewRect?>(
    'windowFrame',
    _$windowFrame,
  );

  static bool? _$hidden(InAppBrowserSettings e) {
    return e.hidden;
  }

  static bool? _$hideToolbarTop(InAppBrowserSettings e) {
    return e.hideToolbarTop;
  }

  static Color? _$toolbarTopBackgroundColor(InAppBrowserSettings e) {
    return e.toolbarTopBackgroundColor;
  }

  static bool? _$hideUrlBar(InAppBrowserSettings e) {
    return e.hideUrlBar;
  }

  static bool? _$hideProgressBar(InAppBrowserSettings e) {
    return e.hideProgressBar;
  }

  static bool? _$hideDefaultMenuItems(InAppBrowserSettings e) {
    return e.hideDefaultMenuItems;
  }

  static bool? _$toolbarTopTranslucent(InAppBrowserSettings e) {
    return e.toolbarTopTranslucent;
  }

  static Color? _$toolbarTopBarTintColor(InAppBrowserSettings e) {
    return e.toolbarTopBarTintColor;
  }

  static Color? _$toolbarTopTintColor(InAppBrowserSettings e) {
    return e.toolbarTopTintColor;
  }

  static bool? _$hideToolbarBottom(InAppBrowserSettings e) {
    return e.hideToolbarBottom;
  }

  static Color? _$toolbarBottomBackgroundColor(InAppBrowserSettings e) {
    return e.toolbarBottomBackgroundColor;
  }

  static Color? _$toolbarBottomTintColor(InAppBrowserSettings e) {
    return e.toolbarBottomTintColor;
  }

  static bool? _$toolbarBottomTranslucent(InAppBrowserSettings e) {
    return e.toolbarBottomTranslucent;
  }

  static String? _$closeButtonCaption(InAppBrowserSettings e) {
    return e.closeButtonCaption;
  }

  static Color? _$closeButtonColor(InAppBrowserSettings e) {
    return e.closeButtonColor;
  }

  static bool? _$hideCloseButton(InAppBrowserSettings e) {
    return e.hideCloseButton;
  }

  static Color? _$menuButtonColor(InAppBrowserSettings e) {
    return e.menuButtonColor;
  }

  static ModalPresentationStyle? _$presentationStyle(InAppBrowserSettings e) {
    return e.presentationStyle;
  }

  static ModalTransitionStyle? _$transitionStyle(InAppBrowserSettings e) {
    return e.transitionStyle;
  }

  static bool? _$hideTitleBar(InAppBrowserSettings e) {
    return e.hideTitleBar;
  }

  static String? _$toolbarTopFixedTitle(InAppBrowserSettings e) {
    return e.toolbarTopFixedTitle;
  }

  static bool? _$closeOnCannotGoBack(InAppBrowserSettings e) {
    return e.closeOnCannotGoBack;
  }

  static bool? _$allowGoBackWithBackButton(InAppBrowserSettings e) {
    return e.allowGoBackWithBackButton;
  }

  static bool? _$shouldCloseOnBackButtonPressed(InAppBrowserSettings e) {
    return e.shouldCloseOnBackButtonPressed;
  }

  static WindowType? _$windowType(InAppBrowserSettings e) {
    return e.windowType;
  }

  static double? _$windowAlphaValue(InAppBrowserSettings e) {
    return e.windowAlphaValue;
  }

  static WindowStyleMask? _$windowStyleMask(InAppBrowserSettings e) {
    return e.windowStyleMask;
  }

  static WindowTitlebarSeparatorStyle? _$windowTitlebarSeparatorStyle(
    InAppBrowserSettings e,
  ) {
    return e.windowTitlebarSeparatorStyle;
  }

  static InAppWebViewRect? _$windowFrame(InAppBrowserSettings e) {
    return e.windowFrame;
  }
}

extension InAppBrowserSettingsCompareE on InAppBrowserSettings {
  Map<String, dynamic> compareToInAppBrowserSettings(
    InAppBrowserSettings other,
  ) {
    final Map<String, dynamic> diff = {};

    if (hidden != other.hidden) {
      diff['hidden'] = () => other.hidden;
    }

    if (hideToolbarTop != other.hideToolbarTop) {
      diff['hideToolbarTop'] = () => other.hideToolbarTop;
    }

    if (toolbarTopBackgroundColor != other.toolbarTopBackgroundColor) {
      diff['toolbarTopBackgroundColor'] = () => other.toolbarTopBackgroundColor;
    }

    if (hideUrlBar != other.hideUrlBar) {
      diff['hideUrlBar'] = () => other.hideUrlBar;
    }

    if (hideProgressBar != other.hideProgressBar) {
      diff['hideProgressBar'] = () => other.hideProgressBar;
    }

    if (hideDefaultMenuItems != other.hideDefaultMenuItems) {
      diff['hideDefaultMenuItems'] = () => other.hideDefaultMenuItems;
    }

    if (toolbarTopTranslucent != other.toolbarTopTranslucent) {
      diff['toolbarTopTranslucent'] = () => other.toolbarTopTranslucent;
    }

    if (toolbarTopBarTintColor != other.toolbarTopBarTintColor) {
      diff['toolbarTopBarTintColor'] = () => other.toolbarTopBarTintColor;
    }

    if (toolbarTopTintColor != other.toolbarTopTintColor) {
      diff['toolbarTopTintColor'] = () => other.toolbarTopTintColor;
    }

    if (hideToolbarBottom != other.hideToolbarBottom) {
      diff['hideToolbarBottom'] = () => other.hideToolbarBottom;
    }

    if (toolbarBottomBackgroundColor != other.toolbarBottomBackgroundColor) {
      diff['toolbarBottomBackgroundColor'] = () =>
          other.toolbarBottomBackgroundColor;
    }

    if (toolbarBottomTintColor != other.toolbarBottomTintColor) {
      diff['toolbarBottomTintColor'] = () => other.toolbarBottomTintColor;
    }

    if (toolbarBottomTranslucent != other.toolbarBottomTranslucent) {
      diff['toolbarBottomTranslucent'] = () => other.toolbarBottomTranslucent;
    }

    if (closeButtonCaption != other.closeButtonCaption) {
      diff['closeButtonCaption'] = () => other.closeButtonCaption;
    }

    if (closeButtonColor != other.closeButtonColor) {
      diff['closeButtonColor'] = () => other.closeButtonColor;
    }

    if (hideCloseButton != other.hideCloseButton) {
      diff['hideCloseButton'] = () => other.hideCloseButton;
    }

    if (menuButtonColor != other.menuButtonColor) {
      diff['menuButtonColor'] = () => other.menuButtonColor;
    }

    if (presentationStyle != other.presentationStyle) {
      diff['presentationStyle'] = () => other.presentationStyle;
    }

    if (transitionStyle != other.transitionStyle) {
      diff['transitionStyle'] = () => other.transitionStyle;
    }

    if (hideTitleBar != other.hideTitleBar) {
      diff['hideTitleBar'] = () => other.hideTitleBar;
    }

    if (toolbarTopFixedTitle != other.toolbarTopFixedTitle) {
      diff['toolbarTopFixedTitle'] = () => other.toolbarTopFixedTitle;
    }

    if (closeOnCannotGoBack != other.closeOnCannotGoBack) {
      diff['closeOnCannotGoBack'] = () => other.closeOnCannotGoBack;
    }

    if (allowGoBackWithBackButton != other.allowGoBackWithBackButton) {
      diff['allowGoBackWithBackButton'] = () => other.allowGoBackWithBackButton;
    }

    if (shouldCloseOnBackButtonPressed !=
        other.shouldCloseOnBackButtonPressed) {
      diff['shouldCloseOnBackButtonPressed'] = () =>
          other.shouldCloseOnBackButtonPressed;
    }

    if (windowType != other.windowType) {
      diff['windowType'] = () => other.windowType;
    }

    if (windowAlphaValue != other.windowAlphaValue) {
      diff['windowAlphaValue'] = () => other.windowAlphaValue;
    }

    if (windowStyleMask != other.windowStyleMask) {
      diff['windowStyleMask'] = () => other.windowStyleMask;
    }

    if (windowTitlebarSeparatorStyle != other.windowTitlebarSeparatorStyle) {
      diff['windowTitlebarSeparatorStyle'] = () =>
          other.windowTitlebarSeparatorStyle;
    }

    if (windowFrame != other.windowFrame) {
      diff['windowFrame'] = () => other.windowFrame;
    }
    return diff;
  }
}
