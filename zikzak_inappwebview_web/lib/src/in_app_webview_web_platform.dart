import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'find_interaction_controller_web.dart';
import 'headless_in_app_webview_web.dart';
import 'in_app_webview_web_element.dart';

/// Implementation of [InAppWebViewPlatform] using the Web.
class ZikzakInAppWebViewWebPlatform extends InAppWebViewPlatform {
  /// Registers this class as the default instance of [InAppWebViewPlatform].
  static void registerWith(Registrar registrar) {
    InAppWebViewPlatform.instance = ZikzakInAppWebViewWebPlatform();
  }

  @override
  PlatformInAppWebViewWidget createPlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams params,
  ) {
    return InAppWebViewWebElement(params);
  }

  @override
  PlatformFindInteractionController createPlatformFindInteractionController(
    PlatformFindInteractionControllerCreationParams params,
  ) {
    return FindInteractionControllerWeb(params);
  }

  @override
  PlatformHeadlessInAppWebView createPlatformHeadlessInAppWebView(
    PlatformHeadlessInAppWebViewCreationParams params,
  ) {
    return HeadlessInAppWebViewWeb(params);
  }
}
