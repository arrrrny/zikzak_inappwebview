// Wire-format regression tests for enum wire maps that the zorphy migration
// (PR #226) broke, pinned by the kimi review of the migration branch:
//  - WebsiteDataType / ProxySchemeFilter / AttributedStringTextEffectStyle
//    wire maps must match the pre-migration @ExchangeableEnum codegen values.
//  - AndroidResource static factories (anim/layout/id/drawable) must exist on
//    the concrete class (restored post-merge in #230).
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('WebsiteDataType wire map', () {
    test('all values map to their WKWebsiteDataType* strings', () {
      expect(
        websiteDataTypeToWire(WebsiteDataType.WKWebsiteDataTypeFetchCache),
        'WKWebsiteDataTypeFetchCache',
      );
      expect(
        websiteDataTypeToWire(WebsiteDataType.WKWebsiteDataTypeDiskCache),
        'WKWebsiteDataTypeDiskCache',
      );
      expect(
        websiteDataTypeToWire(WebsiteDataType.WKWebsiteDataTypeMemoryCache),
        'WKWebsiteDataTypeMemoryCache',
      );
      expect(
        websiteDataTypeToWire(
          WebsiteDataType.WKWebsiteDataTypeOfflineWebApplicationCache,
        ),
        'WKWebsiteDataTypeOfflineWebApplicationCache',
      );
      expect(
        websiteDataTypeToWire(WebsiteDataType.WKWebsiteDataTypeCookies),
        'WKWebsiteDataTypeCookies',
      );
      expect(
        websiteDataTypeToWire(WebsiteDataType.WKWebsiteDataTypeSessionStorage),
        'WKWebsiteDataTypeSessionStorage',
      );
      expect(
        websiteDataTypeToWire(WebsiteDataType.WKWebsiteDataTypeLocalStorage),
        'WKWebsiteDataTypeLocalStorage',
      );
      expect(
        websiteDataTypeToWire(WebsiteDataType.WKWebsiteDataTypeWebSQLDatabases),
        'WKWebsiteDataTypeWebSQLDatabases',
      );
      expect(
        websiteDataTypeToWire(
          WebsiteDataType.WKWebsiteDataTypeIndexedDBDatabases,
        ),
        'WKWebsiteDataTypeIndexedDBDatabases',
      );
      expect(
        websiteDataTypeToWire(
          WebsiteDataType.WKWebsiteDataTypeServiceWorkerRegistrations,
        ),
        'WKWebsiteDataTypeServiceWorkerRegistrations',
      );
    });

    test('round-trips and rejects unknown wire strings', () {
      for (final value in WebsiteDataType.values) {
        expect(websiteDataTypeFromWire(websiteDataTypeToWire(value)), value);
      }
      expect(websiteDataTypeFromWire('WKWebsiteDataTypeUnknown'), isNull);
    });
  });

  group('ProxySchemeFilter wire map', () {
    test('values map to * / http / https', () {
      expect(proxySchemeFilterToWire(ProxySchemeFilter.MATCH_ALL_SCHEMES), '*');
      expect(proxySchemeFilterToWire(ProxySchemeFilter.MATCH_HTTP), 'http');
      expect(proxySchemeFilterToWire(ProxySchemeFilter.MATCH_HTTPS), 'https');
    });

    test('round-trips values with a wire representation', () {
      for (final value in [
        ProxySchemeFilter.MATCH_ALL_SCHEMES,
        ProxySchemeFilter.MATCH_HTTP,
        ProxySchemeFilter.MATCH_HTTPS,
      ]) {
        expect(
          proxySchemeFilterFromWire(proxySchemeFilterToWire(value)),
          value,
        );
      }
    });

    test('rejects unknown wire strings', () {
      expect(proxySchemeFilterFromWire('ws'), isNull);
      expect(proxySchemeFilterFromWire('wss'), isNull);
      expect(proxySchemeFilterFromWire('ftp'), isNull);
    });
  });

  group('AttributedStringTextEffectStyle wire map', () {
    test('LETTERPRESS_STYLE maps to letterpressStyle', () {
      expect(
        attributedStringTextEffectStyleToWire(
          AttributedStringTextEffectStyle.LETTERPRESS_STYLE,
        ),
        'letterpressStyle',
      );
      expect(
        attributedStringTextEffectStyleFromWire('letterpressStyle'),
        AttributedStringTextEffectStyle.LETTERPRESS_STYLE,
      );
    });

    test('rejects stale wire strings from the broken map', () {
      expect(attributedStringTextEffectStyleFromWire('NONE'), isNull);
      expect(
        attributedStringTextEffectStyleFromWire('LETTERPRESS_STYLE'),
        isNull,
      );
    });

    test('toWire returns null for the default (NONE/null) value', () {
      expect(attributedStringTextEffectStyleToWire(null), isNull);
    });
  });

  group('AndroidResource static factories', () {
    test('anim/layout/id/drawable factories exist on the concrete class', () {
      expect(AndroidResource.anim(name: 'fade_in').defType, 'anim');
      expect(AndroidResource.layout(name: 'activity_main').defType, 'layout');
      expect(AndroidResource.id(name: 'webview').defType, 'id');
      expect(AndroidResource.drawable(name: 'ic_launcher').defType, 'drawable');
    });

    test('factories forward defPackage', () {
      expect(
        AndroidResource.drawable(
          name: 'abc',
          defPackage: 'com.example.app',
        ).defPackage,
        'com.example.app',
      );
    });
  });
}
