// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safe_browsing_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SafeBrowsingResponse _$SafeBrowsingResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SafeBrowsingResponse', json, ($checkedConvert) {
  final val = SafeBrowsingResponse(
    report: $checkedConvert('report', (v) => v as bool? ?? true),
    action: $checkedConvert(
      'action',
      (v) => v == null
          ? SafeBrowsingResponseAction.SHOW_INTERSTITIAL
          : _actionFromJson(v),
    ),
  );
  return val;
});

Map<String, dynamic> _$SafeBrowsingResponseToJson(
  SafeBrowsingResponse instance,
) => <String, dynamic>{
  'report': instance.report,
  'action': _actionToJson(instance.action),
};
