///Class that describes the Web Authentication support level for a WebView instance.
enum WebAuthenticationSupport {
  ///Disable Web Authentication support in WebView.
  NONE,

  ///Enable Web Authentication support for the embedding app (for example, passkeys).
  FOR_APP,

  ///Enable Web Authentication support for browser delegations.
  FOR_BROWSER,
}
