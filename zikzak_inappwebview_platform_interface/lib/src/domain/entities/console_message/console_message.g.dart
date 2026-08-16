// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'console_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsoleMessage _$ConsoleMessageFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ConsoleMessage', json, ($checkedConvert) {
      final val = ConsoleMessage(
        message: $checkedConvert('message', (v) => v as String? ?? ''),
        messageLevel: $checkedConvert(
          'messageLevel',
          (v) => v == null ? ConsoleMessageLevel.LOG : _messageLevelFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ConsoleMessageToJson(ConsoleMessage instance) =>
    <String, dynamic>{
      'message': instance.message,
      'messageLevel': _messageLevelToJson(instance.messageLevel),
    };
