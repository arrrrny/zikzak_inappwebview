import 'package:zorphy_annotation/zorphy_annotation.dart';
import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

import '../ui_image/ui_image.dart';

part 'activity_button.zorphy.dart';
part 'activity_button.g.dart';

///Class that represents a custom button to show in `SFSafariViewController`'s toolbar.
///When tapped, it will invoke a Share or Action Extension bundled with your app.
///The default VoiceOver description of this button is the `CFBundleDisplayName` set in the extension's `Info.plist`.
///
///Check [Official Apple App Extensions](https://developer.apple.com/app-extensions/) for more details.
///
///**Officially Supported Platforms/Implementations**:
///iOS
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $ActivityButton {
  ///The name of the image asset or file.
  @JsonKey(fromJson: _templateImageFromJson, toJson: _templateImageToJson)
  UIImage get templateImage;
  ///The name of the App or Share Extension to be called.
  String get extensionIdentifier;
}


UIImage _templateImageFromJson(Object? value) =>
    UIImage.fromJson((value as Map).cast<String, dynamic>())!;

Object? _templateImageToJson(UIImage value) => value.toJson();
