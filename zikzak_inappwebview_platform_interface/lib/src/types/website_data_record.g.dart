// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'website_data_record.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///Class that represents website data, grouped by domain name using the public suffix list.
class WebsiteDataRecord {
  ///The various types of website data that exist for this data record.
  Set<WebsiteDataType>? dataTypes;

  ///The display name for the data record. This is usually the domain name.
  String? displayName;
  WebsiteDataRecord({this.dataTypes, this.displayName});

  ///Gets a possible [WebsiteDataRecord] instance from a [Map] value.
  static WebsiteDataRecord? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WebsiteDataRecord(
      dataTypes: map['dataTypes'] != null
          ? Set<WebsiteDataType>.from(
              map['dataTypes'].map((e) => WebsiteDataType.fromNativeValue(e)!),
            )
          : null,
      displayName: map['displayName'],
    );
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "dataTypes": dataTypes?.map((e) => e.toNativeValue()).toList(),
      "displayName": displayName,
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'WebsiteDataRecord{dataTypes: $dataTypes, displayName: $displayName}';
  }
}
