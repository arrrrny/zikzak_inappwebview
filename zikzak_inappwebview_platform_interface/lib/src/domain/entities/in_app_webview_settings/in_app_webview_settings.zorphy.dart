// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'in_app_webview_settings.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class InAppWebViewSettings {
  InAppWebViewSettings({
    bool? this.useShouldOverrideUrlLoading,
    bool? this.useOnLoadResource,
    bool? this.useOnDownloadStart,
    String? userAgent,
    String? applicationNameForUserAgent,
    bool? javaScriptEnabled,
    bool? javaScriptCanOpenWindowsAutomatically,
    bool? mediaPlaybackRequiresUserGesture,
    int? this.minimumFontSize,
    bool? verticalScrollBarEnabled,
    bool? horizontalScrollBarEnabled,
    List<String>? resourceCustomSchemes,
    List<ContentBlocker>? contentBlockers,
    UserPreferredContentMode? preferredContentMode,
    bool? this.useShouldInterceptAjaxRequest,
    bool? interceptOnlyAsyncAjaxRequests,
    bool? this.useShouldInterceptFetchRequest,
    bool? incognito,
    bool? cacheEnabled,
    bool? transparentBackground,
    bool? disableVerticalScroll,
    bool? disableHorizontalScroll,
    bool? disableContextMenu,
    bool? this.stylusHandwritingEnabled,
    bool? supportZoom,
    bool? allowFileAccessFromFileURLs,
    bool? allowUniversalAccessFromFileURLs,
    bool? builtInZoomControls,
    bool? displayZoomControls,
    bool? databaseEnabled,
    bool? domStorageEnabled,
    bool? useWideViewPort,
    bool? safeBrowsingEnabled,
    MixedContentMode? this.mixedContentMode,
    bool? allowContentAccess,
    bool? allowFileAccess,
    bool? blockNetworkImage,
    bool? blockNetworkLoads,
    CacheMode? cacheMode,
    String? cursiveFontFamily,
    int? defaultFixedFontSize,
    int? defaultFontSize,
    String? defaultTextEncodingName,
    ActionModeMenuItem? this.disabledActionModeMenuItems,
    String? fantasyFontFamily,
    String? fixedFontFamily,
    ForceDark? forceDark,
    ForceDarkStrategy? forceDarkStrategy,
    bool? geolocationEnabled,
    LayoutAlgorithm? this.layoutAlgorithm,
    bool? loadWithOverviewMode,
    bool? loadsImagesAutomatically,
    int? minimumLogicalFontSize,
    bool? needInitialFocus,
    bool? offscreenPreRaster,
    String? sansSerifFontFamily,
    String? serifFontFamily,
    String? standardFontFamily,
    bool? saveFormData,
    bool? thirdPartyCookiesEnabled,
    bool? hardwareAcceleration,
    int? initialScale,
    bool? supportMultipleWindows,
    String? this.regexToCancelSubFramesLoading,
    String? this.regexToCancelOverrideUrlLoading,
    bool? useHybridComposition,
    bool? this.useShouldInterceptRequest,
    bool? this.useOnRenderProcessGone,
    OverScrollMode? overScrollMode,
    bool? this.networkAvailable,
    ScrollBarStyle? scrollBarStyle,
    VerticalScrollbarPosition? verticalScrollbarPosition,
    int? this.scrollBarDefaultDelayBeforeFade,
    bool? scrollbarFadingEnabled,
    int? this.scrollBarFadeDuration,
    RendererPriorityPolicy? this.rendererPriorityPolicy,
    bool? disableDefaultErrorPage,
    Color? this.verticalScrollbarThumbColor,
    Color? this.verticalScrollbarTrackColor,
    Color? this.horizontalScrollbarThumbColor,
    Color? this.horizontalScrollbarTrackColor,
    bool? algorithmicDarkeningAllowed,
    bool? this.paymentRequestEnabled,
    WebAuthenticationSupport? this.webAuthenticationSupport,
    bool? enterpriseAuthenticationAppLinkPolicyEnabled,
    Uint8List? this.defaultVideoPoster,
    Set<String>? this.requestedWithHeaderOriginAllowList,
    bool? disallowOverScroll,
    bool? enableViewportScale,
    bool? suppressesIncrementalRendering,
    bool? allowsAirPlayForMediaPlayback,
    bool? allowsBackForwardNavigationGestures,
    bool? allowsLinkPreview,
    bool? ignoresViewportScaleLimits,
    bool? allowsInlineMediaPlayback,
    bool? allowsPictureInPictureMediaPlayback,
    bool? isFraudulentWebsiteWarningEnabled,
    SelectionGranularity? selectionGranularity,
    List<DataDetectorTypes>? this.dataDetectorTypes,
    bool? sharedCookiesEnabled,
    bool? automaticallyAdjustsScrollIndicatorInsets,
    bool? accessibilityIgnoresInvertColors,
    ScrollViewDecelerationRate? decelerationRate,
    bool? alwaysBounceVertical,
    bool? alwaysBounceHorizontal,
    bool? this.bouncesHorizontally,
    bool? this.bouncesVertically,
    bool? scrollsToTop,
    bool? isPagingEnabled,
    double? maximumZoomScale,
    double? minimumZoomScale,
    ScrollViewContentInsetAdjustmentBehavior? contentInsetAdjustmentBehavior,
    bool? isDirectionalLockEnabled,
    String? this.mediaType,
    double? pageZoom,
    bool? limitsNavigationsToAppBoundDomains,
    bool? this.useOnNavigationResponse,
    bool? applePayAPIEnabled,
    WebUri? this.allowingReadAccessTo,
    bool? disableLongPressContextMenuOnLinks,
    bool? disableInputAccessoryView,
    Color? this.underPageBackgroundColor,
    bool? isTextInteractionEnabled,
    bool? isSiteSpecificQuirksModeEnabled,
    bool? upgradeKnownHostsToHTTPS,
    bool? isElementFullscreenEnabled,
    bool? isFindInteractionEnabled,
    EdgeInsets? this.minimumViewportInset,
    EdgeInsets? this.maximumViewportInset,
    bool? isInspectable,
    bool? shouldPrintBackgrounds,
    bool? allowBackgroundAudioPlaying,
    WebViewAssetLoader? this.webViewAssetLoader,
    String? this.iframeAllow,
    bool? this.iframeAllowFullscreen,
    Set<Sandbox>? this.iframeSandbox,
    ReferrerPolicy? this.iframeReferrerPolicy,
    String? this.iframeName,
    String? this.iframeCsp,
    bool? dismissDialogues,
    List<AndroidWebViewInsets>? this.insetsForWebContentToIgnore,
    bool? this.useNetworkCapture,
    int? networkCaptureMaxBodySize,
    bool? networkCaptureBodies,
    bool? networkCaptureBinaryBodies,
    List<String>? networkCaptureUrlPatterns,
    UrlPatternType? this.networkCaptureUrlPatternType,
    List<ResourceType>? this.networkCaptureResourceTypes,
    List<String>? networkCaptureMimeTypes,
    NetworkCaptureController? this.networkCapture,
  }) : this.userAgent = userAgent ?? "",
       this.applicationNameForUserAgent = applicationNameForUserAgent ?? "",
       this.javaScriptEnabled = javaScriptEnabled ?? true,
       this.javaScriptCanOpenWindowsAutomatically =
           javaScriptCanOpenWindowsAutomatically ?? false,
       this.mediaPlaybackRequiresUserGesture =
           mediaPlaybackRequiresUserGesture ?? true,
       this.verticalScrollBarEnabled = verticalScrollBarEnabled ?? true,
       this.horizontalScrollBarEnabled = horizontalScrollBarEnabled ?? true,
       this.resourceCustomSchemes = resourceCustomSchemes ?? const [],
       this.contentBlockers = contentBlockers ?? const [],
       this.preferredContentMode =
           preferredContentMode ?? UserPreferredContentMode.RECOMMENDED,
       this.interceptOnlyAsyncAjaxRequests =
           interceptOnlyAsyncAjaxRequests ?? true,
       this.incognito = incognito ?? false,
       this.cacheEnabled = cacheEnabled ?? true,
       this.transparentBackground = transparentBackground ?? false,
       this.disableVerticalScroll = disableVerticalScroll ?? false,
       this.disableHorizontalScroll = disableHorizontalScroll ?? false,
       this.disableContextMenu = disableContextMenu ?? false,
       this.supportZoom = supportZoom ?? true,
       this.allowFileAccessFromFileURLs = allowFileAccessFromFileURLs ?? false,
       this.allowUniversalAccessFromFileURLs =
           allowUniversalAccessFromFileURLs ?? false,
       this.builtInZoomControls = builtInZoomControls ?? true,
       this.displayZoomControls = displayZoomControls ?? false,
       this.databaseEnabled = databaseEnabled ?? true,
       this.domStorageEnabled = domStorageEnabled ?? true,
       this.useWideViewPort = useWideViewPort ?? true,
       this.safeBrowsingEnabled = safeBrowsingEnabled ?? true,
       this.allowContentAccess = allowContentAccess ?? true,
       this.allowFileAccess = allowFileAccess ?? true,
       this.blockNetworkImage = blockNetworkImage ?? false,
       this.blockNetworkLoads = blockNetworkLoads ?? false,
       this.cacheMode = cacheMode ?? CacheMode.LOAD_DEFAULT,
       this.cursiveFontFamily = cursiveFontFamily ?? "cursive",
       this.defaultFixedFontSize = defaultFixedFontSize ?? 16,
       this.defaultFontSize = defaultFontSize ?? 16,
       this.defaultTextEncodingName = defaultTextEncodingName ?? "UTF-8",
       this.fantasyFontFamily = fantasyFontFamily ?? "fantasy",
       this.fixedFontFamily = fixedFontFamily ?? "monospace",
       this.forceDark = forceDark ?? ForceDark.OFF,
       this.forceDarkStrategy =
           forceDarkStrategy ??
           ForceDarkStrategy.PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING,
       this.geolocationEnabled = geolocationEnabled ?? true,
       this.loadWithOverviewMode = loadWithOverviewMode ?? true,
       this.loadsImagesAutomatically = loadsImagesAutomatically ?? true,
       this.minimumLogicalFontSize = minimumLogicalFontSize ?? 8,
       this.needInitialFocus = needInitialFocus ?? true,
       this.offscreenPreRaster = offscreenPreRaster ?? false,
       this.sansSerifFontFamily = sansSerifFontFamily ?? "sans-serif",
       this.serifFontFamily = serifFontFamily ?? "sans-serif",
       this.standardFontFamily = standardFontFamily ?? "sans-serif",
       this.saveFormData = saveFormData ?? true,
       this.thirdPartyCookiesEnabled = thirdPartyCookiesEnabled ?? true,
       this.hardwareAcceleration = hardwareAcceleration ?? true,
       this.initialScale = initialScale ?? 0,
       this.supportMultipleWindows = supportMultipleWindows ?? false,
       this.useHybridComposition = useHybridComposition ?? true,
       this.overScrollMode =
           overScrollMode ?? OverScrollMode.IF_CONTENT_SCROLLS,
       this.scrollBarStyle =
           scrollBarStyle ?? ScrollBarStyle.SCROLLBARS_INSIDE_OVERLAY,
       this.verticalScrollbarPosition =
           verticalScrollbarPosition ??
           VerticalScrollbarPosition.SCROLLBAR_POSITION_DEFAULT,
       this.scrollbarFadingEnabled = scrollbarFadingEnabled ?? true,
       this.disableDefaultErrorPage = disableDefaultErrorPage ?? false,
       this.algorithmicDarkeningAllowed = algorithmicDarkeningAllowed ?? false,
       this.enterpriseAuthenticationAppLinkPolicyEnabled =
           enterpriseAuthenticationAppLinkPolicyEnabled ?? true,
       this.disallowOverScroll = disallowOverScroll ?? false,
       this.enableViewportScale = enableViewportScale ?? false,
       this.suppressesIncrementalRendering =
           suppressesIncrementalRendering ?? false,
       this.allowsAirPlayForMediaPlayback =
           allowsAirPlayForMediaPlayback ?? true,
       this.allowsBackForwardNavigationGestures =
           allowsBackForwardNavigationGestures ?? true,
       this.allowsLinkPreview = allowsLinkPreview ?? true,
       this.ignoresViewportScaleLimits = ignoresViewportScaleLimits ?? false,
       this.allowsInlineMediaPlayback = allowsInlineMediaPlayback ?? false,
       this.allowsPictureInPictureMediaPlayback =
           allowsPictureInPictureMediaPlayback ?? true,
       this.isFraudulentWebsiteWarningEnabled =
           isFraudulentWebsiteWarningEnabled ?? true,
       this.selectionGranularity =
           selectionGranularity ?? SelectionGranularity.DYNAMIC,
       this.sharedCookiesEnabled = sharedCookiesEnabled ?? false,
       this.automaticallyAdjustsScrollIndicatorInsets =
           automaticallyAdjustsScrollIndicatorInsets ?? false,
       this.accessibilityIgnoresInvertColors =
           accessibilityIgnoresInvertColors ?? false,
       this.decelerationRate =
           decelerationRate ?? ScrollViewDecelerationRate.NORMAL,
       this.alwaysBounceVertical = alwaysBounceVertical ?? false,
       this.alwaysBounceHorizontal = alwaysBounceHorizontal ?? false,
       this.scrollsToTop = scrollsToTop ?? true,
       this.isPagingEnabled = isPagingEnabled ?? false,
       this.maximumZoomScale = maximumZoomScale ?? 1.0,
       this.minimumZoomScale = minimumZoomScale ?? 1.0,
       this.contentInsetAdjustmentBehavior =
           contentInsetAdjustmentBehavior ??
           ScrollViewContentInsetAdjustmentBehavior.NEVER,
       this.isDirectionalLockEnabled = isDirectionalLockEnabled ?? false,
       this.pageZoom = pageZoom ?? 1.0,
       this.limitsNavigationsToAppBoundDomains =
           limitsNavigationsToAppBoundDomains ?? false,
       this.applePayAPIEnabled = applePayAPIEnabled ?? false,
       this.disableLongPressContextMenuOnLinks =
           disableLongPressContextMenuOnLinks ?? false,
       this.disableInputAccessoryView = disableInputAccessoryView ?? false,
       this.isTextInteractionEnabled = isTextInteractionEnabled ?? true,
       this.isSiteSpecificQuirksModeEnabled =
           isSiteSpecificQuirksModeEnabled ?? true,
       this.upgradeKnownHostsToHTTPS = upgradeKnownHostsToHTTPS ?? true,
       this.isElementFullscreenEnabled = isElementFullscreenEnabled ?? true,
       this.isFindInteractionEnabled = isFindInteractionEnabled ?? false,
       this.isInspectable = isInspectable ?? false,
       this.shouldPrintBackgrounds = shouldPrintBackgrounds ?? false,
       this.allowBackgroundAudioPlaying = allowBackgroundAudioPlaying ?? false,
       this.dismissDialogues = dismissDialogues ?? false,
       this.networkCaptureMaxBodySize = networkCaptureMaxBodySize ?? 50000,
       this.networkCaptureBodies = networkCaptureBodies ?? true,
       this.networkCaptureBinaryBodies = networkCaptureBinaryBodies ?? false,
       this.networkCaptureUrlPatterns = networkCaptureUrlPatterns ?? const [],
       this.networkCaptureMimeTypes = networkCaptureMimeTypes ?? const [];

  factory InAppWebViewSettings.fromJson(Map<String, dynamic> json) =>
      _$InAppWebViewSettingsFromJson(json);

  final bool? useShouldOverrideUrlLoading;

  final bool? useOnLoadResource;

  final bool? useOnDownloadStart;

  @JsonKey(defaultValue: "")
  final String? userAgent;

  @JsonKey(defaultValue: "")
  final String? applicationNameForUserAgent;

  @JsonKey(defaultValue: true)
  final bool? javaScriptEnabled;

  @JsonKey(defaultValue: false)
  final bool? javaScriptCanOpenWindowsAutomatically;

  @JsonKey(defaultValue: true)
  final bool? mediaPlaybackRequiresUserGesture;

  final int? minimumFontSize;

  @JsonKey(defaultValue: true)
  final bool? verticalScrollBarEnabled;

  @JsonKey(defaultValue: true)
  final bool? horizontalScrollBarEnabled;

  @JsonKey(defaultValue: const [])
  final List<String>? resourceCustomSchemes;

  @JsonKey(
    defaultValue: const [],
    toJson: _serializeContentBlockers,
    fromJson: _deserializeContentBlockers,
  )
  final List<ContentBlocker>? contentBlockers;

  @JsonKey(
    defaultValue: UserPreferredContentMode.RECOMMENDED,
    toJson: userPreferredContentModeToWire,
    fromJson: userPreferredContentModeFromWire,
  )
  final UserPreferredContentMode? preferredContentMode;

  final bool? useShouldInterceptAjaxRequest;

  @JsonKey(defaultValue: true)
  final bool? interceptOnlyAsyncAjaxRequests;

  final bool? useShouldInterceptFetchRequest;

  @JsonKey(defaultValue: false)
  final bool? incognito;

  @JsonKey(defaultValue: true)
  final bool? cacheEnabled;

  @JsonKey(defaultValue: false)
  final bool? transparentBackground;

  @JsonKey(defaultValue: false)
  final bool? disableVerticalScroll;

  @JsonKey(defaultValue: false)
  final bool? disableHorizontalScroll;

  @JsonKey(defaultValue: false)
  final bool? disableContextMenu;

  final bool? stylusHandwritingEnabled;

  @JsonKey(defaultValue: true)
  final bool? supportZoom;

  @JsonKey(defaultValue: false)
  final bool? allowFileAccessFromFileURLs;

  @JsonKey(defaultValue: false)
  final bool? allowUniversalAccessFromFileURLs;

  @JsonKey(defaultValue: true)
  final bool? builtInZoomControls;

  @JsonKey(defaultValue: false)
  final bool? displayZoomControls;

  @JsonKey(defaultValue: true)
  final bool? databaseEnabled;

  @JsonKey(defaultValue: true)
  final bool? domStorageEnabled;

  @JsonKey(defaultValue: true)
  final bool? useWideViewPort;

  @JsonKey(defaultValue: true)
  final bool? safeBrowsingEnabled;

  @JsonKey(toJson: mixedContentModeToWire, fromJson: mixedContentModeFromWire)
  final MixedContentMode? mixedContentMode;

  @JsonKey(defaultValue: true)
  final bool? allowContentAccess;

  @JsonKey(defaultValue: true)
  final bool? allowFileAccess;

  @JsonKey(defaultValue: false)
  final bool? blockNetworkImage;

  @JsonKey(defaultValue: false)
  final bool? blockNetworkLoads;

  @JsonKey(
    defaultValue: CacheMode.LOAD_DEFAULT,
    toJson: cacheModeToWire,
    fromJson: cacheModeFromWire,
  )
  final CacheMode? cacheMode;

  @JsonKey(defaultValue: "cursive")
  final String? cursiveFontFamily;

  @JsonKey(defaultValue: 16)
  final int? defaultFixedFontSize;

  @JsonKey(defaultValue: 16)
  final int? defaultFontSize;

  @JsonKey(defaultValue: "UTF-8")
  final String? defaultTextEncodingName;

  @JsonKey(
    toJson: actionModeMenuItemToWire,
    fromJson: actionModeMenuItemFromWire,
  )
  final ActionModeMenuItem? disabledActionModeMenuItems;

  @JsonKey(defaultValue: "fantasy")
  final String? fantasyFontFamily;

  @JsonKey(defaultValue: "monospace")
  final String? fixedFontFamily;

  @JsonKey(
    defaultValue: ForceDark.OFF,
    toJson: forceDarkToWire,
    fromJson: forceDarkFromWire,
  )
  final ForceDark? forceDark;

  @JsonKey(
    defaultValue: ForceDarkStrategy.PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING,
    toJson: forceDarkStrategyToWire,
    fromJson: forceDarkStrategyFromWire,
  )
  final ForceDarkStrategy? forceDarkStrategy;

  @JsonKey(defaultValue: true)
  final bool? geolocationEnabled;

  final LayoutAlgorithm? layoutAlgorithm;

  @JsonKey(defaultValue: true)
  final bool? loadWithOverviewMode;

  @JsonKey(defaultValue: true)
  final bool? loadsImagesAutomatically;

  @JsonKey(defaultValue: 8)
  final int? minimumLogicalFontSize;

  @JsonKey(defaultValue: true)
  final bool? needInitialFocus;

  @JsonKey(defaultValue: false)
  final bool? offscreenPreRaster;

  @JsonKey(defaultValue: "sans-serif")
  final String? sansSerifFontFamily;

  @JsonKey(defaultValue: "sans-serif")
  final String? serifFontFamily;

  @JsonKey(defaultValue: "sans-serif")
  final String? standardFontFamily;

  @JsonKey(defaultValue: true)
  final bool? saveFormData;

  @JsonKey(defaultValue: true)
  final bool? thirdPartyCookiesEnabled;

  @JsonKey(defaultValue: true)
  final bool? hardwareAcceleration;

  @JsonKey(defaultValue: 0)
  final int? initialScale;

  @JsonKey(defaultValue: false)
  final bool? supportMultipleWindows;

  final String? regexToCancelSubFramesLoading;

  final String? regexToCancelOverrideUrlLoading;

  @JsonKey(defaultValue: true)
  final bool? useHybridComposition;

  final bool? useShouldInterceptRequest;

  final bool? useOnRenderProcessGone;

  @JsonKey(
    defaultValue: OverScrollMode.IF_CONTENT_SCROLLS,
    toJson: overScrollModeToWire,
    fromJson: overScrollModeFromWire,
  )
  final OverScrollMode? overScrollMode;

  final bool? networkAvailable;

  @JsonKey(
    defaultValue: ScrollBarStyle.SCROLLBARS_INSIDE_OVERLAY,
    toJson: scrollBarStyleToWire,
    fromJson: scrollBarStyleFromWire,
  )
  final ScrollBarStyle? scrollBarStyle;

  @JsonKey(
    defaultValue: VerticalScrollbarPosition.SCROLLBAR_POSITION_DEFAULT,
    toJson: verticalScrollbarPositionToWire,
    fromJson: verticalScrollbarPositionFromWire,
  )
  final VerticalScrollbarPosition? verticalScrollbarPosition;

  final int? scrollBarDefaultDelayBeforeFade;

  @JsonKey(defaultValue: true)
  final bool? scrollbarFadingEnabled;

  final int? scrollBarFadeDuration;

  final RendererPriorityPolicy? rendererPriorityPolicy;

  @JsonKey(defaultValue: false)
  final bool? disableDefaultErrorPage;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? verticalScrollbarThumbColor;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? verticalScrollbarTrackColor;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? horizontalScrollbarThumbColor;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? horizontalScrollbarTrackColor;

  @JsonKey(defaultValue: false)
  final bool? algorithmicDarkeningAllowed;

  final bool? paymentRequestEnabled;

  @JsonKey(
    toJson: webAuthenticationSupportToWire,
    fromJson: webAuthenticationSupportFromWire,
  )
  final WebAuthenticationSupport? webAuthenticationSupport;

  @JsonKey(defaultValue: true)
  final bool? enterpriseAuthenticationAppLinkPolicyEnabled;

  @JsonKey(
    toJson: _defaultVideoPosterToJson,
    fromJson: _defaultVideoPosterFromJson,
  )
  final Uint8List? defaultVideoPoster;

  final Set<String>? requestedWithHeaderOriginAllowList;

  @JsonKey(defaultValue: false)
  final bool? disallowOverScroll;

  @JsonKey(defaultValue: false)
  final bool? enableViewportScale;

  @JsonKey(defaultValue: false)
  final bool? suppressesIncrementalRendering;

  @JsonKey(defaultValue: true)
  final bool? allowsAirPlayForMediaPlayback;

  @JsonKey(defaultValue: true)
  final bool? allowsBackForwardNavigationGestures;

  @JsonKey(defaultValue: true)
  final bool? allowsLinkPreview;

  @JsonKey(defaultValue: false)
  final bool? ignoresViewportScaleLimits;

  @JsonKey(defaultValue: false)
  final bool? allowsInlineMediaPlayback;

  @JsonKey(defaultValue: true)
  final bool? allowsPictureInPictureMediaPlayback;

  @JsonKey(defaultValue: true)
  final bool? isFraudulentWebsiteWarningEnabled;

  @JsonKey(defaultValue: SelectionGranularity.DYNAMIC)
  final SelectionGranularity? selectionGranularity;

  final List<DataDetectorTypes>? dataDetectorTypes;

  @JsonKey(defaultValue: false)
  final bool? sharedCookiesEnabled;

  @JsonKey(defaultValue: false)
  final bool? automaticallyAdjustsScrollIndicatorInsets;

  @JsonKey(defaultValue: false)
  final bool? accessibilityIgnoresInvertColors;

  @JsonKey(defaultValue: ScrollViewDecelerationRate.NORMAL)
  final ScrollViewDecelerationRate? decelerationRate;

  @JsonKey(defaultValue: false)
  final bool? alwaysBounceVertical;

  @JsonKey(defaultValue: false)
  final bool? alwaysBounceHorizontal;

  final bool? bouncesHorizontally;

  final bool? bouncesVertically;

  @JsonKey(defaultValue: true)
  final bool? scrollsToTop;

  @JsonKey(defaultValue: false)
  final bool? isPagingEnabled;

  @JsonKey(defaultValue: 1.0)
  final double? maximumZoomScale;

  @JsonKey(defaultValue: 1.0)
  final double? minimumZoomScale;

  @JsonKey(defaultValue: ScrollViewContentInsetAdjustmentBehavior.NEVER)
  final ScrollViewContentInsetAdjustmentBehavior?
  contentInsetAdjustmentBehavior;

  @JsonKey(defaultValue: false)
  final bool? isDirectionalLockEnabled;

  final String? mediaType;

  @JsonKey(defaultValue: 1.0)
  final double? pageZoom;

  @JsonKey(defaultValue: false)
  final bool? limitsNavigationsToAppBoundDomains;

  final bool? useOnNavigationResponse;

  @JsonKey(defaultValue: false)
  final bool? applePayAPIEnabled;

  @JsonKey(
    toJson: _allowingReadAccessToToJson,
    fromJson: _allowingReadAccessToFromJson,
  )
  final WebUri? allowingReadAccessTo;

  @JsonKey(defaultValue: false)
  final bool? disableLongPressContextMenuOnLinks;

  @JsonKey(defaultValue: false)
  final bool? disableInputAccessoryView;

  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? underPageBackgroundColor;

  @JsonKey(defaultValue: true)
  final bool? isTextInteractionEnabled;

  @JsonKey(defaultValue: true)
  final bool? isSiteSpecificQuirksModeEnabled;

  @JsonKey(defaultValue: true)
  final bool? upgradeKnownHostsToHTTPS;

  @JsonKey(defaultValue: true)
  final bool? isElementFullscreenEnabled;

  @JsonKey(defaultValue: false)
  final bool? isFindInteractionEnabled;

  @JsonKey(
    toJson: _minimumViewportInsetToJson,
    fromJson: _minimumViewportInsetFromJson,
  )
  final EdgeInsets? minimumViewportInset;

  @JsonKey(
    toJson: _maximumViewportInsetToJson,
    fromJson: _maximumViewportInsetFromJson,
  )
  final EdgeInsets? maximumViewportInset;

  @JsonKey(defaultValue: false)
  final bool? isInspectable;

  @JsonKey(defaultValue: false)
  final bool? shouldPrintBackgrounds;

  @JsonKey(defaultValue: false)
  final bool? allowBackgroundAudioPlaying;

  final WebViewAssetLoader? webViewAssetLoader;

  final String? iframeAllow;

  final bool? iframeAllowFullscreen;

  @JsonKey(toJson: _iframeSandboxToJson, fromJson: _iframeSandboxFromJson)
  final Set<Sandbox>? iframeSandbox;

  final ReferrerPolicy? iframeReferrerPolicy;

  final String? iframeName;

  final String? iframeCsp;

  @JsonKey(defaultValue: false)
  final bool? dismissDialogues;

  @JsonKey(toJson: _insetsToJson, fromJson: _insetsFromJson)
  final List<AndroidWebViewInsets>? insetsForWebContentToIgnore;

  final bool? useNetworkCapture;

  @JsonKey(defaultValue: 50000)
  final int? networkCaptureMaxBodySize;

  @JsonKey(defaultValue: true)
  final bool? networkCaptureBodies;

  @JsonKey(defaultValue: false)
  final bool? networkCaptureBinaryBodies;

  @JsonKey(defaultValue: const [])
  final List<String>? networkCaptureUrlPatterns;

  @JsonKey(toJson: _urlPatternTypeToJson, fromJson: _urlPatternTypeFromJson)
  final UrlPatternType? networkCaptureUrlPatternType;

  @JsonKey(toJson: _resourceTypesToJson, fromJson: _resourceTypesFromJson)
  final List<ResourceType>? networkCaptureResourceTypes;

  @JsonKey(defaultValue: const [])
  final List<String>? networkCaptureMimeTypes;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final NetworkCaptureController? networkCapture;

  InAppWebViewSettings copyWith({
    bool? useShouldOverrideUrlLoading,
    bool? useOnLoadResource,
    bool? useOnDownloadStart,
    String? userAgent,
    String? applicationNameForUserAgent,
    bool? javaScriptEnabled,
    bool? javaScriptCanOpenWindowsAutomatically,
    bool? mediaPlaybackRequiresUserGesture,
    int? minimumFontSize,
    bool? verticalScrollBarEnabled,
    bool? horizontalScrollBarEnabled,
    List<String>? resourceCustomSchemes,
    List<ContentBlocker>? contentBlockers,
    UserPreferredContentMode? preferredContentMode,
    bool? useShouldInterceptAjaxRequest,
    bool? interceptOnlyAsyncAjaxRequests,
    bool? useShouldInterceptFetchRequest,
    bool? incognito,
    bool? cacheEnabled,
    bool? transparentBackground,
    bool? disableVerticalScroll,
    bool? disableHorizontalScroll,
    bool? disableContextMenu,
    bool? stylusHandwritingEnabled,
    bool? supportZoom,
    bool? allowFileAccessFromFileURLs,
    bool? allowUniversalAccessFromFileURLs,
    bool? builtInZoomControls,
    bool? displayZoomControls,
    bool? databaseEnabled,
    bool? domStorageEnabled,
    bool? useWideViewPort,
    bool? safeBrowsingEnabled,
    MixedContentMode? mixedContentMode,
    bool? allowContentAccess,
    bool? allowFileAccess,
    bool? blockNetworkImage,
    bool? blockNetworkLoads,
    CacheMode? cacheMode,
    String? cursiveFontFamily,
    int? defaultFixedFontSize,
    int? defaultFontSize,
    String? defaultTextEncodingName,
    ActionModeMenuItem? disabledActionModeMenuItems,
    String? fantasyFontFamily,
    String? fixedFontFamily,
    ForceDark? forceDark,
    ForceDarkStrategy? forceDarkStrategy,
    bool? geolocationEnabled,
    LayoutAlgorithm? layoutAlgorithm,
    bool? loadWithOverviewMode,
    bool? loadsImagesAutomatically,
    int? minimumLogicalFontSize,
    bool? needInitialFocus,
    bool? offscreenPreRaster,
    String? sansSerifFontFamily,
    String? serifFontFamily,
    String? standardFontFamily,
    bool? saveFormData,
    bool? thirdPartyCookiesEnabled,
    bool? hardwareAcceleration,
    int? initialScale,
    bool? supportMultipleWindows,
    String? regexToCancelSubFramesLoading,
    String? regexToCancelOverrideUrlLoading,
    bool? useHybridComposition,
    bool? useShouldInterceptRequest,
    bool? useOnRenderProcessGone,
    OverScrollMode? overScrollMode,
    bool? networkAvailable,
    ScrollBarStyle? scrollBarStyle,
    VerticalScrollbarPosition? verticalScrollbarPosition,
    int? scrollBarDefaultDelayBeforeFade,
    bool? scrollbarFadingEnabled,
    int? scrollBarFadeDuration,
    RendererPriorityPolicy? rendererPriorityPolicy,
    bool? disableDefaultErrorPage,
    Color? verticalScrollbarThumbColor,
    Color? verticalScrollbarTrackColor,
    Color? horizontalScrollbarThumbColor,
    Color? horizontalScrollbarTrackColor,
    bool? algorithmicDarkeningAllowed,
    bool? paymentRequestEnabled,
    WebAuthenticationSupport? webAuthenticationSupport,
    bool? enterpriseAuthenticationAppLinkPolicyEnabled,
    Uint8List? defaultVideoPoster,
    Set<String>? requestedWithHeaderOriginAllowList,
    bool? disallowOverScroll,
    bool? enableViewportScale,
    bool? suppressesIncrementalRendering,
    bool? allowsAirPlayForMediaPlayback,
    bool? allowsBackForwardNavigationGestures,
    bool? allowsLinkPreview,
    bool? ignoresViewportScaleLimits,
    bool? allowsInlineMediaPlayback,
    bool? allowsPictureInPictureMediaPlayback,
    bool? isFraudulentWebsiteWarningEnabled,
    SelectionGranularity? selectionGranularity,
    List<DataDetectorTypes>? dataDetectorTypes,
    bool? sharedCookiesEnabled,
    bool? automaticallyAdjustsScrollIndicatorInsets,
    bool? accessibilityIgnoresInvertColors,
    ScrollViewDecelerationRate? decelerationRate,
    bool? alwaysBounceVertical,
    bool? alwaysBounceHorizontal,
    bool? bouncesHorizontally,
    bool? bouncesVertically,
    bool? scrollsToTop,
    bool? isPagingEnabled,
    double? maximumZoomScale,
    double? minimumZoomScale,
    ScrollViewContentInsetAdjustmentBehavior? contentInsetAdjustmentBehavior,
    bool? isDirectionalLockEnabled,
    String? mediaType,
    double? pageZoom,
    bool? limitsNavigationsToAppBoundDomains,
    bool? useOnNavigationResponse,
    bool? applePayAPIEnabled,
    WebUri? allowingReadAccessTo,
    bool? disableLongPressContextMenuOnLinks,
    bool? disableInputAccessoryView,
    Color? underPageBackgroundColor,
    bool? isTextInteractionEnabled,
    bool? isSiteSpecificQuirksModeEnabled,
    bool? upgradeKnownHostsToHTTPS,
    bool? isElementFullscreenEnabled,
    bool? isFindInteractionEnabled,
    EdgeInsets? minimumViewportInset,
    EdgeInsets? maximumViewportInset,
    bool? isInspectable,
    bool? shouldPrintBackgrounds,
    bool? allowBackgroundAudioPlaying,
    WebViewAssetLoader? webViewAssetLoader,
    String? iframeAllow,
    bool? iframeAllowFullscreen,
    Set<Sandbox>? iframeSandbox,
    ReferrerPolicy? iframeReferrerPolicy,
    String? iframeName,
    String? iframeCsp,
    bool? dismissDialogues,
    List<AndroidWebViewInsets>? insetsForWebContentToIgnore,
    bool? useNetworkCapture,
    int? networkCaptureMaxBodySize,
    bool? networkCaptureBodies,
    bool? networkCaptureBinaryBodies,
    List<String>? networkCaptureUrlPatterns,
    UrlPatternType? networkCaptureUrlPatternType,
    List<ResourceType>? networkCaptureResourceTypes,
    List<String>? networkCaptureMimeTypes,
    NetworkCaptureController? networkCapture,
  }) {
    return InAppWebViewSettings(
      useShouldOverrideUrlLoading:
          useShouldOverrideUrlLoading ?? this.useShouldOverrideUrlLoading,
      useOnLoadResource: useOnLoadResource ?? this.useOnLoadResource,
      useOnDownloadStart: useOnDownloadStart ?? this.useOnDownloadStart,
      userAgent: userAgent ?? this.userAgent,
      applicationNameForUserAgent:
          applicationNameForUserAgent ?? this.applicationNameForUserAgent,
      javaScriptEnabled: javaScriptEnabled ?? this.javaScriptEnabled,
      javaScriptCanOpenWindowsAutomatically:
          javaScriptCanOpenWindowsAutomatically ??
          this.javaScriptCanOpenWindowsAutomatically,
      mediaPlaybackRequiresUserGesture:
          mediaPlaybackRequiresUserGesture ??
          this.mediaPlaybackRequiresUserGesture,
      minimumFontSize: minimumFontSize ?? this.minimumFontSize,
      verticalScrollBarEnabled:
          verticalScrollBarEnabled ?? this.verticalScrollBarEnabled,
      horizontalScrollBarEnabled:
          horizontalScrollBarEnabled ?? this.horizontalScrollBarEnabled,
      resourceCustomSchemes:
          resourceCustomSchemes ?? this.resourceCustomSchemes,
      contentBlockers: contentBlockers ?? this.contentBlockers,
      preferredContentMode: preferredContentMode ?? this.preferredContentMode,
      useShouldInterceptAjaxRequest:
          useShouldInterceptAjaxRequest ?? this.useShouldInterceptAjaxRequest,
      interceptOnlyAsyncAjaxRequests:
          interceptOnlyAsyncAjaxRequests ?? this.interceptOnlyAsyncAjaxRequests,
      useShouldInterceptFetchRequest:
          useShouldInterceptFetchRequest ?? this.useShouldInterceptFetchRequest,
      incognito: incognito ?? this.incognito,
      cacheEnabled: cacheEnabled ?? this.cacheEnabled,
      transparentBackground:
          transparentBackground ?? this.transparentBackground,
      disableVerticalScroll:
          disableVerticalScroll ?? this.disableVerticalScroll,
      disableHorizontalScroll:
          disableHorizontalScroll ?? this.disableHorizontalScroll,
      disableContextMenu: disableContextMenu ?? this.disableContextMenu,
      stylusHandwritingEnabled:
          stylusHandwritingEnabled ?? this.stylusHandwritingEnabled,
      supportZoom: supportZoom ?? this.supportZoom,
      allowFileAccessFromFileURLs:
          allowFileAccessFromFileURLs ?? this.allowFileAccessFromFileURLs,
      allowUniversalAccessFromFileURLs:
          allowUniversalAccessFromFileURLs ??
          this.allowUniversalAccessFromFileURLs,
      builtInZoomControls: builtInZoomControls ?? this.builtInZoomControls,
      displayZoomControls: displayZoomControls ?? this.displayZoomControls,
      databaseEnabled: databaseEnabled ?? this.databaseEnabled,
      domStorageEnabled: domStorageEnabled ?? this.domStorageEnabled,
      useWideViewPort: useWideViewPort ?? this.useWideViewPort,
      safeBrowsingEnabled: safeBrowsingEnabled ?? this.safeBrowsingEnabled,
      mixedContentMode: mixedContentMode ?? this.mixedContentMode,
      allowContentAccess: allowContentAccess ?? this.allowContentAccess,
      allowFileAccess: allowFileAccess ?? this.allowFileAccess,
      blockNetworkImage: blockNetworkImage ?? this.blockNetworkImage,
      blockNetworkLoads: blockNetworkLoads ?? this.blockNetworkLoads,
      cacheMode: cacheMode ?? this.cacheMode,
      cursiveFontFamily: cursiveFontFamily ?? this.cursiveFontFamily,
      defaultFixedFontSize: defaultFixedFontSize ?? this.defaultFixedFontSize,
      defaultFontSize: defaultFontSize ?? this.defaultFontSize,
      defaultTextEncodingName:
          defaultTextEncodingName ?? this.defaultTextEncodingName,
      disabledActionModeMenuItems:
          disabledActionModeMenuItems ?? this.disabledActionModeMenuItems,
      fantasyFontFamily: fantasyFontFamily ?? this.fantasyFontFamily,
      fixedFontFamily: fixedFontFamily ?? this.fixedFontFamily,
      forceDark: forceDark ?? this.forceDark,
      forceDarkStrategy: forceDarkStrategy ?? this.forceDarkStrategy,
      geolocationEnabled: geolocationEnabled ?? this.geolocationEnabled,
      layoutAlgorithm: layoutAlgorithm ?? this.layoutAlgorithm,
      loadWithOverviewMode: loadWithOverviewMode ?? this.loadWithOverviewMode,
      loadsImagesAutomatically:
          loadsImagesAutomatically ?? this.loadsImagesAutomatically,
      minimumLogicalFontSize:
          minimumLogicalFontSize ?? this.minimumLogicalFontSize,
      needInitialFocus: needInitialFocus ?? this.needInitialFocus,
      offscreenPreRaster: offscreenPreRaster ?? this.offscreenPreRaster,
      sansSerifFontFamily: sansSerifFontFamily ?? this.sansSerifFontFamily,
      serifFontFamily: serifFontFamily ?? this.serifFontFamily,
      standardFontFamily: standardFontFamily ?? this.standardFontFamily,
      saveFormData: saveFormData ?? this.saveFormData,
      thirdPartyCookiesEnabled:
          thirdPartyCookiesEnabled ?? this.thirdPartyCookiesEnabled,
      hardwareAcceleration: hardwareAcceleration ?? this.hardwareAcceleration,
      initialScale: initialScale ?? this.initialScale,
      supportMultipleWindows:
          supportMultipleWindows ?? this.supportMultipleWindows,
      regexToCancelSubFramesLoading:
          regexToCancelSubFramesLoading ?? this.regexToCancelSubFramesLoading,
      regexToCancelOverrideUrlLoading:
          regexToCancelOverrideUrlLoading ??
          this.regexToCancelOverrideUrlLoading,
      useHybridComposition: useHybridComposition ?? this.useHybridComposition,
      useShouldInterceptRequest:
          useShouldInterceptRequest ?? this.useShouldInterceptRequest,
      useOnRenderProcessGone:
          useOnRenderProcessGone ?? this.useOnRenderProcessGone,
      overScrollMode: overScrollMode ?? this.overScrollMode,
      networkAvailable: networkAvailable ?? this.networkAvailable,
      scrollBarStyle: scrollBarStyle ?? this.scrollBarStyle,
      verticalScrollbarPosition:
          verticalScrollbarPosition ?? this.verticalScrollbarPosition,
      scrollBarDefaultDelayBeforeFade:
          scrollBarDefaultDelayBeforeFade ??
          this.scrollBarDefaultDelayBeforeFade,
      scrollbarFadingEnabled:
          scrollbarFadingEnabled ?? this.scrollbarFadingEnabled,
      scrollBarFadeDuration:
          scrollBarFadeDuration ?? this.scrollBarFadeDuration,
      rendererPriorityPolicy:
          rendererPriorityPolicy ?? this.rendererPriorityPolicy,
      disableDefaultErrorPage:
          disableDefaultErrorPage ?? this.disableDefaultErrorPage,
      verticalScrollbarThumbColor:
          verticalScrollbarThumbColor ?? this.verticalScrollbarThumbColor,
      verticalScrollbarTrackColor:
          verticalScrollbarTrackColor ?? this.verticalScrollbarTrackColor,
      horizontalScrollbarThumbColor:
          horizontalScrollbarThumbColor ?? this.horizontalScrollbarThumbColor,
      horizontalScrollbarTrackColor:
          horizontalScrollbarTrackColor ?? this.horizontalScrollbarTrackColor,
      algorithmicDarkeningAllowed:
          algorithmicDarkeningAllowed ?? this.algorithmicDarkeningAllowed,
      paymentRequestEnabled:
          paymentRequestEnabled ?? this.paymentRequestEnabled,
      webAuthenticationSupport:
          webAuthenticationSupport ?? this.webAuthenticationSupport,
      enterpriseAuthenticationAppLinkPolicyEnabled:
          enterpriseAuthenticationAppLinkPolicyEnabled ??
          this.enterpriseAuthenticationAppLinkPolicyEnabled,
      defaultVideoPoster: defaultVideoPoster ?? this.defaultVideoPoster,
      requestedWithHeaderOriginAllowList:
          requestedWithHeaderOriginAllowList ??
          this.requestedWithHeaderOriginAllowList,
      disallowOverScroll: disallowOverScroll ?? this.disallowOverScroll,
      enableViewportScale: enableViewportScale ?? this.enableViewportScale,
      suppressesIncrementalRendering:
          suppressesIncrementalRendering ?? this.suppressesIncrementalRendering,
      allowsAirPlayForMediaPlayback:
          allowsAirPlayForMediaPlayback ?? this.allowsAirPlayForMediaPlayback,
      allowsBackForwardNavigationGestures:
          allowsBackForwardNavigationGestures ??
          this.allowsBackForwardNavigationGestures,
      allowsLinkPreview: allowsLinkPreview ?? this.allowsLinkPreview,
      ignoresViewportScaleLimits:
          ignoresViewportScaleLimits ?? this.ignoresViewportScaleLimits,
      allowsInlineMediaPlayback:
          allowsInlineMediaPlayback ?? this.allowsInlineMediaPlayback,
      allowsPictureInPictureMediaPlayback:
          allowsPictureInPictureMediaPlayback ??
          this.allowsPictureInPictureMediaPlayback,
      isFraudulentWebsiteWarningEnabled:
          isFraudulentWebsiteWarningEnabled ??
          this.isFraudulentWebsiteWarningEnabled,
      selectionGranularity: selectionGranularity ?? this.selectionGranularity,
      dataDetectorTypes: dataDetectorTypes ?? this.dataDetectorTypes,
      sharedCookiesEnabled: sharedCookiesEnabled ?? this.sharedCookiesEnabled,
      automaticallyAdjustsScrollIndicatorInsets:
          automaticallyAdjustsScrollIndicatorInsets ??
          this.automaticallyAdjustsScrollIndicatorInsets,
      accessibilityIgnoresInvertColors:
          accessibilityIgnoresInvertColors ??
          this.accessibilityIgnoresInvertColors,
      decelerationRate: decelerationRate ?? this.decelerationRate,
      alwaysBounceVertical: alwaysBounceVertical ?? this.alwaysBounceVertical,
      alwaysBounceHorizontal:
          alwaysBounceHorizontal ?? this.alwaysBounceHorizontal,
      bouncesHorizontally: bouncesHorizontally ?? this.bouncesHorizontally,
      bouncesVertically: bouncesVertically ?? this.bouncesVertically,
      scrollsToTop: scrollsToTop ?? this.scrollsToTop,
      isPagingEnabled: isPagingEnabled ?? this.isPagingEnabled,
      maximumZoomScale: maximumZoomScale ?? this.maximumZoomScale,
      minimumZoomScale: minimumZoomScale ?? this.minimumZoomScale,
      contentInsetAdjustmentBehavior:
          contentInsetAdjustmentBehavior ?? this.contentInsetAdjustmentBehavior,
      isDirectionalLockEnabled:
          isDirectionalLockEnabled ?? this.isDirectionalLockEnabled,
      mediaType: mediaType ?? this.mediaType,
      pageZoom: pageZoom ?? this.pageZoom,
      limitsNavigationsToAppBoundDomains:
          limitsNavigationsToAppBoundDomains ??
          this.limitsNavigationsToAppBoundDomains,
      useOnNavigationResponse:
          useOnNavigationResponse ?? this.useOnNavigationResponse,
      applePayAPIEnabled: applePayAPIEnabled ?? this.applePayAPIEnabled,
      allowingReadAccessTo: allowingReadAccessTo ?? this.allowingReadAccessTo,
      disableLongPressContextMenuOnLinks:
          disableLongPressContextMenuOnLinks ??
          this.disableLongPressContextMenuOnLinks,
      disableInputAccessoryView:
          disableInputAccessoryView ?? this.disableInputAccessoryView,
      underPageBackgroundColor:
          underPageBackgroundColor ?? this.underPageBackgroundColor,
      isTextInteractionEnabled:
          isTextInteractionEnabled ?? this.isTextInteractionEnabled,
      isSiteSpecificQuirksModeEnabled:
          isSiteSpecificQuirksModeEnabled ??
          this.isSiteSpecificQuirksModeEnabled,
      upgradeKnownHostsToHTTPS:
          upgradeKnownHostsToHTTPS ?? this.upgradeKnownHostsToHTTPS,
      isElementFullscreenEnabled:
          isElementFullscreenEnabled ?? this.isElementFullscreenEnabled,
      isFindInteractionEnabled:
          isFindInteractionEnabled ?? this.isFindInteractionEnabled,
      minimumViewportInset: minimumViewportInset ?? this.minimumViewportInset,
      maximumViewportInset: maximumViewportInset ?? this.maximumViewportInset,
      isInspectable: isInspectable ?? this.isInspectable,
      shouldPrintBackgrounds:
          shouldPrintBackgrounds ?? this.shouldPrintBackgrounds,
      allowBackgroundAudioPlaying:
          allowBackgroundAudioPlaying ?? this.allowBackgroundAudioPlaying,
      webViewAssetLoader: webViewAssetLoader ?? this.webViewAssetLoader,
      iframeAllow: iframeAllow ?? this.iframeAllow,
      iframeAllowFullscreen:
          iframeAllowFullscreen ?? this.iframeAllowFullscreen,
      iframeSandbox: iframeSandbox ?? this.iframeSandbox,
      iframeReferrerPolicy: iframeReferrerPolicy ?? this.iframeReferrerPolicy,
      iframeName: iframeName ?? this.iframeName,
      iframeCsp: iframeCsp ?? this.iframeCsp,
      dismissDialogues: dismissDialogues ?? this.dismissDialogues,
      insetsForWebContentToIgnore:
          insetsForWebContentToIgnore ?? this.insetsForWebContentToIgnore,
      useNetworkCapture: useNetworkCapture ?? this.useNetworkCapture,
      networkCaptureMaxBodySize:
          networkCaptureMaxBodySize ?? this.networkCaptureMaxBodySize,
      networkCaptureBodies: networkCaptureBodies ?? this.networkCaptureBodies,
      networkCaptureBinaryBodies:
          networkCaptureBinaryBodies ?? this.networkCaptureBinaryBodies,
      networkCaptureUrlPatterns:
          networkCaptureUrlPatterns ?? this.networkCaptureUrlPatterns,
      networkCaptureUrlPatternType:
          networkCaptureUrlPatternType ?? this.networkCaptureUrlPatternType,
      networkCaptureResourceTypes:
          networkCaptureResourceTypes ?? this.networkCaptureResourceTypes,
      networkCaptureMimeTypes:
          networkCaptureMimeTypes ?? this.networkCaptureMimeTypes,
      networkCapture: networkCapture ?? this.networkCapture,
    );
  }

  InAppWebViewSettings copyWithInAppWebViewSettings({
    bool? useShouldOverrideUrlLoading,
    bool? useOnLoadResource,
    bool? useOnDownloadStart,
    String? userAgent,
    String? applicationNameForUserAgent,
    bool? javaScriptEnabled,
    bool? javaScriptCanOpenWindowsAutomatically,
    bool? mediaPlaybackRequiresUserGesture,
    int? minimumFontSize,
    bool? verticalScrollBarEnabled,
    bool? horizontalScrollBarEnabled,
    List<String>? resourceCustomSchemes,
    List<ContentBlocker>? contentBlockers,
    UserPreferredContentMode? preferredContentMode,
    bool? useShouldInterceptAjaxRequest,
    bool? interceptOnlyAsyncAjaxRequests,
    bool? useShouldInterceptFetchRequest,
    bool? incognito,
    bool? cacheEnabled,
    bool? transparentBackground,
    bool? disableVerticalScroll,
    bool? disableHorizontalScroll,
    bool? disableContextMenu,
    bool? stylusHandwritingEnabled,
    bool? supportZoom,
    bool? allowFileAccessFromFileURLs,
    bool? allowUniversalAccessFromFileURLs,
    bool? builtInZoomControls,
    bool? displayZoomControls,
    bool? databaseEnabled,
    bool? domStorageEnabled,
    bool? useWideViewPort,
    bool? safeBrowsingEnabled,
    MixedContentMode? mixedContentMode,
    bool? allowContentAccess,
    bool? allowFileAccess,
    bool? blockNetworkImage,
    bool? blockNetworkLoads,
    CacheMode? cacheMode,
    String? cursiveFontFamily,
    int? defaultFixedFontSize,
    int? defaultFontSize,
    String? defaultTextEncodingName,
    ActionModeMenuItem? disabledActionModeMenuItems,
    String? fantasyFontFamily,
    String? fixedFontFamily,
    ForceDark? forceDark,
    ForceDarkStrategy? forceDarkStrategy,
    bool? geolocationEnabled,
    LayoutAlgorithm? layoutAlgorithm,
    bool? loadWithOverviewMode,
    bool? loadsImagesAutomatically,
    int? minimumLogicalFontSize,
    bool? needInitialFocus,
    bool? offscreenPreRaster,
    String? sansSerifFontFamily,
    String? serifFontFamily,
    String? standardFontFamily,
    bool? saveFormData,
    bool? thirdPartyCookiesEnabled,
    bool? hardwareAcceleration,
    int? initialScale,
    bool? supportMultipleWindows,
    String? regexToCancelSubFramesLoading,
    String? regexToCancelOverrideUrlLoading,
    bool? useHybridComposition,
    bool? useShouldInterceptRequest,
    bool? useOnRenderProcessGone,
    OverScrollMode? overScrollMode,
    bool? networkAvailable,
    ScrollBarStyle? scrollBarStyle,
    VerticalScrollbarPosition? verticalScrollbarPosition,
    int? scrollBarDefaultDelayBeforeFade,
    bool? scrollbarFadingEnabled,
    int? scrollBarFadeDuration,
    RendererPriorityPolicy? rendererPriorityPolicy,
    bool? disableDefaultErrorPage,
    Color? verticalScrollbarThumbColor,
    Color? verticalScrollbarTrackColor,
    Color? horizontalScrollbarThumbColor,
    Color? horizontalScrollbarTrackColor,
    bool? algorithmicDarkeningAllowed,
    bool? paymentRequestEnabled,
    WebAuthenticationSupport? webAuthenticationSupport,
    bool? enterpriseAuthenticationAppLinkPolicyEnabled,
    Uint8List? defaultVideoPoster,
    Set<String>? requestedWithHeaderOriginAllowList,
    bool? disallowOverScroll,
    bool? enableViewportScale,
    bool? suppressesIncrementalRendering,
    bool? allowsAirPlayForMediaPlayback,
    bool? allowsBackForwardNavigationGestures,
    bool? allowsLinkPreview,
    bool? ignoresViewportScaleLimits,
    bool? allowsInlineMediaPlayback,
    bool? allowsPictureInPictureMediaPlayback,
    bool? isFraudulentWebsiteWarningEnabled,
    SelectionGranularity? selectionGranularity,
    List<DataDetectorTypes>? dataDetectorTypes,
    bool? sharedCookiesEnabled,
    bool? automaticallyAdjustsScrollIndicatorInsets,
    bool? accessibilityIgnoresInvertColors,
    ScrollViewDecelerationRate? decelerationRate,
    bool? alwaysBounceVertical,
    bool? alwaysBounceHorizontal,
    bool? bouncesHorizontally,
    bool? bouncesVertically,
    bool? scrollsToTop,
    bool? isPagingEnabled,
    double? maximumZoomScale,
    double? minimumZoomScale,
    ScrollViewContentInsetAdjustmentBehavior? contentInsetAdjustmentBehavior,
    bool? isDirectionalLockEnabled,
    String? mediaType,
    double? pageZoom,
    bool? limitsNavigationsToAppBoundDomains,
    bool? useOnNavigationResponse,
    bool? applePayAPIEnabled,
    WebUri? allowingReadAccessTo,
    bool? disableLongPressContextMenuOnLinks,
    bool? disableInputAccessoryView,
    Color? underPageBackgroundColor,
    bool? isTextInteractionEnabled,
    bool? isSiteSpecificQuirksModeEnabled,
    bool? upgradeKnownHostsToHTTPS,
    bool? isElementFullscreenEnabled,
    bool? isFindInteractionEnabled,
    EdgeInsets? minimumViewportInset,
    EdgeInsets? maximumViewportInset,
    bool? isInspectable,
    bool? shouldPrintBackgrounds,
    bool? allowBackgroundAudioPlaying,
    WebViewAssetLoader? webViewAssetLoader,
    String? iframeAllow,
    bool? iframeAllowFullscreen,
    Set<Sandbox>? iframeSandbox,
    ReferrerPolicy? iframeReferrerPolicy,
    String? iframeName,
    String? iframeCsp,
    bool? dismissDialogues,
    List<AndroidWebViewInsets>? insetsForWebContentToIgnore,
    bool? useNetworkCapture,
    int? networkCaptureMaxBodySize,
    bool? networkCaptureBodies,
    bool? networkCaptureBinaryBodies,
    List<String>? networkCaptureUrlPatterns,
    UrlPatternType? networkCaptureUrlPatternType,
    List<ResourceType>? networkCaptureResourceTypes,
    List<String>? networkCaptureMimeTypes,
    NetworkCaptureController? networkCapture,
  }) {
    return copyWith(
      useShouldOverrideUrlLoading: useShouldOverrideUrlLoading,
      useOnLoadResource: useOnLoadResource,
      useOnDownloadStart: useOnDownloadStart,
      userAgent: userAgent,
      applicationNameForUserAgent: applicationNameForUserAgent,
      javaScriptEnabled: javaScriptEnabled,
      javaScriptCanOpenWindowsAutomatically:
          javaScriptCanOpenWindowsAutomatically,
      mediaPlaybackRequiresUserGesture: mediaPlaybackRequiresUserGesture,
      minimumFontSize: minimumFontSize,
      verticalScrollBarEnabled: verticalScrollBarEnabled,
      horizontalScrollBarEnabled: horizontalScrollBarEnabled,
      resourceCustomSchemes: resourceCustomSchemes,
      contentBlockers: contentBlockers,
      preferredContentMode: preferredContentMode,
      useShouldInterceptAjaxRequest: useShouldInterceptAjaxRequest,
      interceptOnlyAsyncAjaxRequests: interceptOnlyAsyncAjaxRequests,
      useShouldInterceptFetchRequest: useShouldInterceptFetchRequest,
      incognito: incognito,
      cacheEnabled: cacheEnabled,
      transparentBackground: transparentBackground,
      disableVerticalScroll: disableVerticalScroll,
      disableHorizontalScroll: disableHorizontalScroll,
      disableContextMenu: disableContextMenu,
      stylusHandwritingEnabled: stylusHandwritingEnabled,
      supportZoom: supportZoom,
      allowFileAccessFromFileURLs: allowFileAccessFromFileURLs,
      allowUniversalAccessFromFileURLs: allowUniversalAccessFromFileURLs,
      builtInZoomControls: builtInZoomControls,
      displayZoomControls: displayZoomControls,
      databaseEnabled: databaseEnabled,
      domStorageEnabled: domStorageEnabled,
      useWideViewPort: useWideViewPort,
      safeBrowsingEnabled: safeBrowsingEnabled,
      mixedContentMode: mixedContentMode,
      allowContentAccess: allowContentAccess,
      allowFileAccess: allowFileAccess,
      blockNetworkImage: blockNetworkImage,
      blockNetworkLoads: blockNetworkLoads,
      cacheMode: cacheMode,
      cursiveFontFamily: cursiveFontFamily,
      defaultFixedFontSize: defaultFixedFontSize,
      defaultFontSize: defaultFontSize,
      defaultTextEncodingName: defaultTextEncodingName,
      disabledActionModeMenuItems: disabledActionModeMenuItems,
      fantasyFontFamily: fantasyFontFamily,
      fixedFontFamily: fixedFontFamily,
      forceDark: forceDark,
      forceDarkStrategy: forceDarkStrategy,
      geolocationEnabled: geolocationEnabled,
      layoutAlgorithm: layoutAlgorithm,
      loadWithOverviewMode: loadWithOverviewMode,
      loadsImagesAutomatically: loadsImagesAutomatically,
      minimumLogicalFontSize: minimumLogicalFontSize,
      needInitialFocus: needInitialFocus,
      offscreenPreRaster: offscreenPreRaster,
      sansSerifFontFamily: sansSerifFontFamily,
      serifFontFamily: serifFontFamily,
      standardFontFamily: standardFontFamily,
      saveFormData: saveFormData,
      thirdPartyCookiesEnabled: thirdPartyCookiesEnabled,
      hardwareAcceleration: hardwareAcceleration,
      initialScale: initialScale,
      supportMultipleWindows: supportMultipleWindows,
      regexToCancelSubFramesLoading: regexToCancelSubFramesLoading,
      regexToCancelOverrideUrlLoading: regexToCancelOverrideUrlLoading,
      useHybridComposition: useHybridComposition,
      useShouldInterceptRequest: useShouldInterceptRequest,
      useOnRenderProcessGone: useOnRenderProcessGone,
      overScrollMode: overScrollMode,
      networkAvailable: networkAvailable,
      scrollBarStyle: scrollBarStyle,
      verticalScrollbarPosition: verticalScrollbarPosition,
      scrollBarDefaultDelayBeforeFade: scrollBarDefaultDelayBeforeFade,
      scrollbarFadingEnabled: scrollbarFadingEnabled,
      scrollBarFadeDuration: scrollBarFadeDuration,
      rendererPriorityPolicy: rendererPriorityPolicy,
      disableDefaultErrorPage: disableDefaultErrorPage,
      verticalScrollbarThumbColor: verticalScrollbarThumbColor,
      verticalScrollbarTrackColor: verticalScrollbarTrackColor,
      horizontalScrollbarThumbColor: horizontalScrollbarThumbColor,
      horizontalScrollbarTrackColor: horizontalScrollbarTrackColor,
      algorithmicDarkeningAllowed: algorithmicDarkeningAllowed,
      paymentRequestEnabled: paymentRequestEnabled,
      webAuthenticationSupport: webAuthenticationSupport,
      enterpriseAuthenticationAppLinkPolicyEnabled:
          enterpriseAuthenticationAppLinkPolicyEnabled,
      defaultVideoPoster: defaultVideoPoster,
      requestedWithHeaderOriginAllowList: requestedWithHeaderOriginAllowList,
      disallowOverScroll: disallowOverScroll,
      enableViewportScale: enableViewportScale,
      suppressesIncrementalRendering: suppressesIncrementalRendering,
      allowsAirPlayForMediaPlayback: allowsAirPlayForMediaPlayback,
      allowsBackForwardNavigationGestures: allowsBackForwardNavigationGestures,
      allowsLinkPreview: allowsLinkPreview,
      ignoresViewportScaleLimits: ignoresViewportScaleLimits,
      allowsInlineMediaPlayback: allowsInlineMediaPlayback,
      allowsPictureInPictureMediaPlayback: allowsPictureInPictureMediaPlayback,
      isFraudulentWebsiteWarningEnabled: isFraudulentWebsiteWarningEnabled,
      selectionGranularity: selectionGranularity,
      dataDetectorTypes: dataDetectorTypes,
      sharedCookiesEnabled: sharedCookiesEnabled,
      automaticallyAdjustsScrollIndicatorInsets:
          automaticallyAdjustsScrollIndicatorInsets,
      accessibilityIgnoresInvertColors: accessibilityIgnoresInvertColors,
      decelerationRate: decelerationRate,
      alwaysBounceVertical: alwaysBounceVertical,
      alwaysBounceHorizontal: alwaysBounceHorizontal,
      bouncesHorizontally: bouncesHorizontally,
      bouncesVertically: bouncesVertically,
      scrollsToTop: scrollsToTop,
      isPagingEnabled: isPagingEnabled,
      maximumZoomScale: maximumZoomScale,
      minimumZoomScale: minimumZoomScale,
      contentInsetAdjustmentBehavior: contentInsetAdjustmentBehavior,
      isDirectionalLockEnabled: isDirectionalLockEnabled,
      mediaType: mediaType,
      pageZoom: pageZoom,
      limitsNavigationsToAppBoundDomains: limitsNavigationsToAppBoundDomains,
      useOnNavigationResponse: useOnNavigationResponse,
      applePayAPIEnabled: applePayAPIEnabled,
      allowingReadAccessTo: allowingReadAccessTo,
      disableLongPressContextMenuOnLinks: disableLongPressContextMenuOnLinks,
      disableInputAccessoryView: disableInputAccessoryView,
      underPageBackgroundColor: underPageBackgroundColor,
      isTextInteractionEnabled: isTextInteractionEnabled,
      isSiteSpecificQuirksModeEnabled: isSiteSpecificQuirksModeEnabled,
      upgradeKnownHostsToHTTPS: upgradeKnownHostsToHTTPS,
      isElementFullscreenEnabled: isElementFullscreenEnabled,
      isFindInteractionEnabled: isFindInteractionEnabled,
      minimumViewportInset: minimumViewportInset,
      maximumViewportInset: maximumViewportInset,
      isInspectable: isInspectable,
      shouldPrintBackgrounds: shouldPrintBackgrounds,
      allowBackgroundAudioPlaying: allowBackgroundAudioPlaying,
      webViewAssetLoader: webViewAssetLoader,
      iframeAllow: iframeAllow,
      iframeAllowFullscreen: iframeAllowFullscreen,
      iframeSandbox: iframeSandbox,
      iframeReferrerPolicy: iframeReferrerPolicy,
      iframeName: iframeName,
      iframeCsp: iframeCsp,
      dismissDialogues: dismissDialogues,
      insetsForWebContentToIgnore: insetsForWebContentToIgnore,
      useNetworkCapture: useNetworkCapture,
      networkCaptureMaxBodySize: networkCaptureMaxBodySize,
      networkCaptureBodies: networkCaptureBodies,
      networkCaptureBinaryBodies: networkCaptureBinaryBodies,
      networkCaptureUrlPatterns: networkCaptureUrlPatterns,
      networkCaptureUrlPatternType: networkCaptureUrlPatternType,
      networkCaptureResourceTypes: networkCaptureResourceTypes,
      networkCaptureMimeTypes: networkCaptureMimeTypes,
      networkCapture: networkCapture,
    );
  }

  InAppWebViewSettings patchWithInAppWebViewSettings([
    InAppWebViewSettingsPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? InAppWebViewSettingsPatch();
    final _patchMap = _patcher.patchMap;
    return InAppWebViewSettings(
      useShouldOverrideUrlLoading:
          _patchMap.containsKey(
            InAppWebViewSettings$.useShouldOverrideUrlLoading,
          )
          ? ((_patchMap[InAppWebViewSettings$.useShouldOverrideUrlLoading]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .useShouldOverrideUrlLoading](
                        this.useShouldOverrideUrlLoading,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .useShouldOverrideUrlLoading]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .useShouldOverrideUrlLoading]
                          .applyTo(this.useShouldOverrideUrlLoading)
                    : _patchMap[InAppWebViewSettings$
                          .useShouldOverrideUrlLoading])
                as bool?
          : this.useShouldOverrideUrlLoading,
      useOnLoadResource:
          _patchMap.containsKey(InAppWebViewSettings$.useOnLoadResource)
          ? ((_patchMap[InAppWebViewSettings$.useOnLoadResource] is Function)
                    ? _patchMap[InAppWebViewSettings$.useOnLoadResource](
                        this.useOnLoadResource,
                      )
                    : (_patchMap[InAppWebViewSettings$.useOnLoadResource]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.useOnLoadResource]
                          .applyTo(this.useOnLoadResource)
                    : _patchMap[InAppWebViewSettings$.useOnLoadResource])
                as bool?
          : this.useOnLoadResource,
      useOnDownloadStart:
          _patchMap.containsKey(InAppWebViewSettings$.useOnDownloadStart)
          ? ((_patchMap[InAppWebViewSettings$.useOnDownloadStart] is Function)
                    ? _patchMap[InAppWebViewSettings$.useOnDownloadStart](
                        this.useOnDownloadStart,
                      )
                    : (_patchMap[InAppWebViewSettings$.useOnDownloadStart]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.useOnDownloadStart]
                          .applyTo(this.useOnDownloadStart)
                    : _patchMap[InAppWebViewSettings$.useOnDownloadStart])
                as bool?
          : this.useOnDownloadStart,
      userAgent: _patchMap.containsKey(InAppWebViewSettings$.userAgent)
          ? ((_patchMap[InAppWebViewSettings$.userAgent] is Function)
                    ? _patchMap[InAppWebViewSettings$.userAgent](this.userAgent)
                    : (_patchMap[InAppWebViewSettings$.userAgent] is Patch)
                    ? _patchMap[InAppWebViewSettings$.userAgent].applyTo(
                        this.userAgent,
                      )
                    : _patchMap[InAppWebViewSettings$.userAgent])
                as String?
          : this.userAgent,
      applicationNameForUserAgent:
          _patchMap.containsKey(
            InAppWebViewSettings$.applicationNameForUserAgent,
          )
          ? ((_patchMap[InAppWebViewSettings$.applicationNameForUserAgent]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .applicationNameForUserAgent](
                        this.applicationNameForUserAgent,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .applicationNameForUserAgent]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .applicationNameForUserAgent]
                          .applyTo(this.applicationNameForUserAgent)
                    : _patchMap[InAppWebViewSettings$
                          .applicationNameForUserAgent])
                as String?
          : this.applicationNameForUserAgent,
      javaScriptEnabled:
          _patchMap.containsKey(InAppWebViewSettings$.javaScriptEnabled)
          ? ((_patchMap[InAppWebViewSettings$.javaScriptEnabled] is Function)
                    ? _patchMap[InAppWebViewSettings$.javaScriptEnabled](
                        this.javaScriptEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.javaScriptEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.javaScriptEnabled]
                          .applyTo(this.javaScriptEnabled)
                    : _patchMap[InAppWebViewSettings$.javaScriptEnabled])
                as bool?
          : this.javaScriptEnabled,
      javaScriptCanOpenWindowsAutomatically:
          _patchMap.containsKey(
            InAppWebViewSettings$.javaScriptCanOpenWindowsAutomatically,
          )
          ? ((_patchMap[InAppWebViewSettings$
                            .javaScriptCanOpenWindowsAutomatically]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .javaScriptCanOpenWindowsAutomatically](
                        this.javaScriptCanOpenWindowsAutomatically,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .javaScriptCanOpenWindowsAutomatically]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .javaScriptCanOpenWindowsAutomatically]
                          .applyTo(this.javaScriptCanOpenWindowsAutomatically)
                    : _patchMap[InAppWebViewSettings$
                          .javaScriptCanOpenWindowsAutomatically])
                as bool?
          : this.javaScriptCanOpenWindowsAutomatically,
      mediaPlaybackRequiresUserGesture:
          _patchMap.containsKey(
            InAppWebViewSettings$.mediaPlaybackRequiresUserGesture,
          )
          ? ((_patchMap[InAppWebViewSettings$.mediaPlaybackRequiresUserGesture]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .mediaPlaybackRequiresUserGesture](
                        this.mediaPlaybackRequiresUserGesture,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .mediaPlaybackRequiresUserGesture]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .mediaPlaybackRequiresUserGesture]
                          .applyTo(this.mediaPlaybackRequiresUserGesture)
                    : _patchMap[InAppWebViewSettings$
                          .mediaPlaybackRequiresUserGesture])
                as bool?
          : this.mediaPlaybackRequiresUserGesture,
      minimumFontSize:
          _patchMap.containsKey(InAppWebViewSettings$.minimumFontSize)
          ? ((_patchMap[InAppWebViewSettings$.minimumFontSize] is Function)
                    ? _patchMap[InAppWebViewSettings$.minimumFontSize](
                        this.minimumFontSize,
                      )
                    : (_patchMap[InAppWebViewSettings$.minimumFontSize]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.minimumFontSize].applyTo(
                        this.minimumFontSize,
                      )
                    : _patchMap[InAppWebViewSettings$.minimumFontSize])
                as int?
          : this.minimumFontSize,
      verticalScrollBarEnabled:
          _patchMap.containsKey(InAppWebViewSettings$.verticalScrollBarEnabled)
          ? ((_patchMap[InAppWebViewSettings$.verticalScrollBarEnabled]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.verticalScrollBarEnabled](
                        this.verticalScrollBarEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.verticalScrollBarEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.verticalScrollBarEnabled]
                          .applyTo(this.verticalScrollBarEnabled)
                    : _patchMap[InAppWebViewSettings$.verticalScrollBarEnabled])
                as bool?
          : this.verticalScrollBarEnabled,
      horizontalScrollBarEnabled:
          _patchMap.containsKey(
            InAppWebViewSettings$.horizontalScrollBarEnabled,
          )
          ? ((_patchMap[InAppWebViewSettings$.horizontalScrollBarEnabled]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .horizontalScrollBarEnabled](
                        this.horizontalScrollBarEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .horizontalScrollBarEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .horizontalScrollBarEnabled]
                          .applyTo(this.horizontalScrollBarEnabled)
                    : _patchMap[InAppWebViewSettings$
                          .horizontalScrollBarEnabled])
                as bool?
          : this.horizontalScrollBarEnabled,
      resourceCustomSchemes:
          _patchMap.containsKey(InAppWebViewSettings$.resourceCustomSchemes)
          ? ((_patchMap[InAppWebViewSettings$.resourceCustomSchemes]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.resourceCustomSchemes](
                        this.resourceCustomSchemes,
                      )
                    : (_patchMap[InAppWebViewSettings$.resourceCustomSchemes]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.resourceCustomSchemes]
                          .applyTo(this.resourceCustomSchemes)
                    : _patchMap[InAppWebViewSettings$.resourceCustomSchemes])
                as List<String>?
          : this.resourceCustomSchemes,
      contentBlockers:
          _patchMap.containsKey(InAppWebViewSettings$.contentBlockers)
          ? ((_patchMap[InAppWebViewSettings$.contentBlockers] is Function)
                    ? _patchMap[InAppWebViewSettings$.contentBlockers](
                        this.contentBlockers,
                      )
                    : (_patchMap[InAppWebViewSettings$.contentBlockers]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.contentBlockers].applyTo(
                        this.contentBlockers,
                      )
                    : _patchMap[InAppWebViewSettings$.contentBlockers])
                as List<ContentBlocker>?
          : this.contentBlockers,
      preferredContentMode:
          _patchMap.containsKey(InAppWebViewSettings$.preferredContentMode)
          ? ((_patchMap[InAppWebViewSettings$.preferredContentMode] is Function)
                    ? _patchMap[InAppWebViewSettings$.preferredContentMode](
                        this.preferredContentMode,
                      )
                    : (_patchMap[InAppWebViewSettings$.preferredContentMode]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.preferredContentMode]
                          .applyTo(this.preferredContentMode)
                    : _patchMap[InAppWebViewSettings$.preferredContentMode])
                as UserPreferredContentMode?
          : this.preferredContentMode,
      useShouldInterceptAjaxRequest:
          _patchMap.containsKey(
            InAppWebViewSettings$.useShouldInterceptAjaxRequest,
          )
          ? ((_patchMap[InAppWebViewSettings$.useShouldInterceptAjaxRequest]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .useShouldInterceptAjaxRequest](
                        this.useShouldInterceptAjaxRequest,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .useShouldInterceptAjaxRequest]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .useShouldInterceptAjaxRequest]
                          .applyTo(this.useShouldInterceptAjaxRequest)
                    : _patchMap[InAppWebViewSettings$
                          .useShouldInterceptAjaxRequest])
                as bool?
          : this.useShouldInterceptAjaxRequest,
      interceptOnlyAsyncAjaxRequests:
          _patchMap.containsKey(
            InAppWebViewSettings$.interceptOnlyAsyncAjaxRequests,
          )
          ? ((_patchMap[InAppWebViewSettings$.interceptOnlyAsyncAjaxRequests]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .interceptOnlyAsyncAjaxRequests](
                        this.interceptOnlyAsyncAjaxRequests,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .interceptOnlyAsyncAjaxRequests]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .interceptOnlyAsyncAjaxRequests]
                          .applyTo(this.interceptOnlyAsyncAjaxRequests)
                    : _patchMap[InAppWebViewSettings$
                          .interceptOnlyAsyncAjaxRequests])
                as bool?
          : this.interceptOnlyAsyncAjaxRequests,
      useShouldInterceptFetchRequest:
          _patchMap.containsKey(
            InAppWebViewSettings$.useShouldInterceptFetchRequest,
          )
          ? ((_patchMap[InAppWebViewSettings$.useShouldInterceptFetchRequest]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .useShouldInterceptFetchRequest](
                        this.useShouldInterceptFetchRequest,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .useShouldInterceptFetchRequest]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .useShouldInterceptFetchRequest]
                          .applyTo(this.useShouldInterceptFetchRequest)
                    : _patchMap[InAppWebViewSettings$
                          .useShouldInterceptFetchRequest])
                as bool?
          : this.useShouldInterceptFetchRequest,
      incognito: _patchMap.containsKey(InAppWebViewSettings$.incognito)
          ? ((_patchMap[InAppWebViewSettings$.incognito] is Function)
                    ? _patchMap[InAppWebViewSettings$.incognito](this.incognito)
                    : (_patchMap[InAppWebViewSettings$.incognito] is Patch)
                    ? _patchMap[InAppWebViewSettings$.incognito].applyTo(
                        this.incognito,
                      )
                    : _patchMap[InAppWebViewSettings$.incognito])
                as bool?
          : this.incognito,
      cacheEnabled: _patchMap.containsKey(InAppWebViewSettings$.cacheEnabled)
          ? ((_patchMap[InAppWebViewSettings$.cacheEnabled] is Function)
                    ? _patchMap[InAppWebViewSettings$.cacheEnabled](
                        this.cacheEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.cacheEnabled] is Patch)
                    ? _patchMap[InAppWebViewSettings$.cacheEnabled].applyTo(
                        this.cacheEnabled,
                      )
                    : _patchMap[InAppWebViewSettings$.cacheEnabled])
                as bool?
          : this.cacheEnabled,
      transparentBackground:
          _patchMap.containsKey(InAppWebViewSettings$.transparentBackground)
          ? ((_patchMap[InAppWebViewSettings$.transparentBackground]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.transparentBackground](
                        this.transparentBackground,
                      )
                    : (_patchMap[InAppWebViewSettings$.transparentBackground]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.transparentBackground]
                          .applyTo(this.transparentBackground)
                    : _patchMap[InAppWebViewSettings$.transparentBackground])
                as bool?
          : this.transparentBackground,
      disableVerticalScroll:
          _patchMap.containsKey(InAppWebViewSettings$.disableVerticalScroll)
          ? ((_patchMap[InAppWebViewSettings$.disableVerticalScroll]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.disableVerticalScroll](
                        this.disableVerticalScroll,
                      )
                    : (_patchMap[InAppWebViewSettings$.disableVerticalScroll]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.disableVerticalScroll]
                          .applyTo(this.disableVerticalScroll)
                    : _patchMap[InAppWebViewSettings$.disableVerticalScroll])
                as bool?
          : this.disableVerticalScroll,
      disableHorizontalScroll:
          _patchMap.containsKey(InAppWebViewSettings$.disableHorizontalScroll)
          ? ((_patchMap[InAppWebViewSettings$.disableHorizontalScroll]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.disableHorizontalScroll](
                        this.disableHorizontalScroll,
                      )
                    : (_patchMap[InAppWebViewSettings$.disableHorizontalScroll]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.disableHorizontalScroll]
                          .applyTo(this.disableHorizontalScroll)
                    : _patchMap[InAppWebViewSettings$.disableHorizontalScroll])
                as bool?
          : this.disableHorizontalScroll,
      disableContextMenu:
          _patchMap.containsKey(InAppWebViewSettings$.disableContextMenu)
          ? ((_patchMap[InAppWebViewSettings$.disableContextMenu] is Function)
                    ? _patchMap[InAppWebViewSettings$.disableContextMenu](
                        this.disableContextMenu,
                      )
                    : (_patchMap[InAppWebViewSettings$.disableContextMenu]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.disableContextMenu]
                          .applyTo(this.disableContextMenu)
                    : _patchMap[InAppWebViewSettings$.disableContextMenu])
                as bool?
          : this.disableContextMenu,
      stylusHandwritingEnabled:
          _patchMap.containsKey(InAppWebViewSettings$.stylusHandwritingEnabled)
          ? ((_patchMap[InAppWebViewSettings$.stylusHandwritingEnabled]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.stylusHandwritingEnabled](
                        this.stylusHandwritingEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.stylusHandwritingEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.stylusHandwritingEnabled]
                          .applyTo(this.stylusHandwritingEnabled)
                    : _patchMap[InAppWebViewSettings$.stylusHandwritingEnabled])
                as bool?
          : this.stylusHandwritingEnabled,
      supportZoom: _patchMap.containsKey(InAppWebViewSettings$.supportZoom)
          ? ((_patchMap[InAppWebViewSettings$.supportZoom] is Function)
                    ? _patchMap[InAppWebViewSettings$.supportZoom](
                        this.supportZoom,
                      )
                    : (_patchMap[InAppWebViewSettings$.supportZoom] is Patch)
                    ? _patchMap[InAppWebViewSettings$.supportZoom].applyTo(
                        this.supportZoom,
                      )
                    : _patchMap[InAppWebViewSettings$.supportZoom])
                as bool?
          : this.supportZoom,
      allowFileAccessFromFileURLs:
          _patchMap.containsKey(
            InAppWebViewSettings$.allowFileAccessFromFileURLs,
          )
          ? ((_patchMap[InAppWebViewSettings$.allowFileAccessFromFileURLs]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .allowFileAccessFromFileURLs](
                        this.allowFileAccessFromFileURLs,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .allowFileAccessFromFileURLs]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .allowFileAccessFromFileURLs]
                          .applyTo(this.allowFileAccessFromFileURLs)
                    : _patchMap[InAppWebViewSettings$
                          .allowFileAccessFromFileURLs])
                as bool?
          : this.allowFileAccessFromFileURLs,
      allowUniversalAccessFromFileURLs:
          _patchMap.containsKey(
            InAppWebViewSettings$.allowUniversalAccessFromFileURLs,
          )
          ? ((_patchMap[InAppWebViewSettings$.allowUniversalAccessFromFileURLs]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .allowUniversalAccessFromFileURLs](
                        this.allowUniversalAccessFromFileURLs,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .allowUniversalAccessFromFileURLs]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .allowUniversalAccessFromFileURLs]
                          .applyTo(this.allowUniversalAccessFromFileURLs)
                    : _patchMap[InAppWebViewSettings$
                          .allowUniversalAccessFromFileURLs])
                as bool?
          : this.allowUniversalAccessFromFileURLs,
      builtInZoomControls:
          _patchMap.containsKey(InAppWebViewSettings$.builtInZoomControls)
          ? ((_patchMap[InAppWebViewSettings$.builtInZoomControls] is Function)
                    ? _patchMap[InAppWebViewSettings$.builtInZoomControls](
                        this.builtInZoomControls,
                      )
                    : (_patchMap[InAppWebViewSettings$.builtInZoomControls]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.builtInZoomControls]
                          .applyTo(this.builtInZoomControls)
                    : _patchMap[InAppWebViewSettings$.builtInZoomControls])
                as bool?
          : this.builtInZoomControls,
      displayZoomControls:
          _patchMap.containsKey(InAppWebViewSettings$.displayZoomControls)
          ? ((_patchMap[InAppWebViewSettings$.displayZoomControls] is Function)
                    ? _patchMap[InAppWebViewSettings$.displayZoomControls](
                        this.displayZoomControls,
                      )
                    : (_patchMap[InAppWebViewSettings$.displayZoomControls]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.displayZoomControls]
                          .applyTo(this.displayZoomControls)
                    : _patchMap[InAppWebViewSettings$.displayZoomControls])
                as bool?
          : this.displayZoomControls,
      databaseEnabled:
          _patchMap.containsKey(InAppWebViewSettings$.databaseEnabled)
          ? ((_patchMap[InAppWebViewSettings$.databaseEnabled] is Function)
                    ? _patchMap[InAppWebViewSettings$.databaseEnabled](
                        this.databaseEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.databaseEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.databaseEnabled].applyTo(
                        this.databaseEnabled,
                      )
                    : _patchMap[InAppWebViewSettings$.databaseEnabled])
                as bool?
          : this.databaseEnabled,
      domStorageEnabled:
          _patchMap.containsKey(InAppWebViewSettings$.domStorageEnabled)
          ? ((_patchMap[InAppWebViewSettings$.domStorageEnabled] is Function)
                    ? _patchMap[InAppWebViewSettings$.domStorageEnabled](
                        this.domStorageEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.domStorageEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.domStorageEnabled]
                          .applyTo(this.domStorageEnabled)
                    : _patchMap[InAppWebViewSettings$.domStorageEnabled])
                as bool?
          : this.domStorageEnabled,
      useWideViewPort:
          _patchMap.containsKey(InAppWebViewSettings$.useWideViewPort)
          ? ((_patchMap[InAppWebViewSettings$.useWideViewPort] is Function)
                    ? _patchMap[InAppWebViewSettings$.useWideViewPort](
                        this.useWideViewPort,
                      )
                    : (_patchMap[InAppWebViewSettings$.useWideViewPort]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.useWideViewPort].applyTo(
                        this.useWideViewPort,
                      )
                    : _patchMap[InAppWebViewSettings$.useWideViewPort])
                as bool?
          : this.useWideViewPort,
      safeBrowsingEnabled:
          _patchMap.containsKey(InAppWebViewSettings$.safeBrowsingEnabled)
          ? ((_patchMap[InAppWebViewSettings$.safeBrowsingEnabled] is Function)
                    ? _patchMap[InAppWebViewSettings$.safeBrowsingEnabled](
                        this.safeBrowsingEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.safeBrowsingEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.safeBrowsingEnabled]
                          .applyTo(this.safeBrowsingEnabled)
                    : _patchMap[InAppWebViewSettings$.safeBrowsingEnabled])
                as bool?
          : this.safeBrowsingEnabled,
      mixedContentMode:
          _patchMap.containsKey(InAppWebViewSettings$.mixedContentMode)
          ? ((_patchMap[InAppWebViewSettings$.mixedContentMode] is Function)
                    ? _patchMap[InAppWebViewSettings$.mixedContentMode](
                        this.mixedContentMode,
                      )
                    : (_patchMap[InAppWebViewSettings$.mixedContentMode]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.mixedContentMode].applyTo(
                        this.mixedContentMode,
                      )
                    : _patchMap[InAppWebViewSettings$.mixedContentMode])
                as MixedContentMode?
          : this.mixedContentMode,
      allowContentAccess:
          _patchMap.containsKey(InAppWebViewSettings$.allowContentAccess)
          ? ((_patchMap[InAppWebViewSettings$.allowContentAccess] is Function)
                    ? _patchMap[InAppWebViewSettings$.allowContentAccess](
                        this.allowContentAccess,
                      )
                    : (_patchMap[InAppWebViewSettings$.allowContentAccess]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.allowContentAccess]
                          .applyTo(this.allowContentAccess)
                    : _patchMap[InAppWebViewSettings$.allowContentAccess])
                as bool?
          : this.allowContentAccess,
      allowFileAccess:
          _patchMap.containsKey(InAppWebViewSettings$.allowFileAccess)
          ? ((_patchMap[InAppWebViewSettings$.allowFileAccess] is Function)
                    ? _patchMap[InAppWebViewSettings$.allowFileAccess](
                        this.allowFileAccess,
                      )
                    : (_patchMap[InAppWebViewSettings$.allowFileAccess]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.allowFileAccess].applyTo(
                        this.allowFileAccess,
                      )
                    : _patchMap[InAppWebViewSettings$.allowFileAccess])
                as bool?
          : this.allowFileAccess,
      blockNetworkImage:
          _patchMap.containsKey(InAppWebViewSettings$.blockNetworkImage)
          ? ((_patchMap[InAppWebViewSettings$.blockNetworkImage] is Function)
                    ? _patchMap[InAppWebViewSettings$.blockNetworkImage](
                        this.blockNetworkImage,
                      )
                    : (_patchMap[InAppWebViewSettings$.blockNetworkImage]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.blockNetworkImage]
                          .applyTo(this.blockNetworkImage)
                    : _patchMap[InAppWebViewSettings$.blockNetworkImage])
                as bool?
          : this.blockNetworkImage,
      blockNetworkLoads:
          _patchMap.containsKey(InAppWebViewSettings$.blockNetworkLoads)
          ? ((_patchMap[InAppWebViewSettings$.blockNetworkLoads] is Function)
                    ? _patchMap[InAppWebViewSettings$.blockNetworkLoads](
                        this.blockNetworkLoads,
                      )
                    : (_patchMap[InAppWebViewSettings$.blockNetworkLoads]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.blockNetworkLoads]
                          .applyTo(this.blockNetworkLoads)
                    : _patchMap[InAppWebViewSettings$.blockNetworkLoads])
                as bool?
          : this.blockNetworkLoads,
      cacheMode: _patchMap.containsKey(InAppWebViewSettings$.cacheMode)
          ? ((_patchMap[InAppWebViewSettings$.cacheMode] is Function)
                    ? _patchMap[InAppWebViewSettings$.cacheMode](this.cacheMode)
                    : (_patchMap[InAppWebViewSettings$.cacheMode] is Patch)
                    ? _patchMap[InAppWebViewSettings$.cacheMode].applyTo(
                        this.cacheMode,
                      )
                    : _patchMap[InAppWebViewSettings$.cacheMode])
                as CacheMode?
          : this.cacheMode,
      cursiveFontFamily:
          _patchMap.containsKey(InAppWebViewSettings$.cursiveFontFamily)
          ? ((_patchMap[InAppWebViewSettings$.cursiveFontFamily] is Function)
                    ? _patchMap[InAppWebViewSettings$.cursiveFontFamily](
                        this.cursiveFontFamily,
                      )
                    : (_patchMap[InAppWebViewSettings$.cursiveFontFamily]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.cursiveFontFamily]
                          .applyTo(this.cursiveFontFamily)
                    : _patchMap[InAppWebViewSettings$.cursiveFontFamily])
                as String?
          : this.cursiveFontFamily,
      defaultFixedFontSize:
          _patchMap.containsKey(InAppWebViewSettings$.defaultFixedFontSize)
          ? ((_patchMap[InAppWebViewSettings$.defaultFixedFontSize] is Function)
                    ? _patchMap[InAppWebViewSettings$.defaultFixedFontSize](
                        this.defaultFixedFontSize,
                      )
                    : (_patchMap[InAppWebViewSettings$.defaultFixedFontSize]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.defaultFixedFontSize]
                          .applyTo(this.defaultFixedFontSize)
                    : _patchMap[InAppWebViewSettings$.defaultFixedFontSize])
                as int?
          : this.defaultFixedFontSize,
      defaultFontSize:
          _patchMap.containsKey(InAppWebViewSettings$.defaultFontSize)
          ? ((_patchMap[InAppWebViewSettings$.defaultFontSize] is Function)
                    ? _patchMap[InAppWebViewSettings$.defaultFontSize](
                        this.defaultFontSize,
                      )
                    : (_patchMap[InAppWebViewSettings$.defaultFontSize]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.defaultFontSize].applyTo(
                        this.defaultFontSize,
                      )
                    : _patchMap[InAppWebViewSettings$.defaultFontSize])
                as int?
          : this.defaultFontSize,
      defaultTextEncodingName:
          _patchMap.containsKey(InAppWebViewSettings$.defaultTextEncodingName)
          ? ((_patchMap[InAppWebViewSettings$.defaultTextEncodingName]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.defaultTextEncodingName](
                        this.defaultTextEncodingName,
                      )
                    : (_patchMap[InAppWebViewSettings$.defaultTextEncodingName]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.defaultTextEncodingName]
                          .applyTo(this.defaultTextEncodingName)
                    : _patchMap[InAppWebViewSettings$.defaultTextEncodingName])
                as String?
          : this.defaultTextEncodingName,
      disabledActionModeMenuItems:
          _patchMap.containsKey(
            InAppWebViewSettings$.disabledActionModeMenuItems,
          )
          ? ((_patchMap[InAppWebViewSettings$.disabledActionModeMenuItems]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .disabledActionModeMenuItems](
                        this.disabledActionModeMenuItems,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .disabledActionModeMenuItems]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .disabledActionModeMenuItems]
                          .applyTo(this.disabledActionModeMenuItems)
                    : _patchMap[InAppWebViewSettings$
                          .disabledActionModeMenuItems])
                as ActionModeMenuItem?
          : this.disabledActionModeMenuItems,
      fantasyFontFamily:
          _patchMap.containsKey(InAppWebViewSettings$.fantasyFontFamily)
          ? ((_patchMap[InAppWebViewSettings$.fantasyFontFamily] is Function)
                    ? _patchMap[InAppWebViewSettings$.fantasyFontFamily](
                        this.fantasyFontFamily,
                      )
                    : (_patchMap[InAppWebViewSettings$.fantasyFontFamily]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.fantasyFontFamily]
                          .applyTo(this.fantasyFontFamily)
                    : _patchMap[InAppWebViewSettings$.fantasyFontFamily])
                as String?
          : this.fantasyFontFamily,
      fixedFontFamily:
          _patchMap.containsKey(InAppWebViewSettings$.fixedFontFamily)
          ? ((_patchMap[InAppWebViewSettings$.fixedFontFamily] is Function)
                    ? _patchMap[InAppWebViewSettings$.fixedFontFamily](
                        this.fixedFontFamily,
                      )
                    : (_patchMap[InAppWebViewSettings$.fixedFontFamily]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.fixedFontFamily].applyTo(
                        this.fixedFontFamily,
                      )
                    : _patchMap[InAppWebViewSettings$.fixedFontFamily])
                as String?
          : this.fixedFontFamily,
      forceDark: _patchMap.containsKey(InAppWebViewSettings$.forceDark)
          ? ((_patchMap[InAppWebViewSettings$.forceDark] is Function)
                    ? _patchMap[InAppWebViewSettings$.forceDark](this.forceDark)
                    : (_patchMap[InAppWebViewSettings$.forceDark] is Patch)
                    ? _patchMap[InAppWebViewSettings$.forceDark].applyTo(
                        this.forceDark,
                      )
                    : _patchMap[InAppWebViewSettings$.forceDark])
                as ForceDark?
          : this.forceDark,
      forceDarkStrategy:
          _patchMap.containsKey(InAppWebViewSettings$.forceDarkStrategy)
          ? ((_patchMap[InAppWebViewSettings$.forceDarkStrategy] is Function)
                    ? _patchMap[InAppWebViewSettings$.forceDarkStrategy](
                        this.forceDarkStrategy,
                      )
                    : (_patchMap[InAppWebViewSettings$.forceDarkStrategy]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.forceDarkStrategy]
                          .applyTo(this.forceDarkStrategy)
                    : _patchMap[InAppWebViewSettings$.forceDarkStrategy])
                as ForceDarkStrategy?
          : this.forceDarkStrategy,
      geolocationEnabled:
          _patchMap.containsKey(InAppWebViewSettings$.geolocationEnabled)
          ? ((_patchMap[InAppWebViewSettings$.geolocationEnabled] is Function)
                    ? _patchMap[InAppWebViewSettings$.geolocationEnabled](
                        this.geolocationEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.geolocationEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.geolocationEnabled]
                          .applyTo(this.geolocationEnabled)
                    : _patchMap[InAppWebViewSettings$.geolocationEnabled])
                as bool?
          : this.geolocationEnabled,
      layoutAlgorithm:
          _patchMap.containsKey(InAppWebViewSettings$.layoutAlgorithm)
          ? ((_patchMap[InAppWebViewSettings$.layoutAlgorithm] is Function)
                    ? _patchMap[InAppWebViewSettings$.layoutAlgorithm](
                        this.layoutAlgorithm,
                      )
                    : (_patchMap[InAppWebViewSettings$.layoutAlgorithm]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.layoutAlgorithm].applyTo(
                        this.layoutAlgorithm,
                      )
                    : _patchMap[InAppWebViewSettings$.layoutAlgorithm])
                as LayoutAlgorithm?
          : this.layoutAlgorithm,
      loadWithOverviewMode:
          _patchMap.containsKey(InAppWebViewSettings$.loadWithOverviewMode)
          ? ((_patchMap[InAppWebViewSettings$.loadWithOverviewMode] is Function)
                    ? _patchMap[InAppWebViewSettings$.loadWithOverviewMode](
                        this.loadWithOverviewMode,
                      )
                    : (_patchMap[InAppWebViewSettings$.loadWithOverviewMode]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.loadWithOverviewMode]
                          .applyTo(this.loadWithOverviewMode)
                    : _patchMap[InAppWebViewSettings$.loadWithOverviewMode])
                as bool?
          : this.loadWithOverviewMode,
      loadsImagesAutomatically:
          _patchMap.containsKey(InAppWebViewSettings$.loadsImagesAutomatically)
          ? ((_patchMap[InAppWebViewSettings$.loadsImagesAutomatically]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.loadsImagesAutomatically](
                        this.loadsImagesAutomatically,
                      )
                    : (_patchMap[InAppWebViewSettings$.loadsImagesAutomatically]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.loadsImagesAutomatically]
                          .applyTo(this.loadsImagesAutomatically)
                    : _patchMap[InAppWebViewSettings$.loadsImagesAutomatically])
                as bool?
          : this.loadsImagesAutomatically,
      minimumLogicalFontSize:
          _patchMap.containsKey(InAppWebViewSettings$.minimumLogicalFontSize)
          ? ((_patchMap[InAppWebViewSettings$.minimumLogicalFontSize]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.minimumLogicalFontSize](
                        this.minimumLogicalFontSize,
                      )
                    : (_patchMap[InAppWebViewSettings$.minimumLogicalFontSize]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.minimumLogicalFontSize]
                          .applyTo(this.minimumLogicalFontSize)
                    : _patchMap[InAppWebViewSettings$.minimumLogicalFontSize])
                as int?
          : this.minimumLogicalFontSize,
      needInitialFocus:
          _patchMap.containsKey(InAppWebViewSettings$.needInitialFocus)
          ? ((_patchMap[InAppWebViewSettings$.needInitialFocus] is Function)
                    ? _patchMap[InAppWebViewSettings$.needInitialFocus](
                        this.needInitialFocus,
                      )
                    : (_patchMap[InAppWebViewSettings$.needInitialFocus]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.needInitialFocus].applyTo(
                        this.needInitialFocus,
                      )
                    : _patchMap[InAppWebViewSettings$.needInitialFocus])
                as bool?
          : this.needInitialFocus,
      offscreenPreRaster:
          _patchMap.containsKey(InAppWebViewSettings$.offscreenPreRaster)
          ? ((_patchMap[InAppWebViewSettings$.offscreenPreRaster] is Function)
                    ? _patchMap[InAppWebViewSettings$.offscreenPreRaster](
                        this.offscreenPreRaster,
                      )
                    : (_patchMap[InAppWebViewSettings$.offscreenPreRaster]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.offscreenPreRaster]
                          .applyTo(this.offscreenPreRaster)
                    : _patchMap[InAppWebViewSettings$.offscreenPreRaster])
                as bool?
          : this.offscreenPreRaster,
      sansSerifFontFamily:
          _patchMap.containsKey(InAppWebViewSettings$.sansSerifFontFamily)
          ? ((_patchMap[InAppWebViewSettings$.sansSerifFontFamily] is Function)
                    ? _patchMap[InAppWebViewSettings$.sansSerifFontFamily](
                        this.sansSerifFontFamily,
                      )
                    : (_patchMap[InAppWebViewSettings$.sansSerifFontFamily]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.sansSerifFontFamily]
                          .applyTo(this.sansSerifFontFamily)
                    : _patchMap[InAppWebViewSettings$.sansSerifFontFamily])
                as String?
          : this.sansSerifFontFamily,
      serifFontFamily:
          _patchMap.containsKey(InAppWebViewSettings$.serifFontFamily)
          ? ((_patchMap[InAppWebViewSettings$.serifFontFamily] is Function)
                    ? _patchMap[InAppWebViewSettings$.serifFontFamily](
                        this.serifFontFamily,
                      )
                    : (_patchMap[InAppWebViewSettings$.serifFontFamily]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.serifFontFamily].applyTo(
                        this.serifFontFamily,
                      )
                    : _patchMap[InAppWebViewSettings$.serifFontFamily])
                as String?
          : this.serifFontFamily,
      standardFontFamily:
          _patchMap.containsKey(InAppWebViewSettings$.standardFontFamily)
          ? ((_patchMap[InAppWebViewSettings$.standardFontFamily] is Function)
                    ? _patchMap[InAppWebViewSettings$.standardFontFamily](
                        this.standardFontFamily,
                      )
                    : (_patchMap[InAppWebViewSettings$.standardFontFamily]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.standardFontFamily]
                          .applyTo(this.standardFontFamily)
                    : _patchMap[InAppWebViewSettings$.standardFontFamily])
                as String?
          : this.standardFontFamily,
      saveFormData: _patchMap.containsKey(InAppWebViewSettings$.saveFormData)
          ? ((_patchMap[InAppWebViewSettings$.saveFormData] is Function)
                    ? _patchMap[InAppWebViewSettings$.saveFormData](
                        this.saveFormData,
                      )
                    : (_patchMap[InAppWebViewSettings$.saveFormData] is Patch)
                    ? _patchMap[InAppWebViewSettings$.saveFormData].applyTo(
                        this.saveFormData,
                      )
                    : _patchMap[InAppWebViewSettings$.saveFormData])
                as bool?
          : this.saveFormData,
      thirdPartyCookiesEnabled:
          _patchMap.containsKey(InAppWebViewSettings$.thirdPartyCookiesEnabled)
          ? ((_patchMap[InAppWebViewSettings$.thirdPartyCookiesEnabled]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.thirdPartyCookiesEnabled](
                        this.thirdPartyCookiesEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.thirdPartyCookiesEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.thirdPartyCookiesEnabled]
                          .applyTo(this.thirdPartyCookiesEnabled)
                    : _patchMap[InAppWebViewSettings$.thirdPartyCookiesEnabled])
                as bool?
          : this.thirdPartyCookiesEnabled,
      hardwareAcceleration:
          _patchMap.containsKey(InAppWebViewSettings$.hardwareAcceleration)
          ? ((_patchMap[InAppWebViewSettings$.hardwareAcceleration] is Function)
                    ? _patchMap[InAppWebViewSettings$.hardwareAcceleration](
                        this.hardwareAcceleration,
                      )
                    : (_patchMap[InAppWebViewSettings$.hardwareAcceleration]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.hardwareAcceleration]
                          .applyTo(this.hardwareAcceleration)
                    : _patchMap[InAppWebViewSettings$.hardwareAcceleration])
                as bool?
          : this.hardwareAcceleration,
      initialScale: _patchMap.containsKey(InAppWebViewSettings$.initialScale)
          ? ((_patchMap[InAppWebViewSettings$.initialScale] is Function)
                    ? _patchMap[InAppWebViewSettings$.initialScale](
                        this.initialScale,
                      )
                    : (_patchMap[InAppWebViewSettings$.initialScale] is Patch)
                    ? _patchMap[InAppWebViewSettings$.initialScale].applyTo(
                        this.initialScale,
                      )
                    : _patchMap[InAppWebViewSettings$.initialScale])
                as int?
          : this.initialScale,
      supportMultipleWindows:
          _patchMap.containsKey(InAppWebViewSettings$.supportMultipleWindows)
          ? ((_patchMap[InAppWebViewSettings$.supportMultipleWindows]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.supportMultipleWindows](
                        this.supportMultipleWindows,
                      )
                    : (_patchMap[InAppWebViewSettings$.supportMultipleWindows]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.supportMultipleWindows]
                          .applyTo(this.supportMultipleWindows)
                    : _patchMap[InAppWebViewSettings$.supportMultipleWindows])
                as bool?
          : this.supportMultipleWindows,
      regexToCancelSubFramesLoading:
          _patchMap.containsKey(
            InAppWebViewSettings$.regexToCancelSubFramesLoading,
          )
          ? ((_patchMap[InAppWebViewSettings$.regexToCancelSubFramesLoading]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .regexToCancelSubFramesLoading](
                        this.regexToCancelSubFramesLoading,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .regexToCancelSubFramesLoading]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .regexToCancelSubFramesLoading]
                          .applyTo(this.regexToCancelSubFramesLoading)
                    : _patchMap[InAppWebViewSettings$
                          .regexToCancelSubFramesLoading])
                as String?
          : this.regexToCancelSubFramesLoading,
      regexToCancelOverrideUrlLoading:
          _patchMap.containsKey(
            InAppWebViewSettings$.regexToCancelOverrideUrlLoading,
          )
          ? ((_patchMap[InAppWebViewSettings$.regexToCancelOverrideUrlLoading]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .regexToCancelOverrideUrlLoading](
                        this.regexToCancelOverrideUrlLoading,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .regexToCancelOverrideUrlLoading]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .regexToCancelOverrideUrlLoading]
                          .applyTo(this.regexToCancelOverrideUrlLoading)
                    : _patchMap[InAppWebViewSettings$
                          .regexToCancelOverrideUrlLoading])
                as String?
          : this.regexToCancelOverrideUrlLoading,
      useHybridComposition:
          _patchMap.containsKey(InAppWebViewSettings$.useHybridComposition)
          ? ((_patchMap[InAppWebViewSettings$.useHybridComposition] is Function)
                    ? _patchMap[InAppWebViewSettings$.useHybridComposition](
                        this.useHybridComposition,
                      )
                    : (_patchMap[InAppWebViewSettings$.useHybridComposition]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.useHybridComposition]
                          .applyTo(this.useHybridComposition)
                    : _patchMap[InAppWebViewSettings$.useHybridComposition])
                as bool?
          : this.useHybridComposition,
      useShouldInterceptRequest:
          _patchMap.containsKey(InAppWebViewSettings$.useShouldInterceptRequest)
          ? ((_patchMap[InAppWebViewSettings$.useShouldInterceptRequest]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .useShouldInterceptRequest](
                        this.useShouldInterceptRequest,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .useShouldInterceptRequest]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.useShouldInterceptRequest]
                          .applyTo(this.useShouldInterceptRequest)
                    : _patchMap[InAppWebViewSettings$
                          .useShouldInterceptRequest])
                as bool?
          : this.useShouldInterceptRequest,
      useOnRenderProcessGone:
          _patchMap.containsKey(InAppWebViewSettings$.useOnRenderProcessGone)
          ? ((_patchMap[InAppWebViewSettings$.useOnRenderProcessGone]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.useOnRenderProcessGone](
                        this.useOnRenderProcessGone,
                      )
                    : (_patchMap[InAppWebViewSettings$.useOnRenderProcessGone]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.useOnRenderProcessGone]
                          .applyTo(this.useOnRenderProcessGone)
                    : _patchMap[InAppWebViewSettings$.useOnRenderProcessGone])
                as bool?
          : this.useOnRenderProcessGone,
      overScrollMode:
          _patchMap.containsKey(InAppWebViewSettings$.overScrollMode)
          ? ((_patchMap[InAppWebViewSettings$.overScrollMode] is Function)
                    ? _patchMap[InAppWebViewSettings$.overScrollMode](
                        this.overScrollMode,
                      )
                    : (_patchMap[InAppWebViewSettings$.overScrollMode] is Patch)
                    ? _patchMap[InAppWebViewSettings$.overScrollMode].applyTo(
                        this.overScrollMode,
                      )
                    : _patchMap[InAppWebViewSettings$.overScrollMode])
                as OverScrollMode?
          : this.overScrollMode,
      networkAvailable:
          _patchMap.containsKey(InAppWebViewSettings$.networkAvailable)
          ? ((_patchMap[InAppWebViewSettings$.networkAvailable] is Function)
                    ? _patchMap[InAppWebViewSettings$.networkAvailable](
                        this.networkAvailable,
                      )
                    : (_patchMap[InAppWebViewSettings$.networkAvailable]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.networkAvailable].applyTo(
                        this.networkAvailable,
                      )
                    : _patchMap[InAppWebViewSettings$.networkAvailable])
                as bool?
          : this.networkAvailable,
      scrollBarStyle:
          _patchMap.containsKey(InAppWebViewSettings$.scrollBarStyle)
          ? ((_patchMap[InAppWebViewSettings$.scrollBarStyle] is Function)
                    ? _patchMap[InAppWebViewSettings$.scrollBarStyle](
                        this.scrollBarStyle,
                      )
                    : (_patchMap[InAppWebViewSettings$.scrollBarStyle] is Patch)
                    ? _patchMap[InAppWebViewSettings$.scrollBarStyle].applyTo(
                        this.scrollBarStyle,
                      )
                    : _patchMap[InAppWebViewSettings$.scrollBarStyle])
                as ScrollBarStyle?
          : this.scrollBarStyle,
      verticalScrollbarPosition:
          _patchMap.containsKey(InAppWebViewSettings$.verticalScrollbarPosition)
          ? ((_patchMap[InAppWebViewSettings$.verticalScrollbarPosition]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .verticalScrollbarPosition](
                        this.verticalScrollbarPosition,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .verticalScrollbarPosition]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.verticalScrollbarPosition]
                          .applyTo(this.verticalScrollbarPosition)
                    : _patchMap[InAppWebViewSettings$
                          .verticalScrollbarPosition])
                as VerticalScrollbarPosition?
          : this.verticalScrollbarPosition,
      scrollBarDefaultDelayBeforeFade:
          _patchMap.containsKey(
            InAppWebViewSettings$.scrollBarDefaultDelayBeforeFade,
          )
          ? ((_patchMap[InAppWebViewSettings$.scrollBarDefaultDelayBeforeFade]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .scrollBarDefaultDelayBeforeFade](
                        this.scrollBarDefaultDelayBeforeFade,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .scrollBarDefaultDelayBeforeFade]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .scrollBarDefaultDelayBeforeFade]
                          .applyTo(this.scrollBarDefaultDelayBeforeFade)
                    : _patchMap[InAppWebViewSettings$
                          .scrollBarDefaultDelayBeforeFade])
                as int?
          : this.scrollBarDefaultDelayBeforeFade,
      scrollbarFadingEnabled:
          _patchMap.containsKey(InAppWebViewSettings$.scrollbarFadingEnabled)
          ? ((_patchMap[InAppWebViewSettings$.scrollbarFadingEnabled]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.scrollbarFadingEnabled](
                        this.scrollbarFadingEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.scrollbarFadingEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.scrollbarFadingEnabled]
                          .applyTo(this.scrollbarFadingEnabled)
                    : _patchMap[InAppWebViewSettings$.scrollbarFadingEnabled])
                as bool?
          : this.scrollbarFadingEnabled,
      scrollBarFadeDuration:
          _patchMap.containsKey(InAppWebViewSettings$.scrollBarFadeDuration)
          ? ((_patchMap[InAppWebViewSettings$.scrollBarFadeDuration]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.scrollBarFadeDuration](
                        this.scrollBarFadeDuration,
                      )
                    : (_patchMap[InAppWebViewSettings$.scrollBarFadeDuration]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.scrollBarFadeDuration]
                          .applyTo(this.scrollBarFadeDuration)
                    : _patchMap[InAppWebViewSettings$.scrollBarFadeDuration])
                as int?
          : this.scrollBarFadeDuration,
      rendererPriorityPolicy:
          _patchMap.containsKey(InAppWebViewSettings$.rendererPriorityPolicy)
          ? ((_patchMap[InAppWebViewSettings$.rendererPriorityPolicy]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.rendererPriorityPolicy](
                        this.rendererPriorityPolicy,
                      )
                    : (_patchMap[InAppWebViewSettings$.rendererPriorityPolicy]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.rendererPriorityPolicy]
                          .applyTo(this.rendererPriorityPolicy)
                    : _patchMap[InAppWebViewSettings$.rendererPriorityPolicy])
                as RendererPriorityPolicy?
          : this.rendererPriorityPolicy,
      disableDefaultErrorPage:
          _patchMap.containsKey(InAppWebViewSettings$.disableDefaultErrorPage)
          ? ((_patchMap[InAppWebViewSettings$.disableDefaultErrorPage]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.disableDefaultErrorPage](
                        this.disableDefaultErrorPage,
                      )
                    : (_patchMap[InAppWebViewSettings$.disableDefaultErrorPage]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.disableDefaultErrorPage]
                          .applyTo(this.disableDefaultErrorPage)
                    : _patchMap[InAppWebViewSettings$.disableDefaultErrorPage])
                as bool?
          : this.disableDefaultErrorPage,
      verticalScrollbarThumbColor:
          _patchMap.containsKey(
            InAppWebViewSettings$.verticalScrollbarThumbColor,
          )
          ? ((_patchMap[InAppWebViewSettings$.verticalScrollbarThumbColor]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .verticalScrollbarThumbColor](
                        this.verticalScrollbarThumbColor,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .verticalScrollbarThumbColor]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .verticalScrollbarThumbColor]
                          .applyTo(this.verticalScrollbarThumbColor)
                    : _patchMap[InAppWebViewSettings$
                          .verticalScrollbarThumbColor])
                as Color?
          : this.verticalScrollbarThumbColor,
      verticalScrollbarTrackColor:
          _patchMap.containsKey(
            InAppWebViewSettings$.verticalScrollbarTrackColor,
          )
          ? ((_patchMap[InAppWebViewSettings$.verticalScrollbarTrackColor]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .verticalScrollbarTrackColor](
                        this.verticalScrollbarTrackColor,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .verticalScrollbarTrackColor]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .verticalScrollbarTrackColor]
                          .applyTo(this.verticalScrollbarTrackColor)
                    : _patchMap[InAppWebViewSettings$
                          .verticalScrollbarTrackColor])
                as Color?
          : this.verticalScrollbarTrackColor,
      horizontalScrollbarThumbColor:
          _patchMap.containsKey(
            InAppWebViewSettings$.horizontalScrollbarThumbColor,
          )
          ? ((_patchMap[InAppWebViewSettings$.horizontalScrollbarThumbColor]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .horizontalScrollbarThumbColor](
                        this.horizontalScrollbarThumbColor,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .horizontalScrollbarThumbColor]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .horizontalScrollbarThumbColor]
                          .applyTo(this.horizontalScrollbarThumbColor)
                    : _patchMap[InAppWebViewSettings$
                          .horizontalScrollbarThumbColor])
                as Color?
          : this.horizontalScrollbarThumbColor,
      horizontalScrollbarTrackColor:
          _patchMap.containsKey(
            InAppWebViewSettings$.horizontalScrollbarTrackColor,
          )
          ? ((_patchMap[InAppWebViewSettings$.horizontalScrollbarTrackColor]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .horizontalScrollbarTrackColor](
                        this.horizontalScrollbarTrackColor,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .horizontalScrollbarTrackColor]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .horizontalScrollbarTrackColor]
                          .applyTo(this.horizontalScrollbarTrackColor)
                    : _patchMap[InAppWebViewSettings$
                          .horizontalScrollbarTrackColor])
                as Color?
          : this.horizontalScrollbarTrackColor,
      algorithmicDarkeningAllowed:
          _patchMap.containsKey(
            InAppWebViewSettings$.algorithmicDarkeningAllowed,
          )
          ? ((_patchMap[InAppWebViewSettings$.algorithmicDarkeningAllowed]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .algorithmicDarkeningAllowed](
                        this.algorithmicDarkeningAllowed,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .algorithmicDarkeningAllowed]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .algorithmicDarkeningAllowed]
                          .applyTo(this.algorithmicDarkeningAllowed)
                    : _patchMap[InAppWebViewSettings$
                          .algorithmicDarkeningAllowed])
                as bool?
          : this.algorithmicDarkeningAllowed,
      paymentRequestEnabled:
          _patchMap.containsKey(InAppWebViewSettings$.paymentRequestEnabled)
          ? ((_patchMap[InAppWebViewSettings$.paymentRequestEnabled]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.paymentRequestEnabled](
                        this.paymentRequestEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.paymentRequestEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.paymentRequestEnabled]
                          .applyTo(this.paymentRequestEnabled)
                    : _patchMap[InAppWebViewSettings$.paymentRequestEnabled])
                as bool?
          : this.paymentRequestEnabled,
      webAuthenticationSupport:
          _patchMap.containsKey(InAppWebViewSettings$.webAuthenticationSupport)
          ? ((_patchMap[InAppWebViewSettings$.webAuthenticationSupport]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.webAuthenticationSupport](
                        this.webAuthenticationSupport,
                      )
                    : (_patchMap[InAppWebViewSettings$.webAuthenticationSupport]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.webAuthenticationSupport]
                          .applyTo(this.webAuthenticationSupport)
                    : _patchMap[InAppWebViewSettings$.webAuthenticationSupport])
                as WebAuthenticationSupport?
          : this.webAuthenticationSupport,
      enterpriseAuthenticationAppLinkPolicyEnabled:
          _patchMap.containsKey(
            InAppWebViewSettings$.enterpriseAuthenticationAppLinkPolicyEnabled,
          )
          ? ((_patchMap[InAppWebViewSettings$
                            .enterpriseAuthenticationAppLinkPolicyEnabled]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .enterpriseAuthenticationAppLinkPolicyEnabled](
                        this.enterpriseAuthenticationAppLinkPolicyEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .enterpriseAuthenticationAppLinkPolicyEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .enterpriseAuthenticationAppLinkPolicyEnabled]
                          .applyTo(
                            this.enterpriseAuthenticationAppLinkPolicyEnabled,
                          )
                    : _patchMap[InAppWebViewSettings$
                          .enterpriseAuthenticationAppLinkPolicyEnabled])
                as bool?
          : this.enterpriseAuthenticationAppLinkPolicyEnabled,
      defaultVideoPoster:
          _patchMap.containsKey(InAppWebViewSettings$.defaultVideoPoster)
          ? ((_patchMap[InAppWebViewSettings$.defaultVideoPoster] is Function)
                    ? _patchMap[InAppWebViewSettings$.defaultVideoPoster](
                        this.defaultVideoPoster,
                      )
                    : (_patchMap[InAppWebViewSettings$.defaultVideoPoster]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.defaultVideoPoster]
                          .applyTo(this.defaultVideoPoster)
                    : _patchMap[InAppWebViewSettings$.defaultVideoPoster])
                as Uint8List?
          : this.defaultVideoPoster,
      requestedWithHeaderOriginAllowList:
          _patchMap.containsKey(
            InAppWebViewSettings$.requestedWithHeaderOriginAllowList,
          )
          ? ((_patchMap[InAppWebViewSettings$
                            .requestedWithHeaderOriginAllowList]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .requestedWithHeaderOriginAllowList](
                        this.requestedWithHeaderOriginAllowList,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .requestedWithHeaderOriginAllowList]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .requestedWithHeaderOriginAllowList]
                          .applyTo(this.requestedWithHeaderOriginAllowList)
                    : _patchMap[InAppWebViewSettings$
                          .requestedWithHeaderOriginAllowList])
                as Set<String>?
          : this.requestedWithHeaderOriginAllowList,
      disallowOverScroll:
          _patchMap.containsKey(InAppWebViewSettings$.disallowOverScroll)
          ? ((_patchMap[InAppWebViewSettings$.disallowOverScroll] is Function)
                    ? _patchMap[InAppWebViewSettings$.disallowOverScroll](
                        this.disallowOverScroll,
                      )
                    : (_patchMap[InAppWebViewSettings$.disallowOverScroll]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.disallowOverScroll]
                          .applyTo(this.disallowOverScroll)
                    : _patchMap[InAppWebViewSettings$.disallowOverScroll])
                as bool?
          : this.disallowOverScroll,
      enableViewportScale:
          _patchMap.containsKey(InAppWebViewSettings$.enableViewportScale)
          ? ((_patchMap[InAppWebViewSettings$.enableViewportScale] is Function)
                    ? _patchMap[InAppWebViewSettings$.enableViewportScale](
                        this.enableViewportScale,
                      )
                    : (_patchMap[InAppWebViewSettings$.enableViewportScale]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.enableViewportScale]
                          .applyTo(this.enableViewportScale)
                    : _patchMap[InAppWebViewSettings$.enableViewportScale])
                as bool?
          : this.enableViewportScale,
      suppressesIncrementalRendering:
          _patchMap.containsKey(
            InAppWebViewSettings$.suppressesIncrementalRendering,
          )
          ? ((_patchMap[InAppWebViewSettings$.suppressesIncrementalRendering]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .suppressesIncrementalRendering](
                        this.suppressesIncrementalRendering,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .suppressesIncrementalRendering]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .suppressesIncrementalRendering]
                          .applyTo(this.suppressesIncrementalRendering)
                    : _patchMap[InAppWebViewSettings$
                          .suppressesIncrementalRendering])
                as bool?
          : this.suppressesIncrementalRendering,
      allowsAirPlayForMediaPlayback:
          _patchMap.containsKey(
            InAppWebViewSettings$.allowsAirPlayForMediaPlayback,
          )
          ? ((_patchMap[InAppWebViewSettings$.allowsAirPlayForMediaPlayback]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .allowsAirPlayForMediaPlayback](
                        this.allowsAirPlayForMediaPlayback,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .allowsAirPlayForMediaPlayback]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .allowsAirPlayForMediaPlayback]
                          .applyTo(this.allowsAirPlayForMediaPlayback)
                    : _patchMap[InAppWebViewSettings$
                          .allowsAirPlayForMediaPlayback])
                as bool?
          : this.allowsAirPlayForMediaPlayback,
      allowsBackForwardNavigationGestures:
          _patchMap.containsKey(
            InAppWebViewSettings$.allowsBackForwardNavigationGestures,
          )
          ? ((_patchMap[InAppWebViewSettings$
                            .allowsBackForwardNavigationGestures]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .allowsBackForwardNavigationGestures](
                        this.allowsBackForwardNavigationGestures,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .allowsBackForwardNavigationGestures]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .allowsBackForwardNavigationGestures]
                          .applyTo(this.allowsBackForwardNavigationGestures)
                    : _patchMap[InAppWebViewSettings$
                          .allowsBackForwardNavigationGestures])
                as bool?
          : this.allowsBackForwardNavigationGestures,
      allowsLinkPreview:
          _patchMap.containsKey(InAppWebViewSettings$.allowsLinkPreview)
          ? ((_patchMap[InAppWebViewSettings$.allowsLinkPreview] is Function)
                    ? _patchMap[InAppWebViewSettings$.allowsLinkPreview](
                        this.allowsLinkPreview,
                      )
                    : (_patchMap[InAppWebViewSettings$.allowsLinkPreview]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.allowsLinkPreview]
                          .applyTo(this.allowsLinkPreview)
                    : _patchMap[InAppWebViewSettings$.allowsLinkPreview])
                as bool?
          : this.allowsLinkPreview,
      ignoresViewportScaleLimits:
          _patchMap.containsKey(
            InAppWebViewSettings$.ignoresViewportScaleLimits,
          )
          ? ((_patchMap[InAppWebViewSettings$.ignoresViewportScaleLimits]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .ignoresViewportScaleLimits](
                        this.ignoresViewportScaleLimits,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .ignoresViewportScaleLimits]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .ignoresViewportScaleLimits]
                          .applyTo(this.ignoresViewportScaleLimits)
                    : _patchMap[InAppWebViewSettings$
                          .ignoresViewportScaleLimits])
                as bool?
          : this.ignoresViewportScaleLimits,
      allowsInlineMediaPlayback:
          _patchMap.containsKey(InAppWebViewSettings$.allowsInlineMediaPlayback)
          ? ((_patchMap[InAppWebViewSettings$.allowsInlineMediaPlayback]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .allowsInlineMediaPlayback](
                        this.allowsInlineMediaPlayback,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .allowsInlineMediaPlayback]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.allowsInlineMediaPlayback]
                          .applyTo(this.allowsInlineMediaPlayback)
                    : _patchMap[InAppWebViewSettings$
                          .allowsInlineMediaPlayback])
                as bool?
          : this.allowsInlineMediaPlayback,
      allowsPictureInPictureMediaPlayback:
          _patchMap.containsKey(
            InAppWebViewSettings$.allowsPictureInPictureMediaPlayback,
          )
          ? ((_patchMap[InAppWebViewSettings$
                            .allowsPictureInPictureMediaPlayback]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .allowsPictureInPictureMediaPlayback](
                        this.allowsPictureInPictureMediaPlayback,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .allowsPictureInPictureMediaPlayback]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .allowsPictureInPictureMediaPlayback]
                          .applyTo(this.allowsPictureInPictureMediaPlayback)
                    : _patchMap[InAppWebViewSettings$
                          .allowsPictureInPictureMediaPlayback])
                as bool?
          : this.allowsPictureInPictureMediaPlayback,
      isFraudulentWebsiteWarningEnabled:
          _patchMap.containsKey(
            InAppWebViewSettings$.isFraudulentWebsiteWarningEnabled,
          )
          ? ((_patchMap[InAppWebViewSettings$.isFraudulentWebsiteWarningEnabled]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .isFraudulentWebsiteWarningEnabled](
                        this.isFraudulentWebsiteWarningEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .isFraudulentWebsiteWarningEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .isFraudulentWebsiteWarningEnabled]
                          .applyTo(this.isFraudulentWebsiteWarningEnabled)
                    : _patchMap[InAppWebViewSettings$
                          .isFraudulentWebsiteWarningEnabled])
                as bool?
          : this.isFraudulentWebsiteWarningEnabled,
      selectionGranularity:
          _patchMap.containsKey(InAppWebViewSettings$.selectionGranularity)
          ? ((_patchMap[InAppWebViewSettings$.selectionGranularity] is Function)
                    ? _patchMap[InAppWebViewSettings$.selectionGranularity](
                        this.selectionGranularity,
                      )
                    : (_patchMap[InAppWebViewSettings$.selectionGranularity]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.selectionGranularity]
                          .applyTo(this.selectionGranularity)
                    : _patchMap[InAppWebViewSettings$.selectionGranularity])
                as SelectionGranularity?
          : this.selectionGranularity,
      dataDetectorTypes:
          _patchMap.containsKey(InAppWebViewSettings$.dataDetectorTypes)
          ? ((_patchMap[InAppWebViewSettings$.dataDetectorTypes] is Function)
                    ? _patchMap[InAppWebViewSettings$.dataDetectorTypes](
                        this.dataDetectorTypes,
                      )
                    : (_patchMap[InAppWebViewSettings$.dataDetectorTypes]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.dataDetectorTypes]
                          .applyTo(this.dataDetectorTypes)
                    : _patchMap[InAppWebViewSettings$.dataDetectorTypes])
                as List<DataDetectorTypes>?
          : this.dataDetectorTypes,
      sharedCookiesEnabled:
          _patchMap.containsKey(InAppWebViewSettings$.sharedCookiesEnabled)
          ? ((_patchMap[InAppWebViewSettings$.sharedCookiesEnabled] is Function)
                    ? _patchMap[InAppWebViewSettings$.sharedCookiesEnabled](
                        this.sharedCookiesEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.sharedCookiesEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.sharedCookiesEnabled]
                          .applyTo(this.sharedCookiesEnabled)
                    : _patchMap[InAppWebViewSettings$.sharedCookiesEnabled])
                as bool?
          : this.sharedCookiesEnabled,
      automaticallyAdjustsScrollIndicatorInsets:
          _patchMap.containsKey(
            InAppWebViewSettings$.automaticallyAdjustsScrollIndicatorInsets,
          )
          ? ((_patchMap[InAppWebViewSettings$
                            .automaticallyAdjustsScrollIndicatorInsets]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .automaticallyAdjustsScrollIndicatorInsets](
                        this.automaticallyAdjustsScrollIndicatorInsets,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .automaticallyAdjustsScrollIndicatorInsets]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .automaticallyAdjustsScrollIndicatorInsets]
                          .applyTo(
                            this.automaticallyAdjustsScrollIndicatorInsets,
                          )
                    : _patchMap[InAppWebViewSettings$
                          .automaticallyAdjustsScrollIndicatorInsets])
                as bool?
          : this.automaticallyAdjustsScrollIndicatorInsets,
      accessibilityIgnoresInvertColors:
          _patchMap.containsKey(
            InAppWebViewSettings$.accessibilityIgnoresInvertColors,
          )
          ? ((_patchMap[InAppWebViewSettings$.accessibilityIgnoresInvertColors]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .accessibilityIgnoresInvertColors](
                        this.accessibilityIgnoresInvertColors,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .accessibilityIgnoresInvertColors]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .accessibilityIgnoresInvertColors]
                          .applyTo(this.accessibilityIgnoresInvertColors)
                    : _patchMap[InAppWebViewSettings$
                          .accessibilityIgnoresInvertColors])
                as bool?
          : this.accessibilityIgnoresInvertColors,
      decelerationRate:
          _patchMap.containsKey(InAppWebViewSettings$.decelerationRate)
          ? ((_patchMap[InAppWebViewSettings$.decelerationRate] is Function)
                    ? _patchMap[InAppWebViewSettings$.decelerationRate](
                        this.decelerationRate,
                      )
                    : (_patchMap[InAppWebViewSettings$.decelerationRate]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.decelerationRate].applyTo(
                        this.decelerationRate,
                      )
                    : _patchMap[InAppWebViewSettings$.decelerationRate])
                as ScrollViewDecelerationRate?
          : this.decelerationRate,
      alwaysBounceVertical:
          _patchMap.containsKey(InAppWebViewSettings$.alwaysBounceVertical)
          ? ((_patchMap[InAppWebViewSettings$.alwaysBounceVertical] is Function)
                    ? _patchMap[InAppWebViewSettings$.alwaysBounceVertical](
                        this.alwaysBounceVertical,
                      )
                    : (_patchMap[InAppWebViewSettings$.alwaysBounceVertical]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.alwaysBounceVertical]
                          .applyTo(this.alwaysBounceVertical)
                    : _patchMap[InAppWebViewSettings$.alwaysBounceVertical])
                as bool?
          : this.alwaysBounceVertical,
      alwaysBounceHorizontal:
          _patchMap.containsKey(InAppWebViewSettings$.alwaysBounceHorizontal)
          ? ((_patchMap[InAppWebViewSettings$.alwaysBounceHorizontal]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.alwaysBounceHorizontal](
                        this.alwaysBounceHorizontal,
                      )
                    : (_patchMap[InAppWebViewSettings$.alwaysBounceHorizontal]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.alwaysBounceHorizontal]
                          .applyTo(this.alwaysBounceHorizontal)
                    : _patchMap[InAppWebViewSettings$.alwaysBounceHorizontal])
                as bool?
          : this.alwaysBounceHorizontal,
      bouncesHorizontally:
          _patchMap.containsKey(InAppWebViewSettings$.bouncesHorizontally)
          ? ((_patchMap[InAppWebViewSettings$.bouncesHorizontally] is Function)
                    ? _patchMap[InAppWebViewSettings$.bouncesHorizontally](
                        this.bouncesHorizontally,
                      )
                    : (_patchMap[InAppWebViewSettings$.bouncesHorizontally]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.bouncesHorizontally]
                          .applyTo(this.bouncesHorizontally)
                    : _patchMap[InAppWebViewSettings$.bouncesHorizontally])
                as bool?
          : this.bouncesHorizontally,
      bouncesVertically:
          _patchMap.containsKey(InAppWebViewSettings$.bouncesVertically)
          ? ((_patchMap[InAppWebViewSettings$.bouncesVertically] is Function)
                    ? _patchMap[InAppWebViewSettings$.bouncesVertically](
                        this.bouncesVertically,
                      )
                    : (_patchMap[InAppWebViewSettings$.bouncesVertically]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.bouncesVertically]
                          .applyTo(this.bouncesVertically)
                    : _patchMap[InAppWebViewSettings$.bouncesVertically])
                as bool?
          : this.bouncesVertically,
      scrollsToTop: _patchMap.containsKey(InAppWebViewSettings$.scrollsToTop)
          ? ((_patchMap[InAppWebViewSettings$.scrollsToTop] is Function)
                    ? _patchMap[InAppWebViewSettings$.scrollsToTop](
                        this.scrollsToTop,
                      )
                    : (_patchMap[InAppWebViewSettings$.scrollsToTop] is Patch)
                    ? _patchMap[InAppWebViewSettings$.scrollsToTop].applyTo(
                        this.scrollsToTop,
                      )
                    : _patchMap[InAppWebViewSettings$.scrollsToTop])
                as bool?
          : this.scrollsToTop,
      isPagingEnabled:
          _patchMap.containsKey(InAppWebViewSettings$.isPagingEnabled)
          ? ((_patchMap[InAppWebViewSettings$.isPagingEnabled] is Function)
                    ? _patchMap[InAppWebViewSettings$.isPagingEnabled](
                        this.isPagingEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.isPagingEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.isPagingEnabled].applyTo(
                        this.isPagingEnabled,
                      )
                    : _patchMap[InAppWebViewSettings$.isPagingEnabled])
                as bool?
          : this.isPagingEnabled,
      maximumZoomScale:
          _patchMap.containsKey(InAppWebViewSettings$.maximumZoomScale)
          ? ((_patchMap[InAppWebViewSettings$.maximumZoomScale] is Function)
                    ? _patchMap[InAppWebViewSettings$.maximumZoomScale](
                        this.maximumZoomScale,
                      )
                    : (_patchMap[InAppWebViewSettings$.maximumZoomScale]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.maximumZoomScale].applyTo(
                        this.maximumZoomScale,
                      )
                    : _patchMap[InAppWebViewSettings$.maximumZoomScale])
                as double?
          : this.maximumZoomScale,
      minimumZoomScale:
          _patchMap.containsKey(InAppWebViewSettings$.minimumZoomScale)
          ? ((_patchMap[InAppWebViewSettings$.minimumZoomScale] is Function)
                    ? _patchMap[InAppWebViewSettings$.minimumZoomScale](
                        this.minimumZoomScale,
                      )
                    : (_patchMap[InAppWebViewSettings$.minimumZoomScale]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.minimumZoomScale].applyTo(
                        this.minimumZoomScale,
                      )
                    : _patchMap[InAppWebViewSettings$.minimumZoomScale])
                as double?
          : this.minimumZoomScale,
      contentInsetAdjustmentBehavior:
          _patchMap.containsKey(
            InAppWebViewSettings$.contentInsetAdjustmentBehavior,
          )
          ? ((_patchMap[InAppWebViewSettings$.contentInsetAdjustmentBehavior]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .contentInsetAdjustmentBehavior](
                        this.contentInsetAdjustmentBehavior,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .contentInsetAdjustmentBehavior]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .contentInsetAdjustmentBehavior]
                          .applyTo(this.contentInsetAdjustmentBehavior)
                    : _patchMap[InAppWebViewSettings$
                          .contentInsetAdjustmentBehavior])
                as ScrollViewContentInsetAdjustmentBehavior?
          : this.contentInsetAdjustmentBehavior,
      isDirectionalLockEnabled:
          _patchMap.containsKey(InAppWebViewSettings$.isDirectionalLockEnabled)
          ? ((_patchMap[InAppWebViewSettings$.isDirectionalLockEnabled]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.isDirectionalLockEnabled](
                        this.isDirectionalLockEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.isDirectionalLockEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.isDirectionalLockEnabled]
                          .applyTo(this.isDirectionalLockEnabled)
                    : _patchMap[InAppWebViewSettings$.isDirectionalLockEnabled])
                as bool?
          : this.isDirectionalLockEnabled,
      mediaType: _patchMap.containsKey(InAppWebViewSettings$.mediaType)
          ? ((_patchMap[InAppWebViewSettings$.mediaType] is Function)
                    ? _patchMap[InAppWebViewSettings$.mediaType](this.mediaType)
                    : (_patchMap[InAppWebViewSettings$.mediaType] is Patch)
                    ? _patchMap[InAppWebViewSettings$.mediaType].applyTo(
                        this.mediaType,
                      )
                    : _patchMap[InAppWebViewSettings$.mediaType])
                as String?
          : this.mediaType,
      pageZoom: _patchMap.containsKey(InAppWebViewSettings$.pageZoom)
          ? ((_patchMap[InAppWebViewSettings$.pageZoom] is Function)
                    ? _patchMap[InAppWebViewSettings$.pageZoom](this.pageZoom)
                    : (_patchMap[InAppWebViewSettings$.pageZoom] is Patch)
                    ? _patchMap[InAppWebViewSettings$.pageZoom].applyTo(
                        this.pageZoom,
                      )
                    : _patchMap[InAppWebViewSettings$.pageZoom])
                as double?
          : this.pageZoom,
      limitsNavigationsToAppBoundDomains:
          _patchMap.containsKey(
            InAppWebViewSettings$.limitsNavigationsToAppBoundDomains,
          )
          ? ((_patchMap[InAppWebViewSettings$
                            .limitsNavigationsToAppBoundDomains]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .limitsNavigationsToAppBoundDomains](
                        this.limitsNavigationsToAppBoundDomains,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .limitsNavigationsToAppBoundDomains]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .limitsNavigationsToAppBoundDomains]
                          .applyTo(this.limitsNavigationsToAppBoundDomains)
                    : _patchMap[InAppWebViewSettings$
                          .limitsNavigationsToAppBoundDomains])
                as bool?
          : this.limitsNavigationsToAppBoundDomains,
      useOnNavigationResponse:
          _patchMap.containsKey(InAppWebViewSettings$.useOnNavigationResponse)
          ? ((_patchMap[InAppWebViewSettings$.useOnNavigationResponse]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.useOnNavigationResponse](
                        this.useOnNavigationResponse,
                      )
                    : (_patchMap[InAppWebViewSettings$.useOnNavigationResponse]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.useOnNavigationResponse]
                          .applyTo(this.useOnNavigationResponse)
                    : _patchMap[InAppWebViewSettings$.useOnNavigationResponse])
                as bool?
          : this.useOnNavigationResponse,
      applePayAPIEnabled:
          _patchMap.containsKey(InAppWebViewSettings$.applePayAPIEnabled)
          ? ((_patchMap[InAppWebViewSettings$.applePayAPIEnabled] is Function)
                    ? _patchMap[InAppWebViewSettings$.applePayAPIEnabled](
                        this.applePayAPIEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.applePayAPIEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.applePayAPIEnabled]
                          .applyTo(this.applePayAPIEnabled)
                    : _patchMap[InAppWebViewSettings$.applePayAPIEnabled])
                as bool?
          : this.applePayAPIEnabled,
      allowingReadAccessTo:
          _patchMap.containsKey(InAppWebViewSettings$.allowingReadAccessTo)
          ? ((_patchMap[InAppWebViewSettings$.allowingReadAccessTo] is Function)
                    ? _patchMap[InAppWebViewSettings$.allowingReadAccessTo](
                        this.allowingReadAccessTo,
                      )
                    : (_patchMap[InAppWebViewSettings$.allowingReadAccessTo]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.allowingReadAccessTo]
                          .applyTo(this.allowingReadAccessTo)
                    : _patchMap[InAppWebViewSettings$.allowingReadAccessTo])
                as WebUri?
          : this.allowingReadAccessTo,
      disableLongPressContextMenuOnLinks:
          _patchMap.containsKey(
            InAppWebViewSettings$.disableLongPressContextMenuOnLinks,
          )
          ? ((_patchMap[InAppWebViewSettings$
                            .disableLongPressContextMenuOnLinks]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .disableLongPressContextMenuOnLinks](
                        this.disableLongPressContextMenuOnLinks,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .disableLongPressContextMenuOnLinks]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .disableLongPressContextMenuOnLinks]
                          .applyTo(this.disableLongPressContextMenuOnLinks)
                    : _patchMap[InAppWebViewSettings$
                          .disableLongPressContextMenuOnLinks])
                as bool?
          : this.disableLongPressContextMenuOnLinks,
      disableInputAccessoryView:
          _patchMap.containsKey(InAppWebViewSettings$.disableInputAccessoryView)
          ? ((_patchMap[InAppWebViewSettings$.disableInputAccessoryView]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .disableInputAccessoryView](
                        this.disableInputAccessoryView,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .disableInputAccessoryView]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.disableInputAccessoryView]
                          .applyTo(this.disableInputAccessoryView)
                    : _patchMap[InAppWebViewSettings$
                          .disableInputAccessoryView])
                as bool?
          : this.disableInputAccessoryView,
      underPageBackgroundColor:
          _patchMap.containsKey(InAppWebViewSettings$.underPageBackgroundColor)
          ? ((_patchMap[InAppWebViewSettings$.underPageBackgroundColor]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.underPageBackgroundColor](
                        this.underPageBackgroundColor,
                      )
                    : (_patchMap[InAppWebViewSettings$.underPageBackgroundColor]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.underPageBackgroundColor]
                          .applyTo(this.underPageBackgroundColor)
                    : _patchMap[InAppWebViewSettings$.underPageBackgroundColor])
                as Color?
          : this.underPageBackgroundColor,
      isTextInteractionEnabled:
          _patchMap.containsKey(InAppWebViewSettings$.isTextInteractionEnabled)
          ? ((_patchMap[InAppWebViewSettings$.isTextInteractionEnabled]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.isTextInteractionEnabled](
                        this.isTextInteractionEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.isTextInteractionEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.isTextInteractionEnabled]
                          .applyTo(this.isTextInteractionEnabled)
                    : _patchMap[InAppWebViewSettings$.isTextInteractionEnabled])
                as bool?
          : this.isTextInteractionEnabled,
      isSiteSpecificQuirksModeEnabled:
          _patchMap.containsKey(
            InAppWebViewSettings$.isSiteSpecificQuirksModeEnabled,
          )
          ? ((_patchMap[InAppWebViewSettings$.isSiteSpecificQuirksModeEnabled]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .isSiteSpecificQuirksModeEnabled](
                        this.isSiteSpecificQuirksModeEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .isSiteSpecificQuirksModeEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .isSiteSpecificQuirksModeEnabled]
                          .applyTo(this.isSiteSpecificQuirksModeEnabled)
                    : _patchMap[InAppWebViewSettings$
                          .isSiteSpecificQuirksModeEnabled])
                as bool?
          : this.isSiteSpecificQuirksModeEnabled,
      upgradeKnownHostsToHTTPS:
          _patchMap.containsKey(InAppWebViewSettings$.upgradeKnownHostsToHTTPS)
          ? ((_patchMap[InAppWebViewSettings$.upgradeKnownHostsToHTTPS]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.upgradeKnownHostsToHTTPS](
                        this.upgradeKnownHostsToHTTPS,
                      )
                    : (_patchMap[InAppWebViewSettings$.upgradeKnownHostsToHTTPS]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.upgradeKnownHostsToHTTPS]
                          .applyTo(this.upgradeKnownHostsToHTTPS)
                    : _patchMap[InAppWebViewSettings$.upgradeKnownHostsToHTTPS])
                as bool?
          : this.upgradeKnownHostsToHTTPS,
      isElementFullscreenEnabled:
          _patchMap.containsKey(
            InAppWebViewSettings$.isElementFullscreenEnabled,
          )
          ? ((_patchMap[InAppWebViewSettings$.isElementFullscreenEnabled]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .isElementFullscreenEnabled](
                        this.isElementFullscreenEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .isElementFullscreenEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .isElementFullscreenEnabled]
                          .applyTo(this.isElementFullscreenEnabled)
                    : _patchMap[InAppWebViewSettings$
                          .isElementFullscreenEnabled])
                as bool?
          : this.isElementFullscreenEnabled,
      isFindInteractionEnabled:
          _patchMap.containsKey(InAppWebViewSettings$.isFindInteractionEnabled)
          ? ((_patchMap[InAppWebViewSettings$.isFindInteractionEnabled]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.isFindInteractionEnabled](
                        this.isFindInteractionEnabled,
                      )
                    : (_patchMap[InAppWebViewSettings$.isFindInteractionEnabled]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.isFindInteractionEnabled]
                          .applyTo(this.isFindInteractionEnabled)
                    : _patchMap[InAppWebViewSettings$.isFindInteractionEnabled])
                as bool?
          : this.isFindInteractionEnabled,
      minimumViewportInset:
          _patchMap.containsKey(InAppWebViewSettings$.minimumViewportInset)
          ? ((_patchMap[InAppWebViewSettings$.minimumViewportInset] is Function)
                    ? _patchMap[InAppWebViewSettings$.minimumViewportInset](
                        this.minimumViewportInset,
                      )
                    : (_patchMap[InAppWebViewSettings$.minimumViewportInset]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.minimumViewportInset]
                          .applyTo(this.minimumViewportInset)
                    : _patchMap[InAppWebViewSettings$.minimumViewportInset])
                as EdgeInsets?
          : this.minimumViewportInset,
      maximumViewportInset:
          _patchMap.containsKey(InAppWebViewSettings$.maximumViewportInset)
          ? ((_patchMap[InAppWebViewSettings$.maximumViewportInset] is Function)
                    ? _patchMap[InAppWebViewSettings$.maximumViewportInset](
                        this.maximumViewportInset,
                      )
                    : (_patchMap[InAppWebViewSettings$.maximumViewportInset]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.maximumViewportInset]
                          .applyTo(this.maximumViewportInset)
                    : _patchMap[InAppWebViewSettings$.maximumViewportInset])
                as EdgeInsets?
          : this.maximumViewportInset,
      isInspectable: _patchMap.containsKey(InAppWebViewSettings$.isInspectable)
          ? ((_patchMap[InAppWebViewSettings$.isInspectable] is Function)
                    ? _patchMap[InAppWebViewSettings$.isInspectable](
                        this.isInspectable,
                      )
                    : (_patchMap[InAppWebViewSettings$.isInspectable] is Patch)
                    ? _patchMap[InAppWebViewSettings$.isInspectable].applyTo(
                        this.isInspectable,
                      )
                    : _patchMap[InAppWebViewSettings$.isInspectable])
                as bool?
          : this.isInspectable,
      shouldPrintBackgrounds:
          _patchMap.containsKey(InAppWebViewSettings$.shouldPrintBackgrounds)
          ? ((_patchMap[InAppWebViewSettings$.shouldPrintBackgrounds]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.shouldPrintBackgrounds](
                        this.shouldPrintBackgrounds,
                      )
                    : (_patchMap[InAppWebViewSettings$.shouldPrintBackgrounds]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.shouldPrintBackgrounds]
                          .applyTo(this.shouldPrintBackgrounds)
                    : _patchMap[InAppWebViewSettings$.shouldPrintBackgrounds])
                as bool?
          : this.shouldPrintBackgrounds,
      allowBackgroundAudioPlaying:
          _patchMap.containsKey(
            InAppWebViewSettings$.allowBackgroundAudioPlaying,
          )
          ? ((_patchMap[InAppWebViewSettings$.allowBackgroundAudioPlaying]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .allowBackgroundAudioPlaying](
                        this.allowBackgroundAudioPlaying,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .allowBackgroundAudioPlaying]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .allowBackgroundAudioPlaying]
                          .applyTo(this.allowBackgroundAudioPlaying)
                    : _patchMap[InAppWebViewSettings$
                          .allowBackgroundAudioPlaying])
                as bool?
          : this.allowBackgroundAudioPlaying,
      webViewAssetLoader:
          _patchMap.containsKey(InAppWebViewSettings$.webViewAssetLoader)
          ? ((_patchMap[InAppWebViewSettings$.webViewAssetLoader] is Function)
                    ? _patchMap[InAppWebViewSettings$.webViewAssetLoader](
                        this.webViewAssetLoader,
                      )
                    : (_patchMap[InAppWebViewSettings$.webViewAssetLoader]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.webViewAssetLoader]
                          .applyTo(this.webViewAssetLoader)
                    : _patchMap[InAppWebViewSettings$.webViewAssetLoader])
                as WebViewAssetLoader?
          : this.webViewAssetLoader,
      iframeAllow: _patchMap.containsKey(InAppWebViewSettings$.iframeAllow)
          ? ((_patchMap[InAppWebViewSettings$.iframeAllow] is Function)
                    ? _patchMap[InAppWebViewSettings$.iframeAllow](
                        this.iframeAllow,
                      )
                    : (_patchMap[InAppWebViewSettings$.iframeAllow] is Patch)
                    ? _patchMap[InAppWebViewSettings$.iframeAllow].applyTo(
                        this.iframeAllow,
                      )
                    : _patchMap[InAppWebViewSettings$.iframeAllow])
                as String?
          : this.iframeAllow,
      iframeAllowFullscreen:
          _patchMap.containsKey(InAppWebViewSettings$.iframeAllowFullscreen)
          ? ((_patchMap[InAppWebViewSettings$.iframeAllowFullscreen]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.iframeAllowFullscreen](
                        this.iframeAllowFullscreen,
                      )
                    : (_patchMap[InAppWebViewSettings$.iframeAllowFullscreen]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.iframeAllowFullscreen]
                          .applyTo(this.iframeAllowFullscreen)
                    : _patchMap[InAppWebViewSettings$.iframeAllowFullscreen])
                as bool?
          : this.iframeAllowFullscreen,
      iframeSandbox: _patchMap.containsKey(InAppWebViewSettings$.iframeSandbox)
          ? ((_patchMap[InAppWebViewSettings$.iframeSandbox] is Function)
                    ? _patchMap[InAppWebViewSettings$.iframeSandbox](
                        this.iframeSandbox,
                      )
                    : (_patchMap[InAppWebViewSettings$.iframeSandbox] is Patch)
                    ? _patchMap[InAppWebViewSettings$.iframeSandbox].applyTo(
                        this.iframeSandbox,
                      )
                    : _patchMap[InAppWebViewSettings$.iframeSandbox])
                as Set<Sandbox>?
          : this.iframeSandbox,
      iframeReferrerPolicy:
          _patchMap.containsKey(InAppWebViewSettings$.iframeReferrerPolicy)
          ? ((_patchMap[InAppWebViewSettings$.iframeReferrerPolicy] is Function)
                    ? _patchMap[InAppWebViewSettings$.iframeReferrerPolicy](
                        this.iframeReferrerPolicy,
                      )
                    : (_patchMap[InAppWebViewSettings$.iframeReferrerPolicy]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.iframeReferrerPolicy]
                          .applyTo(this.iframeReferrerPolicy)
                    : _patchMap[InAppWebViewSettings$.iframeReferrerPolicy])
                as ReferrerPolicy?
          : this.iframeReferrerPolicy,
      iframeName: _patchMap.containsKey(InAppWebViewSettings$.iframeName)
          ? ((_patchMap[InAppWebViewSettings$.iframeName] is Function)
                    ? _patchMap[InAppWebViewSettings$.iframeName](
                        this.iframeName,
                      )
                    : (_patchMap[InAppWebViewSettings$.iframeName] is Patch)
                    ? _patchMap[InAppWebViewSettings$.iframeName].applyTo(
                        this.iframeName,
                      )
                    : _patchMap[InAppWebViewSettings$.iframeName])
                as String?
          : this.iframeName,
      iframeCsp: _patchMap.containsKey(InAppWebViewSettings$.iframeCsp)
          ? ((_patchMap[InAppWebViewSettings$.iframeCsp] is Function)
                    ? _patchMap[InAppWebViewSettings$.iframeCsp](this.iframeCsp)
                    : (_patchMap[InAppWebViewSettings$.iframeCsp] is Patch)
                    ? _patchMap[InAppWebViewSettings$.iframeCsp].applyTo(
                        this.iframeCsp,
                      )
                    : _patchMap[InAppWebViewSettings$.iframeCsp])
                as String?
          : this.iframeCsp,
      dismissDialogues:
          _patchMap.containsKey(InAppWebViewSettings$.dismissDialogues)
          ? ((_patchMap[InAppWebViewSettings$.dismissDialogues] is Function)
                    ? _patchMap[InAppWebViewSettings$.dismissDialogues](
                        this.dismissDialogues,
                      )
                    : (_patchMap[InAppWebViewSettings$.dismissDialogues]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.dismissDialogues].applyTo(
                        this.dismissDialogues,
                      )
                    : _patchMap[InAppWebViewSettings$.dismissDialogues])
                as bool?
          : this.dismissDialogues,
      insetsForWebContentToIgnore:
          _patchMap.containsKey(
            InAppWebViewSettings$.insetsForWebContentToIgnore,
          )
          ? ((_patchMap[InAppWebViewSettings$.insetsForWebContentToIgnore]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .insetsForWebContentToIgnore](
                        this.insetsForWebContentToIgnore,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .insetsForWebContentToIgnore]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .insetsForWebContentToIgnore]
                          .applyTo(this.insetsForWebContentToIgnore)
                    : _patchMap[InAppWebViewSettings$
                          .insetsForWebContentToIgnore])
                as List<AndroidWebViewInsets>?
          : this.insetsForWebContentToIgnore,
      useNetworkCapture:
          _patchMap.containsKey(InAppWebViewSettings$.useNetworkCapture)
          ? ((_patchMap[InAppWebViewSettings$.useNetworkCapture] is Function)
                    ? _patchMap[InAppWebViewSettings$.useNetworkCapture](
                        this.useNetworkCapture,
                      )
                    : (_patchMap[InAppWebViewSettings$.useNetworkCapture]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.useNetworkCapture]
                          .applyTo(this.useNetworkCapture)
                    : _patchMap[InAppWebViewSettings$.useNetworkCapture])
                as bool?
          : this.useNetworkCapture,
      networkCaptureMaxBodySize:
          _patchMap.containsKey(InAppWebViewSettings$.networkCaptureMaxBodySize)
          ? ((_patchMap[InAppWebViewSettings$.networkCaptureMaxBodySize]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .networkCaptureMaxBodySize](
                        this.networkCaptureMaxBodySize,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .networkCaptureMaxBodySize]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.networkCaptureMaxBodySize]
                          .applyTo(this.networkCaptureMaxBodySize)
                    : _patchMap[InAppWebViewSettings$
                          .networkCaptureMaxBodySize])
                as int?
          : this.networkCaptureMaxBodySize,
      networkCaptureBodies:
          _patchMap.containsKey(InAppWebViewSettings$.networkCaptureBodies)
          ? ((_patchMap[InAppWebViewSettings$.networkCaptureBodies] is Function)
                    ? _patchMap[InAppWebViewSettings$.networkCaptureBodies](
                        this.networkCaptureBodies,
                      )
                    : (_patchMap[InAppWebViewSettings$.networkCaptureBodies]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.networkCaptureBodies]
                          .applyTo(this.networkCaptureBodies)
                    : _patchMap[InAppWebViewSettings$.networkCaptureBodies])
                as bool?
          : this.networkCaptureBodies,
      networkCaptureBinaryBodies:
          _patchMap.containsKey(
            InAppWebViewSettings$.networkCaptureBinaryBodies,
          )
          ? ((_patchMap[InAppWebViewSettings$.networkCaptureBinaryBodies]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .networkCaptureBinaryBodies](
                        this.networkCaptureBinaryBodies,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .networkCaptureBinaryBodies]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .networkCaptureBinaryBodies]
                          .applyTo(this.networkCaptureBinaryBodies)
                    : _patchMap[InAppWebViewSettings$
                          .networkCaptureBinaryBodies])
                as bool?
          : this.networkCaptureBinaryBodies,
      networkCaptureUrlPatterns:
          _patchMap.containsKey(InAppWebViewSettings$.networkCaptureUrlPatterns)
          ? ((_patchMap[InAppWebViewSettings$.networkCaptureUrlPatterns]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .networkCaptureUrlPatterns](
                        this.networkCaptureUrlPatterns,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .networkCaptureUrlPatterns]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.networkCaptureUrlPatterns]
                          .applyTo(this.networkCaptureUrlPatterns)
                    : _patchMap[InAppWebViewSettings$
                          .networkCaptureUrlPatterns])
                as List<String>?
          : this.networkCaptureUrlPatterns,
      networkCaptureUrlPatternType:
          _patchMap.containsKey(
            InAppWebViewSettings$.networkCaptureUrlPatternType,
          )
          ? ((_patchMap[InAppWebViewSettings$.networkCaptureUrlPatternType]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .networkCaptureUrlPatternType](
                        this.networkCaptureUrlPatternType,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .networkCaptureUrlPatternType]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .networkCaptureUrlPatternType]
                          .applyTo(this.networkCaptureUrlPatternType)
                    : _patchMap[InAppWebViewSettings$
                          .networkCaptureUrlPatternType])
                as UrlPatternType?
          : this.networkCaptureUrlPatternType,
      networkCaptureResourceTypes:
          _patchMap.containsKey(
            InAppWebViewSettings$.networkCaptureResourceTypes,
          )
          ? ((_patchMap[InAppWebViewSettings$.networkCaptureResourceTypes]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$
                          .networkCaptureResourceTypes](
                        this.networkCaptureResourceTypes,
                      )
                    : (_patchMap[InAppWebViewSettings$
                              .networkCaptureResourceTypes]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$
                              .networkCaptureResourceTypes]
                          .applyTo(this.networkCaptureResourceTypes)
                    : _patchMap[InAppWebViewSettings$
                          .networkCaptureResourceTypes])
                as List<ResourceType>?
          : this.networkCaptureResourceTypes,
      networkCaptureMimeTypes:
          _patchMap.containsKey(InAppWebViewSettings$.networkCaptureMimeTypes)
          ? ((_patchMap[InAppWebViewSettings$.networkCaptureMimeTypes]
                        is Function)
                    ? _patchMap[InAppWebViewSettings$.networkCaptureMimeTypes](
                        this.networkCaptureMimeTypes,
                      )
                    : (_patchMap[InAppWebViewSettings$.networkCaptureMimeTypes]
                          is Patch)
                    ? _patchMap[InAppWebViewSettings$.networkCaptureMimeTypes]
                          .applyTo(this.networkCaptureMimeTypes)
                    : _patchMap[InAppWebViewSettings$.networkCaptureMimeTypes])
                as List<String>?
          : this.networkCaptureMimeTypes,
      networkCapture:
          _patchMap.containsKey(InAppWebViewSettings$.networkCapture)
          ? ((_patchMap[InAppWebViewSettings$.networkCapture] is Function)
                    ? _patchMap[InAppWebViewSettings$.networkCapture](
                        this.networkCapture,
                      )
                    : (_patchMap[InAppWebViewSettings$.networkCapture] is Patch)
                    ? _patchMap[InAppWebViewSettings$.networkCapture].applyTo(
                        this.networkCapture,
                      )
                    : _patchMap[InAppWebViewSettings$.networkCapture])
                as NetworkCaptureController?
          : this.networkCapture,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InAppWebViewSettings &&
        useShouldOverrideUrlLoading == other.useShouldOverrideUrlLoading &&
        useOnLoadResource == other.useOnLoadResource &&
        useOnDownloadStart == other.useOnDownloadStart &&
        userAgent == other.userAgent &&
        applicationNameForUserAgent == other.applicationNameForUserAgent &&
        javaScriptEnabled == other.javaScriptEnabled &&
        javaScriptCanOpenWindowsAutomatically ==
            other.javaScriptCanOpenWindowsAutomatically &&
        mediaPlaybackRequiresUserGesture ==
            other.mediaPlaybackRequiresUserGesture &&
        minimumFontSize == other.minimumFontSize &&
        verticalScrollBarEnabled == other.verticalScrollBarEnabled &&
        horizontalScrollBarEnabled == other.horizontalScrollBarEnabled &&
        resourceCustomSchemes == other.resourceCustomSchemes &&
        contentBlockers == other.contentBlockers &&
        preferredContentMode == other.preferredContentMode &&
        useShouldInterceptAjaxRequest == other.useShouldInterceptAjaxRequest &&
        interceptOnlyAsyncAjaxRequests ==
            other.interceptOnlyAsyncAjaxRequests &&
        useShouldInterceptFetchRequest ==
            other.useShouldInterceptFetchRequest &&
        incognito == other.incognito &&
        cacheEnabled == other.cacheEnabled &&
        transparentBackground == other.transparentBackground &&
        disableVerticalScroll == other.disableVerticalScroll &&
        disableHorizontalScroll == other.disableHorizontalScroll &&
        disableContextMenu == other.disableContextMenu &&
        stylusHandwritingEnabled == other.stylusHandwritingEnabled &&
        supportZoom == other.supportZoom &&
        allowFileAccessFromFileURLs == other.allowFileAccessFromFileURLs &&
        allowUniversalAccessFromFileURLs ==
            other.allowUniversalAccessFromFileURLs &&
        builtInZoomControls == other.builtInZoomControls &&
        displayZoomControls == other.displayZoomControls &&
        databaseEnabled == other.databaseEnabled &&
        domStorageEnabled == other.domStorageEnabled &&
        useWideViewPort == other.useWideViewPort &&
        safeBrowsingEnabled == other.safeBrowsingEnabled &&
        mixedContentMode == other.mixedContentMode &&
        allowContentAccess == other.allowContentAccess &&
        allowFileAccess == other.allowFileAccess &&
        blockNetworkImage == other.blockNetworkImage &&
        blockNetworkLoads == other.blockNetworkLoads &&
        cacheMode == other.cacheMode &&
        cursiveFontFamily == other.cursiveFontFamily &&
        defaultFixedFontSize == other.defaultFixedFontSize &&
        defaultFontSize == other.defaultFontSize &&
        defaultTextEncodingName == other.defaultTextEncodingName &&
        disabledActionModeMenuItems == other.disabledActionModeMenuItems &&
        fantasyFontFamily == other.fantasyFontFamily &&
        fixedFontFamily == other.fixedFontFamily &&
        forceDark == other.forceDark &&
        forceDarkStrategy == other.forceDarkStrategy &&
        geolocationEnabled == other.geolocationEnabled &&
        layoutAlgorithm == other.layoutAlgorithm &&
        loadWithOverviewMode == other.loadWithOverviewMode &&
        loadsImagesAutomatically == other.loadsImagesAutomatically &&
        minimumLogicalFontSize == other.minimumLogicalFontSize &&
        needInitialFocus == other.needInitialFocus &&
        offscreenPreRaster == other.offscreenPreRaster &&
        sansSerifFontFamily == other.sansSerifFontFamily &&
        serifFontFamily == other.serifFontFamily &&
        standardFontFamily == other.standardFontFamily &&
        saveFormData == other.saveFormData &&
        thirdPartyCookiesEnabled == other.thirdPartyCookiesEnabled &&
        hardwareAcceleration == other.hardwareAcceleration &&
        initialScale == other.initialScale &&
        supportMultipleWindows == other.supportMultipleWindows &&
        regexToCancelSubFramesLoading == other.regexToCancelSubFramesLoading &&
        regexToCancelOverrideUrlLoading ==
            other.regexToCancelOverrideUrlLoading &&
        useHybridComposition == other.useHybridComposition &&
        useShouldInterceptRequest == other.useShouldInterceptRequest &&
        useOnRenderProcessGone == other.useOnRenderProcessGone &&
        overScrollMode == other.overScrollMode &&
        networkAvailable == other.networkAvailable &&
        scrollBarStyle == other.scrollBarStyle &&
        verticalScrollbarPosition == other.verticalScrollbarPosition &&
        scrollBarDefaultDelayBeforeFade ==
            other.scrollBarDefaultDelayBeforeFade &&
        scrollbarFadingEnabled == other.scrollbarFadingEnabled &&
        scrollBarFadeDuration == other.scrollBarFadeDuration &&
        rendererPriorityPolicy == other.rendererPriorityPolicy &&
        disableDefaultErrorPage == other.disableDefaultErrorPage &&
        verticalScrollbarThumbColor == other.verticalScrollbarThumbColor &&
        verticalScrollbarTrackColor == other.verticalScrollbarTrackColor &&
        horizontalScrollbarThumbColor == other.horizontalScrollbarThumbColor &&
        horizontalScrollbarTrackColor == other.horizontalScrollbarTrackColor &&
        algorithmicDarkeningAllowed == other.algorithmicDarkeningAllowed &&
        paymentRequestEnabled == other.paymentRequestEnabled &&
        webAuthenticationSupport == other.webAuthenticationSupport &&
        enterpriseAuthenticationAppLinkPolicyEnabled ==
            other.enterpriseAuthenticationAppLinkPolicyEnabled &&
        defaultVideoPoster == other.defaultVideoPoster &&
        requestedWithHeaderOriginAllowList ==
            other.requestedWithHeaderOriginAllowList &&
        disallowOverScroll == other.disallowOverScroll &&
        enableViewportScale == other.enableViewportScale &&
        suppressesIncrementalRendering ==
            other.suppressesIncrementalRendering &&
        allowsAirPlayForMediaPlayback == other.allowsAirPlayForMediaPlayback &&
        allowsBackForwardNavigationGestures ==
            other.allowsBackForwardNavigationGestures &&
        allowsLinkPreview == other.allowsLinkPreview &&
        ignoresViewportScaleLimits == other.ignoresViewportScaleLimits &&
        allowsInlineMediaPlayback == other.allowsInlineMediaPlayback &&
        allowsPictureInPictureMediaPlayback ==
            other.allowsPictureInPictureMediaPlayback &&
        isFraudulentWebsiteWarningEnabled ==
            other.isFraudulentWebsiteWarningEnabled &&
        selectionGranularity == other.selectionGranularity &&
        dataDetectorTypes == other.dataDetectorTypes &&
        sharedCookiesEnabled == other.sharedCookiesEnabled &&
        automaticallyAdjustsScrollIndicatorInsets ==
            other.automaticallyAdjustsScrollIndicatorInsets &&
        accessibilityIgnoresInvertColors ==
            other.accessibilityIgnoresInvertColors &&
        decelerationRate == other.decelerationRate &&
        alwaysBounceVertical == other.alwaysBounceVertical &&
        alwaysBounceHorizontal == other.alwaysBounceHorizontal &&
        bouncesHorizontally == other.bouncesHorizontally &&
        bouncesVertically == other.bouncesVertically &&
        scrollsToTop == other.scrollsToTop &&
        isPagingEnabled == other.isPagingEnabled &&
        maximumZoomScale == other.maximumZoomScale &&
        minimumZoomScale == other.minimumZoomScale &&
        contentInsetAdjustmentBehavior ==
            other.contentInsetAdjustmentBehavior &&
        isDirectionalLockEnabled == other.isDirectionalLockEnabled &&
        mediaType == other.mediaType &&
        pageZoom == other.pageZoom &&
        limitsNavigationsToAppBoundDomains ==
            other.limitsNavigationsToAppBoundDomains &&
        useOnNavigationResponse == other.useOnNavigationResponse &&
        applePayAPIEnabled == other.applePayAPIEnabled &&
        allowingReadAccessTo == other.allowingReadAccessTo &&
        disableLongPressContextMenuOnLinks ==
            other.disableLongPressContextMenuOnLinks &&
        disableInputAccessoryView == other.disableInputAccessoryView &&
        underPageBackgroundColor == other.underPageBackgroundColor &&
        isTextInteractionEnabled == other.isTextInteractionEnabled &&
        isSiteSpecificQuirksModeEnabled ==
            other.isSiteSpecificQuirksModeEnabled &&
        upgradeKnownHostsToHTTPS == other.upgradeKnownHostsToHTTPS &&
        isElementFullscreenEnabled == other.isElementFullscreenEnabled &&
        isFindInteractionEnabled == other.isFindInteractionEnabled &&
        minimumViewportInset == other.minimumViewportInset &&
        maximumViewportInset == other.maximumViewportInset &&
        isInspectable == other.isInspectable &&
        shouldPrintBackgrounds == other.shouldPrintBackgrounds &&
        allowBackgroundAudioPlaying == other.allowBackgroundAudioPlaying &&
        webViewAssetLoader == other.webViewAssetLoader &&
        iframeAllow == other.iframeAllow &&
        iframeAllowFullscreen == other.iframeAllowFullscreen &&
        iframeSandbox == other.iframeSandbox &&
        iframeReferrerPolicy == other.iframeReferrerPolicy &&
        iframeName == other.iframeName &&
        iframeCsp == other.iframeCsp &&
        dismissDialogues == other.dismissDialogues &&
        insetsForWebContentToIgnore == other.insetsForWebContentToIgnore &&
        useNetworkCapture == other.useNetworkCapture &&
        networkCaptureMaxBodySize == other.networkCaptureMaxBodySize &&
        networkCaptureBodies == other.networkCaptureBodies &&
        networkCaptureBinaryBodies == other.networkCaptureBinaryBodies &&
        networkCaptureUrlPatterns == other.networkCaptureUrlPatterns &&
        networkCaptureUrlPatternType == other.networkCaptureUrlPatternType &&
        networkCaptureResourceTypes == other.networkCaptureResourceTypes &&
        networkCaptureMimeTypes == other.networkCaptureMimeTypes &&
        networkCapture == other.networkCapture;
  }

  @override
  int get hashCode {
    return Object.hash(
          this.useShouldOverrideUrlLoading,
          this.useOnLoadResource,
          this.useOnDownloadStart,
          this.userAgent,
          this.applicationNameForUserAgent,
          this.javaScriptEnabled,
          this.javaScriptCanOpenWindowsAutomatically,
          this.mediaPlaybackRequiresUserGesture,
          this.minimumFontSize,
          this.verticalScrollBarEnabled,
          this.horizontalScrollBarEnabled,
          this.resourceCustomSchemes,
          this.contentBlockers,
          this.preferredContentMode,
          this.useShouldInterceptAjaxRequest,
          this.interceptOnlyAsyncAjaxRequests,
          this.useShouldInterceptFetchRequest,
          this.incognito,
          this.cacheEnabled,
          this.transparentBackground,
        ) ^
        Object.hash(
          this.disableVerticalScroll,
          this.disableHorizontalScroll,
          this.disableContextMenu,
          this.stylusHandwritingEnabled,
          this.supportZoom,
          this.allowFileAccessFromFileURLs,
          this.allowUniversalAccessFromFileURLs,
          this.builtInZoomControls,
          this.displayZoomControls,
          this.databaseEnabled,
          this.domStorageEnabled,
          this.useWideViewPort,
          this.safeBrowsingEnabled,
          this.mixedContentMode,
          this.allowContentAccess,
          this.allowFileAccess,
          this.blockNetworkImage,
          this.blockNetworkLoads,
          this.cacheMode,
          this.cursiveFontFamily,
        ) ^
        Object.hash(
          this.defaultFixedFontSize,
          this.defaultFontSize,
          this.defaultTextEncodingName,
          this.disabledActionModeMenuItems,
          this.fantasyFontFamily,
          this.fixedFontFamily,
          this.forceDark,
          this.forceDarkStrategy,
          this.geolocationEnabled,
          this.layoutAlgorithm,
          this.loadWithOverviewMode,
          this.loadsImagesAutomatically,
          this.minimumLogicalFontSize,
          this.needInitialFocus,
          this.offscreenPreRaster,
          this.sansSerifFontFamily,
          this.serifFontFamily,
          this.standardFontFamily,
          this.saveFormData,
          this.thirdPartyCookiesEnabled,
        ) ^
        Object.hash(
          this.hardwareAcceleration,
          this.initialScale,
          this.supportMultipleWindows,
          this.regexToCancelSubFramesLoading,
          this.regexToCancelOverrideUrlLoading,
          this.useHybridComposition,
          this.useShouldInterceptRequest,
          this.useOnRenderProcessGone,
          this.overScrollMode,
          this.networkAvailable,
          this.scrollBarStyle,
          this.verticalScrollbarPosition,
          this.scrollBarDefaultDelayBeforeFade,
          this.scrollbarFadingEnabled,
          this.scrollBarFadeDuration,
          this.rendererPriorityPolicy,
          this.disableDefaultErrorPage,
          this.verticalScrollbarThumbColor,
          this.verticalScrollbarTrackColor,
          this.horizontalScrollbarThumbColor,
        ) ^
        Object.hash(
          this.horizontalScrollbarTrackColor,
          this.algorithmicDarkeningAllowed,
          this.paymentRequestEnabled,
          this.webAuthenticationSupport,
          this.enterpriseAuthenticationAppLinkPolicyEnabled,
          this.defaultVideoPoster,
          this.requestedWithHeaderOriginAllowList,
          this.disallowOverScroll,
          this.enableViewportScale,
          this.suppressesIncrementalRendering,
          this.allowsAirPlayForMediaPlayback,
          this.allowsBackForwardNavigationGestures,
          this.allowsLinkPreview,
          this.ignoresViewportScaleLimits,
          this.allowsInlineMediaPlayback,
          this.allowsPictureInPictureMediaPlayback,
          this.isFraudulentWebsiteWarningEnabled,
          this.selectionGranularity,
          this.dataDetectorTypes,
          this.sharedCookiesEnabled,
        ) ^
        Object.hash(
          this.automaticallyAdjustsScrollIndicatorInsets,
          this.accessibilityIgnoresInvertColors,
          this.decelerationRate,
          this.alwaysBounceVertical,
          this.alwaysBounceHorizontal,
          this.bouncesHorizontally,
          this.bouncesVertically,
          this.scrollsToTop,
          this.isPagingEnabled,
          this.maximumZoomScale,
          this.minimumZoomScale,
          this.contentInsetAdjustmentBehavior,
          this.isDirectionalLockEnabled,
          this.mediaType,
          this.pageZoom,
          this.limitsNavigationsToAppBoundDomains,
          this.useOnNavigationResponse,
          this.applePayAPIEnabled,
          this.allowingReadAccessTo,
          this.disableLongPressContextMenuOnLinks,
        ) ^
        Object.hash(
          this.disableInputAccessoryView,
          this.underPageBackgroundColor,
          this.isTextInteractionEnabled,
          this.isSiteSpecificQuirksModeEnabled,
          this.upgradeKnownHostsToHTTPS,
          this.isElementFullscreenEnabled,
          this.isFindInteractionEnabled,
          this.minimumViewportInset,
          this.maximumViewportInset,
          this.isInspectable,
          this.shouldPrintBackgrounds,
          this.allowBackgroundAudioPlaying,
          this.webViewAssetLoader,
          this.iframeAllow,
          this.iframeAllowFullscreen,
          this.iframeSandbox,
          this.iframeReferrerPolicy,
          this.iframeName,
          this.iframeCsp,
          this.dismissDialogues,
        ) ^
        Object.hash(
          this.insetsForWebContentToIgnore,
          this.useNetworkCapture,
          this.networkCaptureMaxBodySize,
          this.networkCaptureBodies,
          this.networkCaptureBinaryBodies,
          this.networkCaptureUrlPatterns,
          this.networkCaptureUrlPatternType,
          this.networkCaptureResourceTypes,
          this.networkCaptureMimeTypes,
          this.networkCapture,
        );
  }

  @override
  String toString() {
    return 'InAppWebViewSettings(' +
        'useShouldOverrideUrlLoading: ${useShouldOverrideUrlLoading}' +
        ', ' +
        'useOnLoadResource: ${useOnLoadResource}' +
        ', ' +
        'useOnDownloadStart: ${useOnDownloadStart}' +
        ', ' +
        'userAgent: ${userAgent}' +
        ', ' +
        'applicationNameForUserAgent: ${applicationNameForUserAgent}' +
        ', ' +
        'javaScriptEnabled: ${javaScriptEnabled}' +
        ', ' +
        'javaScriptCanOpenWindowsAutomatically: ${javaScriptCanOpenWindowsAutomatically}' +
        ', ' +
        'mediaPlaybackRequiresUserGesture: ${mediaPlaybackRequiresUserGesture}' +
        ', ' +
        'minimumFontSize: ${minimumFontSize}' +
        ', ' +
        'verticalScrollBarEnabled: ${verticalScrollBarEnabled}' +
        ', ' +
        'horizontalScrollBarEnabled: ${horizontalScrollBarEnabled}' +
        ', ' +
        'resourceCustomSchemes: ${resourceCustomSchemes}' +
        ', ' +
        'contentBlockers: ${contentBlockers}' +
        ', ' +
        'preferredContentMode: ${preferredContentMode}' +
        ', ' +
        'useShouldInterceptAjaxRequest: ${useShouldInterceptAjaxRequest}' +
        ', ' +
        'interceptOnlyAsyncAjaxRequests: ${interceptOnlyAsyncAjaxRequests}' +
        ', ' +
        'useShouldInterceptFetchRequest: ${useShouldInterceptFetchRequest}' +
        ', ' +
        'incognito: ${incognito}' +
        ', ' +
        'cacheEnabled: ${cacheEnabled}' +
        ', ' +
        'transparentBackground: ${transparentBackground}' +
        ', ' +
        'disableVerticalScroll: ${disableVerticalScroll}' +
        ', ' +
        'disableHorizontalScroll: ${disableHorizontalScroll}' +
        ', ' +
        'disableContextMenu: ${disableContextMenu}' +
        ', ' +
        'stylusHandwritingEnabled: ${stylusHandwritingEnabled}' +
        ', ' +
        'supportZoom: ${supportZoom}' +
        ', ' +
        'allowFileAccessFromFileURLs: ${allowFileAccessFromFileURLs}' +
        ', ' +
        'allowUniversalAccessFromFileURLs: ${allowUniversalAccessFromFileURLs}' +
        ', ' +
        'builtInZoomControls: ${builtInZoomControls}' +
        ', ' +
        'displayZoomControls: ${displayZoomControls}' +
        ', ' +
        'databaseEnabled: ${databaseEnabled}' +
        ', ' +
        'domStorageEnabled: ${domStorageEnabled}' +
        ', ' +
        'useWideViewPort: ${useWideViewPort}' +
        ', ' +
        'safeBrowsingEnabled: ${safeBrowsingEnabled}' +
        ', ' +
        'mixedContentMode: ${mixedContentMode}' +
        ', ' +
        'allowContentAccess: ${allowContentAccess}' +
        ', ' +
        'allowFileAccess: ${allowFileAccess}' +
        ', ' +
        'blockNetworkImage: ${blockNetworkImage}' +
        ', ' +
        'blockNetworkLoads: ${blockNetworkLoads}' +
        ', ' +
        'cacheMode: ${cacheMode}' +
        ', ' +
        'cursiveFontFamily: ${cursiveFontFamily}' +
        ', ' +
        'defaultFixedFontSize: ${defaultFixedFontSize}' +
        ', ' +
        'defaultFontSize: ${defaultFontSize}' +
        ', ' +
        'defaultTextEncodingName: ${defaultTextEncodingName}' +
        ', ' +
        'disabledActionModeMenuItems: ${disabledActionModeMenuItems}' +
        ', ' +
        'fantasyFontFamily: ${fantasyFontFamily}' +
        ', ' +
        'fixedFontFamily: ${fixedFontFamily}' +
        ', ' +
        'forceDark: ${forceDark}' +
        ', ' +
        'forceDarkStrategy: ${forceDarkStrategy}' +
        ', ' +
        'geolocationEnabled: ${geolocationEnabled}' +
        ', ' +
        'layoutAlgorithm: ${layoutAlgorithm}' +
        ', ' +
        'loadWithOverviewMode: ${loadWithOverviewMode}' +
        ', ' +
        'loadsImagesAutomatically: ${loadsImagesAutomatically}' +
        ', ' +
        'minimumLogicalFontSize: ${minimumLogicalFontSize}' +
        ', ' +
        'needInitialFocus: ${needInitialFocus}' +
        ', ' +
        'offscreenPreRaster: ${offscreenPreRaster}' +
        ', ' +
        'sansSerifFontFamily: ${sansSerifFontFamily}' +
        ', ' +
        'serifFontFamily: ${serifFontFamily}' +
        ', ' +
        'standardFontFamily: ${standardFontFamily}' +
        ', ' +
        'saveFormData: ${saveFormData}' +
        ', ' +
        'thirdPartyCookiesEnabled: ${thirdPartyCookiesEnabled}' +
        ', ' +
        'hardwareAcceleration: ${hardwareAcceleration}' +
        ', ' +
        'initialScale: ${initialScale}' +
        ', ' +
        'supportMultipleWindows: ${supportMultipleWindows}' +
        ', ' +
        'regexToCancelSubFramesLoading: ${regexToCancelSubFramesLoading}' +
        ', ' +
        'regexToCancelOverrideUrlLoading: ${regexToCancelOverrideUrlLoading}' +
        ', ' +
        'useHybridComposition: ${useHybridComposition}' +
        ', ' +
        'useShouldInterceptRequest: ${useShouldInterceptRequest}' +
        ', ' +
        'useOnRenderProcessGone: ${useOnRenderProcessGone}' +
        ', ' +
        'overScrollMode: ${overScrollMode}' +
        ', ' +
        'networkAvailable: ${networkAvailable}' +
        ', ' +
        'scrollBarStyle: ${scrollBarStyle}' +
        ', ' +
        'verticalScrollbarPosition: ${verticalScrollbarPosition}' +
        ', ' +
        'scrollBarDefaultDelayBeforeFade: ${scrollBarDefaultDelayBeforeFade}' +
        ', ' +
        'scrollbarFadingEnabled: ${scrollbarFadingEnabled}' +
        ', ' +
        'scrollBarFadeDuration: ${scrollBarFadeDuration}' +
        ', ' +
        'rendererPriorityPolicy: ${rendererPriorityPolicy}' +
        ', ' +
        'disableDefaultErrorPage: ${disableDefaultErrorPage}' +
        ', ' +
        'verticalScrollbarThumbColor: ${verticalScrollbarThumbColor}' +
        ', ' +
        'verticalScrollbarTrackColor: ${verticalScrollbarTrackColor}' +
        ', ' +
        'horizontalScrollbarThumbColor: ${horizontalScrollbarThumbColor}' +
        ', ' +
        'horizontalScrollbarTrackColor: ${horizontalScrollbarTrackColor}' +
        ', ' +
        'algorithmicDarkeningAllowed: ${algorithmicDarkeningAllowed}' +
        ', ' +
        'paymentRequestEnabled: ${paymentRequestEnabled}' +
        ', ' +
        'webAuthenticationSupport: ${webAuthenticationSupport}' +
        ', ' +
        'enterpriseAuthenticationAppLinkPolicyEnabled: ${enterpriseAuthenticationAppLinkPolicyEnabled}' +
        ', ' +
        'defaultVideoPoster: ${defaultVideoPoster}' +
        ', ' +
        'requestedWithHeaderOriginAllowList: ${requestedWithHeaderOriginAllowList}' +
        ', ' +
        'disallowOverScroll: ${disallowOverScroll}' +
        ', ' +
        'enableViewportScale: ${enableViewportScale}' +
        ', ' +
        'suppressesIncrementalRendering: ${suppressesIncrementalRendering}' +
        ', ' +
        'allowsAirPlayForMediaPlayback: ${allowsAirPlayForMediaPlayback}' +
        ', ' +
        'allowsBackForwardNavigationGestures: ${allowsBackForwardNavigationGestures}' +
        ', ' +
        'allowsLinkPreview: ${allowsLinkPreview}' +
        ', ' +
        'ignoresViewportScaleLimits: ${ignoresViewportScaleLimits}' +
        ', ' +
        'allowsInlineMediaPlayback: ${allowsInlineMediaPlayback}' +
        ', ' +
        'allowsPictureInPictureMediaPlayback: ${allowsPictureInPictureMediaPlayback}' +
        ', ' +
        'isFraudulentWebsiteWarningEnabled: ${isFraudulentWebsiteWarningEnabled}' +
        ', ' +
        'selectionGranularity: ${selectionGranularity}' +
        ', ' +
        'dataDetectorTypes: ${dataDetectorTypes}' +
        ', ' +
        'sharedCookiesEnabled: ${sharedCookiesEnabled}' +
        ', ' +
        'automaticallyAdjustsScrollIndicatorInsets: ${automaticallyAdjustsScrollIndicatorInsets}' +
        ', ' +
        'accessibilityIgnoresInvertColors: ${accessibilityIgnoresInvertColors}' +
        ', ' +
        'decelerationRate: ${decelerationRate}' +
        ', ' +
        'alwaysBounceVertical: ${alwaysBounceVertical}' +
        ', ' +
        'alwaysBounceHorizontal: ${alwaysBounceHorizontal}' +
        ', ' +
        'bouncesHorizontally: ${bouncesHorizontally}' +
        ', ' +
        'bouncesVertically: ${bouncesVertically}' +
        ', ' +
        'scrollsToTop: ${scrollsToTop}' +
        ', ' +
        'isPagingEnabled: ${isPagingEnabled}' +
        ', ' +
        'maximumZoomScale: ${maximumZoomScale}' +
        ', ' +
        'minimumZoomScale: ${minimumZoomScale}' +
        ', ' +
        'contentInsetAdjustmentBehavior: ${contentInsetAdjustmentBehavior}' +
        ', ' +
        'isDirectionalLockEnabled: ${isDirectionalLockEnabled}' +
        ', ' +
        'mediaType: ${mediaType}' +
        ', ' +
        'pageZoom: ${pageZoom}' +
        ', ' +
        'limitsNavigationsToAppBoundDomains: ${limitsNavigationsToAppBoundDomains}' +
        ', ' +
        'useOnNavigationResponse: ${useOnNavigationResponse}' +
        ', ' +
        'applePayAPIEnabled: ${applePayAPIEnabled}' +
        ', ' +
        'allowingReadAccessTo: ${allowingReadAccessTo}' +
        ', ' +
        'disableLongPressContextMenuOnLinks: ${disableLongPressContextMenuOnLinks}' +
        ', ' +
        'disableInputAccessoryView: ${disableInputAccessoryView}' +
        ', ' +
        'underPageBackgroundColor: ${underPageBackgroundColor}' +
        ', ' +
        'isTextInteractionEnabled: ${isTextInteractionEnabled}' +
        ', ' +
        'isSiteSpecificQuirksModeEnabled: ${isSiteSpecificQuirksModeEnabled}' +
        ', ' +
        'upgradeKnownHostsToHTTPS: ${upgradeKnownHostsToHTTPS}' +
        ', ' +
        'isElementFullscreenEnabled: ${isElementFullscreenEnabled}' +
        ', ' +
        'isFindInteractionEnabled: ${isFindInteractionEnabled}' +
        ', ' +
        'minimumViewportInset: ${minimumViewportInset}' +
        ', ' +
        'maximumViewportInset: ${maximumViewportInset}' +
        ', ' +
        'isInspectable: ${isInspectable}' +
        ', ' +
        'shouldPrintBackgrounds: ${shouldPrintBackgrounds}' +
        ', ' +
        'allowBackgroundAudioPlaying: ${allowBackgroundAudioPlaying}' +
        ', ' +
        'webViewAssetLoader: ${webViewAssetLoader}' +
        ', ' +
        'iframeAllow: ${iframeAllow}' +
        ', ' +
        'iframeAllowFullscreen: ${iframeAllowFullscreen}' +
        ', ' +
        'iframeSandbox: ${iframeSandbox}' +
        ', ' +
        'iframeReferrerPolicy: ${iframeReferrerPolicy}' +
        ', ' +
        'iframeName: ${iframeName}' +
        ', ' +
        'iframeCsp: ${iframeCsp}' +
        ', ' +
        'dismissDialogues: ${dismissDialogues}' +
        ', ' +
        'insetsForWebContentToIgnore: ${insetsForWebContentToIgnore}' +
        ', ' +
        'useNetworkCapture: ${useNetworkCapture}' +
        ', ' +
        'networkCaptureMaxBodySize: ${networkCaptureMaxBodySize}' +
        ', ' +
        'networkCaptureBodies: ${networkCaptureBodies}' +
        ', ' +
        'networkCaptureBinaryBodies: ${networkCaptureBinaryBodies}' +
        ', ' +
        'networkCaptureUrlPatterns: ${networkCaptureUrlPatterns}' +
        ', ' +
        'networkCaptureUrlPatternType: ${networkCaptureUrlPatternType}' +
        ', ' +
        'networkCaptureResourceTypes: ${networkCaptureResourceTypes}' +
        ', ' +
        'networkCaptureMimeTypes: ${networkCaptureMimeTypes}' +
        ', ' +
        'networkCapture: ${networkCapture})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$InAppWebViewSettingsToJson(this);
    _sanitizeJson(data);
    return data;
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

extension InAppWebViewSettingsPropertyHelpers on InAppWebViewSettings {
  bool get hasUseShouldOverrideUrlLoading {
    return this.useShouldOverrideUrlLoading != null;
  }

  bool get noUseShouldOverrideUrlLoading {
    return this.useShouldOverrideUrlLoading == null;
  }

  bool get useShouldOverrideUrlLoadingRequired {
    return this.useShouldOverrideUrlLoading ??
        (throw StateError(
          'useShouldOverrideUrlLoading is required but was null',
        ));
  }

  bool get hasUseOnLoadResource {
    return this.useOnLoadResource != null;
  }

  bool get noUseOnLoadResource {
    return this.useOnLoadResource == null;
  }

  bool get useOnLoadResourceRequired {
    return this.useOnLoadResource ??
        (throw StateError('useOnLoadResource is required but was null'));
  }

  bool get hasUseOnDownloadStart {
    return this.useOnDownloadStart != null;
  }

  bool get noUseOnDownloadStart {
    return this.useOnDownloadStart == null;
  }

  bool get useOnDownloadStartRequired {
    return this.useOnDownloadStart ??
        (throw StateError('useOnDownloadStart is required but was null'));
  }

  bool get hasUserAgent {
    return this.userAgent?.isNotEmpty == true;
  }

  bool get noUserAgent {
    return this.userAgent?.isEmpty ?? true;
  }

  String get userAgentRequired {
    return this.userAgent ??
        (throw StateError('userAgent is required but was null'));
  }

  bool get hasApplicationNameForUserAgent {
    return this.applicationNameForUserAgent?.isNotEmpty == true;
  }

  bool get noApplicationNameForUserAgent {
    return this.applicationNameForUserAgent?.isEmpty ?? true;
  }

  String get applicationNameForUserAgentRequired {
    return this.applicationNameForUserAgent ??
        (throw StateError(
          'applicationNameForUserAgent is required but was null',
        ));
  }

  bool get hasJavaScriptEnabled {
    return this.javaScriptEnabled != null;
  }

  bool get noJavaScriptEnabled {
    return this.javaScriptEnabled == null;
  }

  bool get javaScriptEnabledRequired {
    return this.javaScriptEnabled ??
        (throw StateError('javaScriptEnabled is required but was null'));
  }

  bool get hasJavaScriptCanOpenWindowsAutomatically {
    return this.javaScriptCanOpenWindowsAutomatically != null;
  }

  bool get noJavaScriptCanOpenWindowsAutomatically {
    return this.javaScriptCanOpenWindowsAutomatically == null;
  }

  bool get javaScriptCanOpenWindowsAutomaticallyRequired {
    return this.javaScriptCanOpenWindowsAutomatically ??
        (throw StateError(
          'javaScriptCanOpenWindowsAutomatically is required but was null',
        ));
  }

  bool get hasMediaPlaybackRequiresUserGesture {
    return this.mediaPlaybackRequiresUserGesture != null;
  }

  bool get noMediaPlaybackRequiresUserGesture {
    return this.mediaPlaybackRequiresUserGesture == null;
  }

  bool get mediaPlaybackRequiresUserGestureRequired {
    return this.mediaPlaybackRequiresUserGesture ??
        (throw StateError(
          'mediaPlaybackRequiresUserGesture is required but was null',
        ));
  }

  bool get hasMinimumFontSize {
    return this.minimumFontSize != null;
  }

  bool get noMinimumFontSize {
    return this.minimumFontSize == null;
  }

  int get minimumFontSizeRequired {
    return this.minimumFontSize ??
        (throw StateError('minimumFontSize is required but was null'));
  }

  bool get hasVerticalScrollBarEnabled {
    return this.verticalScrollBarEnabled != null;
  }

  bool get noVerticalScrollBarEnabled {
    return this.verticalScrollBarEnabled == null;
  }

  bool get verticalScrollBarEnabledRequired {
    return this.verticalScrollBarEnabled ??
        (throw StateError('verticalScrollBarEnabled is required but was null'));
  }

  bool get hasHorizontalScrollBarEnabled {
    return this.horizontalScrollBarEnabled != null;
  }

  bool get noHorizontalScrollBarEnabled {
    return this.horizontalScrollBarEnabled == null;
  }

  bool get horizontalScrollBarEnabledRequired {
    return this.horizontalScrollBarEnabled ??
        (throw StateError(
          'horizontalScrollBarEnabled is required but was null',
        ));
  }

  List<String> get resourceCustomSchemesRequired {
    return this.resourceCustomSchemes ??
        (throw StateError('resourceCustomSchemes is required but was null'));
  }

  bool get hasResourceCustomSchemes {
    return this.resourceCustomSchemes?.isNotEmpty ?? false;
  }

  bool get noResourceCustomSchemes {
    return this.resourceCustomSchemes?.isEmpty ?? true;
  }

  List<ContentBlocker> get contentBlockersRequired {
    return this.contentBlockers ??
        (throw StateError('contentBlockers is required but was null'));
  }

  bool get hasContentBlockers {
    return this.contentBlockers?.isNotEmpty ?? false;
  }

  bool get noContentBlockers {
    return this.contentBlockers?.isEmpty ?? true;
  }

  bool get hasPreferredContentMode {
    return this.preferredContentMode != null;
  }

  bool get noPreferredContentMode {
    return this.preferredContentMode == null;
  }

  UserPreferredContentMode get preferredContentModeRequired {
    return this.preferredContentMode ??
        (throw StateError('preferredContentMode is required but was null'));
  }

  bool get isPreferredContentModeRECOMMENDED {
    return this.preferredContentMode == UserPreferredContentMode.RECOMMENDED;
  }

  bool get isPreferredContentModeMOBILE {
    return this.preferredContentMode == UserPreferredContentMode.MOBILE;
  }

  bool get isPreferredContentModeDESKTOP {
    return this.preferredContentMode == UserPreferredContentMode.DESKTOP;
  }

  bool get hasUseShouldInterceptAjaxRequest {
    return this.useShouldInterceptAjaxRequest != null;
  }

  bool get noUseShouldInterceptAjaxRequest {
    return this.useShouldInterceptAjaxRequest == null;
  }

  bool get useShouldInterceptAjaxRequestRequired {
    return this.useShouldInterceptAjaxRequest ??
        (throw StateError(
          'useShouldInterceptAjaxRequest is required but was null',
        ));
  }

  bool get hasInterceptOnlyAsyncAjaxRequests {
    return this.interceptOnlyAsyncAjaxRequests != null;
  }

  bool get noInterceptOnlyAsyncAjaxRequests {
    return this.interceptOnlyAsyncAjaxRequests == null;
  }

  bool get interceptOnlyAsyncAjaxRequestsRequired {
    return this.interceptOnlyAsyncAjaxRequests ??
        (throw StateError(
          'interceptOnlyAsyncAjaxRequests is required but was null',
        ));
  }

  bool get hasUseShouldInterceptFetchRequest {
    return this.useShouldInterceptFetchRequest != null;
  }

  bool get noUseShouldInterceptFetchRequest {
    return this.useShouldInterceptFetchRequest == null;
  }

  bool get useShouldInterceptFetchRequestRequired {
    return this.useShouldInterceptFetchRequest ??
        (throw StateError(
          'useShouldInterceptFetchRequest is required but was null',
        ));
  }

  bool get hasIncognito {
    return this.incognito != null;
  }

  bool get noIncognito {
    return this.incognito == null;
  }

  bool get incognitoRequired {
    return this.incognito ??
        (throw StateError('incognito is required but was null'));
  }

  bool get hasCacheEnabled {
    return this.cacheEnabled != null;
  }

  bool get noCacheEnabled {
    return this.cacheEnabled == null;
  }

  bool get cacheEnabledRequired {
    return this.cacheEnabled ??
        (throw StateError('cacheEnabled is required but was null'));
  }

  bool get hasTransparentBackground {
    return this.transparentBackground != null;
  }

  bool get noTransparentBackground {
    return this.transparentBackground == null;
  }

  bool get transparentBackgroundRequired {
    return this.transparentBackground ??
        (throw StateError('transparentBackground is required but was null'));
  }

  bool get hasDisableVerticalScroll {
    return this.disableVerticalScroll != null;
  }

  bool get noDisableVerticalScroll {
    return this.disableVerticalScroll == null;
  }

  bool get disableVerticalScrollRequired {
    return this.disableVerticalScroll ??
        (throw StateError('disableVerticalScroll is required but was null'));
  }

  bool get hasDisableHorizontalScroll {
    return this.disableHorizontalScroll != null;
  }

  bool get noDisableHorizontalScroll {
    return this.disableHorizontalScroll == null;
  }

  bool get disableHorizontalScrollRequired {
    return this.disableHorizontalScroll ??
        (throw StateError('disableHorizontalScroll is required but was null'));
  }

  bool get hasDisableContextMenu {
    return this.disableContextMenu != null;
  }

  bool get noDisableContextMenu {
    return this.disableContextMenu == null;
  }

  bool get disableContextMenuRequired {
    return this.disableContextMenu ??
        (throw StateError('disableContextMenu is required but was null'));
  }

  bool get hasStylusHandwritingEnabled {
    return this.stylusHandwritingEnabled != null;
  }

  bool get noStylusHandwritingEnabled {
    return this.stylusHandwritingEnabled == null;
  }

  bool get stylusHandwritingEnabledRequired {
    return this.stylusHandwritingEnabled ??
        (throw StateError('stylusHandwritingEnabled is required but was null'));
  }

  bool get hasSupportZoom {
    return this.supportZoom != null;
  }

  bool get noSupportZoom {
    return this.supportZoom == null;
  }

  bool get supportZoomRequired {
    return this.supportZoom ??
        (throw StateError('supportZoom is required but was null'));
  }

  bool get hasAllowFileAccessFromFileURLs {
    return this.allowFileAccessFromFileURLs != null;
  }

  bool get noAllowFileAccessFromFileURLs {
    return this.allowFileAccessFromFileURLs == null;
  }

  bool get allowFileAccessFromFileURLsRequired {
    return this.allowFileAccessFromFileURLs ??
        (throw StateError(
          'allowFileAccessFromFileURLs is required but was null',
        ));
  }

  bool get hasAllowUniversalAccessFromFileURLs {
    return this.allowUniversalAccessFromFileURLs != null;
  }

  bool get noAllowUniversalAccessFromFileURLs {
    return this.allowUniversalAccessFromFileURLs == null;
  }

  bool get allowUniversalAccessFromFileURLsRequired {
    return this.allowUniversalAccessFromFileURLs ??
        (throw StateError(
          'allowUniversalAccessFromFileURLs is required but was null',
        ));
  }

  bool get hasBuiltInZoomControls {
    return this.builtInZoomControls != null;
  }

  bool get noBuiltInZoomControls {
    return this.builtInZoomControls == null;
  }

  bool get builtInZoomControlsRequired {
    return this.builtInZoomControls ??
        (throw StateError('builtInZoomControls is required but was null'));
  }

  bool get hasDisplayZoomControls {
    return this.displayZoomControls != null;
  }

  bool get noDisplayZoomControls {
    return this.displayZoomControls == null;
  }

  bool get displayZoomControlsRequired {
    return this.displayZoomControls ??
        (throw StateError('displayZoomControls is required but was null'));
  }

  bool get hasDatabaseEnabled {
    return this.databaseEnabled != null;
  }

  bool get noDatabaseEnabled {
    return this.databaseEnabled == null;
  }

  bool get databaseEnabledRequired {
    return this.databaseEnabled ??
        (throw StateError('databaseEnabled is required but was null'));
  }

  bool get hasDomStorageEnabled {
    return this.domStorageEnabled != null;
  }

  bool get noDomStorageEnabled {
    return this.domStorageEnabled == null;
  }

  bool get domStorageEnabledRequired {
    return this.domStorageEnabled ??
        (throw StateError('domStorageEnabled is required but was null'));
  }

  bool get hasUseWideViewPort {
    return this.useWideViewPort != null;
  }

  bool get noUseWideViewPort {
    return this.useWideViewPort == null;
  }

  bool get useWideViewPortRequired {
    return this.useWideViewPort ??
        (throw StateError('useWideViewPort is required but was null'));
  }

  bool get hasSafeBrowsingEnabled {
    return this.safeBrowsingEnabled != null;
  }

  bool get noSafeBrowsingEnabled {
    return this.safeBrowsingEnabled == null;
  }

  bool get safeBrowsingEnabledRequired {
    return this.safeBrowsingEnabled ??
        (throw StateError('safeBrowsingEnabled is required but was null'));
  }

  bool get hasMixedContentMode {
    return this.mixedContentMode != null;
  }

  bool get noMixedContentMode {
    return this.mixedContentMode == null;
  }

  MixedContentMode get mixedContentModeRequired {
    return this.mixedContentMode ??
        (throw StateError('mixedContentMode is required but was null'));
  }

  bool get isMixedContentModeMIXED_CONTENT_ALWAYS_ALLOW {
    return this.mixedContentMode == MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW;
  }

  bool get isMixedContentModeMIXED_CONTENT_NEVER_ALLOW {
    return this.mixedContentMode == MixedContentMode.MIXED_CONTENT_NEVER_ALLOW;
  }

  bool get isMixedContentModeMIXED_CONTENT_COMPATIBILITY_MODE {
    return this.mixedContentMode ==
        MixedContentMode.MIXED_CONTENT_COMPATIBILITY_MODE;
  }

  bool get hasAllowContentAccess {
    return this.allowContentAccess != null;
  }

  bool get noAllowContentAccess {
    return this.allowContentAccess == null;
  }

  bool get allowContentAccessRequired {
    return this.allowContentAccess ??
        (throw StateError('allowContentAccess is required but was null'));
  }

  bool get hasAllowFileAccess {
    return this.allowFileAccess != null;
  }

  bool get noAllowFileAccess {
    return this.allowFileAccess == null;
  }

  bool get allowFileAccessRequired {
    return this.allowFileAccess ??
        (throw StateError('allowFileAccess is required but was null'));
  }

  bool get hasBlockNetworkImage {
    return this.blockNetworkImage != null;
  }

  bool get noBlockNetworkImage {
    return this.blockNetworkImage == null;
  }

  bool get blockNetworkImageRequired {
    return this.blockNetworkImage ??
        (throw StateError('blockNetworkImage is required but was null'));
  }

  bool get hasBlockNetworkLoads {
    return this.blockNetworkLoads != null;
  }

  bool get noBlockNetworkLoads {
    return this.blockNetworkLoads == null;
  }

  bool get blockNetworkLoadsRequired {
    return this.blockNetworkLoads ??
        (throw StateError('blockNetworkLoads is required but was null'));
  }

  bool get hasCacheMode {
    return this.cacheMode != null;
  }

  bool get noCacheMode {
    return this.cacheMode == null;
  }

  CacheMode get cacheModeRequired {
    return this.cacheMode ??
        (throw StateError('cacheMode is required but was null'));
  }

  bool get isCacheModeLOAD_DEFAULT {
    return this.cacheMode == CacheMode.LOAD_DEFAULT;
  }

  bool get isCacheModeLOAD_CACHE_ELSE_NETWORK {
    return this.cacheMode == CacheMode.LOAD_CACHE_ELSE_NETWORK;
  }

  bool get isCacheModeLOAD_NO_CACHE {
    return this.cacheMode == CacheMode.LOAD_NO_CACHE;
  }

  bool get isCacheModeLOAD_CACHE_ONLY {
    return this.cacheMode == CacheMode.LOAD_CACHE_ONLY;
  }

  bool get hasCursiveFontFamily {
    return this.cursiveFontFamily?.isNotEmpty == true;
  }

  bool get noCursiveFontFamily {
    return this.cursiveFontFamily?.isEmpty ?? true;
  }

  String get cursiveFontFamilyRequired {
    return this.cursiveFontFamily ??
        (throw StateError('cursiveFontFamily is required but was null'));
  }

  bool get hasDefaultFixedFontSize {
    return this.defaultFixedFontSize != null;
  }

  bool get noDefaultFixedFontSize {
    return this.defaultFixedFontSize == null;
  }

  int get defaultFixedFontSizeRequired {
    return this.defaultFixedFontSize ??
        (throw StateError('defaultFixedFontSize is required but was null'));
  }

  bool get hasDefaultFontSize {
    return this.defaultFontSize != null;
  }

  bool get noDefaultFontSize {
    return this.defaultFontSize == null;
  }

  int get defaultFontSizeRequired {
    return this.defaultFontSize ??
        (throw StateError('defaultFontSize is required but was null'));
  }

  bool get hasDefaultTextEncodingName {
    return this.defaultTextEncodingName?.isNotEmpty == true;
  }

  bool get noDefaultTextEncodingName {
    return this.defaultTextEncodingName?.isEmpty ?? true;
  }

  String get defaultTextEncodingNameRequired {
    return this.defaultTextEncodingName ??
        (throw StateError('defaultTextEncodingName is required but was null'));
  }

  bool get hasDisabledActionModeMenuItems {
    return this.disabledActionModeMenuItems != null;
  }

  bool get noDisabledActionModeMenuItems {
    return this.disabledActionModeMenuItems == null;
  }

  ActionModeMenuItem get disabledActionModeMenuItemsRequired {
    return this.disabledActionModeMenuItems ??
        (throw StateError(
          'disabledActionModeMenuItems is required but was null',
        ));
  }

  bool get isDisabledActionModeMenuItemsMENU_ITEM_NONE {
    return this.disabledActionModeMenuItems ==
        ActionModeMenuItem.MENU_ITEM_NONE;
  }

  bool get isDisabledActionModeMenuItemsMENU_ITEM_SHARE {
    return this.disabledActionModeMenuItems ==
        ActionModeMenuItem.MENU_ITEM_SHARE;
  }

  bool get isDisabledActionModeMenuItemsMENU_ITEM_WEB_SEARCH {
    return this.disabledActionModeMenuItems ==
        ActionModeMenuItem.MENU_ITEM_WEB_SEARCH;
  }

  bool get isDisabledActionModeMenuItemsMENU_ITEM_PROCESS_TEXT {
    return this.disabledActionModeMenuItems ==
        ActionModeMenuItem.MENU_ITEM_PROCESS_TEXT;
  }

  bool get hasFantasyFontFamily {
    return this.fantasyFontFamily?.isNotEmpty == true;
  }

  bool get noFantasyFontFamily {
    return this.fantasyFontFamily?.isEmpty ?? true;
  }

  String get fantasyFontFamilyRequired {
    return this.fantasyFontFamily ??
        (throw StateError('fantasyFontFamily is required but was null'));
  }

  bool get hasFixedFontFamily {
    return this.fixedFontFamily?.isNotEmpty == true;
  }

  bool get noFixedFontFamily {
    return this.fixedFontFamily?.isEmpty ?? true;
  }

  String get fixedFontFamilyRequired {
    return this.fixedFontFamily ??
        (throw StateError('fixedFontFamily is required but was null'));
  }

  bool get hasForceDark {
    return this.forceDark != null;
  }

  bool get noForceDark {
    return this.forceDark == null;
  }

  ForceDark get forceDarkRequired {
    return this.forceDark ??
        (throw StateError('forceDark is required but was null'));
  }

  bool get isForceDarkOFF {
    return this.forceDark == ForceDark.OFF;
  }

  bool get isForceDarkAUTO {
    return this.forceDark == ForceDark.AUTO;
  }

  bool get isForceDarkON {
    return this.forceDark == ForceDark.ON;
  }

  bool get hasForceDarkStrategy {
    return this.forceDarkStrategy != null;
  }

  bool get noForceDarkStrategy {
    return this.forceDarkStrategy == null;
  }

  ForceDarkStrategy get forceDarkStrategyRequired {
    return this.forceDarkStrategy ??
        (throw StateError('forceDarkStrategy is required but was null'));
  }

  bool get isForceDarkStrategyUSER_AGENT_DARKENING_ONLY {
    return this.forceDarkStrategy ==
        ForceDarkStrategy.USER_AGENT_DARKENING_ONLY;
  }

  bool get isForceDarkStrategyWEB_THEME_DARKENING_ONLY {
    return this.forceDarkStrategy == ForceDarkStrategy.WEB_THEME_DARKENING_ONLY;
  }

  bool get isForceDarkStrategyPREFER_WEB_THEME_OVER_USER_AGENT_DARKENING {
    return this.forceDarkStrategy ==
        ForceDarkStrategy.PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING;
  }

  bool get hasGeolocationEnabled {
    return this.geolocationEnabled != null;
  }

  bool get noGeolocationEnabled {
    return this.geolocationEnabled == null;
  }

  bool get geolocationEnabledRequired {
    return this.geolocationEnabled ??
        (throw StateError('geolocationEnabled is required but was null'));
  }

  bool get hasLayoutAlgorithm {
    return this.layoutAlgorithm != null;
  }

  bool get noLayoutAlgorithm {
    return this.layoutAlgorithm == null;
  }

  LayoutAlgorithm get layoutAlgorithmRequired {
    return this.layoutAlgorithm ??
        (throw StateError('layoutAlgorithm is required but was null'));
  }

  bool get isLayoutAlgorithmNORMAL {
    return this.layoutAlgorithm == LayoutAlgorithm.NORMAL;
  }

  bool get isLayoutAlgorithmTEXT_AUTOSIZING {
    return this.layoutAlgorithm == LayoutAlgorithm.TEXT_AUTOSIZING;
  }

  bool get isLayoutAlgorithmNARROW_COLUMNS {
    return this.layoutAlgorithm == LayoutAlgorithm.NARROW_COLUMNS;
  }

  bool get hasLoadWithOverviewMode {
    return this.loadWithOverviewMode != null;
  }

  bool get noLoadWithOverviewMode {
    return this.loadWithOverviewMode == null;
  }

  bool get loadWithOverviewModeRequired {
    return this.loadWithOverviewMode ??
        (throw StateError('loadWithOverviewMode is required but was null'));
  }

  bool get hasLoadsImagesAutomatically {
    return this.loadsImagesAutomatically != null;
  }

  bool get noLoadsImagesAutomatically {
    return this.loadsImagesAutomatically == null;
  }

  bool get loadsImagesAutomaticallyRequired {
    return this.loadsImagesAutomatically ??
        (throw StateError('loadsImagesAutomatically is required but was null'));
  }

  bool get hasMinimumLogicalFontSize {
    return this.minimumLogicalFontSize != null;
  }

  bool get noMinimumLogicalFontSize {
    return this.minimumLogicalFontSize == null;
  }

  int get minimumLogicalFontSizeRequired {
    return this.minimumLogicalFontSize ??
        (throw StateError('minimumLogicalFontSize is required but was null'));
  }

  bool get hasNeedInitialFocus {
    return this.needInitialFocus != null;
  }

  bool get noNeedInitialFocus {
    return this.needInitialFocus == null;
  }

  bool get needInitialFocusRequired {
    return this.needInitialFocus ??
        (throw StateError('needInitialFocus is required but was null'));
  }

  bool get hasOffscreenPreRaster {
    return this.offscreenPreRaster != null;
  }

  bool get noOffscreenPreRaster {
    return this.offscreenPreRaster == null;
  }

  bool get offscreenPreRasterRequired {
    return this.offscreenPreRaster ??
        (throw StateError('offscreenPreRaster is required but was null'));
  }

  bool get hasSansSerifFontFamily {
    return this.sansSerifFontFamily?.isNotEmpty == true;
  }

  bool get noSansSerifFontFamily {
    return this.sansSerifFontFamily?.isEmpty ?? true;
  }

  String get sansSerifFontFamilyRequired {
    return this.sansSerifFontFamily ??
        (throw StateError('sansSerifFontFamily is required but was null'));
  }

  bool get hasSerifFontFamily {
    return this.serifFontFamily?.isNotEmpty == true;
  }

  bool get noSerifFontFamily {
    return this.serifFontFamily?.isEmpty ?? true;
  }

  String get serifFontFamilyRequired {
    return this.serifFontFamily ??
        (throw StateError('serifFontFamily is required but was null'));
  }

  bool get hasStandardFontFamily {
    return this.standardFontFamily?.isNotEmpty == true;
  }

  bool get noStandardFontFamily {
    return this.standardFontFamily?.isEmpty ?? true;
  }

  String get standardFontFamilyRequired {
    return this.standardFontFamily ??
        (throw StateError('standardFontFamily is required but was null'));
  }

  bool get hasSaveFormData {
    return this.saveFormData != null;
  }

  bool get noSaveFormData {
    return this.saveFormData == null;
  }

  bool get saveFormDataRequired {
    return this.saveFormData ??
        (throw StateError('saveFormData is required but was null'));
  }

  bool get hasThirdPartyCookiesEnabled {
    return this.thirdPartyCookiesEnabled != null;
  }

  bool get noThirdPartyCookiesEnabled {
    return this.thirdPartyCookiesEnabled == null;
  }

  bool get thirdPartyCookiesEnabledRequired {
    return this.thirdPartyCookiesEnabled ??
        (throw StateError('thirdPartyCookiesEnabled is required but was null'));
  }

  bool get hasHardwareAcceleration {
    return this.hardwareAcceleration != null;
  }

  bool get noHardwareAcceleration {
    return this.hardwareAcceleration == null;
  }

  bool get hardwareAccelerationRequired {
    return this.hardwareAcceleration ??
        (throw StateError('hardwareAcceleration is required but was null'));
  }

  bool get hasInitialScale {
    return this.initialScale != null;
  }

  bool get noInitialScale {
    return this.initialScale == null;
  }

  int get initialScaleRequired {
    return this.initialScale ??
        (throw StateError('initialScale is required but was null'));
  }

  bool get hasSupportMultipleWindows {
    return this.supportMultipleWindows != null;
  }

  bool get noSupportMultipleWindows {
    return this.supportMultipleWindows == null;
  }

  bool get supportMultipleWindowsRequired {
    return this.supportMultipleWindows ??
        (throw StateError('supportMultipleWindows is required but was null'));
  }

  bool get hasRegexToCancelSubFramesLoading {
    return this.regexToCancelSubFramesLoading?.isNotEmpty == true;
  }

  bool get noRegexToCancelSubFramesLoading {
    return this.regexToCancelSubFramesLoading?.isEmpty ?? true;
  }

  String get regexToCancelSubFramesLoadingRequired {
    return this.regexToCancelSubFramesLoading ??
        (throw StateError(
          'regexToCancelSubFramesLoading is required but was null',
        ));
  }

  bool get hasRegexToCancelOverrideUrlLoading {
    return this.regexToCancelOverrideUrlLoading?.isNotEmpty == true;
  }

  bool get noRegexToCancelOverrideUrlLoading {
    return this.regexToCancelOverrideUrlLoading?.isEmpty ?? true;
  }

  String get regexToCancelOverrideUrlLoadingRequired {
    return this.regexToCancelOverrideUrlLoading ??
        (throw StateError(
          'regexToCancelOverrideUrlLoading is required but was null',
        ));
  }

  bool get hasUseHybridComposition {
    return this.useHybridComposition != null;
  }

  bool get noUseHybridComposition {
    return this.useHybridComposition == null;
  }

  bool get useHybridCompositionRequired {
    return this.useHybridComposition ??
        (throw StateError('useHybridComposition is required but was null'));
  }

  bool get hasUseShouldInterceptRequest {
    return this.useShouldInterceptRequest != null;
  }

  bool get noUseShouldInterceptRequest {
    return this.useShouldInterceptRequest == null;
  }

  bool get useShouldInterceptRequestRequired {
    return this.useShouldInterceptRequest ??
        (throw StateError(
          'useShouldInterceptRequest is required but was null',
        ));
  }

  bool get hasUseOnRenderProcessGone {
    return this.useOnRenderProcessGone != null;
  }

  bool get noUseOnRenderProcessGone {
    return this.useOnRenderProcessGone == null;
  }

  bool get useOnRenderProcessGoneRequired {
    return this.useOnRenderProcessGone ??
        (throw StateError('useOnRenderProcessGone is required but was null'));
  }

  bool get hasOverScrollMode {
    return this.overScrollMode != null;
  }

  bool get noOverScrollMode {
    return this.overScrollMode == null;
  }

  OverScrollMode get overScrollModeRequired {
    return this.overScrollMode ??
        (throw StateError('overScrollMode is required but was null'));
  }

  bool get isOverScrollModeALWAYS {
    return this.overScrollMode == OverScrollMode.ALWAYS;
  }

  bool get isOverScrollModeIF_CONTENT_SCROLLS {
    return this.overScrollMode == OverScrollMode.IF_CONTENT_SCROLLS;
  }

  bool get isOverScrollModeNEVER {
    return this.overScrollMode == OverScrollMode.NEVER;
  }

  bool get hasNetworkAvailable {
    return this.networkAvailable != null;
  }

  bool get noNetworkAvailable {
    return this.networkAvailable == null;
  }

  bool get networkAvailableRequired {
    return this.networkAvailable ??
        (throw StateError('networkAvailable is required but was null'));
  }

  bool get hasScrollBarStyle {
    return this.scrollBarStyle != null;
  }

  bool get noScrollBarStyle {
    return this.scrollBarStyle == null;
  }

  ScrollBarStyle get scrollBarStyleRequired {
    return this.scrollBarStyle ??
        (throw StateError('scrollBarStyle is required but was null'));
  }

  bool get isScrollBarStyleSCROLLBARS_INSIDE_OVERLAY {
    return this.scrollBarStyle == ScrollBarStyle.SCROLLBARS_INSIDE_OVERLAY;
  }

  bool get isScrollBarStyleSCROLLBARS_INSIDE_INSET {
    return this.scrollBarStyle == ScrollBarStyle.SCROLLBARS_INSIDE_INSET;
  }

  bool get isScrollBarStyleSCROLLBARS_OUTSIDE_OVERLAY {
    return this.scrollBarStyle == ScrollBarStyle.SCROLLBARS_OUTSIDE_OVERLAY;
  }

  bool get isScrollBarStyleSCROLLBARS_OUTSIDE_INSET {
    return this.scrollBarStyle == ScrollBarStyle.SCROLLBARS_OUTSIDE_INSET;
  }

  bool get hasVerticalScrollbarPosition {
    return this.verticalScrollbarPosition != null;
  }

  bool get noVerticalScrollbarPosition {
    return this.verticalScrollbarPosition == null;
  }

  VerticalScrollbarPosition get verticalScrollbarPositionRequired {
    return this.verticalScrollbarPosition ??
        (throw StateError(
          'verticalScrollbarPosition is required but was null',
        ));
  }

  bool get isVerticalScrollbarPositionSCROLLBAR_POSITION_DEFAULT {
    return this.verticalScrollbarPosition ==
        VerticalScrollbarPosition.SCROLLBAR_POSITION_DEFAULT;
  }

  bool get isVerticalScrollbarPositionSCROLLBAR_POSITION_LEFT {
    return this.verticalScrollbarPosition ==
        VerticalScrollbarPosition.SCROLLBAR_POSITION_LEFT;
  }

  bool get isVerticalScrollbarPositionSCROLLBAR_POSITION_RIGHT {
    return this.verticalScrollbarPosition ==
        VerticalScrollbarPosition.SCROLLBAR_POSITION_RIGHT;
  }

  bool get hasScrollBarDefaultDelayBeforeFade {
    return this.scrollBarDefaultDelayBeforeFade != null;
  }

  bool get noScrollBarDefaultDelayBeforeFade {
    return this.scrollBarDefaultDelayBeforeFade == null;
  }

  int get scrollBarDefaultDelayBeforeFadeRequired {
    return this.scrollBarDefaultDelayBeforeFade ??
        (throw StateError(
          'scrollBarDefaultDelayBeforeFade is required but was null',
        ));
  }

  bool get hasScrollbarFadingEnabled {
    return this.scrollbarFadingEnabled != null;
  }

  bool get noScrollbarFadingEnabled {
    return this.scrollbarFadingEnabled == null;
  }

  bool get scrollbarFadingEnabledRequired {
    return this.scrollbarFadingEnabled ??
        (throw StateError('scrollbarFadingEnabled is required but was null'));
  }

  bool get hasScrollBarFadeDuration {
    return this.scrollBarFadeDuration != null;
  }

  bool get noScrollBarFadeDuration {
    return this.scrollBarFadeDuration == null;
  }

  int get scrollBarFadeDurationRequired {
    return this.scrollBarFadeDuration ??
        (throw StateError('scrollBarFadeDuration is required but was null'));
  }

  bool get hasRendererPriorityPolicy {
    return this.rendererPriorityPolicy != null;
  }

  bool get noRendererPriorityPolicy {
    return this.rendererPriorityPolicy == null;
  }

  RendererPriorityPolicy get rendererPriorityPolicyRequired {
    return this.rendererPriorityPolicy ??
        (throw StateError('rendererPriorityPolicy is required but was null'));
  }

  bool get hasDisableDefaultErrorPage {
    return this.disableDefaultErrorPage != null;
  }

  bool get noDisableDefaultErrorPage {
    return this.disableDefaultErrorPage == null;
  }

  bool get disableDefaultErrorPageRequired {
    return this.disableDefaultErrorPage ??
        (throw StateError('disableDefaultErrorPage is required but was null'));
  }

  bool get hasVerticalScrollbarThumbColor {
    return this.verticalScrollbarThumbColor != null;
  }

  bool get noVerticalScrollbarThumbColor {
    return this.verticalScrollbarThumbColor == null;
  }

  Color get verticalScrollbarThumbColorRequired {
    return this.verticalScrollbarThumbColor ??
        (throw StateError(
          'verticalScrollbarThumbColor is required but was null',
        ));
  }

  bool get hasVerticalScrollbarTrackColor {
    return this.verticalScrollbarTrackColor != null;
  }

  bool get noVerticalScrollbarTrackColor {
    return this.verticalScrollbarTrackColor == null;
  }

  Color get verticalScrollbarTrackColorRequired {
    return this.verticalScrollbarTrackColor ??
        (throw StateError(
          'verticalScrollbarTrackColor is required but was null',
        ));
  }

  bool get hasHorizontalScrollbarThumbColor {
    return this.horizontalScrollbarThumbColor != null;
  }

  bool get noHorizontalScrollbarThumbColor {
    return this.horizontalScrollbarThumbColor == null;
  }

  Color get horizontalScrollbarThumbColorRequired {
    return this.horizontalScrollbarThumbColor ??
        (throw StateError(
          'horizontalScrollbarThumbColor is required but was null',
        ));
  }

  bool get hasHorizontalScrollbarTrackColor {
    return this.horizontalScrollbarTrackColor != null;
  }

  bool get noHorizontalScrollbarTrackColor {
    return this.horizontalScrollbarTrackColor == null;
  }

  Color get horizontalScrollbarTrackColorRequired {
    return this.horizontalScrollbarTrackColor ??
        (throw StateError(
          'horizontalScrollbarTrackColor is required but was null',
        ));
  }

  bool get hasAlgorithmicDarkeningAllowed {
    return this.algorithmicDarkeningAllowed != null;
  }

  bool get noAlgorithmicDarkeningAllowed {
    return this.algorithmicDarkeningAllowed == null;
  }

  bool get algorithmicDarkeningAllowedRequired {
    return this.algorithmicDarkeningAllowed ??
        (throw StateError(
          'algorithmicDarkeningAllowed is required but was null',
        ));
  }

  bool get hasPaymentRequestEnabled {
    return this.paymentRequestEnabled != null;
  }

  bool get noPaymentRequestEnabled {
    return this.paymentRequestEnabled == null;
  }

  bool get paymentRequestEnabledRequired {
    return this.paymentRequestEnabled ??
        (throw StateError('paymentRequestEnabled is required but was null'));
  }

  bool get hasWebAuthenticationSupport {
    return this.webAuthenticationSupport != null;
  }

  bool get noWebAuthenticationSupport {
    return this.webAuthenticationSupport == null;
  }

  WebAuthenticationSupport get webAuthenticationSupportRequired {
    return this.webAuthenticationSupport ??
        (throw StateError('webAuthenticationSupport is required but was null'));
  }

  bool get isWebAuthenticationSupportNONE {
    return this.webAuthenticationSupport == WebAuthenticationSupport.NONE;
  }

  bool get isWebAuthenticationSupportFOR_APP {
    return this.webAuthenticationSupport == WebAuthenticationSupport.FOR_APP;
  }

  bool get isWebAuthenticationSupportFOR_BROWSER {
    return this.webAuthenticationSupport ==
        WebAuthenticationSupport.FOR_BROWSER;
  }

  bool get hasEnterpriseAuthenticationAppLinkPolicyEnabled {
    return this.enterpriseAuthenticationAppLinkPolicyEnabled != null;
  }

  bool get noEnterpriseAuthenticationAppLinkPolicyEnabled {
    return this.enterpriseAuthenticationAppLinkPolicyEnabled == null;
  }

  bool get enterpriseAuthenticationAppLinkPolicyEnabledRequired {
    return this.enterpriseAuthenticationAppLinkPolicyEnabled ??
        (throw StateError(
          'enterpriseAuthenticationAppLinkPolicyEnabled is required but was null',
        ));
  }

  bool get hasDefaultVideoPoster {
    return this.defaultVideoPoster != null;
  }

  bool get noDefaultVideoPoster {
    return this.defaultVideoPoster == null;
  }

  Uint8List get defaultVideoPosterRequired {
    return this.defaultVideoPoster ??
        (throw StateError('defaultVideoPoster is required but was null'));
  }

  Set<String> get requestedWithHeaderOriginAllowListRequired {
    return this.requestedWithHeaderOriginAllowList ??
        (throw StateError(
          'requestedWithHeaderOriginAllowList is required but was null',
        ));
  }

  bool get hasRequestedWithHeaderOriginAllowList {
    return this.requestedWithHeaderOriginAllowList?.isNotEmpty ?? false;
  }

  bool get noRequestedWithHeaderOriginAllowList {
    return this.requestedWithHeaderOriginAllowList?.isEmpty ?? true;
  }

  bool get hasDisallowOverScroll {
    return this.disallowOverScroll != null;
  }

  bool get noDisallowOverScroll {
    return this.disallowOverScroll == null;
  }

  bool get disallowOverScrollRequired {
    return this.disallowOverScroll ??
        (throw StateError('disallowOverScroll is required but was null'));
  }

  bool get hasEnableViewportScale {
    return this.enableViewportScale != null;
  }

  bool get noEnableViewportScale {
    return this.enableViewportScale == null;
  }

  bool get enableViewportScaleRequired {
    return this.enableViewportScale ??
        (throw StateError('enableViewportScale is required but was null'));
  }

  bool get hasSuppressesIncrementalRendering {
    return this.suppressesIncrementalRendering != null;
  }

  bool get noSuppressesIncrementalRendering {
    return this.suppressesIncrementalRendering == null;
  }

  bool get suppressesIncrementalRenderingRequired {
    return this.suppressesIncrementalRendering ??
        (throw StateError(
          'suppressesIncrementalRendering is required but was null',
        ));
  }

  bool get hasAllowsAirPlayForMediaPlayback {
    return this.allowsAirPlayForMediaPlayback != null;
  }

  bool get noAllowsAirPlayForMediaPlayback {
    return this.allowsAirPlayForMediaPlayback == null;
  }

  bool get allowsAirPlayForMediaPlaybackRequired {
    return this.allowsAirPlayForMediaPlayback ??
        (throw StateError(
          'allowsAirPlayForMediaPlayback is required but was null',
        ));
  }

  bool get hasAllowsBackForwardNavigationGestures {
    return this.allowsBackForwardNavigationGestures != null;
  }

  bool get noAllowsBackForwardNavigationGestures {
    return this.allowsBackForwardNavigationGestures == null;
  }

  bool get allowsBackForwardNavigationGesturesRequired {
    return this.allowsBackForwardNavigationGestures ??
        (throw StateError(
          'allowsBackForwardNavigationGestures is required but was null',
        ));
  }

  bool get hasAllowsLinkPreview {
    return this.allowsLinkPreview != null;
  }

  bool get noAllowsLinkPreview {
    return this.allowsLinkPreview == null;
  }

  bool get allowsLinkPreviewRequired {
    return this.allowsLinkPreview ??
        (throw StateError('allowsLinkPreview is required but was null'));
  }

  bool get hasIgnoresViewportScaleLimits {
    return this.ignoresViewportScaleLimits != null;
  }

  bool get noIgnoresViewportScaleLimits {
    return this.ignoresViewportScaleLimits == null;
  }

  bool get ignoresViewportScaleLimitsRequired {
    return this.ignoresViewportScaleLimits ??
        (throw StateError(
          'ignoresViewportScaleLimits is required but was null',
        ));
  }

  bool get hasAllowsInlineMediaPlayback {
    return this.allowsInlineMediaPlayback != null;
  }

  bool get noAllowsInlineMediaPlayback {
    return this.allowsInlineMediaPlayback == null;
  }

  bool get allowsInlineMediaPlaybackRequired {
    return this.allowsInlineMediaPlayback ??
        (throw StateError(
          'allowsInlineMediaPlayback is required but was null',
        ));
  }

  bool get hasAllowsPictureInPictureMediaPlayback {
    return this.allowsPictureInPictureMediaPlayback != null;
  }

  bool get noAllowsPictureInPictureMediaPlayback {
    return this.allowsPictureInPictureMediaPlayback == null;
  }

  bool get allowsPictureInPictureMediaPlaybackRequired {
    return this.allowsPictureInPictureMediaPlayback ??
        (throw StateError(
          'allowsPictureInPictureMediaPlayback is required but was null',
        ));
  }

  bool get hasIsFraudulentWebsiteWarningEnabled {
    return this.isFraudulentWebsiteWarningEnabled != null;
  }

  bool get noIsFraudulentWebsiteWarningEnabled {
    return this.isFraudulentWebsiteWarningEnabled == null;
  }

  bool get isFraudulentWebsiteWarningEnabledRequired {
    return this.isFraudulentWebsiteWarningEnabled ??
        (throw StateError(
          'isFraudulentWebsiteWarningEnabled is required but was null',
        ));
  }

  bool get hasSelectionGranularity {
    return this.selectionGranularity != null;
  }

  bool get noSelectionGranularity {
    return this.selectionGranularity == null;
  }

  SelectionGranularity get selectionGranularityRequired {
    return this.selectionGranularity ??
        (throw StateError('selectionGranularity is required but was null'));
  }

  bool get isSelectionGranularityDYNAMIC {
    return this.selectionGranularity == SelectionGranularity.DYNAMIC;
  }

  bool get isSelectionGranularityCHARACTER {
    return this.selectionGranularity == SelectionGranularity.CHARACTER;
  }

  List<DataDetectorTypes> get dataDetectorTypesRequired {
    return this.dataDetectorTypes ??
        (throw StateError('dataDetectorTypes is required but was null'));
  }

  bool get hasDataDetectorTypes {
    return this.dataDetectorTypes?.isNotEmpty ?? false;
  }

  bool get noDataDetectorTypes {
    return this.dataDetectorTypes?.isEmpty ?? true;
  }

  bool get hasSharedCookiesEnabled {
    return this.sharedCookiesEnabled != null;
  }

  bool get noSharedCookiesEnabled {
    return this.sharedCookiesEnabled == null;
  }

  bool get sharedCookiesEnabledRequired {
    return this.sharedCookiesEnabled ??
        (throw StateError('sharedCookiesEnabled is required but was null'));
  }

  bool get hasAutomaticallyAdjustsScrollIndicatorInsets {
    return this.automaticallyAdjustsScrollIndicatorInsets != null;
  }

  bool get noAutomaticallyAdjustsScrollIndicatorInsets {
    return this.automaticallyAdjustsScrollIndicatorInsets == null;
  }

  bool get automaticallyAdjustsScrollIndicatorInsetsRequired {
    return this.automaticallyAdjustsScrollIndicatorInsets ??
        (throw StateError(
          'automaticallyAdjustsScrollIndicatorInsets is required but was null',
        ));
  }

  bool get hasAccessibilityIgnoresInvertColors {
    return this.accessibilityIgnoresInvertColors != null;
  }

  bool get noAccessibilityIgnoresInvertColors {
    return this.accessibilityIgnoresInvertColors == null;
  }

  bool get accessibilityIgnoresInvertColorsRequired {
    return this.accessibilityIgnoresInvertColors ??
        (throw StateError(
          'accessibilityIgnoresInvertColors is required but was null',
        ));
  }

  bool get hasDecelerationRate {
    return this.decelerationRate != null;
  }

  bool get noDecelerationRate {
    return this.decelerationRate == null;
  }

  ScrollViewDecelerationRate get decelerationRateRequired {
    return this.decelerationRate ??
        (throw StateError('decelerationRate is required but was null'));
  }

  bool get isDecelerationRateNORMAL {
    return this.decelerationRate == ScrollViewDecelerationRate.NORMAL;
  }

  bool get isDecelerationRateFAST {
    return this.decelerationRate == ScrollViewDecelerationRate.FAST;
  }

  bool get hasAlwaysBounceVertical {
    return this.alwaysBounceVertical != null;
  }

  bool get noAlwaysBounceVertical {
    return this.alwaysBounceVertical == null;
  }

  bool get alwaysBounceVerticalRequired {
    return this.alwaysBounceVertical ??
        (throw StateError('alwaysBounceVertical is required but was null'));
  }

  bool get hasAlwaysBounceHorizontal {
    return this.alwaysBounceHorizontal != null;
  }

  bool get noAlwaysBounceHorizontal {
    return this.alwaysBounceHorizontal == null;
  }

  bool get alwaysBounceHorizontalRequired {
    return this.alwaysBounceHorizontal ??
        (throw StateError('alwaysBounceHorizontal is required but was null'));
  }

  bool get hasBouncesHorizontally {
    return this.bouncesHorizontally != null;
  }

  bool get noBouncesHorizontally {
    return this.bouncesHorizontally == null;
  }

  bool get bouncesHorizontallyRequired {
    return this.bouncesHorizontally ??
        (throw StateError('bouncesHorizontally is required but was null'));
  }

  bool get hasBouncesVertically {
    return this.bouncesVertically != null;
  }

  bool get noBouncesVertically {
    return this.bouncesVertically == null;
  }

  bool get bouncesVerticallyRequired {
    return this.bouncesVertically ??
        (throw StateError('bouncesVertically is required but was null'));
  }

  bool get hasScrollsToTop {
    return this.scrollsToTop != null;
  }

  bool get noScrollsToTop {
    return this.scrollsToTop == null;
  }

  bool get scrollsToTopRequired {
    return this.scrollsToTop ??
        (throw StateError('scrollsToTop is required but was null'));
  }

  bool get hasIsPagingEnabled {
    return this.isPagingEnabled != null;
  }

  bool get noIsPagingEnabled {
    return this.isPagingEnabled == null;
  }

  bool get isPagingEnabledRequired {
    return this.isPagingEnabled ??
        (throw StateError('isPagingEnabled is required but was null'));
  }

  bool get hasMaximumZoomScale {
    return this.maximumZoomScale != null;
  }

  bool get noMaximumZoomScale {
    return this.maximumZoomScale == null;
  }

  double get maximumZoomScaleRequired {
    return this.maximumZoomScale ??
        (throw StateError('maximumZoomScale is required but was null'));
  }

  bool get hasMinimumZoomScale {
    return this.minimumZoomScale != null;
  }

  bool get noMinimumZoomScale {
    return this.minimumZoomScale == null;
  }

  double get minimumZoomScaleRequired {
    return this.minimumZoomScale ??
        (throw StateError('minimumZoomScale is required but was null'));
  }

  bool get hasContentInsetAdjustmentBehavior {
    return this.contentInsetAdjustmentBehavior != null;
  }

  bool get noContentInsetAdjustmentBehavior {
    return this.contentInsetAdjustmentBehavior == null;
  }

  ScrollViewContentInsetAdjustmentBehavior
  get contentInsetAdjustmentBehaviorRequired {
    return this.contentInsetAdjustmentBehavior ??
        (throw StateError(
          'contentInsetAdjustmentBehavior is required but was null',
        ));
  }

  bool get isContentInsetAdjustmentBehaviorAUTOMATIC {
    return this.contentInsetAdjustmentBehavior ==
        ScrollViewContentInsetAdjustmentBehavior.AUTOMATIC;
  }

  bool get isContentInsetAdjustmentBehaviorSCROLLABLE_AXES {
    return this.contentInsetAdjustmentBehavior ==
        ScrollViewContentInsetAdjustmentBehavior.SCROLLABLE_AXES;
  }

  bool get isContentInsetAdjustmentBehaviorNEVER {
    return this.contentInsetAdjustmentBehavior ==
        ScrollViewContentInsetAdjustmentBehavior.NEVER;
  }

  bool get isContentInsetAdjustmentBehaviorALWAYS {
    return this.contentInsetAdjustmentBehavior ==
        ScrollViewContentInsetAdjustmentBehavior.ALWAYS;
  }

  bool get hasIsDirectionalLockEnabled {
    return this.isDirectionalLockEnabled != null;
  }

  bool get noIsDirectionalLockEnabled {
    return this.isDirectionalLockEnabled == null;
  }

  bool get isDirectionalLockEnabledRequired {
    return this.isDirectionalLockEnabled ??
        (throw StateError('isDirectionalLockEnabled is required but was null'));
  }

  bool get hasMediaType {
    return this.mediaType?.isNotEmpty == true;
  }

  bool get noMediaType {
    return this.mediaType?.isEmpty ?? true;
  }

  String get mediaTypeRequired {
    return this.mediaType ??
        (throw StateError('mediaType is required but was null'));
  }

  bool get hasPageZoom {
    return this.pageZoom != null;
  }

  bool get noPageZoom {
    return this.pageZoom == null;
  }

  double get pageZoomRequired {
    return this.pageZoom ??
        (throw StateError('pageZoom is required but was null'));
  }

  bool get hasLimitsNavigationsToAppBoundDomains {
    return this.limitsNavigationsToAppBoundDomains != null;
  }

  bool get noLimitsNavigationsToAppBoundDomains {
    return this.limitsNavigationsToAppBoundDomains == null;
  }

  bool get limitsNavigationsToAppBoundDomainsRequired {
    return this.limitsNavigationsToAppBoundDomains ??
        (throw StateError(
          'limitsNavigationsToAppBoundDomains is required but was null',
        ));
  }

  bool get hasUseOnNavigationResponse {
    return this.useOnNavigationResponse != null;
  }

  bool get noUseOnNavigationResponse {
    return this.useOnNavigationResponse == null;
  }

  bool get useOnNavigationResponseRequired {
    return this.useOnNavigationResponse ??
        (throw StateError('useOnNavigationResponse is required but was null'));
  }

  bool get hasApplePayAPIEnabled {
    return this.applePayAPIEnabled != null;
  }

  bool get noApplePayAPIEnabled {
    return this.applePayAPIEnabled == null;
  }

  bool get applePayAPIEnabledRequired {
    return this.applePayAPIEnabled ??
        (throw StateError('applePayAPIEnabled is required but was null'));
  }

  bool get hasAllowingReadAccessTo {
    return this.allowingReadAccessTo != null;
  }

  bool get noAllowingReadAccessTo {
    return this.allowingReadAccessTo == null;
  }

  WebUri get allowingReadAccessToRequired {
    return this.allowingReadAccessTo ??
        (throw StateError('allowingReadAccessTo is required but was null'));
  }

  bool get hasDisableLongPressContextMenuOnLinks {
    return this.disableLongPressContextMenuOnLinks != null;
  }

  bool get noDisableLongPressContextMenuOnLinks {
    return this.disableLongPressContextMenuOnLinks == null;
  }

  bool get disableLongPressContextMenuOnLinksRequired {
    return this.disableLongPressContextMenuOnLinks ??
        (throw StateError(
          'disableLongPressContextMenuOnLinks is required but was null',
        ));
  }

  bool get hasDisableInputAccessoryView {
    return this.disableInputAccessoryView != null;
  }

  bool get noDisableInputAccessoryView {
    return this.disableInputAccessoryView == null;
  }

  bool get disableInputAccessoryViewRequired {
    return this.disableInputAccessoryView ??
        (throw StateError(
          'disableInputAccessoryView is required but was null',
        ));
  }

  bool get hasUnderPageBackgroundColor {
    return this.underPageBackgroundColor != null;
  }

  bool get noUnderPageBackgroundColor {
    return this.underPageBackgroundColor == null;
  }

  Color get underPageBackgroundColorRequired {
    return this.underPageBackgroundColor ??
        (throw StateError('underPageBackgroundColor is required but was null'));
  }

  bool get hasIsTextInteractionEnabled {
    return this.isTextInteractionEnabled != null;
  }

  bool get noIsTextInteractionEnabled {
    return this.isTextInteractionEnabled == null;
  }

  bool get isTextInteractionEnabledRequired {
    return this.isTextInteractionEnabled ??
        (throw StateError('isTextInteractionEnabled is required but was null'));
  }

  bool get hasIsSiteSpecificQuirksModeEnabled {
    return this.isSiteSpecificQuirksModeEnabled != null;
  }

  bool get noIsSiteSpecificQuirksModeEnabled {
    return this.isSiteSpecificQuirksModeEnabled == null;
  }

  bool get isSiteSpecificQuirksModeEnabledRequired {
    return this.isSiteSpecificQuirksModeEnabled ??
        (throw StateError(
          'isSiteSpecificQuirksModeEnabled is required but was null',
        ));
  }

  bool get hasUpgradeKnownHostsToHTTPS {
    return this.upgradeKnownHostsToHTTPS != null;
  }

  bool get noUpgradeKnownHostsToHTTPS {
    return this.upgradeKnownHostsToHTTPS == null;
  }

  bool get upgradeKnownHostsToHTTPSRequired {
    return this.upgradeKnownHostsToHTTPS ??
        (throw StateError('upgradeKnownHostsToHTTPS is required but was null'));
  }

  bool get hasIsElementFullscreenEnabled {
    return this.isElementFullscreenEnabled != null;
  }

  bool get noIsElementFullscreenEnabled {
    return this.isElementFullscreenEnabled == null;
  }

  bool get isElementFullscreenEnabledRequired {
    return this.isElementFullscreenEnabled ??
        (throw StateError(
          'isElementFullscreenEnabled is required but was null',
        ));
  }

  bool get hasIsFindInteractionEnabled {
    return this.isFindInteractionEnabled != null;
  }

  bool get noIsFindInteractionEnabled {
    return this.isFindInteractionEnabled == null;
  }

  bool get isFindInteractionEnabledRequired {
    return this.isFindInteractionEnabled ??
        (throw StateError('isFindInteractionEnabled is required but was null'));
  }

  bool get hasMinimumViewportInset {
    return this.minimumViewportInset != null;
  }

  bool get noMinimumViewportInset {
    return this.minimumViewportInset == null;
  }

  EdgeInsets get minimumViewportInsetRequired {
    return this.minimumViewportInset ??
        (throw StateError('minimumViewportInset is required but was null'));
  }

  bool get hasMaximumViewportInset {
    return this.maximumViewportInset != null;
  }

  bool get noMaximumViewportInset {
    return this.maximumViewportInset == null;
  }

  EdgeInsets get maximumViewportInsetRequired {
    return this.maximumViewportInset ??
        (throw StateError('maximumViewportInset is required but was null'));
  }

  bool get hasIsInspectable {
    return this.isInspectable != null;
  }

  bool get noIsInspectable {
    return this.isInspectable == null;
  }

  bool get isInspectableRequired {
    return this.isInspectable ??
        (throw StateError('isInspectable is required but was null'));
  }

  bool get hasShouldPrintBackgrounds {
    return this.shouldPrintBackgrounds != null;
  }

  bool get noShouldPrintBackgrounds {
    return this.shouldPrintBackgrounds == null;
  }

  bool get shouldPrintBackgroundsRequired {
    return this.shouldPrintBackgrounds ??
        (throw StateError('shouldPrintBackgrounds is required but was null'));
  }

  bool get hasAllowBackgroundAudioPlaying {
    return this.allowBackgroundAudioPlaying != null;
  }

  bool get noAllowBackgroundAudioPlaying {
    return this.allowBackgroundAudioPlaying == null;
  }

  bool get allowBackgroundAudioPlayingRequired {
    return this.allowBackgroundAudioPlaying ??
        (throw StateError(
          'allowBackgroundAudioPlaying is required but was null',
        ));
  }

  bool get hasWebViewAssetLoader {
    return this.webViewAssetLoader != null;
  }

  bool get noWebViewAssetLoader {
    return this.webViewAssetLoader == null;
  }

  WebViewAssetLoader get webViewAssetLoaderRequired {
    return this.webViewAssetLoader ??
        (throw StateError('webViewAssetLoader is required but was null'));
  }

  bool get hasIframeAllow {
    return this.iframeAllow?.isNotEmpty == true;
  }

  bool get noIframeAllow {
    return this.iframeAllow?.isEmpty ?? true;
  }

  String get iframeAllowRequired {
    return this.iframeAllow ??
        (throw StateError('iframeAllow is required but was null'));
  }

  bool get hasIframeAllowFullscreen {
    return this.iframeAllowFullscreen != null;
  }

  bool get noIframeAllowFullscreen {
    return this.iframeAllowFullscreen == null;
  }

  bool get iframeAllowFullscreenRequired {
    return this.iframeAllowFullscreen ??
        (throw StateError('iframeAllowFullscreen is required but was null'));
  }

  Set<Sandbox> get iframeSandboxRequired {
    return this.iframeSandbox ??
        (throw StateError('iframeSandbox is required but was null'));
  }

  bool get hasIframeSandbox {
    return this.iframeSandbox?.isNotEmpty ?? false;
  }

  bool get noIframeSandbox {
    return this.iframeSandbox?.isEmpty ?? true;
  }

  bool get hasIframeReferrerPolicy {
    return this.iframeReferrerPolicy != null;
  }

  bool get noIframeReferrerPolicy {
    return this.iframeReferrerPolicy == null;
  }

  ReferrerPolicy get iframeReferrerPolicyRequired {
    return this.iframeReferrerPolicy ??
        (throw StateError('iframeReferrerPolicy is required but was null'));
  }

  bool get isIframeReferrerPolicyNO_REFERRER {
    return this.iframeReferrerPolicy == ReferrerPolicy.NO_REFERRER;
  }

  bool get isIframeReferrerPolicyNO_REFERRER_WHEN_DOWNGRADE {
    return this.iframeReferrerPolicy ==
        ReferrerPolicy.NO_REFERRER_WHEN_DOWNGRADE;
  }

  bool get isIframeReferrerPolicyORIGIN {
    return this.iframeReferrerPolicy == ReferrerPolicy.ORIGIN;
  }

  bool get isIframeReferrerPolicyORIGIN_WHEN_CROSS_ORIGIN {
    return this.iframeReferrerPolicy == ReferrerPolicy.ORIGIN_WHEN_CROSS_ORIGIN;
  }

  bool get isIframeReferrerPolicySAME_ORIGIN {
    return this.iframeReferrerPolicy == ReferrerPolicy.SAME_ORIGIN;
  }

  bool get isIframeReferrerPolicySTRICT_ORIGIN {
    return this.iframeReferrerPolicy == ReferrerPolicy.STRICT_ORIGIN;
  }

  bool get isIframeReferrerPolicySTRICT_ORIGIN_WHEN_CROSS_ORIGIN {
    return this.iframeReferrerPolicy ==
        ReferrerPolicy.STRICT_ORIGIN_WHEN_CROSS_ORIGIN;
  }

  bool get isIframeReferrerPolicyUNSAFE_URL {
    return this.iframeReferrerPolicy == ReferrerPolicy.UNSAFE_URL;
  }

  bool get hasIframeName {
    return this.iframeName?.isNotEmpty == true;
  }

  bool get noIframeName {
    return this.iframeName?.isEmpty ?? true;
  }

  String get iframeNameRequired {
    return this.iframeName ??
        (throw StateError('iframeName is required but was null'));
  }

  bool get hasIframeCsp {
    return this.iframeCsp?.isNotEmpty == true;
  }

  bool get noIframeCsp {
    return this.iframeCsp?.isEmpty ?? true;
  }

  String get iframeCspRequired {
    return this.iframeCsp ??
        (throw StateError('iframeCsp is required but was null'));
  }

  bool get hasDismissDialogues {
    return this.dismissDialogues != null;
  }

  bool get noDismissDialogues {
    return this.dismissDialogues == null;
  }

  bool get dismissDialoguesRequired {
    return this.dismissDialogues ??
        (throw StateError('dismissDialogues is required but was null'));
  }

  List<AndroidWebViewInsets> get insetsForWebContentToIgnoreRequired {
    return this.insetsForWebContentToIgnore ??
        (throw StateError(
          'insetsForWebContentToIgnore is required but was null',
        ));
  }

  bool get hasInsetsForWebContentToIgnore {
    return this.insetsForWebContentToIgnore?.isNotEmpty ?? false;
  }

  bool get noInsetsForWebContentToIgnore {
    return this.insetsForWebContentToIgnore?.isEmpty ?? true;
  }

  bool get hasUseNetworkCapture {
    return this.useNetworkCapture != null;
  }

  bool get noUseNetworkCapture {
    return this.useNetworkCapture == null;
  }

  bool get useNetworkCaptureRequired {
    return this.useNetworkCapture ??
        (throw StateError('useNetworkCapture is required but was null'));
  }

  bool get hasNetworkCaptureMaxBodySize {
    return this.networkCaptureMaxBodySize != null;
  }

  bool get noNetworkCaptureMaxBodySize {
    return this.networkCaptureMaxBodySize == null;
  }

  int get networkCaptureMaxBodySizeRequired {
    return this.networkCaptureMaxBodySize ??
        (throw StateError(
          'networkCaptureMaxBodySize is required but was null',
        ));
  }

  bool get hasNetworkCaptureBodies {
    return this.networkCaptureBodies != null;
  }

  bool get noNetworkCaptureBodies {
    return this.networkCaptureBodies == null;
  }

  bool get networkCaptureBodiesRequired {
    return this.networkCaptureBodies ??
        (throw StateError('networkCaptureBodies is required but was null'));
  }

  bool get hasNetworkCaptureBinaryBodies {
    return this.networkCaptureBinaryBodies != null;
  }

  bool get noNetworkCaptureBinaryBodies {
    return this.networkCaptureBinaryBodies == null;
  }

  bool get networkCaptureBinaryBodiesRequired {
    return this.networkCaptureBinaryBodies ??
        (throw StateError(
          'networkCaptureBinaryBodies is required but was null',
        ));
  }

  List<String> get networkCaptureUrlPatternsRequired {
    return this.networkCaptureUrlPatterns ??
        (throw StateError(
          'networkCaptureUrlPatterns is required but was null',
        ));
  }

  bool get hasNetworkCaptureUrlPatterns {
    return this.networkCaptureUrlPatterns?.isNotEmpty ?? false;
  }

  bool get noNetworkCaptureUrlPatterns {
    return this.networkCaptureUrlPatterns?.isEmpty ?? true;
  }

  bool get hasNetworkCaptureUrlPatternType {
    return this.networkCaptureUrlPatternType != null;
  }

  bool get noNetworkCaptureUrlPatternType {
    return this.networkCaptureUrlPatternType == null;
  }

  UrlPatternType get networkCaptureUrlPatternTypeRequired {
    return this.networkCaptureUrlPatternType ??
        (throw StateError(
          'networkCaptureUrlPatternType is required but was null',
        ));
  }

  List<ResourceType> get networkCaptureResourceTypesRequired {
    return this.networkCaptureResourceTypes ??
        (throw StateError(
          'networkCaptureResourceTypes is required but was null',
        ));
  }

  bool get hasNetworkCaptureResourceTypes {
    return this.networkCaptureResourceTypes?.isNotEmpty ?? false;
  }

  bool get noNetworkCaptureResourceTypes {
    return this.networkCaptureResourceTypes?.isEmpty ?? true;
  }

  List<String> get networkCaptureMimeTypesRequired {
    return this.networkCaptureMimeTypes ??
        (throw StateError('networkCaptureMimeTypes is required but was null'));
  }

  bool get hasNetworkCaptureMimeTypes {
    return this.networkCaptureMimeTypes?.isNotEmpty ?? false;
  }

  bool get noNetworkCaptureMimeTypes {
    return this.networkCaptureMimeTypes?.isEmpty ?? true;
  }

  bool get hasNetworkCapture {
    return this.networkCapture != null;
  }

  bool get noNetworkCapture {
    return this.networkCapture == null;
  }

  NetworkCaptureController get networkCaptureRequired {
    return this.networkCapture ??
        (throw StateError('networkCapture is required but was null'));
  }
}

extension InAppWebViewSettingsSerialization on InAppWebViewSettings {
  Map<String, dynamic> toJson() {
    return _$InAppWebViewSettingsToJson(this);
  }
}

enum InAppWebViewSettings$ {
  useShouldOverrideUrlLoading,
  useOnLoadResource,
  useOnDownloadStart,
  userAgent,
  applicationNameForUserAgent,
  javaScriptEnabled,
  javaScriptCanOpenWindowsAutomatically,
  mediaPlaybackRequiresUserGesture,
  minimumFontSize,
  verticalScrollBarEnabled,
  horizontalScrollBarEnabled,
  resourceCustomSchemes,
  contentBlockers,
  preferredContentMode,
  useShouldInterceptAjaxRequest,
  interceptOnlyAsyncAjaxRequests,
  useShouldInterceptFetchRequest,
  incognito,
  cacheEnabled,
  transparentBackground,
  disableVerticalScroll,
  disableHorizontalScroll,
  disableContextMenu,
  stylusHandwritingEnabled,
  supportZoom,
  allowFileAccessFromFileURLs,
  allowUniversalAccessFromFileURLs,
  builtInZoomControls,
  displayZoomControls,
  databaseEnabled,
  domStorageEnabled,
  useWideViewPort,
  safeBrowsingEnabled,
  mixedContentMode,
  allowContentAccess,
  allowFileAccess,
  blockNetworkImage,
  blockNetworkLoads,
  cacheMode,
  cursiveFontFamily,
  defaultFixedFontSize,
  defaultFontSize,
  defaultTextEncodingName,
  disabledActionModeMenuItems,
  fantasyFontFamily,
  fixedFontFamily,
  forceDark,
  forceDarkStrategy,
  geolocationEnabled,
  layoutAlgorithm,
  loadWithOverviewMode,
  loadsImagesAutomatically,
  minimumLogicalFontSize,
  needInitialFocus,
  offscreenPreRaster,
  sansSerifFontFamily,
  serifFontFamily,
  standardFontFamily,
  saveFormData,
  thirdPartyCookiesEnabled,
  hardwareAcceleration,
  initialScale,
  supportMultipleWindows,
  regexToCancelSubFramesLoading,
  regexToCancelOverrideUrlLoading,
  useHybridComposition,
  useShouldInterceptRequest,
  useOnRenderProcessGone,
  overScrollMode,
  networkAvailable,
  scrollBarStyle,
  verticalScrollbarPosition,
  scrollBarDefaultDelayBeforeFade,
  scrollbarFadingEnabled,
  scrollBarFadeDuration,
  rendererPriorityPolicy,
  disableDefaultErrorPage,
  verticalScrollbarThumbColor,
  verticalScrollbarTrackColor,
  horizontalScrollbarThumbColor,
  horizontalScrollbarTrackColor,
  algorithmicDarkeningAllowed,
  paymentRequestEnabled,
  webAuthenticationSupport,
  enterpriseAuthenticationAppLinkPolicyEnabled,
  defaultVideoPoster,
  requestedWithHeaderOriginAllowList,
  disallowOverScroll,
  enableViewportScale,
  suppressesIncrementalRendering,
  allowsAirPlayForMediaPlayback,
  allowsBackForwardNavigationGestures,
  allowsLinkPreview,
  ignoresViewportScaleLimits,
  allowsInlineMediaPlayback,
  allowsPictureInPictureMediaPlayback,
  isFraudulentWebsiteWarningEnabled,
  selectionGranularity,
  dataDetectorTypes,
  sharedCookiesEnabled,
  automaticallyAdjustsScrollIndicatorInsets,
  accessibilityIgnoresInvertColors,
  decelerationRate,
  alwaysBounceVertical,
  alwaysBounceHorizontal,
  bouncesHorizontally,
  bouncesVertically,
  scrollsToTop,
  isPagingEnabled,
  maximumZoomScale,
  minimumZoomScale,
  contentInsetAdjustmentBehavior,
  isDirectionalLockEnabled,
  mediaType,
  pageZoom,
  limitsNavigationsToAppBoundDomains,
  useOnNavigationResponse,
  applePayAPIEnabled,
  allowingReadAccessTo,
  disableLongPressContextMenuOnLinks,
  disableInputAccessoryView,
  underPageBackgroundColor,
  isTextInteractionEnabled,
  isSiteSpecificQuirksModeEnabled,
  upgradeKnownHostsToHTTPS,
  isElementFullscreenEnabled,
  isFindInteractionEnabled,
  minimumViewportInset,
  maximumViewportInset,
  isInspectable,
  shouldPrintBackgrounds,
  allowBackgroundAudioPlaying,
  webViewAssetLoader,
  iframeAllow,
  iframeAllowFullscreen,
  iframeSandbox,
  iframeReferrerPolicy,
  iframeName,
  iframeCsp,
  dismissDialogues,
  insetsForWebContentToIgnore,
  useNetworkCapture,
  networkCaptureMaxBodySize,
  networkCaptureBodies,
  networkCaptureBinaryBodies,
  networkCaptureUrlPatterns,
  networkCaptureUrlPatternType,
  networkCaptureResourceTypes,
  networkCaptureMimeTypes,
  networkCapture,
}

class InAppWebViewSettingsPatch
    extends PatchBase<InAppWebViewSettings, InAppWebViewSettings$> {
  InAppWebViewSettings applyTo(InAppWebViewSettings entity) {
    return entity.patchWithInAppWebViewSettings(this);
  }

  InAppWebViewSettingsPatch withUseShouldOverrideUrlLoading(bool? value) {
    patchMap[InAppWebViewSettings$.useShouldOverrideUrlLoading] = value;
    return this;
  }

  InAppWebViewSettingsPatch withUseOnLoadResource(bool? value) {
    patchMap[InAppWebViewSettings$.useOnLoadResource] = value;
    return this;
  }

  InAppWebViewSettingsPatch withUseOnDownloadStart(bool? value) {
    patchMap[InAppWebViewSettings$.useOnDownloadStart] = value;
    return this;
  }

  InAppWebViewSettingsPatch withUserAgent(String? value) {
    patchMap[InAppWebViewSettings$.userAgent] = value;
    return this;
  }

  InAppWebViewSettingsPatch withApplicationNameForUserAgent(String? value) {
    patchMap[InAppWebViewSettings$.applicationNameForUserAgent] = value;
    return this;
  }

  InAppWebViewSettingsPatch withJavaScriptEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.javaScriptEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withJavaScriptCanOpenWindowsAutomatically(
    bool? value,
  ) {
    patchMap[InAppWebViewSettings$.javaScriptCanOpenWindowsAutomatically] =
        value;
    return this;
  }

  InAppWebViewSettingsPatch withMediaPlaybackRequiresUserGesture(bool? value) {
    patchMap[InAppWebViewSettings$.mediaPlaybackRequiresUserGesture] = value;
    return this;
  }

  InAppWebViewSettingsPatch withMinimumFontSize(int? value) {
    patchMap[InAppWebViewSettings$.minimumFontSize] = value;
    return this;
  }

  InAppWebViewSettingsPatch withVerticalScrollBarEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.verticalScrollBarEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withHorizontalScrollBarEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.horizontalScrollBarEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withResourceCustomSchemes(List<String>? value) {
    patchMap[InAppWebViewSettings$.resourceCustomSchemes] = value;
    return this;
  }

  InAppWebViewSettingsPatch withContentBlockers(List<ContentBlocker>? value) {
    patchMap[InAppWebViewSettings$.contentBlockers] = value;
    return this;
  }

  InAppWebViewSettingsPatch withPreferredContentMode(
    UserPreferredContentMode? value,
  ) {
    patchMap[InAppWebViewSettings$.preferredContentMode] = value;
    return this;
  }

  InAppWebViewSettingsPatch withUseShouldInterceptAjaxRequest(bool? value) {
    patchMap[InAppWebViewSettings$.useShouldInterceptAjaxRequest] = value;
    return this;
  }

  InAppWebViewSettingsPatch withInterceptOnlyAsyncAjaxRequests(bool? value) {
    patchMap[InAppWebViewSettings$.interceptOnlyAsyncAjaxRequests] = value;
    return this;
  }

  InAppWebViewSettingsPatch withUseShouldInterceptFetchRequest(bool? value) {
    patchMap[InAppWebViewSettings$.useShouldInterceptFetchRequest] = value;
    return this;
  }

  InAppWebViewSettingsPatch withIncognito(bool? value) {
    patchMap[InAppWebViewSettings$.incognito] = value;
    return this;
  }

  InAppWebViewSettingsPatch withCacheEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.cacheEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withTransparentBackground(bool? value) {
    patchMap[InAppWebViewSettings$.transparentBackground] = value;
    return this;
  }

  InAppWebViewSettingsPatch withDisableVerticalScroll(bool? value) {
    patchMap[InAppWebViewSettings$.disableVerticalScroll] = value;
    return this;
  }

  InAppWebViewSettingsPatch withDisableHorizontalScroll(bool? value) {
    patchMap[InAppWebViewSettings$.disableHorizontalScroll] = value;
    return this;
  }

  InAppWebViewSettingsPatch withDisableContextMenu(bool? value) {
    patchMap[InAppWebViewSettings$.disableContextMenu] = value;
    return this;
  }

  InAppWebViewSettingsPatch withStylusHandwritingEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.stylusHandwritingEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withSupportZoom(bool? value) {
    patchMap[InAppWebViewSettings$.supportZoom] = value;
    return this;
  }

  InAppWebViewSettingsPatch withAllowFileAccessFromFileURLs(bool? value) {
    patchMap[InAppWebViewSettings$.allowFileAccessFromFileURLs] = value;
    return this;
  }

  InAppWebViewSettingsPatch withAllowUniversalAccessFromFileURLs(bool? value) {
    patchMap[InAppWebViewSettings$.allowUniversalAccessFromFileURLs] = value;
    return this;
  }

  InAppWebViewSettingsPatch withBuiltInZoomControls(bool? value) {
    patchMap[InAppWebViewSettings$.builtInZoomControls] = value;
    return this;
  }

  InAppWebViewSettingsPatch withDisplayZoomControls(bool? value) {
    patchMap[InAppWebViewSettings$.displayZoomControls] = value;
    return this;
  }

  InAppWebViewSettingsPatch withDatabaseEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.databaseEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withDomStorageEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.domStorageEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withUseWideViewPort(bool? value) {
    patchMap[InAppWebViewSettings$.useWideViewPort] = value;
    return this;
  }

  InAppWebViewSettingsPatch withSafeBrowsingEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.safeBrowsingEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withMixedContentMode(MixedContentMode? value) {
    patchMap[InAppWebViewSettings$.mixedContentMode] = value;
    return this;
  }

  InAppWebViewSettingsPatch withAllowContentAccess(bool? value) {
    patchMap[InAppWebViewSettings$.allowContentAccess] = value;
    return this;
  }

  InAppWebViewSettingsPatch withAllowFileAccess(bool? value) {
    patchMap[InAppWebViewSettings$.allowFileAccess] = value;
    return this;
  }

  InAppWebViewSettingsPatch withBlockNetworkImage(bool? value) {
    patchMap[InAppWebViewSettings$.blockNetworkImage] = value;
    return this;
  }

  InAppWebViewSettingsPatch withBlockNetworkLoads(bool? value) {
    patchMap[InAppWebViewSettings$.blockNetworkLoads] = value;
    return this;
  }

  InAppWebViewSettingsPatch withCacheMode(CacheMode? value) {
    patchMap[InAppWebViewSettings$.cacheMode] = value;
    return this;
  }

  InAppWebViewSettingsPatch withCursiveFontFamily(String? value) {
    patchMap[InAppWebViewSettings$.cursiveFontFamily] = value;
    return this;
  }

  InAppWebViewSettingsPatch withDefaultFixedFontSize(int? value) {
    patchMap[InAppWebViewSettings$.defaultFixedFontSize] = value;
    return this;
  }

  InAppWebViewSettingsPatch withDefaultFontSize(int? value) {
    patchMap[InAppWebViewSettings$.defaultFontSize] = value;
    return this;
  }

  InAppWebViewSettingsPatch withDefaultTextEncodingName(String? value) {
    patchMap[InAppWebViewSettings$.defaultTextEncodingName] = value;
    return this;
  }

  InAppWebViewSettingsPatch withDisabledActionModeMenuItems(
    ActionModeMenuItem? value,
  ) {
    patchMap[InAppWebViewSettings$.disabledActionModeMenuItems] = value;
    return this;
  }

  InAppWebViewSettingsPatch withFantasyFontFamily(String? value) {
    patchMap[InAppWebViewSettings$.fantasyFontFamily] = value;
    return this;
  }

  InAppWebViewSettingsPatch withFixedFontFamily(String? value) {
    patchMap[InAppWebViewSettings$.fixedFontFamily] = value;
    return this;
  }

  InAppWebViewSettingsPatch withForceDark(ForceDark? value) {
    patchMap[InAppWebViewSettings$.forceDark] = value;
    return this;
  }

  InAppWebViewSettingsPatch withForceDarkStrategy(ForceDarkStrategy? value) {
    patchMap[InAppWebViewSettings$.forceDarkStrategy] = value;
    return this;
  }

  InAppWebViewSettingsPatch withGeolocationEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.geolocationEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withLayoutAlgorithm(LayoutAlgorithm? value) {
    patchMap[InAppWebViewSettings$.layoutAlgorithm] = value;
    return this;
  }

  InAppWebViewSettingsPatch withLoadWithOverviewMode(bool? value) {
    patchMap[InAppWebViewSettings$.loadWithOverviewMode] = value;
    return this;
  }

  InAppWebViewSettingsPatch withLoadsImagesAutomatically(bool? value) {
    patchMap[InAppWebViewSettings$.loadsImagesAutomatically] = value;
    return this;
  }

  InAppWebViewSettingsPatch withMinimumLogicalFontSize(int? value) {
    patchMap[InAppWebViewSettings$.minimumLogicalFontSize] = value;
    return this;
  }

  InAppWebViewSettingsPatch withNeedInitialFocus(bool? value) {
    patchMap[InAppWebViewSettings$.needInitialFocus] = value;
    return this;
  }

  InAppWebViewSettingsPatch withOffscreenPreRaster(bool? value) {
    patchMap[InAppWebViewSettings$.offscreenPreRaster] = value;
    return this;
  }

  InAppWebViewSettingsPatch withSansSerifFontFamily(String? value) {
    patchMap[InAppWebViewSettings$.sansSerifFontFamily] = value;
    return this;
  }

  InAppWebViewSettingsPatch withSerifFontFamily(String? value) {
    patchMap[InAppWebViewSettings$.serifFontFamily] = value;
    return this;
  }

  InAppWebViewSettingsPatch withStandardFontFamily(String? value) {
    patchMap[InAppWebViewSettings$.standardFontFamily] = value;
    return this;
  }

  InAppWebViewSettingsPatch withSaveFormData(bool? value) {
    patchMap[InAppWebViewSettings$.saveFormData] = value;
    return this;
  }

  InAppWebViewSettingsPatch withThirdPartyCookiesEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.thirdPartyCookiesEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withHardwareAcceleration(bool? value) {
    patchMap[InAppWebViewSettings$.hardwareAcceleration] = value;
    return this;
  }

  InAppWebViewSettingsPatch withInitialScale(int? value) {
    patchMap[InAppWebViewSettings$.initialScale] = value;
    return this;
  }

  InAppWebViewSettingsPatch withSupportMultipleWindows(bool? value) {
    patchMap[InAppWebViewSettings$.supportMultipleWindows] = value;
    return this;
  }

  InAppWebViewSettingsPatch withRegexToCancelSubFramesLoading(String? value) {
    patchMap[InAppWebViewSettings$.regexToCancelSubFramesLoading] = value;
    return this;
  }

  InAppWebViewSettingsPatch withRegexToCancelOverrideUrlLoading(String? value) {
    patchMap[InAppWebViewSettings$.regexToCancelOverrideUrlLoading] = value;
    return this;
  }

  InAppWebViewSettingsPatch withUseHybridComposition(bool? value) {
    patchMap[InAppWebViewSettings$.useHybridComposition] = value;
    return this;
  }

  InAppWebViewSettingsPatch withUseShouldInterceptRequest(bool? value) {
    patchMap[InAppWebViewSettings$.useShouldInterceptRequest] = value;
    return this;
  }

  InAppWebViewSettingsPatch withUseOnRenderProcessGone(bool? value) {
    patchMap[InAppWebViewSettings$.useOnRenderProcessGone] = value;
    return this;
  }

  InAppWebViewSettingsPatch withOverScrollMode(OverScrollMode? value) {
    patchMap[InAppWebViewSettings$.overScrollMode] = value;
    return this;
  }

  InAppWebViewSettingsPatch withNetworkAvailable(bool? value) {
    patchMap[InAppWebViewSettings$.networkAvailable] = value;
    return this;
  }

  InAppWebViewSettingsPatch withScrollBarStyle(ScrollBarStyle? value) {
    patchMap[InAppWebViewSettings$.scrollBarStyle] = value;
    return this;
  }

  InAppWebViewSettingsPatch withVerticalScrollbarPosition(
    VerticalScrollbarPosition? value,
  ) {
    patchMap[InAppWebViewSettings$.verticalScrollbarPosition] = value;
    return this;
  }

  InAppWebViewSettingsPatch withScrollBarDefaultDelayBeforeFade(int? value) {
    patchMap[InAppWebViewSettings$.scrollBarDefaultDelayBeforeFade] = value;
    return this;
  }

  InAppWebViewSettingsPatch withScrollbarFadingEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.scrollbarFadingEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withScrollBarFadeDuration(int? value) {
    patchMap[InAppWebViewSettings$.scrollBarFadeDuration] = value;
    return this;
  }

  InAppWebViewSettingsPatch withRendererPriorityPolicy(
    RendererPriorityPolicy? value,
  ) {
    patchMap[InAppWebViewSettings$.rendererPriorityPolicy] = value;
    return this;
  }

  InAppWebViewSettingsPatch withRendererPriorityPolicyPatch(
    RendererPriorityPolicyPatch patch,
  ) {
    patchMap[InAppWebViewSettings$.rendererPriorityPolicy] = patch;
    return this;
  }

  InAppWebViewSettingsPatch withRendererPriorityPolicyPatchFunc(
    RendererPriorityPolicyPatch Function(RendererPriorityPolicyPatch) patch,
  ) {
    patchMap[InAppWebViewSettings$.rendererPriorityPolicy] = (dynamic current) {
      var currentPatch = RendererPriorityPolicyPatch();
      return patch(currentPatch).applyTo(current as RendererPriorityPolicy);
    };
    return this;
  }

  InAppWebViewSettingsPatch withDisableDefaultErrorPage(bool? value) {
    patchMap[InAppWebViewSettings$.disableDefaultErrorPage] = value;
    return this;
  }

  InAppWebViewSettingsPatch withVerticalScrollbarThumbColor(Color? value) {
    patchMap[InAppWebViewSettings$.verticalScrollbarThumbColor] = value;
    return this;
  }

  InAppWebViewSettingsPatch withVerticalScrollbarTrackColor(Color? value) {
    patchMap[InAppWebViewSettings$.verticalScrollbarTrackColor] = value;
    return this;
  }

  InAppWebViewSettingsPatch withHorizontalScrollbarThumbColor(Color? value) {
    patchMap[InAppWebViewSettings$.horizontalScrollbarThumbColor] = value;
    return this;
  }

  InAppWebViewSettingsPatch withHorizontalScrollbarTrackColor(Color? value) {
    patchMap[InAppWebViewSettings$.horizontalScrollbarTrackColor] = value;
    return this;
  }

  InAppWebViewSettingsPatch withAlgorithmicDarkeningAllowed(bool? value) {
    patchMap[InAppWebViewSettings$.algorithmicDarkeningAllowed] = value;
    return this;
  }

  InAppWebViewSettingsPatch withPaymentRequestEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.paymentRequestEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withWebAuthenticationSupport(
    WebAuthenticationSupport? value,
  ) {
    patchMap[InAppWebViewSettings$.webAuthenticationSupport] = value;
    return this;
  }

  InAppWebViewSettingsPatch withEnterpriseAuthenticationAppLinkPolicyEnabled(
    bool? value,
  ) {
    patchMap[InAppWebViewSettings$
            .enterpriseAuthenticationAppLinkPolicyEnabled] =
        value;
    return this;
  }

  InAppWebViewSettingsPatch withDefaultVideoPoster(Uint8List? value) {
    patchMap[InAppWebViewSettings$.defaultVideoPoster] = value;
    return this;
  }

  InAppWebViewSettingsPatch withRequestedWithHeaderOriginAllowList(
    Set<String>? value,
  ) {
    patchMap[InAppWebViewSettings$.requestedWithHeaderOriginAllowList] = value;
    return this;
  }

  InAppWebViewSettingsPatch withDisallowOverScroll(bool? value) {
    patchMap[InAppWebViewSettings$.disallowOverScroll] = value;
    return this;
  }

  InAppWebViewSettingsPatch withEnableViewportScale(bool? value) {
    patchMap[InAppWebViewSettings$.enableViewportScale] = value;
    return this;
  }

  InAppWebViewSettingsPatch withSuppressesIncrementalRendering(bool? value) {
    patchMap[InAppWebViewSettings$.suppressesIncrementalRendering] = value;
    return this;
  }

  InAppWebViewSettingsPatch withAllowsAirPlayForMediaPlayback(bool? value) {
    patchMap[InAppWebViewSettings$.allowsAirPlayForMediaPlayback] = value;
    return this;
  }

  InAppWebViewSettingsPatch withAllowsBackForwardNavigationGestures(
    bool? value,
  ) {
    patchMap[InAppWebViewSettings$.allowsBackForwardNavigationGestures] = value;
    return this;
  }

  InAppWebViewSettingsPatch withAllowsLinkPreview(bool? value) {
    patchMap[InAppWebViewSettings$.allowsLinkPreview] = value;
    return this;
  }

  InAppWebViewSettingsPatch withIgnoresViewportScaleLimits(bool? value) {
    patchMap[InAppWebViewSettings$.ignoresViewportScaleLimits] = value;
    return this;
  }

  InAppWebViewSettingsPatch withAllowsInlineMediaPlayback(bool? value) {
    patchMap[InAppWebViewSettings$.allowsInlineMediaPlayback] = value;
    return this;
  }

  InAppWebViewSettingsPatch withAllowsPictureInPictureMediaPlayback(
    bool? value,
  ) {
    patchMap[InAppWebViewSettings$.allowsPictureInPictureMediaPlayback] = value;
    return this;
  }

  InAppWebViewSettingsPatch withIsFraudulentWebsiteWarningEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.isFraudulentWebsiteWarningEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withSelectionGranularity(
    SelectionGranularity? value,
  ) {
    patchMap[InAppWebViewSettings$.selectionGranularity] = value;
    return this;
  }

  InAppWebViewSettingsPatch withDataDetectorTypes(
    List<DataDetectorTypes>? value,
  ) {
    patchMap[InAppWebViewSettings$.dataDetectorTypes] = value;
    return this;
  }

  InAppWebViewSettingsPatch withSharedCookiesEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.sharedCookiesEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withAutomaticallyAdjustsScrollIndicatorInsets(
    bool? value,
  ) {
    patchMap[InAppWebViewSettings$.automaticallyAdjustsScrollIndicatorInsets] =
        value;
    return this;
  }

  InAppWebViewSettingsPatch withAccessibilityIgnoresInvertColors(bool? value) {
    patchMap[InAppWebViewSettings$.accessibilityIgnoresInvertColors] = value;
    return this;
  }

  InAppWebViewSettingsPatch withDecelerationRate(
    ScrollViewDecelerationRate? value,
  ) {
    patchMap[InAppWebViewSettings$.decelerationRate] = value;
    return this;
  }

  InAppWebViewSettingsPatch withAlwaysBounceVertical(bool? value) {
    patchMap[InAppWebViewSettings$.alwaysBounceVertical] = value;
    return this;
  }

  InAppWebViewSettingsPatch withAlwaysBounceHorizontal(bool? value) {
    patchMap[InAppWebViewSettings$.alwaysBounceHorizontal] = value;
    return this;
  }

  InAppWebViewSettingsPatch withBouncesHorizontally(bool? value) {
    patchMap[InAppWebViewSettings$.bouncesHorizontally] = value;
    return this;
  }

  InAppWebViewSettingsPatch withBouncesVertically(bool? value) {
    patchMap[InAppWebViewSettings$.bouncesVertically] = value;
    return this;
  }

  InAppWebViewSettingsPatch withScrollsToTop(bool? value) {
    patchMap[InAppWebViewSettings$.scrollsToTop] = value;
    return this;
  }

  InAppWebViewSettingsPatch withIsPagingEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.isPagingEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withMaximumZoomScale(double? value) {
    patchMap[InAppWebViewSettings$.maximumZoomScale] = value;
    return this;
  }

  InAppWebViewSettingsPatch withMinimumZoomScale(double? value) {
    patchMap[InAppWebViewSettings$.minimumZoomScale] = value;
    return this;
  }

  InAppWebViewSettingsPatch withContentInsetAdjustmentBehavior(
    ScrollViewContentInsetAdjustmentBehavior? value,
  ) {
    patchMap[InAppWebViewSettings$.contentInsetAdjustmentBehavior] = value;
    return this;
  }

  InAppWebViewSettingsPatch withIsDirectionalLockEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.isDirectionalLockEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withMediaType(String? value) {
    patchMap[InAppWebViewSettings$.mediaType] = value;
    return this;
  }

  InAppWebViewSettingsPatch withPageZoom(double? value) {
    patchMap[InAppWebViewSettings$.pageZoom] = value;
    return this;
  }

  InAppWebViewSettingsPatch withLimitsNavigationsToAppBoundDomains(
    bool? value,
  ) {
    patchMap[InAppWebViewSettings$.limitsNavigationsToAppBoundDomains] = value;
    return this;
  }

  InAppWebViewSettingsPatch withUseOnNavigationResponse(bool? value) {
    patchMap[InAppWebViewSettings$.useOnNavigationResponse] = value;
    return this;
  }

  InAppWebViewSettingsPatch withApplePayAPIEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.applePayAPIEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withAllowingReadAccessTo(WebUri? value) {
    patchMap[InAppWebViewSettings$.allowingReadAccessTo] = value;
    return this;
  }

  InAppWebViewSettingsPatch withDisableLongPressContextMenuOnLinks(
    bool? value,
  ) {
    patchMap[InAppWebViewSettings$.disableLongPressContextMenuOnLinks] = value;
    return this;
  }

  InAppWebViewSettingsPatch withDisableInputAccessoryView(bool? value) {
    patchMap[InAppWebViewSettings$.disableInputAccessoryView] = value;
    return this;
  }

  InAppWebViewSettingsPatch withUnderPageBackgroundColor(Color? value) {
    patchMap[InAppWebViewSettings$.underPageBackgroundColor] = value;
    return this;
  }

  InAppWebViewSettingsPatch withIsTextInteractionEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.isTextInteractionEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withIsSiteSpecificQuirksModeEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.isSiteSpecificQuirksModeEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withUpgradeKnownHostsToHTTPS(bool? value) {
    patchMap[InAppWebViewSettings$.upgradeKnownHostsToHTTPS] = value;
    return this;
  }

  InAppWebViewSettingsPatch withIsElementFullscreenEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.isElementFullscreenEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withIsFindInteractionEnabled(bool? value) {
    patchMap[InAppWebViewSettings$.isFindInteractionEnabled] = value;
    return this;
  }

  InAppWebViewSettingsPatch withMinimumViewportInset(EdgeInsets? value) {
    patchMap[InAppWebViewSettings$.minimumViewportInset] = value;
    return this;
  }

  InAppWebViewSettingsPatch withMaximumViewportInset(EdgeInsets? value) {
    patchMap[InAppWebViewSettings$.maximumViewportInset] = value;
    return this;
  }

  InAppWebViewSettingsPatch withIsInspectable(bool? value) {
    patchMap[InAppWebViewSettings$.isInspectable] = value;
    return this;
  }

  InAppWebViewSettingsPatch withShouldPrintBackgrounds(bool? value) {
    patchMap[InAppWebViewSettings$.shouldPrintBackgrounds] = value;
    return this;
  }

  InAppWebViewSettingsPatch withAllowBackgroundAudioPlaying(bool? value) {
    patchMap[InAppWebViewSettings$.allowBackgroundAudioPlaying] = value;
    return this;
  }

  InAppWebViewSettingsPatch withWebViewAssetLoader(WebViewAssetLoader? value) {
    patchMap[InAppWebViewSettings$.webViewAssetLoader] = value;
    return this;
  }

  InAppWebViewSettingsPatch withWebViewAssetLoaderPatch(
    WebViewAssetLoaderPatch patch,
  ) {
    patchMap[InAppWebViewSettings$.webViewAssetLoader] = patch;
    return this;
  }

  InAppWebViewSettingsPatch withWebViewAssetLoaderPatchFunc(
    WebViewAssetLoaderPatch Function(WebViewAssetLoaderPatch) patch,
  ) {
    patchMap[InAppWebViewSettings$.webViewAssetLoader] = (dynamic current) {
      var currentPatch = WebViewAssetLoaderPatch();
      return patch(currentPatch).applyTo(current as WebViewAssetLoader);
    };
    return this;
  }

  InAppWebViewSettingsPatch withIframeAllow(String? value) {
    patchMap[InAppWebViewSettings$.iframeAllow] = value;
    return this;
  }

  InAppWebViewSettingsPatch withIframeAllowFullscreen(bool? value) {
    patchMap[InAppWebViewSettings$.iframeAllowFullscreen] = value;
    return this;
  }

  InAppWebViewSettingsPatch withIframeSandbox(Set<Sandbox>? value) {
    patchMap[InAppWebViewSettings$.iframeSandbox] = value;
    return this;
  }

  InAppWebViewSettingsPatch withIframeReferrerPolicy(ReferrerPolicy? value) {
    patchMap[InAppWebViewSettings$.iframeReferrerPolicy] = value;
    return this;
  }

  InAppWebViewSettingsPatch withIframeName(String? value) {
    patchMap[InAppWebViewSettings$.iframeName] = value;
    return this;
  }

  InAppWebViewSettingsPatch withIframeCsp(String? value) {
    patchMap[InAppWebViewSettings$.iframeCsp] = value;
    return this;
  }

  InAppWebViewSettingsPatch withDismissDialogues(bool? value) {
    patchMap[InAppWebViewSettings$.dismissDialogues] = value;
    return this;
  }

  InAppWebViewSettingsPatch withInsetsForWebContentToIgnore(
    List<AndroidWebViewInsets>? value,
  ) {
    patchMap[InAppWebViewSettings$.insetsForWebContentToIgnore] = value;
    return this;
  }

  InAppWebViewSettingsPatch withUseNetworkCapture(bool? value) {
    patchMap[InAppWebViewSettings$.useNetworkCapture] = value;
    return this;
  }

  InAppWebViewSettingsPatch withNetworkCaptureMaxBodySize(int? value) {
    patchMap[InAppWebViewSettings$.networkCaptureMaxBodySize] = value;
    return this;
  }

  InAppWebViewSettingsPatch withNetworkCaptureBodies(bool? value) {
    patchMap[InAppWebViewSettings$.networkCaptureBodies] = value;
    return this;
  }

  InAppWebViewSettingsPatch withNetworkCaptureBinaryBodies(bool? value) {
    patchMap[InAppWebViewSettings$.networkCaptureBinaryBodies] = value;
    return this;
  }

  InAppWebViewSettingsPatch withNetworkCaptureUrlPatterns(List<String>? value) {
    patchMap[InAppWebViewSettings$.networkCaptureUrlPatterns] = value;
    return this;
  }

  InAppWebViewSettingsPatch withNetworkCaptureUrlPatternType(
    UrlPatternType? value,
  ) {
    patchMap[InAppWebViewSettings$.networkCaptureUrlPatternType] = value;
    return this;
  }

  InAppWebViewSettingsPatch withNetworkCaptureResourceTypes(
    List<ResourceType>? value,
  ) {
    patchMap[InAppWebViewSettings$.networkCaptureResourceTypes] = value;
    return this;
  }

  InAppWebViewSettingsPatch withNetworkCaptureMimeTypes(List<String>? value) {
    patchMap[InAppWebViewSettings$.networkCaptureMimeTypes] = value;
    return this;
  }

  InAppWebViewSettingsPatch withNetworkCapture(
    NetworkCaptureController? value,
  ) {
    patchMap[InAppWebViewSettings$.networkCapture] = value;
    return this;
  }
}

/// Field descriptors for [InAppWebViewSettings] query construction
abstract final class InAppWebViewSettingsFields {
  static const useShouldOverrideUrlLoading = Field<InAppWebViewSettings, bool?>(
    'useShouldOverrideUrlLoading',
    _$useShouldOverrideUrlLoading,
  );

  static const useOnLoadResource = Field<InAppWebViewSettings, bool?>(
    'useOnLoadResource',
    _$useOnLoadResource,
  );

  static const useOnDownloadStart = Field<InAppWebViewSettings, bool?>(
    'useOnDownloadStart',
    _$useOnDownloadStart,
  );

  static const userAgent = Field<InAppWebViewSettings, String?>(
    'userAgent',
    _$userAgent,
  );

  static const applicationNameForUserAgent =
      Field<InAppWebViewSettings, String?>(
        'applicationNameForUserAgent',
        _$applicationNameForUserAgent,
      );

  static const javaScriptEnabled = Field<InAppWebViewSettings, bool?>(
    'javaScriptEnabled',
    _$javaScriptEnabled,
  );

  static const javaScriptCanOpenWindowsAutomatically =
      Field<InAppWebViewSettings, bool?>(
        'javaScriptCanOpenWindowsAutomatically',
        _$javaScriptCanOpenWindowsAutomatically,
      );

  static const mediaPlaybackRequiresUserGesture =
      Field<InAppWebViewSettings, bool?>(
        'mediaPlaybackRequiresUserGesture',
        _$mediaPlaybackRequiresUserGesture,
      );

  static const minimumFontSize = Field<InAppWebViewSettings, int?>(
    'minimumFontSize',
    _$minimumFontSize,
  );

  static const verticalScrollBarEnabled = Field<InAppWebViewSettings, bool?>(
    'verticalScrollBarEnabled',
    _$verticalScrollBarEnabled,
  );

  static const horizontalScrollBarEnabled = Field<InAppWebViewSettings, bool?>(
    'horizontalScrollBarEnabled',
    _$horizontalScrollBarEnabled,
  );

  static const resourceCustomSchemes =
      Field<InAppWebViewSettings, List<String>?>(
        'resourceCustomSchemes',
        _$resourceCustomSchemes,
      );

  static const contentBlockers =
      Field<InAppWebViewSettings, List<ContentBlocker>?>(
        'contentBlockers',
        _$contentBlockers,
      );

  static const preferredContentMode =
      Field<InAppWebViewSettings, UserPreferredContentMode?>(
        'preferredContentMode',
        _$preferredContentMode,
      );

  static const useShouldInterceptAjaxRequest =
      Field<InAppWebViewSettings, bool?>(
        'useShouldInterceptAjaxRequest',
        _$useShouldInterceptAjaxRequest,
      );

  static const interceptOnlyAsyncAjaxRequests =
      Field<InAppWebViewSettings, bool?>(
        'interceptOnlyAsyncAjaxRequests',
        _$interceptOnlyAsyncAjaxRequests,
      );

  static const useShouldInterceptFetchRequest =
      Field<InAppWebViewSettings, bool?>(
        'useShouldInterceptFetchRequest',
        _$useShouldInterceptFetchRequest,
      );

  static const incognito = Field<InAppWebViewSettings, bool?>(
    'incognito',
    _$incognito,
  );

  static const cacheEnabled = Field<InAppWebViewSettings, bool?>(
    'cacheEnabled',
    _$cacheEnabled,
  );

  static const transparentBackground = Field<InAppWebViewSettings, bool?>(
    'transparentBackground',
    _$transparentBackground,
  );

  static const disableVerticalScroll = Field<InAppWebViewSettings, bool?>(
    'disableVerticalScroll',
    _$disableVerticalScroll,
  );

  static const disableHorizontalScroll = Field<InAppWebViewSettings, bool?>(
    'disableHorizontalScroll',
    _$disableHorizontalScroll,
  );

  static const disableContextMenu = Field<InAppWebViewSettings, bool?>(
    'disableContextMenu',
    _$disableContextMenu,
  );

  static const stylusHandwritingEnabled = Field<InAppWebViewSettings, bool?>(
    'stylusHandwritingEnabled',
    _$stylusHandwritingEnabled,
  );

  static const supportZoom = Field<InAppWebViewSettings, bool?>(
    'supportZoom',
    _$supportZoom,
  );

  static const allowFileAccessFromFileURLs = Field<InAppWebViewSettings, bool?>(
    'allowFileAccessFromFileURLs',
    _$allowFileAccessFromFileURLs,
  );

  static const allowUniversalAccessFromFileURLs =
      Field<InAppWebViewSettings, bool?>(
        'allowUniversalAccessFromFileURLs',
        _$allowUniversalAccessFromFileURLs,
      );

  static const builtInZoomControls = Field<InAppWebViewSettings, bool?>(
    'builtInZoomControls',
    _$builtInZoomControls,
  );

  static const displayZoomControls = Field<InAppWebViewSettings, bool?>(
    'displayZoomControls',
    _$displayZoomControls,
  );

  static const databaseEnabled = Field<InAppWebViewSettings, bool?>(
    'databaseEnabled',
    _$databaseEnabled,
  );

  static const domStorageEnabled = Field<InAppWebViewSettings, bool?>(
    'domStorageEnabled',
    _$domStorageEnabled,
  );

  static const useWideViewPort = Field<InAppWebViewSettings, bool?>(
    'useWideViewPort',
    _$useWideViewPort,
  );

  static const safeBrowsingEnabled = Field<InAppWebViewSettings, bool?>(
    'safeBrowsingEnabled',
    _$safeBrowsingEnabled,
  );

  static const mixedContentMode =
      Field<InAppWebViewSettings, MixedContentMode?>(
        'mixedContentMode',
        _$mixedContentMode,
      );

  static const allowContentAccess = Field<InAppWebViewSettings, bool?>(
    'allowContentAccess',
    _$allowContentAccess,
  );

  static const allowFileAccess = Field<InAppWebViewSettings, bool?>(
    'allowFileAccess',
    _$allowFileAccess,
  );

  static const blockNetworkImage = Field<InAppWebViewSettings, bool?>(
    'blockNetworkImage',
    _$blockNetworkImage,
  );

  static const blockNetworkLoads = Field<InAppWebViewSettings, bool?>(
    'blockNetworkLoads',
    _$blockNetworkLoads,
  );

  static const cacheMode = Field<InAppWebViewSettings, CacheMode?>(
    'cacheMode',
    _$cacheMode,
  );

  static const cursiveFontFamily = Field<InAppWebViewSettings, String?>(
    'cursiveFontFamily',
    _$cursiveFontFamily,
  );

  static const defaultFixedFontSize = Field<InAppWebViewSettings, int?>(
    'defaultFixedFontSize',
    _$defaultFixedFontSize,
  );

  static const defaultFontSize = Field<InAppWebViewSettings, int?>(
    'defaultFontSize',
    _$defaultFontSize,
  );

  static const defaultTextEncodingName = Field<InAppWebViewSettings, String?>(
    'defaultTextEncodingName',
    _$defaultTextEncodingName,
  );

  static const disabledActionModeMenuItems =
      Field<InAppWebViewSettings, ActionModeMenuItem?>(
        'disabledActionModeMenuItems',
        _$disabledActionModeMenuItems,
      );

  static const fantasyFontFamily = Field<InAppWebViewSettings, String?>(
    'fantasyFontFamily',
    _$fantasyFontFamily,
  );

  static const fixedFontFamily = Field<InAppWebViewSettings, String?>(
    'fixedFontFamily',
    _$fixedFontFamily,
  );

  static const forceDark = Field<InAppWebViewSettings, ForceDark?>(
    'forceDark',
    _$forceDark,
  );

  static const forceDarkStrategy =
      Field<InAppWebViewSettings, ForceDarkStrategy?>(
        'forceDarkStrategy',
        _$forceDarkStrategy,
      );

  static const geolocationEnabled = Field<InAppWebViewSettings, bool?>(
    'geolocationEnabled',
    _$geolocationEnabled,
  );

  static const layoutAlgorithm = Field<InAppWebViewSettings, LayoutAlgorithm?>(
    'layoutAlgorithm',
    _$layoutAlgorithm,
  );

  static const loadWithOverviewMode = Field<InAppWebViewSettings, bool?>(
    'loadWithOverviewMode',
    _$loadWithOverviewMode,
  );

  static const loadsImagesAutomatically = Field<InAppWebViewSettings, bool?>(
    'loadsImagesAutomatically',
    _$loadsImagesAutomatically,
  );

  static const minimumLogicalFontSize = Field<InAppWebViewSettings, int?>(
    'minimumLogicalFontSize',
    _$minimumLogicalFontSize,
  );

  static const needInitialFocus = Field<InAppWebViewSettings, bool?>(
    'needInitialFocus',
    _$needInitialFocus,
  );

  static const offscreenPreRaster = Field<InAppWebViewSettings, bool?>(
    'offscreenPreRaster',
    _$offscreenPreRaster,
  );

  static const sansSerifFontFamily = Field<InAppWebViewSettings, String?>(
    'sansSerifFontFamily',
    _$sansSerifFontFamily,
  );

  static const serifFontFamily = Field<InAppWebViewSettings, String?>(
    'serifFontFamily',
    _$serifFontFamily,
  );

  static const standardFontFamily = Field<InAppWebViewSettings, String?>(
    'standardFontFamily',
    _$standardFontFamily,
  );

  static const saveFormData = Field<InAppWebViewSettings, bool?>(
    'saveFormData',
    _$saveFormData,
  );

  static const thirdPartyCookiesEnabled = Field<InAppWebViewSettings, bool?>(
    'thirdPartyCookiesEnabled',
    _$thirdPartyCookiesEnabled,
  );

  static const hardwareAcceleration = Field<InAppWebViewSettings, bool?>(
    'hardwareAcceleration',
    _$hardwareAcceleration,
  );

  static const initialScale = Field<InAppWebViewSettings, int?>(
    'initialScale',
    _$initialScale,
  );

  static const supportMultipleWindows = Field<InAppWebViewSettings, bool?>(
    'supportMultipleWindows',
    _$supportMultipleWindows,
  );

  static const regexToCancelSubFramesLoading =
      Field<InAppWebViewSettings, String?>(
        'regexToCancelSubFramesLoading',
        _$regexToCancelSubFramesLoading,
      );

  static const regexToCancelOverrideUrlLoading =
      Field<InAppWebViewSettings, String?>(
        'regexToCancelOverrideUrlLoading',
        _$regexToCancelOverrideUrlLoading,
      );

  static const useHybridComposition = Field<InAppWebViewSettings, bool?>(
    'useHybridComposition',
    _$useHybridComposition,
  );

  static const useShouldInterceptRequest = Field<InAppWebViewSettings, bool?>(
    'useShouldInterceptRequest',
    _$useShouldInterceptRequest,
  );

  static const useOnRenderProcessGone = Field<InAppWebViewSettings, bool?>(
    'useOnRenderProcessGone',
    _$useOnRenderProcessGone,
  );

  static const overScrollMode = Field<InAppWebViewSettings, OverScrollMode?>(
    'overScrollMode',
    _$overScrollMode,
  );

  static const networkAvailable = Field<InAppWebViewSettings, bool?>(
    'networkAvailable',
    _$networkAvailable,
  );

  static const scrollBarStyle = Field<InAppWebViewSettings, ScrollBarStyle?>(
    'scrollBarStyle',
    _$scrollBarStyle,
  );

  static const verticalScrollbarPosition =
      Field<InAppWebViewSettings, VerticalScrollbarPosition?>(
        'verticalScrollbarPosition',
        _$verticalScrollbarPosition,
      );

  static const scrollBarDefaultDelayBeforeFade =
      Field<InAppWebViewSettings, int?>(
        'scrollBarDefaultDelayBeforeFade',
        _$scrollBarDefaultDelayBeforeFade,
      );

  static const scrollbarFadingEnabled = Field<InAppWebViewSettings, bool?>(
    'scrollbarFadingEnabled',
    _$scrollbarFadingEnabled,
  );

  static const scrollBarFadeDuration = Field<InAppWebViewSettings, int?>(
    'scrollBarFadeDuration',
    _$scrollBarFadeDuration,
  );

  static const rendererPriorityPolicy =
      Field<InAppWebViewSettings, RendererPriorityPolicy?>(
        'rendererPriorityPolicy',
        _$rendererPriorityPolicy,
      );

  static const disableDefaultErrorPage = Field<InAppWebViewSettings, bool?>(
    'disableDefaultErrorPage',
    _$disableDefaultErrorPage,
  );

  static const verticalScrollbarThumbColor =
      Field<InAppWebViewSettings, Color?>(
        'verticalScrollbarThumbColor',
        _$verticalScrollbarThumbColor,
      );

  static const verticalScrollbarTrackColor =
      Field<InAppWebViewSettings, Color?>(
        'verticalScrollbarTrackColor',
        _$verticalScrollbarTrackColor,
      );

  static const horizontalScrollbarThumbColor =
      Field<InAppWebViewSettings, Color?>(
        'horizontalScrollbarThumbColor',
        _$horizontalScrollbarThumbColor,
      );

  static const horizontalScrollbarTrackColor =
      Field<InAppWebViewSettings, Color?>(
        'horizontalScrollbarTrackColor',
        _$horizontalScrollbarTrackColor,
      );

  static const algorithmicDarkeningAllowed = Field<InAppWebViewSettings, bool?>(
    'algorithmicDarkeningAllowed',
    _$algorithmicDarkeningAllowed,
  );

  static const paymentRequestEnabled = Field<InAppWebViewSettings, bool?>(
    'paymentRequestEnabled',
    _$paymentRequestEnabled,
  );

  static const webAuthenticationSupport =
      Field<InAppWebViewSettings, WebAuthenticationSupport?>(
        'webAuthenticationSupport',
        _$webAuthenticationSupport,
      );

  static const enterpriseAuthenticationAppLinkPolicyEnabled =
      Field<InAppWebViewSettings, bool?>(
        'enterpriseAuthenticationAppLinkPolicyEnabled',
        _$enterpriseAuthenticationAppLinkPolicyEnabled,
      );

  static const defaultVideoPoster = Field<InAppWebViewSettings, Uint8List?>(
    'defaultVideoPoster',
    _$defaultVideoPoster,
  );

  static const requestedWithHeaderOriginAllowList =
      Field<InAppWebViewSettings, Set<String>?>(
        'requestedWithHeaderOriginAllowList',
        _$requestedWithHeaderOriginAllowList,
      );

  static const disallowOverScroll = Field<InAppWebViewSettings, bool?>(
    'disallowOverScroll',
    _$disallowOverScroll,
  );

  static const enableViewportScale = Field<InAppWebViewSettings, bool?>(
    'enableViewportScale',
    _$enableViewportScale,
  );

  static const suppressesIncrementalRendering =
      Field<InAppWebViewSettings, bool?>(
        'suppressesIncrementalRendering',
        _$suppressesIncrementalRendering,
      );

  static const allowsAirPlayForMediaPlayback =
      Field<InAppWebViewSettings, bool?>(
        'allowsAirPlayForMediaPlayback',
        _$allowsAirPlayForMediaPlayback,
      );

  static const allowsBackForwardNavigationGestures =
      Field<InAppWebViewSettings, bool?>(
        'allowsBackForwardNavigationGestures',
        _$allowsBackForwardNavigationGestures,
      );

  static const allowsLinkPreview = Field<InAppWebViewSettings, bool?>(
    'allowsLinkPreview',
    _$allowsLinkPreview,
  );

  static const ignoresViewportScaleLimits = Field<InAppWebViewSettings, bool?>(
    'ignoresViewportScaleLimits',
    _$ignoresViewportScaleLimits,
  );

  static const allowsInlineMediaPlayback = Field<InAppWebViewSettings, bool?>(
    'allowsInlineMediaPlayback',
    _$allowsInlineMediaPlayback,
  );

  static const allowsPictureInPictureMediaPlayback =
      Field<InAppWebViewSettings, bool?>(
        'allowsPictureInPictureMediaPlayback',
        _$allowsPictureInPictureMediaPlayback,
      );

  static const isFraudulentWebsiteWarningEnabled =
      Field<InAppWebViewSettings, bool?>(
        'isFraudulentWebsiteWarningEnabled',
        _$isFraudulentWebsiteWarningEnabled,
      );

  static const selectionGranularity =
      Field<InAppWebViewSettings, SelectionGranularity?>(
        'selectionGranularity',
        _$selectionGranularity,
      );

  static const dataDetectorTypes =
      Field<InAppWebViewSettings, List<DataDetectorTypes>?>(
        'dataDetectorTypes',
        _$dataDetectorTypes,
      );

  static const sharedCookiesEnabled = Field<InAppWebViewSettings, bool?>(
    'sharedCookiesEnabled',
    _$sharedCookiesEnabled,
  );

  static const automaticallyAdjustsScrollIndicatorInsets =
      Field<InAppWebViewSettings, bool?>(
        'automaticallyAdjustsScrollIndicatorInsets',
        _$automaticallyAdjustsScrollIndicatorInsets,
      );

  static const accessibilityIgnoresInvertColors =
      Field<InAppWebViewSettings, bool?>(
        'accessibilityIgnoresInvertColors',
        _$accessibilityIgnoresInvertColors,
      );

  static const decelerationRate =
      Field<InAppWebViewSettings, ScrollViewDecelerationRate?>(
        'decelerationRate',
        _$decelerationRate,
      );

  static const alwaysBounceVertical = Field<InAppWebViewSettings, bool?>(
    'alwaysBounceVertical',
    _$alwaysBounceVertical,
  );

  static const alwaysBounceHorizontal = Field<InAppWebViewSettings, bool?>(
    'alwaysBounceHorizontal',
    _$alwaysBounceHorizontal,
  );

  static const bouncesHorizontally = Field<InAppWebViewSettings, bool?>(
    'bouncesHorizontally',
    _$bouncesHorizontally,
  );

  static const bouncesVertically = Field<InAppWebViewSettings, bool?>(
    'bouncesVertically',
    _$bouncesVertically,
  );

  static const scrollsToTop = Field<InAppWebViewSettings, bool?>(
    'scrollsToTop',
    _$scrollsToTop,
  );

  static const isPagingEnabled = Field<InAppWebViewSettings, bool?>(
    'isPagingEnabled',
    _$isPagingEnabled,
  );

  static const maximumZoomScale = Field<InAppWebViewSettings, double?>(
    'maximumZoomScale',
    _$maximumZoomScale,
  );

  static const minimumZoomScale = Field<InAppWebViewSettings, double?>(
    'minimumZoomScale',
    _$minimumZoomScale,
  );

  static const contentInsetAdjustmentBehavior =
      Field<InAppWebViewSettings, ScrollViewContentInsetAdjustmentBehavior?>(
        'contentInsetAdjustmentBehavior',
        _$contentInsetAdjustmentBehavior,
      );

  static const isDirectionalLockEnabled = Field<InAppWebViewSettings, bool?>(
    'isDirectionalLockEnabled',
    _$isDirectionalLockEnabled,
  );

  static const mediaType = Field<InAppWebViewSettings, String?>(
    'mediaType',
    _$mediaType,
  );

  static const pageZoom = Field<InAppWebViewSettings, double?>(
    'pageZoom',
    _$pageZoom,
  );

  static const limitsNavigationsToAppBoundDomains =
      Field<InAppWebViewSettings, bool?>(
        'limitsNavigationsToAppBoundDomains',
        _$limitsNavigationsToAppBoundDomains,
      );

  static const useOnNavigationResponse = Field<InAppWebViewSettings, bool?>(
    'useOnNavigationResponse',
    _$useOnNavigationResponse,
  );

  static const applePayAPIEnabled = Field<InAppWebViewSettings, bool?>(
    'applePayAPIEnabled',
    _$applePayAPIEnabled,
  );

  static const allowingReadAccessTo = Field<InAppWebViewSettings, WebUri?>(
    'allowingReadAccessTo',
    _$allowingReadAccessTo,
  );

  static const disableLongPressContextMenuOnLinks =
      Field<InAppWebViewSettings, bool?>(
        'disableLongPressContextMenuOnLinks',
        _$disableLongPressContextMenuOnLinks,
      );

  static const disableInputAccessoryView = Field<InAppWebViewSettings, bool?>(
    'disableInputAccessoryView',
    _$disableInputAccessoryView,
  );

  static const underPageBackgroundColor = Field<InAppWebViewSettings, Color?>(
    'underPageBackgroundColor',
    _$underPageBackgroundColor,
  );

  static const isTextInteractionEnabled = Field<InAppWebViewSettings, bool?>(
    'isTextInteractionEnabled',
    _$isTextInteractionEnabled,
  );

  static const isSiteSpecificQuirksModeEnabled =
      Field<InAppWebViewSettings, bool?>(
        'isSiteSpecificQuirksModeEnabled',
        _$isSiteSpecificQuirksModeEnabled,
      );

  static const upgradeKnownHostsToHTTPS = Field<InAppWebViewSettings, bool?>(
    'upgradeKnownHostsToHTTPS',
    _$upgradeKnownHostsToHTTPS,
  );

  static const isElementFullscreenEnabled = Field<InAppWebViewSettings, bool?>(
    'isElementFullscreenEnabled',
    _$isElementFullscreenEnabled,
  );

  static const isFindInteractionEnabled = Field<InAppWebViewSettings, bool?>(
    'isFindInteractionEnabled',
    _$isFindInteractionEnabled,
  );

  static const minimumViewportInset = Field<InAppWebViewSettings, EdgeInsets?>(
    'minimumViewportInset',
    _$minimumViewportInset,
  );

  static const maximumViewportInset = Field<InAppWebViewSettings, EdgeInsets?>(
    'maximumViewportInset',
    _$maximumViewportInset,
  );

  static const isInspectable = Field<InAppWebViewSettings, bool?>(
    'isInspectable',
    _$isInspectable,
  );

  static const shouldPrintBackgrounds = Field<InAppWebViewSettings, bool?>(
    'shouldPrintBackgrounds',
    _$shouldPrintBackgrounds,
  );

  static const allowBackgroundAudioPlaying = Field<InAppWebViewSettings, bool?>(
    'allowBackgroundAudioPlaying',
    _$allowBackgroundAudioPlaying,
  );

  static const webViewAssetLoader =
      Field<InAppWebViewSettings, WebViewAssetLoader?>(
        'webViewAssetLoader',
        _$webViewAssetLoader,
      );

  static const iframeAllow = Field<InAppWebViewSettings, String?>(
    'iframeAllow',
    _$iframeAllow,
  );

  static const iframeAllowFullscreen = Field<InAppWebViewSettings, bool?>(
    'iframeAllowFullscreen',
    _$iframeAllowFullscreen,
  );

  static const iframeSandbox = Field<InAppWebViewSettings, Set<Sandbox>?>(
    'iframeSandbox',
    _$iframeSandbox,
  );

  static const iframeReferrerPolicy =
      Field<InAppWebViewSettings, ReferrerPolicy?>(
        'iframeReferrerPolicy',
        _$iframeReferrerPolicy,
      );

  static const iframeName = Field<InAppWebViewSettings, String?>(
    'iframeName',
    _$iframeName,
  );

  static const iframeCsp = Field<InAppWebViewSettings, String?>(
    'iframeCsp',
    _$iframeCsp,
  );

  static const dismissDialogues = Field<InAppWebViewSettings, bool?>(
    'dismissDialogues',
    _$dismissDialogues,
  );

  static const insetsForWebContentToIgnore =
      Field<InAppWebViewSettings, List<AndroidWebViewInsets>?>(
        'insetsForWebContentToIgnore',
        _$insetsForWebContentToIgnore,
      );

  static const useNetworkCapture = Field<InAppWebViewSettings, bool?>(
    'useNetworkCapture',
    _$useNetworkCapture,
  );

  static const networkCaptureMaxBodySize = Field<InAppWebViewSettings, int?>(
    'networkCaptureMaxBodySize',
    _$networkCaptureMaxBodySize,
  );

  static const networkCaptureBodies = Field<InAppWebViewSettings, bool?>(
    'networkCaptureBodies',
    _$networkCaptureBodies,
  );

  static const networkCaptureBinaryBodies = Field<InAppWebViewSettings, bool?>(
    'networkCaptureBinaryBodies',
    _$networkCaptureBinaryBodies,
  );

  static const networkCaptureUrlPatterns =
      Field<InAppWebViewSettings, List<String>?>(
        'networkCaptureUrlPatterns',
        _$networkCaptureUrlPatterns,
      );

  static const networkCaptureUrlPatternType =
      Field<InAppWebViewSettings, UrlPatternType?>(
        'networkCaptureUrlPatternType',
        _$networkCaptureUrlPatternType,
      );

  static const networkCaptureResourceTypes =
      Field<InAppWebViewSettings, List<ResourceType>?>(
        'networkCaptureResourceTypes',
        _$networkCaptureResourceTypes,
      );

  static const networkCaptureMimeTypes =
      Field<InAppWebViewSettings, List<String>?>(
        'networkCaptureMimeTypes',
        _$networkCaptureMimeTypes,
      );

  static const networkCapture =
      Field<InAppWebViewSettings, NetworkCaptureController?>(
        'networkCapture',
        _$networkCapture,
      );

  static bool? _$useShouldOverrideUrlLoading(InAppWebViewSettings e) {
    return e.useShouldOverrideUrlLoading;
  }

  static bool? _$useOnLoadResource(InAppWebViewSettings e) {
    return e.useOnLoadResource;
  }

  static bool? _$useOnDownloadStart(InAppWebViewSettings e) {
    return e.useOnDownloadStart;
  }

  static String? _$userAgent(InAppWebViewSettings e) {
    return e.userAgent;
  }

  static String? _$applicationNameForUserAgent(InAppWebViewSettings e) {
    return e.applicationNameForUserAgent;
  }

  static bool? _$javaScriptEnabled(InAppWebViewSettings e) {
    return e.javaScriptEnabled;
  }

  static bool? _$javaScriptCanOpenWindowsAutomatically(InAppWebViewSettings e) {
    return e.javaScriptCanOpenWindowsAutomatically;
  }

  static bool? _$mediaPlaybackRequiresUserGesture(InAppWebViewSettings e) {
    return e.mediaPlaybackRequiresUserGesture;
  }

  static int? _$minimumFontSize(InAppWebViewSettings e) {
    return e.minimumFontSize;
  }

  static bool? _$verticalScrollBarEnabled(InAppWebViewSettings e) {
    return e.verticalScrollBarEnabled;
  }

  static bool? _$horizontalScrollBarEnabled(InAppWebViewSettings e) {
    return e.horizontalScrollBarEnabled;
  }

  static List<String>? _$resourceCustomSchemes(InAppWebViewSettings e) {
    return e.resourceCustomSchemes;
  }

  static List<ContentBlocker>? _$contentBlockers(InAppWebViewSettings e) {
    return e.contentBlockers;
  }

  static UserPreferredContentMode? _$preferredContentMode(
    InAppWebViewSettings e,
  ) {
    return e.preferredContentMode;
  }

  static bool? _$useShouldInterceptAjaxRequest(InAppWebViewSettings e) {
    return e.useShouldInterceptAjaxRequest;
  }

  static bool? _$interceptOnlyAsyncAjaxRequests(InAppWebViewSettings e) {
    return e.interceptOnlyAsyncAjaxRequests;
  }

  static bool? _$useShouldInterceptFetchRequest(InAppWebViewSettings e) {
    return e.useShouldInterceptFetchRequest;
  }

  static bool? _$incognito(InAppWebViewSettings e) {
    return e.incognito;
  }

  static bool? _$cacheEnabled(InAppWebViewSettings e) {
    return e.cacheEnabled;
  }

  static bool? _$transparentBackground(InAppWebViewSettings e) {
    return e.transparentBackground;
  }

  static bool? _$disableVerticalScroll(InAppWebViewSettings e) {
    return e.disableVerticalScroll;
  }

  static bool? _$disableHorizontalScroll(InAppWebViewSettings e) {
    return e.disableHorizontalScroll;
  }

  static bool? _$disableContextMenu(InAppWebViewSettings e) {
    return e.disableContextMenu;
  }

  static bool? _$stylusHandwritingEnabled(InAppWebViewSettings e) {
    return e.stylusHandwritingEnabled;
  }

  static bool? _$supportZoom(InAppWebViewSettings e) {
    return e.supportZoom;
  }

  static bool? _$allowFileAccessFromFileURLs(InAppWebViewSettings e) {
    return e.allowFileAccessFromFileURLs;
  }

  static bool? _$allowUniversalAccessFromFileURLs(InAppWebViewSettings e) {
    return e.allowUniversalAccessFromFileURLs;
  }

  static bool? _$builtInZoomControls(InAppWebViewSettings e) {
    return e.builtInZoomControls;
  }

  static bool? _$displayZoomControls(InAppWebViewSettings e) {
    return e.displayZoomControls;
  }

  static bool? _$databaseEnabled(InAppWebViewSettings e) {
    return e.databaseEnabled;
  }

  static bool? _$domStorageEnabled(InAppWebViewSettings e) {
    return e.domStorageEnabled;
  }

  static bool? _$useWideViewPort(InAppWebViewSettings e) {
    return e.useWideViewPort;
  }

  static bool? _$safeBrowsingEnabled(InAppWebViewSettings e) {
    return e.safeBrowsingEnabled;
  }

  static MixedContentMode? _$mixedContentMode(InAppWebViewSettings e) {
    return e.mixedContentMode;
  }

  static bool? _$allowContentAccess(InAppWebViewSettings e) {
    return e.allowContentAccess;
  }

  static bool? _$allowFileAccess(InAppWebViewSettings e) {
    return e.allowFileAccess;
  }

  static bool? _$blockNetworkImage(InAppWebViewSettings e) {
    return e.blockNetworkImage;
  }

  static bool? _$blockNetworkLoads(InAppWebViewSettings e) {
    return e.blockNetworkLoads;
  }

  static CacheMode? _$cacheMode(InAppWebViewSettings e) {
    return e.cacheMode;
  }

  static String? _$cursiveFontFamily(InAppWebViewSettings e) {
    return e.cursiveFontFamily;
  }

  static int? _$defaultFixedFontSize(InAppWebViewSettings e) {
    return e.defaultFixedFontSize;
  }

  static int? _$defaultFontSize(InAppWebViewSettings e) {
    return e.defaultFontSize;
  }

  static String? _$defaultTextEncodingName(InAppWebViewSettings e) {
    return e.defaultTextEncodingName;
  }

  static ActionModeMenuItem? _$disabledActionModeMenuItems(
    InAppWebViewSettings e,
  ) {
    return e.disabledActionModeMenuItems;
  }

  static String? _$fantasyFontFamily(InAppWebViewSettings e) {
    return e.fantasyFontFamily;
  }

  static String? _$fixedFontFamily(InAppWebViewSettings e) {
    return e.fixedFontFamily;
  }

  static ForceDark? _$forceDark(InAppWebViewSettings e) {
    return e.forceDark;
  }

  static ForceDarkStrategy? _$forceDarkStrategy(InAppWebViewSettings e) {
    return e.forceDarkStrategy;
  }

  static bool? _$geolocationEnabled(InAppWebViewSettings e) {
    return e.geolocationEnabled;
  }

  static LayoutAlgorithm? _$layoutAlgorithm(InAppWebViewSettings e) {
    return e.layoutAlgorithm;
  }

  static bool? _$loadWithOverviewMode(InAppWebViewSettings e) {
    return e.loadWithOverviewMode;
  }

  static bool? _$loadsImagesAutomatically(InAppWebViewSettings e) {
    return e.loadsImagesAutomatically;
  }

  static int? _$minimumLogicalFontSize(InAppWebViewSettings e) {
    return e.minimumLogicalFontSize;
  }

  static bool? _$needInitialFocus(InAppWebViewSettings e) {
    return e.needInitialFocus;
  }

  static bool? _$offscreenPreRaster(InAppWebViewSettings e) {
    return e.offscreenPreRaster;
  }

  static String? _$sansSerifFontFamily(InAppWebViewSettings e) {
    return e.sansSerifFontFamily;
  }

  static String? _$serifFontFamily(InAppWebViewSettings e) {
    return e.serifFontFamily;
  }

  static String? _$standardFontFamily(InAppWebViewSettings e) {
    return e.standardFontFamily;
  }

  static bool? _$saveFormData(InAppWebViewSettings e) {
    return e.saveFormData;
  }

  static bool? _$thirdPartyCookiesEnabled(InAppWebViewSettings e) {
    return e.thirdPartyCookiesEnabled;
  }

  static bool? _$hardwareAcceleration(InAppWebViewSettings e) {
    return e.hardwareAcceleration;
  }

  static int? _$initialScale(InAppWebViewSettings e) {
    return e.initialScale;
  }

  static bool? _$supportMultipleWindows(InAppWebViewSettings e) {
    return e.supportMultipleWindows;
  }

  static String? _$regexToCancelSubFramesLoading(InAppWebViewSettings e) {
    return e.regexToCancelSubFramesLoading;
  }

  static String? _$regexToCancelOverrideUrlLoading(InAppWebViewSettings e) {
    return e.regexToCancelOverrideUrlLoading;
  }

  static bool? _$useHybridComposition(InAppWebViewSettings e) {
    return e.useHybridComposition;
  }

  static bool? _$useShouldInterceptRequest(InAppWebViewSettings e) {
    return e.useShouldInterceptRequest;
  }

  static bool? _$useOnRenderProcessGone(InAppWebViewSettings e) {
    return e.useOnRenderProcessGone;
  }

  static OverScrollMode? _$overScrollMode(InAppWebViewSettings e) {
    return e.overScrollMode;
  }

  static bool? _$networkAvailable(InAppWebViewSettings e) {
    return e.networkAvailable;
  }

  static ScrollBarStyle? _$scrollBarStyle(InAppWebViewSettings e) {
    return e.scrollBarStyle;
  }

  static VerticalScrollbarPosition? _$verticalScrollbarPosition(
    InAppWebViewSettings e,
  ) {
    return e.verticalScrollbarPosition;
  }

  static int? _$scrollBarDefaultDelayBeforeFade(InAppWebViewSettings e) {
    return e.scrollBarDefaultDelayBeforeFade;
  }

  static bool? _$scrollbarFadingEnabled(InAppWebViewSettings e) {
    return e.scrollbarFadingEnabled;
  }

  static int? _$scrollBarFadeDuration(InAppWebViewSettings e) {
    return e.scrollBarFadeDuration;
  }

  static RendererPriorityPolicy? _$rendererPriorityPolicy(
    InAppWebViewSettings e,
  ) {
    return e.rendererPriorityPolicy;
  }

  static bool? _$disableDefaultErrorPage(InAppWebViewSettings e) {
    return e.disableDefaultErrorPage;
  }

  static Color? _$verticalScrollbarThumbColor(InAppWebViewSettings e) {
    return e.verticalScrollbarThumbColor;
  }

  static Color? _$verticalScrollbarTrackColor(InAppWebViewSettings e) {
    return e.verticalScrollbarTrackColor;
  }

  static Color? _$horizontalScrollbarThumbColor(InAppWebViewSettings e) {
    return e.horizontalScrollbarThumbColor;
  }

  static Color? _$horizontalScrollbarTrackColor(InAppWebViewSettings e) {
    return e.horizontalScrollbarTrackColor;
  }

  static bool? _$algorithmicDarkeningAllowed(InAppWebViewSettings e) {
    return e.algorithmicDarkeningAllowed;
  }

  static bool? _$paymentRequestEnabled(InAppWebViewSettings e) {
    return e.paymentRequestEnabled;
  }

  static WebAuthenticationSupport? _$webAuthenticationSupport(
    InAppWebViewSettings e,
  ) {
    return e.webAuthenticationSupport;
  }

  static bool? _$enterpriseAuthenticationAppLinkPolicyEnabled(
    InAppWebViewSettings e,
  ) {
    return e.enterpriseAuthenticationAppLinkPolicyEnabled;
  }

  static Uint8List? _$defaultVideoPoster(InAppWebViewSettings e) {
    return e.defaultVideoPoster;
  }

  static Set<String>? _$requestedWithHeaderOriginAllowList(
    InAppWebViewSettings e,
  ) {
    return e.requestedWithHeaderOriginAllowList;
  }

  static bool? _$disallowOverScroll(InAppWebViewSettings e) {
    return e.disallowOverScroll;
  }

  static bool? _$enableViewportScale(InAppWebViewSettings e) {
    return e.enableViewportScale;
  }

  static bool? _$suppressesIncrementalRendering(InAppWebViewSettings e) {
    return e.suppressesIncrementalRendering;
  }

  static bool? _$allowsAirPlayForMediaPlayback(InAppWebViewSettings e) {
    return e.allowsAirPlayForMediaPlayback;
  }

  static bool? _$allowsBackForwardNavigationGestures(InAppWebViewSettings e) {
    return e.allowsBackForwardNavigationGestures;
  }

  static bool? _$allowsLinkPreview(InAppWebViewSettings e) {
    return e.allowsLinkPreview;
  }

  static bool? _$ignoresViewportScaleLimits(InAppWebViewSettings e) {
    return e.ignoresViewportScaleLimits;
  }

  static bool? _$allowsInlineMediaPlayback(InAppWebViewSettings e) {
    return e.allowsInlineMediaPlayback;
  }

  static bool? _$allowsPictureInPictureMediaPlayback(InAppWebViewSettings e) {
    return e.allowsPictureInPictureMediaPlayback;
  }

  static bool? _$isFraudulentWebsiteWarningEnabled(InAppWebViewSettings e) {
    return e.isFraudulentWebsiteWarningEnabled;
  }

  static SelectionGranularity? _$selectionGranularity(InAppWebViewSettings e) {
    return e.selectionGranularity;
  }

  static List<DataDetectorTypes>? _$dataDetectorTypes(InAppWebViewSettings e) {
    return e.dataDetectorTypes;
  }

  static bool? _$sharedCookiesEnabled(InAppWebViewSettings e) {
    return e.sharedCookiesEnabled;
  }

  static bool? _$automaticallyAdjustsScrollIndicatorInsets(
    InAppWebViewSettings e,
  ) {
    return e.automaticallyAdjustsScrollIndicatorInsets;
  }

  static bool? _$accessibilityIgnoresInvertColors(InAppWebViewSettings e) {
    return e.accessibilityIgnoresInvertColors;
  }

  static ScrollViewDecelerationRate? _$decelerationRate(
    InAppWebViewSettings e,
  ) {
    return e.decelerationRate;
  }

  static bool? _$alwaysBounceVertical(InAppWebViewSettings e) {
    return e.alwaysBounceVertical;
  }

  static bool? _$alwaysBounceHorizontal(InAppWebViewSettings e) {
    return e.alwaysBounceHorizontal;
  }

  static bool? _$bouncesHorizontally(InAppWebViewSettings e) {
    return e.bouncesHorizontally;
  }

  static bool? _$bouncesVertically(InAppWebViewSettings e) {
    return e.bouncesVertically;
  }

  static bool? _$scrollsToTop(InAppWebViewSettings e) {
    return e.scrollsToTop;
  }

  static bool? _$isPagingEnabled(InAppWebViewSettings e) {
    return e.isPagingEnabled;
  }

  static double? _$maximumZoomScale(InAppWebViewSettings e) {
    return e.maximumZoomScale;
  }

  static double? _$minimumZoomScale(InAppWebViewSettings e) {
    return e.minimumZoomScale;
  }

  static ScrollViewContentInsetAdjustmentBehavior?
  _$contentInsetAdjustmentBehavior(InAppWebViewSettings e) {
    return e.contentInsetAdjustmentBehavior;
  }

  static bool? _$isDirectionalLockEnabled(InAppWebViewSettings e) {
    return e.isDirectionalLockEnabled;
  }

  static String? _$mediaType(InAppWebViewSettings e) {
    return e.mediaType;
  }

  static double? _$pageZoom(InAppWebViewSettings e) {
    return e.pageZoom;
  }

  static bool? _$limitsNavigationsToAppBoundDomains(InAppWebViewSettings e) {
    return e.limitsNavigationsToAppBoundDomains;
  }

  static bool? _$useOnNavigationResponse(InAppWebViewSettings e) {
    return e.useOnNavigationResponse;
  }

  static bool? _$applePayAPIEnabled(InAppWebViewSettings e) {
    return e.applePayAPIEnabled;
  }

  static WebUri? _$allowingReadAccessTo(InAppWebViewSettings e) {
    return e.allowingReadAccessTo;
  }

  static bool? _$disableLongPressContextMenuOnLinks(InAppWebViewSettings e) {
    return e.disableLongPressContextMenuOnLinks;
  }

  static bool? _$disableInputAccessoryView(InAppWebViewSettings e) {
    return e.disableInputAccessoryView;
  }

  static Color? _$underPageBackgroundColor(InAppWebViewSettings e) {
    return e.underPageBackgroundColor;
  }

  static bool? _$isTextInteractionEnabled(InAppWebViewSettings e) {
    return e.isTextInteractionEnabled;
  }

  static bool? _$isSiteSpecificQuirksModeEnabled(InAppWebViewSettings e) {
    return e.isSiteSpecificQuirksModeEnabled;
  }

  static bool? _$upgradeKnownHostsToHTTPS(InAppWebViewSettings e) {
    return e.upgradeKnownHostsToHTTPS;
  }

  static bool? _$isElementFullscreenEnabled(InAppWebViewSettings e) {
    return e.isElementFullscreenEnabled;
  }

  static bool? _$isFindInteractionEnabled(InAppWebViewSettings e) {
    return e.isFindInteractionEnabled;
  }

  static EdgeInsets? _$minimumViewportInset(InAppWebViewSettings e) {
    return e.minimumViewportInset;
  }

  static EdgeInsets? _$maximumViewportInset(InAppWebViewSettings e) {
    return e.maximumViewportInset;
  }

  static bool? _$isInspectable(InAppWebViewSettings e) {
    return e.isInspectable;
  }

  static bool? _$shouldPrintBackgrounds(InAppWebViewSettings e) {
    return e.shouldPrintBackgrounds;
  }

  static bool? _$allowBackgroundAudioPlaying(InAppWebViewSettings e) {
    return e.allowBackgroundAudioPlaying;
  }

  static WebViewAssetLoader? _$webViewAssetLoader(InAppWebViewSettings e) {
    return e.webViewAssetLoader;
  }

  static String? _$iframeAllow(InAppWebViewSettings e) {
    return e.iframeAllow;
  }

  static bool? _$iframeAllowFullscreen(InAppWebViewSettings e) {
    return e.iframeAllowFullscreen;
  }

  static Set<Sandbox>? _$iframeSandbox(InAppWebViewSettings e) {
    return e.iframeSandbox;
  }

  static ReferrerPolicy? _$iframeReferrerPolicy(InAppWebViewSettings e) {
    return e.iframeReferrerPolicy;
  }

  static String? _$iframeName(InAppWebViewSettings e) {
    return e.iframeName;
  }

  static String? _$iframeCsp(InAppWebViewSettings e) {
    return e.iframeCsp;
  }

  static bool? _$dismissDialogues(InAppWebViewSettings e) {
    return e.dismissDialogues;
  }

  static List<AndroidWebViewInsets>? _$insetsForWebContentToIgnore(
    InAppWebViewSettings e,
  ) {
    return e.insetsForWebContentToIgnore;
  }

  static bool? _$useNetworkCapture(InAppWebViewSettings e) {
    return e.useNetworkCapture;
  }

  static int? _$networkCaptureMaxBodySize(InAppWebViewSettings e) {
    return e.networkCaptureMaxBodySize;
  }

  static bool? _$networkCaptureBodies(InAppWebViewSettings e) {
    return e.networkCaptureBodies;
  }

  static bool? _$networkCaptureBinaryBodies(InAppWebViewSettings e) {
    return e.networkCaptureBinaryBodies;
  }

  static List<String>? _$networkCaptureUrlPatterns(InAppWebViewSettings e) {
    return e.networkCaptureUrlPatterns;
  }

  static UrlPatternType? _$networkCaptureUrlPatternType(
    InAppWebViewSettings e,
  ) {
    return e.networkCaptureUrlPatternType;
  }

  static List<ResourceType>? _$networkCaptureResourceTypes(
    InAppWebViewSettings e,
  ) {
    return e.networkCaptureResourceTypes;
  }

  static List<String>? _$networkCaptureMimeTypes(InAppWebViewSettings e) {
    return e.networkCaptureMimeTypes;
  }

  static NetworkCaptureController? _$networkCapture(InAppWebViewSettings e) {
    return e.networkCapture;
  }
}

extension InAppWebViewSettingsCompareE on InAppWebViewSettings {
  Map<String, dynamic> compareToInAppWebViewSettings(
    InAppWebViewSettings other,
  ) {
    final Map<String, dynamic> diff = {};

    if (useShouldOverrideUrlLoading != other.useShouldOverrideUrlLoading) {
      diff['useShouldOverrideUrlLoading'] = () =>
          other.useShouldOverrideUrlLoading;
    }

    if (useOnLoadResource != other.useOnLoadResource) {
      diff['useOnLoadResource'] = () => other.useOnLoadResource;
    }

    if (useOnDownloadStart != other.useOnDownloadStart) {
      diff['useOnDownloadStart'] = () => other.useOnDownloadStart;
    }

    if (userAgent != other.userAgent) {
      diff['userAgent'] = () => other.userAgent;
    }

    if (applicationNameForUserAgent != other.applicationNameForUserAgent) {
      diff['applicationNameForUserAgent'] = () =>
          other.applicationNameForUserAgent;
    }

    if (javaScriptEnabled != other.javaScriptEnabled) {
      diff['javaScriptEnabled'] = () => other.javaScriptEnabled;
    }

    if (javaScriptCanOpenWindowsAutomatically !=
        other.javaScriptCanOpenWindowsAutomatically) {
      diff['javaScriptCanOpenWindowsAutomatically'] = () =>
          other.javaScriptCanOpenWindowsAutomatically;
    }

    if (mediaPlaybackRequiresUserGesture !=
        other.mediaPlaybackRequiresUserGesture) {
      diff['mediaPlaybackRequiresUserGesture'] = () =>
          other.mediaPlaybackRequiresUserGesture;
    }

    if (minimumFontSize != other.minimumFontSize) {
      diff['minimumFontSize'] = () => other.minimumFontSize;
    }

    if (verticalScrollBarEnabled != other.verticalScrollBarEnabled) {
      diff['verticalScrollBarEnabled'] = () => other.verticalScrollBarEnabled;
    }

    if (horizontalScrollBarEnabled != other.horizontalScrollBarEnabled) {
      diff['horizontalScrollBarEnabled'] = () =>
          other.horizontalScrollBarEnabled;
    }

    if (resourceCustomSchemes != other.resourceCustomSchemes) {
      diff['resourceCustomSchemes'] = () => other.resourceCustomSchemes;
    }

    if (contentBlockers != other.contentBlockers) {
      diff['contentBlockers'] = () => other.contentBlockers;
    }

    if (preferredContentMode != other.preferredContentMode) {
      diff['preferredContentMode'] = () => other.preferredContentMode;
    }

    if (useShouldInterceptAjaxRequest != other.useShouldInterceptAjaxRequest) {
      diff['useShouldInterceptAjaxRequest'] = () =>
          other.useShouldInterceptAjaxRequest;
    }

    if (interceptOnlyAsyncAjaxRequests !=
        other.interceptOnlyAsyncAjaxRequests) {
      diff['interceptOnlyAsyncAjaxRequests'] = () =>
          other.interceptOnlyAsyncAjaxRequests;
    }

    if (useShouldInterceptFetchRequest !=
        other.useShouldInterceptFetchRequest) {
      diff['useShouldInterceptFetchRequest'] = () =>
          other.useShouldInterceptFetchRequest;
    }

    if (incognito != other.incognito) {
      diff['incognito'] = () => other.incognito;
    }

    if (cacheEnabled != other.cacheEnabled) {
      diff['cacheEnabled'] = () => other.cacheEnabled;
    }

    if (transparentBackground != other.transparentBackground) {
      diff['transparentBackground'] = () => other.transparentBackground;
    }

    if (disableVerticalScroll != other.disableVerticalScroll) {
      diff['disableVerticalScroll'] = () => other.disableVerticalScroll;
    }

    if (disableHorizontalScroll != other.disableHorizontalScroll) {
      diff['disableHorizontalScroll'] = () => other.disableHorizontalScroll;
    }

    if (disableContextMenu != other.disableContextMenu) {
      diff['disableContextMenu'] = () => other.disableContextMenu;
    }

    if (stylusHandwritingEnabled != other.stylusHandwritingEnabled) {
      diff['stylusHandwritingEnabled'] = () => other.stylusHandwritingEnabled;
    }

    if (supportZoom != other.supportZoom) {
      diff['supportZoom'] = () => other.supportZoom;
    }

    if (allowFileAccessFromFileURLs != other.allowFileAccessFromFileURLs) {
      diff['allowFileAccessFromFileURLs'] = () =>
          other.allowFileAccessFromFileURLs;
    }

    if (allowUniversalAccessFromFileURLs !=
        other.allowUniversalAccessFromFileURLs) {
      diff['allowUniversalAccessFromFileURLs'] = () =>
          other.allowUniversalAccessFromFileURLs;
    }

    if (builtInZoomControls != other.builtInZoomControls) {
      diff['builtInZoomControls'] = () => other.builtInZoomControls;
    }

    if (displayZoomControls != other.displayZoomControls) {
      diff['displayZoomControls'] = () => other.displayZoomControls;
    }

    if (databaseEnabled != other.databaseEnabled) {
      diff['databaseEnabled'] = () => other.databaseEnabled;
    }

    if (domStorageEnabled != other.domStorageEnabled) {
      diff['domStorageEnabled'] = () => other.domStorageEnabled;
    }

    if (useWideViewPort != other.useWideViewPort) {
      diff['useWideViewPort'] = () => other.useWideViewPort;
    }

    if (safeBrowsingEnabled != other.safeBrowsingEnabled) {
      diff['safeBrowsingEnabled'] = () => other.safeBrowsingEnabled;
    }

    if (mixedContentMode != other.mixedContentMode) {
      diff['mixedContentMode'] = () => other.mixedContentMode;
    }

    if (allowContentAccess != other.allowContentAccess) {
      diff['allowContentAccess'] = () => other.allowContentAccess;
    }

    if (allowFileAccess != other.allowFileAccess) {
      diff['allowFileAccess'] = () => other.allowFileAccess;
    }

    if (blockNetworkImage != other.blockNetworkImage) {
      diff['blockNetworkImage'] = () => other.blockNetworkImage;
    }

    if (blockNetworkLoads != other.blockNetworkLoads) {
      diff['blockNetworkLoads'] = () => other.blockNetworkLoads;
    }

    if (cacheMode != other.cacheMode) {
      diff['cacheMode'] = () => other.cacheMode;
    }

    if (cursiveFontFamily != other.cursiveFontFamily) {
      diff['cursiveFontFamily'] = () => other.cursiveFontFamily;
    }

    if (defaultFixedFontSize != other.defaultFixedFontSize) {
      diff['defaultFixedFontSize'] = () => other.defaultFixedFontSize;
    }

    if (defaultFontSize != other.defaultFontSize) {
      diff['defaultFontSize'] = () => other.defaultFontSize;
    }

    if (defaultTextEncodingName != other.defaultTextEncodingName) {
      diff['defaultTextEncodingName'] = () => other.defaultTextEncodingName;
    }

    if (disabledActionModeMenuItems != other.disabledActionModeMenuItems) {
      diff['disabledActionModeMenuItems'] = () =>
          other.disabledActionModeMenuItems;
    }

    if (fantasyFontFamily != other.fantasyFontFamily) {
      diff['fantasyFontFamily'] = () => other.fantasyFontFamily;
    }

    if (fixedFontFamily != other.fixedFontFamily) {
      diff['fixedFontFamily'] = () => other.fixedFontFamily;
    }

    if (forceDark != other.forceDark) {
      diff['forceDark'] = () => other.forceDark;
    }

    if (forceDarkStrategy != other.forceDarkStrategy) {
      diff['forceDarkStrategy'] = () => other.forceDarkStrategy;
    }

    if (geolocationEnabled != other.geolocationEnabled) {
      diff['geolocationEnabled'] = () => other.geolocationEnabled;
    }

    if (layoutAlgorithm != other.layoutAlgorithm) {
      diff['layoutAlgorithm'] = () => other.layoutAlgorithm;
    }

    if (loadWithOverviewMode != other.loadWithOverviewMode) {
      diff['loadWithOverviewMode'] = () => other.loadWithOverviewMode;
    }

    if (loadsImagesAutomatically != other.loadsImagesAutomatically) {
      diff['loadsImagesAutomatically'] = () => other.loadsImagesAutomatically;
    }

    if (minimumLogicalFontSize != other.minimumLogicalFontSize) {
      diff['minimumLogicalFontSize'] = () => other.minimumLogicalFontSize;
    }

    if (needInitialFocus != other.needInitialFocus) {
      diff['needInitialFocus'] = () => other.needInitialFocus;
    }

    if (offscreenPreRaster != other.offscreenPreRaster) {
      diff['offscreenPreRaster'] = () => other.offscreenPreRaster;
    }

    if (sansSerifFontFamily != other.sansSerifFontFamily) {
      diff['sansSerifFontFamily'] = () => other.sansSerifFontFamily;
    }

    if (serifFontFamily != other.serifFontFamily) {
      diff['serifFontFamily'] = () => other.serifFontFamily;
    }

    if (standardFontFamily != other.standardFontFamily) {
      diff['standardFontFamily'] = () => other.standardFontFamily;
    }

    if (saveFormData != other.saveFormData) {
      diff['saveFormData'] = () => other.saveFormData;
    }

    if (thirdPartyCookiesEnabled != other.thirdPartyCookiesEnabled) {
      diff['thirdPartyCookiesEnabled'] = () => other.thirdPartyCookiesEnabled;
    }

    if (hardwareAcceleration != other.hardwareAcceleration) {
      diff['hardwareAcceleration'] = () => other.hardwareAcceleration;
    }

    if (initialScale != other.initialScale) {
      diff['initialScale'] = () => other.initialScale;
    }

    if (supportMultipleWindows != other.supportMultipleWindows) {
      diff['supportMultipleWindows'] = () => other.supportMultipleWindows;
    }

    if (regexToCancelSubFramesLoading != other.regexToCancelSubFramesLoading) {
      diff['regexToCancelSubFramesLoading'] = () =>
          other.regexToCancelSubFramesLoading;
    }

    if (regexToCancelOverrideUrlLoading !=
        other.regexToCancelOverrideUrlLoading) {
      diff['regexToCancelOverrideUrlLoading'] = () =>
          other.regexToCancelOverrideUrlLoading;
    }

    if (useHybridComposition != other.useHybridComposition) {
      diff['useHybridComposition'] = () => other.useHybridComposition;
    }

    if (useShouldInterceptRequest != other.useShouldInterceptRequest) {
      diff['useShouldInterceptRequest'] = () => other.useShouldInterceptRequest;
    }

    if (useOnRenderProcessGone != other.useOnRenderProcessGone) {
      diff['useOnRenderProcessGone'] = () => other.useOnRenderProcessGone;
    }

    if (overScrollMode != other.overScrollMode) {
      diff['overScrollMode'] = () => other.overScrollMode;
    }

    if (networkAvailable != other.networkAvailable) {
      diff['networkAvailable'] = () => other.networkAvailable;
    }

    if (scrollBarStyle != other.scrollBarStyle) {
      diff['scrollBarStyle'] = () => other.scrollBarStyle;
    }

    if (verticalScrollbarPosition != other.verticalScrollbarPosition) {
      diff['verticalScrollbarPosition'] = () => other.verticalScrollbarPosition;
    }

    if (scrollBarDefaultDelayBeforeFade !=
        other.scrollBarDefaultDelayBeforeFade) {
      diff['scrollBarDefaultDelayBeforeFade'] = () =>
          other.scrollBarDefaultDelayBeforeFade;
    }

    if (scrollbarFadingEnabled != other.scrollbarFadingEnabled) {
      diff['scrollbarFadingEnabled'] = () => other.scrollbarFadingEnabled;
    }

    if (scrollBarFadeDuration != other.scrollBarFadeDuration) {
      diff['scrollBarFadeDuration'] = () => other.scrollBarFadeDuration;
    }

    if (rendererPriorityPolicy != other.rendererPriorityPolicy) {
      diff['rendererPriorityPolicy'] = () => other.rendererPriorityPolicy;
    }

    if (disableDefaultErrorPage != other.disableDefaultErrorPage) {
      diff['disableDefaultErrorPage'] = () => other.disableDefaultErrorPage;
    }

    if (verticalScrollbarThumbColor != other.verticalScrollbarThumbColor) {
      diff['verticalScrollbarThumbColor'] = () =>
          other.verticalScrollbarThumbColor;
    }

    if (verticalScrollbarTrackColor != other.verticalScrollbarTrackColor) {
      diff['verticalScrollbarTrackColor'] = () =>
          other.verticalScrollbarTrackColor;
    }

    if (horizontalScrollbarThumbColor != other.horizontalScrollbarThumbColor) {
      diff['horizontalScrollbarThumbColor'] = () =>
          other.horizontalScrollbarThumbColor;
    }

    if (horizontalScrollbarTrackColor != other.horizontalScrollbarTrackColor) {
      diff['horizontalScrollbarTrackColor'] = () =>
          other.horizontalScrollbarTrackColor;
    }

    if (algorithmicDarkeningAllowed != other.algorithmicDarkeningAllowed) {
      diff['algorithmicDarkeningAllowed'] = () =>
          other.algorithmicDarkeningAllowed;
    }

    if (paymentRequestEnabled != other.paymentRequestEnabled) {
      diff['paymentRequestEnabled'] = () => other.paymentRequestEnabled;
    }

    if (webAuthenticationSupport != other.webAuthenticationSupport) {
      diff['webAuthenticationSupport'] = () => other.webAuthenticationSupport;
    }

    if (enterpriseAuthenticationAppLinkPolicyEnabled !=
        other.enterpriseAuthenticationAppLinkPolicyEnabled) {
      diff['enterpriseAuthenticationAppLinkPolicyEnabled'] = () =>
          other.enterpriseAuthenticationAppLinkPolicyEnabled;
    }

    if (defaultVideoPoster != other.defaultVideoPoster) {
      diff['defaultVideoPoster'] = () => other.defaultVideoPoster;
    }

    if (requestedWithHeaderOriginAllowList !=
        other.requestedWithHeaderOriginAllowList) {
      diff['requestedWithHeaderOriginAllowList'] = () =>
          other.requestedWithHeaderOriginAllowList;
    }

    if (disallowOverScroll != other.disallowOverScroll) {
      diff['disallowOverScroll'] = () => other.disallowOverScroll;
    }

    if (enableViewportScale != other.enableViewportScale) {
      diff['enableViewportScale'] = () => other.enableViewportScale;
    }

    if (suppressesIncrementalRendering !=
        other.suppressesIncrementalRendering) {
      diff['suppressesIncrementalRendering'] = () =>
          other.suppressesIncrementalRendering;
    }

    if (allowsAirPlayForMediaPlayback != other.allowsAirPlayForMediaPlayback) {
      diff['allowsAirPlayForMediaPlayback'] = () =>
          other.allowsAirPlayForMediaPlayback;
    }

    if (allowsBackForwardNavigationGestures !=
        other.allowsBackForwardNavigationGestures) {
      diff['allowsBackForwardNavigationGestures'] = () =>
          other.allowsBackForwardNavigationGestures;
    }

    if (allowsLinkPreview != other.allowsLinkPreview) {
      diff['allowsLinkPreview'] = () => other.allowsLinkPreview;
    }

    if (ignoresViewportScaleLimits != other.ignoresViewportScaleLimits) {
      diff['ignoresViewportScaleLimits'] = () =>
          other.ignoresViewportScaleLimits;
    }

    if (allowsInlineMediaPlayback != other.allowsInlineMediaPlayback) {
      diff['allowsInlineMediaPlayback'] = () => other.allowsInlineMediaPlayback;
    }

    if (allowsPictureInPictureMediaPlayback !=
        other.allowsPictureInPictureMediaPlayback) {
      diff['allowsPictureInPictureMediaPlayback'] = () =>
          other.allowsPictureInPictureMediaPlayback;
    }

    if (isFraudulentWebsiteWarningEnabled !=
        other.isFraudulentWebsiteWarningEnabled) {
      diff['isFraudulentWebsiteWarningEnabled'] = () =>
          other.isFraudulentWebsiteWarningEnabled;
    }

    if (selectionGranularity != other.selectionGranularity) {
      diff['selectionGranularity'] = () => other.selectionGranularity;
    }

    if (dataDetectorTypes != other.dataDetectorTypes) {
      diff['dataDetectorTypes'] = () => other.dataDetectorTypes;
    }

    if (sharedCookiesEnabled != other.sharedCookiesEnabled) {
      diff['sharedCookiesEnabled'] = () => other.sharedCookiesEnabled;
    }

    if (automaticallyAdjustsScrollIndicatorInsets !=
        other.automaticallyAdjustsScrollIndicatorInsets) {
      diff['automaticallyAdjustsScrollIndicatorInsets'] = () =>
          other.automaticallyAdjustsScrollIndicatorInsets;
    }

    if (accessibilityIgnoresInvertColors !=
        other.accessibilityIgnoresInvertColors) {
      diff['accessibilityIgnoresInvertColors'] = () =>
          other.accessibilityIgnoresInvertColors;
    }

    if (decelerationRate != other.decelerationRate) {
      diff['decelerationRate'] = () => other.decelerationRate;
    }

    if (alwaysBounceVertical != other.alwaysBounceVertical) {
      diff['alwaysBounceVertical'] = () => other.alwaysBounceVertical;
    }

    if (alwaysBounceHorizontal != other.alwaysBounceHorizontal) {
      diff['alwaysBounceHorizontal'] = () => other.alwaysBounceHorizontal;
    }

    if (bouncesHorizontally != other.bouncesHorizontally) {
      diff['bouncesHorizontally'] = () => other.bouncesHorizontally;
    }

    if (bouncesVertically != other.bouncesVertically) {
      diff['bouncesVertically'] = () => other.bouncesVertically;
    }

    if (scrollsToTop != other.scrollsToTop) {
      diff['scrollsToTop'] = () => other.scrollsToTop;
    }

    if (isPagingEnabled != other.isPagingEnabled) {
      diff['isPagingEnabled'] = () => other.isPagingEnabled;
    }

    if (maximumZoomScale != other.maximumZoomScale) {
      diff['maximumZoomScale'] = () => other.maximumZoomScale;
    }

    if (minimumZoomScale != other.minimumZoomScale) {
      diff['minimumZoomScale'] = () => other.minimumZoomScale;
    }

    if (contentInsetAdjustmentBehavior !=
        other.contentInsetAdjustmentBehavior) {
      diff['contentInsetAdjustmentBehavior'] = () =>
          other.contentInsetAdjustmentBehavior;
    }

    if (isDirectionalLockEnabled != other.isDirectionalLockEnabled) {
      diff['isDirectionalLockEnabled'] = () => other.isDirectionalLockEnabled;
    }

    if (mediaType != other.mediaType) {
      diff['mediaType'] = () => other.mediaType;
    }

    if (pageZoom != other.pageZoom) {
      diff['pageZoom'] = () => other.pageZoom;
    }

    if (limitsNavigationsToAppBoundDomains !=
        other.limitsNavigationsToAppBoundDomains) {
      diff['limitsNavigationsToAppBoundDomains'] = () =>
          other.limitsNavigationsToAppBoundDomains;
    }

    if (useOnNavigationResponse != other.useOnNavigationResponse) {
      diff['useOnNavigationResponse'] = () => other.useOnNavigationResponse;
    }

    if (applePayAPIEnabled != other.applePayAPIEnabled) {
      diff['applePayAPIEnabled'] = () => other.applePayAPIEnabled;
    }

    if (allowingReadAccessTo != other.allowingReadAccessTo) {
      diff['allowingReadAccessTo'] = () => other.allowingReadAccessTo;
    }

    if (disableLongPressContextMenuOnLinks !=
        other.disableLongPressContextMenuOnLinks) {
      diff['disableLongPressContextMenuOnLinks'] = () =>
          other.disableLongPressContextMenuOnLinks;
    }

    if (disableInputAccessoryView != other.disableInputAccessoryView) {
      diff['disableInputAccessoryView'] = () => other.disableInputAccessoryView;
    }

    if (underPageBackgroundColor != other.underPageBackgroundColor) {
      diff['underPageBackgroundColor'] = () => other.underPageBackgroundColor;
    }

    if (isTextInteractionEnabled != other.isTextInteractionEnabled) {
      diff['isTextInteractionEnabled'] = () => other.isTextInteractionEnabled;
    }

    if (isSiteSpecificQuirksModeEnabled !=
        other.isSiteSpecificQuirksModeEnabled) {
      diff['isSiteSpecificQuirksModeEnabled'] = () =>
          other.isSiteSpecificQuirksModeEnabled;
    }

    if (upgradeKnownHostsToHTTPS != other.upgradeKnownHostsToHTTPS) {
      diff['upgradeKnownHostsToHTTPS'] = () => other.upgradeKnownHostsToHTTPS;
    }

    if (isElementFullscreenEnabled != other.isElementFullscreenEnabled) {
      diff['isElementFullscreenEnabled'] = () =>
          other.isElementFullscreenEnabled;
    }

    if (isFindInteractionEnabled != other.isFindInteractionEnabled) {
      diff['isFindInteractionEnabled'] = () => other.isFindInteractionEnabled;
    }

    if (minimumViewportInset != other.minimumViewportInset) {
      diff['minimumViewportInset'] = () => other.minimumViewportInset;
    }

    if (maximumViewportInset != other.maximumViewportInset) {
      diff['maximumViewportInset'] = () => other.maximumViewportInset;
    }

    if (isInspectable != other.isInspectable) {
      diff['isInspectable'] = () => other.isInspectable;
    }

    if (shouldPrintBackgrounds != other.shouldPrintBackgrounds) {
      diff['shouldPrintBackgrounds'] = () => other.shouldPrintBackgrounds;
    }

    if (allowBackgroundAudioPlaying != other.allowBackgroundAudioPlaying) {
      diff['allowBackgroundAudioPlaying'] = () =>
          other.allowBackgroundAudioPlaying;
    }

    if (webViewAssetLoader != other.webViewAssetLoader) {
      diff['webViewAssetLoader'] = () => other.webViewAssetLoader;
    }

    if (iframeAllow != other.iframeAllow) {
      diff['iframeAllow'] = () => other.iframeAllow;
    }

    if (iframeAllowFullscreen != other.iframeAllowFullscreen) {
      diff['iframeAllowFullscreen'] = () => other.iframeAllowFullscreen;
    }

    if (iframeSandbox != other.iframeSandbox) {
      diff['iframeSandbox'] = () => other.iframeSandbox;
    }

    if (iframeReferrerPolicy != other.iframeReferrerPolicy) {
      diff['iframeReferrerPolicy'] = () => other.iframeReferrerPolicy;
    }

    if (iframeName != other.iframeName) {
      diff['iframeName'] = () => other.iframeName;
    }

    if (iframeCsp != other.iframeCsp) {
      diff['iframeCsp'] = () => other.iframeCsp;
    }

    if (dismissDialogues != other.dismissDialogues) {
      diff['dismissDialogues'] = () => other.dismissDialogues;
    }

    if (insetsForWebContentToIgnore != other.insetsForWebContentToIgnore) {
      diff['insetsForWebContentToIgnore'] = () =>
          other.insetsForWebContentToIgnore;
    }

    if (useNetworkCapture != other.useNetworkCapture) {
      diff['useNetworkCapture'] = () => other.useNetworkCapture;
    }

    if (networkCaptureMaxBodySize != other.networkCaptureMaxBodySize) {
      diff['networkCaptureMaxBodySize'] = () => other.networkCaptureMaxBodySize;
    }

    if (networkCaptureBodies != other.networkCaptureBodies) {
      diff['networkCaptureBodies'] = () => other.networkCaptureBodies;
    }

    if (networkCaptureBinaryBodies != other.networkCaptureBinaryBodies) {
      diff['networkCaptureBinaryBodies'] = () =>
          other.networkCaptureBinaryBodies;
    }

    if (networkCaptureUrlPatterns != other.networkCaptureUrlPatterns) {
      diff['networkCaptureUrlPatterns'] = () => other.networkCaptureUrlPatterns;
    }

    if (networkCaptureUrlPatternType != other.networkCaptureUrlPatternType) {
      diff['networkCaptureUrlPatternType'] = () =>
          other.networkCaptureUrlPatternType;
    }

    if (networkCaptureResourceTypes != other.networkCaptureResourceTypes) {
      diff['networkCaptureResourceTypes'] = () =>
          other.networkCaptureResourceTypes;
    }

    if (networkCaptureMimeTypes != other.networkCaptureMimeTypes) {
      diff['networkCaptureMimeTypes'] = () => other.networkCaptureMimeTypes;
    }

    if (networkCapture != other.networkCapture) {
      diff['networkCapture'] = () => other.networkCapture;
    }
    return diff;
  }
}
