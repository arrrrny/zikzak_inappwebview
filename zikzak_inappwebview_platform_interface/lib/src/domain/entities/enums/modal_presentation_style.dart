

///Class used to specify the modal presentation style when presenting a view controller.
enum ModalPresentationStyle {
  ///A presentation style in which the presented view covers the screen.
  FULL_SCREEN,
  ///A presentation style that partially covers the underlying content.
  PAGE_SHEET,
  ///A presentation style that displays the content centered in the screen.
  FORM_SHEET,
  ///A presentation style where the content is displayed over another view controller’s content.
  CURRENT_CONTEXT,
  ///A custom view presentation style that is managed by a custom presentation controller and one or more custom animator objects.
  CUSTOM,
  ///A view presentation style in which the presented view covers the screen.
  OVER_FULL_SCREEN,
  ///A presentation style where the content is displayed over another view controller’s content.
  OVER_CURRENT_CONTEXT,
  ///A presentation style where the content is displayed in a popover view.
  POPOVER,
  ///A presentation style that indicates no adaptations should be made.
  NONE,
  ///The default presentation style chosen by the system.
  ///
  ///**NOTE**: available on iOS 13.0+.
  AUTOMATIC,
}

///ModalPresentationStyle wire values are sequential 0..n-1 — `.index` matches.
ModalPresentationStyle? modalPresentationStyleFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < ModalPresentationStyle.values.length
      ? ModalPresentationStyle.values[value]
      : null;
}

Object? modalPresentationStyleToWire(ModalPresentationStyle? value) =>
    value?.index;
