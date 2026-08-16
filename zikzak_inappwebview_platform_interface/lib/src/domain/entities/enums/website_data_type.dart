///Class that represents a website data type.
enum WebsiteDataType {
  ///On-disk Fetch caches.
  ///
  ///**NOTE**: available on iOS 11.3+.
  WKWebsiteDataTypeFetchCache,

  ///On-disk caches.
  WKWebsiteDataTypeDiskCache,

  ///In-memory caches.
  WKWebsiteDataTypeMemoryCache,

  ///HTML offline web application caches.
  WKWebsiteDataTypeOfflineWebApplicationCache,

  ///Cookies.
  WKWebsiteDataTypeCookies,

  ///HTML session storage.
  WKWebsiteDataTypeSessionStorage,

  ///HTML local storage.
  WKWebsiteDataTypeLocalStorage,

  ///WebSQL databases.
  WKWebsiteDataTypeWebSQLDatabases,

  ///IndexedDB databases.
  WKWebsiteDataTypeIndexedDBDatabases,

  ///Service worker registrations.
  ///
  ///**NOTE**: available on iOS 11.3+.
  WKWebsiteDataTypeServiceWorkerRegistrations,
}

///WebsiteDataType wire values are strings — lookup by value.
const _websiteDataType_wire = [
  'WKWebsiteDataTypeSessionStorage',
  'WKWebsiteDataTypeWebSQLDatabases',
  'WKWebsiteDataTypeIndexedDBDatabases',
];

WebsiteDataType? websiteDataTypeFromWire(Object? value) {
  if (value is! String) return null;
  final index = _websiteDataType_wire.indexOf(value);
  return index >= 0 ? WebsiteDataType.values[index] : null;
}

Object? websiteDataTypeToWire(WebsiteDataType? value) =>
    value == null ? null : _websiteDataType_wire[value.index];
