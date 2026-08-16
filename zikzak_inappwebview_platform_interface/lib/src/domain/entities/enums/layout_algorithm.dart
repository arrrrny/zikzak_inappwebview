///Class used to set the underlying layout algorithm.
enum LayoutAlgorithm {
  ///NORMAL means no rendering changes. This is the recommended choice for maximum compatibility across different platforms and Android versions.
  NORMAL,

  ///TEXT_AUTOSIZING boosts font size of paragraphs based on heuristics to make the text readable when viewing a wide-viewport layout in the overview mode.
  ///It is recommended to enable zoom support [InAppWebViewSettings.supportZoom] when using this mode.
  ///
  ///**NOTE**: available on Android 19+.
  TEXT_AUTOSIZING,

  ///NARROW_COLUMNS makes all columns no wider than the screen if possible. Only use this for API levels prior to `Build.VERSION_CODES.KITKAT`.
  NARROW_COLUMNS,
}

LayoutAlgorithm? layoutAlgorithmFromWire(Object? value) => value is String
    ? LayoutAlgorithm.values.firstWhere(
        (e) => e.name == value,
        orElse: () => LayoutAlgorithm.values.first,
      )
    : null;

String? layoutAlgorithmToWire(LayoutAlgorithm? value) => value?.name;
