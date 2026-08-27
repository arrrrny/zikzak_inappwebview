import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('VirtualHostMapping.fromJson', () {
    test('with null fields returns safe defaults', () {
      final result = VirtualHostMapping.fromJson({
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
      final result = VirtualHostMapping.fromJson(<String, dynamic>{});
      expect(result, isNotNull);
      expect(result!.hostName, '');
      expect(result.folderPath, '');
      expect(result.accessKind, HostResourceAccessKind.allow);
    });

    test('fromJson tolerates unknown wire values', () {
      final result = VirtualHostMapping.fromJson({
        'hostName': 'app.localhost',
        'folderPath': 'C:/assets/web',
        'accessKind': 99,
      });
      expect(result, isNotNull);
    });

    test('with valid values works correctly', () {
      final result = VirtualHostMapping.fromJson({
        'hostName': 'app.localhost',
        'folderPath': 'C:/assets/web',
        'accessKind': 2,
      });
      expect(result, isNotNull);
      expect(result!.hostName, 'app.localhost');
      expect(result.folderPath, 'C:/assets/web');
      expect(result.accessKind, HostResourceAccessKind.allowCors);
    });

    test('toJson round-trip preserves all fields', () {
      final mapping = VirtualHostMapping(
        hostName: 'app.localhost',
        folderPath: 'C:/assets/web',
        accessKind: HostResourceAccessKind.allowCors,
      );
      final restored = VirtualHostMapping.fromJson(mapping.toJson());
      expect(restored, isNotNull);
      expect(restored!.hostName, mapping.hostName);
      expect(restored.folderPath, mapping.folderPath);
      expect(restored.accessKind, mapping.accessKind);
    });
  });

  group('HostResourceAccessKind', () {
    test('native values match WebView2 enum', () {
      expect(HostResourceAccessKind.deny.index, 0);
      expect(HostResourceAccessKind.allow.index, 1);
      expect(HostResourceAccessKind.allowCors.index, 2);
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
      final map = settings.toJson();
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
      final restored = WebViewEnvironmentSettings.fromJson(settings.toJson());
      expect(restored, isNotNull);
      expect(restored!.virtualHostMappings, hasLength(1));
      expect(restored.virtualHostMappings!.single.hostName, 'app.localhost');
      expect(
        restored.virtualHostMappings!.single.accessKind,
        HostResourceAccessKind.allowCors,
      );
    });

    test('fromMap with null virtualHostMappings returns null list', () {
      final restored = WebViewEnvironmentSettings.fromJson(<String, dynamic>{
        'virtualHostMappings': null,
      });
      expect(restored, isNotNull);
      expect(restored!.virtualHostMappings, isNull);
    });
  });
}
