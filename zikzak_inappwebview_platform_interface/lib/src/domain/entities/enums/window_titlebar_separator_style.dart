///Class that represents the type of separator that the app displays between the title bar and content of a browser window.
enum WindowTitlebarSeparatorStyle {
  ///A style indicating that the system determines the type of separator.
  AUTOMATIC,

  ///A style indicating that the title bar separator is a line.
  NONE,

  ///A style indicating that there’s no title bar separator.
  LINE,

  ///A style indicating that the title bar separator is a shadow.
  SHADOW,
}

///WindowTitlebarSeparatorStyle wire values are sequential 0..n-1 — `.index` matches.
WindowTitlebarSeparatorStyle? windowTitlebarSeparatorStyleFromWire(
  Object? value,
) {
  if (value is! int) return null;
  return value >= 0 && value < WindowTitlebarSeparatorStyle.values.length
      ? WindowTitlebarSeparatorStyle.values[value]
      : null;
}

Object? windowTitlebarSeparatorStyleToWire(
  WindowTitlebarSeparatorStyle? value,
) => value?.index;
