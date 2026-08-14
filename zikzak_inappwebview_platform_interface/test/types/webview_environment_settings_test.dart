import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('VirtualHostMapping.fromMap', () {
    test('with null fields returns safe defaults', () {
      final result = VirtualHostMapping.fromMap({
        'hostName': null,
        'folderPath': null,
        'accessKind': null,
      });
      expect(result, isNotNull);
      expect(result!.hostName, '');
      expect(result.folderPath, '');
      expect(result.accessKind, HostResourceAccessKind.allow);
    });

    test('with empty map returns safe defaults', () {
      final result = VirtualHostMapping.fromMap(<String, dynamic>{});
      expect(result, isNotNull);
      expect(result!.hostName, '');
      expect(result.folderPath, '');
      expect(result.accessKind, HostResourceAccessKind.allow);
    });

    test('with completely null map returns null', () {
      final result = VirtualHostMapping.fromMap(null);
      expect(result, isNull);
    });

    test('with valid values works correctly', () {
      final result = VirtualHostMapping.fromMap({
        'hostName': 'app.localhost',
        'folderPath': 'C:/assets/web',
        'accessKind': 2,
      });
      expect(result, isNotNull);
      expect(result!.hostName, 'app.localhost');
      expect(result.folderPath, 'C:/assets/web');
      expect(result.accessKind, HostResourceAccessKind.allowCors);
    });

    test('toMap round-trip preserves all fields', () {
      final mapping = VirtualHostMapping(
        hostName: 'app.localhost',
        folderPath: 'C:/assets/web',
        accessKind: HostResourceAccessKind.allowCors,
      );
      final restored = VirtualHostMapping.fromMap(mapping.toMap());
      expect(restored, isNotNull);
      expect(restored!.hostName, mapping.hostName);
      expect(restored.folderPath, mapping.folderPath);
      expect(restored.accessKind, mapping.accessKind);
    });
  });

  group('HostResourceAccessKind', () {
    test('native values match WebView2 enum', () {
      expect(HostResourceAccessKind.deny.toNativeValue(), 0);
      expect(HostResourceAccessKind.allow.toNativeValue(), 1);
      expect(HostResourceAccessKind.allowCors.toNativeValue(), 2);
    });
  });

  group('WebViewEnvironmentSettings', () {
    test('toMap includes virtualHostMappings', () {
      final settings = WebViewEnvironmentSettings(
        virtualHostMappings: [
          VirtualHostMapping(
            hostName: 'app.localhost',
            folderPath: 'C:/assets/web',
            accessKind: HostResourceAccessKind.allowCors,
          ),
        ],
      );
      final map = settings.toMap();
      expect(map['virtualHostMappings'], isA<List<Map<String, dynamic>>>());
      final mappings = map['virtualHostMappings'] as List<Map<String, dynamic>>;
      expect(mappings.single['hostName'], 'app.localhost');
      expect(mappings.single['accessKind'], 2);
    });

    test('fromMap restores virtualHostMappings', () {
      final settings = WebViewEnvironmentSettings(
        virtualHostMappings: [
          VirtualHostMapping(
            hostName: 'app.localhost',
            folderPath: 'C:/assets/web',
            accessKind: HostResourceAccessKind.allowCors,
          ),
        ],
      );
      final restored = WebViewEnvironmentSettings.fromMap(settings.toMap());
      expect(restored, isNotNull);
      expect(restored!.virtualHostMappings, hasLength(1));
      expect(restored.virtualHostMappings!.single.hostName, 'app.localhost');
      expect(
        restored.virtualHostMappings!.single.accessKind,
        HostResourceAccessKind.allowCors,
      );
    });

    test('fromMap with null virtualHostMappings returns null list', () {
      final restored = WebViewEnvironmentSettings.fromMap(<String, dynamic>{
        'virtualHostMappings': null,
      });
      expect(restored, isNotNull);
      expect(restored!.virtualHostMappings, isNull);
    });
  });
}
