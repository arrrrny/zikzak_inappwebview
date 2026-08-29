import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../../../util.dart';
import '../enums/print_job_orientation.dart';
import '../in_app_webview_rect/in_app_webview_rect.dart';

part 'pdf_configuration.zorphy.dart';
part 'pdf_configuration.g.dart';

///Class that represents the configuration data to use when generating a PDF representation of a web view’s contents.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $PDFConfiguration {
  ///The portion of your web view to capture, specified as a rectangle in the view’s coordinate system.
  ///The default value of this property is `null`, which captures everything in the view’s bounds rectangle.
  ///If you specify a custom rectangle, it must lie within the bounds rectangle of the `WebView` object.
  @JsonKey(fromJson: _rectFromJson, toJson: _rectToJson)
  InAppWebViewRect? get rect;

  ///The size of each PDF page, in points (1 point = 1/72 inch).
  ///When set, the generated PDF uses this page size and paginates the web
  ///content across pages. When `null`, the platform uses its default page size.
  @JsonKey(fromJson: _pageSizeFromJson, toJson: _pageSizeToJson)
  Size? get pageSize;

  ///The margins to apply around the content on each page, in points.
  @JsonKey(fromJson: _marginsFromJson, toJson: _marginsToJson)
  EdgeInsets? get margins;

  ///The orientation of the generated PDF pages.
  @JsonKey(fromJson: _orientationFromJson, toJson: _orientationToJson)
  PrintJobOrientation? get orientation;
}

InAppWebViewRect? _rectFromJson(Object? value) => value == null
    ? null
    : InAppWebViewRect.fromJson((value as Map).cast<String, dynamic>());

Object? _rectToJson(InAppWebViewRect? value) => value?.toJson();

Size? _pageSizeFromJson(Object? value) {
  if (value == null) return null;
  final map = (value as Map).cast<String, dynamic>();
  final width = (map['width'] as num?)?.toDouble();
  final height = (map['height'] as num?)?.toDouble();
  if (width == null || height == null) return null;
  return Size(width, height);
}

Object? _pageSizeToJson(Size? value) =>
    value == null ? null : {'width': value.width, 'height': value.height};

EdgeInsets? _marginsFromJson(Object? value) => value == null
    ? null
    : MapEdgeInsets.fromMap((value as Map).cast<String, dynamic>());

Object? _marginsToJson(EdgeInsets? margins) => margins?.toMap();

PrintJobOrientation? _orientationFromJson(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < PrintJobOrientation.values.length
      ? PrintJobOrientation.values[value]
      : null;
}

Object? _orientationToJson(PrintJobOrientation? orientation) =>
    orientation?.index;
