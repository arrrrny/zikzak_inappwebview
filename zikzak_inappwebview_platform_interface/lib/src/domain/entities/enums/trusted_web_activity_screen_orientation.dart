

///Class representing Screen Orientation Lock type value of a Trusted Web Activity:
///https://www.w3.org/TR/screen-orientation/#screenorientation-interface
enum TrustedWebActivityScreenOrientation {
  /// The default screen orientation is the set of orientations to which the screen is locked when
  /// there is no current orientation lock.
  DEFAULT,
  ///  Portrait-primary is an orientation where the screen width is less than or equal to the
  ///  screen height. If the device's natural orientation is portrait, then it is in
  ///  portrait-primary when held in that position.
  PORTRAIT_PRIMARY,
  /// Portrait-secondary is an orientation where the screen width is less than or equal to the
  /// screen height. If the device's natural orientation is portrait, then it is in
  /// portrait-secondary when rotated 180° from its natural position.
  PORTRAIT_SECONDARY,
  /// Landscape-primary is an orientation where the screen width is greater than the screen height.
  /// If the device's natural orientation is landscape, then it is in landscape-primary when held
  /// in that position.
  LANDSCAPE_PRIMARY,
  /// Landscape-secondary is an orientation where the screen width is greater than the
  /// screen height. If the device's natural orientation is landscape, it is in
  /// landscape-secondary when rotated 180° from its natural orientation.
  LANDSCAPE_SECONDARY,
  /// Any is an orientation that means the screen can be locked to any one of portrait-primary,
  /// portrait-secondary, landscape-primary and landscape-secondary.
  ANY,
  /// Landscape is an orientation where the screen width is greater than the screen height and
  /// depending on platform convention locking the screen to landscape can represent
  /// landscape-primary, landscape-secondary or both.
  LANDSCAPE,
  /// Portrait is an orientation where the screen width is less than or equal to the screen height
  /// and depending on platform convention locking the screen to portrait can represent
  /// portrait-primary, portrait-secondary or both.
  PORTRAIT,
  /// Natural is an orientation that refers to either portrait-primary or landscape-primary
  /// depending on the device's usual orientation. This orientation is usually provided by
  /// the underlying operating system.
  NATURAL,
}
