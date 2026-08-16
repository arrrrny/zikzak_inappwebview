import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../enums/website_data_type.dart';

part 'website_data_record.zorphy.dart';
part 'website_data_record.g.dart';

///Class that represents website data, grouped by domain name using the public suffix list.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $WebsiteDataRecord {
  ///The display name for the data record. This is usually the domain name.
  String? get displayName;
  ///The various types of website data that exist for this data record.
  @JsonKey(fromJson: _dataTypesFromJson, toJson: _dataTypesToJson)
  Set<WebsiteDataType>? get dataTypes;
}

Set<WebsiteDataType>? _dataTypesFromJson(Object? value) {
  if (value is! List) return null;
  return value.map((e) => websiteDataTypeFromWire(e)!).toSet();
}

Object? _dataTypesToJson(Set<WebsiteDataType>? dataTypes) =>
    dataTypes?.map((e) => websiteDataTypeToWire(e)).toList();
