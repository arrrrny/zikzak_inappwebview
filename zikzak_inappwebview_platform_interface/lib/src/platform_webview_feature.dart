import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';
import 'inappwebview_platform.dart';
import 'types/disposable.dart';

part 'platform_webview_feature.g.dart';

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
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
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
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
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
@ExchangeableEnum()
class WebViewFeature_ {
  // ignore: unused_field
  final String _value;

  const WebViewFeature_._internal(this._value);

  @ExchangeableObjectMethod(ignore: true)
  String toNativeValue() => _value;

  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewController.createWebMessageChannel].
  static const CREATE_WEB_MESSAGE_CHANNEL = const WebViewFeature_._internal(
    "CREATE_WEB_MESSAGE_CHANNEL",
  );

  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewSettings.disabledActionModeMenuItems].
  static const DISABLED_ACTION_MODE_MENU_ITEMS =
      const WebViewFeature_._internal("DISABLED_ACTION_MODE_MENU_ITEMS");

  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewSettings.forceDark].
  static const FORCE_DARK = const WebViewFeature_._internal("FORCE_DARK");

  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewSettings.forceDarkStrategy].
  static const FORCE_DARK_STRATEGY = const WebViewFeature_._internal(
    "FORCE_DARK_STRATEGY",
  );

  ///
  static const GET_WEB_CHROME_CLIENT = const WebViewFeature_._internal(
    "GET_WEB_CHROME_CLIENT",
  );

  ///
  static const GET_WEB_VIEW_CLIENT = const WebViewFeature_._internal(
    "GET_WEB_VIEW_CLIENT",
  );

  ///
  static const GET_WEB_VIEW_RENDERER = const WebViewFeature_._internal(
    "GET_WEB_VIEW_RENDERER",
  );

  ///
  static const MULTI_PROCESS = const WebViewFeature_._internal("MULTI_PROCESS");

  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewSettings.offscreenPreRaster].
  static const OFF_SCREEN_PRERASTER = const WebViewFeature_._internal(
    "OFF_SCREEN_PRERASTER",
  );

  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewController.postWebMessage].
  static const POST_WEB_MESSAGE = const WebViewFeature_._internal(
    "POST_WEB_MESSAGE",
  );

  ///Feature for [isFeatureSupported]. This feature covers [ProxyController.setProxyOverride] and [ProxyController.clearProxyOverride].
  static const PROXY_OVERRIDE = const WebViewFeature_._internal(
    "PROXY_OVERRIDE",
  );

  ///Feature for [isFeatureSupported]. This feature covers [ProxySettings.reverseBypassEnabled].
  static const PROXY_OVERRIDE_REVERSE_BYPASS = const WebViewFeature_._internal(
    "PROXY_OVERRIDE_REVERSE_BYPASS",
  );

  ///
  static const RECEIVE_HTTP_ERROR = const WebViewFeature_._internal(
    "RECEIVE_HTTP_ERROR",
  );

  ///
  static const RECEIVE_WEB_RESOURCE_ERROR = const WebViewFeature_._internal(
    "RECEIVE_WEB_RESOURCE_ERROR",
  );

  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewController.setSafeBrowsingAllowlist].
  static const SAFE_BROWSING_ALLOWLIST = const WebViewFeature_._internal(
    "SAFE_BROWSING_ALLOWLIST",
  );

  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewSettings.safeBrowsingEnabled].
  static const SAFE_BROWSING_ENABLE = const WebViewFeature_._internal(
    "SAFE_BROWSING_ENABLE",
  );

  ///
  static const SAFE_BROWSING_HIT = const WebViewFeature_._internal(
    "SAFE_BROWSING_HIT",
  );

  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewController.getSafeBrowsingPrivacyPolicyUrl].
  static const SAFE_BROWSING_PRIVACY_POLICY_URL =
      const WebViewFeature_._internal("SAFE_BROWSING_PRIVACY_POLICY_URL");

  ///
  static const SAFE_BROWSING_RESPONSE_BACK_TO_SAFETY =
      const WebViewFeature_._internal("SAFE_BROWSING_RESPONSE_BACK_TO_SAFETY");

  ///
  static const SAFE_BROWSING_RESPONSE_PROCEED = const WebViewFeature_._internal(
    "SAFE_BROWSING_RESPONSE_PROCEED",
  );

  ///
  static const SAFE_BROWSING_RESPONSE_SHOW_INTERSTITIAL =
      const WebViewFeature_._internal(
        "SAFE_BROWSING_RESPONSE_SHOW_INTERSTITIAL",
      );

  ///Feature for [isFeatureSupported]. This feature covers [ServiceWorkerController].
  static const SERVICE_WORKER_BASIC_USAGE = const WebViewFeature_._internal(
    "SERVICE_WORKER_BASIC_USAGE",
  );

  ///Feature for [isFeatureSupported]. This feature covers [ServiceWorkerController.setBlockNetworkLoads] and [ServiceWorkerController.getBlockNetworkLoads].
  static const SERVICE_WORKER_BLOCK_NETWORK_LOADS =
      const WebViewFeature_._internal("SERVICE_WORKER_BLOCK_NETWORK_LOADS");

  ///Feature for [isFeatureSupported]. This feature covers [ServiceWorkerController.setCacheMode] and [ServiceWorkerController.getCacheMode].
  static const SERVICE_WORKER_CACHE_MODE = const WebViewFeature_._internal(
    "SERVICE_WORKER_CACHE_MODE",
  );

  ///Feature for [isFeatureSupported]. This feature covers [ServiceWorkerController.setAllowContentAccess] and [ServiceWorkerController.getAllowContentAccess].
  static const SERVICE_WORKER_CONTENT_ACCESS = const WebViewFeature_._internal(
    "SERVICE_WORKER_CONTENT_ACCESS",
  );

  ///Feature for [isFeatureSupported]. This feature covers [ServiceWorkerController.setAllowFileAccess] and [ServiceWorkerController.getAllowFileAccess].
  static const SERVICE_WORKER_FILE_ACCESS = const WebViewFeature_._internal(
    "SERVICE_WORKER_FILE_ACCESS",
  );

  ///Feature for [isFeatureSupported]. This feature covers [ServiceWorkerClient.shouldInterceptRequest].
  static const SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST =
      const WebViewFeature_._internal(
        "SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST",
      );

  ///
  static const SHOULD_OVERRIDE_WITH_REDIRECTS = const WebViewFeature_._internal(
    "SHOULD_OVERRIDE_WITH_REDIRECTS",
  );

  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewController.startSafeBrowsing].
  static const START_SAFE_BROWSING = const WebViewFeature_._internal(
    "START_SAFE_BROWSING",
  );

  ///
  static const TRACING_CONTROLLER_BASIC_USAGE = const WebViewFeature_._internal(
    "TRACING_CONTROLLER_BASIC_USAGE",
  );

  ///
  static const VISUAL_STATE_CALLBACK = const WebViewFeature_._internal(
    "VISUAL_STATE_CALLBACK",
  );

  ///
  static const WEB_MESSAGE_CALLBACK_ON_MESSAGE =
      const WebViewFeature_._internal("WEB_MESSAGE_CALLBACK_ON_MESSAGE");

  ///Feature for [isFeatureSupported]. This feature covers [WebMessageListener].
  static const WEB_MESSAGE_LISTENER = const WebViewFeature_._internal(
    "WEB_MESSAGE_LISTENER",
  );

  ///
  static const WEB_MESSAGE_PORT_CLOSE = const WebViewFeature_._internal(
    "WEB_MESSAGE_PORT_CLOSE",
  );

  ///
  static const WEB_MESSAGE_PORT_POST_MESSAGE = const WebViewFeature_._internal(
    "WEB_MESSAGE_PORT_POST_MESSAGE",
  );

  ///
  static const WEB_MESSAGE_PORT_SET_MESSAGE_CALLBACK =
      const WebViewFeature_._internal("WEB_MESSAGE_PORT_SET_MESSAGE_CALLBACK");

  ///
  static const WEB_RESOURCE_ERROR_GET_CODE = const WebViewFeature_._internal(
    "WEB_RESOURCE_ERROR_GET_CODE",
  );

  ///
  static const WEB_RESOURCE_ERROR_GET_DESCRIPTION =
      const WebViewFeature_._internal("WEB_RESOURCE_ERROR_GET_DESCRIPTION");

  ///
  static const WEB_RESOURCE_REQUEST_IS_REDIRECT =
      const WebViewFeature_._internal("WEB_RESOURCE_REQUEST_IS_REDIRECT");

  ///
  static const WEB_VIEW_RENDERER_CLIENT_BASIC_USAGE =
      const WebViewFeature_._internal("WEB_VIEW_RENDERER_CLIENT_BASIC_USAGE");

  ///
  static const WEB_VIEW_RENDERER_TERMINATE = const WebViewFeature_._internal(
    "WEB_VIEW_RENDERER_TERMINATE",
  );

  ///Feature for [isFeatureSupported]. This feature covers [UserScriptInjectionTime.AT_DOCUMENT_START].
  static const DOCUMENT_START_SCRIPT = const WebViewFeature_._internal(
    "DOCUMENT_START_SCRIPT",
  );

  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewSettings.algorithmicDarkeningAllowed].
  static const ALGORITHMIC_DARKENING = const WebViewFeature_._internal(
    "ALGORITHMIC_DARKENING",
  );

  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewSettings.enterpriseAuthenticationAppLinkPolicyEnabled].
  static const ENTERPRISE_AUTHENTICATION_APP_LINK_POLICY =
      const WebViewFeature_._internal(
        "ENTERPRISE_AUTHENTICATION_APP_LINK_POLICY",
      );

  ///Feature for [isFeatureSupported]. This feature covers [InAppWebViewController.getVariationsHeader].
  static const GET_VARIATIONS_HEADER = const WebViewFeature_._internal(
    "GET_VARIATIONS_HEADER",
  );

  ///Feature for [isFeatureSupported]. This feature covers cookie attributes of [CookieManager.getCookie] and [CookieManager.getCookies] methods.
  static const GET_COOKIE_INFO = const WebViewFeature_._internal(
    "GET_COOKIE_INFO",
  );

  ///Feature for [isFeatureSupported]. This feature covers cookie attributes of [CookieManager.getCookie] and [CookieManager.getCookies] methods.
  static const REQUESTED_WITH_HEADER_ALLOW_LIST =
      const WebViewFeature_._internal("REQUESTED_WITH_HEADER_ALLOW_LIST");

  ///Feature for [isFeatureSupported]. This feature covers [WebMessagePort.postMessage] with `ArrayBuffer` type,
  ///[InAppWebViewController.postWebMessage] with `ArrayBuffer` type, and [JavaScriptReplyProxy.postMessage] with `ArrayBuffer` type.
  static const WEB_MESSAGE_ARRAY_BUFFER = const WebViewFeature_._internal(
    "WEB_MESSAGE_ARRAY_BUFFER",
  );

  ///Feature for [isStartupFeatureSupported]. This feature covers [ProcessGlobalConfigSettings.dataDirectorySuffix].
  static const STARTUP_FEATURE_SET_DATA_DIRECTORY_SUFFIX =
      const WebViewFeature_._internal(
        "STARTUP_FEATURE_SET_DATA_DIRECTORY_SUFFIX",
      );

  ///Feature for [isStartupFeatureSupported]. This feature covers [ProcessGlobalConfigSettings.directoryBasePaths].
  static const STARTUP_FEATURE_SET_DIRECTORY_BASE_PATHS =
      const WebViewFeature_._internal(
        "STARTUP_FEATURE_SET_DIRECTORY_BASE_PATHS",
      );

  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebViewFeature.isFeatureSupported}
  static Future<bool> isFeatureSupported(WebViewFeature feature) =>
      PlatformWebViewFeature.static().isFeatureSupported(feature);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebViewFeature.isStartupFeatureSupported}
  static Future<bool> isStartupFeatureSupported(
    WebViewFeature startupFeature,
  ) =>
      PlatformWebViewFeature.static().isStartupFeatureSupported(startupFeature);
}
