// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_webview_asset_loader.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebViewAssetLoader _$WebViewAssetLoaderFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WebViewAssetLoader', json, ($checkedConvert) {
      final val = WebViewAssetLoader(
        domain: $checkedConvert('domain', (v) => v as String?),
        httpAllowed: $checkedConvert('httpAllowed', (v) => v as bool?),
        pathHandlers: $checkedConvert(
          'pathHandlers',
          (v) => _pathHandlersFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$WebViewAssetLoaderToJson(WebViewAssetLoader instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'httpAllowed': instance.httpAllowed,
      'pathHandlers': _pathHandlersToJson(instance.pathHandlers),
    };
