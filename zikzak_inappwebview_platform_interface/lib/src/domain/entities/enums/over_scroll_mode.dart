

///Class used to configure the `WebView`'s over-scroll mode.
///Setting the over-scroll mode of a WebView will have an effect only if the `WebView` is capable of scrolling.
enum OverScrollMode {
  ///Always allow a user to over-scroll this view, provided it is a view that can scroll.
  ALWAYS,
  ///Allow a user to over-scroll this view only if the content is large enough to meaningfully scroll, provided it is a view that can scroll.
  IF_CONTENT_SCROLLS,
  ///Never allow a user to over-scroll this view.
  NEVER,
}


OverScrollMode? overScrollModeFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < OverScrollMode.values.length
      ? OverScrollMode.values[value]
      : null;
}

Object? overScrollModeToWire(OverScrollMode? value) => value?.index;
