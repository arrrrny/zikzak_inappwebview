import 'package:flutter/rendering.dart';
import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

import '../print_job/main.dart';
import '../util.dart';
import '../web_uri.dart';
import 'in_app_webview_rect.dart';
import 'print_job_color_mode.dart';
import 'print_job_duplex_mode.dart';
import 'print_job_orientation.dart';
import 'print_job_media_size.dart';
import 'print_job_resolution.dart';
import 'print_job_pagination_mode.dart';
import 'print_job_disposition.dart';

part 'print_job_attributes.g.dart';

///Class representing the attributes of a [PlatformPrintJobController].
///These attributes describe how the printed content should be laid out.
@ExchangeableObject()
class PrintJobAttributes_ {
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

  ///The orientation of the printed content, portrait or landscape.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- MacOS
  PrintJobOrientation? orientation;

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

  ///The margins for the printed content.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  ///- MacOS
  EdgeInsets? margins;

  ///The height of the page footer.
  ///
  ///The footer is measured in points from the bottom of [printableRect] and is below the content area.
  ///The default footer height is `0.0`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  double? footerHeight;

  ///The height of the page header.
  ///
  ///The header is measured in points from the top of [printableRect] and is above the content area.
  ///The default header height is `0.0`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  double? headerHeight;

  ///The kind of paper used for the print job.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  String? paperName;

  ///The name of the currently selected paper size, suitable for presenting in a user interface.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  String? localizedPaperName;

  ///The area in which printing can occur.
  ///
  ///The value of this property is a rectangle that defines the area in which the printer can print content.
  ///Sometimes this area is smaller than the [paperRect].
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  InAppWebViewRect? printableRect;

  ///The size and position of the paper.
  ///
  ///The value of this property is a rectangle that defines the size and position of the paper.
  ///The origin is (0,0).
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  InAppWebViewRect? paperRect;

  ///If `true`, produce detailed reports when an error occurs.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? detailedErrorReporting;

  ///A fax number.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  String? faxNumber;

  ///If `true`, a standard header and footer are added outside the margins of each page.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  bool? headerAndFooter;

  ///The horizontal pagination mode.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  PrintJobPaginationMode? horizontalPagination;

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

  ///The action specified for the job.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  PrintJobDisposition? jobDisposition;

  ///An URL containing the location to which the job file will be saved when the [jobDisposition] is [PrintJobDisposition.SAVE].
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  WebUri? jobSavingURL;

  ///The vertical pagination mode.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- MacOS
  PrintJobPaginationMode? verticalPagination;

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
}
