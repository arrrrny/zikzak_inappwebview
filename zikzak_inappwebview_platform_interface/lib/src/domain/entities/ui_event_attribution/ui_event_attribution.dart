import 'package:zorphy_annotation/zorphy_annotation.dart';
import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

import '../../../web_uri.dart';

part 'ui_event_attribution.zorphy.dart';
part 'ui_event_attribution.g.dart';

///Class that represents an object that contains event attribution information for Private Click Measurement.
///
///Apps use event attribution objects to send data to the browser when opening an external website that supports Private Click Measurement (PCM).
///For more information on the proposed PCM web standard, see [Introducing Private Click Measurement](https://webkit.org/blog/11529/introducing-private-click-measurement-pcm/)
///and [Private Click Measurement Draft Community Group Report](https://privacycg.github.io/private-click-measurement/).
///
///Check [UIEventAttribution](https://developer.apple.com/documentation/uikit/uieventattribution) for details.
///
///**Officially Supported Platforms/Implementations**:
///iOS
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $UIEventAttribution {
  ///An 8-bit number that identifies the source of the click for attribution. Value must be between 0 and 255.
  int get sourceIdentifier;
  ///The destination URL of the attribution.
  @JsonKey(fromJson: _destinationURLFromJson, toJson: _destinationURLToJson)
  WebUri get destinationURL;
  ///A description of the source of the attribution.
  String get sourceDescription;
  ///A string that describes the entity that purchased the attributed content.
  String get purchaser;
}


WebUri _destinationURLFromJson(Object? value) => WebUri(value as String);

Object? _destinationURLToJson(WebUri value) => value.toString();
