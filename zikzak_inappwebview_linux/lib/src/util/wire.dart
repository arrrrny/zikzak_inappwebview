// Wire adapters between zikzak's platform-interface types and the map
// shapes the Linux native code (imported from upstream
// flutter_inappwebview_linux 0.1.0-beta.1) reads and writes.
//
// Most adapters resolve entries of `knownDifferences` in
// tool/wire_parity/test/support.dart, whose tests print each encoding
// difference as a `DIFF` line.

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Converts a map received over a method channel, whose nested maps are
/// `Map<Object?, Object?>`, into `Map<String, dynamic>` all the way down,
/// as zikzak's generated `fromJson` constructors expect.
Map<String, dynamic>? wireMap(Object? value) {
  if (value is! Map) return null;
  return value.map((k, v) => MapEntry(k.toString(), _deep(v)));
}

Object? _deep(Object? v) {
  if (v is Map) return wireMap(v);
  if (v is List) return v.map(_deep).toList();
  return v;
}

/// Decodes a channel value with [fromJson], or returns null when there is
/// no map to decode.
T? fromWire<T>(Object? value, T Function(Map<String, dynamic>) fromJson) {
  final map = wireMap(value);
  return map == null ? null : fromJson(map);
}

/// Fills in the page world when the script has none, as upstream always sends
/// `contentWorld`. Native (linux/types/user_script.cc) falls back to the page
/// world too, so this keeps the payload identical to upstream's.
Map<String, dynamic> userScriptToWire(UserScript script) => {
      ...script.toJson(),
      'contentWorld': script.contentWorld?.toJson() ?? {'name': 'page'},
    };

/// zikzak's [ClientCertResponse] has no `selectedCertificate`; native
/// (linux/types/client_cert_response.cc) defaults it to -1, which is sent
/// explicitly so the payload matches upstream's.
Map<String, dynamic> clientCertResponseToWire(ClientCertResponse response) => {
      ...response.toJson(),
      'selectedCertificate': -1,
    };

/// Native never reads `compressFormat` (it always returns PNG) and upstream
/// sends none on Linux.
Map<String, dynamic> screenshotConfigurationToWire(
  ScreenshotConfiguration configuration,
) =>
    configuration.toJson()..remove('compressFormat');

/// iOS/web-only settings that zikzak encodes as enum names, upstream as ints
/// or HTTP tokens. Linux native neither reads nor sends them, and zikzak's
/// decoder throws on upstream's encodings, so they are dropped both ways.
const _settingsKeysNotOnLinux = {
  'contentInsetAdjustmentBehavior',
  'selectionGranularity',
  'iframeReferrerPolicy',
};

/// [InAppWebViewSettings.toJson] without the keys Linux never reads.
Map<String, dynamic> inAppWebViewSettingsToWire(
  InAppWebViewSettings settings,
) =>
    settings.toJson()
      ..removeWhere((k, _) => _settingsKeysNotOnLinux.contains(k));

/// [InAppBrowserClassSettings.toJson] (browser and webview settings merged
/// into one map, as native reads them) without the keys Linux never reads.
Map<String, dynamic> inAppBrowserClassSettingsToWire(
  InAppBrowserClassSettings settings,
) =>
    settings.toJson()
      ..removeWhere((k, _) => _settingsKeysNotOnLinux.contains(k));

/// Adds the `useOnAjaxReadyStateChange` / `useOnAjaxProgress` keys to a
/// settings wire map. zikzak's [InAppWebViewSettings] has no such settings,
/// native defaults both to false (linux/in_app_webview/in_app_webview_settings.h)
/// and the Ajax script only wraps `onreadystatechange` / progress events when
/// they are true, so without them `onAjaxReadyStateChange` and
/// `onAjaxProgress` never fire. A flag that is false leaves the map as is.
Map<String, dynamic> withAjaxEventFlags(
  Map<String, dynamic> settings, {
  required bool onReadyStateChange,
  required bool onProgress,
}) {
  if (onReadyStateChange) settings['useOnAjaxReadyStateChange'] = true;
  if (onProgress) settings['useOnAjaxProgress'] = true;
  return settings;
}

/// Maps zikzak's [ProxySettings] to the map
/// `linux/proxy_manager.cc` `ProxySettings(FlValue*)` reads:
/// `{bypassRules: [String], proxyRules: [{url, schemeFilter}]}`.
///
/// zikzak's rule-based [AndroidProxySettings] maps directly (`directs`,
/// `bypassSimpleHostnames`, `removeImplicitRules` and `reverseBypassEnabled`
/// have no WPE equivalent). Without them, [IOSProxySettings.proxyUrl] becomes
/// the default proxy and its `excludedDomains` the bypass list. No rules
/// makes native clear the proxy override.
Map<String, dynamic> proxySettingsToWire(ProxySettings settings) {
  final android = settings.androidProxySettings;
  if (android != null) {
    return {
      'bypassRules': List<String>.of(android.bypassRules),
      'proxyRules': [
        for (final rule in android.proxyRules)
          {
            'url': rule.url.toString(),
            'schemeFilter': proxySchemeFilterToWire(rule.schemeFilter),
          },
      ],
    };
  }
  final ios = settings.iOSProxySettings;
  if (ios != null && ios.proxyUrl.isNotEmpty) {
    return {
      'bypassRules': List<String>.of(ios.excludedDomains),
      'proxyRules': [
        {'url': ios.proxyUrl, 'schemeFilter': null},
      ],
    };
  }
  return {'bypassRules': <String>[], 'proxyRules': <Object?>[]};
}

/// Decodes `getSettings`, ignoring the keys of [_settingsKeysNotOnLinux].
InAppWebViewSettings? inAppWebViewSettingsFromWire(Object? value) {
  final map = wireMap(value);
  if (map == null) return null;
  map.removeWhere((k, _) => _settingsKeysNotOnLinux.contains(k));
  return InAppWebViewSettings.fromJson(map);
}

/// Decodes the browser's `getSettings`, ignoring the keys of
/// [_settingsKeysNotOnLinux].
InAppBrowserClassSettings? inAppBrowserClassSettingsFromWire(Object? value) {
  final map = wireMap(value);
  if (map == null) return null;
  map.removeWhere((k, _) => _settingsKeysNotOnLinux.contains(k));
  return InAppBrowserClassSettings.fromMap(map);
}

/// Native `PermissionResourceType` values
/// (linux/types/permission_request.h). GEOLOCATION (3), NOTIFICATIONS (4),
/// DEVICE_INFO (7) and POINTER_LOCK (8) have no zikzak value and are dropped.
const _nativePermissionResourceTypes = <int, PermissionResourceType>{
  0: PermissionResourceType.CAMERA,
  1: PermissionResourceType.MICROPHONE,
  2: PermissionResourceType.CAMERA_AND_MICROPHONE,
  5: PermissionResourceType.PROTECTED_MEDIA_ID,
  6: PermissionResourceType.MIDI_SYSEX,
};

/// Native sends `resources` as ints (linux/types/permission_request.cc),
/// which zikzak's decoder only understands on iOS/macOS. The frame is always
/// null on Linux.
PermissionRequest? permissionRequestFromWire(Object? value) {
  final map = wireMap(value);
  if (map == null) return null;
  final origin = map['origin'];
  final resources = map['resources'];
  return PermissionRequest(
    origin: origin is String ? WebUri(origin) : null,
    resources: [
      if (resources is List)
        for (final r in resources)
          ?_nativePermissionResourceTypes[r],
    ],
  );
}

/// Native sends only `resultCount` and `highlightedResultIndex`
/// (linux/types/find_session.cc); zikzak's decoder requires
/// `searchResultDisplayStyle`, which defaults to CURRENT_AND_TOTAL here.
FindSession? findSessionFromWire(Object? value) {
  final map = wireMap(value);
  if (map == null) return null;
  final style = map['searchResultDisplayStyle'];
  return FindSession(
    resultCount: (map['resultCount'] as num?)?.toInt() ?? 0,
    highlightedResultIndex: (map['highlightedResultIndex'] as num?)?.toInt() ?? 0,
    searchResultDisplayStyle: (style is int &&
                style >= 0 &&
                style < SearchResultDisplayStyle.values.length)
        ? SearchResultDisplayStyle.values[style]
        : SearchResultDisplayStyle.values
                .where((e) => e.name == style)
                .firstOrNull ??
            SearchResultDisplayStyle.CURRENT_AND_TOTAL,
  );
}

/// WebKit `GError` codes native passes through as `WebResourceError.type`
/// (linux/in_app_webview/in_app_webview.cc, OnLoadFailed), using upstream's
/// Linux table: TLS certificate flags (1-64), WebKitPolicyError (100-199),
/// WebKitNetworkError (300-399) and WebKitDownloadError (400-499). Codes
/// without a zikzak counterpart map to UNKNOWN.
///
/// Known inexactness (inherited from upstream): native sends the GError code
/// without its domain (in_app_webview.cc, OnLoadFailed), so codes from other
/// domains collide with this table. For example G_IO_ERROR_NOT_FOUND (1) maps
/// to SERVER_CERTIFICATE_UNTRUSTED, and DNS failures and timeouts map to
/// UNKNOWN.
const _nativeWebResourceErrorTypes = <int, WebResourceErrorType>{
  1: WebResourceErrorType.SERVER_CERTIFICATE_UNTRUSTED,
  2: WebResourceErrorType.SERVER_CERTIFICATE_UNTRUSTED, // bad identity
  4: WebResourceErrorType.SERVER_CERTIFICATE_NOT_YET_VALID,
  8: WebResourceErrorType.SERVER_CERTIFICATE_HAS_BAD_DATE,
  16: WebResourceErrorType.SERVER_CERTIFICATE_UNTRUSTED, // revoked
  32: WebResourceErrorType.SECURE_CONNECTION_FAILED,
  64: WebResourceErrorType.SECURE_CONNECTION_FAILED, // generic TLS error
  101: WebResourceErrorType.BAD_URL, // cannot show URI
  300: WebResourceErrorType.CANNOT_CONNECT_TO_HOST,
  301: WebResourceErrorType.UNSUPPORTED_SCHEME,
  302: WebResourceErrorType.CANCELLED,
  303: WebResourceErrorType.FILE_NOT_FOUND,
  400: WebResourceErrorType.CANCELLED, // download cancelled by user
  401: WebResourceErrorType.CANNOT_CREATE_FILE, // download destination
  499: WebResourceErrorType.CANNOT_LOAD_FROM_NETWORK, // download network
};

/// Native sends a WebKit error code, which zikzak's decoder (enum names
/// only) turns into null.
WebResourceError? webResourceErrorFromWire(Object? value) {
  final map = wireMap(value);
  if (map == null) return null;
  final type = map['type'];
  return WebResourceError(
    description: map['description'] as String?,
    type: type is String
        ? WebResourceErrorType.values.where((e) => e.name == type).firstOrNull
        : _nativeWebResourceErrorTypes[type] ?? WebResourceErrorType.UNKNOWN,
  );
}

/// zikzak's [WebMessage.fromJson] throws on port maps (it expects
/// [IWebMessagePort] objects). Native never sends ports to Dart, so only
/// `data` and `type` are decoded.
WebMessage? webMessageFromWire(Object? value) {
  final map = wireMap(value);
  if (map == null) return null;
  final type = map['type'];
  return WebMessage(
    data: map['data'],
    type: type is int && type >= 0 && type < WebMessageType.values.length
        ? WebMessageType.values[type]
        : WebMessageType.STRING,
  );
}
