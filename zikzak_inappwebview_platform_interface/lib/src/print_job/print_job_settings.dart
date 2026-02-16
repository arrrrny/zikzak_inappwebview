import 'package:flutter/cupertino.dart';
import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

import '../types/main.dart';
import '../types/print_job_color_mode.dart';
import '../types/print_job_disposition.dart';
import '../types/print_job_duplex_mode.dart';
import '../types/print_job_media_size.dart';
import '../types/print_job_orientation.dart';
import '../types/print_job_output_type.dart';
import '../types/print_job_page_order.dart';
import '../types/print_job_pagination_mode.dart';
import '../types/print_job_rendering_quality.dart';
import '../types/print_job_resolution.dart';
import '../util.dart';
import '../web_uri.dart';
import 'platform_print_job_controller.dart';

part 'print_job_settings.g.dart';

///Class that represents the settings of a [PlatformPrintJobController].
@ExchangeableObject()
class PrintJobSettings_ {
  ///Set this to `true` to handle the [PlatformPrintJobController].
  ///Otherwise, it will be handled and disposed automatically by the system.
  ///The default value is `false`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  bool? handledByClient;

  ///The name of the print job.
  ///An application should set this property to a name appropriate to the content being printed.
  ///The default job name is the current webpage title concatenated with the "Document" word at the end.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  String? jobName;

  ///If `true`, produce detailed reports when an error occurs.
  ///The default value is `false`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? detailedErrorReporting;

  ///A Boolean value that determines whether the print operation displays a print panel.
  ///The default value is `true`.
  ///
  ///This property does not affect the display of a progress panel;
  ///that operation is controlled by the [showsProgressPanel] property.
  ///Operations that generate EPS or PDF data do no display a progress panel, regardless of the value in the flag parameter.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? showsPrintPanel;

  ///A Boolean value that determines whether the print operation displays a progress panel.
  ///The default value is `true`.
  ///
  ///This property does not affect the display of a print panel;
  ///that operation is controlled by the [showsPrintPanel] property.
  ///Operations that generate EPS or PDF data do no display a progress panel, regardless of the value in the flag parameter.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? showsProgressPanel;

  ///An URL containing the location to which the job file will be saved when the [jobDisposition] is [PrintJobDisposition.SAVE].
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  WebUri? jobSavingURL;

  ///The action specified for the job.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  PrintJobDisposition? jobDisposition;

  ///The kind of paper used for the print job.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  String? paperName;

  ///The horizontal pagination mode.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  PrintJobPaginationMode? horizontalPagination;

  ///The vertical pagination to the specified mode.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  PrintJobPaginationMode? verticalPagination;

  ///Indicates whether the image is centered horizontally.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? isHorizontallyCentered;

  ///Indicates whether the image is centered vertically.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? isVerticallyCentered;

  ///The maximum height of the content.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  double? maximumContentHeight;

  ///The maximum width of the content.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  double? maximumContentWidth;

  ///The margins for the printed content.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  EdgeInsets? margins;

  ///An integer value that specifies the first page in the print job.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  int? firstPage;

  ///An integer value that specifies the last page in the print job.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  int? lastPage;

  ///If `true`, a standard header and footer are added outside the margins of each page.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? headerAndFooter;

  ///The height of the page header.
  ///
  ///The header is measured in points from the top of [printableRect] and is above the content area.
  ///The default header height is `0.0`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  double? headerHeight;

  ///The height of the page footer.
  ///
  ///The footer is measured in points from the bottom of [printableRect] and is below the content area.
  ///The default footer height is `0.0`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  double? footerHeight;

  ///A timestamp that specifies the time at which printing should begin.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  int? time;

  ///The orientation of the printed content, portrait or landscape.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- MacOS
  PrintJobOrientation? orientation;

  ///The color mode.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- MacOS
  PrintJobColorMode? colorMode;

  ///The duplex mode to use for the print job.
  ///
  ///**NOTE for Android native WebView**: available only on Android 23+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  PrintJobDuplexMode? duplexMode;

  ///The media size.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- MacOS
  PrintJobMediaSize? mediaSize;

  ///The supported resolution in DPI (dots per inch).
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- MacOS
  PrintJobResolution? resolution;

  ///A fax number.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  String? faxNumber;

  ///How many copies to print.
  ///The default value is `1`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  int? copies;

  ///The number of pages to print.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  int? numberOfPages;

  ///Specifies whether the results of a print operation should be collated.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? mustCollate;

  ///The name of the currently selected paper size, suitable for presenting in a user interface.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  String? pagesAcross;

  ///The name of the currently selected paper size, suitable for presenting in a user interface.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  String? pagesDown;

  ///A Boolean value that determines whether the Print panel displays a built-in preview of the document contents.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? showsPreview;

  ///A Boolean value that determines whether the Print panel includes an additional selection option for paper range.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? showsPrintSelection;

  ///A Boolean value that determines whether the Print panel includes a set of fields for manipulating the range of pages being printed.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? showsPageRange;

  ///A Boolean value that determines whether the printing settings include the number of copies.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  ///- MacOS
  bool? showsNumberOfCopies;

  ///A Boolean value that determines whether the printing settings include the paper orientation control when available.
  ///The default value is `true`.
  ///
  ///**NOTE for iOS**: available only on iOS 15.0+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  ///- MacOS
  bool? showsPaperOrientation;

  ///A Boolean value that determines whether the paper selection menu displays.
  ///The default value of this property is `false`.
  ///Setting the value to `true` enables a paper selection menu on printers that support different types of paper and have more than one paper type loaded.
  ///On printers where only one paper type is available, no paper selection menu is displayed, regardless of the value of this property.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  bool? showsPaperSelectionForLoadedPapers;

  ///A Boolean value that determines whether the print panel includes a control for manipulating the paper size of the printer.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? showsPaperSize;

  ///A Boolean value that determines whether the Print panel includes a control for scaling the printed output.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? showsScaling;

  ///A Boolean value that determines whether the Print panel includes a separate accessory view for manipulating the paper size, orientation, and scaling attributes.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? showsPageSetupAccessory;

  ///The current scaling factor. From `0.0` to `1.0`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  double? scalingFactor;

  ///Force rendering quality.
  ///
  ///**NOTE for iOS**: available only on iOS 14.5+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  PrintJobRenderingQuality? forceRenderingQuality;

  ///`true` to animate the display of the sheet, `false` to display the sheet immediately.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  bool? animated;

  ///Whether the print operation should spawn a separate thread in which to run itself.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? canSpawnSeparateThread;

  ///The type of content.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  PrintJobOutputType? outputType;

  ///The page order.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  PrintJobPageOrder? pageOrder;
}
