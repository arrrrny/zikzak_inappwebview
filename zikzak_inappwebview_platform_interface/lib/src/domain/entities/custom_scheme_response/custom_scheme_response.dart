import 'package:zorphy_annotation/zorphy_annotation.dart';
import 'dart:typed_data';


part 'custom_scheme_response.zorphy.dart';
part 'custom_scheme_response.g.dart';

///Class representing the response returned by the [PlatformWebViewCreationParams.onLoadResourceWithCustomScheme] event.
///It allows to load a specific resource. The resource data must be encoded to `base64`.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $CustomSchemeResponse {
  ///Data enconded to 'base64'.
  @JsonKey(fromJson: _dataFromJson, toJson: _dataToJson)
  Uint8List get data;
  ///Content-Type of the data, such as `image/png`.
  String get contentType;
  ///Content-Encoding of the data, such as `utf-8`.
  @JsonKey(defaultValue: 'utf-8')
  String get contentEncoding;
}
Uint8List _dataFromJson(Object? value) {
  if (value is Uint8List) return value;
  if (value is List) {
    return Uint8List.fromList(value.cast<int>());
  }
  throw ArgumentError('expected a Uint8List or List<int>');
}

Object? _dataToJson(Uint8List? value) => value;
