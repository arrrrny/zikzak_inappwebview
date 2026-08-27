import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../in_app_webview_controller.dart';

/// Android implementation of [PlatformSettingsDelegate].
///
/// Forwards every call to the parent [AndroidInAppWebViewController].
/// Behavior is identical to calling the controller directly — this is a
/// focused facade, not a separate implementation. Part of the
/// domain-controller split (issue #229, P3).
class AndroidSettingsDelegate extends PlatformSettingsDelegate {
  /// Creates a new [AndroidSettingsDelegate] bound to [_controller].
  AndroidSettingsDelegate(this._controller) : super(token: _token);

  static final Object _token = Object();

  final AndroidInAppWebViewController _controller;

  @override
  Future<void> setSettings({required InAppWebViewSettings settings}) =>
      _controller.setSettings(settings: settings);

  @override
  Future<InAppWebViewSettings?> getSettings() => _controller.getSettings();
}
