import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'src/in_app_webview_web_platform.dart';

/// The web implementation of [InAppWebViewPlatform].
class ZikzakInAppWebViewWeb {
  /// Registers this class as the default instance of [InAppWebViewPlatform].
  static void registerWith(Registrar registrar) {
    InAppWebViewPlatform.instance = ZikzakInAppWebViewWebPlatform();
  }
}
