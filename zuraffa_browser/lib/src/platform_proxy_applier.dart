import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

import 'platform_settings.dart';
import 'proxy_ports.dart';

/// Production [ProxyApplier]: wraps zikzak_inappwebview's
/// [ProxyController] (`PlatformProxyController` infrastructure) so the
/// resolved proxy governs WebView-initiated network requests.
///
/// The platform override is process-wide (androidx.webkit ProxyController on
/// Android, iOS 17+ WKWebsiteDataStore proxy configuration); per-profile
/// isolation is enforced by the browser layer, which applies the navigating
/// scope's resolved proxy before each navigation (FR-007).
class PlatformProxyApplier implements ProxyApplier {
  /// Applies [proxy], or clears the override when null (direct connection).
  @override
  Future<void> apply(ResolvedProxy? proxy) async {
    final controller = ProxyController.instance();
    if (proxy == null) {
      await controller.clearProxyOverride();
      return;
    }
    await controller.setProxyOverride(
      settings: proxySettingsFromConfig(proxy.config, password: proxy.password),
    );
  }

  /// Releases the proxy-related platform resources: clears the override.
  @override
  Future<void> dispose() async {
    await ProxyController.instance().clearProxyOverride();
  }
}
