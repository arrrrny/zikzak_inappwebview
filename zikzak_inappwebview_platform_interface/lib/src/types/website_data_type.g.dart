// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'website_data_type.dart';

// **************************************************************************
// ExchangeableEnumGenerator
// **************************************************************************

///Class that represents a website data type.
class WebsiteDataType {
  final String _value;
  final String _nativeValue;
  const WebsiteDataType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory WebsiteDataType._internalMultiPlatform(
          String value, Function nativeValue) =>
      WebsiteDataType._internal(value, nativeValue());

  ///Returns a set of all available website data types.
  static final ALL = [
    WebsiteDataType.WKWebsiteDataTypeFetchCache,
    WebsiteDataType.WKWebsiteDataTypeDiskCache,
    WebsiteDataType.WKWebsiteDataTypeMemoryCache,
    WebsiteDataType.WKWebsiteDataTypeOfflineWebApplicationCache,
    WebsiteDataType.WKWebsiteDataTypeCookies,
    WebsiteDataType.WKWebsiteDataTypeSessionStorage,
    WebsiteDataType.WKWebsiteDataTypeLocalStorage,
    WebsiteDataType.WKWebsiteDataTypeWebSQLDatabases,
    WebsiteDataType.WKWebsiteDataTypeIndexedDBDatabases,
    WebsiteDataType.WKWebsiteDataTypeServiceWorkerRegistrations
  ].toSet();

  ///Cookies.
  static const WKWebsiteDataTypeCookies = WebsiteDataType._internal(
      'WKWebsiteDataTypeCookies', 'WKWebsiteDataTypeCookies');

  ///On-disk caches.
  static const WKWebsiteDataTypeDiskCache = WebsiteDataType._internal(
      'WKWebsiteDataTypeDiskCache', 'WKWebsiteDataTypeDiskCache');

  ///On-disk Fetch caches.
  ///
  ///**NOTE**: available on iOS 11.3+.
  static const WKWebsiteDataTypeFetchCache = WebsiteDataType._internal(
      'WKWebsiteDataTypeFetchCache', 'WKWebsiteDataTypeFetchCache');

  ///IndexedDB databases.
  static const WKWebsiteDataTypeIndexedDBDatabases = WebsiteDataType._internal(
      'WKWebsiteDataTypeIndexedDBDatabases',
      'WKWebsiteDataTypeIndexedDBDatabases');

  ///HTML local storage.
  static const WKWebsiteDataTypeLocalStorage = WebsiteDataType._internal(
      'WKWebsiteDataTypeLocalStorage', 'WKWebsiteDataTypeLocalStorage');

  ///In-memory caches.
  static const WKWebsiteDataTypeMemoryCache = WebsiteDataType._internal(
      'WKWebsiteDataTypeMemoryCache', 'WKWebsiteDataTypeMemoryCache');

  ///HTML offline web application caches.
  static const WKWebsiteDataTypeOfflineWebApplicationCache =
      WebsiteDataType._internal('WKWebsiteDataTypeOfflineWebApplicationCache',
          'WKWebsiteDataTypeOfflineWebApplicationCache');

  ///Service worker registrations.
  ///
  ///**NOTE**: available on iOS 11.3+.
  static const WKWebsiteDataTypeServiceWorkerRegistrations =
      WebsiteDataType._internal('WKWebsiteDataTypeServiceWorkerRegistrations',
          'WKWebsiteDataTypeServiceWorkerRegistrations');

  ///HTML session storage.
  static const WKWebsiteDataTypeSessionStorage = WebsiteDataType._internal(
      'WKWebsiteDataTypeSessionStorage', 'WKWebsiteDataTypeSessionStorage');

  ///WebSQL databases.
  static const WKWebsiteDataTypeWebSQLDatabases = WebsiteDataType._internal(
      'WKWebsiteDataTypeWebSQLDatabases', 'WKWebsiteDataTypeWebSQLDatabases');

  ///Set of all values of [WebsiteDataType].
  static final Set<WebsiteDataType> values = [
    WebsiteDataType.WKWebsiteDataTypeCookies,
    WebsiteDataType.WKWebsiteDataTypeDiskCache,
    WebsiteDataType.WKWebsiteDataTypeFetchCache,
    WebsiteDataType.WKWebsiteDataTypeIndexedDBDatabases,
    WebsiteDataType.WKWebsiteDataTypeLocalStorage,
    WebsiteDataType.WKWebsiteDataTypeMemoryCache,
    WebsiteDataType.WKWebsiteDataTypeOfflineWebApplicationCache,
    WebsiteDataType.WKWebsiteDataTypeServiceWorkerRegistrations,
    WebsiteDataType.WKWebsiteDataTypeSessionStorage,
    WebsiteDataType.WKWebsiteDataTypeWebSQLDatabases,
  ].toSet();

  ///Gets a possible [WebsiteDataType] instance from [String] value.
  static WebsiteDataType? fromValue(String? value) {
    if (value != null) {
      try {
        return WebsiteDataType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [WebsiteDataType] instance from a native value.
  static WebsiteDataType? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return WebsiteDataType.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets [String] value.
  String toValue() => _value;

  ///Gets [String] native value.
  String toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    return _value;
  }
}
