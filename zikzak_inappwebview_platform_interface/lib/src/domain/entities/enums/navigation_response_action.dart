///Class that is used by [PlatformWebViewCreationParams.onNavigationResponse] event.
///It represents the policy to pass back to the decision handler.
enum NavigationResponseAction {
  ///Cancel the navigation.
  CANCEL,

  ///Allow the navigation to continue.
  ALLOW,

  ///Turn the navigation into a download.
  ///
  ///**NOTE**: available only on iOS 14.5+. It will fallback to [CANCEL].
  DOWNLOAD,
}
