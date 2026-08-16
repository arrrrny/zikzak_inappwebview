import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../../../web_uri.dart';

part 'loaded_resource.zorphy.dart';
part 'loaded_resource.g.dart';

///Class representing a resource response of the `WebView`.
///It is used by the method [PlatformWebViewCreationParams.onLoadResource].
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $LoadedResource {
  ///A string representing the type of resource.
  String? get initiatorType;
  ///Resource URL.
  @JsonKey(fromJson: _urlFromJson, toJson: _urlToJson)
  WebUri? get url;
  ///Returns the [DOMHighResTimeStamp](https://developer.mozilla.org/en-US/docs/Web/API/DOMHighResTimeStamp) for the time a resource fetch started.
  double? get startTime;
  ///Returns the [DOMHighResTimeStamp](https://developer.mozilla.org/en-US/docs/Web/API/DOMHighResTimeStamp) duration to fetch a resource.
  double? get duration;
}
WebUri? _urlFromJson(Object? value) =>
    value == null ? null : WebUri(value as String);

Object? _urlToJson(WebUri? value) => value?.toString();
