///Class that represents the constants used to indicate the entities that can make a network request.
enum URLRequestAttribution {
  ///A developer-initiated network request.
  ///
  ///Use this value for the attribution parameter of a [URLRequest] that your app makes for any purpose other than when the user explicitly accesses a link.
  ///This includes requests that your app makes to get user data. This is the default value.
  ///
  ///For cases where the user enters a URL, like in the navigation bar of a web browser, or taps or clicks a URL to load the content it represents, use the [URLRequestAttribution.USER] value instead.
  DEVELOPER,

  ///Use this value for the attribution parameter of a [URLRequest] that satisfies a user request to access an explicit, unmodified URL.
  ///In all other cases, use the [URLRequestAttribution.DEVELOPER] value instead.
  USER,
}
