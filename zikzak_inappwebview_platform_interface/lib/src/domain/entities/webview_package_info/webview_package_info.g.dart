// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webview_package_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebViewPackageInfo _$WebViewPackageInfoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WebViewPackageInfo', json, ($checkedConvert) {
      final val = WebViewPackageInfo(
        versionName: $checkedConvert('versionName', (v) => v as String?),
        packageName: $checkedConvert('packageName', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$WebViewPackageInfoToJson(WebViewPackageInfo instance) =>
    <String, dynamic>{
      'versionName': instance.versionName,
      'packageName': instance.packageName,
    };
