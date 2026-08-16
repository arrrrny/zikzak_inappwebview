

///Class that represents the content mode to prefer when loading and rendering a webpage.
enum UserPreferredContentMode {
  ///The recommended content mode for the current platform.
  RECOMMENDED,
  ///Represents content targeting mobile browsers.
  MOBILE,
  ///Represents content targeting desktop browsers.
  DESKTOP,
}


UserPreferredContentMode? userPreferredContentModeFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < UserPreferredContentMode.values.length
      ? UserPreferredContentMode.values[value]
      : null;
}

Object? userPreferredContentModeToWire(UserPreferredContentMode? value) => value?.index;
