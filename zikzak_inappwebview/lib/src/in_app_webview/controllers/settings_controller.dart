import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../in_app_webview_controller.dart';

///Domain-specific facade of [InAppWebViewController] for reading and
///updating the WebView settings.
///
///Part of the domain controller split (issue #161, P3). Every method
///delegates to the parent [InAppWebViewController].
class SettingsController {
  final InAppWebViewController _controller;

  ///Creates a [SettingsController] bound to the given controller.
  const SettingsController(this._controller);

  ///The current settings of the WebView.
  Future<InAppWebViewSettings?> getSettings() => _controller.getSettings();

  ///Updates the WebView with the given [settings].
  Future<void> setSettings({required InAppWebViewSettings settings}) =>
      _controller.setSettings(settings: settings);
}
