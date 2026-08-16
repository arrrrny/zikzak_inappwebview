// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_job_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintJobInfo _$PrintJobInfoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PrintJobInfo', json, ($checkedConvert) {
  final val = PrintJobInfo(
    state: $checkedConvert('state', (v) => _stateFromJson(v)),
    copies: $checkedConvert('copies', (v) => (v as num?)?.toInt()),
    numberOfPages: $checkedConvert(
      'numberOfPages',
      (v) => (v as num?)?.toInt(),
    ),
    creationTime: $checkedConvert('creationTime', (v) => (v as num?)?.toInt()),
    label: $checkedConvert('label', (v) => v as String?),
    printer: $checkedConvert('printer', (v) => _printerFromJson(v)),
    pageOrder: $checkedConvert('pageOrder', (v) => _pageOrderFromJson(v)),
    preferredRenderingQuality: $checkedConvert(
      'preferredRenderingQuality',
      (v) => $enumDecodeNullable(_$PrintJobRenderingQualityEnumMap, v),
    ),
    showsProgressPanel: $checkedConvert(
      'showsProgressPanel',
      (v) => v as bool?,
    ),
    showsPrintPanel: $checkedConvert('showsPrintPanel', (v) => v as bool?),
    canSpawnSeparateThread: $checkedConvert(
      'canSpawnSeparateThread',
      (v) => v as bool?,
    ),
    isCopyingOperation: $checkedConvert(
      'isCopyingOperation',
      (v) => v as bool?,
    ),
    currentPage: $checkedConvert('currentPage', (v) => (v as num?)?.toInt()),
    firstPage: $checkedConvert('firstPage', (v) => (v as num?)?.toInt()),
    lastPage: $checkedConvert('lastPage', (v) => (v as num?)?.toInt()),
    attributes: $checkedConvert('attributes', (v) => _attributesFromJson(v)),
  );
  return val;
});

Map<String, dynamic> _$PrintJobInfoToJson(PrintJobInfo instance) =>
    <String, dynamic>{
      'state': _stateToJson(instance.state),
      'copies': instance.copies,
      'numberOfPages': instance.numberOfPages,
      'creationTime': instance.creationTime,
      'label': instance.label,
      'printer': _printerToJson(instance.printer),
      'pageOrder': _pageOrderToJson(instance.pageOrder),
      'preferredRenderingQuality':
          _$PrintJobRenderingQualityEnumMap[instance.preferredRenderingQuality],
      'showsProgressPanel': instance.showsProgressPanel,
      'showsPrintPanel': instance.showsPrintPanel,
      'canSpawnSeparateThread': instance.canSpawnSeparateThread,
      'isCopyingOperation': instance.isCopyingOperation,
      'currentPage': instance.currentPage,
      'firstPage': instance.firstPage,
      'lastPage': instance.lastPage,
      'attributes': _attributesToJson(instance.attributes),
    };

const _$PrintJobRenderingQualityEnumMap = {
  PrintJobRenderingQuality.BEST: 'BEST',
  PrintJobRenderingQuality.RESPONSIVE: 'RESPONSIVE',
};
