// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

URLRequest _$URLRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('URLRequest', json, ($checkedConvert) {
  final val = URLRequest(
    url: $checkedConvert('url', (v) => _urlFromJson(v)),
    method: $checkedConvert('method', (v) => v as String?),
    headers: $checkedConvert('headers', (v) => _headersFromJson(v)),
    body: $checkedConvert('body', (v) => _bodyFromJson(v)),
    allowsCellularAccess: $checkedConvert(
      'allowsCellularAccess',
      (v) => v as bool?,
    ),
    allowsConstrainedNetworkAccess: $checkedConvert(
      'allowsConstrainedNetworkAccess',
      (v) => v as bool?,
    ),
    allowsExpensiveNetworkAccess: $checkedConvert(
      'allowsExpensiveNetworkAccess',
      (v) => v as bool?,
    ),
    cachePolicy: $checkedConvert('cachePolicy', (v) => _cachePolicyFromJson(v)),
    httpShouldHandleCookies: $checkedConvert(
      'httpShouldHandleCookies',
      (v) => v as bool?,
    ),
    httpShouldUsePipelining: $checkedConvert(
      'httpShouldUsePipelining',
      (v) => v as bool?,
    ),
    networkServiceType: $checkedConvert(
      'networkServiceType',
      (v) => _networkServiceTypeFromJson(v),
    ),
    timeoutInterval: $checkedConvert(
      'timeoutInterval',
      (v) => (v as num?)?.toDouble(),
    ),
    mainDocumentURL: $checkedConvert(
      'mainDocumentURL',
      (v) => _mainDocumentURLFromJson(v),
    ),
    assumesHTTP3Capable: $checkedConvert(
      'assumesHTTP3Capable',
      (v) => v as bool?,
    ),
    attribution: $checkedConvert('attribution', (v) => _attributionFromJson(v)),
  );
  return val;
});

Map<String, dynamic> _$URLRequestToJson(
  URLRequest instance,
) => <String, dynamic>{
  'url': _urlToJson(instance.url),
  'method': instance.method,
  'headers': _headersToJson(instance.headers),
  'body': _bodyToJson(instance.body),
  'allowsCellularAccess': instance.allowsCellularAccess,
  'allowsConstrainedNetworkAccess': instance.allowsConstrainedNetworkAccess,
  'allowsExpensiveNetworkAccess': instance.allowsExpensiveNetworkAccess,
  'cachePolicy': _cachePolicyToJson(instance.cachePolicy),
  'httpShouldHandleCookies': instance.httpShouldHandleCookies,
  'httpShouldUsePipelining': instance.httpShouldUsePipelining,
  'networkServiceType': _networkServiceTypeToJson(instance.networkServiceType),
  'timeoutInterval': instance.timeoutInterval,
  'mainDocumentURL': _mainDocumentURLToJson(instance.mainDocumentURL),
  'assumesHTTP3Capable': instance.assumesHTTP3Capable,
  'attribution': _attributionToJson(instance.attribution),
};
