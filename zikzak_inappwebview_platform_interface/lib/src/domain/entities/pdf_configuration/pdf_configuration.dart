import 'package:zorphy_annotation/zorphy_annotation.dart';

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
}

InAppWebViewRect? _rectFromJson(Object? value) => value == null
    ? null
    : InAppWebViewRect.fromJson((value as Map).cast<String, dynamic>());

Object? _rectToJson(InAppWebViewRect? value) => value?.toJson();
