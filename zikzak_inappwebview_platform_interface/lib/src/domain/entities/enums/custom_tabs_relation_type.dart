///Custom Tabs relation for which the result is available.
enum CustomTabsRelationType {
  ///For App -> Web transitions, requests the app to use the declared origin to be used as origin for the client app in the web APIs context.
  USE_AS_ORIGIN,

  ///Requests the ability to handle all URLs from a given origin.
  HANDLE_ALL_URLS,
}

///custom_tabs_relation_type wire values are NOT sequential (1, 2) — a plain enum's `.index`
///does not match the old `_value`.

///CustomTabsRelationType wire values start at 1 — lookup by value.
const _customTabsRelationType_wire = [1, 2];

CustomTabsRelationType? customTabsRelationTypeFromWire(Object? value) {
  if (value is! int) return null;
  final index = _customTabsRelationType_wire.indexOf(value);
  return index >= 0 ? CustomTabsRelationType.values[index] : null;
}

Object? customTabsRelationTypeToWire(CustomTabsRelationType? value) =>
    value == null ? null : _customTabsRelationType_wire[value.index];
