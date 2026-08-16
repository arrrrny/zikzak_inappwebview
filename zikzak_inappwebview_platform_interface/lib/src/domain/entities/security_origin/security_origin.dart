import 'package:zorphy_annotation/zorphy_annotation.dart';

part 'security_origin.zorphy.dart';
part 'security_origin.g.dart';

///An object that identifies the origin of a particular resource.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $SecurityOrigin {
  ///The security origin’s host.
  String get host;

  ///The security origin's port.
  int get port;

  ///The security origin's protocol.
  String get protocol;
}
