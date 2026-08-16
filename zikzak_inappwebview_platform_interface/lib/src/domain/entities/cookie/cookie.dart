import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../../../platform_cookie_manager.dart';
import '../enums/http_cookie_same_site_policy.dart';

part 'cookie.zorphy.dart';
part 'cookie.g.dart';

///Class that represents a cookie returned by the [PlatformCookieManager].
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $Cookie {
  ///The cookie name.
  String get name;
  ///The cookie value.
  dynamic get value;
  ///The cookie expiration date in milliseconds.
  int? get expiresDate;
  ///Indicates if the cookie is a session only cookie.
  bool? get isSessionOnly;
  ///The cookie domain.
  String? get domain;
  ///The cookie same site policy.
  @JsonKey(fromJson: _sameSiteFromJson, toJson: _sameSiteToJson)
  HTTPCookieSameSitePolicy? get sameSite;
  ///Indicates if the cookie is secure or not.
  bool? get isSecure;
  ///Indicates if the cookie is a http only cookie.
  bool? get isHttpOnly;
  ///The cookie path.
  String? get path;
}

HTTPCookieSameSitePolicy? _sameSiteFromJson(Object? value) => httpCookieSameSitePolicyFromWire(value);

Object? _sameSiteToJson(HTTPCookieSameSitePolicy? value) => httpCookieSameSitePolicyToWire(value);
