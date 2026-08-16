// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'chrome_safari_browser_settings.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class ChromeSafariBrowserSettings {
  ChromeSafariBrowserSettings({
    CustomTabsShareState? shareState,
    bool? showTitle,
    Color_? this.toolbarBackgroundColor,
    Color_? this.navigationBarColor,
    Color_? this.navigationBarDividerColor,
    Color_? this.secondaryToolbarColor,
    bool? enableUrlBarHiding,
    bool? instantAppsEnabled,
    String? this.packageName,
    bool? keepAliveEnabled,
    bool? isSingleInstance,
    bool? noHistory,
    bool? isTrustedWebActivity,
    List<String>? additionalTrustedOrigins,
    TrustedWebActivityDisplayMode? this.displayMode,
    TrustedWebActivityScreenOrientation? screenOrientation,
    List<AndroidResource>? this.startAnimations,
    List<AndroidResource>? this.exitAnimations,
    bool? alwaysUseBrowserUI,
    bool? entersReaderIfAvailable,
    bool? barCollapsingEnabled,
    DismissButtonStyle? dismissButtonStyle,
    Color_? this.preferredBarTintColor,
    Color_? this.preferredControlTintColor,
    ModalPresentationStyle? presentationStyle,
    ModalTransitionStyle? transitionStyle,
    ActivityButton? this.activityButton,
    UIEventAttribution? this.eventAttribution,
  }) : this.shareState = shareState ?? CustomTabsShareState.SHARE_STATE_DEFAULT,
       this.showTitle = showTitle ?? true,
       this.enableUrlBarHiding = enableUrlBarHiding ?? false,
       this.instantAppsEnabled = instantAppsEnabled ?? false,
       this.keepAliveEnabled = keepAliveEnabled ?? false,
       this.isSingleInstance = isSingleInstance ?? false,
       this.noHistory = noHistory ?? false,
       this.isTrustedWebActivity = isTrustedWebActivity ?? false,
       this.additionalTrustedOrigins = additionalTrustedOrigins ?? const [],
       this.screenOrientation =
           screenOrientation ?? TrustedWebActivityScreenOrientation.DEFAULT,
       this.alwaysUseBrowserUI = alwaysUseBrowserUI ?? false,
       this.entersReaderIfAvailable = entersReaderIfAvailable ?? false,
       this.barCollapsingEnabled = barCollapsingEnabled ?? false,
       this.dismissButtonStyle = dismissButtonStyle ?? DismissButtonStyle.DONE,
       this.presentationStyle =
           presentationStyle ?? ModalPresentationStyle.FULL_SCREEN,
       this.transitionStyle =
           transitionStyle ?? ModalTransitionStyle.COVER_VERTICAL;

  factory ChromeSafariBrowserSettings.fromJson(Map<String, dynamic> json) =>
      _$ChromeSafariBrowserSettingsFromJson(json);

  @JsonKey(
    defaultValue: CustomTabsShareState.SHARE_STATE_DEFAULT,
    toJson: _shareStateToJson,
    fromJson: _shareStateFromJson,
  )
  final CustomTabsShareState? shareState;

  @JsonKey(defaultValue: true)
  final bool? showTitle;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color_? toolbarBackgroundColor;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color_? navigationBarColor;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color_? navigationBarDividerColor;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color_? secondaryToolbarColor;

  @JsonKey(defaultValue: false)
  final bool? enableUrlBarHiding;

  @JsonKey(defaultValue: false)
  final bool? instantAppsEnabled;

  final String? packageName;

  @JsonKey(defaultValue: false)
  final bool? keepAliveEnabled;

  @JsonKey(defaultValue: false)
  final bool? isSingleInstance;

  @JsonKey(defaultValue: false)
  final bool? noHistory;

  @JsonKey(defaultValue: false)
  final bool? isTrustedWebActivity;

  @JsonKey(defaultValue: const [])
  final List<String>? additionalTrustedOrigins;

  @JsonKey(toJson: _displayModeToJson, fromJson: _displayModeFromJson)
  final TrustedWebActivityDisplayMode? displayMode;

  @JsonKey(
    defaultValue: TrustedWebActivityScreenOrientation.DEFAULT,
    toJson: _screenOrientationToJson,
    fromJson: _screenOrientationFromJson,
  )
  final TrustedWebActivityScreenOrientation? screenOrientation;

  @JsonKey(toJson: _startAnimationsToJson, fromJson: _startAnimationsFromJson)
  final List<AndroidResource>? startAnimations;

  @JsonKey(toJson: _exitAnimationsToJson, fromJson: _exitAnimationsFromJson)
  final List<AndroidResource>? exitAnimations;

  @JsonKey(defaultValue: false)
  final bool? alwaysUseBrowserUI;

  @JsonKey(defaultValue: false)
  final bool? entersReaderIfAvailable;

  @JsonKey(defaultValue: false)
  final bool? barCollapsingEnabled;

  @JsonKey(
    defaultValue: DismissButtonStyle.DONE,
    toJson: _dismissButtonStyleToJson,
    fromJson: _dismissButtonStyleFromJson,
  )
  final DismissButtonStyle? dismissButtonStyle;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color_? preferredBarTintColor;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color_? preferredControlTintColor;

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

  @JsonKey(toJson: _activityButtonToJson, fromJson: _activityButtonFromJson)
  final ActivityButton? activityButton;

  @JsonKey(toJson: _eventAttributionToJson, fromJson: _eventAttributionFromJson)
  final UIEventAttribution? eventAttribution;

  ChromeSafariBrowserSettings copyWith({
    CustomTabsShareState? shareState,
    bool? showTitle,
    Color_? toolbarBackgroundColor,
    Color_? navigationBarColor,
    Color_? navigationBarDividerColor,
    Color_? secondaryToolbarColor,
    bool? enableUrlBarHiding,
    bool? instantAppsEnabled,
    String? packageName,
    bool? keepAliveEnabled,
    bool? isSingleInstance,
    bool? noHistory,
    bool? isTrustedWebActivity,
    List<String>? additionalTrustedOrigins,
    TrustedWebActivityDisplayMode? displayMode,
    TrustedWebActivityScreenOrientation? screenOrientation,
    List<AndroidResource>? startAnimations,
    List<AndroidResource>? exitAnimations,
    bool? alwaysUseBrowserUI,
    bool? entersReaderIfAvailable,
    bool? barCollapsingEnabled,
    DismissButtonStyle? dismissButtonStyle,
    Color_? preferredBarTintColor,
    Color_? preferredControlTintColor,
    ModalPresentationStyle? presentationStyle,
    ModalTransitionStyle? transitionStyle,
    ActivityButton? activityButton,
    UIEventAttribution? eventAttribution,
  }) {
    return ChromeSafariBrowserSettings(
      shareState: shareState ?? this.shareState,
      showTitle: showTitle ?? this.showTitle,
      toolbarBackgroundColor:
          toolbarBackgroundColor ?? this.toolbarBackgroundColor,
      navigationBarColor: navigationBarColor ?? this.navigationBarColor,
      navigationBarDividerColor:
          navigationBarDividerColor ?? this.navigationBarDividerColor,
      secondaryToolbarColor:
          secondaryToolbarColor ?? this.secondaryToolbarColor,
      enableUrlBarHiding: enableUrlBarHiding ?? this.enableUrlBarHiding,
      instantAppsEnabled: instantAppsEnabled ?? this.instantAppsEnabled,
      packageName: packageName ?? this.packageName,
      keepAliveEnabled: keepAliveEnabled ?? this.keepAliveEnabled,
      isSingleInstance: isSingleInstance ?? this.isSingleInstance,
      noHistory: noHistory ?? this.noHistory,
      isTrustedWebActivity: isTrustedWebActivity ?? this.isTrustedWebActivity,
      additionalTrustedOrigins:
          additionalTrustedOrigins ?? this.additionalTrustedOrigins,
      displayMode: displayMode ?? this.displayMode,
      screenOrientation: screenOrientation ?? this.screenOrientation,
      startAnimations: startAnimations ?? this.startAnimations,
      exitAnimations: exitAnimations ?? this.exitAnimations,
      alwaysUseBrowserUI: alwaysUseBrowserUI ?? this.alwaysUseBrowserUI,
      entersReaderIfAvailable:
          entersReaderIfAvailable ?? this.entersReaderIfAvailable,
      barCollapsingEnabled: barCollapsingEnabled ?? this.barCollapsingEnabled,
      dismissButtonStyle: dismissButtonStyle ?? this.dismissButtonStyle,
      preferredBarTintColor:
          preferredBarTintColor ?? this.preferredBarTintColor,
      preferredControlTintColor:
          preferredControlTintColor ?? this.preferredControlTintColor,
      presentationStyle: presentationStyle ?? this.presentationStyle,
      transitionStyle: transitionStyle ?? this.transitionStyle,
      activityButton: activityButton ?? this.activityButton,
      eventAttribution: eventAttribution ?? this.eventAttribution,
    );
  }

  ChromeSafariBrowserSettings copyWithChromeSafariBrowserSettings({
    CustomTabsShareState? shareState,
    bool? showTitle,
    Color_? toolbarBackgroundColor,
    Color_? navigationBarColor,
    Color_? navigationBarDividerColor,
    Color_? secondaryToolbarColor,
    bool? enableUrlBarHiding,
    bool? instantAppsEnabled,
    String? packageName,
    bool? keepAliveEnabled,
    bool? isSingleInstance,
    bool? noHistory,
    bool? isTrustedWebActivity,
    List<String>? additionalTrustedOrigins,
    TrustedWebActivityDisplayMode? displayMode,
    TrustedWebActivityScreenOrientation? screenOrientation,
    List<AndroidResource>? startAnimations,
    List<AndroidResource>? exitAnimations,
    bool? alwaysUseBrowserUI,
    bool? entersReaderIfAvailable,
    bool? barCollapsingEnabled,
    DismissButtonStyle? dismissButtonStyle,
    Color_? preferredBarTintColor,
    Color_? preferredControlTintColor,
    ModalPresentationStyle? presentationStyle,
    ModalTransitionStyle? transitionStyle,
    ActivityButton? activityButton,
    UIEventAttribution? eventAttribution,
  }) {
    return copyWith(
      shareState: shareState,
      showTitle: showTitle,
      toolbarBackgroundColor: toolbarBackgroundColor,
      navigationBarColor: navigationBarColor,
      navigationBarDividerColor: navigationBarDividerColor,
      secondaryToolbarColor: secondaryToolbarColor,
      enableUrlBarHiding: enableUrlBarHiding,
      instantAppsEnabled: instantAppsEnabled,
      packageName: packageName,
      keepAliveEnabled: keepAliveEnabled,
      isSingleInstance: isSingleInstance,
      noHistory: noHistory,
      isTrustedWebActivity: isTrustedWebActivity,
      additionalTrustedOrigins: additionalTrustedOrigins,
      displayMode: displayMode,
      screenOrientation: screenOrientation,
      startAnimations: startAnimations,
      exitAnimations: exitAnimations,
      alwaysUseBrowserUI: alwaysUseBrowserUI,
      entersReaderIfAvailable: entersReaderIfAvailable,
      barCollapsingEnabled: barCollapsingEnabled,
      dismissButtonStyle: dismissButtonStyle,
      preferredBarTintColor: preferredBarTintColor,
      preferredControlTintColor: preferredControlTintColor,
      presentationStyle: presentationStyle,
      transitionStyle: transitionStyle,
      activityButton: activityButton,
      eventAttribution: eventAttribution,
    );
  }

  ChromeSafariBrowserSettings patchWithChromeSafariBrowserSettings([
    ChromeSafariBrowserSettingsPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? ChromeSafariBrowserSettingsPatch();
    final _patchMap = _patcher.patchMap;
    return ChromeSafariBrowserSettings(
      shareState: _patchMap.containsKey(ChromeSafariBrowserSettings$.shareState)
          ? (_patchMap[ChromeSafariBrowserSettings$.shareState] is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.shareState](
                    this.shareState,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.shareState] is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.shareState].applyTo(
                    this.shareState,
                  )
                : _patchMap[ChromeSafariBrowserSettings$.shareState]
          : this.shareState,
      showTitle: _patchMap.containsKey(ChromeSafariBrowserSettings$.showTitle)
          ? (_patchMap[ChromeSafariBrowserSettings$.showTitle] is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.showTitle](
                    this.showTitle,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.showTitle] is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.showTitle].applyTo(
                    this.showTitle,
                  )
                : _patchMap[ChromeSafariBrowserSettings$.showTitle]
          : this.showTitle,
      toolbarBackgroundColor:
          _patchMap.containsKey(
            ChromeSafariBrowserSettings$.toolbarBackgroundColor,
          )
          ? (_patchMap[ChromeSafariBrowserSettings$.toolbarBackgroundColor]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$
                      .toolbarBackgroundColor](this.toolbarBackgroundColor)
                : (_patchMap[ChromeSafariBrowserSettings$
                          .toolbarBackgroundColor]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.toolbarBackgroundColor]
                      .applyTo(this.toolbarBackgroundColor)
                : _patchMap[ChromeSafariBrowserSettings$.toolbarBackgroundColor]
          : this.toolbarBackgroundColor,
      navigationBarColor:
          _patchMap.containsKey(ChromeSafariBrowserSettings$.navigationBarColor)
          ? (_patchMap[ChromeSafariBrowserSettings$.navigationBarColor]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.navigationBarColor](
                    this.navigationBarColor,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.navigationBarColor]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.navigationBarColor]
                      .applyTo(this.navigationBarColor)
                : _patchMap[ChromeSafariBrowserSettings$.navigationBarColor]
          : this.navigationBarColor,
      navigationBarDividerColor:
          _patchMap.containsKey(
            ChromeSafariBrowserSettings$.navigationBarDividerColor,
          )
          ? (_patchMap[ChromeSafariBrowserSettings$.navigationBarDividerColor]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$
                      .navigationBarDividerColor](
                    this.navigationBarDividerColor,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$
                          .navigationBarDividerColor]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$
                          .navigationBarDividerColor]
                      .applyTo(this.navigationBarDividerColor)
                : _patchMap[ChromeSafariBrowserSettings$
                      .navigationBarDividerColor]
          : this.navigationBarDividerColor,
      secondaryToolbarColor:
          _patchMap.containsKey(
            ChromeSafariBrowserSettings$.secondaryToolbarColor,
          )
          ? (_patchMap[ChromeSafariBrowserSettings$.secondaryToolbarColor]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.secondaryToolbarColor](
                    this.secondaryToolbarColor,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.secondaryToolbarColor]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.secondaryToolbarColor]
                      .applyTo(this.secondaryToolbarColor)
                : _patchMap[ChromeSafariBrowserSettings$.secondaryToolbarColor]
          : this.secondaryToolbarColor,
      enableUrlBarHiding:
          _patchMap.containsKey(ChromeSafariBrowserSettings$.enableUrlBarHiding)
          ? (_patchMap[ChromeSafariBrowserSettings$.enableUrlBarHiding]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.enableUrlBarHiding](
                    this.enableUrlBarHiding,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.enableUrlBarHiding]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.enableUrlBarHiding]
                      .applyTo(this.enableUrlBarHiding)
                : _patchMap[ChromeSafariBrowserSettings$.enableUrlBarHiding]
          : this.enableUrlBarHiding,
      instantAppsEnabled:
          _patchMap.containsKey(ChromeSafariBrowserSettings$.instantAppsEnabled)
          ? (_patchMap[ChromeSafariBrowserSettings$.instantAppsEnabled]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.instantAppsEnabled](
                    this.instantAppsEnabled,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.instantAppsEnabled]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.instantAppsEnabled]
                      .applyTo(this.instantAppsEnabled)
                : _patchMap[ChromeSafariBrowserSettings$.instantAppsEnabled]
          : this.instantAppsEnabled,
      packageName:
          _patchMap.containsKey(ChromeSafariBrowserSettings$.packageName)
          ? (_patchMap[ChromeSafariBrowserSettings$.packageName] is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.packageName](
                    this.packageName,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.packageName] is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.packageName].applyTo(
                    this.packageName,
                  )
                : _patchMap[ChromeSafariBrowserSettings$.packageName]
          : this.packageName,
      keepAliveEnabled:
          _patchMap.containsKey(ChromeSafariBrowserSettings$.keepAliveEnabled)
          ? (_patchMap[ChromeSafariBrowserSettings$.keepAliveEnabled]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.keepAliveEnabled](
                    this.keepAliveEnabled,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.keepAliveEnabled]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.keepAliveEnabled]
                      .applyTo(this.keepAliveEnabled)
                : _patchMap[ChromeSafariBrowserSettings$.keepAliveEnabled]
          : this.keepAliveEnabled,
      isSingleInstance:
          _patchMap.containsKey(ChromeSafariBrowserSettings$.isSingleInstance)
          ? (_patchMap[ChromeSafariBrowserSettings$.isSingleInstance]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.isSingleInstance](
                    this.isSingleInstance,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.isSingleInstance]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.isSingleInstance]
                      .applyTo(this.isSingleInstance)
                : _patchMap[ChromeSafariBrowserSettings$.isSingleInstance]
          : this.isSingleInstance,
      noHistory: _patchMap.containsKey(ChromeSafariBrowserSettings$.noHistory)
          ? (_patchMap[ChromeSafariBrowserSettings$.noHistory] is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.noHistory](
                    this.noHistory,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.noHistory] is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.noHistory].applyTo(
                    this.noHistory,
                  )
                : _patchMap[ChromeSafariBrowserSettings$.noHistory]
          : this.noHistory,
      isTrustedWebActivity:
          _patchMap.containsKey(
            ChromeSafariBrowserSettings$.isTrustedWebActivity,
          )
          ? (_patchMap[ChromeSafariBrowserSettings$.isTrustedWebActivity]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.isTrustedWebActivity](
                    this.isTrustedWebActivity,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.isTrustedWebActivity]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.isTrustedWebActivity]
                      .applyTo(this.isTrustedWebActivity)
                : _patchMap[ChromeSafariBrowserSettings$.isTrustedWebActivity]
          : this.isTrustedWebActivity,
      additionalTrustedOrigins:
          _patchMap.containsKey(
            ChromeSafariBrowserSettings$.additionalTrustedOrigins,
          )
          ? (_patchMap[ChromeSafariBrowserSettings$.additionalTrustedOrigins]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$
                      .additionalTrustedOrigins](this.additionalTrustedOrigins)
                : (_patchMap[ChromeSafariBrowserSettings$
                          .additionalTrustedOrigins]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$
                          .additionalTrustedOrigins]
                      .applyTo(this.additionalTrustedOrigins)
                : _patchMap[ChromeSafariBrowserSettings$
                      .additionalTrustedOrigins]
          : this.additionalTrustedOrigins,
      displayMode:
          _patchMap.containsKey(ChromeSafariBrowserSettings$.displayMode)
          ? (_patchMap[ChromeSafariBrowserSettings$.displayMode] is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.displayMode](
                    this.displayMode,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.displayMode] is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.displayMode].applyTo(
                    this.displayMode,
                  )
                : _patchMap[ChromeSafariBrowserSettings$.displayMode]
          : this.displayMode,
      screenOrientation:
          _patchMap.containsKey(ChromeSafariBrowserSettings$.screenOrientation)
          ? (_patchMap[ChromeSafariBrowserSettings$.screenOrientation]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.screenOrientation](
                    this.screenOrientation,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.screenOrientation]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.screenOrientation]
                      .applyTo(this.screenOrientation)
                : _patchMap[ChromeSafariBrowserSettings$.screenOrientation]
          : this.screenOrientation,
      startAnimations:
          _patchMap.containsKey(ChromeSafariBrowserSettings$.startAnimations)
          ? (_patchMap[ChromeSafariBrowserSettings$.startAnimations]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.startAnimations](
                    this.startAnimations,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.startAnimations]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.startAnimations]
                      .applyTo(this.startAnimations)
                : _patchMap[ChromeSafariBrowserSettings$.startAnimations]
          : this.startAnimations,
      exitAnimations:
          _patchMap.containsKey(ChromeSafariBrowserSettings$.exitAnimations)
          ? (_patchMap[ChromeSafariBrowserSettings$.exitAnimations] is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.exitAnimations](
                    this.exitAnimations,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.exitAnimations]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.exitAnimations]
                      .applyTo(this.exitAnimations)
                : _patchMap[ChromeSafariBrowserSettings$.exitAnimations]
          : this.exitAnimations,
      alwaysUseBrowserUI:
          _patchMap.containsKey(ChromeSafariBrowserSettings$.alwaysUseBrowserUI)
          ? (_patchMap[ChromeSafariBrowserSettings$.alwaysUseBrowserUI]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.alwaysUseBrowserUI](
                    this.alwaysUseBrowserUI,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.alwaysUseBrowserUI]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.alwaysUseBrowserUI]
                      .applyTo(this.alwaysUseBrowserUI)
                : _patchMap[ChromeSafariBrowserSettings$.alwaysUseBrowserUI]
          : this.alwaysUseBrowserUI,
      entersReaderIfAvailable:
          _patchMap.containsKey(
            ChromeSafariBrowserSettings$.entersReaderIfAvailable,
          )
          ? (_patchMap[ChromeSafariBrowserSettings$.entersReaderIfAvailable]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$
                      .entersReaderIfAvailable](this.entersReaderIfAvailable)
                : (_patchMap[ChromeSafariBrowserSettings$
                          .entersReaderIfAvailable]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$
                          .entersReaderIfAvailable]
                      .applyTo(this.entersReaderIfAvailable)
                : _patchMap[ChromeSafariBrowserSettings$
                      .entersReaderIfAvailable]
          : this.entersReaderIfAvailable,
      barCollapsingEnabled:
          _patchMap.containsKey(
            ChromeSafariBrowserSettings$.barCollapsingEnabled,
          )
          ? (_patchMap[ChromeSafariBrowserSettings$.barCollapsingEnabled]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.barCollapsingEnabled](
                    this.barCollapsingEnabled,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.barCollapsingEnabled]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.barCollapsingEnabled]
                      .applyTo(this.barCollapsingEnabled)
                : _patchMap[ChromeSafariBrowserSettings$.barCollapsingEnabled]
          : this.barCollapsingEnabled,
      dismissButtonStyle:
          _patchMap.containsKey(ChromeSafariBrowserSettings$.dismissButtonStyle)
          ? (_patchMap[ChromeSafariBrowserSettings$.dismissButtonStyle]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.dismissButtonStyle](
                    this.dismissButtonStyle,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.dismissButtonStyle]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.dismissButtonStyle]
                      .applyTo(this.dismissButtonStyle)
                : _patchMap[ChromeSafariBrowserSettings$.dismissButtonStyle]
          : this.dismissButtonStyle,
      preferredBarTintColor:
          _patchMap.containsKey(
            ChromeSafariBrowserSettings$.preferredBarTintColor,
          )
          ? (_patchMap[ChromeSafariBrowserSettings$.preferredBarTintColor]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.preferredBarTintColor](
                    this.preferredBarTintColor,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.preferredBarTintColor]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.preferredBarTintColor]
                      .applyTo(this.preferredBarTintColor)
                : _patchMap[ChromeSafariBrowserSettings$.preferredBarTintColor]
          : this.preferredBarTintColor,
      preferredControlTintColor:
          _patchMap.containsKey(
            ChromeSafariBrowserSettings$.preferredControlTintColor,
          )
          ? (_patchMap[ChromeSafariBrowserSettings$.preferredControlTintColor]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$
                      .preferredControlTintColor](
                    this.preferredControlTintColor,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$
                          .preferredControlTintColor]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$
                          .preferredControlTintColor]
                      .applyTo(this.preferredControlTintColor)
                : _patchMap[ChromeSafariBrowserSettings$
                      .preferredControlTintColor]
          : this.preferredControlTintColor,
      presentationStyle:
          _patchMap.containsKey(ChromeSafariBrowserSettings$.presentationStyle)
          ? (_patchMap[ChromeSafariBrowserSettings$.presentationStyle]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.presentationStyle](
                    this.presentationStyle,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.presentationStyle]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.presentationStyle]
                      .applyTo(this.presentationStyle)
                : _patchMap[ChromeSafariBrowserSettings$.presentationStyle]
          : this.presentationStyle,
      transitionStyle:
          _patchMap.containsKey(ChromeSafariBrowserSettings$.transitionStyle)
          ? (_patchMap[ChromeSafariBrowserSettings$.transitionStyle]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.transitionStyle](
                    this.transitionStyle,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.transitionStyle]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.transitionStyle]
                      .applyTo(this.transitionStyle)
                : _patchMap[ChromeSafariBrowserSettings$.transitionStyle]
          : this.transitionStyle,
      activityButton:
          _patchMap.containsKey(ChromeSafariBrowserSettings$.activityButton)
          ? (_patchMap[ChromeSafariBrowserSettings$.activityButton] is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.activityButton](
                    this.activityButton,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.activityButton]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.activityButton]
                      .applyTo(this.activityButton)
                : _patchMap[ChromeSafariBrowserSettings$.activityButton]
          : this.activityButton,
      eventAttribution:
          _patchMap.containsKey(ChromeSafariBrowserSettings$.eventAttribution)
          ? (_patchMap[ChromeSafariBrowserSettings$.eventAttribution]
                    is Function)
                ? _patchMap[ChromeSafariBrowserSettings$.eventAttribution](
                    this.eventAttribution,
                  )
                : (_patchMap[ChromeSafariBrowserSettings$.eventAttribution]
                      is Patch)
                ? _patchMap[ChromeSafariBrowserSettings$.eventAttribution]
                      .applyTo(this.eventAttribution)
                : _patchMap[ChromeSafariBrowserSettings$.eventAttribution]
          : this.eventAttribution,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChromeSafariBrowserSettings &&
        shareState == other.shareState &&
        showTitle == other.showTitle &&
        toolbarBackgroundColor == other.toolbarBackgroundColor &&
        navigationBarColor == other.navigationBarColor &&
        navigationBarDividerColor == other.navigationBarDividerColor &&
        secondaryToolbarColor == other.secondaryToolbarColor &&
        enableUrlBarHiding == other.enableUrlBarHiding &&
        instantAppsEnabled == other.instantAppsEnabled &&
        packageName == other.packageName &&
        keepAliveEnabled == other.keepAliveEnabled &&
        isSingleInstance == other.isSingleInstance &&
        noHistory == other.noHistory &&
        isTrustedWebActivity == other.isTrustedWebActivity &&
        additionalTrustedOrigins == other.additionalTrustedOrigins &&
        displayMode == other.displayMode &&
        screenOrientation == other.screenOrientation &&
        startAnimations == other.startAnimations &&
        exitAnimations == other.exitAnimations &&
        alwaysUseBrowserUI == other.alwaysUseBrowserUI &&
        entersReaderIfAvailable == other.entersReaderIfAvailable &&
        barCollapsingEnabled == other.barCollapsingEnabled &&
        dismissButtonStyle == other.dismissButtonStyle &&
        preferredBarTintColor == other.preferredBarTintColor &&
        preferredControlTintColor == other.preferredControlTintColor &&
        presentationStyle == other.presentationStyle &&
        transitionStyle == other.transitionStyle &&
        activityButton == other.activityButton &&
        eventAttribution == other.eventAttribution;
  }

  @override
  int get hashCode {
    return Object.hash(
          this.shareState,
          this.showTitle,
          this.toolbarBackgroundColor,
          this.navigationBarColor,
          this.navigationBarDividerColor,
          this.secondaryToolbarColor,
          this.enableUrlBarHiding,
          this.instantAppsEnabled,
          this.packageName,
          this.keepAliveEnabled,
          this.isSingleInstance,
          this.noHistory,
          this.isTrustedWebActivity,
          this.additionalTrustedOrigins,
          this.displayMode,
          this.screenOrientation,
          this.startAnimations,
          this.exitAnimations,
          this.alwaysUseBrowserUI,
          this.entersReaderIfAvailable,
        ) ^
        Object.hash(
          this.barCollapsingEnabled,
          this.dismissButtonStyle,
          this.preferredBarTintColor,
          this.preferredControlTintColor,
          this.presentationStyle,
          this.transitionStyle,
          this.activityButton,
          this.eventAttribution,
        );
  }

  @override
  String toString() {
    return 'ChromeSafariBrowserSettings(' +
        'shareState: ${shareState}' +
        ', ' +
        'showTitle: ${showTitle}' +
        ', ' +
        'toolbarBackgroundColor: ${toolbarBackgroundColor}' +
        ', ' +
        'navigationBarColor: ${navigationBarColor}' +
        ', ' +
        'navigationBarDividerColor: ${navigationBarDividerColor}' +
        ', ' +
        'secondaryToolbarColor: ${secondaryToolbarColor}' +
        ', ' +
        'enableUrlBarHiding: ${enableUrlBarHiding}' +
        ', ' +
        'instantAppsEnabled: ${instantAppsEnabled}' +
        ', ' +
        'packageName: ${packageName}' +
        ', ' +
        'keepAliveEnabled: ${keepAliveEnabled}' +
        ', ' +
        'isSingleInstance: ${isSingleInstance}' +
        ', ' +
        'noHistory: ${noHistory}' +
        ', ' +
        'isTrustedWebActivity: ${isTrustedWebActivity}' +
        ', ' +
        'additionalTrustedOrigins: ${additionalTrustedOrigins}' +
        ', ' +
        'displayMode: ${displayMode}' +
        ', ' +
        'screenOrientation: ${screenOrientation}' +
        ', ' +
        'startAnimations: ${startAnimations}' +
        ', ' +
        'exitAnimations: ${exitAnimations}' +
        ', ' +
        'alwaysUseBrowserUI: ${alwaysUseBrowserUI}' +
        ', ' +
        'entersReaderIfAvailable: ${entersReaderIfAvailable}' +
        ', ' +
        'barCollapsingEnabled: ${barCollapsingEnabled}' +
        ', ' +
        'dismissButtonStyle: ${dismissButtonStyle}' +
        ', ' +
        'preferredBarTintColor: ${preferredBarTintColor}' +
        ', ' +
        'preferredControlTintColor: ${preferredControlTintColor}' +
        ', ' +
        'presentationStyle: ${presentationStyle}' +
        ', ' +
        'transitionStyle: ${transitionStyle}' +
        ', ' +
        'activityButton: ${activityButton}' +
        ', ' +
        'eventAttribution: ${eventAttribution})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$ChromeSafariBrowserSettingsToJson(this);
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

extension ChromeSafariBrowserSettingsPropertyHelpers
    on ChromeSafariBrowserSettings {
  bool get hasShareState {
    return this.shareState != null;
  }

  bool get noShareState {
    return this.shareState == null;
  }

  CustomTabsShareState get shareStateRequired {
    return this.shareState ??
        (throw StateError('shareState is required but was null'));
  }

  bool get isShareStateSHARE_STATE_DEFAULT {
    return this.shareState == CustomTabsShareState.SHARE_STATE_DEFAULT;
  }

  bool get isShareStateSHARE_STATE_ON {
    return this.shareState == CustomTabsShareState.SHARE_STATE_ON;
  }

  bool get isShareStateSHARE_STATE_OFF {
    return this.shareState == CustomTabsShareState.SHARE_STATE_OFF;
  }

  bool get hasShowTitle {
    return this.showTitle != null;
  }

  bool get noShowTitle {
    return this.showTitle == null;
  }

  bool get showTitleRequired {
    return this.showTitle ??
        (throw StateError('showTitle is required but was null'));
  }

  bool get hasToolbarBackgroundColor {
    return this.toolbarBackgroundColor != null;
  }

  bool get noToolbarBackgroundColor {
    return this.toolbarBackgroundColor == null;
  }

  Color_ get toolbarBackgroundColorRequired {
    return this.toolbarBackgroundColor ??
        (throw StateError('toolbarBackgroundColor is required but was null'));
  }

  bool get hasNavigationBarColor {
    return this.navigationBarColor != null;
  }

  bool get noNavigationBarColor {
    return this.navigationBarColor == null;
  }

  Color_ get navigationBarColorRequired {
    return this.navigationBarColor ??
        (throw StateError('navigationBarColor is required but was null'));
  }

  bool get hasNavigationBarDividerColor {
    return this.navigationBarDividerColor != null;
  }

  bool get noNavigationBarDividerColor {
    return this.navigationBarDividerColor == null;
  }

  Color_ get navigationBarDividerColorRequired {
    return this.navigationBarDividerColor ??
        (throw StateError(
          'navigationBarDividerColor is required but was null',
        ));
  }

  bool get hasSecondaryToolbarColor {
    return this.secondaryToolbarColor != null;
  }

  bool get noSecondaryToolbarColor {
    return this.secondaryToolbarColor == null;
  }

  Color_ get secondaryToolbarColorRequired {
    return this.secondaryToolbarColor ??
        (throw StateError('secondaryToolbarColor is required but was null'));
  }

  bool get hasEnableUrlBarHiding {
    return this.enableUrlBarHiding != null;
  }

  bool get noEnableUrlBarHiding {
    return this.enableUrlBarHiding == null;
  }

  bool get enableUrlBarHidingRequired {
    return this.enableUrlBarHiding ??
        (throw StateError('enableUrlBarHiding is required but was null'));
  }

  bool get hasInstantAppsEnabled {
    return this.instantAppsEnabled != null;
  }

  bool get noInstantAppsEnabled {
    return this.instantAppsEnabled == null;
  }

  bool get instantAppsEnabledRequired {
    return this.instantAppsEnabled ??
        (throw StateError('instantAppsEnabled is required but was null'));
  }

  bool get hasPackageName {
    return this.packageName?.isNotEmpty == true;
  }

  bool get noPackageName {
    return this.packageName?.isEmpty ?? true;
  }

  String get packageNameRequired {
    return this.packageName ??
        (throw StateError('packageName is required but was null'));
  }

  bool get hasKeepAliveEnabled {
    return this.keepAliveEnabled != null;
  }

  bool get noKeepAliveEnabled {
    return this.keepAliveEnabled == null;
  }

  bool get keepAliveEnabledRequired {
    return this.keepAliveEnabled ??
        (throw StateError('keepAliveEnabled is required but was null'));
  }

  bool get hasIsSingleInstance {
    return this.isSingleInstance != null;
  }

  bool get noIsSingleInstance {
    return this.isSingleInstance == null;
  }

  bool get isSingleInstanceRequired {
    return this.isSingleInstance ??
        (throw StateError('isSingleInstance is required but was null'));
  }

  bool get hasNoHistory {
    return this.noHistory != null;
  }

  bool get noNoHistory {
    return this.noHistory == null;
  }

  bool get noHistoryRequired {
    return this.noHistory ??
        (throw StateError('noHistory is required but was null'));
  }

  bool get hasIsTrustedWebActivity {
    return this.isTrustedWebActivity != null;
  }

  bool get noIsTrustedWebActivity {
    return this.isTrustedWebActivity == null;
  }

  bool get isTrustedWebActivityRequired {
    return this.isTrustedWebActivity ??
        (throw StateError('isTrustedWebActivity is required but was null'));
  }

  List<String> get additionalTrustedOriginsRequired {
    return this.additionalTrustedOrigins ??
        (throw StateError('additionalTrustedOrigins is required but was null'));
  }

  bool get hasAdditionalTrustedOrigins {
    return this.additionalTrustedOrigins?.isNotEmpty ?? false;
  }

  bool get noAdditionalTrustedOrigins {
    return this.additionalTrustedOrigins?.isEmpty ?? true;
  }

  bool get hasDisplayMode {
    return this.displayMode != null;
  }

  bool get noDisplayMode {
    return this.displayMode == null;
  }

  TrustedWebActivityDisplayMode get displayModeRequired {
    return this.displayMode ??
        (throw StateError('displayMode is required but was null'));
  }

  bool get hasScreenOrientation {
    return this.screenOrientation != null;
  }

  bool get noScreenOrientation {
    return this.screenOrientation == null;
  }

  TrustedWebActivityScreenOrientation get screenOrientationRequired {
    return this.screenOrientation ??
        (throw StateError('screenOrientation is required but was null'));
  }

  bool get isScreenOrientationDEFAULT {
    return this.screenOrientation ==
        TrustedWebActivityScreenOrientation.DEFAULT;
  }

  bool get isScreenOrientationPORTRAIT_PRIMARY {
    return this.screenOrientation ==
        TrustedWebActivityScreenOrientation.PORTRAIT_PRIMARY;
  }

  bool get isScreenOrientationPORTRAIT_SECONDARY {
    return this.screenOrientation ==
        TrustedWebActivityScreenOrientation.PORTRAIT_SECONDARY;
  }

  bool get isScreenOrientationLANDSCAPE_PRIMARY {
    return this.screenOrientation ==
        TrustedWebActivityScreenOrientation.LANDSCAPE_PRIMARY;
  }

  bool get isScreenOrientationLANDSCAPE_SECONDARY {
    return this.screenOrientation ==
        TrustedWebActivityScreenOrientation.LANDSCAPE_SECONDARY;
  }

  bool get isScreenOrientationANY {
    return this.screenOrientation == TrustedWebActivityScreenOrientation.ANY;
  }

  bool get isScreenOrientationLANDSCAPE {
    return this.screenOrientation ==
        TrustedWebActivityScreenOrientation.LANDSCAPE;
  }

  bool get isScreenOrientationPORTRAIT {
    return this.screenOrientation ==
        TrustedWebActivityScreenOrientation.PORTRAIT;
  }

  bool get isScreenOrientationNATURAL {
    return this.screenOrientation ==
        TrustedWebActivityScreenOrientation.NATURAL;
  }

  List<AndroidResource> get startAnimationsRequired {
    return this.startAnimations ??
        (throw StateError('startAnimations is required but was null'));
  }

  bool get hasStartAnimations {
    return this.startAnimations?.isNotEmpty ?? false;
  }

  bool get noStartAnimations {
    return this.startAnimations?.isEmpty ?? true;
  }

  List<AndroidResource> get exitAnimationsRequired {
    return this.exitAnimations ??
        (throw StateError('exitAnimations is required but was null'));
  }

  bool get hasExitAnimations {
    return this.exitAnimations?.isNotEmpty ?? false;
  }

  bool get noExitAnimations {
    return this.exitAnimations?.isEmpty ?? true;
  }

  bool get hasAlwaysUseBrowserUI {
    return this.alwaysUseBrowserUI != null;
  }

  bool get noAlwaysUseBrowserUI {
    return this.alwaysUseBrowserUI == null;
  }

  bool get alwaysUseBrowserUIRequired {
    return this.alwaysUseBrowserUI ??
        (throw StateError('alwaysUseBrowserUI is required but was null'));
  }

  bool get hasEntersReaderIfAvailable {
    return this.entersReaderIfAvailable != null;
  }

  bool get noEntersReaderIfAvailable {
    return this.entersReaderIfAvailable == null;
  }

  bool get entersReaderIfAvailableRequired {
    return this.entersReaderIfAvailable ??
        (throw StateError('entersReaderIfAvailable is required but was null'));
  }

  bool get hasBarCollapsingEnabled {
    return this.barCollapsingEnabled != null;
  }

  bool get noBarCollapsingEnabled {
    return this.barCollapsingEnabled == null;
  }

  bool get barCollapsingEnabledRequired {
    return this.barCollapsingEnabled ??
        (throw StateError('barCollapsingEnabled is required but was null'));
  }

  bool get hasDismissButtonStyle {
    return this.dismissButtonStyle != null;
  }

  bool get noDismissButtonStyle {
    return this.dismissButtonStyle == null;
  }

  DismissButtonStyle get dismissButtonStyleRequired {
    return this.dismissButtonStyle ??
        (throw StateError('dismissButtonStyle is required but was null'));
  }

  bool get isDismissButtonStyleDONE {
    return this.dismissButtonStyle == DismissButtonStyle.DONE;
  }

  bool get isDismissButtonStyleCLOSE {
    return this.dismissButtonStyle == DismissButtonStyle.CLOSE;
  }

  bool get isDismissButtonStyleCANCEL {
    return this.dismissButtonStyle == DismissButtonStyle.CANCEL;
  }

  bool get hasPreferredBarTintColor {
    return this.preferredBarTintColor != null;
  }

  bool get noPreferredBarTintColor {
    return this.preferredBarTintColor == null;
  }

  Color_ get preferredBarTintColorRequired {
    return this.preferredBarTintColor ??
        (throw StateError('preferredBarTintColor is required but was null'));
  }

  bool get hasPreferredControlTintColor {
    return this.preferredControlTintColor != null;
  }

  bool get noPreferredControlTintColor {
    return this.preferredControlTintColor == null;
  }

  Color_ get preferredControlTintColorRequired {
    return this.preferredControlTintColor ??
        (throw StateError(
          'preferredControlTintColor is required but was null',
        ));
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

  bool get hasActivityButton {
    return this.activityButton != null;
  }

  bool get noActivityButton {
    return this.activityButton == null;
  }

  ActivityButton get activityButtonRequired {
    return this.activityButton ??
        (throw StateError('activityButton is required but was null'));
  }

  bool get hasEventAttribution {
    return this.eventAttribution != null;
  }

  bool get noEventAttribution {
    return this.eventAttribution == null;
  }

  UIEventAttribution get eventAttributionRequired {
    return this.eventAttribution ??
        (throw StateError('eventAttribution is required but was null'));
  }
}

extension ChromeSafariBrowserSettingsSerialization
    on ChromeSafariBrowserSettings {
  Map<String, dynamic> toJson() {
    return _$ChromeSafariBrowserSettingsToJson(this);
  }
}

enum ChromeSafariBrowserSettings$ {
  shareState,
  showTitle,
  toolbarBackgroundColor,
  navigationBarColor,
  navigationBarDividerColor,
  secondaryToolbarColor,
  enableUrlBarHiding,
  instantAppsEnabled,
  packageName,
  keepAliveEnabled,
  isSingleInstance,
  noHistory,
  isTrustedWebActivity,
  additionalTrustedOrigins,
  displayMode,
  screenOrientation,
  startAnimations,
  exitAnimations,
  alwaysUseBrowserUI,
  entersReaderIfAvailable,
  barCollapsingEnabled,
  dismissButtonStyle,
  preferredBarTintColor,
  preferredControlTintColor,
  presentationStyle,
  transitionStyle,
  activityButton,
  eventAttribution,
}

class ChromeSafariBrowserSettingsPatch
    extends
        PatchBase<ChromeSafariBrowserSettings, ChromeSafariBrowserSettings$> {
  ChromeSafariBrowserSettings applyTo(ChromeSafariBrowserSettings entity) {
    return entity.patchWithChromeSafariBrowserSettings(this);
  }

  ChromeSafariBrowserSettingsPatch withShareState(CustomTabsShareState? value) {
    patchMap[ChromeSafariBrowserSettings$.shareState] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withShowTitle(bool? value) {
    patchMap[ChromeSafariBrowserSettings$.showTitle] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withToolbarBackgroundColor(Color_? value) {
    patchMap[ChromeSafariBrowserSettings$.toolbarBackgroundColor] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withNavigationBarColor(Color_? value) {
    patchMap[ChromeSafariBrowserSettings$.navigationBarColor] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withNavigationBarDividerColor(
    Color_? value,
  ) {
    patchMap[ChromeSafariBrowserSettings$.navigationBarDividerColor] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withSecondaryToolbarColor(Color_? value) {
    patchMap[ChromeSafariBrowserSettings$.secondaryToolbarColor] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withEnableUrlBarHiding(bool? value) {
    patchMap[ChromeSafariBrowserSettings$.enableUrlBarHiding] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withInstantAppsEnabled(bool? value) {
    patchMap[ChromeSafariBrowserSettings$.instantAppsEnabled] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withPackageName(String? value) {
    patchMap[ChromeSafariBrowserSettings$.packageName] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withKeepAliveEnabled(bool? value) {
    patchMap[ChromeSafariBrowserSettings$.keepAliveEnabled] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withIsSingleInstance(bool? value) {
    patchMap[ChromeSafariBrowserSettings$.isSingleInstance] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withNoHistory(bool? value) {
    patchMap[ChromeSafariBrowserSettings$.noHistory] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withIsTrustedWebActivity(bool? value) {
    patchMap[ChromeSafariBrowserSettings$.isTrustedWebActivity] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withAdditionalTrustedOrigins(
    List<String>? value,
  ) {
    patchMap[ChromeSafariBrowserSettings$.additionalTrustedOrigins] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withDisplayMode(
    TrustedWebActivityDisplayMode? value,
  ) {
    patchMap[ChromeSafariBrowserSettings$.displayMode] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withScreenOrientation(
    TrustedWebActivityScreenOrientation? value,
  ) {
    patchMap[ChromeSafariBrowserSettings$.screenOrientation] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withStartAnimations(
    List<AndroidResource>? value,
  ) {
    patchMap[ChromeSafariBrowserSettings$.startAnimations] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withExitAnimations(
    List<AndroidResource>? value,
  ) {
    patchMap[ChromeSafariBrowserSettings$.exitAnimations] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withAlwaysUseBrowserUI(bool? value) {
    patchMap[ChromeSafariBrowserSettings$.alwaysUseBrowserUI] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withEntersReaderIfAvailable(bool? value) {
    patchMap[ChromeSafariBrowserSettings$.entersReaderIfAvailable] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withBarCollapsingEnabled(bool? value) {
    patchMap[ChromeSafariBrowserSettings$.barCollapsingEnabled] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withDismissButtonStyle(
    DismissButtonStyle? value,
  ) {
    patchMap[ChromeSafariBrowserSettings$.dismissButtonStyle] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withPreferredBarTintColor(Color_? value) {
    patchMap[ChromeSafariBrowserSettings$.preferredBarTintColor] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withPreferredControlTintColor(
    Color_? value,
  ) {
    patchMap[ChromeSafariBrowserSettings$.preferredControlTintColor] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withPresentationStyle(
    ModalPresentationStyle? value,
  ) {
    patchMap[ChromeSafariBrowserSettings$.presentationStyle] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withTransitionStyle(
    ModalTransitionStyle? value,
  ) {
    patchMap[ChromeSafariBrowserSettings$.transitionStyle] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withActivityButton(ActivityButton? value) {
    patchMap[ChromeSafariBrowserSettings$.activityButton] = value;
    return this;
  }

  ChromeSafariBrowserSettingsPatch withEventAttribution(
    UIEventAttribution? value,
  ) {
    patchMap[ChromeSafariBrowserSettings$.eventAttribution] = value;
    return this;
  }
}

/// Field descriptors for [ChromeSafariBrowserSettings] query construction
abstract final class ChromeSafariBrowserSettingsFields {
  static const shareState =
      Field<ChromeSafariBrowserSettings, CustomTabsShareState?>(
        'shareState',
        _$shareState,
      );

  static const showTitle = Field<ChromeSafariBrowserSettings, bool?>(
    'showTitle',
    _$showTitle,
  );

  static const toolbarBackgroundColor =
      Field<ChromeSafariBrowserSettings, Color_?>(
        'toolbarBackgroundColor',
        _$toolbarBackgroundColor,
      );

  static const navigationBarColor = Field<ChromeSafariBrowserSettings, Color_?>(
    'navigationBarColor',
    _$navigationBarColor,
  );

  static const navigationBarDividerColor =
      Field<ChromeSafariBrowserSettings, Color_?>(
        'navigationBarDividerColor',
        _$navigationBarDividerColor,
      );

  static const secondaryToolbarColor =
      Field<ChromeSafariBrowserSettings, Color_?>(
        'secondaryToolbarColor',
        _$secondaryToolbarColor,
      );

  static const enableUrlBarHiding = Field<ChromeSafariBrowserSettings, bool?>(
    'enableUrlBarHiding',
    _$enableUrlBarHiding,
  );

  static const instantAppsEnabled = Field<ChromeSafariBrowserSettings, bool?>(
    'instantAppsEnabled',
    _$instantAppsEnabled,
  );

  static const packageName = Field<ChromeSafariBrowserSettings, String?>(
    'packageName',
    _$packageName,
  );

  static const keepAliveEnabled = Field<ChromeSafariBrowserSettings, bool?>(
    'keepAliveEnabled',
    _$keepAliveEnabled,
  );

  static const isSingleInstance = Field<ChromeSafariBrowserSettings, bool?>(
    'isSingleInstance',
    _$isSingleInstance,
  );

  static const noHistory = Field<ChromeSafariBrowserSettings, bool?>(
    'noHistory',
    _$noHistory,
  );

  static const isTrustedWebActivity = Field<ChromeSafariBrowserSettings, bool?>(
    'isTrustedWebActivity',
    _$isTrustedWebActivity,
  );

  static const additionalTrustedOrigins =
      Field<ChromeSafariBrowserSettings, List<String>?>(
        'additionalTrustedOrigins',
        _$additionalTrustedOrigins,
      );

  static const displayMode =
      Field<ChromeSafariBrowserSettings, TrustedWebActivityDisplayMode?>(
        'displayMode',
        _$displayMode,
      );

  static const screenOrientation =
      Field<ChromeSafariBrowserSettings, TrustedWebActivityScreenOrientation?>(
        'screenOrientation',
        _$screenOrientation,
      );

  static const startAnimations =
      Field<ChromeSafariBrowserSettings, List<AndroidResource>?>(
        'startAnimations',
        _$startAnimations,
      );

  static const exitAnimations =
      Field<ChromeSafariBrowserSettings, List<AndroidResource>?>(
        'exitAnimations',
        _$exitAnimations,
      );

  static const alwaysUseBrowserUI = Field<ChromeSafariBrowserSettings, bool?>(
    'alwaysUseBrowserUI',
    _$alwaysUseBrowserUI,
  );

  static const entersReaderIfAvailable =
      Field<ChromeSafariBrowserSettings, bool?>(
        'entersReaderIfAvailable',
        _$entersReaderIfAvailable,
      );

  static const barCollapsingEnabled = Field<ChromeSafariBrowserSettings, bool?>(
    'barCollapsingEnabled',
    _$barCollapsingEnabled,
  );

  static const dismissButtonStyle =
      Field<ChromeSafariBrowserSettings, DismissButtonStyle?>(
        'dismissButtonStyle',
        _$dismissButtonStyle,
      );

  static const preferredBarTintColor =
      Field<ChromeSafariBrowserSettings, Color_?>(
        'preferredBarTintColor',
        _$preferredBarTintColor,
      );

  static const preferredControlTintColor =
      Field<ChromeSafariBrowserSettings, Color_?>(
        'preferredControlTintColor',
        _$preferredControlTintColor,
      );

  static const presentationStyle =
      Field<ChromeSafariBrowserSettings, ModalPresentationStyle?>(
        'presentationStyle',
        _$presentationStyle,
      );

  static const transitionStyle =
      Field<ChromeSafariBrowserSettings, ModalTransitionStyle?>(
        'transitionStyle',
        _$transitionStyle,
      );

  static const activityButton =
      Field<ChromeSafariBrowserSettings, ActivityButton?>(
        'activityButton',
        _$activityButton,
      );

  static const eventAttribution =
      Field<ChromeSafariBrowserSettings, UIEventAttribution?>(
        'eventAttribution',
        _$eventAttribution,
      );

  static CustomTabsShareState? _$shareState(ChromeSafariBrowserSettings e) {
    return e.shareState;
  }

  static bool? _$showTitle(ChromeSafariBrowserSettings e) {
    return e.showTitle;
  }

  static Color_? _$toolbarBackgroundColor(ChromeSafariBrowserSettings e) {
    return e.toolbarBackgroundColor;
  }

  static Color_? _$navigationBarColor(ChromeSafariBrowserSettings e) {
    return e.navigationBarColor;
  }

  static Color_? _$navigationBarDividerColor(ChromeSafariBrowserSettings e) {
    return e.navigationBarDividerColor;
  }

  static Color_? _$secondaryToolbarColor(ChromeSafariBrowserSettings e) {
    return e.secondaryToolbarColor;
  }

  static bool? _$enableUrlBarHiding(ChromeSafariBrowserSettings e) {
    return e.enableUrlBarHiding;
  }

  static bool? _$instantAppsEnabled(ChromeSafariBrowserSettings e) {
    return e.instantAppsEnabled;
  }

  static String? _$packageName(ChromeSafariBrowserSettings e) {
    return e.packageName;
  }

  static bool? _$keepAliveEnabled(ChromeSafariBrowserSettings e) {
    return e.keepAliveEnabled;
  }

  static bool? _$isSingleInstance(ChromeSafariBrowserSettings e) {
    return e.isSingleInstance;
  }

  static bool? _$noHistory(ChromeSafariBrowserSettings e) {
    return e.noHistory;
  }

  static bool? _$isTrustedWebActivity(ChromeSafariBrowserSettings e) {
    return e.isTrustedWebActivity;
  }

  static List<String>? _$additionalTrustedOrigins(
    ChromeSafariBrowserSettings e,
  ) {
    return e.additionalTrustedOrigins;
  }

  static TrustedWebActivityDisplayMode? _$displayMode(
    ChromeSafariBrowserSettings e,
  ) {
    return e.displayMode;
  }

  static TrustedWebActivityScreenOrientation? _$screenOrientation(
    ChromeSafariBrowserSettings e,
  ) {
    return e.screenOrientation;
  }

  static List<AndroidResource>? _$startAnimations(
    ChromeSafariBrowserSettings e,
  ) {
    return e.startAnimations;
  }

  static List<AndroidResource>? _$exitAnimations(
    ChromeSafariBrowserSettings e,
  ) {
    return e.exitAnimations;
  }

  static bool? _$alwaysUseBrowserUI(ChromeSafariBrowserSettings e) {
    return e.alwaysUseBrowserUI;
  }

  static bool? _$entersReaderIfAvailable(ChromeSafariBrowserSettings e) {
    return e.entersReaderIfAvailable;
  }

  static bool? _$barCollapsingEnabled(ChromeSafariBrowserSettings e) {
    return e.barCollapsingEnabled;
  }

  static DismissButtonStyle? _$dismissButtonStyle(
    ChromeSafariBrowserSettings e,
  ) {
    return e.dismissButtonStyle;
  }

  static Color_? _$preferredBarTintColor(ChromeSafariBrowserSettings e) {
    return e.preferredBarTintColor;
  }

  static Color_? _$preferredControlTintColor(ChromeSafariBrowserSettings e) {
    return e.preferredControlTintColor;
  }

  static ModalPresentationStyle? _$presentationStyle(
    ChromeSafariBrowserSettings e,
  ) {
    return e.presentationStyle;
  }

  static ModalTransitionStyle? _$transitionStyle(
    ChromeSafariBrowserSettings e,
  ) {
    return e.transitionStyle;
  }

  static ActivityButton? _$activityButton(ChromeSafariBrowserSettings e) {
    return e.activityButton;
  }

  static UIEventAttribution? _$eventAttribution(ChromeSafariBrowserSettings e) {
    return e.eventAttribution;
  }
}

extension ChromeSafariBrowserSettingsCompareE on ChromeSafariBrowserSettings {
  Map<String, dynamic> compareToChromeSafariBrowserSettings(
    ChromeSafariBrowserSettings other,
  ) {
    final Map<String, dynamic> diff = {};

    if (shareState != other.shareState) {
      diff['shareState'] = () => other.shareState;
    }

    if (showTitle != other.showTitle) {
      diff['showTitle'] = () => other.showTitle;
    }

    if (toolbarBackgroundColor != other.toolbarBackgroundColor) {
      diff['toolbarBackgroundColor'] = () => other.toolbarBackgroundColor;
    }

    if (navigationBarColor != other.navigationBarColor) {
      diff['navigationBarColor'] = () => other.navigationBarColor;
    }

    if (navigationBarDividerColor != other.navigationBarDividerColor) {
      diff['navigationBarDividerColor'] = () => other.navigationBarDividerColor;
    }

    if (secondaryToolbarColor != other.secondaryToolbarColor) {
      diff['secondaryToolbarColor'] = () => other.secondaryToolbarColor;
    }

    if (enableUrlBarHiding != other.enableUrlBarHiding) {
      diff['enableUrlBarHiding'] = () => other.enableUrlBarHiding;
    }

    if (instantAppsEnabled != other.instantAppsEnabled) {
      diff['instantAppsEnabled'] = () => other.instantAppsEnabled;
    }

    if (packageName != other.packageName) {
      diff['packageName'] = () => other.packageName;
    }

    if (keepAliveEnabled != other.keepAliveEnabled) {
      diff['keepAliveEnabled'] = () => other.keepAliveEnabled;
    }

    if (isSingleInstance != other.isSingleInstance) {
      diff['isSingleInstance'] = () => other.isSingleInstance;
    }

    if (noHistory != other.noHistory) {
      diff['noHistory'] = () => other.noHistory;
    }

    if (isTrustedWebActivity != other.isTrustedWebActivity) {
      diff['isTrustedWebActivity'] = () => other.isTrustedWebActivity;
    }

    if (additionalTrustedOrigins != other.additionalTrustedOrigins) {
      diff['additionalTrustedOrigins'] = () => other.additionalTrustedOrigins;
    }

    if (displayMode != other.displayMode) {
      diff['displayMode'] = () => other.displayMode;
    }

    if (screenOrientation != other.screenOrientation) {
      diff['screenOrientation'] = () => other.screenOrientation;
    }

    if (startAnimations != other.startAnimations) {
      diff['startAnimations'] = () => other.startAnimations;
    }

    if (exitAnimations != other.exitAnimations) {
      diff['exitAnimations'] = () => other.exitAnimations;
    }

    if (alwaysUseBrowserUI != other.alwaysUseBrowserUI) {
      diff['alwaysUseBrowserUI'] = () => other.alwaysUseBrowserUI;
    }

    if (entersReaderIfAvailable != other.entersReaderIfAvailable) {
      diff['entersReaderIfAvailable'] = () => other.entersReaderIfAvailable;
    }

    if (barCollapsingEnabled != other.barCollapsingEnabled) {
      diff['barCollapsingEnabled'] = () => other.barCollapsingEnabled;
    }

    if (dismissButtonStyle != other.dismissButtonStyle) {
      diff['dismissButtonStyle'] = () => other.dismissButtonStyle;
    }

    if (preferredBarTintColor != other.preferredBarTintColor) {
      diff['preferredBarTintColor'] = () => other.preferredBarTintColor;
    }

    if (preferredControlTintColor != other.preferredControlTintColor) {
      diff['preferredControlTintColor'] = () => other.preferredControlTintColor;
    }

    if (presentationStyle != other.presentationStyle) {
      diff['presentationStyle'] = () => other.presentationStyle;
    }

    if (transitionStyle != other.transitionStyle) {
      diff['transitionStyle'] = () => other.transitionStyle;
    }

    if (activityButton != other.activityButton) {
      diff['activityButton'] = () => other.activityButton;
    }

    if (eventAttribution != other.eventAttribution) {
      diff['eventAttribution'] = () => other.eventAttribution;
    }
    return diff;
  }
}
