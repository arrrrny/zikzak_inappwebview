
import '../cookie/cookie.dart';


///Class that represents the same site policy of a cookie. Used by the [Cookie] class.
enum HTTPCookieSameSitePolicy {
  ///SameSite=Lax;
  ///
  ///Cookies are allowed to be sent with top-level navigations and will be sent along with GET
  ///request initiated by third party website. This is the default value in modern browsers.
  LAX,
  ///SameSite=Strict;
  ///
  ///Cookies will only be sent in a first-party context and not be sent along with requests initiated by third party websites.
  STRICT,
  ///SameSite=None;
  ///
  ///Cookies will be sent in all contexts, i.e sending cross-origin is allowed.
  ///`None` requires the `Secure` attribute in latest browser versions.
  NONE,
}


///HTTPCookieSameSitePolicy wire values are strings — lookup by value.
const _httpCookieSameSitePolicy_wire = ['Lax', 'Strict', 'None'];

HTTPCookieSameSitePolicy? httpCookieSameSitePolicyFromWire(Object? value) {
  if (value is! String) return null;
  final index = _httpCookieSameSitePolicy_wire.indexOf(value);
  return index >= 0 ? HTTPCookieSameSitePolicy.values[index] : null;
}

Object? httpCookieSameSitePolicyToWire(HTTPCookieSameSitePolicy? value) =>
    value == null ? null : _httpCookieSameSitePolicy_wire[value.index];
