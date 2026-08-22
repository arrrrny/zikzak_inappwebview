import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../ssl_certificate/ssl_certificate.dart';

part 'ssl_certificate_dname.zorphy.dart';
part 'ssl_certificate_dname.g.dart';

///Distinguished name helper class. Used by [SslCertificate].
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $SslCertificateDName {
  ///Common-name (CN) component of the name
  @JsonKey(defaultValue: "")
  String? get CName;

  ///Distinguished name (normally includes CN, O, and OU names)
  @JsonKey(defaultValue: "")
  String? get DName;

  ///Organization (O) component of the name
  @JsonKey(defaultValue: "")
  String? get OName;

  ///Organizational Unit (OU) component of the name
  @JsonKey(defaultValue: "")
  String? get UName;
}
