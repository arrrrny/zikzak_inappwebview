// Public-API regression tests for the android-side valueObjects + enums
// (Zorphy entities). Pins the consumer-visible contract:
//   - constructor shapes (required fields throw on missing keys in fromJson)
//   - JSON wire format (WebUri as toString; enum index ints; ProxyRule
//     schemeFilter as native strings; RenderProcessGoneDetail priority int)
//   - static factories (AndroidResource.anim/layout/id/drawable)
//   - enum index == old native value for sequential enums
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('AndroidResource', () {
    // NOTE: the static factories anim/layout/id/drawable live only on the
    // abstract $AndroidResource class and were NOT carried onto the concrete
    // zorphy class — a migration regression (the example still compiles only
    // because it resolves the published 4.10.0 platform_interface). See
    // PROGRESS.md anomalies.
    test('constructor + toJson/fromJson round-trip', () {
      final r = AndroidResource(name: 'ic_launcher', defType: 'drawable');
      expect(r.toJson(), {'name': 'ic_launcher', 'defType': 'drawable', 'defPackage': null});
      final back = AndroidResource.fromJson(r.toJson());
      expect(back.name, 'ic_launcher');
      expect(back.defType, 'drawable');
      // name is required.
      expect(() => AndroidResource.fromJson({}), throwsA(anything));
    });
  });

  group('ActivityButton', () {
    test('toJson nests UIImage + required fields', () {
      final b = ActivityButton(
        templateImage: UIImage(name: 'share.png'),
        extensionIdentifier: 'com.app.share',
      );
      expect(b.toJson(), {
        'templateImage': {'name': 'share.png', 'systemName': null, 'data': null},
        'extensionIdentifier': 'com.app.share',
      });
      expect(() => ActivityButton.fromJson({}), throwsA(anything));
      final back = ActivityButton.fromJson(b.toJson());
      expect(back.extensionIdentifier, 'com.app.share');
      expect(back.templateImage.name, 'share.png');
    });
  });

  group('UIEventAttribution', () {
    test('wire: destinationURL as string', () {
      final e = UIEventAttribution(
        sourceIdentifier: 7,
        destinationURL: WebUri('https://attrib.dev/click'),
        sourceDescription: 'src',
        purchaser: 'acme',
      );
      expect(e.toJson(), {
        'sourceIdentifier': 7,
        'destinationURL': 'https://attrib.dev/click',
        'sourceDescription': 'src',
        'purchaser': 'acme',
      });
      expect(() => UIEventAttribution.fromJson({}), throwsA(anything));
      final back = UIEventAttribution.fromJson(e.toJson());
      expect(back.destinationURL.toString(), 'https://attrib.dev/click');
      expect(back.sourceIdentifier, 7);
    });
  });

  group('RenderProcessGoneDetail', () {
    test('wire: priority as int index', () {
      final d = RenderProcessGoneDetail(
        didCrash: true,
        rendererPriorityAtExit: RendererPriority.RENDERER_PRIORITY_IMPORTANT,
      );
      expect(d.toJson(), {'didCrash': true, 'rendererPriorityAtExit': 2});
      final back = RenderProcessGoneDetail.fromJson(d.toJson());
      expect(back.didCrash, true);
      expect(back.rendererPriorityAtExit,
          RendererPriority.RENDERER_PRIORITY_IMPORTANT);
      final none = RenderProcessGoneDetail.fromJson({'didCrash': false});
      expect(none.rendererPriorityAtExit, isNull);
    });
  });

  group('RendererPriorityPolicy', () {
    test('wire + defaults', () {
      final p = RendererPriorityPolicy(
        rendererRequestedPriority: RendererPriority.RENDERER_PRIORITY_BOUND,
        waivedWhenNotVisible: true,
      );
      expect(p.toJson(), {'rendererRequestedPriority': 1, 'waivedWhenNotVisible': true});
      final back = RendererPriorityPolicy.fromJson(p.toJson());
      expect(back.rendererRequestedPriority,
          RendererPriority.RENDERER_PRIORITY_BOUND);
      expect(back.waivedWhenNotVisible, true);
    });
  });

  group('ProxyRule', () {
    // NOTE: ProxySchemeFilter is dead API surface (unused across the monorepo).
    // Its wire map ['http','https','ws','wss'] has 4 entries for 3 enum values,
    // so MATCH_HTTPS round-trips as 'ws' and fromWire('wss') throws a
    // RangeError — an anomaly pinned as-is, to revisit during the zfa migration.
    test('wire: schemeFilter native strings (current mapping)', () {
      final r = ProxyRule(
        url: WebUri('https://proxy.dev:8080'),
        schemeFilter: ProxySchemeFilter.MATCH_HTTP,
      );
      expect(r.toJson(), {
        'url': 'https://proxy.dev:8080',
        'schemeFilter': 'https',
      });
      final back = ProxyRule.fromJson(r.toJson());
      expect(back.url.toString(), 'https://proxy.dev:8080');
      expect(back.schemeFilter, ProxySchemeFilter.MATCH_HTTP);
      expect(ProxyRule.fromJson({'url': 'https://x.dev'}).schemeFilter, isNull);
      // current (anomalous) mappings, pinned for the conformance suite:
      expect(ProxyRule(url: WebUri('https://x.dev'), schemeFilter: ProxySchemeFilter.MATCH_ALL_SCHEMES).toJson()['schemeFilter'], 'http');
      expect(ProxyRule(url: WebUri('https://x.dev'), schemeFilter: ProxySchemeFilter.MATCH_HTTPS).toJson()['schemeFilter'], 'ws');
      // fromWire('wss') hits values[3] of a 3-value enum → wrapped RangeError.
      expect(() => ProxyRule.fromJson({'url': 'https://x.dev', 'schemeFilter': 'wss'}), throwsA(anything));
    });
  });

  group('sequential enums (wire == index)', () {
    test('RendererPriority', () {
      expect(RendererPriority.RENDERER_PRIORITY_WAIVED.index, 0);
      expect(RendererPriority.RENDERER_PRIORITY_BOUND.index, 1);
      expect(RendererPriority.RENDERER_PRIORITY_IMPORTANT.index, 2);
    });

    test('OverScrollMode', () {
      expect(OverScrollMode.ALWAYS.index, 0);
      expect(OverScrollMode.IF_CONTENT_SCROLLS.index, 1);
      expect(OverScrollMode.NEVER.index, 2);
    });

    test('LayoutAlgorithm', () {
      expect(LayoutAlgorithm.NORMAL.index, 0);
      expect(LayoutAlgorithm.TEXT_AUTOSIZING.index, 1);
      expect(LayoutAlgorithm.NARROW_COLUMNS.index, 2);
    });

    test('LayoutInDisplayCutoutMode', () {
      expect(LayoutInDisplayCutoutMode.DEFAULT.index, 0);
      expect(LayoutInDisplayCutoutMode.SHORT_EDGES.index, 1);
      expect(LayoutInDisplayCutoutMode.NEVER.index, 2);
      expect(LayoutInDisplayCutoutMode.ALWAYS.index, 3);
    });

    test('MixedContentMode', () {
      expect(MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW.index, 0);
      expect(MixedContentMode.MIXED_CONTENT_NEVER_ALLOW.index, 1);
      expect(MixedContentMode.MIXED_CONTENT_COMPATIBILITY_MODE.index, 2);
    });

    test('CompressFormat', () {
      expect(CompressFormat.PNG.index, 0);
      expect(CompressFormat.JPEG.index, 1);
      expect(CompressFormat.WEBP.index, 2);
      expect(CompressFormat.WEBP_LOSSY.index, 3);
      expect(CompressFormat.WEBP_LOSSLESS.index, 4);
    });

    test('TracingMode', () {
      expect(TracingMode.RECORD_UNTIL_FULL.index, 0);
      expect(TracingMode.RECORD_CONTINUOUSLY.index, 1);
    });
  });

  group('TracingCategory wire (bitmask list [1,2,64,8,32,0,16,4])', () {
    test('wire helper round-trips', () {
      expect(tracingCategoryToWire(TracingCategory.CATEGORIES_ALL), 1);
      expect(tracingCategoryToWire(TracingCategory.CATEGORIES_ANDROID_WEBVIEW), 2);
      expect(tracingCategoryToWire(TracingCategory.CATEGORIES_FRAME_VIEWER), 64);
      expect(tracingCategoryToWire(TracingCategory.CATEGORIES_INPUT_LATENCY), 8);
      expect(
        tracingCategoryToWire(TracingCategory.CATEGORIES_JAVASCRIPT_AND_RENDERING),
        32,
      );
      expect(tracingCategoryToWire(TracingCategory.CATEGORIES_RENDERING), 16);
      expect(tracingCategoryToWire(TracingCategory.CATEGORIES_WEB_DEVELOPER), 4);
      expect(tracingCategoryFromWire(64), TracingCategory.CATEGORIES_FRAME_VIEWER);
      expect(tracingCategoryFromWire(999), isNull);
      expect(tracingCategoryFromWire('x'), isNull);
    });
  });

  group('WebViewRenderProcessAction', () {
    test('wire + helper', () {
      expect(WebViewRenderProcessAction.TERMINATE.index, 0);
      expect(webViewRenderProcessActionToWire(WebViewRenderProcessAction.TERMINATE), 0);
      expect(webViewRenderProcessActionFromWire(0),
          WebViewRenderProcessAction.TERMINATE);
      expect(webViewRenderProcessActionFromWire(5), isNull);
    });
  });

  group('Sandbox wire (enum index -> iframe token strings)', () {
    test('indexes match the wire tokens', () {
      // wire list: ['null','','allow-all','allow-none','allow-downloads',...]
      expect(Sandbox.ALLOW_ALL.index, 2);
      expect(Sandbox.ALLOW_NONE.index, 3);
      expect(Sandbox.ALLOW_DOWNLOADS.index, 4);
      expect(Sandbox.ALLOW_FORMS.index, 5);
      expect(Sandbox.ALLOW_MODALS.index, 6);
      expect(Sandbox.ALLOW_POPUPS.index, 9);
      expect(Sandbox.ALLOW_SAME_ORIGIN.index, 12);
      expect(Sandbox.ALLOW_SCRIPTS.index, 13);
      expect(Sandbox.ALLOW_TOP_NAVIGATION.index, 14);
      expect(Sandbox.ALLOW_TOP_NAVIGATION_BY_USER_ACTIVATION.index, 15);
    });
  });
}
