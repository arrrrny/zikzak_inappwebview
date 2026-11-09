// ignore_for_file: deprecated_member_use

import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart' as u;
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart' as z;

typedef SettingsVariantVisitor = void Function<U, Z>(
  String key,
  Iterable<U> uv,
  Iterable<Z> zv,
  u.InAppWebViewSettings Function(U) mkU,
  z.InAppWebViewSettings Function(Z) mkZ,
);

/// Calls [variants] once per shared enum-valued InAppWebViewSettings key, with
/// builders that set that key to one enum value.
void forEachSettingsEnum(SettingsVariantVisitor variants) {
    variants('cacheMode', u.CacheMode.values, z.CacheMode.values, (e) => u.InAppWebViewSettings(cacheMode: e), (e) => z.InAppWebViewSettings(cacheMode: e));
    variants('contentInsetAdjustmentBehavior', u.ScrollViewContentInsetAdjustmentBehavior.values, z.ScrollViewContentInsetAdjustmentBehavior.values,
        (e) => u.InAppWebViewSettings(contentInsetAdjustmentBehavior: e), (e) => z.InAppWebViewSettings(contentInsetAdjustmentBehavior: e));
    variants('dataDetectorTypes', u.DataDetectorTypes.values, z.DataDetectorTypes.values,
        (e) => u.InAppWebViewSettings(dataDetectorTypes: [e]), (e) => z.InAppWebViewSettings(dataDetectorTypes: [e]));
    variants('decelerationRate', u.ScrollViewDecelerationRate.values, z.ScrollViewDecelerationRate.values,
        (e) => u.InAppWebViewSettings(decelerationRate: e), (e) => z.InAppWebViewSettings(decelerationRate: e));
    variants('disabledActionModeMenuItems', u.ActionModeMenuItem.values, z.ActionModeMenuItem.values,
        (e) => u.InAppWebViewSettings(disabledActionModeMenuItems: e), (e) => z.InAppWebViewSettings(disabledActionModeMenuItems: e));
    variants('forceDark', u.ForceDark.values, z.ForceDark.values, (e) => u.InAppWebViewSettings(forceDark: e), (e) => z.InAppWebViewSettings(forceDark: e));
    variants('forceDarkStrategy', u.ForceDarkStrategy.values, z.ForceDarkStrategy.values,
        (e) => u.InAppWebViewSettings(forceDarkStrategy: e), (e) => z.InAppWebViewSettings(forceDarkStrategy: e));
    variants('iframeReferrerPolicy', u.ReferrerPolicy.values, z.ReferrerPolicy.values,
        (e) => u.InAppWebViewSettings(iframeReferrerPolicy: e), (e) => z.InAppWebViewSettings(iframeReferrerPolicy: e));
    variants('iframeSandbox', u.Sandbox.values, z.Sandbox.values,
        (e) => u.InAppWebViewSettings(iframeSandbox: {e}), (e) => z.InAppWebViewSettings(iframeSandbox: {e}));
    variants('layoutAlgorithm', u.LayoutAlgorithm.values, z.LayoutAlgorithm.values,
        (e) => u.InAppWebViewSettings(layoutAlgorithm: e), (e) => z.InAppWebViewSettings(layoutAlgorithm: e));
    variants('mixedContentMode', u.MixedContentMode.values, z.MixedContentMode.values,
        (e) => u.InAppWebViewSettings(mixedContentMode: e), (e) => z.InAppWebViewSettings(mixedContentMode: e));
    variants('overScrollMode', u.OverScrollMode.values, z.OverScrollMode.values,
        (e) => u.InAppWebViewSettings(overScrollMode: e), (e) => z.InAppWebViewSettings(overScrollMode: e));
    variants('preferredContentMode', u.UserPreferredContentMode.values, z.UserPreferredContentMode.values,
        (e) => u.InAppWebViewSettings(preferredContentMode: e), (e) => z.InAppWebViewSettings(preferredContentMode: e));
    variants('rendererPriorityPolicy', u.RendererPriority.values, z.RendererPriority.values,
        (e) => u.InAppWebViewSettings(rendererPriorityPolicy: u.RendererPriorityPolicy(rendererRequestedPriority: e, waivedWhenNotVisible: true)),
        (e) => z.InAppWebViewSettings(rendererPriorityPolicy: z.RendererPriorityPolicy(rendererRequestedPriority: e, waivedWhenNotVisible: true)));
    variants('scrollBarStyle', u.ScrollBarStyle.values, z.ScrollBarStyle.values,
        (e) => u.InAppWebViewSettings(scrollBarStyle: e), (e) => z.InAppWebViewSettings(scrollBarStyle: e));
    variants('selectionGranularity', u.SelectionGranularity.values, z.SelectionGranularity.values,
        (e) => u.InAppWebViewSettings(selectionGranularity: e), (e) => z.InAppWebViewSettings(selectionGranularity: e));
    variants('verticalScrollbarPosition', u.VerticalScrollbarPosition.values, z.VerticalScrollbarPosition.values,
        (e) => u.InAppWebViewSettings(verticalScrollbarPosition: e), (e) => z.InAppWebViewSettings(verticalScrollbarPosition: e));
}
