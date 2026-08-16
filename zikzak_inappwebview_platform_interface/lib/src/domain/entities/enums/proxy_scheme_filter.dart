


///Class that represent scheme filters used by [PlatformProxyController].
enum ProxySchemeFilter {
  ///Matches all schemes.
  MATCH_ALL_SCHEMES,
  ///HTTP scheme.
  MATCH_HTTP,
  ///HTTPS scheme.
  MATCH_HTTPS,
}

///ProxySchemeFilter wire values are strings — lookup by value.
const _proxySchemeFilter_wire = ['http', 'https', 'ws', 'wss'];

ProxySchemeFilter? proxySchemeFilterFromWire(Object? value) {
  if (value is! String) return null;
  final index = _proxySchemeFilter_wire.indexOf(value);
  return index >= 0 ? ProxySchemeFilter.values[index] : null;
}

Object? proxySchemeFilterToWire(ProxySchemeFilter? value) =>
    value == null ? null : _proxySchemeFilter_wire[value.index];
