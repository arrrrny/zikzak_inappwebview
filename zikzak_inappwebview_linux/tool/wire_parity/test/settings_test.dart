// ignore_for_file: deprecated_member_use

// InAppWebViewSettings.toMap() is what the native settings parser
// (linux/in_app_webview/in_app_webview_settings.cc) reads.
import 'dart:typed_data';

import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart' as u;
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart' as z;

import 'settings_enums.dart';
import 'support.dart';

/// Shared keys whose value is an enum (or a list/set of enums). Each one is
/// compared once per enum value in the `enums` test below.
const _enumKeys = <String>{
  'cacheMode',
  'contentInsetAdjustmentBehavior',
  'dataDetectorTypes',
  'decelerationRate',
  'disabledActionModeMenuItems',
  'forceDark',
  'forceDarkStrategy',
  'iframeReferrerPolicy',
  'iframeSandbox',
  'layoutAlgorithm',
  'mixedContentMode',
  'overScrollMode',
  'preferredContentMode',
  'rendererPriorityPolicy',
  'scrollBarStyle',
  'selectionGranularity',
  'verticalScrollbarPosition',
};

/// Shared keys that cannot be built from a plain wire value, with the reason.
const _skippedKeys = <String, String>{
  'contentBlockers': 'a list of ContentBlocker objects; compared in the contentBlockers test below',
  'webViewAssetLoader': 'Android-only; a structured WebViewAssetLoader with a different class on each side, never read by Linux native',
};

/// Values for shared settings that are null by default (so they cannot be
/// flipped), as wire values both fromMap/fromJson accept.
final _nullDefaultValues = <String, Object?>{
  'allowingReadAccessTo': 'file:///tmp/',
  'defaultVideoPoster': Uint8List.fromList([1, 2]),
  'horizontalScrollbarThumbColor': '#ff010203',
  'horizontalScrollbarTrackColor': '#ff040506',
  'verticalScrollbarThumbColor': '#ff070809',
  'verticalScrollbarTrackColor': '#ff0a0b0c',
  'underPageBackgroundColor': '#ff0d0e0f',
  'iframeAllow': 'camera',
  'iframeAllowFullscreen': true,
  'iframeCsp': "default-src 'self'",
  'iframeName': 'frame',
  'maximumViewportInset': {'left': 5.0, 'top': 6.0, 'right': 7.0, 'bottom': 8.0},
  'minimumViewportInset': {'left': 1.0, 'top': 2.0, 'right': 3.0, 'bottom': 4.0},
  'mediaType': 'print',
  'minimumFontSize': 12,
  'networkAvailable': true,
  'regexToCancelSubFramesLoading': 're',
  'requestedWithHeaderOriginAllowList': ['https://a.b'],
  'scrollBarDefaultDelayBeforeFade': 5,
  'scrollBarFadeDuration': 6,
  'useOnDownloadStart': true,
  'useOnLoadResource': true,
  'useOnNavigationResponse': true,
  'useOnRenderProcessGone': true,
  'useShouldInterceptAjaxRequest': true,
  'useShouldInterceptFetchRequest': true,
  'useShouldInterceptRequest': true,
  'useShouldOverrideUrlLoading': true,
  'resourceCustomSchemes': ['custom'],
};

/// A non-default wire value for every shared, non-enum setting: null-default
/// ones come from [_nullDefaultValues], the rest are flipped from upstream's
/// default (bool negated, number plus one, string suffixed).
Map<String, Object?> _nonDefaultScalars(Map<String, Object?> defaults, Iterable<String> keys) {
  final out = <String, Object?>{};
  for (final k in keys) {
    if (_enumKeys.contains(k) || _skippedKeys.containsKey(k)) continue;
    final d = defaults[k];
    if (_nullDefaultValues.containsKey(k)) {
      out[k] = _nullDefaultValues[k];
    } else if (d is bool) {
      out[k] = !d;
    } else if (d is int) {
      out[k] = d + 1;
    } else if (d is double) {
      out[k] = d + 1.0;
    } else if (d is String) {
      out[k] = '${d}x';
    } else if (d is List) {
      out[k] = ['x'];
    }
  }
  return out;
}

void main() {
  registerParityCheck();

  test('shared keys with a non-default value', () {
    final rawA = u.InAppWebViewSettings().toMap();
    final rawB = z.InAppWebViewSettings().toJson();
    final shared = rawA.keys.where(rawB.containsKey).toList()..sort();
    final vals = _nonDefaultScalars(rawA, shared);

    // Every shared key must be accounted for, so a new setting cannot slip by.
    final unaccounted = shared.where((k) => !vals.containsKey(k) && !_enumKeys.contains(k) && !_skippedKeys.containsKey(k)).toList();
    expect(unaccounted, isEmpty, reason: 'shared settings with no non-default test value');

    // Settings are built through fromMap / fromJson so that every key can be
    // set from one table; if either side drops or reshapes a value, that shows
    // up as a DIFF below.
    final a = norm(u.InAppWebViewSettings.fromMap(vals)!.toMap());
    final b = norm(z.InAppWebViewSettings.fromJson(vals).toJson());
    for (final k in vals.keys) {
      expectSame('InAppWebViewSettings.$k', a[k], b[k]);
    }
  });

  test('shared enum-valued keys, every value', () {
    forEachSettingsEnum(<U, Z>(key, uv, zv, mkU, mkZ) {
      expect(_enumKeys, contains(key));
      enumVariants<U, Z>('InAppWebViewSettings.$key', uv, zv,
          (e) => {key: mkU(e).toMap()[key]}, (e) => {key: mkZ(e).toJson()[key]});
    });
  });

  test('contentBlockers', () {
    // Parsed by linux/content_blocker/content_blocker_handler.cc.
    u.ContentBlocker up(u.ContentBlockerTriggerResourceType r, u.ContentBlockerTriggerLoadType l, u.ContentBlockerTriggerLoadContext c, u.ContentBlockerActionType a) => u.ContentBlocker(
          trigger: u.ContentBlockerTrigger(urlFilter: '.*ads.*', ifFrameUrl: ['f'], urlFilterIsCaseSensitive: true, resourceType: [r], ifDomain: ['a.b'], loadType: [l], loadContext: [c]),
          action: u.ContentBlockerAction(type: a, selector: '.ad'),
        );
    z.ContentBlocker zp(z.ContentBlockerTriggerResourceType r, z.ContentBlockerTriggerLoadType l, z.ContentBlockerTriggerLoadContext c, z.ContentBlockerActionType a) => z.ContentBlocker(
          trigger: z.ContentBlockerTrigger(urlFilter: '.*ads.*', ifFrameUrl: ['f'], urlFilterIsCaseSensitive: true, resourceType: [r], ifDomain: ['a.b'], loadType: [l], loadContext: [c]),
          action: z.ContentBlockerAction(type: a, selector: '.ad'),
        );
    final ur = u.ContentBlockerTriggerResourceType.IMAGE;
    final ul = u.ContentBlockerTriggerLoadType.FIRST_PARTY;
    final uc = u.ContentBlockerTriggerLoadContext.TOP_FRAME;
    final ua = u.ContentBlockerActionType.CSS_DISPLAY_NONE;
    final zr = z.ContentBlockerTriggerResourceType.IMAGE;
    final zl = z.ContentBlockerTriggerLoadType.FIRST_PARTY;
    final zc = z.ContentBlockerTriggerLoadContext.TOP_FRAME;
    final za = z.ContentBlockerActionType.CSS_DISPLAY_NONE;
    enumVariants('contentBlockers.resourceType', u.ContentBlockerTriggerResourceType.values, z.ContentBlockerTriggerResourceType.values,
        (e) => up(e, ul, uc, ua).toMap(), (e) => zp(e, zl, zc, za).toMap());
    enumVariants('contentBlockers.loadType', u.ContentBlockerTriggerLoadType.values, z.ContentBlockerTriggerLoadType.values,
        (e) => up(ur, e, uc, ua).toMap(), (e) => zp(zr, e, zc, za).toMap());
    enumVariants('contentBlockers.loadContext', u.ContentBlockerTriggerLoadContext.values, z.ContentBlockerTriggerLoadContext.values,
        (e) => up(ur, ul, e, ua).toMap(), (e) => zp(zr, zl, e, za).toMap());
    enumVariants('contentBlockers.action', u.ContentBlockerActionType.values, z.ContentBlockerActionType.values,
        (e) => up(ur, ul, uc, e).toMap(), (e) => zp(zr, zl, zc, e).toMap());
    // The settings key itself wraps the list.
    expectSame(
      'contentBlockers.inSettings',
      u.InAppWebViewSettings(contentBlockers: [up(ur, ul, uc, ua)]).toMap()['contentBlockers'],
      z.InAppWebViewSettings(contentBlockers: [zp(zr, zl, zc, za)]).toJson()['contentBlockers'],
    );
  });

  test('keys only upstream', () {
    final rawA = u.InAppWebViewSettings().toMap();
    final rawB = z.InAppWebViewSettings().toJson();
    // Keys are compared on the raw maps: a key that is null by default still
    // counts as present, so settings with a null default are listed too.
    final onlyUpstream = rawA.keys.where((k) => !rawB.containsKey(k)).toList()..sort();
    // ignore: avoid_print
    print('Settings keys only upstream: $onlyUpstream');
  });
}
