// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_webview_rect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InAppWebViewRect _$InAppWebViewRectFromJson(Map<String, dynamic> json) =>
    $checkedCreate('InAppWebViewRect', json, ($checkedConvert) {
      final val = InAppWebViewRect(
        x: $checkedConvert('x', (v) => (v as num).toDouble()),
        y: $checkedConvert('y', (v) => (v as num).toDouble()),
        width: $checkedConvert('width', (v) => (v as num).toDouble()),
        height: $checkedConvert('height', (v) => (v as num).toDouble()),
      );
      return val;
    });

Map<String, dynamic> _$InAppWebViewRectToJson(InAppWebViewRect instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'width': instance.width,
      'height': instance.height,
    };
