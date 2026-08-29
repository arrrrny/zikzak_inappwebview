import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../domain/entities/in_app_webview_settings/in_app_webview_settings.dart';
import '../platform_inappwebview_controller.dart';

/// Delegate for reading and updating the WebView settings of a single
/// [PlatformInAppWebViewController].
///
/// Part of the domain-controller split (issue #229, P3). Exposes the
/// settings subset of [PlatformInAppWebViewController] behind a focused
/// facade so the main controller stays easy to reason about.
///
/// Platform implementations override the [PlatformInAppWebViewController.settingsDelegate]
/// getter to return a concrete instance. The default getter returns `null`,
/// preserving backward compatibility for implementations that have not yet
/// been migrated.
abstract class PlatformSettingsDelegate extends PlatformInterface {
  /// Creates a new [PlatformSettingsDelegate].
  PlatformSettingsDelegate({required Object token}) : super(token: token);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.setSettings}
  Future<void> setSettings({required InAppWebViewSettings settings}) {
    throw UnimplementedError(
      'setSettings is not implemented on the current platform',
    );
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewController.getSettings}
  Future<InAppWebViewSettings?> getSettings() {
    throw UnimplementedError(
      'getSettings is not implemented on the current platform',
    );
  }
}
