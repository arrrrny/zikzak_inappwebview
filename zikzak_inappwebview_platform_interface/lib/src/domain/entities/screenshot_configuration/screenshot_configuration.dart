import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../in_app_webview_rect/in_app_webview_rect.dart';
import '../enums/compress_format.dart';

part 'screenshot_configuration.zorphy.dart';
part 'screenshot_configuration.g.dart';

///Class that represents the configuration data to use when generating an image from a web view’s contents using [PlatformInAppWebViewController.takeScreenshot].
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $ScreenshotConfiguration {
  ///The portion of your web view to capture, specified as a rectangle in the view’s coordinate system.
  ///The default value of this property is `null`, which captures everything in the view’s bounds rectangle.
  ///If you specify a custom rectangle, it must lie within the bounds rectangle of the `WebView` object.
  InAppWebViewRect? get rect;

  ///The width of the captured image, in points.
  ///Use this property to scale the generated image to the specified width.
  ///The web view maintains the aspect ratio of the captured content, but scales it to match the width you specify.
  ///
  ///The default value of this property is `null`, which returns an image whose size matches the original size of the captured rectangle.
  double? get snapshotWidth;

  ///The compression format of the captured image.
  ///The default value is [CompressFormat.PNG].
  @JsonKey(defaultValue: CompressFormat.PNG)
  CompressFormat get compressFormat;

  ///Hint to the compressor, `0-100`. The value is interpreted differently depending on the [CompressFormat].
  ///[CompressFormat.PNG] is lossless, so this value is ignored.
  @JsonKey(defaultValue: 100)
  int get quality;

  ///A Boolean value that indicates whether to take the snapshot after incorporating any pending screen updates.
  ///The default value of this property is `true`, which causes the web view to incorporate any recent changes to the view’s content and then generate the snapshot.
  ///If you change the value to `false`, the `WebView` takes the snapshot immediately, and before incorporating any new changes.
  @JsonKey(defaultValue: true)
  bool get afterScreenUpdates;
}
