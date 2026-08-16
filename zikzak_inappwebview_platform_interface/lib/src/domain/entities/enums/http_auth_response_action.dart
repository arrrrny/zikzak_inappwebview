


///Class used by [HttpAuthResponse] class.
enum HttpAuthResponseAction {
  ///Instructs the WebView to cancel the authentication request.
  CANCEL,
  ///Instructs the WebView to proceed with the authentication with the given credentials.
  PROCEED,
  ///Uses the credentials stored for the current host.
  USE_SAVED_HTTP_AUTH_CREDENTIALS,
}
