// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context_menu_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContextMenuSettings _$ContextMenuSettingsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ContextMenuSettings', json, ($checkedConvert) {
      final val = ContextMenuSettings(
        hideDefaultSystemContextMenuItems: $checkedConvert(
          'hideDefaultSystemContextMenuItems',
          (v) => v as bool? ?? false,
        ),
      );
      return val;
    });

Map<String, dynamic> _$ContextMenuSettingsToJson(
  ContextMenuSettings instance,
) => <String, dynamic>{
  'hideDefaultSystemContextMenuItems':
      instance.hideDefaultSystemContextMenuItems,
};
