///Class that represents the type of action triggering a navigation for the [PlatformWebViewCreationParams.shouldOverrideUrlLoading] event.
enum NavigationType {
  ///A link with an href attribute was activated by the user.
  LINK_ACTIVATED,

  ///A form was submitted.
  FORM_SUBMITTED,

  ///An item from the back-forward list was requested.
  BACK_FORWARD,

  ///The webpage was reloaded.
  RELOAD,

  ///A form was resubmitted (for example by going back, going forward, or reloading).
  FORM_RESUBMITTED,

  ///Navigation is taking place for some other reason.
  OTHER,
}
