// Public-API regression tests for the navigation family, migrated from
// @ExchangeableObject/@ExchangeableEnum codegen to Zorphy entities (see
// PROGRESS.md, Phase 2e).
//
// Pins the CONSUMER-VISIBLE contract:
//   - constructor call shapes (required/optional params)
//   - JSON wire format (map keys; WebUri as toString; int enums as their
//     index; URLRequestNetworkServiceType as its NON-sequential wire ints;
//     NavigationType as its platform-dependent native value — iOS/macOS
//     WKNavigationType raw values / Windows WebView2 kinds / null on
//     Android)
//   - nested sibling entities (URLRequest/URLResponse/FrameInfo/
//     SecurityOrigin/WindowFeatures) via nested maps
//   - null/missing-key tolerance of fromJson
//   - copyWith availability (zorphy addition)
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// NavigationType native values are platform-dependent (the old
/// ExchangeableEnum codegen dispatched on `defaultTargetPlatform`), so the
/// wire tests pin the platform explicitly.
void withPlatform(TargetPlatform platform, void Function() fn) {
  debugDefaultTargetPlatformOverride = platform;
  try {
    fn();
  } finally {
    debugDefaultTargetPlatformOverride = null;
  }
}

void main() {
  group('NavigationAction', () {
    test('constructor requires request + isForMainFrame, optional rest', () {
      final action = NavigationAction(
        request: URLRequest(url: WebUri('https://example.com')),
        isForMainFrame: true,
      );
      expect(action.request.url.toString(), 'https://example.com');
      expect(action.isForMainFrame, isTrue);
      expect(action.hasGesture, isNull);
      expect(action.navigationType, isNull);
    });

    test('toJson emits nested request map + platform-native navigationType',
        () {
      withPlatform(TargetPlatform.iOS, () {
        final action = NavigationAction(
          request: URLRequest(url: WebUri('https://example.com')),
          isForMainFrame: true,
          navigationType: NavigationType.LINK_ACTIVATED,
          sourceFrame: FrameInfo(isMainFrame: true),
        );
        final map = action.toJson();
        expect(map['isForMainFrame'], true);
        expect(
          (map['request'] as Map)['url'],
          'https://example.com',
        );
        expect(map['navigationType'], 0); // WKNavigationType.linkActivated
        expect((map['sourceFrame'] as Map)['isMainFrame'], true);
        expect(map.containsKey('targetFrame'), isTrue);
        expect(map['targetFrame'], isNull);
      });
    });

    test('fromJson round-trips with platform-native navigationType', () {
      withPlatform(TargetPlatform.macOS, () {
        final action = NavigationAction.fromJson({
          'request': {'url': 'https://example.com'},
          'isForMainFrame': true,
          'navigationType': 4, // WKNavigationType.formResubmitted
        });
        expect(action.request.url.toString(), 'https://example.com');
        expect(action.navigationType, NavigationType.FORM_RESUBMITTED);
        expect(action.sourceFrame, isNull);
      });
    });

    test('navigationType wire is null on Android (no native value)', () {
      withPlatform(TargetPlatform.android, () {
        final action = NavigationAction(
          request: URLRequest(url: WebUri('https://example.com')),
          isForMainFrame: true,
          navigationType: NavigationType.RELOAD,
        );
        expect(action.toJson()['navigationType'], isNull);
      });
    });

    test('copyWith is available (zorphy addition)', () {
      final action = NavigationAction(
        request: URLRequest(url: WebUri('https://example.com')),
        isForMainFrame: true,
      );
      final changed = action.copyWith(isForMainFrame: false);
      expect(changed.isForMainFrame, isFalse);
      expect(changed.request.url.toString(), 'https://example.com');
    });
  });

  group('URLRequest', () {
    test('toJson emits WebUri as string + non-sequential service-type wire',
        () {
      final request = URLRequest(
        url: WebUri('https://example.com'),
        method: 'GET',
        headers: {'X-Test': '1'},
        body: Uint8List.fromList([1, 2, 3]),
        cachePolicy: URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_CACHE_DATA,
        networkServiceType: URLRequestNetworkServiceType.VIDEO,
        attribution: URLRequestAttribution.DEVELOPER,
      );
      final map = request.toJson();
      expect(map['url'], 'https://example.com');
      expect(map['headers'], {'X-Test': '1'});
      expect(map['body'], [1, 2, 3]);
      expect(map['cachePolicy'], 1); // sequential index
      expect(map['networkServiceType'], 2); // old _value, NOT .index
      expect(map['attribution'], 0);
    });

    test('fromJson round-trips body/headers/WebUri/enums', () {
      final request = URLRequest.fromJson({
        'url': 'https://example.com',
        'headers': {'X-Test': '1'},
        'body': [4, 5],
        'cachePolicy': 5,
        'networkServiceType': 11,
        'attribution': 1,
        'mainDocumentURL': 'https://main.example.com',
      });
      expect(request.url.toString(), 'https://example.com');
      expect(request.headers, {'X-Test': '1'});
      expect(request.body, [4, 5]);
      expect(
        request.cachePolicy,
        URLRequestCachePolicy.RELOAD_REVALIDATING_CACHE_DATA,
      );
      expect(
        request.networkServiceType,
        URLRequestNetworkServiceType.CALL_SIGNALING, // wire 11
      );
      expect(request.attribution, URLRequestAttribution.USER);
      expect(request.mainDocumentURL.toString(), 'https://main.example.com');
    });

    test('fromJson tolerates missing keys and unknown wire values', () {
      final request = URLRequest.fromJson(const {});
      expect(request.url, isNull);
      expect(request.cachePolicy, isNull);
      expect(request.networkServiceType, isNull);

      final bad = URLRequest.fromJson({'networkServiceType': 999});
      expect(bad.networkServiceType, isNull);
    });
  });

  group('NavigationResponse + URLResponse', () {
    test('nested URLResponse wire + round-trip', () {
      final response = NavigationResponse(
        response: URLResponse(
          url: WebUri('https://example.com'),
          expectedContentLength: 100,
          mimeType: 'text/html',
          headers: {'X-Test': '1'},
          statusCode: 200,
        ),
        isForMainFrame: true,
        canShowMIMEType: true,
      );
      final map = response.toJson();
      expect((map['response'] as Map)['url'], 'https://example.com');
      expect((map['response'] as Map)['expectedContentLength'], 100);
      expect((map['response'] as Map)['statusCode'], 200);

      final restored = NavigationResponse.fromJson(map);
      expect(restored.response!.url.toString(), 'https://example.com');
      expect(restored.response!.mimeType, 'text/html');
      expect(restored.isForMainFrame, isTrue);
    });
  });

  group('FrameInfo + SecurityOrigin', () {
    test('nested SecurityOrigin + URLRequest round-trip', () {
      final frame = FrameInfo(
        isMainFrame: true,
        request: URLRequest(url: WebUri('https://example.com')),
        securityOrigin: SecurityOrigin(host: 'example.com', port: 443, protocol: 'https'),
      );
      final map = frame.toJson();
      expect((map['securityOrigin'] as Map)['host'], 'example.com');
      expect((map['request'] as Map)['url'], 'https://example.com');

      final restored = FrameInfo.fromJson(map);
      expect(restored.securityOrigin!.protocol, 'https');
      expect(restored.request!.url.toString(), 'https://example.com');
    });
  });

  group('CreateWindowAction (extends NavigationAction, flattened)', () {
    test('flattened super-fields on the wire + round-trip', () {
      withPlatform(TargetPlatform.iOS, () {
        final action = CreateWindowAction(
          windowId: 7,
          windowFeatures: WindowFeatures(width: 640, height: 480),
          request: URLRequest(url: WebUri('https://example.com')),
          isForMainFrame: true,
          navigationType: NavigationType.RELOAD,
        );
        final map = action.toJson();
        expect(map['windowId'], 7);
        expect((map['windowFeatures'] as Map)['width'], 640);
        expect((map['request'] as Map)['url'], 'https://example.com');
        expect(map['navigationType'], 3); // WKNavigationType.reload

        final restored = CreateWindowAction.fromJson(map);
        expect(restored.windowId, 7);
        expect(restored.windowFeatures!.height, 480);
        expect(restored.request.url.toString(), 'https://example.com');
        expect(restored.navigationType, NavigationType.RELOAD);
      });
    });
  });

  group('LoginRequest + enums', () {
    test('LoginRequest round-trip', () {
      final login = LoginRequest(realm: 'realm', account: 'account', args: '');
      final map = login.toJson();
      expect(map['realm'], 'realm');
      expect(map['account'], 'account');
      final restored = LoginRequest.fromJson(map);
      expect(restored.realm, 'realm');
      expect(restored.args, '');
    });

    test('NavigationType string wire still round-trips (name-based)', () {
      withPlatform(TargetPlatform.android, () {
        final action = NavigationAction.fromJson({
          'request': {'url': 'https://example.com'},
          'isForMainFrame': true,
          'navigationType': 'LINK_ACTIVATED',
        });
        expect(action.navigationType, NavigationType.LINK_ACTIVATED);
      });
    });
  });
}
