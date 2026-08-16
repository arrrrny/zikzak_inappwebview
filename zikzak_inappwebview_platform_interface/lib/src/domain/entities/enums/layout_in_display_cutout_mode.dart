

///Class representing the share state that should be applied to the custom tab.
enum LayoutInDisplayCutoutMode {
  ///With this default setting, content renders into the cutout area when displayed in portrait mode, but content is letterboxed when displayed in landscape mode.
  ///
  ///**NOTE**: available on Android 28+.
  DEFAULT,
  ///Content renders into the cutout area in both portrait and landscape modes.
  ///
  ///**NOTE**: available on Android 28+.
  SHORT_EDGES,
  ///Content never renders into the cutout area.
  ///
  ///**NOTE**: available on Android 28+.
  NEVER,
  ///The window is always allowed to extend into the DisplayCutout areas on the all edges of the screen.
  ///
  ///**NOTE**: available on Android 30+.
  ALWAYS,
}
