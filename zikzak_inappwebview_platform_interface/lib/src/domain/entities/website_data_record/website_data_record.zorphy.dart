// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'website_data_record.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class WebsiteDataRecord {
  WebsiteDataRecord({
    String? this.displayName,
    Set<WebsiteDataType>? this.dataTypes,
  });

  factory WebsiteDataRecord.fromJson(Map<String, dynamic> json) =>
      _$WebsiteDataRecordFromJson(json);

  final String? displayName;

  @JsonKey(toJson: _dataTypesToJson, fromJson: _dataTypesFromJson)
  final Set<WebsiteDataType>? dataTypes;

  WebsiteDataRecord copyWith({
    String? displayName,
    Set<WebsiteDataType>? dataTypes,
  }) {
    return WebsiteDataRecord(
      displayName: displayName ?? this.displayName,
      dataTypes: dataTypes ?? this.dataTypes,
    );
  }

  WebsiteDataRecord copyWithWebsiteDataRecord({
    String? displayName,
    Set<WebsiteDataType>? dataTypes,
  }) {
    return copyWith(displayName: displayName, dataTypes: dataTypes);
  }

  WebsiteDataRecord patchWithWebsiteDataRecord([
    WebsiteDataRecordPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? WebsiteDataRecordPatch();
    final _patchMap = _patcher.patchMap;
    return WebsiteDataRecord(
      displayName: _patchMap.containsKey(WebsiteDataRecord$.displayName)
          ? ((_patchMap[WebsiteDataRecord$.displayName] is Function)
                    ? _patchMap[WebsiteDataRecord$.displayName](
                        this.displayName,
                      )
                    : (_patchMap[WebsiteDataRecord$.displayName] is Patch)
                    ? _patchMap[WebsiteDataRecord$.displayName].applyTo(
                        this.displayName,
                      )
                    : _patchMap[WebsiteDataRecord$.displayName])
                as String?
          : this.displayName,
      dataTypes: _patchMap.containsKey(WebsiteDataRecord$.dataTypes)
          ? ((_patchMap[WebsiteDataRecord$.dataTypes] is Function)
                    ? _patchMap[WebsiteDataRecord$.dataTypes](this.dataTypes)
                    : (_patchMap[WebsiteDataRecord$.dataTypes] is Patch)
                    ? _patchMap[WebsiteDataRecord$.dataTypes].applyTo(
                        this.dataTypes,
                      )
                    : _patchMap[WebsiteDataRecord$.dataTypes])
                as Set<WebsiteDataType>?
          : this.dataTypes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WebsiteDataRecord &&
        displayName == other.displayName &&
        dataTypes == other.dataTypes;
  }

  @override
  int get hashCode {
    return Object.hash(this.displayName, this.dataTypes);
  }

  @override
  String toString() {
    return 'WebsiteDataRecord(' +
        'displayName: ${displayName}' +
        ', ' +
        'dataTypes: ${dataTypes})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$WebsiteDataRecordToJson(this);
    _sanitizeJson(data);
    return data;
  }

  dynamic _sanitizeJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      json.remove('__typename');
      return json..forEach((key, value) {
        json[key] = _sanitizeJson(value);
      });
    } else if (json is List) {
      return json.map((e) => _sanitizeJson(e)).toList();
    }
    return json;
  }
}

extension WebsiteDataRecordPropertyHelpers on WebsiteDataRecord {
  bool get hasDisplayName {
    return this.displayName?.isNotEmpty == true;
  }

  bool get noDisplayName {
    return this.displayName?.isEmpty ?? true;
  }

  String get displayNameRequired {
    return this.displayName ??
        (throw StateError('displayName is required but was null'));
  }

  Set<WebsiteDataType> get dataTypesRequired {
    return this.dataTypes ??
        (throw StateError('dataTypes is required but was null'));
  }

  bool get hasDataTypes {
    return this.dataTypes?.isNotEmpty ?? false;
  }

  bool get noDataTypes {
    return this.dataTypes?.isEmpty ?? true;
  }
}

extension WebsiteDataRecordSerialization on WebsiteDataRecord {
  Map<String, dynamic> toJson() {
    return _$WebsiteDataRecordToJson(this);
  }
}

enum WebsiteDataRecord$ { displayName, dataTypes }

class WebsiteDataRecordPatch
    extends PatchBase<WebsiteDataRecord, WebsiteDataRecord$> {
  WebsiteDataRecord applyTo(WebsiteDataRecord entity) {
    return entity.patchWithWebsiteDataRecord(this);
  }

  WebsiteDataRecordPatch withDisplayName(String? value) {
    patchMap[WebsiteDataRecord$.displayName] = value;
    return this;
  }

  WebsiteDataRecordPatch withDataTypes(Set<WebsiteDataType>? value) {
    patchMap[WebsiteDataRecord$.dataTypes] = value;
    return this;
  }
}

/// Field descriptors for [WebsiteDataRecord] query construction
abstract final class WebsiteDataRecordFields {
  static const displayName = Field<WebsiteDataRecord, String?>(
    'displayName',
    _$displayName,
  );

  static const dataTypes = Field<WebsiteDataRecord, Set<WebsiteDataType>?>(
    'dataTypes',
    _$dataTypes,
  );

  static String? _$displayName(WebsiteDataRecord e) {
    return e.displayName;
  }

  static Set<WebsiteDataType>? _$dataTypes(WebsiteDataRecord e) {
    return e.dataTypes;
  }
}

extension WebsiteDataRecordCompareE on WebsiteDataRecord {
  Map<String, dynamic> compareToWebsiteDataRecord(WebsiteDataRecord other) {
    final Map<String, dynamic> diff = {};

    if (displayName != other.displayName) {
      diff['displayName'] = () => other.displayName;
    }

    if (dataTypes != other.dataTypes) {
      diff['dataTypes'] = () => other.dataTypes;
    }
    return diff;
  }
}
