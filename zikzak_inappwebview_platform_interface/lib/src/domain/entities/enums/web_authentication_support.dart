///Class that describes the Web Authentication support level for a WebView instance.
enum WebAuthenticationSupport {
  ///Disable Web Authentication support in WebView.
  NONE,

  ///Enable Web Authentication support for the embedding app (for example, passkeys).
  FOR_APP,

  ///Enable Web Authentication support for browser delegations.
  FOR_BROWSER,
}

WebAuthenticationSupport? webAuthenticationSupportFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < WebAuthenticationSupport.values.length
      ? WebAuthenticationSupport.values[value]
      : null;
}

Object? webAuthenticationSupportToWire(WebAuthenticationSupport? value) =>
    value?.index;
