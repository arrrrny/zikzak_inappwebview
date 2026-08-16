

///Class used to specify the transition style when presenting a view controller.
enum ModalTransitionStyle {
  ///When the view controller is presented, its view slides up from the bottom of the screen.
  ///On dismissal, the view slides back down. This is the default transition style.
  COVER_VERTICAL,
  ///When the view controller is presented, the current view initiates a horizontal 3D flip from right-to-left,
  ///resulting in the revealing of the new view as if it were on the back of the previous view.
  ///On dismissal, the flip occurs from left-to-right, returning to the original view.
  FLIP_HORIZONTAL,
  ///When the view controller is presented, the current view fades out while the new view fades in at the same time.
  ///On dismissal, a similar type of cross-fade is used to return to the original view.
  CROSS_DISSOLVE,
  ///When the view controller is presented, one corner of the current view curls up to reveal the presented view underneath.
  ///On dismissal, the curled up page unfurls itself back on top of the presented view.
  ///A view controller presented using this transition is itself prevented from presenting any additional view controllers.
  PARTIAL_CURL,
}

///ModalTransitionStyle wire values are sequential 0..n-1 — `.index` matches.
ModalTransitionStyle? modalTransitionStyleFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < ModalTransitionStyle.values.length
      ? ModalTransitionStyle.values[value]
      : null;
}

Object? modalTransitionStyleToWire(ModalTransitionStyle? value) =>
    value?.index;
