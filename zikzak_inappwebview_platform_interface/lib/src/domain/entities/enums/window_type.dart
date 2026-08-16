

///Class that represents how a browser window should be added to the main window.
enum WindowType {
  ///Adds the new browser window as a separate new window from the main window.
  WINDOW,
  ///Adds the new browser window as a child window of the main window.
  CHILD,
  ///Adds the new browser window as a new tab in a tabbed window of the main window.
  TABBED,
}

///WindowType wire values are strings equal to the member names.
WindowType? windowTypeFromWire(Object? value) {
  if (value is! String) return null;
  return WindowType.values.firstWhere(
    (e) => e.name == value,
    orElse: () => WindowType.WINDOW,
  );
}

Object? windowTypeToWire(WindowType? value) => value?.name;
