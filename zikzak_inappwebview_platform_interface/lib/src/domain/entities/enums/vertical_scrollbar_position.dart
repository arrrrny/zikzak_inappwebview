///Class used to configure the position of the vertical scroll bar.
enum VerticalScrollbarPosition {
  ///Position the scroll bar at the default position as determined by the system.
  SCROLLBAR_POSITION_DEFAULT,

  ///Position the scroll bar along the left edge.
  SCROLLBAR_POSITION_LEFT,

  ///Position the scroll bar along the right edge.
  SCROLLBAR_POSITION_RIGHT,
}

VerticalScrollbarPosition? verticalScrollbarPositionFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < VerticalScrollbarPosition.values.length
      ? VerticalScrollbarPosition.values[value]
      : null;
}

Object? verticalScrollbarPositionToWire(VerticalScrollbarPosition? value) =>
    value?.index;
