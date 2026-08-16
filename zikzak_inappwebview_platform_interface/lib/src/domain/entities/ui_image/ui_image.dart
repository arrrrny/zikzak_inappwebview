import 'package:zorphy_annotation/zorphy_annotation.dart';
import 'dart:typed_data';


part 'ui_image.zorphy.dart';
part 'ui_image.g.dart';

///Class that represents an object that manages iOS and MacOS image data in your app.
///
///Check iOS [UIKit.UIImage](https://developer.apple.com/documentation/uikit/uiimage) for more details.
///Check MacOS [AppKit.NSImage](https://developer.apple.com/documentation/appkit/nsimage) for more details.
///
///**Officially Supported Platforms/Implementations**:
///iOS
///MacOS
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $UIImage {
  ///The name of the image asset or file.
  String? get name;
  ///The name of the system symbol image.
  String? get systemName;
  ///The data object containing the image data.
  @JsonKey(fromJson: _dataFromJson, toJson: _dataToJson)
  Uint8List? get data;
}


Uint8List? _dataFromJson(Object? value) => value == null
    ? null
    : Uint8List.fromList((value as List).cast<int>());

Object? _dataToJson(Uint8List? value) => value?.toList();
