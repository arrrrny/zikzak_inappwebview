import 'package:zorphy_annotation/zorphy_annotation.dart';


part 'prewarming_token.zorphy.dart';
part 'prewarming_token.g.dart';

///Class that represents the Prewarming Token returned by [PlatformChromeSafariBrowser.prewarmConnections].
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $PrewarmingToken {
  ///Prewarming Token id.
  String get id;
}
