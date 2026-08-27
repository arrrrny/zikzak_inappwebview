import '../../../types/script_html_tag_attributes.dart';
import '../css_link_html_tag_attributes/css_link_html_tag_attributes.dart';

///Class that represents a Referrer-Policy HTTP header.
///It could be used with [ScriptHtmlTagAttributes] and [CSSLinkHtmlTagAttributes]
///when fetching a resource `<link>` or a `<script>` (or resources fetched by the `<script>`).
enum ReferrerPolicy {
  ///The Referer header will not be sent.
  NO_REFERRER,

  ///The Referer header will not be sent to origins without TLS (HTTPS).
  NO_REFERRER_WHEN_DOWNGRADE,

  ///The sent referrer will be limited to the origin of the referring page: its scheme, host, and port.
  ORIGIN,

  ///The referrer sent to other origins will be limited to the scheme, the host, and the port.
  ///Navigations on the same origin will still include the path.
  ORIGIN_WHEN_CROSS_ORIGIN,

  ///A referrer will be sent for same origin, but cross-origin requests will contain no referrer information.
  SAME_ORIGIN,

  ///Only send the origin of the document as the referrer when the protocol security level stays the same (e.g. HTTPS -> HTTPS),
  ///but don't send it to a less secure destination (e.g. HTTPS -> HTTP).
  STRICT_ORIGIN,

  ///Send a full URL when performing a same-origin request, but only send the origin when the protocol security level stays the same (e.g.HTTPS -> HTTPS),
  ///and send no header to a less secure destination (e.g. HTTPS -> HTTP).
  STRICT_ORIGIN_WHEN_CROSS_ORIGIN,

  ///The referrer will include the origin and the path (but not the fragment, password, or username).
  ///This value is unsafe, because it leaks origins and paths from TLS-protected resources to insecure origins.
  UNSAFE_URL,
}

///ReferrerPolicy wire values differ from the member names — lookup by value.
const _referrerPolicy_wire = [
  'no-referrer',
  'no-referrer-when-downgrade',
  'origin',
  'origin-when-cross-origin',
  'same-origin',
  'strict-origin',
  'strict-origin-when-cross-origin',
  'unsafe-url',
];

ReferrerPolicy? referrerPolicyFromWire(Object? value) {
  if (value is! String) return null;
  final index = _referrerPolicy_wire.indexOf(value);
  return index >= 0 ? ReferrerPolicy.values[index] : null;
}

Object? referrerPolicyToWire(ReferrerPolicy? value) =>
    value == null ? null : _referrerPolicy_wire[value.index];
