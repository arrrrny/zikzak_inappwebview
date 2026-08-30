// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_webview_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InAppWebViewSettings _$InAppWebViewSettingsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('InAppWebViewSettings', json, ($checkedConvert) {
  final val = InAppWebViewSettings(
    useShouldOverrideUrlLoading: $checkedConvert(
      'useShouldOverrideUrlLoading',
      (v) => v as bool?,
    ),
    useOnLoadResource: $checkedConvert('useOnLoadResource', (v) => v as bool?),
    useOnDownloadStart: $checkedConvert(
      'useOnDownloadStart',
      (v) => v as bool?,
    ),
    userAgent: $checkedConvert('userAgent', (v) => v as String? ?? ''),
    applicationNameForUserAgent: $checkedConvert(
      'applicationNameForUserAgent',
      (v) => v as String? ?? '',
    ),
    javaScriptEnabled: $checkedConvert(
      'javaScriptEnabled',
      (v) => v as bool? ?? true,
    ),
    javaScriptCanOpenWindowsAutomatically: $checkedConvert(
      'javaScriptCanOpenWindowsAutomatically',
      (v) => v as bool? ?? false,
    ),
    mediaPlaybackRequiresUserGesture: $checkedConvert(
      'mediaPlaybackRequiresUserGesture',
      (v) => v as bool? ?? true,
    ),
    minimumFontSize: $checkedConvert(
      'minimumFontSize',
      (v) => (v as num?)?.toInt(),
    ),
    verticalScrollBarEnabled: $checkedConvert(
      'verticalScrollBarEnabled',
      (v) => v as bool? ?? true,
    ),
    horizontalScrollBarEnabled: $checkedConvert(
      'horizontalScrollBarEnabled',
      (v) => v as bool? ?? true,
    ),
    resourceCustomSchemes: $checkedConvert(
      'resourceCustomSchemes',
      (v) => (v as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    ),
    contentBlockers: $checkedConvert(
      'contentBlockers',
      (v) => v == null ? [] : _deserializeContentBlockers(v),
    ),
    preferredContentMode: $checkedConvert(
      'preferredContentMode',
      (v) => v == null
          ? UserPreferredContentMode.RECOMMENDED
          : userPreferredContentModeFromWire(v),
    ),
    useShouldInterceptAjaxRequest: $checkedConvert(
      'useShouldInterceptAjaxRequest',
      (v) => v as bool?,
    ),
    interceptOnlyAsyncAjaxRequests: $checkedConvert(
      'interceptOnlyAsyncAjaxRequests',
      (v) => v as bool? ?? true,
    ),
    useShouldInterceptFetchRequest: $checkedConvert(
      'useShouldInterceptFetchRequest',
      (v) => v as bool?,
    ),
    incognito: $checkedConvert('incognito', (v) => v as bool? ?? false),
    persistentStoreIdentifier: $checkedConvert(
      'persistentStoreIdentifier',
      (v) => v as String?,
    ),
    cacheEnabled: $checkedConvert('cacheEnabled', (v) => v as bool? ?? true),
    transparentBackground: $checkedConvert(
      'transparentBackground',
      (v) => v as bool? ?? false,
    ),
    disableVerticalScroll: $checkedConvert(
      'disableVerticalScroll',
      (v) => v as bool? ?? false,
    ),
    disableHorizontalScroll: $checkedConvert(
      'disableHorizontalScroll',
      (v) => v as bool? ?? false,
    ),
    disableContextMenu: $checkedConvert(
      'disableContextMenu',
      (v) => v as bool? ?? false,
    ),
    stylusHandwritingEnabled: $checkedConvert(
      'stylusHandwritingEnabled',
      (v) => v as bool?,
    ),
    supportZoom: $checkedConvert('supportZoom', (v) => v as bool? ?? true),
    allowFileAccessFromFileURLs: $checkedConvert(
      'allowFileAccessFromFileURLs',
      (v) => v as bool? ?? false,
    ),
    allowUniversalAccessFromFileURLs: $checkedConvert(
      'allowUniversalAccessFromFileURLs',
      (v) => v as bool? ?? false,
    ),
    builtInZoomControls: $checkedConvert(
      'builtInZoomControls',
      (v) => v as bool? ?? true,
    ),
    displayZoomControls: $checkedConvert(
      'displayZoomControls',
      (v) => v as bool? ?? false,
    ),
    databaseEnabled: $checkedConvert(
      'databaseEnabled',
      (v) => v as bool? ?? true,
    ),
    domStorageEnabled: $checkedConvert(
      'domStorageEnabled',
      (v) => v as bool? ?? true,
    ),
    useWideViewPort: $checkedConvert(
      'useWideViewPort',
      (v) => v as bool? ?? true,
    ),
    safeBrowsingEnabled: $checkedConvert(
      'safeBrowsingEnabled',
      (v) => v as bool? ?? true,
    ),
    mixedContentMode: $checkedConvert(
      'mixedContentMode',
      (v) => mixedContentModeFromWire(v),
    ),
    allowContentAccess: $checkedConvert(
      'allowContentAccess',
      (v) => v as bool? ?? true,
    ),
    allowFileAccess: $checkedConvert(
      'allowFileAccess',
      (v) => v as bool? ?? true,
    ),
    blockNetworkImage: $checkedConvert(
      'blockNetworkImage',
      (v) => v as bool? ?? false,
    ),
    blockNetworkLoads: $checkedConvert(
      'blockNetworkLoads',
      (v) => v as bool? ?? false,
    ),
    cacheMode: $checkedConvert(
      'cacheMode',
      (v) => v == null ? CacheMode.LOAD_DEFAULT : cacheModeFromWire(v),
    ),
    cursiveFontFamily: $checkedConvert(
      'cursiveFontFamily',
      (v) => v as String? ?? 'cursive',
    ),
    defaultFixedFontSize: $checkedConvert(
      'defaultFixedFontSize',
      (v) => (v as num?)?.toInt() ?? 16,
    ),
    defaultFontSize: $checkedConvert(
      'defaultFontSize',
      (v) => (v as num?)?.toInt() ?? 16,
    ),
    defaultTextEncodingName: $checkedConvert(
      'defaultTextEncodingName',
      (v) => v as String? ?? 'UTF-8',
    ),
    disabledActionModeMenuItems: $checkedConvert(
      'disabledActionModeMenuItems',
      (v) => actionModeMenuItemFromWire(v),
    ),
    fantasyFontFamily: $checkedConvert(
      'fantasyFontFamily',
      (v) => v as String? ?? 'fantasy',
    ),
    fixedFontFamily: $checkedConvert(
      'fixedFontFamily',
      (v) => v as String? ?? 'monospace',
    ),
    forceDark: $checkedConvert(
      'forceDark',
      (v) => v == null ? ForceDark.OFF : forceDarkFromWire(v),
    ),
    forceDarkStrategy: $checkedConvert(
      'forceDarkStrategy',
      (v) => v == null
          ? ForceDarkStrategy.PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING
          : forceDarkStrategyFromWire(v),
    ),
    geolocationEnabled: $checkedConvert(
      'geolocationEnabled',
      (v) => v as bool? ?? true,
    ),
    layoutAlgorithm: $checkedConvert(
      'layoutAlgorithm',
      (v) => $enumDecodeNullable(_$LayoutAlgorithmEnumMap, v),
    ),
    loadWithOverviewMode: $checkedConvert(
      'loadWithOverviewMode',
      (v) => v as bool? ?? true,
    ),
    loadsImagesAutomatically: $checkedConvert(
      'loadsImagesAutomatically',
      (v) => v as bool? ?? true,
    ),
    minimumLogicalFontSize: $checkedConvert(
      'minimumLogicalFontSize',
      (v) => (v as num?)?.toInt() ?? 8,
    ),
    needInitialFocus: $checkedConvert(
      'needInitialFocus',
      (v) => v as bool? ?? true,
    ),
    offscreenPreRaster: $checkedConvert(
      'offscreenPreRaster',
      (v) => v as bool? ?? false,
    ),
    sansSerifFontFamily: $checkedConvert(
      'sansSerifFontFamily',
      (v) => v as String? ?? 'sans-serif',
    ),
    serifFontFamily: $checkedConvert(
      'serifFontFamily',
      (v) => v as String? ?? 'sans-serif',
    ),
    standardFontFamily: $checkedConvert(
      'standardFontFamily',
      (v) => v as String? ?? 'sans-serif',
    ),
    saveFormData: $checkedConvert('saveFormData', (v) => v as bool? ?? true),
    thirdPartyCookiesEnabled: $checkedConvert(
      'thirdPartyCookiesEnabled',
      (v) => v as bool? ?? true,
    ),
    hardwareAcceleration: $checkedConvert(
      'hardwareAcceleration',
      (v) => v as bool? ?? true,
    ),
    initialScale: $checkedConvert(
      'initialScale',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    supportMultipleWindows: $checkedConvert(
      'supportMultipleWindows',
      (v) => v as bool? ?? false,
    ),
    regexToCancelSubFramesLoading: $checkedConvert(
      'regexToCancelSubFramesLoading',
      (v) => v as String?,
    ),
    regexToCancelOverrideUrlLoading: $checkedConvert(
      'regexToCancelOverrideUrlLoading',
      (v) => v as String?,
    ),
    useHybridComposition: $checkedConvert(
      'useHybridComposition',
      (v) => v as bool? ?? true,
    ),
    useShouldInterceptRequest: $checkedConvert(
      'useShouldInterceptRequest',
      (v) => v as bool?,
    ),
    useOnRenderProcessGone: $checkedConvert(
      'useOnRenderProcessGone',
      (v) => v as bool?,
    ),
    overScrollMode: $checkedConvert(
      'overScrollMode',
      (v) => v == null
          ? OverScrollMode.IF_CONTENT_SCROLLS
          : overScrollModeFromWire(v),
    ),
    networkAvailable: $checkedConvert('networkAvailable', (v) => v as bool?),
    scrollBarStyle: $checkedConvert(
      'scrollBarStyle',
      (v) => v == null
          ? ScrollBarStyle.SCROLLBARS_INSIDE_OVERLAY
          : scrollBarStyleFromWire(v),
    ),
    verticalScrollbarPosition: $checkedConvert(
      'verticalScrollbarPosition',
      (v) => v == null
          ? VerticalScrollbarPosition.SCROLLBAR_POSITION_DEFAULT
          : verticalScrollbarPositionFromWire(v),
    ),
    scrollBarDefaultDelayBeforeFade: $checkedConvert(
      'scrollBarDefaultDelayBeforeFade',
      (v) => (v as num?)?.toInt(),
    ),
    scrollbarFadingEnabled: $checkedConvert(
      'scrollbarFadingEnabled',
      (v) => v as bool? ?? true,
    ),
    scrollBarFadeDuration: $checkedConvert(
      'scrollBarFadeDuration',
      (v) => (v as num?)?.toInt(),
    ),
    rendererPriorityPolicy: $checkedConvert(
      'rendererPriorityPolicy',
      (v) => v == null
          ? null
          : RendererPriorityPolicy.fromJson(Map<String, dynamic>.from(v as Map)),
    ),
    disableDefaultErrorPage: $checkedConvert(
      'disableDefaultErrorPage',
      (v) => v as bool? ?? false,
    ),
    verticalScrollbarThumbColor: $checkedConvert(
      'verticalScrollbarThumbColor',
      (v) => _colorFromJson(v),
    ),
    verticalScrollbarTrackColor: $checkedConvert(
      'verticalScrollbarTrackColor',
      (v) => _colorFromJson(v),
    ),
    horizontalScrollbarThumbColor: $checkedConvert(
      'horizontalScrollbarThumbColor',
      (v) => _colorFromJson(v),
    ),
    horizontalScrollbarTrackColor: $checkedConvert(
      'horizontalScrollbarTrackColor',
      (v) => _colorFromJson(v),
    ),
    algorithmicDarkeningAllowed: $checkedConvert(
      'algorithmicDarkeningAllowed',
      (v) => v as bool? ?? false,
    ),
    paymentRequestEnabled: $checkedConvert(
      'paymentRequestEnabled',
      (v) => v as bool?,
    ),
    webAuthenticationSupport: $checkedConvert(
      'webAuthenticationSupport',
      (v) => webAuthenticationSupportFromWire(v),
    ),
    enterpriseAuthenticationAppLinkPolicyEnabled: $checkedConvert(
      'enterpriseAuthenticationAppLinkPolicyEnabled',
      (v) => v as bool? ?? true,
    ),
    defaultVideoPoster: $checkedConvert(
      'defaultVideoPoster',
      (v) => _defaultVideoPosterFromJson(v),
    ),
    requestedWithHeaderOriginAllowList: $checkedConvert(
      'requestedWithHeaderOriginAllowList',
      (v) => (v as List<dynamic>?)?.map((e) => e as String).toSet(),
    ),
    disallowOverScroll: $checkedConvert(
      'disallowOverScroll',
      (v) => v as bool? ?? false,
    ),
    enableViewportScale: $checkedConvert(
      'enableViewportScale',
      (v) => v as bool? ?? false,
    ),
    suppressesIncrementalRendering: $checkedConvert(
      'suppressesIncrementalRendering',
      (v) => v as bool? ?? false,
    ),
    allowsAirPlayForMediaPlayback: $checkedConvert(
      'allowsAirPlayForMediaPlayback',
      (v) => v as bool? ?? true,
    ),
    allowsBackForwardNavigationGestures: $checkedConvert(
      'allowsBackForwardNavigationGestures',
      (v) => v as bool? ?? true,
    ),
    allowsLinkPreview: $checkedConvert(
      'allowsLinkPreview',
      (v) => v as bool? ?? true,
    ),
    ignoresViewportScaleLimits: $checkedConvert(
      'ignoresViewportScaleLimits',
      (v) => v as bool? ?? false,
    ),
    allowsInlineMediaPlayback: $checkedConvert(
      'allowsInlineMediaPlayback',
      (v) => v as bool? ?? false,
    ),
    allowsPictureInPictureMediaPlayback: $checkedConvert(
      'allowsPictureInPictureMediaPlayback',
      (v) => v as bool? ?? true,
    ),
    isFraudulentWebsiteWarningEnabled: $checkedConvert(
      'isFraudulentWebsiteWarningEnabled',
      (v) => v as bool? ?? true,
    ),
    selectionGranularity: $checkedConvert(
      'selectionGranularity',
      (v) =>
          $enumDecodeNullable(_$SelectionGranularityEnumMap, v) ??
          SelectionGranularity.DYNAMIC,
    ),
    dataDetectorTypes: $checkedConvert(
      'dataDetectorTypes',
      (v) => (v as List<dynamic>?)
          ?.map((e) => $enumDecode(_$DataDetectorTypesEnumMap, e))
          .toList(),
    ),
    sharedCookiesEnabled: $checkedConvert(
      'sharedCookiesEnabled',
      (v) => v as bool? ?? false,
    ),
    automaticallyAdjustsScrollIndicatorInsets: $checkedConvert(
      'automaticallyAdjustsScrollIndicatorInsets',
      (v) => v as bool? ?? false,
    ),
    accessibilityIgnoresInvertColors: $checkedConvert(
      'accessibilityIgnoresInvertColors',
      (v) => v as bool? ?? false,
    ),
    decelerationRate: $checkedConvert(
      'decelerationRate',
      (v) =>
          $enumDecodeNullable(_$ScrollViewDecelerationRateEnumMap, v) ??
          ScrollViewDecelerationRate.NORMAL,
    ),
    alwaysBounceVertical: $checkedConvert(
      'alwaysBounceVertical',
      (v) => v as bool? ?? false,
    ),
    alwaysBounceHorizontal: $checkedConvert(
      'alwaysBounceHorizontal',
      (v) => v as bool? ?? false,
    ),
    bouncesHorizontally: $checkedConvert(
      'bouncesHorizontally',
      (v) => v as bool?,
    ),
    bouncesVertically: $checkedConvert('bouncesVertically', (v) => v as bool?),
    scrollsToTop: $checkedConvert('scrollsToTop', (v) => v as bool? ?? true),
    isPagingEnabled: $checkedConvert(
      'isPagingEnabled',
      (v) => v as bool? ?? false,
    ),
    maximumZoomScale: $checkedConvert(
      'maximumZoomScale',
      (v) => (v as num?)?.toDouble() ?? 1.0,
    ),
    minimumZoomScale: $checkedConvert(
      'minimumZoomScale',
      (v) => (v as num?)?.toDouble() ?? 1.0,
    ),
    contentInsetAdjustmentBehavior: $checkedConvert(
      'contentInsetAdjustmentBehavior',
      (v) =>
          $enumDecodeNullable(
            _$ScrollViewContentInsetAdjustmentBehaviorEnumMap,
            v,
          ) ??
          ScrollViewContentInsetAdjustmentBehavior.NEVER,
    ),
    isDirectionalLockEnabled: $checkedConvert(
      'isDirectionalLockEnabled',
      (v) => v as bool? ?? false,
    ),
    mediaType: $checkedConvert('mediaType', (v) => v as String?),
    pageZoom: $checkedConvert(
      'pageZoom',
      (v) => (v as num?)?.toDouble() ?? 1.0,
    ),
    limitsNavigationsToAppBoundDomains: $checkedConvert(
      'limitsNavigationsToAppBoundDomains',
      (v) => v as bool? ?? false,
    ),
    useOnNavigationResponse: $checkedConvert(
      'useOnNavigationResponse',
      (v) => v as bool?,
    ),
    applePayAPIEnabled: $checkedConvert(
      'applePayAPIEnabled',
      (v) => v as bool? ?? false,
    ),
    allowingReadAccessTo: $checkedConvert(
      'allowingReadAccessTo',
      (v) => _allowingReadAccessToFromJson(v),
    ),
    disableLongPressContextMenuOnLinks: $checkedConvert(
      'disableLongPressContextMenuOnLinks',
      (v) => v as bool? ?? false,
    ),
    disableInputAccessoryView: $checkedConvert(
      'disableInputAccessoryView',
      (v) => v as bool? ?? false,
    ),
    underPageBackgroundColor: $checkedConvert(
      'underPageBackgroundColor',
      (v) => _colorFromJson(v),
    ),
    isTextInteractionEnabled: $checkedConvert(
      'isTextInteractionEnabled',
      (v) => v as bool? ?? true,
    ),
    isSiteSpecificQuirksModeEnabled: $checkedConvert(
      'isSiteSpecificQuirksModeEnabled',
      (v) => v as bool? ?? true,
    ),
    upgradeKnownHostsToHTTPS: $checkedConvert(
      'upgradeKnownHostsToHTTPS',
      (v) => v as bool? ?? true,
    ),
    isElementFullscreenEnabled: $checkedConvert(
      'isElementFullscreenEnabled',
      (v) => v as bool? ?? true,
    ),
    isFindInteractionEnabled: $checkedConvert(
      'isFindInteractionEnabled',
      (v) => v as bool? ?? false,
    ),
    minimumViewportInset: $checkedConvert(
      'minimumViewportInset',
      (v) => _minimumViewportInsetFromJson(v),
    ),
    maximumViewportInset: $checkedConvert(
      'maximumViewportInset',
      (v) => _maximumViewportInsetFromJson(v),
    ),
    isInspectable: $checkedConvert('isInspectable', (v) => v as bool? ?? false),
    shouldPrintBackgrounds: $checkedConvert(
      'shouldPrintBackgrounds',
      (v) => v as bool? ?? false,
    ),
    allowBackgroundAudioPlaying: $checkedConvert(
      'allowBackgroundAudioPlaying',
      (v) => v as bool? ?? false,
    ),
    webViewAssetLoader: $checkedConvert(
      'webViewAssetLoader',
      (v) => v == null
          ? null
          : WebViewAssetLoader.fromJson(Map<String, dynamic>.from(v as Map)),
    ),
    iframeAllow: $checkedConvert('iframeAllow', (v) => v as String?),
    iframeAllowFullscreen: $checkedConvert(
      'iframeAllowFullscreen',
      (v) => v as bool?,
    ),
    iframeSandbox: $checkedConvert(
      'iframeSandbox',
      (v) => _iframeSandboxFromJson(v),
    ),
    iframeReferrerPolicy: $checkedConvert(
      'iframeReferrerPolicy',
      (v) => $enumDecodeNullable(_$ReferrerPolicyEnumMap, v),
    ),
    iframeName: $checkedConvert('iframeName', (v) => v as String?),
    iframeCsp: $checkedConvert('iframeCsp', (v) => v as String?),
    dismissDialogues: $checkedConvert(
      'dismissDialogues',
      (v) => v as bool? ?? false,
    ),
    insetsForWebContentToIgnore: $checkedConvert(
      'insetsForWebContentToIgnore',
      (v) => _insetsFromJson(v),
    ),
    useNetworkCapture: $checkedConvert('useNetworkCapture', (v) => v as bool?),
    networkCaptureMaxBodySize: $checkedConvert(
      'networkCaptureMaxBodySize',
      (v) => (v as num?)?.toInt() ?? 50000,
    ),
    networkCaptureBodies: $checkedConvert(
      'networkCaptureBodies',
      (v) => v as bool? ?? true,
    ),
    networkCaptureBinaryBodies: $checkedConvert(
      'networkCaptureBinaryBodies',
      (v) => v as bool? ?? false,
    ),
    networkCaptureUrlPatterns: $checkedConvert(
      'networkCaptureUrlPatterns',
      (v) => (v as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    ),
    networkCaptureUrlPatternType: $checkedConvert(
      'networkCaptureUrlPatternType',
      (v) => _urlPatternTypeFromJson(v),
    ),
    networkCaptureResourceTypes: $checkedConvert(
      'networkCaptureResourceTypes',
      (v) => _resourceTypesFromJson(v),
    ),
    networkCaptureMimeTypes: $checkedConvert(
      'networkCaptureMimeTypes',
      (v) => (v as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    ),
  );
  return val;
});

Map<String, dynamic> _$InAppWebViewSettingsToJson(
  InAppWebViewSettings instance,
) => <String, dynamic>{
  'useShouldOverrideUrlLoading': instance.useShouldOverrideUrlLoading,
  'useOnLoadResource': instance.useOnLoadResource,
  'useOnDownloadStart': instance.useOnDownloadStart,
  'userAgent': instance.userAgent,
  'applicationNameForUserAgent': instance.applicationNameForUserAgent,
  'javaScriptEnabled': instance.javaScriptEnabled,
  'javaScriptCanOpenWindowsAutomatically':
      instance.javaScriptCanOpenWindowsAutomatically,
  'mediaPlaybackRequiresUserGesture': instance.mediaPlaybackRequiresUserGesture,
  'minimumFontSize': instance.minimumFontSize,
  'verticalScrollBarEnabled': instance.verticalScrollBarEnabled,
  'horizontalScrollBarEnabled': instance.horizontalScrollBarEnabled,
  'resourceCustomSchemes': instance.resourceCustomSchemes,
  'contentBlockers': _serializeContentBlockers(instance.contentBlockers),
  'preferredContentMode': userPreferredContentModeToWire(
    instance.preferredContentMode,
  ),
  'useShouldInterceptAjaxRequest': instance.useShouldInterceptAjaxRequest,
  'interceptOnlyAsyncAjaxRequests': instance.interceptOnlyAsyncAjaxRequests,
  'useShouldInterceptFetchRequest': instance.useShouldInterceptFetchRequest,
  'incognito': instance.incognito,
  'persistentStoreIdentifier': ?instance.persistentStoreIdentifier,
  'cacheEnabled': instance.cacheEnabled,
  'transparentBackground': instance.transparentBackground,
  'disableVerticalScroll': instance.disableVerticalScroll,
  'disableHorizontalScroll': instance.disableHorizontalScroll,
  'disableContextMenu': instance.disableContextMenu,
  'stylusHandwritingEnabled': instance.stylusHandwritingEnabled,
  'supportZoom': instance.supportZoom,
  'allowFileAccessFromFileURLs': instance.allowFileAccessFromFileURLs,
  'allowUniversalAccessFromFileURLs': instance.allowUniversalAccessFromFileURLs,
  'builtInZoomControls': instance.builtInZoomControls,
  'displayZoomControls': instance.displayZoomControls,
  'databaseEnabled': instance.databaseEnabled,
  'domStorageEnabled': instance.domStorageEnabled,
  'useWideViewPort': instance.useWideViewPort,
  'safeBrowsingEnabled': instance.safeBrowsingEnabled,
  'mixedContentMode': mixedContentModeToWire(instance.mixedContentMode),
  'allowContentAccess': instance.allowContentAccess,
  'allowFileAccess': instance.allowFileAccess,
  'blockNetworkImage': instance.blockNetworkImage,
  'blockNetworkLoads': instance.blockNetworkLoads,
  'cacheMode': cacheModeToWire(instance.cacheMode),
  'cursiveFontFamily': instance.cursiveFontFamily,
  'defaultFixedFontSize': instance.defaultFixedFontSize,
  'defaultFontSize': instance.defaultFontSize,
  'defaultTextEncodingName': instance.defaultTextEncodingName,
  'disabledActionModeMenuItems': actionModeMenuItemToWire(
    instance.disabledActionModeMenuItems,
  ),
  'fantasyFontFamily': instance.fantasyFontFamily,
  'fixedFontFamily': instance.fixedFontFamily,
  'forceDark': forceDarkToWire(instance.forceDark),
  'forceDarkStrategy': forceDarkStrategyToWire(instance.forceDarkStrategy),
  'geolocationEnabled': instance.geolocationEnabled,
  'layoutAlgorithm': _$LayoutAlgorithmEnumMap[instance.layoutAlgorithm],
  'loadWithOverviewMode': instance.loadWithOverviewMode,
  'loadsImagesAutomatically': instance.loadsImagesAutomatically,
  'minimumLogicalFontSize': instance.minimumLogicalFontSize,
  'needInitialFocus': instance.needInitialFocus,
  'offscreenPreRaster': instance.offscreenPreRaster,
  'sansSerifFontFamily': instance.sansSerifFontFamily,
  'serifFontFamily': instance.serifFontFamily,
  'standardFontFamily': instance.standardFontFamily,
  'saveFormData': instance.saveFormData,
  'thirdPartyCookiesEnabled': instance.thirdPartyCookiesEnabled,
  'hardwareAcceleration': instance.hardwareAcceleration,
  'initialScale': instance.initialScale,
  'supportMultipleWindows': instance.supportMultipleWindows,
  'regexToCancelSubFramesLoading': instance.regexToCancelSubFramesLoading,
  'regexToCancelOverrideUrlLoading': instance.regexToCancelOverrideUrlLoading,
  'useHybridComposition': instance.useHybridComposition,
  'useShouldInterceptRequest': instance.useShouldInterceptRequest,
  'useOnRenderProcessGone': instance.useOnRenderProcessGone,
  'overScrollMode': overScrollModeToWire(instance.overScrollMode),
  'networkAvailable': instance.networkAvailable,
  'scrollBarStyle': scrollBarStyleToWire(instance.scrollBarStyle),
  'verticalScrollbarPosition': verticalScrollbarPositionToWire(
    instance.verticalScrollbarPosition,
  ),
  'scrollBarDefaultDelayBeforeFade': instance.scrollBarDefaultDelayBeforeFade,
  'scrollbarFadingEnabled': instance.scrollbarFadingEnabled,
  'scrollBarFadeDuration': instance.scrollBarFadeDuration,
  'rendererPriorityPolicy': instance.rendererPriorityPolicy?.toJson(),
  'disableDefaultErrorPage': instance.disableDefaultErrorPage,
  'verticalScrollbarThumbColor': _colorToJson(
    instance.verticalScrollbarThumbColor,
  ),
  'verticalScrollbarTrackColor': _colorToJson(
    instance.verticalScrollbarTrackColor,
  ),
  'horizontalScrollbarThumbColor': _colorToJson(
    instance.horizontalScrollbarThumbColor,
  ),
  'horizontalScrollbarTrackColor': _colorToJson(
    instance.horizontalScrollbarTrackColor,
  ),
  'algorithmicDarkeningAllowed': instance.algorithmicDarkeningAllowed,
  'paymentRequestEnabled': instance.paymentRequestEnabled,
  'webAuthenticationSupport': webAuthenticationSupportToWire(
    instance.webAuthenticationSupport,
  ),
  'enterpriseAuthenticationAppLinkPolicyEnabled':
      instance.enterpriseAuthenticationAppLinkPolicyEnabled,
  'defaultVideoPoster': _defaultVideoPosterToJson(instance.defaultVideoPoster),
  'requestedWithHeaderOriginAllowList': instance
      .requestedWithHeaderOriginAllowList
      ?.toList(),
  'disallowOverScroll': instance.disallowOverScroll,
  'enableViewportScale': instance.enableViewportScale,
  'suppressesIncrementalRendering': instance.suppressesIncrementalRendering,
  'allowsAirPlayForMediaPlayback': instance.allowsAirPlayForMediaPlayback,
  'allowsBackForwardNavigationGestures':
      instance.allowsBackForwardNavigationGestures,
  'allowsLinkPreview': instance.allowsLinkPreview,
  'ignoresViewportScaleLimits': instance.ignoresViewportScaleLimits,
  'allowsInlineMediaPlayback': instance.allowsInlineMediaPlayback,
  'allowsPictureInPictureMediaPlayback':
      instance.allowsPictureInPictureMediaPlayback,
  'isFraudulentWebsiteWarningEnabled':
      instance.isFraudulentWebsiteWarningEnabled,
  'selectionGranularity':
      _$SelectionGranularityEnumMap[instance.selectionGranularity],
  'dataDetectorTypes': instance.dataDetectorTypes
      ?.map((e) => _$DataDetectorTypesEnumMap[e]!)
      .toList(),
  'sharedCookiesEnabled': instance.sharedCookiesEnabled,
  'automaticallyAdjustsScrollIndicatorInsets':
      instance.automaticallyAdjustsScrollIndicatorInsets,
  'accessibilityIgnoresInvertColors': instance.accessibilityIgnoresInvertColors,
  'decelerationRate':
      _$ScrollViewDecelerationRateEnumMap[instance.decelerationRate],
  'alwaysBounceVertical': instance.alwaysBounceVertical,
  'alwaysBounceHorizontal': instance.alwaysBounceHorizontal,
  'bouncesHorizontally': instance.bouncesHorizontally,
  'bouncesVertically': instance.bouncesVertically,
  'scrollsToTop': instance.scrollsToTop,
  'isPagingEnabled': instance.isPagingEnabled,
  'maximumZoomScale': instance.maximumZoomScale,
  'minimumZoomScale': instance.minimumZoomScale,
  'contentInsetAdjustmentBehavior':
      _$ScrollViewContentInsetAdjustmentBehaviorEnumMap[instance
          .contentInsetAdjustmentBehavior],
  'isDirectionalLockEnabled': instance.isDirectionalLockEnabled,
  'mediaType': instance.mediaType,
  'pageZoom': instance.pageZoom,
  'limitsNavigationsToAppBoundDomains':
      instance.limitsNavigationsToAppBoundDomains,
  'useOnNavigationResponse': instance.useOnNavigationResponse,
  'applePayAPIEnabled': instance.applePayAPIEnabled,
  'allowingReadAccessTo': _allowingReadAccessToToJson(
    instance.allowingReadAccessTo,
  ),
  'disableLongPressContextMenuOnLinks':
      instance.disableLongPressContextMenuOnLinks,
  'disableInputAccessoryView': instance.disableInputAccessoryView,
  'underPageBackgroundColor': _colorToJson(instance.underPageBackgroundColor),
  'isTextInteractionEnabled': instance.isTextInteractionEnabled,
  'isSiteSpecificQuirksModeEnabled': instance.isSiteSpecificQuirksModeEnabled,
  'upgradeKnownHostsToHTTPS': instance.upgradeKnownHostsToHTTPS,
  'isElementFullscreenEnabled': instance.isElementFullscreenEnabled,
  'isFindInteractionEnabled': instance.isFindInteractionEnabled,
  'minimumViewportInset': _minimumViewportInsetToJson(
    instance.minimumViewportInset,
  ),
  'maximumViewportInset': _maximumViewportInsetToJson(
    instance.maximumViewportInset,
  ),
  'isInspectable': instance.isInspectable,
  'shouldPrintBackgrounds': instance.shouldPrintBackgrounds,
  'allowBackgroundAudioPlaying': instance.allowBackgroundAudioPlaying,
  'webViewAssetLoader': instance.webViewAssetLoader?.toJson(),
  'iframeAllow': instance.iframeAllow,
  'iframeAllowFullscreen': instance.iframeAllowFullscreen,
  'iframeSandbox': _iframeSandboxToJson(instance.iframeSandbox),
  'iframeReferrerPolicy':
      _$ReferrerPolicyEnumMap[instance.iframeReferrerPolicy],
  'iframeName': instance.iframeName,
  'iframeCsp': instance.iframeCsp,
  'dismissDialogues': instance.dismissDialogues,
  'insetsForWebContentToIgnore': _insetsToJson(
    instance.insetsForWebContentToIgnore,
  ),
  'useNetworkCapture': instance.useNetworkCapture,
  'networkCaptureMaxBodySize': instance.networkCaptureMaxBodySize,
  'networkCaptureBodies': instance.networkCaptureBodies,
  'networkCaptureBinaryBodies': instance.networkCaptureBinaryBodies,
  'networkCaptureUrlPatterns': instance.networkCaptureUrlPatterns,
  'networkCaptureUrlPatternType': _urlPatternTypeToJson(
    instance.networkCaptureUrlPatternType,
  ),
  'networkCaptureResourceTypes': _resourceTypesToJson(
    instance.networkCaptureResourceTypes,
  ),
  'networkCaptureMimeTypes': instance.networkCaptureMimeTypes,
};

const _$LayoutAlgorithmEnumMap = {
  LayoutAlgorithm.NORMAL: 'NORMAL',
  LayoutAlgorithm.TEXT_AUTOSIZING: 'TEXT_AUTOSIZING',
  LayoutAlgorithm.NARROW_COLUMNS: 'NARROW_COLUMNS',
};

const _$SelectionGranularityEnumMap = {
  SelectionGranularity.DYNAMIC: 'DYNAMIC',
  SelectionGranularity.CHARACTER: 'CHARACTER',
};

const _$DataDetectorTypesEnumMap = {
  DataDetectorTypes.NONE: 'NONE',
  DataDetectorTypes.PHONE_NUMBER: 'PHONE_NUMBER',
  DataDetectorTypes.LINK: 'LINK',
  DataDetectorTypes.ADDRESS: 'ADDRESS',
  DataDetectorTypes.CALENDAR_EVENT: 'CALENDAR_EVENT',
  DataDetectorTypes.TRACKING_NUMBER: 'TRACKING_NUMBER',
  DataDetectorTypes.FLIGHT_NUMBER: 'FLIGHT_NUMBER',
  DataDetectorTypes.LOOKUP_SUGGESTION: 'LOOKUP_SUGGESTION',
  DataDetectorTypes.SPOTLIGHT_SUGGESTION: 'SPOTLIGHT_SUGGESTION',
  DataDetectorTypes.ALL: 'ALL',
};

const _$ScrollViewDecelerationRateEnumMap = {
  ScrollViewDecelerationRate.NORMAL: 'NORMAL',
  ScrollViewDecelerationRate.FAST: 'FAST',
};

const _$ScrollViewContentInsetAdjustmentBehaviorEnumMap = {
  ScrollViewContentInsetAdjustmentBehavior.AUTOMATIC: 'AUTOMATIC',
  ScrollViewContentInsetAdjustmentBehavior.SCROLLABLE_AXES: 'SCROLLABLE_AXES',
  ScrollViewContentInsetAdjustmentBehavior.NEVER: 'NEVER',
  ScrollViewContentInsetAdjustmentBehavior.ALWAYS: 'ALWAYS',
};

const _$ReferrerPolicyEnumMap = {
  ReferrerPolicy.NO_REFERRER: 'NO_REFERRER',
  ReferrerPolicy.NO_REFERRER_WHEN_DOWNGRADE: 'NO_REFERRER_WHEN_DOWNGRADE',
  ReferrerPolicy.ORIGIN: 'ORIGIN',
  ReferrerPolicy.ORIGIN_WHEN_CROSS_ORIGIN: 'ORIGIN_WHEN_CROSS_ORIGIN',
  ReferrerPolicy.SAME_ORIGIN: 'SAME_ORIGIN',
  ReferrerPolicy.STRICT_ORIGIN: 'STRICT_ORIGIN',
  ReferrerPolicy.STRICT_ORIGIN_WHEN_CROSS_ORIGIN:
      'STRICT_ORIGIN_WHEN_CROSS_ORIGIN',
  ReferrerPolicy.UNSAFE_URL: 'UNSAFE_URL',
};
