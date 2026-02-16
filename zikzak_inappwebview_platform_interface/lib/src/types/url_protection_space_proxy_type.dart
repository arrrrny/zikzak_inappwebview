import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

part 'url_protection_space_proxy_type.g.dart';

///Class that represents the supported proxy types.
@ExchangeableEnum()
class URLProtectionSpaceProxyType_ {
  // ignore: unused_field
  final String _value;
  const URLProtectionSpaceProxyType_._internal(this._value);

  ///The proxy type for HTTP proxies.
  static const URL_PROTECTION_SPACE_HTTP_PROXY =
      const URLProtectionSpaceProxyType_._internal(
        "NSURLProtectionSpaceHTTPProxy",
      );

  ///The proxy type for HTTPS proxies.
  static const URL_PROTECTION_SPACE_HTTPS_PROXY =
      const URLProtectionSpaceProxyType_._internal(
        "NSURLProtectionSpaceHTTPSProxy",
      );

  ///The proxy type for FTP proxies.
  static const URL_PROTECTION_SPACE_FTP_PROXY =
      const URLProtectionSpaceProxyType_._internal(
        "NSURLProtectionSpaceFTPProxy",
      );

  ///The proxy type for SOCKS proxies.
  static const URL_PROTECTION_SPACE_SOCKS_PROXY =
      const URLProtectionSpaceProxyType_._internal(
        "NSURLProtectionSpaceSOCKSProxy",
      );
}
