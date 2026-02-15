import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

part 'website_data_type.g.dart';

///Class that represents a website data type.
@ExchangeableEnum()
class WebsiteDataType_ {
  // ignore: unused_field
  final String _value;
  const WebsiteDataType_._internal(this._value);

  ///On-disk Fetch caches.
  ///
  ///**NOTE**: available on iOS 11.3+.
  static const WKWebsiteDataTypeFetchCache =
      const WebsiteDataType_._internal("WKWebsiteDataTypeFetchCache");

  ///On-disk caches.
  static const WKWebsiteDataTypeDiskCache =
      const WebsiteDataType_._internal("WKWebsiteDataTypeDiskCache");

  ///In-memory caches.
  static const WKWebsiteDataTypeMemoryCache =
      const WebsiteDataType_._internal("WKWebsiteDataTypeMemoryCache");

  ///HTML offline web application caches.
  static const WKWebsiteDataTypeOfflineWebApplicationCache =
      const WebsiteDataType_._internal(
          "WKWebsiteDataTypeOfflineWebApplicationCache");

  ///Cookies.
  static const WKWebsiteDataTypeCookies =
      const WebsiteDataType_._internal("WKWebsiteDataTypeCookies");

  ///HTML session storage.
  static const WKWebsiteDataTypeSessionStorage =
      const WebsiteDataType_._internal("WKWebsiteDataTypeSessionStorage");

  ///HTML local storage.
  static const WKWebsiteDataTypeLocalStorage =
      const WebsiteDataType_._internal("WKWebsiteDataTypeLocalStorage");

  ///WebSQL databases.
  static const WKWebsiteDataTypeWebSQLDatabases =
      const WebsiteDataType_._internal("WKWebsiteDataTypeWebSQLDatabases");

  ///IndexedDB databases.
  static const WKWebsiteDataTypeIndexedDBDatabases =
      const WebsiteDataType_._internal("WKWebsiteDataTypeIndexedDBDatabases");

  ///Service worker registrations.
  ///
  ///**NOTE**: available on iOS 11.3+.
  static const WKWebsiteDataTypeServiceWorkerRegistrations =
      const WebsiteDataType_._internal(
          "WKWebsiteDataTypeServiceWorkerRegistrations");

  ///Returns a set of all available website data types.
  @ExchangeableEnumCustomValue()
  // ignore: non_constant_identifier_names
  static final Set<WebsiteDataType_> ALL = [
    WebsiteDataType_.WKWebsiteDataTypeFetchCache,
    WebsiteDataType_.WKWebsiteDataTypeDiskCache,
    WebsiteDataType_.WKWebsiteDataTypeMemoryCache,
    WebsiteDataType_.WKWebsiteDataTypeOfflineWebApplicationCache,
    WebsiteDataType_.WKWebsiteDataTypeCookies,
    WebsiteDataType_.WKWebsiteDataTypeSessionStorage,
    WebsiteDataType_.WKWebsiteDataTypeLocalStorage,
    WebsiteDataType_.WKWebsiteDataTypeWebSQLDatabases,
    WebsiteDataType_.WKWebsiteDataTypeIndexedDBDatabases,
    WebsiteDataType_.WKWebsiteDataTypeServiceWorkerRegistrations
  ].toSet();
}
