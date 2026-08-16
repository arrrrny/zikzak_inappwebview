// Public-API regression tests for the remaining wire-form enums (Zorphy
// entities). Pins each enum's wire contract (index int, native string, or
// explicit wire list) as shipped — the conformance contract for the zfa
// migration. Two upstream bugs found + fixed while writing these are noted
// inline (content_blocker_trigger_load_context reversed list, website_data_type
// truncated list — see PROGRESS.md).
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('ContentBlockerActionType (native strings)', () {
    test('wire round-trips', () {
      expect(contentBlockerActionTypeToWire(ContentBlockerActionType.BLOCK), 'block');
      expect(
        contentBlockerActionTypeToWire(ContentBlockerActionType.CSS_DISPLAY_NONE),
        'css-display-none',
      );
      expect(
        contentBlockerActionTypeToWire(ContentBlockerActionType.MAKE_HTTPS),
        'make-https',
      );
      expect(
        contentBlockerActionTypeToWire(ContentBlockerActionType.BLOCK_COOKIES),
        'block-cookies',
      );
      expect(
        contentBlockerActionTypeToWire(ContentBlockerActionType.IGNORE_PREVIOUS_RULES),
        'ignore-previous-rules',
      );
      expect(
        contentBlockerActionTypeFromWire('make-https'),
        ContentBlockerActionType.MAKE_HTTPS,
      );
      expect(contentBlockerActionTypeFromWire('bogus'), isNull);
    });
  });

  group('ContentBlockerTriggerLoadType (native strings)', () {
    test('wire round-trips', () {
      expect(
        contentBlockerTriggerLoadTypeToWire(ContentBlockerTriggerLoadType.FIRST_PARTY),
        'first-party',
      );
      expect(
        contentBlockerTriggerLoadTypeToWire(ContentBlockerTriggerLoadType.THIRD_PARTY),
        'third-party',
      );
      expect(
        contentBlockerTriggerLoadTypeFromWire('third-party'),
        ContentBlockerTriggerLoadType.THIRD_PARTY,
      );
    });
  });

  group('ContentBlockerTriggerResourceType (native strings)', () {
    test('wire round-trips', () {
      expect(
        contentBlockerTriggerResourceTypeToWire(ContentBlockerTriggerResourceType.DOCUMENT),
        'document',
      );
      expect(
        contentBlockerTriggerResourceTypeToWire(ContentBlockerTriggerResourceType.SVG_DOCUMENT),
        'svg-document',
      );
      expect(
        contentBlockerTriggerResourceTypeToWire(ContentBlockerTriggerResourceType.RAW),
        'raw',
      );
      expect(contentBlockerTriggerResourceTypeFromWire('media'),
          ContentBlockerTriggerResourceType.MEDIA);
      expect(contentBlockerTriggerResourceTypeFromWire('bogus'), isNull);
    });
  });

  group('ContentBlockerTriggerLoadContext (native strings, FIXED wire)', () {
    test('wire matches upstream (TOP_FRAME -> top-frame)', () {
      expect(
        contentBlockerTriggerLoadContextToWire(ContentBlockerTriggerLoadContext.TOP_FRAME),
        'top-frame',
      );
      expect(
        contentBlockerTriggerLoadContextToWire(ContentBlockerTriggerLoadContext.CHILD_FRAME),
        'child-frame',
      );
      expect(
        contentBlockerTriggerLoadContextFromWire('top-frame'),
        ContentBlockerTriggerLoadContext.TOP_FRAME,
      );
      expect(
        contentBlockerTriggerLoadContextFromWire('child-frame'),
        ContentBlockerTriggerLoadContext.CHILD_FRAME,
      );
      expect(contentBlockerTriggerLoadContextFromWire('x'), isNull);
    });
  });

  group('ForceDark + ForceDarkStrategy (index)', () {
    test('indexes are the wire', () {
      expect(ForceDark.OFF.index, 0);
      expect(ForceDark.AUTO.index, 1);
      expect(ForceDark.ON.index, 2);
      expect(ForceDarkStrategy.USER_AGENT_DARKENING_ONLY.index, 0);
      expect(ForceDarkStrategy.WEB_THEME_DARKENING_ONLY.index, 1);
      expect(ForceDarkStrategy.PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING.index, 2);
    });
  });

  group('FormResubmissionAction + NavigationActionPolicy + NavigationResponseAction', () {
    test('indexes are the wire', () {
      expect(FormResubmissionAction.RESEND.index, 0);
      expect(FormResubmissionAction.DONT_RESEND.index, 1);
      expect(NavigationActionPolicy.CANCEL.index, 0);
      expect(NavigationActionPolicy.ALLOW.index, 1);
      expect(NavigationActionPolicy.DOWNLOAD.index, 2);
      expect(NavigationResponseAction.CANCEL.index, 0);
      expect(NavigationResponseAction.ALLOW.index, 1);
      expect(NavigationResponseAction.DOWNLOAD.index, 2);
    });
  });

  group('ActionModeMenuItem wire [0,1,2,4]', () {
    test('wire round-trips', () {
      expect(actionModeMenuItemToWire(ActionModeMenuItem.MENU_ITEM_NONE), 0);
      expect(actionModeMenuItemToWire(ActionModeMenuItem.MENU_ITEM_SHARE), 1);
      expect(actionModeMenuItemToWire(ActionModeMenuItem.MENU_ITEM_WEB_SEARCH), 2);
      expect(actionModeMenuItemToWire(ActionModeMenuItem.MENU_ITEM_PROCESS_TEXT), 4);
      expect(actionModeMenuItemFromWire(4), ActionModeMenuItem.MENU_ITEM_PROCESS_TEXT);
      expect(actionModeMenuItemFromWire(3), isNull);
    });
  });

  group('CacheMode wire [-1,1,2,3]', () {
    test('wire round-trips', () {
      expect(cacheModeToWire(CacheMode.LOAD_DEFAULT), -1);
      expect(cacheModeToWire(CacheMode.LOAD_CACHE_ELSE_NETWORK), 1);
      expect(cacheModeToWire(CacheMode.LOAD_NO_CACHE), 2);
      expect(cacheModeToWire(CacheMode.LOAD_CACHE_ONLY), 3);
      expect(cacheModeFromWire(-1), CacheMode.LOAD_DEFAULT);
      expect(cacheModeFromWire(2), CacheMode.LOAD_NO_CACHE);
      expect(cacheModeFromWire(0), isNull);
    });
  });

  group('InAppWebViewHitTestResultType wire [0,2,3,4,5,7,8,9]', () {
    test('wire round-trips', () {
      expect(inAppWebViewHitTestResultTypeToWire(InAppWebViewHitTestResultType.UNKNOWN_TYPE), 0);
      expect(inAppWebViewHitTestResultTypeToWire(InAppWebViewHitTestResultType.SRC_ANCHOR_TYPE), 7);
      expect(inAppWebViewHitTestResultTypeToWire(InAppWebViewHitTestResultType.SRC_IMAGE_ANCHOR_TYPE), 8);
      expect(inAppWebViewHitTestResultTypeToWire(InAppWebViewHitTestResultType.EDIT_TEXT_TYPE), 9);
      expect(inAppWebViewHitTestResultTypeFromWire(5), InAppWebViewHitTestResultType.IMAGE_TYPE);
      expect(inAppWebViewHitTestResultTypeFromWire(1), isNull);
    });
  });

  group('DataDetectorTypes (name strings)', () {
    test('wire is the enum name', () {
      expect(DataDetectorTypes.NONE.name, 'NONE');
      expect(DataDetectorTypes.PHONE_NUMBER.name, 'PHONE_NUMBER');
      expect(DataDetectorTypes.ALL.name, 'ALL');
      expect(DataDetectorTypes.FLIGHT_NUMBER.name, 'FLIGHT_NUMBER');
    });
  });

  group('MediaCaptureState + MediaPlaybackState (index)', () {
    test('indexes are the wire', () {
      expect(MediaCaptureState.NONE.index, 0);
      expect(MediaCaptureState.ACTIVE.index, 1);
      expect(MediaCaptureState.MUTED.index, 2);
      expect(MediaPlaybackState.NONE.index, 0);
      expect(MediaPlaybackState.PLAYING.index, 1);
      expect(MediaPlaybackState.PAUSED.index, 2);
      expect(MediaPlaybackState.SUSPENDED.index, 3);
      expect(mediaCaptureStateToWire(MediaCaptureState.MUTED), 2);
      expect(mediaCaptureStateFromWire(1), MediaCaptureState.ACTIVE);
      expect(mediaPlaybackStateToWire(MediaPlaybackState.SUSPENDED), 3);
      expect(mediaPlaybackStateFromWire(2), MediaPlaybackState.PAUSED);
    });
  });

  group('ScrollBarStyle wire [0,16777216,33554432,50331648]', () {
    test('indexes match the wire list (helpers not exported)', () {
      expect(ScrollBarStyle.SCROLLBARS_INSIDE_OVERLAY.index, 0);
      expect(ScrollBarStyle.SCROLLBARS_INSIDE_INSET.index, 1);
      expect(ScrollBarStyle.SCROLLBARS_OUTSIDE_OVERLAY.index, 2);
      expect(ScrollBarStyle.SCROLLBARS_OUTSIDE_INSET.index, 3);
    });
  });

  group('remaining index enums', () {
    test('ScrollView* + SelectionGranularity + ShouldAllow* + UserPreferredContentMode + VerticalScrollbarPosition', () {
      // NOTE: enum declaration order is AUTOMATIC, SCROLLABLE_AXES, NEVER,
      // ALWAYS (differs from upstream inappwebview order) — pinned as shipped.
      expect(ScrollViewContentInsetAdjustmentBehavior.AUTOMATIC.index, 0);
      expect(ScrollViewContentInsetAdjustmentBehavior.SCROLLABLE_AXES.index, 1);
      expect(ScrollViewContentInsetAdjustmentBehavior.NEVER.index, 2);
      expect(ScrollViewContentInsetAdjustmentBehavior.ALWAYS.index, 3);
      expect(ScrollViewDecelerationRate.NORMAL.index, 0);
      expect(ScrollViewDecelerationRate.FAST.index, 1);
      expect(SelectionGranularity.DYNAMIC.index, 0);
      expect(SelectionGranularity.CHARACTER.index, 1);
      expect(ShouldAllowDeprecatedTLSAction.CANCEL.index, 0);
      expect(ShouldAllowDeprecatedTLSAction.ALLOW.index, 1);
      expect(UserPreferredContentMode.RECOMMENDED.index, 0);
      expect(UserPreferredContentMode.MOBILE.index, 1);
      expect(UserPreferredContentMode.DESKTOP.index, 2);
      expect(VerticalScrollbarPosition.SCROLLBAR_POSITION_DEFAULT.index, 0);
      expect(VerticalScrollbarPosition.SCROLLBAR_POSITION_LEFT.index, 1);
      expect(VerticalScrollbarPosition.SCROLLBAR_POSITION_RIGHT.index, 2);
    });

    test('SearchResultDisplayStyle + WindowType + WindowTitlebarSeparatorStyle', () {
      expect(SearchResultDisplayStyle.CURRENT_AND_TOTAL.index, 0);
      expect(SearchResultDisplayStyle.TOTAL.index, 1);
      expect(SearchResultDisplayStyle.NONE.index, 2);
      expect(WindowType.WINDOW.index, 0);
      expect(WindowType.CHILD.index, 1);
      expect(WindowType.TABBED.index, 2);
      expect(WindowTitlebarSeparatorStyle.AUTOMATIC.index, 0);
      expect(WindowTitlebarSeparatorStyle.NONE.index, 1);
      expect(WindowTitlebarSeparatorStyle.LINE.index, 2);
      expect(WindowTitlebarSeparatorStyle.SHADOW.index, 3);
    });

    test('URLRequestCachePolicy + Attribution + NetworkServiceType', () {
      expect(URLRequestCachePolicy.USE_PROTOCOL_CACHE_POLICY.index, 0);
      expect(URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_CACHE_DATA.index, 1);
      expect(URLRequestCachePolicy.RETURN_CACHE_DATA_ELSE_LOAD.index, 2);
      expect(URLRequestCachePolicy.RETURN_CACHE_DATA_DONT_LOAD.index, 3);
      expect(URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA.index, 4);
      expect(URLRequestCachePolicy.RELOAD_REVALIDATING_CACHE_DATA.index, 5);
      expect(URLRequestAttribution.DEVELOPER.index, 0);
      expect(URLRequestAttribution.USER.index, 1);
      expect(URLRequestNetworkServiceType.DEFAULT.index, 0);
      expect(URLRequestNetworkServiceType.VIDEO.index, 1);
      expect(URLRequestNetworkServiceType.CALL_SIGNALING.index, 7);
    });

    test('URLProtectionSpaceAuthenticationMethod + ProxyType', () {
      expect(URLProtectionSpaceAuthenticationMethod.NSURL_AUTHENTICATION_METHOD_CLIENT_CERTIFICATE.index, 0);
      expect(URLProtectionSpaceAuthenticationMethod.NSURL_AUTHENTICATION_METHOD_NEGOTIATE.index, 1);
      expect(URLProtectionSpaceAuthenticationMethod.NSURL_AUTHENTICATION_METHOD_NTLM.index, 2);
      expect(URLProtectionSpaceAuthenticationMethod.NSURL_AUTHENTICATION_METHOD_SERVER_TRUST.index, 3);
      expect(URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_HTTP_PROXY.index, 0);
      expect(URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_HTTPS_PROXY.index, 1);
      expect(URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_FTP_PROXY.index, 2);
      expect(URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_SOCKS_PROXY.index, 3);
    });
  });

  group('WebArchiveFormat (native strings)', () {
    test('wire round-trips', () {
      expect(webArchiveFormatToWire(WebArchiveFormat.MHT), 'mht');
      expect(webArchiveFormatToWire(WebArchiveFormat.WEBARCHIVE), 'webarchive');
      expect(webArchiveFormatFromWire('mht'), WebArchiveFormat.MHT);
      expect(webArchiveFormatFromWire('pdf'), isNull);
    });
  });

  group('WindowStyleMask wire [0,1,2,4,8,16384,32768,16,64,128,8192]', () {
    test('wire round-trips', () {
      expect(windowStyleMaskToWire(WindowStyleMask.BORDERLESS), 0);
      expect(windowStyleMaskToWire(WindowStyleMask.TITLED), 1);
      expect(windowStyleMaskToWire(WindowStyleMask.CLOSABLE), 2);
      expect(windowStyleMaskToWire(WindowStyleMask.MINIATURIZABLE), 4);
      expect(windowStyleMaskToWire(WindowStyleMask.RESIZABLE), 8);
      expect(windowStyleMaskToWire(WindowStyleMask.FULLSCREEN), 16384);
      expect(windowStyleMaskToWire(WindowStyleMask.FULL_SIZE_CONTENT_VIEW), 32768);
      expect(windowStyleMaskToWire(WindowStyleMask.UTILITY_WINDOW), 16);
      expect(windowStyleMaskToWire(WindowStyleMask.DOC_MODAL_WINDOW), 64);
      expect(windowStyleMaskToWire(WindowStyleMask.NONACTIVATING_PANEL), 128);
      expect(windowStyleMaskToWire(WindowStyleMask.HUD_WINDOW), 8192);
      expect(windowStyleMaskFromWire(16), WindowStyleMask.UTILITY_WINDOW);
      expect(windowStyleMaskFromWire(3), isNull);
    });
  });

  group('PullToRefreshSize (DEFAULT=1, LARGE=0)', () {
    test('wire matches upstream', () {
      expect(pullToRefreshSizeToWire(PullToRefreshSize.DEFAULT), 1);
      expect(pullToRefreshSizeToWire(PullToRefreshSize.LARGE), 0);
    });
  });
}
