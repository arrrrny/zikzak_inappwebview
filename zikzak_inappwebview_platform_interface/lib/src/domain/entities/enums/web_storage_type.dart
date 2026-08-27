///Class that represents the type of Web Storage: `localStorage` or `sessionStorage`.
///Used by the [PlatformStorage] class.
enum WebStorageType {
  ///`window.localStorage`: same as [SESSION_STORAGE], but persists even when the browser is closed and reopened.
  LOCAL_STORAGE,

  ///`window.sessionStorage`: maintains a separate storage area for each given origin that's available for the duration
  ///of the page session (as long as the browser is open, including page reloads and restores).
  SESSION_STORAGE,
}

///WebStorageType wire values are the JS storage names (the old `_value`),
///which differ from the member names — lookup by value.
String webStorageTypeToWire(WebStorageType type) => switch (type) {
  WebStorageType.LOCAL_STORAGE => 'localStorage',
  WebStorageType.SESSION_STORAGE => 'sessionStorage',
};
