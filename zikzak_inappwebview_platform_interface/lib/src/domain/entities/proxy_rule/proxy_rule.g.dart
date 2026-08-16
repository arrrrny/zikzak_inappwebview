// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxy_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProxyRule _$ProxyRuleFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ProxyRule', json, ($checkedConvert) {
      final val = ProxyRule(
        url: $checkedConvert('url', (v) => _urlFromJson(v)),
        schemeFilter: $checkedConvert(
          'schemeFilter',
          (v) => _schemeFilterFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ProxyRuleToJson(ProxyRule instance) => <String, dynamic>{
  'url': _urlToJson(instance.url),
  'schemeFilter': _schemeFilterToJson(instance.schemeFilter),
};
