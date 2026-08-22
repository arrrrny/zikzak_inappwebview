// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screenshot_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScreenshotConfiguration _$ScreenshotConfigurationFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ScreenshotConfiguration', json, ($checkedConvert) {
  final val = ScreenshotConfiguration(
    rect: $checkedConvert(
      'rect',
      (v) => v == null
          ? null
          : InAppWebViewRect.fromJson(v as Map<String, dynamic>),
    ),
    snapshotWidth: $checkedConvert(
      'snapshotWidth',
      (v) => (v as num?)?.toDouble(),
    ),
    compressFormat: $checkedConvert(
      'compressFormat',
      (v) =>
          $enumDecodeNullable(_$CompressFormatEnumMap, v) ?? CompressFormat.PNG,
    ),
    quality: $checkedConvert('quality', (v) => (v as num?)?.toInt() ?? 100),
    afterScreenUpdates: $checkedConvert(
      'afterScreenUpdates',
      (v) => v as bool? ?? true,
    ),
  );
  return val;
});

Map<String, dynamic> _$ScreenshotConfigurationToJson(
  ScreenshotConfiguration instance,
) => <String, dynamic>{
  'rect': instance.rect?.toJson(),
  'snapshotWidth': instance.snapshotWidth,
  'compressFormat': _$CompressFormatEnumMap[instance.compressFormat]!,
  'quality': instance.quality,
  'afterScreenUpdates': instance.afterScreenUpdates,
};

const _$CompressFormatEnumMap = {
  CompressFormat.PNG: 'PNG',
  CompressFormat.JPEG: 'JPEG',
  CompressFormat.WEBP: 'WEBP',
  CompressFormat.WEBP_LOSSY: 'WEBP_LOSSY',
  CompressFormat.WEBP_LOSSLESS: 'WEBP_LOSSLESS',
};
