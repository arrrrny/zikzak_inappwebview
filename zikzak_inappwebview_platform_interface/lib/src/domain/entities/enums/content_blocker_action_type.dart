import '../../../content_blocker.dart';

///Class that represents the kind of action that can be used with a [ContentBlockerTrigger].
enum ContentBlockerActionType {
  ///Stops loading of the resource. If the resource was cached, the cache is ignored.
  BLOCK,

  ///Hides elements of the page based on a CSS selector.
  ///A selector field contains the selector list.
  ///Any matching element has its display property set to none, which hides it.
  ///
  ///**NOTE**: on Android, JavaScript must be enabled.
  CSS_DISPLAY_NONE,

  ///Changes a URL from http to https.
  ///URLs with a specified (nondefault) port and links using other protocols are unaffected.
  MAKE_HTTPS,

  ///Strips cookies from the header before sending it to the server.
  ///This only blocks cookies otherwise acceptable to WebView's privacy policy.
  ///Combining with [IGNORE_PREVIOUS_RULES] doesn't override the browser’s privacy settings.
  BLOCK_COOKIES,

  ///Ignores previously triggered actions.
  IGNORE_PREVIOUS_RULES,
}

///ContentBlockerActionType wire values are the content-blocker strings (e.g. 'block'), which
///differ from the member names — lookup by value.

///ContentBlockerActionType wire values are the content-blocker strings (block, css-display-none, make-https...) — lookup by value.
const _contentBlockerActionType_wire = [
  'block',
  'css-display-none',
  'make-https',
  'block-cookies',
  'ignore-previous-rules',
];

ContentBlockerActionType? contentBlockerActionTypeFromWire(String? value) {
  if (value == null) return null;
  final index = _contentBlockerActionType_wire.indexOf(value);
  return index >= 0 ? ContentBlockerActionType.values[index] : null;
}

String? contentBlockerActionTypeToWire(ContentBlockerActionType? value) =>
    value == null ? null : _contentBlockerActionType_wire[value.index];
