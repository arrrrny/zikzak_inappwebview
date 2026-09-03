import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

import 'proxy_config.dart';

/// Builds the zikzak_inappwebview [ProxySettings] for a [ProxyConfig]
/// (spec 279, FR-012).
///
/// Pure mapping — no platform channels — so it is unit-testable:
/// - Android: one [ProxyRule] whose URL carries scheme (and credentials);
///   [ProxySchemeFilter.MATCH_HTTP]/[ProxySchemeFilter.MATCH_HTTPS] for
///   http/https; no scheme filter for socks5 (the enum has no SOCKS entry —
///   the scheme is carried by the rule URL).
/// - iOS: [IOSProxySettings.proxyUrl] with the same URL.
ProxySettings proxySettingsFromConfig(
  ProxyConfig config, {
  String? password,
}) {
  final effectivePassword = password ?? config.password;
  final url = config.toProxyUrl(password: effectivePassword);
  final ProxySchemeFilter? schemeFilter = switch (config.type) {
    ProxyType.http => ProxySchemeFilter.MATCH_HTTP,
    ProxyType.https => ProxySchemeFilter.MATCH_HTTPS,
    ProxyType.socks5 => null,
  };
  return ProxySettings(
    androidProxySettings: AndroidProxySettings(
      proxyRules: [ProxyRule(url: WebUri(url), schemeFilter: schemeFilter)],
    ),
    iOSProxySettings: IOSProxySettings(proxyUrl: url),
  );
}
