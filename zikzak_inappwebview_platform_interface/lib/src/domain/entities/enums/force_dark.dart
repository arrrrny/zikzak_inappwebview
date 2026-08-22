///Class used to indicate the force dark mode.
enum ForceDark {
  ///Disable force dark, irrespective of the force dark mode of the WebView parent.
  ///In this mode, WebView content will always be rendered as-is, regardless of whether native views are being automatically darkened.
  OFF,

  ///Enable force dark dependent on the state of the WebView parent view.
  AUTO,

  ///Unconditionally enable force dark. In this mode WebView content will always be rendered so as to emulate a dark theme.
  ON,
}

ForceDark? forceDarkFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < ForceDark.values.length
      ? ForceDark.values[value]
      : null;
}

Object? forceDarkToWire(ForceDark? value) => value?.index;
