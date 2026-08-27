///Class used to override the way the cache is used.
enum CacheMode {
  ///Default cache usage mode. If the navigation type doesn't impose any specific behavior,
  ///use cached resources when they are available and not expired, otherwise load resources from the network.
  LOAD_DEFAULT,

  ///Use cached resources when they are available, even if they have expired. Otherwise load resources from the network.
  LOAD_CACHE_ELSE_NETWORK,

  ///Don't use the cache, load from the network.
  LOAD_NO_CACHE,

  ///Don't use the network, load from the cache.
  LOAD_CACHE_ONLY,
}

///cache_mode wire values are NOT sequential (-1, 1, 2, 3) — a plain enum's `.index`
///does not match the old `_value`.

///CacheMode wire values are NOT sequential (-1, 1, 2, 3) — lookup by value.
const _cacheMode_wire = [-1, 1, 2, 3];

CacheMode? cacheModeFromWire(Object? value) {
  if (value is! int) return null;
  final index = _cacheMode_wire.indexOf(value);
  return index >= 0 ? CacheMode.values[index] : null;
}

Object? cacheModeToWire(CacheMode? value) =>
    value == null ? null : _cacheMode_wire[value.index];
