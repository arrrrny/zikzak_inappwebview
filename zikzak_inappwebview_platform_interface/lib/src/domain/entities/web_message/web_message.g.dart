// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebMessage _$WebMessageFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WebMessage', json, ($checkedConvert) {
      final val = WebMessage(
        data: $checkedConvert('data', (v) => v),
        type: $checkedConvert(
          'type',
          (v) => v == null ? WebMessageType.STRING : _typeFromJson(v),
        ),
        ports: $checkedConvert('ports', (v) => _portsFromJson(v)),
      );
      return val;
    });

Map<String, dynamic> _$WebMessageToJson(WebMessage instance) =>
    <String, dynamic>{
      'data': instance.data,
      'type': _typeToJson(instance.type),
      'ports': _portsToJson(instance.ports),
    };
