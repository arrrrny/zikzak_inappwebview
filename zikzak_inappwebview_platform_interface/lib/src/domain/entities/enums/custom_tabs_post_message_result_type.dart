

///Custom Tabs postMessage result type.
enum CustomTabsPostMessageResultType {
  ///Indicates that the postMessage request was accepted.
  SUCCESS,
  ///Indicates that the postMessage request was not allowed due to a bad argument
  ///or requesting at a disallowed time like when in background.
  FAILURE_DISALLOWED,
  ///Indicates that the postMessage request has failed due to a `RemoteException`.
  FAILURE_REMOTE_ERROR,
  ///Indicates that the postMessage request has failed due to an internal error on the browser message channel.
  FAILURE_MESSAGING_ERROR,
}


///custom_tabs_post_message_result_type wire values are NOT sequential (0, -1, -2, -3) — a plain enum's `.index`
///does not match the old `_value`.

///CustomTabsPostMessageResultType wire values include negatives — lookup by value.
const _customTabsPostMessageResultType_wire = [0, -1, -2, -3];

CustomTabsPostMessageResultType? customTabsPostMessageResultTypeFromWire(Object? value) {
  if (value is! int) return null;
  final index = _customTabsPostMessageResultType_wire.indexOf(value);
  return index >= 0 ? CustomTabsPostMessageResultType.values[index] : null;
}

Object? customTabsPostMessageResultTypeToWire(CustomTabsPostMessageResultType? value) =>
    value == null ? null : _customTabsPostMessageResultType_wire[value.index];
