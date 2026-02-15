import 'dart:core';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

///{@macro zikzak_inappwebview_platform_interface.PlatformWebViewEnvironment}
class WebViewEnvironment {
  /// Constructs a [WebViewEnvironment].
  ///
  /// See [WebViewEnvironment.fromPlatformCreationParams] for setting parameters for
  /// a specific platform.
  WebViewEnvironment.fromPlatformCreationParams({
    required PlatformWebViewEnvironmentCreationParams params,
  }) : this.fromPlatform(platform: PlatformWebViewEnvironment(params));

  /// Constructs a [WebViewEnvironment] from a specific platform implementation.
  WebViewEnvironment.fromPlatform({required this.platform});

  /// Implementation of [PlatformWebViewEnvironment] for the current platform.
  final PlatformWebViewEnvironment platform;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebViewEnvironment.id}
  String get id => platform.id;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebViewEnvironment.settings}
  WebViewEnvironmentSettings? get settings => platform.settings;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebViewEnvironment.create}
  static Future<WebViewEnvironment> create(
      {WebViewEnvironmentSettings? settings}) async {
    return WebViewEnvironment.fromPlatform(
        platform: await PlatformWebViewEnvironment.static()
            .create(settings: settings));
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebViewEnvironment.getAvailableVersion}
  static Future<String?> getAvailableVersion(
          {String? browserExecutableFolder}) =>
      PlatformWebViewEnvironment.static().getAvailableVersion(
          browserExecutableFolder: browserExecutableFolder);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebViewEnvironment.getAvailableVersion}
  static Future<int?> compareBrowserVersions(
          {required String version1, required String version2}) =>
      PlatformWebViewEnvironment.static()
          .compareBrowserVersions(version1: version1, version2: version2);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebViewEnvironment.dispose}
  Future<void> dispose() => platform.dispose();
}
