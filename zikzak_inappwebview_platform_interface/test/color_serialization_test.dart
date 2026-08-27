import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('Color serialization', () {
    test('plain Color does not crash toJson', () {
      final settings = InAppWebViewSettings(
        verticalScrollbarThumbColor: Colors.red,
      );
      final json = settings.toJson();
      expect(json['verticalScrollbarThumbColor'], isA<String>());
    });

    test('Color_ round-trips through toJson/fromJson', () {
      final settings = InAppWebViewSettings(
        verticalScrollbarThumbColor: Color_(Colors.red.value),
      );
      final json = settings.toJson();
      expect(json['verticalScrollbarThumbColor'], isA<String>());
      final restored = InAppWebViewSettings.fromJson(json);
      expect(restored.verticalScrollbarThumbColor, isNotNull);
    });
  });
}
