

///Class that represents the flags that describe the browser window’s current style, such as if it’s resizable or in full-screen mode.
enum WindowStyleMask {
  ///The window displays none of the usual peripheral elements. Useful only for display or caching purposes.
  BORDERLESS,
  ///The window displays a title bar.
  TITLED,
  ///The window displays a close button.
  CLOSABLE,
  ///The window displays a minimize button.
  MINIATURIZABLE,
  ///The window can be resized by the user.
  RESIZABLE,
  ///The window can appear full screen. A fullscreen window does not draw its title bar, and may have special handling for its toolbar.
  FULLSCREEN,
  ///When set, the window’s contentView consumes the full size of the window.
  ///Although you can combine this constant with other window style masks, it is respected only for windows with a title bar.
  ///Note that using this mask opts in to layer-backing.
  FULL_SIZE_CONTENT_VIEW,
  ///The window is a panel.
  UTILITY_WINDOW,
  ///The window is a document-modal panel.
  DOC_MODAL_WINDOW,
  ///The window is a panel that does not activate the owning app.
  NONACTIVATING_PANEL,
  ///The window is a HUD panel.
  HUD_WINDOW,
}


///window_style_mask wire values are NOT sequential (0, 1, 2, 4, 8, 16384, 32768, 16, 64, 128, 8192) — a plain enum's `.index`
///does not match the old `_value`.

///WindowStyleMask wire values differ from `.index` — lookup by value.
const _windowStyleMask_wire = [0, 1, 2, 4, 8, 16384, 32768, 16, 64, 128, 8192];

WindowStyleMask? windowStyleMaskFromWire(Object? value) {
  if (value is! int) return null;
  final index = _windowStyleMask_wire.indexOf(value);
  return index >= 0 ? WindowStyleMask.values[index] : null;
}

Object? windowStyleMaskToWire(WindowStyleMask? value) =>
    value == null ? null : _windowStyleMask_wire[value.index];
