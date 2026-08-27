// Public-API regression tests for the pull_to_refresh + web_storage families,
// migrated from @ExchangeableObject/@ExchangeableEnum codegen to Zorphy
// entities (see PROGRESS.md, Phase 3a).
//
// Pins the CONSUMER-VISIBLE contract:
//   - constructor call shapes (incl. the fork's defaults)
//   - JSON wire format (map keys; PullToRefreshSize as its NON-sequential
//     wire ints DEFAULT=1 / LARGE=0; Color_ as hex string; AttributedString
//     as nested map; WebStorageType as its 'localStorage'/'sessionStorage'
//     strings)
//   - null/missing-key tolerance of fromJson
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('PullToRefreshSettings', () {
    test('enabled defaults to true', () {
      final settings = PullToRefreshSettings();
      expect(settings.enabled, isTrue);
    });

    test('size wire is NON-sequential (DEFAULT=1, LARGE=0)', () {
      expect(pullToRefreshSizeToWire(PullToRefreshSize.DEFAULT), 1);
      expect(pullToRefreshSizeToWire(PullToRefreshSize.LARGE), 0);

      final settings = PullToRefreshSettings(size: PullToRefreshSize.LARGE);
      expect(settings.toJson()['size'], 0);

      final restored = PullToRefreshSettings.fromJson({'size': 1});
      expect(restored.size, PullToRefreshSize.DEFAULT);
    });

    test('color round-trips as hex string', () {
      final settings = PullToRefreshSettings(
        color: Color_(0xFF112233),
        backgroundColor: Color_(0xFF445566),
      );
      final map = settings.toJson();
      expect(map['color'], '#ff112233');
      expect(map['backgroundColor'], '#ff445566');

      final restored = PullToRefreshSettings.fromJson(map);
      expect(restored.color, isNotNull);
      expect(restored.color!.value, 0xFF112233);
      expect(restored.backgroundColor!.value, 0xFF445566);
    });

    test('attributedTitle round-trips as nested map', () {
      final settings = PullToRefreshSettings(
        attributedTitle: AttributedString(string: 'Pull to refresh'),
      );
      final map = settings.toJson();
      expect((map['attributedTitle'] as Map)['string'], 'Pull to refresh');

      final restored = PullToRefreshSettings.fromJson(map);
      expect(restored.attributedTitle!.string, 'Pull to refresh');
    });
  });

  group('WebStorageItem', () {
    test('key/value round-trip (dynamic value)', () {
      final item = WebStorageItem(key: 'k', value: 'v');
      final map = item.toJson();
      expect(map['key'], 'k');
      expect(map['value'], 'v');

      final restored = WebStorageItem.fromJson(map);
      expect(restored.key, 'k');
      expect(restored.value, 'v');
    });
  });

  group('WebStorageOrigin', () {
    test('origin/quota/usage round-trip', () {
      final origin = WebStorageOrigin(
        origin: 'https://example.com',
        quota: 100,
        usage: 42,
      );
      final map = origin.toJson();
      expect(map['origin'], 'https://example.com');
      expect(map['quota'], 100);
      expect(map['usage'], 42);

      final restored = WebStorageOrigin.fromJson(map);
      expect(restored.usage, 42);
    });
  });

  group('WebStorageType', () {
    test('wire strings are the JS storage names', () {
      expect(
        webStorageTypeToWire(WebStorageType.LOCAL_STORAGE),
        'localStorage',
      );
      expect(
        webStorageTypeToWire(WebStorageType.SESSION_STORAGE),
        'sessionStorage',
      );
    });
  });
}
