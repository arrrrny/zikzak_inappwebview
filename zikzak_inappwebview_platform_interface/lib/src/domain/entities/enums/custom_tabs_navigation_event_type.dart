

///The type corresponding to the navigation event of [PlatformChromeSafariBrowserEvents.onNavigationEvent].
enum CustomTabsNavigationEventType {
  ///Sent when the tab has started loading a page.
  STARTED,
  ///Sent when the tab has finished loading a page.
  FINISHED,
  ///Sent when the tab couldn't finish loading due to a failure.
  FAILED,
  ///Sent when loading was aborted by a user action before it finishes like clicking on a link or refreshing the page.
  ABORTED,
  ///Sent when the tab becomes visible.
  TAB_SHOWN,
  ///Sent when the tab becomes hidden.
  TAB_HIDDEN,
}


///custom_tabs_navigation_event_type wire values are NOT sequential (1, 2, 3, 4, 5, 6) — a plain enum's `.index`
///does not match the old `_value`.

///CustomTabsNavigationEventType wire values start at 1 — lookup by value.
const _customTabsNavigationEventType_wire = [1, 2, 3, 4, 5, 6];

CustomTabsNavigationEventType? customTabsNavigationEventTypeFromWire(Object? value) {
  if (value is! int) return null;
  final index = _customTabsNavigationEventType_wire.indexOf(value);
  return index >= 0 ? CustomTabsNavigationEventType.values[index] : null;
}

Object? customTabsNavigationEventTypeToWire(CustomTabsNavigationEventType? value) =>
    value == null ? null : _customTabsNavigationEventType_wire[value.index];
