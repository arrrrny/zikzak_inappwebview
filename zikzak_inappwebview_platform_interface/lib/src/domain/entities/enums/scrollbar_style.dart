

///Class used to configure the style of the scrollbars.
///The scrollbars can be overlaid or inset.
///When inset, they add to the padding of the view. And the scrollbars can be drawn inside the padding area or on the edge of the view.
///For example, if a view has a background drawable and you want to draw the scrollbars inside the padding specified by the drawable,
///you can use [ScrollBarStyle.SCROLLBARS_INSIDE_OVERLAY] or [ScrollBarStyle.SCROLLBARS_INSIDE_INSET].
///If you want them to appear at the edge of the view, ignoring the padding,
///then you can use [ScrollBarStyle.SCROLLBARS_OUTSIDE_OVERLAY] or [ScrollBarStyle.SCROLLBARS_OUTSIDE_INSET].
enum ScrollBarStyle {
  ///The scrollbar style to display the scrollbars inside the content area, without increasing the padding.
  ///The scrollbars will be overlaid with translucency on the view's content.
  SCROLLBARS_INSIDE_OVERLAY,
  ///The scrollbar style to display the scrollbars inside the padded area, increasing the padding of the view.
  ///The scrollbars will not overlap the content area of the view.
  SCROLLBARS_INSIDE_INSET,
  ///The scrollbar style to display the scrollbars at the edge of the view, without increasing the padding.
  ///The scrollbars will be overlaid with translucency.
  SCROLLBARS_OUTSIDE_OVERLAY,
  ///The scrollbar style to display the scrollbars at the edge of the view, increasing the padding of the view.
  ///The scrollbars will only overlap the background, if any.
  SCROLLBARS_OUTSIDE_INSET,
}


///ScrollBarStyle wire values are NOT sequential (0, 16777216, 33554432, 50331648) — lookup by value.
const _scrollBarStyle_wire = [0, 16777216, 33554432, 50331648];

ScrollBarStyle? scrollBarStyleFromWire(Object? value) {
  if (value is! int) return null;
  final index = _scrollBarStyle_wire.indexOf(value);
  return index >= 0 ? ScrollBarStyle.values[index] : null;
}

Object? scrollBarStyleToWire(ScrollBarStyle? value) =>
    value == null ? null : _scrollBarStyle_wire[value.index];
