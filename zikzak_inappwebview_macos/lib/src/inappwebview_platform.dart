import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'cookie_manager.dart';
import 'find_interaction/find_interaction_controller.dart';
import 'in_app_webview/in_app_webview.dart';
import 'in_app_webview/in_app_webview_controller.dart';
import 'in_app_webview/headless_in_app_webview.dart';
import 'in_app_browser/in_app_browser.dart';

/// Implementation of [InAppWebViewPlatform] using the WebKit API for macOS.
class MacOSInAppWebViewPlatform extends InAppWebViewPlatform {
  /// Registers this class as the default instance of [InAppWebViewPlatform].
  static void registerWith() {
    InAppWebViewPlatform.instance = MacOSInAppWebViewPlatform();
  }

  @override
  PlatformCookieManager createPlatformCookieManager(
    PlatformCookieManagerCreationParams params,
  ) {
    return MacOSCookieManager(params);
  }

  @override
  PlatformInAppWebViewController createPlatformInAppWebViewController(
    PlatformInAppWebViewControllerCreationParams params,
  ) {
    return MacOSInAppWebViewController(params);
  }

  @override
  PlatformInAppWebViewController createPlatformInAppWebViewControllerStatic() {
    return MacOSInAppWebViewController.static();
  }

  @override
  PlatformInAppWebViewWidget createPlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams params,
  ) {
    return MacOSInAppWebViewWidget(params);
  }

  @override
  PlatformFindInteractionController createPlatformFindInteractionController(
    PlatformFindInteractionControllerCreationParams params,
  ) {
    return MacOSFindInteractionController(params);
  }

  @override
  PlatformHeadlessInAppWebView createPlatformHeadlessInAppWebView(
    PlatformHeadlessInAppWebViewCreationParams params,
  ) {
    return MacOSHeadlessInAppWebView(params);
  }

  @override
  PlatformInAppBrowser createPlatformInAppBrowser(
    PlatformInAppBrowserCreationParams params,
  ) {
    return MacOSInAppBrowser(params);
  }

  @override
  PlatformInAppBrowser createPlatformInAppBrowserStatic() {
    return MacOSInAppBrowser.static();
  }
}
