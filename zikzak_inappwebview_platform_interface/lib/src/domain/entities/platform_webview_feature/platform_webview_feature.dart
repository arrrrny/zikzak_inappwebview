import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../../../inappwebview_platform.dart';
import '../../../types/disposable.dart';

/// Object specifying creation parameters for creating a [PlatformWebViewFeature].
///
/// Platform specific implementations can add additional fields by extending
/// this class.
@immutable
class PlatformWebViewFeatureCreationParams {
  /// Used by the platform implementation to create a new [PlatformWebViewFeature].
  const PlatformWebViewFeatureCreationParams();
}

///{@template zikzak_inappwebview_platform_interface.PlatformWebViewFeature}
///Class that represents an Android-specific utility class for checking which WebView Support Library features are supported on the device.
///
///
///**Officially Supported Platforms/Implementations**:
///- Android native WebView
///{@endtemplate}
abstract class PlatformWebViewFeature extends PlatformInterface
    implements Disposable {
  /// Creates a new [PlatformWebViewFeature]
  factory PlatformWebViewFeature(PlatformWebViewFeatureCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `zikzak_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformWebViewFeature webViewFeature = InAppWebViewPlatform.instance!
        .createPlatformWebViewFeature(params);
    PlatformInterface.verify(webViewFeature, _token);
    return webViewFeature;
  }

  /// Creates a new empty [PlatformWebViewFeature] to access static methods.
  factory PlatformWebViewFeature.static() {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `zikzak_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformWebViewFeature webViewFeatureStatic = InAppWebViewPlatform
        .instance!
        .createPlatformWebViewFeatureStatic();
    PlatformInterface.verify(webViewFeatureStatic, _token);
    return webViewFeatureStatic;
  }

  /// Used by the platform implementation to create a new
  /// [PlatformWebViewFeature].
  ///
  /// Should only be used by platform implementations because they can't extend
  /// a class that only contains a factory constructor.
  @protected
  PlatformWebViewFeature.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  /// The parameters used to initialize the [PlatformWebViewFeature].
  final PlatformWebViewFeatureCreationParams params;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewFeature.isFeatureSupported}
  ///Return whether a feature is supported at run-time. On devices running Android version `Build.VERSION_CODES.LOLLIPOP` and higher,
  ///this will check whether a feature is supported, depending on the combination of the desired feature, the Android version of device,
  ///and the WebView APK on the device. If running on a device with a lower API level, this will always return `false`.
  ///
  ///**Note**: This method is different from [isStartupFeatureSupported] and this
  ///method only accepts certain features.
  ///Please verify that the correct feature checking method is used for a particular feature.
  ///
  ///**Note**: If this method returns `false`, it is not safe to invoke the methods
  ///requiring the desired feature.
  ///Furthermore, if this method returns `false` for a particular feature, any callback guarded by that feature will not be invoked.
  ///
  ///**Official Android API**: https://developer.android.com/reference/androidx/webkit/WebViewFeature#isFeatureSupported(java.lang.String)
  ///{@endtemplate}
  Future<bool> isFeatureSupported(WebViewFeature feature) {
    throw UnimplementedError(
      'isFeatureSupported is not implemented on the current platform',
    );
  }

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewFeature.isStartupFeatureSupported}
  ///Return whether a startup feature is supported at run-time.
  ///On devices running Android version `Build.VERSION_CODES.LOLLIPOP` and higher,
  ///this will check whether a startup feature is supported,
  ///depending on the combination of the desired feature,
  ///the Android version of device, and the WebView APK on the device.
  ///If running on a device with a lower API level, this will always return `false`.
  ///
  ///**Note**: This method is different from [isFeatureSupported] and this method only accepts startup features.
  ///Please verify that the correct feature checking method is used for a particular feature.
  ///
  ///**Note**: If this method returns `false`, it is not safe to invoke the methods requiring the desired feature.
  ///Furthermore, if this method returns `false` for a particular feature,
  ///any callback guarded by that feature will not be invoked.
  ///
  ///**Official Android API**: https://developer.android.com/reference/androidx/webkit/WebViewFeature#isFeatureSupported(java.lang.String)
  ///{@endtemplate}
  Future<bool> isStartupFeatureSupported(WebViewFeature startupFeature) {
    throw UnimplementedError(
      'isStartupFeatureSupported is not implemented on the current platform',
    );
  }
}

///{@macro zikzak_inappwebview_platform_interface.PlatformWebViewFeature}
enum WebViewFeature {
  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewController.createWebMessageChannel].
  CREATE_WEB_MESSAGE_CHANNEL,
  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewSettings.disabledActionModeMenuItems].
  DISABLED_ACTION_MODE_MENU_ITEMS,
  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewSettings.forceDark].
  FORCE_DARK,
  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewSettings.forceDarkStrategy].
  FORCE_DARK_STRATEGY,
  ///
  GET_WEB_CHROME_CLIENT,
  ///
  GET_WEB_VIEW_CLIENT,
  ///
  GET_WEB_VIEW_RENDERER,
  ///
  MULTI_PROCESS,
  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewSettings.offscreenPreRaster].
  OFF_SCREEN_PRERASTER,
  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewController.postWebMessage].
  POST_WEB_MESSAGE,
  ///Feature for [isFeatureSupported]. This feature covers [ProxyController.setProxyOverride] and [ProxyController.clearProxyOverride].
  PROXY_OVERRIDE,
  ///Feature for [isFeatureSupported]. This feature covers [ProxySettings.reverseBypassEnabled].
  PROXY_OVERRIDE_REVERSE_BYPASS,
  ///
  RECEIVE_HTTP_ERROR,
  ///
  RECEIVE_WEB_RESOURCE_ERROR,
  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewController.setSafeBrowsingAllowlist].
  SAFE_BROWSING_ALLOWLIST,
  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewSettings.safeBrowsingEnabled].
  SAFE_BROWSING_ENABLE,
  ///
  SAFE_BROWSING_HIT,
  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewController.getSafeBrowsingPrivacyPolicyUrl].
  SAFE_BROWSING_PRIVACY_POLICY_URL,
  ///
  SAFE_BROWSING_RESPONSE_BACK_TO_SAFETY,
  ///
  SAFE_BROWSING_RESPONSE_PROCEED,
  ///
  SAFE_BROWSING_RESPONSE_SHOW_INTERSTITIAL,
  ///Feature for [isFeatureSupported]. This feature covers [ServiceWorkerController].
  SERVICE_WORKER_BASIC_USAGE,
  ///Feature for [isFeatureSupported]. This feature covers [ServiceWorkerController.setBlockNetworkLoads] and [ServiceWorkerController.getBlockNetworkLoads].
  SERVICE_WORKER_BLOCK_NETWORK_LOADS,
  ///Feature for [isFeatureSupported]. This feature covers [ServiceWorkerController.setCacheMode] and [ServiceWorkerController.getCacheMode].
  SERVICE_WORKER_CACHE_MODE,
  ///Feature for [isFeatureSupported]. This feature covers [ServiceWorkerController.setAllowContentAccess] and [ServiceWorkerController.getAllowContentAccess].
  SERVICE_WORKER_CONTENT_ACCESS,
  ///Feature for [isFeatureSupported]. This feature covers [ServiceWorkerController.setAllowFileAccess] and [ServiceWorkerController.getAllowFileAccess].
  SERVICE_WORKER_FILE_ACCESS,
  ///Feature for [isFeatureSupported]. This feature covers [ServiceWorkerClient.shouldInterceptRequest].
  SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST,
  ///
  SHOULD_OVERRIDE_WITH_REDIRECTS,
  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewController.startSafeBrowsing].
  START_SAFE_BROWSING,
  ///
  TRACING_CONTROLLER_BASIC_USAGE,
  ///
  VISUAL_STATE_CALLBACK,
  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewSettings.webAuthenticationSupport].
  WEB_AUTHENTICATION,
  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewSettings.paymentRequestEnabled].
  PAYMENT_REQUEST,
  ///
  WEB_MESSAGE_CALLBACK_ON_MESSAGE,
  ///Feature for [isFeatureSupported]. This feature covers [WebMessageListener].
  WEB_MESSAGE_LISTENER,
  ///
  WEB_MESSAGE_PORT_CLOSE,
  ///
  WEB_MESSAGE_PORT_POST_MESSAGE,
  ///
  WEB_MESSAGE_PORT_SET_MESSAGE_CALLBACK,
  ///
  WEB_RESOURCE_ERROR_GET_CODE,
  ///
  WEB_RESOURCE_ERROR_GET_DESCRIPTION,
  ///
  WEB_RESOURCE_REQUEST_IS_REDIRECT,
  ///
  WEB_VIEW_RENDERER_CLIENT_BASIC_USAGE,
  ///
  WEB_VIEW_RENDERER_TERMINATE,
  ///Feature for [isFeatureSupported]. This feature covers [UserScriptInjectionTime.AT_DOCUMENT_START].
  DOCUMENT_START_SCRIPT,
  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewSettings.algorithmicDarkeningAllowed].
  ALGORITHMIC_DARKENING,
  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewSettings.enterpriseAuthenticationAppLinkPolicyEnabled].
  ENTERPRISE_AUTHENTICATION_APP_LINK_POLICY,
  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewController.getVariationsHeader].
  GET_VARIATIONS_HEADER,
  ///Feature for [isFeatureSupported]. This feature covers cookie attributes of [CookieManager.getCookie] and [CookieManager.getCookies] methods.
  GET_COOKIE_INFO,
  ///Feature for [isFeatureSupported]. This feature covers cookie attributes of [CookieManager.getCookie] and [CookieManager.getCookies] methods.
  REQUESTED_WITH_HEADER_ALLOW_LIST,
  ///Feature for [isFeatureSupported]. This feature covers [WebMessagePort.postMessage] with `ArrayBuffer` type,
  ///[InAppWebViewController.postWebMessage] with `ArrayBuffer` type, and [JavaScriptReplyProxy.postMessage] with `ArrayBuffer` type.
  WEB_MESSAGE_ARRAY_BUFFER,
  ///Feature for [isStartupFeatureSupported]. This feature covers [ProcessGlobalConfigSettings.dataDirectorySuffix].
  STARTUP_FEATURE_SET_DATA_DIRECTORY_SUFFIX,
  ///Feature for [isStartupFeatureSupported]. This feature covers [ProcessGlobalConfigSettings.directoryBasePaths].
  STARTUP_FEATURE_SET_DIRECTORY_BASE_PATHS,
}
