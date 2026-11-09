import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_linux/src/util/wire.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  // Several zikzak encoders dispatch on the target platform.
  setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.linux);
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('wireMap converts nested channel maps to String-keyed maps', () {
    final Object raw = <Object?, Object?>{
      'request': <Object?, Object?>{'url': 'https://a.b/', 'headers': <Object?, Object?>{'h': 'v'}},
      'list': [<Object?, Object?>{'k': 1}],
    };
    final m = wireMap(raw)!;
    expect(m['request'], isA<Map<String, dynamic>>());
    expect((m['request'] as Map)['headers'], isA<Map<String, dynamic>>());
    expect((m['list'] as List).first, isA<Map<String, dynamic>>());
  });

  test('wireMap returns null for non-maps', () {
    expect(wireMap(null), isNull);
    expect(wireMap('x'), isNull);
  });

  test('fromWire decodes through fromJson', () {
    final raw = <Object?, Object?>{'url': 'https://a.b/', 'method': 'GET'};
    final r = fromWire(raw, URLRequest.fromJson)!;
    expect(r.url.toString(), 'https://a.b/');
    expect(r.method, 'GET');
    expect(fromWire<URLRequest>(null, URLRequest.fromJson), isNull);
  });

  group('encode: Dart -> native', () {
    test('userScriptToWire defaults contentWorld to the page world', () {
      final m = userScriptToWire(UserScript(source: 's', injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START));
      expect(m['contentWorld'], {'name': 'page'});
      expect(m['source'], 's');
      expect(m['injectionTime'], 0);
    });

    test('userScriptToWire keeps an explicit content world', () {
      final m = userScriptToWire(UserScript(
        source: 's',
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
        contentWorld: ContentWorld.world(name: 'w'),
      ));
      expect(m['contentWorld'], {'name': 'w'});
      expect(m['injectionTime'], 1);
    });

    test('clientCertResponseToWire adds the native default selectedCertificate', () {
      final m = clientCertResponseToWire(ClientCertResponse(
        certificatePath: '/c.p12',
        certificatePassword: 'pw',
        keyStoreType: 'JKS',
        action: ClientCertResponseAction.PROCEED,
      ));
      // Shape upstream's linux/types/client_cert_response.cc reads.
      expect(m, {
        'action': 1,
        'certificatePassword': 'pw',
        'certificatePath': '/c.p12',
        'keyStoreType': 'JKS',
        'selectedCertificate': -1,
      });
    });

    test('screenshotConfigurationToWire drops compressFormat', () {
      final m = screenshotConfigurationToWire(ScreenshotConfiguration(
        compressFormat: CompressFormat.JPEG,
        quality: 80,
        snapshotWidth: 50,
        afterScreenUpdates: false,
      ));
      expect(m.containsKey('compressFormat'), isFalse);
      expect(m['quality'], 80);
      expect(m['snapshotWidth'], 50.0);
      expect(m['afterScreenUpdates'], false);
    });

    test('inAppWebViewSettingsToWire drops the iOS/web-only enum keys', () {
      final m = inAppWebViewSettingsToWire(InAppWebViewSettings(
        contentInsetAdjustmentBehavior: ScrollViewContentInsetAdjustmentBehavior.ALWAYS,
        selectionGranularity: SelectionGranularity.CHARACTER,
        iframeReferrerPolicy: ReferrerPolicy.NO_REFERRER,
        userAgent: 'ua',
        javaScriptEnabled: false,
      ));
      expect(m.containsKey('contentInsetAdjustmentBehavior'), isFalse);
      expect(m.containsKey('selectionGranularity'), isFalse);
      expect(m.containsKey('iframeReferrerPolicy'), isFalse);
      expect(m['userAgent'], 'ua');
      expect(m['javaScriptEnabled'], false);
    });

    test('inAppBrowserClassSettingsToWire merges both settings without the iOS/web-only keys', () {
      final m = inAppBrowserClassSettingsToWire(InAppBrowserClassSettings(
        browserSettings: InAppBrowserSettings(hidden: true, windowType: WindowType.CHILD),
        webViewSettings: InAppWebViewSettings(
          userAgent: 'ua',
          selectionGranularity: SelectionGranularity.DYNAMIC,
        ),
      ));
      expect(m['hidden'], true);
      // linux/in_app_browser/in_app_browser_settings.cc parses the name.
      expect(m['windowType'], 'CHILD');
      expect(m['userAgent'], 'ua');
      expect(m.containsKey('selectionGranularity'), isFalse);
      expect(m.containsKey('contentInsetAdjustmentBehavior'), isFalse);
      expect(m.containsKey('iframeReferrerPolicy'), isFalse);
    });

    test('withAjaxEventFlags sets only the requested Ajax event keys', () {
      expect(
        withAjaxEventFlags({'a': 1}, onReadyStateChange: true, onProgress: false),
        {'a': 1, 'useOnAjaxReadyStateChange': true},
      );
      expect(
        withAjaxEventFlags({}, onReadyStateChange: false, onProgress: true),
        {'useOnAjaxProgress': true},
      );
      expect(withAjaxEventFlags({}, onReadyStateChange: false, onProgress: false), isEmpty);
    });

    test('proxySettingsToWire maps rule-based settings to bypassRules/proxyRules', () {
      final m = proxySettingsToWire(ProxySettings(
        androidProxySettings: AndroidProxySettings(
          bypassRules: ['*.local'],
          proxyRules: [
            ProxyRule(url: WebUri('http://p:8080'), schemeFilter: ProxySchemeFilter.MATCH_HTTPS),
            ProxyRule(url: WebUri('http://q:3128')),
          ],
        ),
      ));
      // Shape linux/proxy_manager.cc ProxySettings(FlValue*) / ProxyRule(FlValue*) reads.
      expect(m, {
        'bypassRules': ['*.local'],
        'proxyRules': [
          {'url': 'http://p:8080', 'schemeFilter': 'https'},
          {'url': 'http://q:3128', 'schemeFilter': null},
        ],
      });
    });

    test('proxySettingsToWire maps a single proxy URL with excluded domains', () {
      final m = proxySettingsToWire(ProxySettings(
        iOSProxySettings: IOSProxySettings(proxyUrl: 'socks5://s:1080', excludedDomains: ['a.b']),
      ));
      expect(m, {
        'bypassRules': ['a.b'],
        'proxyRules': [
          {'url': 'socks5://s:1080', 'schemeFilter': null},
        ],
      });
    });

    test('proxySettingsToWire sends no rules when nothing is configured', () {
      expect(proxySettingsToWire(ProxySettings()), {'bypassRules': <String>[], 'proxyRules': <Object?>[]});
    });
  });

  group('decode: native -> Dart', () {
    test('inAppWebViewSettingsFromWire ignores the iOS/web-only enum keys', () {
      final s = inAppWebViewSettingsFromWire(<Object?, Object?>{
        'userAgent': 'ua',
        'contentInsetAdjustmentBehavior': 2,
        'selectionGranularity': 0,
        'iframeReferrerPolicy': 'no-referrer',
      })!;
      expect(s.userAgent, 'ua');
      expect(inAppWebViewSettingsFromWire(null), isNull);
    });

    test('inAppBrowserClassSettingsFromWire splits the merged map and ignores the iOS/web-only keys', () {
      final s = inAppBrowserClassSettingsFromWire(<Object?, Object?>{
        'hidden': true,
        'userAgent': 'ua',
        'selectionGranularity': 0,
      })!;
      expect(s.browserSettings.hidden, true);
      expect(s.webViewSettings.userAgent, 'ua');
      expect(inAppBrowserClassSettingsFromWire(null), isNull);
    });

    test('permissionRequestFromWire maps native PermissionResourceType ints', () {
      // linux/types/permission_request.h: CAMERA=0 MICROPHONE=1
      // CAMERA_AND_MICROPHONE=2 GEOLOCATION=3 NOTIFICATIONS=4
      // PROTECTED_MEDIA_ID=5 MIDI_SYSEX=6 DEVICE_INFO=7 POINTER_LOCK=8
      final r = permissionRequestFromWire(<Object?, Object?>{
        'origin': 'https://a.b',
        'resources': [0, 1, 2, 3, 4, 5, 6, 7, 8],
        'frame': null,
      })!;
      expect(r.origin.toString(), 'https://a.b');
      expect(r.resources, [
        PermissionResourceType.CAMERA,
        PermissionResourceType.MICROPHONE,
        PermissionResourceType.CAMERA_AND_MICROPHONE,
        PermissionResourceType.PROTECTED_MEDIA_ID,
        PermissionResourceType.MIDI_SYSEX,
      ]);
      expect(r.frame, isNull);
      expect(permissionRequestFromWire(null), isNull);
    });

    test('findSessionFromWire accepts the native shape without a display style', () {
      final s = findSessionFromWire(<Object?, Object?>{'resultCount': 4, 'highlightedResultIndex': 2})!;
      expect(s.resultCount, 4);
      expect(s.highlightedResultIndex, 2);
      expect(s.searchResultDisplayStyle, SearchResultDisplayStyle.CURRENT_AND_TOTAL);
      expect(findSessionFromWire(null), isNull);
    });

    test('findSessionFromWire maps an int or a name display style', () {
      expect(
        findSessionFromWire(<Object?, Object?>{'resultCount': 1, 'highlightedResultIndex': 0, 'searchResultDisplayStyle': 2})!
            .searchResultDisplayStyle,
        SearchResultDisplayStyle.NONE,
      );
      expect(
        findSessionFromWire(<Object?, Object?>{'resultCount': 1, 'highlightedResultIndex': 0, 'searchResultDisplayStyle': 'TOTAL'})!
            .searchResultDisplayStyle,
        SearchResultDisplayStyle.TOTAL,
      );
    });

    test('webResourceErrorFromWire maps WebKit error codes to zikzak types', () {
      const expected = <int, WebResourceErrorType>{
        1: WebResourceErrorType.SERVER_CERTIFICATE_UNTRUSTED,
        2: WebResourceErrorType.SERVER_CERTIFICATE_UNTRUSTED,
        4: WebResourceErrorType.SERVER_CERTIFICATE_NOT_YET_VALID,
        8: WebResourceErrorType.SERVER_CERTIFICATE_HAS_BAD_DATE,
        16: WebResourceErrorType.SERVER_CERTIFICATE_UNTRUSTED,
        32: WebResourceErrorType.SECURE_CONNECTION_FAILED,
        64: WebResourceErrorType.SECURE_CONNECTION_FAILED,
        100: WebResourceErrorType.UNKNOWN,
        101: WebResourceErrorType.BAD_URL,
        102: WebResourceErrorType.UNKNOWN,
        103: WebResourceErrorType.UNKNOWN,
        199: WebResourceErrorType.UNKNOWN,
        300: WebResourceErrorType.CANNOT_CONNECT_TO_HOST,
        301: WebResourceErrorType.UNSUPPORTED_SCHEME,
        302: WebResourceErrorType.CANCELLED,
        303: WebResourceErrorType.FILE_NOT_FOUND,
        399: WebResourceErrorType.UNKNOWN,
        400: WebResourceErrorType.CANCELLED,
        401: WebResourceErrorType.CANNOT_CREATE_FILE,
        499: WebResourceErrorType.CANNOT_LOAD_FROM_NETWORK,
        -1: WebResourceErrorType.UNKNOWN,
        12345: WebResourceErrorType.UNKNOWN,
      };
      for (final e in expected.entries) {
        final err = webResourceErrorFromWire(<Object?, Object?>{'description': 'oops', 'type': e.key})!;
        expect(err.type, e.value, reason: 'native code ${e.key}');
        expect(err.description, 'oops');
      }
      expect(webResourceErrorFromWire(null), isNull);
    });

    test('webMessageFromWire decodes data and type and never ports', () {
      final s = webMessageFromWire(<Object?, Object?>{'data': 'hi', 'type': 0, 'ports': [<Object?, Object?>{'index': 0}]})!;
      expect(s.data, 'hi');
      expect(s.type, WebMessageType.STRING);
      expect(s.ports, isNull);
      final b = webMessageFromWire(<Object?, Object?>{'data': Uint8List.fromList([1, 2]), 'type': 1})!;
      expect(b.data, [1, 2]);
      expect(b.type, WebMessageType.ARRAY_BUFFER);
      expect(webMessageFromWire(null), isNull);
    });
  });
}
