///Class representing the [InAppWebViewHitTestResult] type.
enum InAppWebViewHitTestResultType {
  ///Default [InAppWebViewHitTestResult], where the target is unknown.
  UNKNOWN_TYPE,

  ///[InAppWebViewHitTestResult] for hitting a phone number.
  PHONE_TYPE,

  ///[InAppWebViewHitTestResult] for hitting a map address.
  GEO_TYPE,

  ///[InAppWebViewHitTestResult] for hitting an email address.
  EMAIL_TYPE,

  ///[InAppWebViewHitTestResult] for hitting an HTML::img tag.
  IMAGE_TYPE,

  ///[InAppWebViewHitTestResult] for hitting a HTML::a tag with src=http.
  SRC_ANCHOR_TYPE,

  ///[InAppWebViewHitTestResult] for hitting a HTML::a tag with src=http + HTML::img.
  SRC_IMAGE_ANCHOR_TYPE,

  ///[InAppWebViewHitTestResult] for hitting an edit text area.
  EDIT_TEXT_TYPE,
}

///InAppWebViewHitTestResultType wire values are NOT sequential (0, 2, 3, 4, 5, 7, 8, 9).
const _inAppWebViewHitTestResultType_wire = [0, 2, 3, 4, 5, 7, 8, 9];

InAppWebViewHitTestResultType? inAppWebViewHitTestResultTypeFromWire(
  Object? value,
) {
  if (value is! int) return null;
  final index = _inAppWebViewHitTestResultType_wire.indexOf(value);
  return index >= 0 ? InAppWebViewHitTestResultType.values[index] : null;
}

Object? inAppWebViewHitTestResultTypeToWire(
  InAppWebViewHitTestResultType? value,
) => value == null ? null : _inAppWebViewHitTestResultType_wire[value.index];
