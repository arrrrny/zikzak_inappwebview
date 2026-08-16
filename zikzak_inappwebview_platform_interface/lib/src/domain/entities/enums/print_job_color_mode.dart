


///Class representing how the printed content of a [PlatformPrintJobController] should be laid out.
enum PrintJobColorMode {
  ///Monochrome color scheme, for example one color is used.
  MONOCHROME,
  ///Color color scheme, for example many colors are used.
  COLOR,
}

///PrintJobColorMode wire values are 1-based (MONOCHROME=1, COLOR=2) — a
///plain enum's `.index` is offset by one.
PrintJobColorMode? printJobColorModeFromWire(int? value) =>
    value != null && value >= 1 && value <= PrintJobColorMode.values.length
        ? PrintJobColorMode.values[value - 1]
        : null;

int? printJobColorModeToWire(PrintJobColorMode? mode) =>
    mode == null ? null : mode.index + 1;
