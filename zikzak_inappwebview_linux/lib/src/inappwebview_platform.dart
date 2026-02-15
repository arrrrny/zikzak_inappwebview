import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'cookie_manager.dart';
import 'find_interaction/find_interaction_controller.dart';
import 'in_app_webview/in_app_webview.dart';
import 'in_app_webview/in_app_webview_controller.dart';
import 'in_app_webview/headless_in_app_webview.dart';
import 'in_app_browser/in_app_browser.dart';

/// Implementation of [InAppWebViewPlatform] using the WebKitGTK API for Linux.
class LinuxInAppWebViewPlatform extends InAppWebViewPlatform {
  /// Registers this class as the default instance of [InAppWebViewPlatform].
  static void registerWith() {
    InAppWebViewPlatform.instance = LinuxInAppWebViewPlatform();
  }

  @override
  PlatformCookieManager createPlatformCookieManager(
    PlatformCookieManagerCreationParams params,
  ) {
    return LinuxCookieManager(params);
  }

  @override
  PlatformInAppWebViewController createPlatformInAppWebViewController(
    PlatformInAppWebViewControllerCreationParams params,
  ) {
    return LinuxInAppWebViewController(params);
  }

  @override
  PlatformInAppWebViewController createPlatformInAppWebViewControllerStatic() {
    return LinuxInAppWebViewController.static();
  }

  @override
  PlatformInAppWebViewWidget createPlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams params,
  ) {
    return LinuxInAppWebViewWidget(params);
  }

  @override
  PlatformFindInteractionController createPlatformFindInteractionController(
    PlatformFindInteractionControllerCreationParams params,
  ) {
    return LinuxFindInteractionController(params);
  }

  @override
  PlatformHeadlessInAppWebView createPlatformHeadlessInAppWebView(
    PlatformHeadlessInAppWebViewCreationParams params,
  ) {
    return LinuxHeadlessInAppWebView(params);
  }

  @override
  PlatformInAppBrowser createPlatformInAppBrowser(
    PlatformInAppBrowserCreationParams params,
  ) {
    return LinuxInAppBrowser(params);
  }

  @override
  PlatformInAppBrowser createPlatformInAppBrowserStatic() {
    return LinuxInAppBrowser.static();
  }
}
