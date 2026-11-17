// Copyright 2024. All rights reserved.

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'src/in_app_webview_windows_platform.dart';
import 'src/cookie_manager.dart';
import 'src/webview_environment.dart';

export 'src/cookie_manager.dart';
export 'src/webview_environment.dart' show WindowsWebViewEnvironment;

/// The Windows implementation of [InAppWebViewPlatform].
class ZikzakInAppWebViewWindows extends InAppWebViewPlatform {
  @override
  PlatformCookieManager createPlatformCookieManager(
    PlatformCookieManagerCreationParams params,
  ) => WindowsCookieManager(params);

  @override
  PlatformWebViewEnvironment createPlatformWebViewEnvironment(
    PlatformWebViewEnvironmentCreationParams params,
  ) => WindowsWebViewEnvironment(params);

  @override
  PlatformWebViewEnvironment createPlatformWebViewEnvironmentStatic() =>
      WindowsWebViewEnvironment(
        const PlatformWebViewEnvironmentCreationParams(),
      );

  /// Registers this class as the default instance of [InAppWebViewPlatform].
  static void registerWith() {
    InAppWebViewPlatform.instance = ZikzakInAppWebViewWindows();
  }

  @override
  PlatformInAppWebViewController createPlatformInAppWebViewController(
    PlatformInAppWebViewControllerCreationParams params,
  ) {
    return InAppWebViewWindowsPlatform(params);
  }

  @override
  PlatformInAppWebViewWidget createPlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams params,
  ) {
    return InAppWebViewWindowsWidget(params);
  }
}
