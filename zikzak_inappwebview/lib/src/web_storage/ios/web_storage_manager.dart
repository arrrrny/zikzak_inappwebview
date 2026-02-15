import 'dart:async';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../web_storage_manager.dart';

///Class that represents various types of data that a website might make use of.
///This includes cookies, disk and memory caches, and persistent data such as WebSQL, IndexedDB databases, and local storage.
///
///**NOTE**: available on iOS 9.0+.
///
///Use [WebStorageManager] instead.
@Deprecated("Use WebStorageManager instead")
class IOSWebStorageManager {
  ///Fetches data records containing the given website data types.
  ///
  ///[dataTypes] represents the website data types to fetch records for.
  Future<List<WebsiteDataRecord>> fetchDataRecords(
      {required Set<WebsiteDataType> dataTypes}) async {
    return await WebStorageManager.instance()
        .fetchDataRecords(dataTypes: dataTypes);
  }

  ///Removes website data of the given types for the given data records.
  ///
  ///[dataTypes] represents the website data types that should be removed.
  ///
  ///[dataRecords] represents the website data records to delete website data for.
  Future<void> removeDataFor(
      {required Set<WebsiteDataType> dataTypes,
      required List<WebsiteDataRecord> dataRecords}) async {
    await WebStorageManager.instance()
        .removeDataFor(dataRecords: dataRecords, dataTypes: dataTypes);
  }

  ///Removes all website data of the given types that has been modified since the given date.
  ///
  ///[dataTypes] represents the website data types that should be removed.
  ///
  ///[date] represents a date. All website data modified after this date will be removed.
  Future<void> removeDataModifiedSince(
      {required Set<WebsiteDataType> dataTypes, required DateTime date}) async {
    await WebStorageManager.instance()
        .removeDataModifiedSince(dataTypes: dataTypes, date: date);
  }
}
