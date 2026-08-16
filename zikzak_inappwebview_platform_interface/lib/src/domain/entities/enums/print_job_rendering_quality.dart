


///Class representing the rendering quality of a [PlatformPrintJobController].
enum PrintJobRenderingQuality {
  ///Renders the printing at the best possible quality, regardless of speed.
  BEST,
  ///Sacrifices the least possible amount of rendering quality for speed to maintain a responsive user interface.
  ///This option should be used only after establishing that best quality rendering does indeed make the user interface unresponsive.
  RESPONSIVE,
}
