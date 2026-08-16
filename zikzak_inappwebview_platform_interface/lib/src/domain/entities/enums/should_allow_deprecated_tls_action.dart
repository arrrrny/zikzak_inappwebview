

///Class that is used by [PlatformWebViewCreationParams.shouldAllowDeprecatedTLS] event.
///It represents the policy to pass back to the decision handler.
enum ShouldAllowDeprecatedTLSAction {
  ///Cancel the navigation.
  CANCEL,
  ///Allow the navigation to continue.
  ALLOW,
}
