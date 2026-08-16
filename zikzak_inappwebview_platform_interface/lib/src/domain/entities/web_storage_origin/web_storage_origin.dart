import 'package:zorphy_annotation/zorphy_annotation.dart';

part 'web_storage_origin.zorphy.dart';
part 'web_storage_origin.g.dart';

///Class that encapsulates information about the amount of storage currently used by an origin for the JavaScript storage APIs.
///An origin comprises the host, scheme and port of a URI. See [PlatformWebStorageManager] for details.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $WebStorageOrigin {
  ///The string representation of this origin.
  String? get origin;

  ///The quota for this origin, for the Web SQL Database API, in bytes.
  int? get quota;

  ///The total amount of storage currently being used by this origin, for all JavaScript storage APIs, in bytes.
  int? get usage;
}
