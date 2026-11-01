import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('Color serialization', () {
    test('plain Color does not crash toJson', () {
      final settings = InAppWebViewSettings(
        verticalScrollbarThumbColor: Color(0xFFF44336),
      );
      final json = settings.toJson();
      expect(json['verticalScrollbarThumbColor'], isA<String>());
      expect(json['verticalScrollbarThumbColor'], equals('#fff44336'));
    });

    test('Color_ round-trips through toJson/fromJson', () {
      final settings = InAppWebViewSettings(
        verticalScrollbarThumbColor: Color_(0xFFF44336),
      );
      final json = settings.toJson();
      expect(json['verticalScrollbarThumbColor'], isA<String>());
      expect(json['verticalScrollbarThumbColor'], equals('#fff44336'));
      final restored = InAppWebViewSettings.fromJson(json);
      expect(restored.verticalScrollbarThumbColor, isNotNull);
      expect(
        restored.verticalScrollbarThumbColor?.value,
        equals(0xFFF44336),
      );
    });
  });
}
