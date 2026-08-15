// Public-API regression tests for the permission + safe-browsing model
// families, migrated from @ExchangeableObject/@ExchangeableEnum codegen to
// Zorphy entities (see PROGRESS.md, Phase 2d).
//
// Pins the CONSUMER-VISIBLE contract:
//   - constructor call shapes (incl. the fork's defaults)
//   - JSON wire format (map keys; WebUri as toString; int enums as their
//     index; PermissionResourceType as its platform-dependent native value —
//     Android resource names / iOS-macOS WKMediaCaptureType raw values)
//   - null/missing-key tolerance of fromJson
//   - copyWith availability (zorphy addition)
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// PermissionResourceType native values are platform-dependent (the old
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
  group('PermissionResponse', () {
    test('default constructor keeps the fork defaults', () {
      final r = PermissionResponse();
      expect(r.resources, const []);
      expect(r.action, PermissionResponseAction.DENY);
    });

    test('toJson emits the fork wire format (Android native values)', () {
      withPlatform(TargetPlatform.android, () {
        final r = PermissionResponse(
          resources: const [
            PermissionResourceType.CAMERA,
            PermissionResourceType.MICROPHONE,
          ],
          action: PermissionResponseAction.GRANT,
        );
        final map = r.toJson();
        expect(map['resources'], [
          'android.webkit.resource.VIDEO_CAPTURE',
          'android.webkit.resource.AUDIO_CAPTURE',
        ]);
        expect(map['action'], 1);
      });
    });

    test('toJson emits the fork wire format (iOS native values)', () {
      withPlatform(TargetPlatform.iOS, () {
        final r = PermissionResponse(
          resources: const [
            PermissionResourceType.CAMERA,
            PermissionResourceType.CAMERA_AND_MICROPHONE,
            PermissionResourceType.DEVICE_ORIENTATION_AND_MOTION,
          ],
          action: PermissionResponseAction.PROMPT,
        );
        final map = r.toJson();
        expect(map['resources'], [0, 2, 'deviceOrientationAndMotion']);
        expect(map['action'], 2);
      });
    });

    test('fromJson is null/missing-key tolerant', () {
      final r = PermissionResponse.fromJson({});
      expect(r.resources, const []);
      expect(r.action, PermissionResponseAction.DENY);
    });

    test('fromJson(toJson) round-trips', () {
      withPlatform(TargetPlatform.android, () {
        final r = PermissionResponse(
          resources: const [PermissionResourceType.MICROPHONE],
          action: PermissionResponseAction.GRANT,
        );
        final back = PermissionResponse.fromJson(r.toJson());
        expect(back.resources, [PermissionResourceType.MICROPHONE]);
        expect(back.action, PermissionResponseAction.GRANT);
      });
    });

    test('copyWith is available (zorphy addition)', () {
      final r = PermissionResponse();
      expect(r.copyWith(action: PermissionResponseAction.GRANT).action,
          PermissionResponseAction.GRANT);
      expect(r.copyWith().action, PermissionResponseAction.DENY);
    });
  });

  group('PermissionRequest', () {
    test('toJson/fromJson round-trip (WebUri + resources + frame)', () {
      withPlatform(TargetPlatform.android, () {
        final r = PermissionRequest(
          origin: WebUri('https://flutter.dev'),
          resources: const [PermissionResourceType.CAMERA],
        );
        final map = r.toJson();
        expect(map['origin'], 'https://flutter.dev');
        expect(map['resources'], ['android.webkit.resource.VIDEO_CAPTURE']);
        expect(map.containsKey('frame'), isTrue);

        final back = PermissionRequest.fromJson(map);
        expect(back.origin?.toString(), 'https://flutter.dev');
        expect(back.resources, [PermissionResourceType.CAMERA]);
        expect(back.frame, isNull);
      });
    });

    test('fromJson is null/missing-key tolerant', () {
      final r = PermissionRequest.fromJson({});
      expect(r.origin, isNull);
      expect(r.resources, const []);
      expect(r.frame, isNull);
    });
  });

  group('SafeBrowsingResponse', () {
    test('default constructor keeps the fork defaults', () {
      final r = SafeBrowsingResponse();
      expect(r.report, isTrue);
      expect(r.action, SafeBrowsingResponseAction.SHOW_INTERSTITIAL);
    });

    test('toJson emits the fork wire format', () {
      final r = SafeBrowsingResponse(
        report: false,
        action: SafeBrowsingResponseAction.PROCEED,
      );
      final map = r.toJson();
      expect(map['report'], false);
      expect(map['action'], 1);
    });

    test('fromJson(toJson) round-trips', () {
      final r = SafeBrowsingResponse(
        report: true,
        action: SafeBrowsingResponseAction.BACK_TO_SAFETY,
      );
      final back = SafeBrowsingResponse.fromJson(r.toJson());
      expect(back.report, isTrue);
      expect(back.action, SafeBrowsingResponseAction.BACK_TO_SAFETY);
    });
  });

  group('GeolocationPermissionShowPromptResponse', () {
    test('default constructor keeps the fork defaults', () {
      final r = GeolocationPermissionShowPromptResponse(
        origin: WebUri('https://flutter.dev'),
        allow: true,
      );
      expect(r.origin?.toString(), 'https://flutter.dev');
      expect(r.allow, isTrue);
      expect(r.retain, isFalse);
    });

    test('toJson/fromJson round-trip', () {
      final r = GeolocationPermissionShowPromptResponse(
        origin: WebUri('https://flutter.dev'),
        allow: true,
        retain: true,
      );
      final map = r.toJson();
      expect(map['origin'], 'https://flutter.dev');
      expect(map['allow'], true);
      expect(map['retain'], true);

      final back = GeolocationPermissionShowPromptResponse.fromJson(map);
      expect(back.origin?.toString(), 'https://flutter.dev');
      expect(back.allow, isTrue);
      expect(back.retain, isTrue);
    });
  });

  group('int enums keep the old native values (index == old _nativeValue)', () {
    test('PermissionResponseAction', () {
      expect(PermissionResponseAction.DENY.index, 0);
      expect(PermissionResponseAction.GRANT.index, 1);
      expect(PermissionResponseAction.PROMPT.index, 2);
    });

    test('SafeBrowsingResponseAction', () {
      expect(SafeBrowsingResponseAction.BACK_TO_SAFETY.index, 0);
      expect(SafeBrowsingResponseAction.PROCEED.index, 1);
      expect(SafeBrowsingResponseAction.SHOW_INTERSTITIAL.index, 2);
    });

    test('SafeBrowsingThreat', () {
      expect(SafeBrowsingThreat.SAFE_BROWSING_THREAT_UNKNOWN.index, 0);
      expect(SafeBrowsingThreat.SAFE_BROWSING_THREAT_MALWARE.index, 1);
      expect(SafeBrowsingThreat.SAFE_BROWSING_THREAT_PHISHING.index, 2);
      expect(SafeBrowsingThreat.SAFE_BROWSING_THREAT_UNWANTED_SOFTWARE.index, 3);
      expect(SafeBrowsingThreat.SAFE_BROWSING_THREAT_BILLING.index, 4);
    });
  });

  group('PermissionResourceType native-value mapping (per platform)', () {
    test('Android sends android.webkit.resource.* names', () {
      withPlatform(TargetPlatform.android, () {
        final r = PermissionResponse(resources: const [
          PermissionResourceType.CAMERA,
          PermissionResourceType.MICROPHONE,
          PermissionResourceType.MIDI_SYSEX,
          PermissionResourceType.PROTECTED_MEDIA_ID,
        ]);
        expect(r.toJson()['resources'], [
          'android.webkit.resource.VIDEO_CAPTURE',
          'android.webkit.resource.AUDIO_CAPTURE',
          'android.webkit.resource.MIDI_SYSEX',
          'android.webkit.resource.PROTECTED_MEDIA_ID',
        ]);
        final back = PermissionResponse.fromJson(r.toJson());
        expect(back.resources, const [
          PermissionResourceType.CAMERA,
          PermissionResourceType.MICROPHONE,
          PermissionResourceType.MIDI_SYSEX,
          PermissionResourceType.PROTECTED_MEDIA_ID,
        ]);
      });
    });

    test('iOS/macOS send WKMediaCaptureType raw values', () {
      withPlatform(TargetPlatform.macOS, () {
        final r = PermissionResponse(resources: const [
          PermissionResourceType.CAMERA,
          PermissionResourceType.MICROPHONE,
          PermissionResourceType.CAMERA_AND_MICROPHONE,
        ]);
        expect(r.toJson()['resources'], [0, 1, 2]);
        final back = PermissionResponse.fromJson(r.toJson());
        expect(back.resources, const [
          PermissionResourceType.CAMERA,
          PermissionResourceType.MICROPHONE,
          PermissionResourceType.CAMERA_AND_MICROPHONE,
        ]);
      });
    });

    test('unknown native values map to null and are dropped', () {
      withPlatform(TargetPlatform.android, () {
        final r = PermissionResponse.fromJson({
          'resources': ['android.webkit.resource.VIDEO_CAPTURE', 'bogus'],
        });
        expect(r.resources, [PermissionResourceType.CAMERA]);
      });
    });
  });
}
