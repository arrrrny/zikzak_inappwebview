///Class that represents the constants that specify how a request uses network resources.
enum URLRequestNetworkServiceType {
  ///A service type for standard network traffic.
  DEFAULT,

  ///A service type for video traffic.
  VIDEO,

  ///A service type for background traffic.
  ///
  ///You should specify this type if your app is performing a download that was not requested by the user—for example,
  ///prefetching content so that it will be available when the user chooses to view it.
  BACKGROUND,

  ///A service type for voice traffic.
  VOICE,

  ///A service type for data that the user is actively waiting for.
  ///
  ///Use this service type for interactive situations where the user is anticipating a quick response, like instant messaging or completing a purchase.
  RESPONSIVE_DATA,

  ///A service type for streaming audio/video data.
  AV_STREAMING,

  ///A service type for responsive (time-sensitive) audio/video data.
  RESPONSIVE_AV,

  ///A service type for call signaling.
  ///
  ///Use this service type with network traffic that establishes, maintains, or tears down a VoIP call.
  CALL_SIGNALING,
}
