import '../../../types/script_html_tag_attributes.dart';
import '../css_link_html_tag_attributes/css_link_html_tag_attributes.dart';

///Class that represents the `crossorigin` content attribute on media elements, which is a CORS settings attribute.
///It could be used with [ScriptHtmlTagAttributes] and [CSSLinkHtmlTagAttributes]
///when fetching a resource `<link>` or a `<script>` (or resources fetched by the `<script>`).
enum CrossOrigin {
  ///CORS requests for this element will have the credentials flag set to 'same-origin'.
  ANONYMOUS,

  ///CORS requests for this element will have the credentials flag set to 'include'.
  USE_CREDENTIALS,
}

///CrossOrigin wire values are strings — lookup by value.
const _crossOrigin_wire = ['anonymous', 'use-credentials'];

CrossOrigin? crossOriginFromWire(Object? value) {
  if (value is! String) return null;
  final index = _crossOrigin_wire.indexOf(value);
  return index >= 0 ? CrossOrigin.values[index] : null;
}

Object? crossOriginToWire(CrossOrigin? value) =>
    value == null ? null : _crossOrigin_wire[value.index];
