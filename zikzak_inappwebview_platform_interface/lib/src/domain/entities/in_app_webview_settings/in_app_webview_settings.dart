import 'package:zorphy_annotation/zorphy_annotation.dart';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../content_blocker.dart';
import '../context_menu/context_menu.dart';
import '../platform_webview_asset_loader/platform_webview_asset_loader.dart';
import '../platform_webview_feature/platform_webview_feature.dart';
import '../../../types/android_webview_insets.dart';
import '../../../types/network_capture_controller.dart';
import '../../../types/resource_type.dart';
import '../../../types/url_pattern_type.dart';
import '../enums/action_mode_menu_item.dart';
import '../enums/cache_mode.dart';
import '../enums/data_detector_types.dart';
import '../enums/force_dark.dart';
import '../enums/force_dark_strategy.dart';
import '../enums/layout_algorithm.dart';
import '../enums/mixed_content_mode.dart';
import '../enums/over_scroll_mode.dart';
import '../enums/referrer_policy.dart';
import '../renderer_priority_policy/renderer_priority_policy.dart';
import '../enums/sandbox.dart';
import '../enums/scrollbar_style.dart';
import '../enums/scrollview_content_inset_adjustment_behavior.dart';
import '../enums/scrollview_deceleration_rate.dart';
import '../enums/selection_granularity.dart';
import '../enums/user_preferred_content_mode.dart';
import '../enums/vertical_scrollbar_position.dart';
import '../enums/web_authentication_support.dart';
import '../../../util.dart';
import '../../../web_uri.dart';
import '../../../in_app_webview/platform_webview.dart';

part 'in_app_webview_settings.zorphy.dart';
part 'in_app_webview_settings.g.dart';

List<ContentBlocker> _deserializeContentBlockers(
  Object? contentBlockersMapList,
) {
  List<ContentBlocker> contentBlockers = [];
  if (contentBlockersMapList != null) {
    (contentBlockersMapList as List).forEach((contentBlocker) {
      contentBlockers.add(
        ContentBlocker.fromMap(
          Map<dynamic, Map<dynamic, dynamic>>.from(
            Map<dynamic, dynamic>.from(contentBlocker),
          ),
        ),
      );
    });
  }
  return contentBlockers;
}

Object? _serializeContentBlockers(List<ContentBlocker>? contentBlockers) =>
    contentBlockers?.map((e) => e.toMap()).toList();

///This class represents all the WebView settings available.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $InAppWebViewSettings {
  ///Set to `true` to be able to listen at the [PlatformWebViewCreationParams.shouldOverrideUrlLoading] event.
  ///
  ///If the [PlatformWebViewCreationParams.shouldOverrideUrlLoading] event is implemented and this value is `null`,
  ///it will be automatically inferred as `true`, otherwise, the default value is `false`.
  ///This logic will not be applied for [PlatformInAppBrowser], where you must set the value manually.
  bool? get useShouldOverrideUrlLoading;

  ///Set to `true` to be able to listen at the [PlatformWebViewCreationParams.onLoadResource] event.
  ///
  ///If the [PlatformWebViewCreationParams.onLoadResource] event is implemented and this value is `null`,
  ///it will be automatically inferred as `true`, otherwise, the default value is `false`.
  ///This logic will not be applied for [PlatformInAppBrowser], where you must set the value manually.
  bool? get useOnLoadResource;

  ///Set to `true` to be able to listen at the [PlatformWebViewCreationParams.onDownloadStartRequest] event.
  ///
  ///If the [PlatformWebViewCreationParams.onDownloadStartRequest] event is implemented and this value is `null`,
  ///it will be automatically inferred as `true`, otherwise, the default value is `false`.
  ///This logic will not be applied for [PlatformInAppBrowser], where you must set the value manually.
  bool? get useOnDownloadStart;

  ///Sets the user-agent for the WebView.
  @JsonKey(defaultValue: "")
  String? get userAgent;

  ///Append to the existing user-agent. Setting userAgent will override this.
  @JsonKey(defaultValue: "")
  String? get applicationNameForUserAgent;

  ///Set to `true` to enable JavaScript. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get javaScriptEnabled;

  ///Set to `true` to allow JavaScript open windows without user interaction. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get javaScriptCanOpenWindowsAutomatically;

  ///Set to `true` to prevent HTML5 audio or video from autoplaying. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get mediaPlaybackRequiresUserGesture;

  ///Sets the minimum font size. The default value is `8` for Android, `0` for iOS.
  int? get minimumFontSize;

  ///Define whether the vertical scrollbar should be drawn or not. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get verticalScrollBarEnabled;

  ///Define whether the horizontal scrollbar should be drawn or not. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get horizontalScrollBarEnabled;

  ///List of custom schemes that the WebView must handle. Use the [PlatformWebViewCreationParams.onLoadResourceWithCustomScheme] event to intercept resource requests with custom scheme.
  @JsonKey(defaultValue: const [])
  List<String>? get resourceCustomSchemes;

  ///List of [ContentBlocker] that are a set of rules used to block content in the browser window.
  @JsonKey(
    defaultValue: const [],
    fromJson: _deserializeContentBlockers,
    toJson: _serializeContentBlockers,
  )
  List<ContentBlocker>? get contentBlockers;

  ///Sets the content mode that the WebView needs to use when loading and rendering a webpage. The default value is [UserPreferredContentMode.RECOMMENDED].
  @JsonKey(defaultValue: UserPreferredContentMode.RECOMMENDED)
  UserPreferredContentMode? get preferredContentMode;

  ///Set to `true` to be able to listen at the [PlatformWebViewCreationParams.shouldInterceptAjaxRequest] event.
  ///
  ///Due to the async nature of [PlatformWebViewCreationParams.shouldInterceptAjaxRequest] event implementation,
  ///it will intercept only async `XMLHttpRequest`s ([AjaxRequest.isAsync] with `true`).
  ///To be able to intercept sync `XMLHttpRequest`s, use [InAppWebViewSettings.interceptOnlyAsyncAjaxRequests] to `false`.
  ///
  ///If the [PlatformWebViewCreationParams.shouldInterceptAjaxRequest] event or
  ///any other Ajax event is implemented and this value is `null`,
  ///it will be automatically inferred as `true`, otherwise, the default value is `false`.
  ///This logic will not be applied for [PlatformInAppBrowser], where you must set the value manually.
  bool? get useShouldInterceptAjaxRequest;

  ///Set to `false` to be able to listen to also sync `XMLHttpRequest`s at the
  ///[PlatformWebViewCreationParams.shouldInterceptAjaxRequest] event.
  ///
  ///**NOTE**: Using `false` will cause the `XMLHttpRequest.send()` method for sync
  ///requests to not wait on the JavaScript code the response synchronously,
  ///as if it was an async `XMLHttpRequest`.
  @JsonKey(defaultValue: true)
  bool? get interceptOnlyAsyncAjaxRequests;

  ///Set to `true` to be able to listen at the [PlatformWebViewCreationParams.shouldInterceptFetchRequest] event.
  ///
  ///If the [PlatformWebViewCreationParams.shouldInterceptFetchRequest] event is implemented and this value is `null`,
  ///it will be automatically inferred as `true`, otherwise, the default value is `false`.
  ///This logic will not be applied for [PlatformInAppBrowser], where you must set the value manually.
  bool? get useShouldInterceptFetchRequest;

  ///Set to `true` to open a browser window with incognito mode. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get incognito;

  ///Sets whether WebView should use browser caching. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get cacheEnabled;

  ///Set to `true` to make the background of the WebView transparent. If your app has a dark theme, this can prevent a white flash on initialization. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get transparentBackground;

  ///Set to `true` to disable vertical scroll. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get disableVerticalScroll;

  ///Set to `true` to disable horizontal scroll. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get disableHorizontalScroll;

  ///Set to `true` to disable context menu. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get disableContextMenu;

  ///Sets whether stylus handwriting is enabled.
  ///
  ///The default value is `true`.
  bool? get stylusHandwritingEnabled;

  ///Set to `false` if the WebView should not support zooming using its on-screen zoom controls and gestures. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get supportZoom;

  ///Sets whether cross-origin requests in the context of a file scheme URL should be allowed to access content from other file scheme URLs.
  ///Note that some accesses such as image HTML elements don't follow same-origin rules and aren't affected by this setting.
  ///
  ///Don't enable this setting if you open files that may be created or altered by external sources.
  ///Enabling this setting allows malicious scripts loaded in a `file://` context to access arbitrary local files including WebView cookies and app private data.
  ///
  ///Note that the value of this setting is ignored if the value of [allowUniversalAccessFromFileURLs] is `true`.
  ///
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get allowFileAccessFromFileURLs;

  ///Sets whether cross-origin requests in the context of a file scheme URL should be allowed to access content from any origin.
  ///This includes access to content from other file scheme URLs or web contexts.
  ///Note that some access such as image HTML elements doesn't follow same-origin rules and isn't affected by this setting.
  ///
  ///Don't enable this setting if you open files that may be created or altered by external sources.
  ///Enabling this setting allows malicious scripts loaded in a `file://` context to launch cross-site scripting attacks,
  ///either accessing arbitrary local files including WebView cookies, app private data or even credentials used on arbitrary web sites.
  ///
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get allowUniversalAccessFromFileURLs;

  ///Sets the text zoom of the page in percent. The default value is `100`.
  @JsonKey(defaultValue: true)
  bool? get builtInZoomControls;

  ///Set to `true` if the WebView should display on-screen zoom controls when using the built-in zoom mechanisms. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get displayZoomControls;

  ///Set to `true` if you want the database storage API is enabled. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get databaseEnabled;

  ///Set to `true` if you want the DOM storage API is enabled. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get domStorageEnabled;

  ///Set to `true` if the WebView should enable support for the "viewport" HTML meta tag or should use a wide viewport.
  ///When the value of the setting is false, the layout width is always set to the width of the WebView control in device-independent (CSS) pixels.
  ///When the value is true and the page contains the viewport meta tag, the value of the width specified in the tag is used.
  ///If the page does not contain the tag or does not provide a width, then a wide viewport will be used. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get useWideViewPort;

  ///Sets whether Safe Browsing is enabled. Safe Browsing allows WebView to protect against malware and phishing attacks by verifying the links.
  ///Safe Browsing is enabled by default for devices which support it.
  @JsonKey(defaultValue: true)
  bool? get safeBrowsingEnabled;

  ///Configures the WebView's behavior when a secure origin attempts to load a resource from an insecure origin.
  MixedContentMode? get mixedContentMode;

  ///Enables or disables content URL access within WebView. Content URL access allows WebView to load content from a content provider installed in the system. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get allowContentAccess;

  ///Enables or disables file access within WebView. Note that this enables or disables file system access only.
  ///Assets and resources are still accessible using `file:///android_asset` and `file:///android_res`. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get allowFileAccess;

  ///Sets whether the WebView should not load image resources from the network (resources accessed via http and https URI schemes). The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get blockNetworkImage;

  ///Sets whether the WebView should not load resources from the network. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get blockNetworkLoads;

  ///Overrides the way the cache is used. The way the cache is used is based on the navigation type. For a normal page load, the cache is checked and content is re-validated as needed.
  ///When navigating back, content is not revalidated, instead the content is just retrieved from the cache. The default value is [CacheMode.LOAD_DEFAULT].
  @JsonKey(defaultValue: CacheMode.LOAD_DEFAULT)
  CacheMode? get cacheMode;

  ///Sets the cursive font family name. The default value is `"cursive"`.
  @JsonKey(defaultValue: "cursive")
  String? get cursiveFontFamily;

  ///Sets the default fixed font size. The default value is `16`.
  @JsonKey(defaultValue: 16)
  int? get defaultFixedFontSize;

  ///Sets the default font size. The default value is `16`.
  @JsonKey(defaultValue: 16)
  int? get defaultFontSize;

  ///Sets the default text encoding name to use when decoding html pages. The default value is `"UTF-8"`.
  @JsonKey(defaultValue: "UTF-8")
  String? get defaultTextEncodingName;

  ///Disables the action mode menu items according to menuItems flag.
  ActionModeMenuItem? get disabledActionModeMenuItems;

  ///Sets the fantasy font family name. The default value is `"fantasy"`.
  @JsonKey(defaultValue: "fantasy")
  String? get fantasyFontFamily;

  ///Sets the fixed font family name. The default value is `"monospace"`.
  @JsonKey(defaultValue: "monospace")
  String? get fixedFontFamily;

  ///Set the force dark mode for this WebView. The default value is [ForceDark.OFF].
  @JsonKey(defaultValue: ForceDark.OFF)
  ForceDark? get forceDark;

  ///Set how WebView content should be darkened.
  ///The default value is [ForceDarkStrategy.PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING].
  @JsonKey(
    defaultValue: ForceDarkStrategy.PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING,
  )
  ForceDarkStrategy? get forceDarkStrategy;

  ///Sets whether Geolocation is enabled. The default is `true`.
  @JsonKey(defaultValue: true)
  bool? get geolocationEnabled;

  ///Sets the underlying layout algorithm. This will cause a re-layout of the WebView.
  LayoutAlgorithm? get layoutAlgorithm;

  ///Sets whether the WebView loads pages in overview mode, that is, zooms out the content to fit on screen by width.
  ///This setting is taken into account when the content width is greater than the width of the WebView control, for example, when [useWideViewPort] is enabled.
  ///The default value is `false`.
  @JsonKey(defaultValue: true)
  bool? get loadWithOverviewMode;

  ///Sets whether the WebView should load image resources. Note that this method controls loading of all images, including those embedded using the data URI scheme.
  ///Note that if the value of this setting is changed from false to true, all images resources referenced by content currently displayed by the WebView are loaded automatically.
  ///The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get loadsImagesAutomatically;

  ///Sets the minimum logical font size. The default is `8`.
  @JsonKey(defaultValue: 8)
  int? get minimumLogicalFontSize;

  ///Tells the WebView whether it needs to set a node. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get needInitialFocus;

  ///Sets whether this WebView should raster tiles when it is offscreen but attached to a window.
  ///Turning this on can avoid rendering artifacts when animating an offscreen WebView on-screen.
  ///Offscreen WebViews in this mode use more memory. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get offscreenPreRaster;

  ///Sets the sans-serif font family name. The default value is `"sans-serif"`.
  @JsonKey(defaultValue: "sans-serif")
  String? get sansSerifFontFamily;

  ///Sets the serif font family name. The default value is `"sans-serif"`.
  @JsonKey(defaultValue: "sans-serif")
  String? get serifFontFamily;

  ///Sets the standard font family name. The default value is `"sans-serif"`.
  @JsonKey(defaultValue: "sans-serif")
  String? get standardFontFamily;

  ///Sets whether the WebView should save form data. In Android O, the platform has implemented a fully functional Autofill feature to store form data.
  ///Therefore, the Webview form data save feature is disabled. Note that the feature will continue to be supported on older versions of Android as before.
  ///The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get saveFormData;

  ///Boolean value to enable third party cookies in the WebView.
  ///Used on Android Lollipop and above only as third party cookies are enabled by default on Android Kitkat and below and on iOS.
  ///The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get thirdPartyCookiesEnabled;

  ///Boolean value to enable Hardware Acceleration in the WebView.
  ///The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get hardwareAcceleration;

  ///Sets the initial scale for this WebView. 0 means default. The behavior for the default scale depends on the state of [useWideViewPort] and [loadWithOverviewMode].
  ///If the content fits into the WebView control by width, then the zoom is set to 100%. For wide content, the behavior depends on the state of [loadWithOverviewMode].
  ///If its value is true, the content will be zoomed out to be fit by width into the WebView control, otherwise not.
  ///If initial scale is greater than 0, WebView starts with this value as initial scale.
  ///Please note that unlike the scale properties in the viewport meta tag, this method doesn't take the screen density into account.
  ///The default is `0`.
  @JsonKey(defaultValue: 0)
  int? get initialScale;

  ///Sets whether the WebView supports multiple windows.
  ///If set to `true`, [PlatformWebViewCreationParams.onCreateWindow] event must be implemented by the host application. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get supportMultipleWindows;

  ///Regular expression used by [PlatformWebViewCreationParams.shouldOverrideUrlLoading] event to cancel navigation requests for frames that are not the main frame.
  ///If the url request of a subframe matches the regular expression, then the request of that subframe is canceled.
  String? get regexToCancelSubFramesLoading;

  ///Regular expression used by [PlatformWebViewCreationParams.shouldOverrideUrlLoading] event to cancel navigation requests
  ///If the url request not matches the regular expression, then the shouldOverrideUrlLoading is return false.
  String? get regexToCancelOverrideUrlLoading;

  ///Set to `false` to disable Flutter Hybrid Composition. The default value is `true`.
  ///Hybrid Composition is supported starting with Flutter v1.20+.
  @JsonKey(defaultValue: true)
  bool? get useHybridComposition;

  ///Set to `true` to be able to listen at the [PlatformWebViewCreationParams.shouldInterceptRequest] event.
  ///
  ///If the [PlatformWebViewCreationParams.shouldInterceptRequest] event is implemented and this value is `null`,
  ///it will be automatically inferred as `true`, otherwise, the default value is `false`.
  ///This logic will not be applied for [PlatformInAppBrowser], where you must set the value manually.
  bool? get useShouldInterceptRequest;

  ///Set to `true` to be able to listen at the [PlatformWebViewCreationParams.onRenderProcessGone] event.
  ///
  ///If the [PlatformWebViewCreationParams.onRenderProcessGone] event is implemented and this value is `null`,
  ///it will be automatically inferred as `true`, otherwise, the default value is `false`.
  ///This logic will not be applied for [PlatformInAppBrowser], where you must set the value manually.
  bool? get useOnRenderProcessGone;

  ///Sets the WebView's over-scroll mode.
  ///Setting the over-scroll mode of a WebView will have an effect only if the WebView is capable of scrolling.
  ///The default value is [OverScrollMode.IF_CONTENT_SCROLLS].
  @JsonKey(defaultValue: OverScrollMode.IF_CONTENT_SCROLLS)
  OverScrollMode? get overScrollMode;

  ///Informs WebView of the network state.
  ///This is used to set the JavaScript property `window.navigator.isOnline` and generates the online/offline event as specified in HTML5, sec. 5.7.7.
  bool? get networkAvailable;

  ///Specifies the style of the scrollbars. The scrollbars can be overlaid or inset.
  ///When inset, they add to the padding of the view. And the scrollbars can be drawn inside the padding area or on the edge of the view.
  ///For example, if a view has a background drawable and you want to draw the scrollbars inside the padding specified by the drawable,
  ///you can use SCROLLBARS_INSIDE_OVERLAY or SCROLLBARS_INSIDE_INSET. If you want them to appear at the edge of the view, ignoring the padding,
  ///then you can use SCROLLBARS_OUTSIDE_OVERLAY or SCROLLBARS_OUTSIDE_INSET.
  ///The default value is [ScrollBarStyle.SCROLLBARS_INSIDE_OVERLAY].
  @JsonKey(defaultValue: ScrollBarStyle.SCROLLBARS_INSIDE_OVERLAY)
  ScrollBarStyle? get scrollBarStyle;

  ///Sets the position of the vertical scroll bar.
  ///The default value is [VerticalScrollbarPosition.SCROLLBAR_POSITION_DEFAULT].
  @JsonKey(defaultValue: VerticalScrollbarPosition.SCROLLBAR_POSITION_DEFAULT)
  VerticalScrollbarPosition? get verticalScrollbarPosition;

  ///Defines the delay in milliseconds that a scrollbar waits before fade out.
  int? get scrollBarDefaultDelayBeforeFade;

  ///Defines whether scrollbars will fade when the view is not scrolling.
  ///The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get scrollbarFadingEnabled;

  ///Defines the scrollbar fade duration in milliseconds.
  int? get scrollBarFadeDuration;

  ///Sets the renderer priority policy for this WebView.
  RendererPriorityPolicy? get rendererPriorityPolicy;

  ///Sets whether the default Android WebView’s internal error page should be suppressed or displayed for bad navigations.
  ///`true` means suppressed (not shown), `false` means it will be displayed. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get disableDefaultErrorPage;

  ///Sets the vertical scrollbar thumb color.
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get verticalScrollbarThumbColor;

  ///Sets the vertical scrollbar track color.
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get verticalScrollbarTrackColor;

  ///Sets the horizontal scrollbar thumb color.
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get horizontalScrollbarThumbColor;

  ///Sets the horizontal scrollbar track color.
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get horizontalScrollbarTrackColor;

  ///Control whether algorithmic darkening is allowed.
  ///
  ///WebView always sets the media query `prefers-color-scheme` according to the app's theme attribute `isLightTheme`,
  ///i.e. `prefers-color-scheme` is light if `isLightTheme` is `true` or not specified, otherwise it is `dark`.
  ///This means that the web content's light or dark style will be applied automatically to match the app's theme if the content supports it.
  ///
  ///Algorithmic darkening is disallowed by default.
  ///
  ///If the app's theme is dark and it allows algorithmic darkening,
  ///WebView will attempt to darken web content using an algorithm,
  ///if the content doesn't define its own dark styles and doesn't explicitly disable darkening.
  @JsonKey(defaultValue: false)
  bool? get algorithmicDarkeningAllowed;

  ///Enable Payment Request API in order to use Google Pay inside the WebView.
  bool? get paymentRequestEnabled;

  ///Sets the Web Authentication support level for the WebView. The default value is [WebAuthenticationSupport.NONE].
  WebAuthenticationSupport? get webAuthenticationSupport;

  ///Sets whether EnterpriseAuthenticationAppLinkPolicy if set by admin is allowed to have any
  ///effect on WebView.
  ///
  ///EnterpriseAuthenticationAppLinkPolicy in WebView allows admins to specify authentication
  ///urls. When WebView is redirected to authentication url, and an app on the device has
  ///registered as the default handler for the url, that app is launched.
  ///
  ///The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get enterpriseAuthenticationAppLinkPolicyEnabled;

  ///When not playing, video elements are represented by a 'poster' image.
  ///The image to use can be specified by the poster attribute of the video tag in HTML.
  ///If the attribute is absent, then a default poster will be used.
  ///This property allows the WebView to provide that default image.
  @JsonKey(
    fromJson: _defaultVideoPosterFromJson,
    toJson: _defaultVideoPosterToJson,
  )
  Uint8List? get defaultVideoPoster;

  ///Set an allow-list of origins to receive the X-Requested-With HTTP header from the WebView owning the passed [InAppWebViewSettings].
  ///
  ///Historically, this header was sent on all requests from WebView, containing the app package name of the embedding app. Depending on the version of installed WebView, this may no longer be the case, as the header was deprecated in late 2022, and its use discontinued.
  ///
  ///Apps can use this method to restore the legacy behavior for servers that still rely on the deprecated header, but it should not be used to identify the webview to first-party servers under the control of the app developer.
  ///
  ///The format of the strings in the allow-list follows the origin rules of [PlatformInAppWebViewController.addWebMessageListener].
  Set<String>? get requestedWithHeaderOriginAllowList;

  ///Set to `true` to disable the bouncing of the WebView when the scrolling has reached an edge of the content. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get disallowOverScroll;

  ///Set to `true` to allow a viewport meta tag to either disable or restrict the range of user scaling. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get enableViewportScale;

  ///Set to `true` if you want the WebView suppresses content rendering until it is fully loaded into memory. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get suppressesIncrementalRendering;

  ///Set to `true` to allow AirPlay. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get allowsAirPlayForMediaPlayback;

  ///Set to `true` to allow the horizontal swipe gestures trigger back-forward list navigations. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get allowsBackForwardNavigationGestures;

  ///Set to `true` to allow that pressing on a link displays a preview of the destination for the link. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get allowsLinkPreview;

  ///Set to `true` if you want that the WebView should always allow scaling of the webpage, regardless of the author's intent.
  ///The ignoresViewportScaleLimits property overrides the `user-scalable` HTML property in a webpage. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get ignoresViewportScaleLimits;

  ///Set to `true` to allow HTML5 media playback to appear inline within the screen layout, using browser-supplied controls rather than native controls.
  ///For this to work, add the `webkit-playsinline` attribute to any `<video>` elements. The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get allowsInlineMediaPlayback;

  ///Set to `true` to allow HTML5 videos play picture-in-picture. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get allowsPictureInPictureMediaPlayback;

  ///A Boolean value indicating whether warnings should be shown for suspected fraudulent content such as phishing or malware.
  ///According to the official documentation, this feature is currently available in the following region: China.
  ///The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get isFraudulentWebsiteWarningEnabled;

  ///The level of granularity with which the user can interactively select content in the web view.
  ///The default value is [SelectionGranularity.DYNAMIC].
  @JsonKey(defaultValue: SelectionGranularity.DYNAMIC)
  SelectionGranularity? get selectionGranularity;

  ///Specifying a dataDetectoryTypes value adds interactivity to web content that matches the value.
  ///For example, Safari adds a link to “apple.com” in the text “Visit apple.com” if the dataDetectorTypes property is set to [DataDetectorTypes.LINK].
  ///The default value is [DataDetectorTypes.NONE].
  List<DataDetectorTypes>? get dataDetectorTypes;

  ///Set `true` if shared cookies from `HTTPCookieStorage.shared` should used for every load request in the WebView.
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get sharedCookiesEnabled;

  ///Configures whether the scroll indicator insets are automatically adjusted by the system.
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get automaticallyAdjustsScrollIndicatorInsets;

  ///A Boolean value indicating whether the WebView ignores an accessibility request to invert its colors.
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get accessibilityIgnoresInvertColors;

  ///A [ScrollViewDecelerationRate] value that determines the rate of deceleration after the user lifts their finger.
  ///The default value is [ScrollViewDecelerationRate.NORMAL].
  @JsonKey(defaultValue: ScrollViewDecelerationRate.NORMAL)
  ScrollViewDecelerationRate? get decelerationRate;

  ///A Boolean value that determines whether bouncing always occurs when vertical scrolling reaches the end of the content.
  ///If this property is set to `true` and [InAppWebViewSettings.disallowOverScroll] is `false`,
  ///vertical dragging is allowed even if the content is smaller than the bounds of the scroll view.
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get alwaysBounceVertical;

  ///A Boolean value that determines whether bouncing always occurs when horizontal scrolling reaches the end of the content view.
  ///If this property is set to `true` and [InAppWebViewSettings.disallowOverScroll] is `false`,
  ///horizontal dragging is allowed even if the content is smaller than the bounds of the scroll view.
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get alwaysBounceHorizontal;

  ///A Boolean value that controls whether the scroll view bounces when it reaches
  ///the end of its horizontal content.
  ///
  ///When set to `false`, horizontal scrolling does not produce a bounce effect
  ///even when [InAppWebViewSettings.disallowOverScroll] is `false` and
  ///[InAppWebViewSettings.alwaysBounceHorizontal] is `false`. The default value
  ///is `true`.
  ///
  ///This property is only applied on iOS 17.4 and newer; on earlier iOS versions
  ///it is a no-op. When left `null`, no override is applied and the scroll view's
  ///own default is preserved.
  bool? get bouncesHorizontally;

  ///A Boolean value that controls whether the scroll view bounces when it reaches
  ///the end of its vertical content.
  ///
  ///When set to `false`, vertical scrolling does not produce a bounce effect
  ///even when [InAppWebViewSettings.disallowOverScroll] is `false` and
  ///[InAppWebViewSettings.alwaysBounceVertical] is `false`. The default value
  ///is `true`.
  ///
  ///This property is only applied on iOS 17.4 and newer; on earlier iOS versions
  ///it is a no-op. When left `null`, no override is applied and the scroll view's
  ///own default is preserved.
  bool? get bouncesVertically;

  ///A Boolean value that controls whether the scroll-to-top gesture is enabled.
  ///The scroll-to-top gesture is a tap on the status bar. When a user makes this gesture,
  ///the system asks the scroll view closest to the status bar to scroll to the top.
  ///The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get scrollsToTop;

  ///A Boolean value that determines whether paging is enabled for the scroll view.
  ///If the value of this property is true, the scroll view stops on multiples of the scroll view’s bounds when the user scrolls.
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get isPagingEnabled;

  ///A floating-point value that specifies the maximum scale factor that can be applied to the scroll view's content.
  ///This value determines how large the content can be scaled.
  ///It must be greater than the minimum zoom scale for zooming to be enabled.
  ///The default value is `1.0`.
  @JsonKey(defaultValue: 1.0)
  double? get maximumZoomScale;

  ///A floating-point value that specifies the minimum scale factor that can be applied to the scroll view's content.
  ///This value determines how small the content can be scaled.
  ///The default value is `1.0`.
  @JsonKey(defaultValue: 1.0)
  double? get minimumZoomScale;

  ///Configures how safe area insets are added to the adjusted content inset.
  ///The default value is [ScrollViewContentInsetAdjustmentBehavior.NEVER].
  @JsonKey(defaultValue: ScrollViewContentInsetAdjustmentBehavior.NEVER)
  ScrollViewContentInsetAdjustmentBehavior? get contentInsetAdjustmentBehavior;

  ///A Boolean value that determines whether scrolling is disabled in a particular direction.
  ///If this property is `false`, scrolling is permitted in both horizontal and vertical directions.
  ///If this property is `true` and the user begins dragging in one general direction (horizontally or vertically),
  ///the scroll view disables scrolling in the other direction.
  ///If the drag direction is diagonal, then scrolling will not be locked and the user can drag in any direction until the drag completes.
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get isDirectionalLockEnabled;

  ///The media type for the contents of the web view.
  ///When the value of this property is `null`, the web view derives the current media type from the CSS media property of its content.
  ///If you assign a value other than `null` to this property, the web view uses the value you provide instead.
  ///The default value of this property is `null`.
  String? get mediaType;

  ///The scale factor by which the web view scales content relative to its bounds.
  ///The default value of this property is `1.0`, which displays the content without any scaling.
  ///Changing the value of this property is equivalent to setting the CSS `zoom` property on all page content.
  @JsonKey(defaultValue: 1.0)
  double? get pageZoom;

  ///A Boolean value that indicates whether the web view limits navigation to pages within the app’s domain.
  ///Check [App-Bound Domains](https://webkit.org/blog/10882/app-bound-domains/) for more details.
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get limitsNavigationsToAppBoundDomains;

  ///Set to `true` to be able to listen to the [PlatformWebViewCreationParams.onNavigationResponse] event.
  ///
  ///If the [PlatformWebViewCreationParams.onNavigationResponse] event is implemented and this value is `null`,
  ///it will be automatically inferred as `true`, otherwise, the default value is `false`.
  ///This logic will not be applied for [PlatformInAppBrowser], where you must set the value manually.
  bool? get useOnNavigationResponse;

  ///Set to `true` to enable Apple Pay API for the `WebView` at its first page load or on the next page load (using [PlatformInAppWebViewController.setSettings]). The default value is `false`.
  ///
  ///**IMPORTANT NOTE**: As written in the official [Safari 13 Release Notes](https://developer.apple.com/documentation/safari-release-notes/safari-13-release-notes#Payment-Request-API),
  ///it won't work if any script injection APIs are used (such as [PlatformInAppWebViewController.evaluateJavascript] or [UserScript]).
  ///So, when this attribute is `true`, all the methods, settings, and events implemented using JavaScript won't be called or won't do anything and the result will always be `null`.
  ///
  ///Methods affected:
  ///[PlatformInAppWebViewController.addUserScript]
  ///[PlatformInAppWebViewController.addUserScripts]
  ///[PlatformInAppWebViewController.removeUserScript]
  ///[PlatformInAppWebViewController.removeUserScripts]
  ///[PlatformInAppWebViewController.removeAllUserScripts]
  ///[PlatformInAppWebViewController.evaluateJavascript]
  ///[PlatformInAppWebViewController.callAsyncJavaScript]
  ///[PlatformInAppWebViewController.injectJavascriptFileFromUrl]
  ///[PlatformInAppWebViewController.injectJavascriptFileFromAsset]
  ///[PlatformInAppWebViewController.injectCSSCode]
  ///[PlatformInAppWebViewController.injectCSSFileFromUrl]
  ///[PlatformInAppWebViewController.injectCSSFileFromAsset]
  ///[PlatformInAppWebViewController.findAllAsync]
  ///[PlatformInAppWebViewController.findNext]
  ///[PlatformInAppWebViewController.clearMatches]
  ///[PlatformInAppWebViewController.pauseTimers]
  ///[PlatformInAppWebViewController.getSelectedText]
  ///[PlatformInAppWebViewController.getHitTestResult]
  ///[PlatformInAppWebViewController.requestFocusNodeHref]
  ///[PlatformInAppWebViewController.requestImageRef]
  ///[PlatformInAppWebViewController.postWebMessage]
  ///[PlatformInAppWebViewController.createWebMessageChannel]
  ///[PlatformInAppWebViewController.addWebMessageListener]
  ///
  ///Also, on MacOS:
  ///[PlatformInAppWebViewController.getScrollX]
  ///[PlatformInAppWebViewController.getScrollY]
  ///[PlatformInAppWebViewController.scrollTo]
  ///[PlatformInAppWebViewController.scrollBy]
  ///[PlatformInAppWebViewController.getContentHeight]
  ///[PlatformInAppWebViewController.getContentWidth]
  ///[PlatformInAppWebViewController.canScrollVertically]
  ///[PlatformInAppWebViewController.canScrollHorizontally]
  ///
  ///Settings affected:
  ///[PlatformWebViewCreationParams.initialUserScripts]
  ///[InAppWebViewSettings.supportZoom]
  ///[InAppWebViewSettings.useOnLoadResource]
  ///[InAppWebViewSettings.useShouldInterceptAjaxRequest]
  ///[InAppWebViewSettings.useShouldInterceptFetchRequest]
  ///[InAppWebViewSettings.enableViewportScale]
  ///
  ///Events affected:
  ///the `hitTestResult` argument of [PlatformWebViewCreationParams.onLongPressHitTestResult] will be empty
  ///the `hitTestResult` argument of [ContextMenu.onCreateContextMenu] will be empty
  ///[PlatformWebViewCreationParams.onLoadResource]
  ///[PlatformWebViewCreationParams.shouldInterceptAjaxRequest]
  ///[PlatformWebViewCreationParams.onAjaxReadyStateChange]
  ///[PlatformWebViewCreationParams.onAjaxProgress]
  ///[PlatformWebViewCreationParams.shouldInterceptFetchRequest]
  ///[PlatformWebViewCreationParams.onConsoleMessage]
  ///[PlatformWebViewCreationParams.onPrintRequest]
  ///[PlatformWebViewCreationParams.onWindowFocus]
  ///[PlatformWebViewCreationParams.onWindowBlur]
  ///[PlatformWebViewCreationParams.onFindResultReceived]
  ///[FindInteractionController.onFindResultReceived]
  ///
  ///Also, on MacOS:
  ///[PlatformWebViewCreationParams.onScrollChanged]
  @JsonKey(defaultValue: false)
  bool? get applePayAPIEnabled;

  ///Used in combination with [PlatformWebViewCreationParams.initialUrlRequest] or [PlatformWebViewCreationParams.initialData] (using the `file://` scheme), it represents the URL from which to read the web content.
  ///This URL must be a file-based URL (using the `file://` scheme).
  ///Specify the same value as the [URLRequest.url] if you are using it with the [PlatformWebViewCreationParams.initialUrlRequest] parameter or
  ///the [InAppWebViewInitialData.baseUrl] if you are using it with the [PlatformWebViewCreationParams.initialData] parameter to prevent WebView from reading any other content.
  ///Specify a directory to give WebView permission to read additional files in the specified directory.
  @JsonKey(
    fromJson: _allowingReadAccessToFromJson,
    toJson: _allowingReadAccessToToJson,
  )
  WebUri? get allowingReadAccessTo;

  ///Set to `true` to disable the context menu (copy, select, etc.) that is shown when the user emits a long press event on a HTML link.
  ///This is implemented using also JavaScript, so it must be enabled or it won't work.
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get disableLongPressContextMenuOnLinks;

  ///Set to `true` to disable the [inputAccessoryView](https://developer.apple.com/documentation/uikit/uiresponder/1621119-inputaccessoryview) above system keyboard.
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get disableInputAccessoryView;

  ///The color the web view displays behind the active page, visible when the user scrolls beyond the bounds of the page.
  ///
  ///The web view derives the default value of this property from the content of the page,
  ///using the background colors of the `<html>` and `<body>` elements with the background color of the web view.
  ///To override the default color, set this property to a new color.
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get underPageBackgroundColor;

  ///A Boolean value indicating whether text interaction is enabled or not.
  ///The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get isTextInteractionEnabled;

  ///A Boolean value indicating whether WebKit will apply built-in workarounds (quirks)
  ///to improve compatibility with certain known websites. You can disable site-specific quirks
  ///to help test your website without these workarounds. The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get isSiteSpecificQuirksModeEnabled;

  ///A Boolean value indicating whether HTTP requests to servers known to support HTTPS should be automatically upgraded to HTTPS requests.
  ///The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get upgradeKnownHostsToHTTPS;

  ///Sets whether fullscreen API is enabled or not.
  ///
  ///The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get isElementFullscreenEnabled;

  ///Sets whether the web view's built-in find interaction native UI is enabled or not.
  ///
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get isFindInteractionEnabled;

  ///Set minimum viewport inset to the smallest inset a webpage may experience in your app's maximally collapsed UI configuration.
  ///Values must be either zero or positive. It must be smaller than [maximumViewportInset].
  @JsonKey(
    fromJson: _minimumViewportInsetFromJson,
    toJson: _minimumViewportInsetToJson,
  )
  EdgeInsets? get minimumViewportInset;

  ///Set maximum viewport inset to the largest inset a webpage may experience in your app's maximally expanded UI configuration.
  ///Values must be either zero or positive. It must be larger than [minimumViewportInset].
  @JsonKey(
    fromJson: _maximumViewportInsetFromJson,
    toJson: _maximumViewportInsetToJson,
  )
  EdgeInsets? get maximumViewportInset;

  ///Controls whether this WebView is inspectable in Web Inspector.
  ///
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get isInspectable;

  ///A Boolean value that indicates whether to include any background color or graphics when printing content.
  ///
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get shouldPrintBackgrounds;

  ///Set to `true` to allow audio playing when the app goes in background or the screen is locked or another app is opened.
  ///However, there will be no controls in the notification bar or on the lockscreen.
  ///Also, make sure to not call [PlatformInAppWebViewController.pause], otherwise it will stop audio playing.
  ///The default value is `false`.
  ///
  ///**IMPORTANT NOTE**: if you use this setting, your app could be rejected by the Google Play Store.
  ///For example, if you allow background playing of YouTube videos, which is a violation of the YouTube API Terms of Service.
  @JsonKey(defaultValue: false)
  bool? get allowBackgroundAudioPlaying;

  ///Use a [WebViewAssetLoader] instance to load local files including application's static assets and resources using http(s):// URLs.
  ///Loading local files using web-like URLs instead of `file://` is desirable as it is compatible with the Same-Origin policy.
  WebViewAssetLoader? get webViewAssetLoader;

  ///Specifies a feature policy for the `<iframe>`.
  ///The policy defines what features are available to the `<iframe>` based on the origin of the request
  ///(e.g. access to the microphone, camera, battery, web-share API, etc.).
  String? get iframeAllow;

  ///Set to true if the `<iframe>` can activate fullscreen mode by calling the `requestFullscreen()` method.
  bool? get iframeAllowFullscreen;

  ///Applies extra restrictions to the content in the frame.
  @JsonKey(fromJson: _iframeSandboxFromJson, toJson: _iframeSandboxToJson)
  Set<Sandbox>? get iframeSandbox;

  ///A string that reflects the `referrerpolicy` HTML attribute indicating which referrer to use when fetching the linked resource.
  ReferrerPolicy? get iframeReferrerPolicy;

  ///A string that reflects the `name` HTML attribute, containing a name by which to refer to the frame.
  String? get iframeName;

  ///A Content Security Policy enforced for the embedded resource.
  String? get iframeCsp;

  ///Set to `true` to automatically dismiss fixed/sticky overlays (popups, dialogs, banners) from the loaded page.
  ///
  ///When enabled, after the page finishes loading, the WebView will find and remove all HTML elements with
  ///CSS `position: fixed` or `position: sticky`, and reset the `overflow` and `margin` CSS properties
  ///on both `document.documentElement` and `document.body`.
  ///This is useful to obtain clean screenshots, PDF exports, or HTML captures.
  ///
  ///The removal process will retry multiple times with a delay to catch dynamically loaded overlays.
  ///If a page uses fixed/sticky elements for essential functionality, set this to `false`.
  ///
  ///The default value is `true`.
  @JsonKey(defaultValue: false)
  bool? get dismissDialogues;

  ///Which window insets the Android WebView should **ignore** when laying out
  ///web content, so that content can render edge-to-edge behind the status bar,
  ///navigation bar, IME (keyboard), display cutout and/or system-gesture areas.
  ///
  ///This is the zikzak equivalent of `webview_flutter_android`'s
  ///`setInsetsForWebContentToIgnore` API. Each listed inset type is zeroed out
  ///before reaching the WebView, so the WebView will not pad or shrink its
  ///content for those insets.
  ///
  ///Example - render web content behind the status bar, navigation bar and IME:
  ///```dart
  ///InAppWebViewSettings(
  /// insetsForWebContentToIgnore: [
  ///   AndroidWebViewInsets.systemBars,
  ///   AndroidWebViewInsets.ime,
  /// ],
  ///)
  ///```
  ///
  ///Leave this `null` or empty to keep the default Android behavior (the
  ///WebView is inset by the system bars / IME as usual).
  @JsonKey(fromJson: _insetsFromJson, toJson: _insetsToJson)
  List<AndroidWebViewInsets>? get insetsForWebContentToIgnore;

  ///Set to `true` to enable the Network Capture API: `XMLHttpRequest` and
  ///`fetch()` calls made by the page are intercepted and reported through
  ///the `onNetworkRequest`/`onNetworkResponse`/`onNetworkLoadingFinished`
  ///events and/or the [NetworkCaptureController].
  ///
  ///If any of those events is implemented or [networkCapture] is set and
  ///this value is `null`, it is automatically inferred as `true`.
  ///The default value is `false`.
  ///
  ///**NOTE**: requires [javaScriptEnabled] to be `true`.
  bool? get useNetworkCapture;

  ///Maximum response body size to capture, in characters.
  ///Bodies exceeding this are truncated with a
  ///`... [truncated, total: N chars]` suffix.
  ///
  ///The default value is `50000` (50 KB of text).
  @JsonKey(defaultValue: 50000)
  int? get networkCaptureMaxBodySize;

  ///Whether to capture response bodies at all.
  ///Set to `false` for URL/status/headers-only monitoring.
  ///
  ///The default value is `true`.
  @JsonKey(defaultValue: true)
  bool? get networkCaptureBodies;

  ///Whether to capture binary response bodies (images, fonts, ...).
  ///When `false`, binary responses capture metadata only.
  ///When `true`, binary bodies are base64-encoded.
  ///
  ///The default value is `false`.
  @JsonKey(defaultValue: false)
  bool? get networkCaptureBinaryBodies;

  ///URL patterns used to filter captured requests.
  ///Only requests whose URL matches ANY pattern are captured.
  ///An empty list captures all requests.
  ///
  ///Patterns are interpreted according to [networkCaptureUrlPatternType].
  ///
  ///The default value is an empty list (capture all).
  @JsonKey(defaultValue: const [])
  List<String>? get networkCaptureUrlPatterns;

  ///How [networkCaptureUrlPatterns] are interpreted.
  ///
  ///The default value is [UrlPatternType.substring].
  @JsonKey(fromJson: _urlPatternTypeFromJson, toJson: _urlPatternTypeToJson)
  UrlPatternType? get networkCaptureUrlPatternType;

  ///Resource types to capture.
  ///
  ///**NOTE**: the JavaScript-injection-based capture engine can only
  ///observe [ResourceType.xhr] and [ResourceType.fetch].
  ///
  ///The default value is `[ResourceType.xhr, ResourceType.fetch]`.
  @JsonKey(fromJson: _resourceTypesFromJson, toJson: _resourceTypesToJson)
  List<ResourceType>? get networkCaptureResourceTypes;

  ///MIME type patterns used to filter captured response bodies.
  ///When non-empty, only responses whose `Content-Type` matches ANY pattern
  ///(substring) have their body captured. Requests are still tracked and
  ///response metadata is still reported; only the body is discarded.
  ///
  ///The default value is an empty list (capture all bodies).
  @JsonKey(defaultValue: const [])
  List<String>? get networkCaptureMimeTypes;

  ///A [NetworkCaptureController] that accumulates all captured
  ///request-response pairs for bulk retrieval.
  ///Setting this also enables network capture (see [useNetworkCapture]).
  ///
  ///**NOTE**: this value is not serialized with the other settings.
  @JsonKey(includeFromJson: false, includeToJson: false)
  NetworkCaptureController? get networkCapture;
}

Color_? _colorFromJson(Object? value) {
  if (value == null) return null;
  final color = UtilColor.fromStringRepresentation(value as String);
  return color == null ? null : Color_(color.value);
}

Object? _colorToJson(Color_? color) => color?.toHex();

Uint8List? _defaultVideoPosterFromJson(Object? value) =>
    value == null ? null : Uint8List.fromList((value as List).cast<int>());

Object? _defaultVideoPosterToJson(Uint8List? value) => value?.toList();

WebUri? _allowingReadAccessToFromJson(Object? value) =>
    value == null ? null : WebUri(value as String);

Object? _allowingReadAccessToToJson(WebUri? value) => value?.toString();

EdgeInsets? _minimumViewportInsetFromJson(Object? value) => value == null
    ? null
    : MapEdgeInsets.fromMap((value as Map).cast<String, dynamic>());

Object? _minimumViewportInsetToJson(EdgeInsets? value) => value?.toMap();

EdgeInsets? _maximumViewportInsetFromJson(Object? value) => value == null
    ? null
    : MapEdgeInsets.fromMap((value as Map).cast<String, dynamic>());

Object? _maximumViewportInsetToJson(EdgeInsets? value) => value?.toMap();

List<AndroidWebViewInsets>? _insetsFromJson(Object? value) => value == null
    ? null
    : (value as List)
          .map((e) => AndroidWebViewInsets.fromNativeValue(e as String)!)
          .toList();

Object? _insetsToJson(List<AndroidWebViewInsets>? value) =>
    value?.map((e) => e.toNativeValue()).toList();

UrlPatternType? _urlPatternTypeFromJson(Object? value) =>
    value == null ? null : UrlPatternType.fromNativeValue(value as String);

Object? _urlPatternTypeToJson(UrlPatternType? value) => value?.toNativeValue();

List<ResourceType>? _resourceTypesFromJson(Object? value) => value == null
    ? null
    : (value as List)
          .map((e) => ResourceType.fromNativeValue(e as String)!)
          .toList();

Object? _resourceTypesToJson(List<ResourceType>? value) =>
    value?.map((e) => e.toNativeValue()).toList();

Set<Sandbox>? _iframeSandboxFromJson(Object? value) => value == null
    ? null
    : (value as List).map((e) => sandboxFromWire(e)!).toSet();

Object? _iframeSandboxToJson(Set<Sandbox>? value) =>
    value?.map((e) => sandboxToWire(e)).toList();
