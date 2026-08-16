///Class that represents the action to take used by the [PlatformWebViewCreationParams.onRenderProcessUnresponsive] and [PlatformWebViewCreationParams.onRenderProcessResponsive] event
///to terminate the Android [WebViewRenderProcess](https://developer.android.com/reference/android/webkit/WebViewRenderProcess).
enum WebViewRenderProcessAction {
  ///Cause this renderer to terminate.
  TERMINATE,
}

///WebViewRenderProcessAction wire values are sequential 0..n-1 — `.index` matches.
WebViewRenderProcessAction? webViewRenderProcessActionFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < WebViewRenderProcessAction.values.length
      ? WebViewRenderProcessAction.values[value]
      : null;
}

Object? webViewRenderProcessActionToWire(WebViewRenderProcessAction? value) =>
    value?.index;
