

///Class used to specify a `dataDetectoryTypes` value that adds interactivity to web content that matches the value.
enum DataDetectorTypes {
  ///No detection is performed.
  NONE,
  ///Phone numbers are detected and turned into links.
  PHONE_NUMBER,
  ///URLs in text are detected and turned into links.
  LINK,
  ///Addresses are detected and turned into links.
  ADDRESS,
  ///Dates and times that are in the future are detected and turned into links.
  CALENDAR_EVENT,
  ///Tracking numbers are detected and turned into links.
  TRACKING_NUMBER,
  ///Flight numbers are detected and turned into links.
  FLIGHT_NUMBER,
  ///Lookup suggestions are detected and turned into links.
  LOOKUP_SUGGESTION,
  ///Spotlight suggestions are detected and turned into links.
  SPOTLIGHT_SUGGESTION,
  ///All of the above data types are turned into links when detected. Choosing this value will automatically include any new detection type that is added.
  ALL,
}


DataDetectorTypes? dataDetectorTypesFromWire(Object? value) =>
    value is String ? DataDetectorTypes.values.firstWhere((e) => e.name == value, orElse: () => DataDetectorTypes.values.first) : null;

String? dataDetectorTypesToWire(DataDetectorTypes? value) => value?.name;
