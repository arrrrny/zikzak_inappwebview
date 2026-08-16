

///Class used to configure the WebView's behavior when a secure origin attempts to load a resource from an insecure origin.
enum MixedContentMode {
  ///In this mode, the WebView will allow a secure origin to load content from any other origin, even if that origin is insecure.
  ///This is the least secure mode of operation for the WebView, and where possible apps should not set this mode.
  MIXED_CONTENT_ALWAYS_ALLOW,
  ///In this mode, the WebView will not allow a secure origin to load content from an insecure origin.
  ///This is the preferred and most secure mode of operation for the WebView and apps are strongly advised to use this mode.
  MIXED_CONTENT_NEVER_ALLOW,
  ///In this mode, the WebView will attempt to be compatible with the approach of a modern web browser with regard to mixed content.
  ///Some insecure content may be allowed to be loaded by a secure origin and other types of content will be blocked.
  ///The types of content are allowed or blocked may change release to release and are not explicitly defined.
  ///This mode is intended to be used by apps that are not in control of the content that they render but desire to operate in a reasonably secure environment.
  ///For highest security, apps are recommended to use [MixedContentMode.MIXED_CONTENT_NEVER_ALLOW].
  MIXED_CONTENT_COMPATIBILITY_MODE,
}


MixedContentMode? mixedContentModeFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < MixedContentMode.values.length
      ? MixedContentMode.values[value]
      : null;
}

Object? mixedContentModeToWire(MixedContentMode? value) => value?.index;
