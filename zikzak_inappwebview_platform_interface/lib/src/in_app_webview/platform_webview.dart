import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui';

import '../find_interaction/platform_find_interaction_controller.dart';
import '../pull_to_refresh/platform_pull_to_refresh_controller.dart';

import '../context_menu/context_menu.dart';
import '../types/main.dart';

import '../web_uri.dart';
import 'in_app_webview_settings.dart';
import 'platform_inappwebview_controller.dart';
import '../print_job/main.dart';

///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams}
///Class that represents a WebView. Used by [InAppWebView], [HeadlessInAppWebView] and the WebView of [PlatformInAppBrowser].
///{@endtemplate}
class PlatformWebViewCreationParams<T> {
  final T Function(PlatformInAppWebViewController controller)?
      controllerFromPlatform;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.windowId}
  ///The window id of a [CreateWindowAction.windowId].
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///{@endtemplate}
  final int? windowId;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onWebViewCreated}
  ///Event fired when the `WebView` is created.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///- Web
  ///- Windows
  ///{@endtemplate}
  final void Function(T controller)? onWebViewCreated;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onLoadStart}
  ///Event fired when the `WebView` starts to load an [url].
  ///
  ///**NOTE for Web**: it will be dispatched at the same time of [onLoadStop] event
  ///because there isn't any way to capture the real load start event from an iframe.
  ///If `window.location.href` isn't accessible inside the iframe,
  ///the [url] parameter will have the current value of the `iframe.src` attribute.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.onPageStarted](https://developer.android.com/reference/android/webkit/WebViewClient#onPageStarted(android.webkit.WebView,%20java.lang.String,%20android.graphics.Bitmap)))
  ///- iOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455621-webview))
  ///- MacOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455621-webview))
  ///- Web
  ///- Windows ([Official API - ICoreWebView2.add_NavigationStarting](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/iwebview2webview?view=webview2-0.8.355#add_navigationstarting))
  ///{@endtemplate}
  final void Function(T controller, WebUri? url)? onLoadStart;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onLoadStop}
  ///Event fired when the `WebView` finishes loading an [url].
  ///
  ///**NOTE for Web**: If `window.location.href` isn't accessible inside the iframe,
  ///the [url] parameter will have the current value of the `iframe.src` attribute.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.onPageFinished](https://developer.android.com/reference/android/webkit/WebViewClient#onPageFinished(android.webkit.WebView,%20java.lang.String)))
  ///- iOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455629-webview))
  ///- MacOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455629-webview))
  ///- Web ([Official API - Window.onload](https://developer.mozilla.org/en-US/docs/Web/API/Window/load_event))
  ///- Windows ([Official API - ICoreWebView2.add_NavigationCompleted](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/iwebview2webview?view=webview2-0.8.355#add_navigationcompleted))
  ///{@endtemplate}
  final void Function(T controller, WebUri? url)? onLoadStop;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onReceivedError}
  ///Event fired when the `WebView` encounters an [error] loading a [request].
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.onReceivedError](https://developer.android.com/reference/android/webkit/WebViewClient#onReceivedError(android.webkit.WebView,%20android.webkit.WebResourceRequest,%20android.webkit.WebResourceError)))
  ///- iOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455623-webview))
  ///- MacOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455623-webview))
  ///- Windows ([Official API - ICoreWebView2.add_NavigationCompleted](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/iwebview2webview?view=webview2-0.8.355#add_navigationcompleted))
  ///{@endtemplate}
  final void Function(
          T controller, WebResourceRequest request, WebResourceError error)?
      onReceivedError;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onReceivedHttpError}
  ///Event fired when the `WebView` receives an HTTP error.
  ///
  ///[request] represents the originating request.
  ///
  ///[errorResponse] represents the information about the error occurred.
  ///
  ///**NOTE**: available on Android 23+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.onReceivedHttpError](https://developer.android.com/reference/android/webkit/WebViewClient#onReceivedHttpError(android.webkit.WebView,%20android.webkit.WebResourceRequest,%20android.webkit.WebResourceResponse)))
  ///- iOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455643-webview))
  ///- MacOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455643-webview))
  ///- Windows ([Official API - ICoreWebView2.add_NavigationCompleted](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/iwebview2webview?view=webview2-0.8.355#add_navigationcompleted))
  ///{@endtemplate}
  final void Function(T controller, WebResourceRequest request,
      WebResourceResponse errorResponse)? onReceivedHttpError;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onProgressChanged}
  ///Event fired when the current [progress] of loading a page is changed.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onProgressChanged](https://developer.android.com/reference/android/webkit/WebChromeClient#onProgressChanged(android.webkit.WebView,%20int)))
  ///- iOS
  ///- MacOS
  ///{@endtemplate}
  final void Function(T controller, int progress)? onProgressChanged;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onConsoleMessage}
  ///Event fired when the `WebView` receives a [ConsoleMessage].
  ///
  ///**NOTE for Web**: this event will be called only if the iframe has the same origin.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onConsoleMessage](https://developer.android.com/reference/android/webkit/WebChromeClient#onConsoleMessage(android.webkit.ConsoleMessage)))
  ///- iOS
  ///- MacOS
  ///- Web
  ///{@endtemplate}
  final void Function(T controller, ConsoleMessage consoleMessage)?
      onConsoleMessage;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.shouldOverrideUrlLoading}
  ///Give the host application a chance to take control when a URL is about to be loaded in the current WebView.
  ///
  ///[navigationAction] represents an object that contains information about an action that causes navigation to occur.
  ///
  ///**NOTE**: In order to be able to listen this event, you need to set [InAppWebViewSettings.useShouldOverrideUrlLoading] setting to `true`.
  ///Also, on Android this event is not called on the first page load.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.shouldOverrideUrlLoading](https://developer.android.com/reference/android/webkit/WebViewClient#shouldOverrideUrlLoading(android.webkit.WebView,%20java.lang.String)))
  ///- iOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455641-webview))
  ///- MacOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455641-webview))
  ///{@endtemplate}
  final Future<NavigationActionPolicy?> Function(
          T controller, NavigationAction navigationAction)?
      shouldOverrideUrlLoading;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onLoadResource}
  ///Event fired when the `WebView` loads a resource.
  ///
  ///**NOTE**: In order to be able to listen this event, you need to set [InAppWebViewSettings.useOnLoadResource] and [InAppWebViewSettings.javaScriptEnabled] setting to `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///{@endtemplate}
  final void Function(T controller, LoadedResource resource)? onLoadResource;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onScrollChanged}
  ///Event fired when the `WebView` scrolls.
  ///
  ///[x] represents the current horizontal scroll origin in pixels.
  ///
  ///[y] represents the current vertical scroll origin in pixels.
  ///
  ///**NOTE for Web**: this event will be called only if the iframe has the same origin.
  ///
  ///**NOTE for MacOS**: this method is implemented with using JavaScript.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebView.onScrollChanged](https://developer.android.com/reference/android/webkit/WebView#onScrollChanged(int,%20int,%20int,%20int)))
  ///- iOS ([Official API - UIScrollViewDelegate.scrollViewDidScroll](https://developer.apple.com/documentation/uikit/uiscrollviewdelegate/1619392-scrollviewdidscroll))
  ///- Web ([Official API - Window.onscroll](https://developer.mozilla.org/en-US/docs/Web/API/GlobalEventHandlers/onscroll))
  ///- MacOS
  ///{@endtemplate}
  final void Function(T controller, int x, int y)? onScrollChanged;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onDownloadStartRequest}
  ///Event fired when `WebView` recognizes a downloadable file.
  ///To download the file, you can use the [flutter_downloader](https://pub.dev/packages/flutter_downloader) plugin.
  ///
  ///[downloadStartRequest] represents the request of the file to download.
  ///
  ///**NOTE**: In order to be able to listen this event, you need to set [InAppWebViewSettings.useOnDownloadStart] setting to `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebView.setDownloadListener](https://developer.android.com/reference/android/webkit/WebView#setDownloadListener(android.webkit.DownloadListener)))
  ///- iOS
  ///- MacOS
  ///{@endtemplate}
  final void Function(T controller, DownloadStartRequest downloadStartRequest)?
      onDownloadStartRequest;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onLoadResourceWithCustomScheme}
  ///Event fired when the `WebView` finds the `custom-scheme` while loading a resource.
  ///Here you can handle the url [request] and return a [CustomSchemeResponse] to load a specific resource encoded to `base64`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS ([Official API - WKURLSchemeHandler](https://developer.apple.com/documentation/webkit/wkurlschemehandler))
  ///- MacOS ([Official API - WKURLSchemeHandler](https://developer.apple.com/documentation/webkit/wkurlschemehandler))
  ///{@endtemplate}
  final Future<CustomSchemeResponse?> Function(
      T controller, WebResourceRequest request)? onLoadResourceWithCustomScheme;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onCreateWindow}
  ///Event fired when the `WebView` requests the host application to create a new window,
  ///for example when trying to open a link with `target="_blank"` or when `window.open()` is called by JavaScript side.
  ///If the host application chooses to honor this request, it should return `true` from this method, create a new WebView to host the window.
  ///If the host application chooses not to honor the request, it should return `false` from this method.
  ///The default implementation of this method does nothing and hence returns `false`.
  ///
  ///- [createWindowAction] represents the request.
  ///
  ///**NOTE**: to allow JavaScript to open windows, you need to set [InAppWebViewSettings.javaScriptCanOpenWindowsAutomatically] setting to `true`.
  ///
  ///**NOTE for Android**: you need to set [InAppWebViewSettings.supportMultipleWindows] setting to `true`.
  ///Also, if the request has been created using JavaScript (`window.open()`), then there are some limitation: check the [NavigationAction] class.
  ///
  ///**NOTE for iOS and MacOS**: setting these initial settings: [InAppWebViewSettings.supportZoom], [InAppWebViewSettings.useOnLoadResource], [InAppWebViewSettings.useShouldInterceptAjaxRequest],
  ///[InAppWebViewSettings.useShouldInterceptFetchRequest], [InAppWebViewSettings.applicationNameForUserAgent], [InAppWebViewSettings.javaScriptCanOpenWindowsAutomatically],
  ///[InAppWebViewSettings.javaScriptEnabled], [InAppWebViewSettings.minimumFontSize], [InAppWebViewSettings.preferredContentMode], [InAppWebViewSettings.incognito],
  ///[InAppWebViewSettings.cacheEnabled], [InAppWebViewSettings.mediaPlaybackRequiresUserGesture],
  ///[InAppWebViewSettings.resourceCustomSchemes], [InAppWebViewSettings.sharedCookiesEnabled],
  ///[InAppWebViewSettings.enableViewportScale], [InAppWebViewSettings.allowsAirPlayForMediaPlayback],
  ///[InAppWebViewSettings.allowsPictureInPictureMediaPlayback], [InAppWebViewSettings.isFraudulentWebsiteWarningEnabled],
  ///[InAppWebViewSettings.allowsInlineMediaPlayback], [InAppWebViewSettings.suppressesIncrementalRendering], [InAppWebViewSettings.selectionGranularity],
  ///[InAppWebViewSettings.ignoresViewportScaleLimits], [InAppWebViewSettings.limitsNavigationsToAppBoundDomains],
  ///[InAppWebViewSettings.upgradeKnownHostsToHTTPS],
  ///will have no effect due to a `WKWebView` limitation when creating the new window WebView: it's impossible to return the new `WKWebView`
  ///with a different `WKWebViewConfiguration` instance (see https://developer.apple.com/documentation/webkit/wkuidelegate/1536907-webview).
  ///So, these settings will be inherited from the caller WebView.
  ///Also, note that calling [InAppWebViewController.setSettings] method using the controller of the new created WebView,
  ///it will update also the WebView settings of the caller WebView.
  ///
  ///**NOTE for Web**: this event will be called only if the iframe has the same origin. It works only for `window.open()` javascript calls.
  ///Also, there is no way to block the opening the window in a synchronous way, so returning `true` will just close it quickly.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onCreateWindow](https://developer.android.com/reference/android/webkit/WebChromeClient#onCreateWindow(android.webkit.WebView,%20boolean,%20boolean,%20android.os.Message)))
  ///- iOS ([Official API - WKUIDelegate.webView](https://developer.apple.com/documentation/webkit/wkuidelegate/1536907-webview))
  ///- MacOS ([Official API - WKUIDelegate.webView](https://developer.apple.com/documentation/webkit/wkuidelegate/1536907-webview))
  ///- Web
  ///{@endtemplate}
  final Future<bool?> Function(
      T controller, CreateWindowAction createWindowAction)? onCreateWindow;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onCloseWindow}
  ///Event fired when the host application should close the given WebView and remove it from the view system if necessary.
  ///At this point, WebCore has stopped any loading in this window and has removed any cross-scripting ability in javascript.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onCloseWindow](https://developer.android.com/reference/android/webkit/WebChromeClient#onCloseWindow(android.webkit.WebView)))
  ///- iOS ([Official API - WKUIDelegate.webViewDidClose](https://developer.apple.com/documentation/webkit/wkuidelegate/1537390-webviewdidclose))
  ///- MacOS ([Official API - WKUIDelegate.webViewDidClose](https://developer.apple.com/documentation/webkit/wkuidelegate/1537390-webviewdidclose))
  ///{@endtemplate}
  final void Function(T controller)? onCloseWindow;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onWindowFocus}
  ///Event fired when the JavaScript `window` object of the WebView has received focus.
  ///This is the result of the `focus` JavaScript event applied to the `window` object.
  ///
  ///**NOTE for Web**: this event will be called only if the iframe has the same origin.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///- Web ([Official API - Window.onfocus](https://developer.mozilla.org/en-US/docs/Web/API/Window/focus_event))
  ///{@endtemplate}
  final void Function(T controller)? onWindowFocus;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onWindowBlur}
  ///Event fired when the JavaScript `window` object of the WebView has lost focus.
  ///This is the result of the `blur` JavaScript event applied to the `window` object.
  ///
  ///**NOTE for Web**: this event will be called only if the iframe has the same origin.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///- Web ([Official API - Window.onblur](https://developer.mozilla.org/en-US/docs/Web/API/Window/blur_event))
  ///{@endtemplate}
  final void Function(T controller)? onWindowBlur;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onJsAlert}
  ///Event fired when javascript calls the `alert()` method to display an alert dialog.
  ///If [JsAlertResponse.handledByClient] is `true`, the webview will assume that the client will handle the dialog.
  ///
  ///[jsAlertRequest] contains the message to be displayed in the alert dialog and the of the page requesting the dialog.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onJsAlert](https://developer.android.com/reference/android/webkit/WebChromeClient#onJsAlert(android.webkit.WebView,%20java.lang.String,%20java.lang.String,%20android.webkit.JsResult)))
  ///- iOS ([Official API - WKUIDelegate.webView](https://developer.apple.com/documentation/webkit/wkuidelegate/1537406-webview))
  ///- MacOS ([Official API - WKUIDelegate.webView](https://developer.apple.com/documentation/webkit/wkuidelegate/1537406-webview))
  ///{@endtemplate}
  final Future<JsAlertResponse?> Function(
      T controller, JsAlertRequest jsAlertRequest)? onJsAlert;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onJsConfirm}
  ///Event fired when javascript calls the `confirm()` method to display a confirm dialog.
  ///If [JsConfirmResponse.handledByClient] is `true`, the webview will assume that the client will handle the dialog.
  ///
  ///[jsConfirmRequest] contains the message to be displayed in the confirm dialog and the of the page requesting the dialog.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onJsConfirm](https://developer.android.com/reference/android/webkit/WebChromeClient#onJsConfirm(android.webkit.WebView,%20java.lang.String,%20java.lang.String,%20android.webkit.JsResult)))
  ///- iOS ([Official API - WKUIDelegate.webView](https://developer.apple.com/documentation/webkit/wkuidelegate/1536489-webview))
  ///- MacOS ([Official API - WKUIDelegate.webView](https://developer.apple.com/documentation/webkit/wkuidelegate/1536489-webview))
  ///{@endtemplate}
  final Future<JsConfirmResponse?> Function(
      T controller, JsConfirmRequest jsConfirmRequest)? onJsConfirm;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onJsPrompt}
  ///Event fired when javascript calls the `prompt()` method to display a prompt dialog.
  ///If [JsPromptResponse.handledByClient] is `true`, the webview will assume that the client will handle the dialog.
  ///
  ///[jsPromptRequest] contains the message to be displayed in the prompt dialog, the default value displayed in the prompt dialog, and the of the page requesting the dialog.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onJsPrompt](https://developer.android.com/reference/android/webkit/WebChromeClient#onJsPrompt(android.webkit.WebView,%20java.lang.String,%20java.lang.String,%20java.lang.String,%20android.webkit.JsPromptResult)))
  ///- iOS ([Official API - WKUIDelegate.webView](https://developer.apple.com/documentation/webkit/wkuidelegate/1538086-webview))
  ///- MacOS ([Official API - WKUIDelegate.webView](https://developer.apple.com/documentation/webkit/wkuidelegate/1538086-webview))
  ///{@endtemplate}
  final Future<JsPromptResponse?> Function(
      T controller, JsPromptRequest jsPromptRequest)? onJsPrompt;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onReceivedHttpAuthRequest}
  ///Event fired when the WebView received an HTTP authentication request. The default behavior is to cancel the request.
  ///
  ///[challenge] contains data about host, port, protocol, realm, etc. as specified in the [URLAuthenticationChallenge].
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.onReceivedHttpAuthRequest](https://developer.android.com/reference/android/webkit/WebViewClient#onReceivedHttpAuthRequest(android.webkit.WebView,%20android.webkit.HttpAuthHandler,%20java.lang.String,%20java.lang.String)))
  ///- iOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455638-webview))
  ///- MacOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455638-webview))
  ///{@endtemplate}
  final Future<HttpAuthResponse?> Function(
          T controller, HttpAuthenticationChallenge challenge)?
      onReceivedHttpAuthRequest;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onReceivedServerTrustAuthRequest}
  ///Event fired when the WebView need to perform server trust authentication (certificate validation).
  ///The host application must return either [ServerTrustAuthResponse] instance with [ServerTrustAuthResponseAction.CANCEL] or [ServerTrustAuthResponseAction.PROCEED].
  ///
  ///[challenge] contains data about host, port, protocol, realm, etc. as specified in the [ServerTrustChallenge].
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.onReceivedSslError](https://developer.android.com/reference/android/webkit/WebViewClient#onReceivedSslError(android.webkit.WebView,%20android.webkit.SslErrorHandler,%20android.net.http.SslError)))
  ///- iOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455638-webview))
  ///- MacOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455638-webview))
  ///{@endtemplate}
  final Future<ServerTrustAuthResponse?> Function(
          T controller, ServerTrustChallenge challenge)?
      onReceivedServerTrustAuthRequest;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onReceivedClientCertRequest}
  ///Notify the host application to handle an SSL client certificate request.
  ///Webview stores the response in memory (for the life of the application) if [ClientCertResponseAction.PROCEED] or [ClientCertResponseAction.CANCEL]
  ///is called and does not call [onReceivedClientCertRequest] again for the same host and port pair.
  ///Note that, multiple layers in chromium network stack might be caching the responses.
  ///
  ///[challenge] contains data about host, port, protocol, realm, etc. as specified in the [ClientCertChallenge].
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.onReceivedClientCertRequest](https://developer.android.com/reference/android/webkit/WebViewClient#onReceivedClientCertRequest(android.webkit.WebView,%20android.webkit.ClientCertRequest)))
  ///- iOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455638-webview))
  ///- MacOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455638-webview))
  ///{@endtemplate}
  final Future<ClientCertResponse?> Function(
      T controller, ClientCertChallenge challenge)? onReceivedClientCertRequest;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.shouldInterceptAjaxRequest}
  ///Event fired when an `XMLHttpRequest` is sent to a server.
  ///It gives the host application a chance to take control over the request before sending it.
  ///
  ///Due to the async nature of this event implementation, it will intercept only async `XMLHttpRequest`s ([AjaxRequest.isAsync] with `true`).
  ///To be able to intercept sync `XMLHttpRequest`s, use [InAppWebViewSettings.interceptOnlyAsyncAjaxRequests] to `false`.
  ///
  ///[ajaxRequest] represents the `XMLHttpRequest`.
  ///
  ///**NOTE**: In order to be able to listen this event, you need to set [InAppWebViewSettings.useShouldInterceptAjaxRequest] setting to `true`.
  ///Also, unlike iOS that has [WKUserScript](https://developer.apple.com/documentation/webkit/wkuserscript) that
  ///can inject javascript code right after the document element is created but before any other content is loaded, in Android the javascript code
  ///used to intercept ajax requests is loaded as soon as possible so it won't be instantaneous as iOS but just after some milliseconds (< ~100ms).
  ///Inside the `window.addEventListener("flutterInAppWebViewPlatformReady")` event, the ajax requests will be intercept for sure.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///{@endtemplate}
  final Future<AjaxRequest?> Function(T controller, AjaxRequest ajaxRequest)?
      shouldInterceptAjaxRequest;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onAjaxReadyStateChange}
  ///Event fired whenever the `readyState` attribute of an `XMLHttpRequest` changes.
  ///It gives the host application a chance to abort the request.
  ///
  ///[ajaxRequest] represents the [XMLHttpRequest].
  ///
  ///**NOTE**: In order to be able to listen this event, you need to set [InAppWebViewSettings.useShouldInterceptAjaxRequest] setting to `true`.
  ///Also, unlike iOS that has [WKUserScript](https://developer.apple.com/documentation/webkit/wkuserscript) that
  ///can inject javascript code right after the document element is created but before any other content is loaded, in Android the javascript code
  ///used to intercept ajax requests is loaded as soon as possible so it won't be instantaneous as iOS but just after some milliseconds (< ~100ms).
  ///Inside the `window.addEventListener("flutterInAppWebViewPlatformReady")` event, the ajax requests will be intercept for sure.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///{@endtemplate}
  final Future<AjaxRequestAction?> Function(
      T controller, AjaxRequest ajaxRequest)? onAjaxReadyStateChange;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onAjaxProgress}
  ///Event fired as an `XMLHttpRequest` progress.
  ///It gives the host application a chance to abort the request.
  ///
  ///[ajaxRequest] represents the [XMLHttpRequest].
  ///
  ///**NOTE**: In order to be able to listen this event, you need to set [InAppWebViewSettings.useShouldInterceptAjaxRequest] setting to `true`.
  ///Also, unlike iOS that has [WKUserScript](https://developer.apple.com/documentation/webkit/wkuserscript) that
  ///can inject javascript code right after the document element is created but before any other content is loaded, in Android the javascript code
  ///used to intercept ajax requests is loaded as soon as possible so it won't be instantaneous as iOS but just after some milliseconds (< ~100ms).
  ///Inside the `window.addEventListener("flutterInAppWebViewPlatformReady")` event, the ajax requests will be intercept for sure.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///{@endtemplate}
  final Future<AjaxRequestAction?> Function(
      T controller, AjaxRequest ajaxRequest)? onAjaxProgress;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.shouldInterceptFetchRequest}
  ///Event fired when a request is sent to a server through [Fetch API](https://developer.mozilla.org/it/docs/Web/API/Fetch_API).
  ///It gives the host application a chance to take control over the request before sending it.
  ///
  ///[fetchRequest] represents a resource request.
  ///
  ///**NOTE**: In order to be able to listen this event, you need to set [InAppWebViewSettings.useShouldInterceptFetchRequest] setting to `true`.
  ///Also, unlike iOS that has [WKUserScript](https://developer.apple.com/documentation/webkit/wkuserscript) that
  ///can inject javascript code right after the document element is created but before any other content is loaded, in Android the javascript code
  ///used to intercept fetch requests is loaded as soon as possible so it won't be instantaneous as iOS but just after some milliseconds (< ~100ms).
  ///Inside the `window.addEventListener("flutterInAppWebViewPlatformReady")` event, the fetch requests will be intercept for sure.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///{@endtemplate}
  final Future<FetchRequest?> Function(T controller, FetchRequest fetchRequest)?
      shouldInterceptFetchRequest;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onUpdateVisitedHistory}
  ///Event fired when the host application updates its visited links database.
  ///This event is also fired when the navigation state of the `WebView` changes through the usage of
  ///javascript **[History API](https://developer.mozilla.org/en-US/docs/Web/API/History_API)** functions (`pushState()`, `replaceState()`) and `onpopstate` event
  ///or, also, when the javascript `window.location` changes without reloading the webview (for example appending or modifying a hash to the url).
  ///
  ///[url] represents the url being visited.
  ///
  ///[isReload] indicates if this url is being reloaded. Available only on Android.
  ///
  ///**NOTE for Web**: this event will be called only if the iframe has the same origin.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.doUpdateVisitedHistory](https://developer.android.com/reference/android/webkit/WebViewClient#doUpdateVisitedHistory(android.webkit.WebView,%20java.lang.String,%20boolean)))
  ///- iOS
  ///- MacOS
  ///- Web
  ///- Windows ([Official API - ICoreWebView2.add_HistoryChanged](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2?view=webview2-1.0.2210.55#add_historychanged))
  ///{@endtemplate}
  final void Function(T controller, WebUri? url, bool? isReload)?
      onUpdateVisitedHistory;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onPrintRequest}
  ///Event fired when `window.print()` is called from JavaScript side.
  ///Return `true` if you want to handle the print job.
  ///Otherwise return `false`, so the [PlatformPrintJobController] will be handled and disposed automatically by the system.
  ///
  ///[url] represents the url on which is called.
  ///
  ///[printJobController] represents the controller of the print job created.
  ///**NOTE**: on Web, it is always `null`
  ///
  ///**NOTE for Web**: this event will be called only if the iframe has the same origin.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///- Web
  ///{@endtemplate}
  final Future<bool?> Function(T controller, WebUri? url,
      PlatformPrintJobController? printJobController)? onPrintRequest;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onLongPressHitTestResult}
  ///Event fired when an HTML element of the webview has been clicked and held.
  ///
  ///[hitTestResult] represents the hit result for hitting an HTML elements.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - View.setOnLongClickListener](https://developer.android.com/reference/android/view/View#setOnLongClickListener(android.view.View.OnLongClickListener)))
  ///- iOS ([Official API - UILongPressGestureRecognizer](https://developer.apple.com/documentation/uikit/uilongpressgesturerecognizer))
  ///{@endtemplate}
  final void Function(T controller, InAppWebViewHitTestResult hitTestResult)?
      onLongPressHitTestResult;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onEnterFullscreen}
  ///Event fired when the current page has entered full screen mode.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onShowCustomView](https://developer.android.com/reference/android/webkit/WebChromeClient#onShowCustomView(android.view.View,%20android.webkit.WebChromeClient.CustomViewCallback)))
  ///- iOS ([Official API - UIWindow.didBecomeVisibleNotification](https://developer.apple.com/documentation/uikit/uiwindow/1621621-didbecomevisiblenotification))
  ///- MacOS ([Official API - NSWindow.didEnterFullScreenNotification](https://developer.apple.com/documentation/appkit/nswindow/1419651-didenterfullscreennotification))
  ///- Web ([Official API - Document.onfullscreenchange](https://developer.mozilla.org/en-US/docs/Web/API/Document/fullscreenchange_event))
  ///{@endtemplate}
  final void Function(T controller)? onEnterFullscreen;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onExitFullscreen}
  ///Event fired when the current page has exited full screen mode.
  ///
  ///**Official Android API**: https://developer.android.com/reference/android/webkit/WebChromeClient#onHideCustomView()
  ///
  ///**Official iOS API**: https://developer.apple.com/documentation/uikit/uiwindow/1621617-didbecomehiddennotification
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onHideCustomView](https://developer.android.com/reference/android/webkit/WebChromeClient#onHideCustomView()))
  ///- iOS ([Official API - UIWindow.didBecomeHiddenNotification](https://developer.apple.com/documentation/uikit/uiwindow/1621617-didbecomehiddennotification))
  ///- MacOS ([Official API - NSWindow.didExitFullScreenNotification](https://developer.apple.com/documentation/appkit/nswindow/1419177-didexitfullscreennotification))
  ///- Web ([Official API - Document.onfullscreenchange](https://developer.mozilla.org/en-US/docs/Web/API/Document/fullscreenchange_event))
  ///{@endtemplate}
  final void Function(T controller)? onExitFullscreen;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onPageCommitVisible}
  ///Called when the web view begins to receive web content.
  ///
  ///This event occurs early in the document loading process, and as such
  ///you should expect that linked resources (for example, CSS and images) may not be available.
  ///
  ///[url] represents the URL corresponding to the page navigation that triggered this callback.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.onPageCommitVisible](https://developer.android.com/reference/android/webkit/WebViewClient#onPageCommitVisible(android.webkit.WebView,%20java.lang.String)))
  ///- iOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455635-webview))
  ///- MacOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455635-webview))
  ///{@endtemplate}
  final void Function(T controller, WebUri? url)? onPageCommitVisible;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onTitleChanged}
  ///Event fired when a change in the document title occurred.
  ///
  ///[title] represents the string containing the new title of the document.
  ///
  ///**NOTE for Web**: this event will be called only if the iframe has the same origin.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onReceivedTitle](https://developer.android.com/reference/android/webkit/WebChromeClient#onReceivedTitle(android.webkit.WebView,%20java.lang.String)))
  ///- iOS
  ///- MacOS
  ///- Web
  ///- Windows ([Official API - ICoreWebView2.add_DocumentTitleChanged](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2?view=webview2-1.0.2210.55#add_documenttitlechanged))
  ///{@endtemplate}
  final void Function(T controller, String? title)? onTitleChanged;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onOverScrolled}
  ///Event fired to respond to the results of an over-scroll operation.
  ///
  ///[x] represents the new X scroll value in pixels.
  ///
  ///[y] represents the new Y scroll value in pixels.
  ///
  ///[clampedX] is `true` if [x] was clamped to an over-scroll boundary.
  ///
  ///[clampedY] is `true` if [y] was clamped to an over-scroll boundary.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebView.onOverScrolled](https://developer.android.com/reference/android/webkit/WebView#onOverScrolled(int,%20int,%20boolean,%20boolean)))
  ///- iOS
  ///{@endtemplate}
  final void Function(T controller, int x, int y, bool clampedX, bool clampedY)?
      onOverScrolled;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onJsBeforeUnload}
  ///Event fired when the client should display a dialog to confirm navigation away from the current page.
  ///This is the result of the `onbeforeunload` javascript event.
  ///If [JsBeforeUnloadResponse.handledByClient] is `true`, WebView will assume that the client will handle the confirm dialog.
  ///If [JsBeforeUnloadResponse.handledByClient] is `false`, a default value of `true` will be returned to javascript to accept navigation away from the current page.
  ///The default behavior is to return `false`.
  ///Setting the [JsBeforeUnloadResponse.action] to [JsBeforeUnloadResponseAction.CONFIRM] will navigate away from the current page,
  ///[JsBeforeUnloadResponseAction.CANCEL] will cancel the navigation.
  ///
  ///[jsBeforeUnloadRequest] contains the message to be displayed in the alert dialog and the of the page requesting the dialog.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onJsBeforeUnload](https://developer.android.com/reference/android/webkit/WebChromeClient#onJsBeforeUnload(android.webkit.WebView,%20java.lang.String,%20java.lang.String,%20android.webkit.JsResult)))
  ///{@endtemplate}
  final Future<JsBeforeUnloadResponse?> Function(
          T controller, JsBeforeUnloadRequest jsBeforeUnloadRequest)?
      onJsBeforeUnload;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onReceivedLoginRequest}
  ///Event fired when a request to automatically log in the user has been processed.
  ///
  ///[loginRequest] contains the realm, account and args of the login request.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.onReceivedLoginRequest](https://developer.android.com/reference/android/webkit/WebViewClient#onReceivedLoginRequest(android.webkit.WebView,%20java.lang.String,%20java.lang.String,%20java.lang.String)))
  ///{@endtemplate}
  final void Function(T controller, LoginRequest loginRequest)?
      onReceivedLoginRequest;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onPermissionRequestCanceled}
  ///Notify the host application that the given permission request has been canceled. Any related UI should therefore be hidden.
  ///
  ///[permissionRequest] represents the permission request that needs be canceled
  ///with an array of resources the web content wants to access
  ///and the origin of the web page which is trying to access the restricted resources.
  ///
  ///**NOTE for Android**: available only on Android 21+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onPermissionRequestCanceled](https://developer.android.com/reference/android/webkit/WebChromeClient#onPermissionRequestCanceled(android.webkit.PermissionRequest)))
  ///{@endtemplate}
  final void Function(T controller, PermissionRequest permissionRequest)?
      onPermissionRequestCanceled;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onRequestFocus}
  ///Request display and focus for this WebView.
  ///This may happen due to another WebView opening a link in this WebView and requesting that this WebView be displayed.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onRequestFocus](https://developer.android.com/reference/android/webkit/WebChromeClient#onRequestFocus(android.webkit.WebView)))
  ///{@endtemplate}
  final void Function(T controller)? onRequestFocus;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onWebContentProcessDidTerminate}
  ///Invoked when the web view's web content process is terminated.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS ([Official API - WKNavigationDelegate.webViewWebContentProcessDidTerminate](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455639-webviewwebcontentprocessdidtermi))
  ///- MacOS ([Official API - WKNavigationDelegate.webViewWebContentProcessDidTerminate](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455639-webviewwebcontentprocessdidtermi))
  ///{@endtemplate}
  final void Function(T controller)? onWebContentProcessDidTerminate;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onDidReceiveServerRedirectForProvisionalNavigation}
  ///Called when a web view receives a server redirect.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455627-webview))
  ///- MacOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455627-webview))
  ///{@endtemplate}
  final void Function(T controller)?
      onDidReceiveServerRedirectForProvisionalNavigation;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onNavigationResponse}
  ///Called when a web view asks for permission to navigate to new content after the response to the navigation request is known.
  ///
  ///[navigationResponse] represents the navigation response.
  ///
  ///**NOTE**: In order to be able to listen this event, you need to set [InAppWebViewSettings.useOnNavigationResponse] setting to `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455643-webview))
  ///- MacOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455643-webview))
  ///{@endtemplate}
  final Future<NavigationResponseAction?> Function(
          T controller, NavigationResponse navigationResponse)?
      onNavigationResponse;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.shouldAllowDeprecatedTLS}
  ///Called when a web view asks whether to continue with a connection that uses a deprecated version of TLS (v1.0 and v1.1).
  ///
  ///[challenge] represents the authentication challenge.
  ///
  ///**NOTE for iOS**: available only on iOS 14.0+.
  ///
  ///**NOTE for MacOS**: available only on MacOS 11.0+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/3601237-webview))
  ///- MacOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/3601237-webview))
  ///{@endtemplate}
  final Future<ShouldAllowDeprecatedTLSAction?> Function(
          T controller, URLAuthenticationChallenge challenge)?
      shouldAllowDeprecatedTLS;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onCameraCaptureStateChanged}
  ///Event fired when a change in the camera capture state occurred.
  ///
  ///**NOTE for iOS**: available only on iOS 15.0+.
  ///
  ///**NOTE for MacOS**: available only on MacOS 12.0+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  ///- MacOS
  ///{@endtemplate}
  final Future<void> Function(
    T controller,
    MediaCaptureState? oldState,
    MediaCaptureState? newState,
  )? onCameraCaptureStateChanged;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onMicrophoneCaptureStateChanged}
  ///Event fired when a change in the microphone capture state occurred.
  ///
  ///**NOTE for iOS**: available only on iOS 15.0+.
  ///
  ///**NOTE for MacOS**: available only on MacOS 12.0+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  ///- MacOS
  ///{@endtemplate}
  final Future<void> Function(
    T controller,
    MediaCaptureState? oldState,
    MediaCaptureState? newState,
  )? onMicrophoneCaptureStateChanged;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onZoomScaleChanged}
  ///Event fired when the zoom scale of the `WebView` changes.
  ///
  ///[oldScale] represents the old zoom scale value.
  ///
  ///[newScale] represents the new zoom scale value.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  ///{@endtemplate}
  final void Function(T controller, double oldScale, double newScale)?
      onZoomScaleChanged;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onSafeBrowsingHit}
  ///Event fired when the webview notifies that a loading has been flagged by Safe Browsing.
  ///The Safe Browsing hit is for the [url] with a specific [threatType].
  ///
  ///[threatType] represents the reason why the page was flagged by Safe Browsing.
  ///
  ///**NOTE**: available only on Android 27+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.onSafeBrowsingHit](https://developer.android.com/reference/android/webkit/WebViewClient#onSafeBrowsingHit(android.webkit.WebView,%20android.webkit.WebResourceRequest,%20int,%20android.webkit.SafeBrowsingResponse)))
  ///{@endtemplate}
  final Future<SafeBrowsingResponse?> Function(
      T controller, WebUri url, SafeBrowsingThreat? threatType)?
      onSafeBrowsingHit;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onPermissionRequest}
  ///Event fired when the webview is requesting a permission to access a specific resource.
  ///
  ///[permissionRequest] represents the permission request.
  ///
  ///**NOTE for Android**: available only on Android 21+.
  ///
  ///**NOTE for iOS**: available only on iOS 15.0+.
  ///
  ///**NOTE for MacOS**: available only on MacOS 12.0+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onPermissionRequest](https://developer.android.com/reference/android/webkit/WebChromeClient#onPermissionRequest(android.webkit.PermissionRequest)))
  ///- iOS ([Official API - WKUIDelegate.webView](https://developer.apple.com/documentation/webkit/wkuidelegate/3763033-webview))
  ///- MacOS ([Official API - WKUIDelegate.webView](https://developer.apple.com/documentation/webkit/wkuidelegate/3763033-webview))
  ///{@endtemplate}
  final Future<PermissionResponse?> Function(
          T controller, PermissionRequest permissionRequest)?
      onPermissionRequest;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onGeolocationPermissionsShowPrompt}
  ///Event fired when the webview is requesting a permission to access the geolocation.
  ///
  ///[origin] represents the origin of the web page which is trying to access the restricted resources.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onGeolocationPermissionsShowPrompt](https://developer.android.com/reference/android/webkit/WebChromeClient#onGeolocationPermissionsShowPrompt(java.lang.String,%20android.webkit.GeolocationPermissions.Callback)))
  ///{@endtemplate}
  final Future<GeolocationPermissionShowPromptResponse?> Function(
      T controller, String origin)? onGeolocationPermissionsShowPrompt;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onGeolocationPermissionsHidePrompt}
  ///Event fired when the webview is hiding the geolocation permission prompt.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onGeolocationPermissionsHidePrompt](https://developer.android.com/reference/android/webkit/WebChromeClient#onGeolocationPermissionsHidePrompt()))
  ///{@endtemplate}
  final void Function(T controller)? onGeolocationPermissionsHidePrompt;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.shouldInterceptRequest}
  ///Notify the host application of a resource request and allow the application to return the data.
  ///If the return value is `null`, the WebView will continue to load the resource as usual.
  ///Otherwise, the return response and data will be used.
  ///
  ///[request] represents the resource request.
  ///
  ///**NOTE**: available only on Android 21+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.shouldInterceptRequest](https://developer.android.com/reference/android/webkit/WebViewClient#shouldInterceptRequest(android.webkit.WebView,%20android.webkit.WebResourceRequest)))
  ///{@endtemplate}
  final Future<WebResourceResponse?> Function(
          T controller, WebResourceRequest request)? shouldInterceptRequest;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onRenderProcessGone}
  ///Event fired when the given WebView's render process has exited.
  ///The cause of the render process exit can be anything from a crash due to a bug in the WebView to a memory-intensive process being killed by the system.
  ///
  ///[detail] represents the reason why the render process has exited.
  ///
  ///**NOTE**: available only on Android 26+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.onRenderProcessGone](https://developer.android.com/reference/android/webkit/WebViewClient#onRenderProcessGone(android.webkit.WebView,%20android.webkit.RenderProcessGoneDetail)))
  ///{@endtemplate}
  final void Function(T controller, RenderProcessGoneDetail detail)?
      onRenderProcessGone;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onRenderProcessResponsive}
  ///Event fired when the WebView's render process has become responsive again.
  ///
  ///**NOTE**: available only on Android 29+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewRenderProcessClient.onRenderProcessResponsive](https://developer.android.com/reference/android/webkit/WebViewRenderProcessClient#onRenderProcessResponsive(android.webkit.WebView,%20android.webkit.WebViewRenderProcess)))
  ///{@endtemplate}
  final void Function(T controller)? onRenderProcessResponsive;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onRenderProcessUnresponsive}
  ///Event fired when the WebView's render process has become unresponsive.
  ///
  ///**NOTE**: available only on Android 29+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewRenderProcessClient.onRenderProcessUnresponsive](https://developer.android.com/reference/android/webkit/WebViewRenderProcessClient#onRenderProcessUnresponsive(android.webkit.WebView,%20android.webkit.WebViewRenderProcess)))
  ///{@endtemplate}
  final void Function(T controller)? onRenderProcessUnresponsive;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onFormResubmission}
  ///As the host application if the browser should resend data as the requested page was the result of a POST. The default is to not resend the data.
  ///
  ///[url] represents the url being visited.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.onFormResubmission](https://developer.android.com/reference/android/webkit/WebViewClient#onFormResubmission(android.webkit.WebView,%20android.os.Message,%20android.os.Message)))
  ///{@endtemplate}
  final Future<FormResubmissionAction?> Function(T controller, WebUri? url)?
      onFormResubmission;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onReceivedIcon}
  ///Event fired when the document title of the current page has been received.
  ///
  ///[icon] represents the icon of the current page.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onReceivedIcon](https://developer.android.com/reference/android/webkit/WebChromeClient#onReceivedIcon(android.webkit.WebView,%20android.graphics.Bitmap)))
  ///{@endtemplate}
  final void Function(T controller, Uint8List icon)? onReceivedIcon;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onReceivedTouchIconUrl}
  ///Event fired when there is a new favicon for the current page.
  ///
  ///[url] represents the favicon url.
  ///
  ///[precomposed] is `true` if the favicon is precomposed.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebChromeClient.onReceivedTouchIconUrl](https://developer.android.com/reference/android/webkit/WebChromeClient#onReceivedTouchIconUrl(android.webkit.WebView,%20java.lang.String,%20boolean)))
  ///{@endtemplate}
  final void Function(T controller, WebUri url, bool precomposed)?
      onReceivedTouchIconUrl;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onContentSizeChanged}
  ///Event fired when the content size of the `WebView` changes.
  ///
  ///[oldContentSize] represents the old content size value.
  ///
  ///[newContentSize] represents the new content size value.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  ///{@endtemplate}
  final void Function(T controller, Size oldContentSize, Size newContentSize)?
      onContentSizeChanged;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.initialUrlRequest}
  ///Initial url request that will be loaded.
  ///
  ///**NOTE for Android**: when loading an URL Request using "POST" method, headers are ignored.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///- Web
  ///- Windows
  ///{@endtemplate}
  final URLRequest? initialUrlRequest;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.initialFile}
  ///Initial asset file that will be loaded. See [InAppWebViewController.loadFile] for explanation.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///- Web
  ///- Windows
  ///{@endtemplate}
  final String? initialFile;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.initialData}
  ///Initial [InAppWebViewInitialData] that will be loaded.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///- Web
  ///- Windows
  ///{@endtemplate}
  final InAppWebViewInitialData? initialData;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.initialSettings}
  ///Initial settings that will be used.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///- Web
  ///{@endtemplate}
  final InAppWebViewSettings? initialSettings;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.contextMenu}
  ///Context menu which contains custom menu items to be shown when [ContextMenu] is presented.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///{@endtemplate}
  final ContextMenu? contextMenu;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.initialUserScripts}
  ///Initial list of user scripts to be loaded at start or end of a page loading.
  ///To add or remove user scripts, you have to use the [InAppWebViewController]'s methods such as [InAppWebViewController.addUserScript],
  ///[InAppWebViewController.removeUserScript], [InAppWebViewController.removeAllUserScripts], etc.
  ///
  ///**NOTE for iOS**: this property will be ignored if the [PlatformWebViewCreationParams.windowId] has been set.
  ///There isn't any way to add/remove user scripts specific to iOS window WebViews.
  ///This is a limitation of the native iOS WebKit APIs.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///- Windows
  ///{@endtemplate}
  final UnmodifiableListView<UserScript>? initialUserScripts;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.pullToRefreshController}
  ///Represents the pull-to-refresh feature controller.
  ///
  ///**NOTE for Android**: to be able to use the "pull-to-refresh" feature, [InAppWebViewSettings.useHybridComposition] must be `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  ///{@endtemplate}
  final PlatformPullToRefreshController? pullToRefreshController;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.findInteractionController}
  ///Represents the find interaction feature controller.
  ///
  ///_**Officially Supported Platforms/Implementations**:_
  ///- Android native WebView
  ///- iOS
  ///- MacOS
  ///{@endtemplate}
  final PlatformFindInteractionController? findInteractionController;

  ///{@template zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams.onFindResultReceived}
  ///Event fired when a find result is received.
  ///
  ///[activeMatchOrdinal] represents the ordinal of the currently active match.
  ///
  ///[numberOfMatches] represents the number of matches found.
  ///
  ///[isDoneCounting] represents whether the counting is done.
  ///{@endtemplate}
  final void Function(
      int activeMatchOrdinal,
      int numberOfMatches,
      bool isDoneCounting)? onFindResultReceived;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebViewCreationParams}
  const PlatformWebViewCreationParams(
      {this.controllerFromPlatform,
      this.windowId,
      this.onWebViewCreated,
      this.onLoadStart,
      this.onLoadStop,
      this.onReceivedError,
      this.onReceivedHttpError,
      this.onProgressChanged,
      this.onConsoleMessage,
      this.shouldOverrideUrlLoading,
      this.onLoadResource,
      this.onScrollChanged,
      this.onDownloadStartRequest,
      this.onLoadResourceWithCustomScheme,
      this.onCreateWindow,
      this.onCloseWindow,
      this.onJsAlert,
      this.onJsConfirm,
      this.onJsPrompt,
      this.onReceivedHttpAuthRequest,
      this.onReceivedServerTrustAuthRequest,
      this.onReceivedClientCertRequest,
      this.shouldInterceptAjaxRequest,
      this.onAjaxReadyStateChange,
      this.onAjaxProgress,
      this.shouldInterceptFetchRequest,
      this.onUpdateVisitedHistory,
      this.onPrintRequest,
      this.onLongPressHitTestResult,
      this.onEnterFullscreen,
      this.onExitFullscreen,
      this.onPageCommitVisible,
      this.onTitleChanged,
      this.onWindowFocus,
      this.onWindowBlur,
      this.onOverScrolled,
      this.onZoomScaleChanged,
      this.onSafeBrowsingHit,
      this.onPermissionRequest,
      this.onGeolocationPermissionsShowPrompt,
      this.onGeolocationPermissionsHidePrompt,
      this.shouldInterceptRequest,
      this.onRenderProcessGone,
      this.onRenderProcessResponsive,
      this.onRenderProcessUnresponsive,
      this.onFormResubmission,
      this.onReceivedIcon,
      this.onReceivedTouchIconUrl,
      this.onJsBeforeUnload,
      this.onReceivedLoginRequest,
      this.onPermissionRequestCanceled,
      this.onRequestFocus,
      this.onWebContentProcessDidTerminate,
      this.onDidReceiveServerRedirectForProvisionalNavigation,
      this.onNavigationResponse,
      this.shouldAllowDeprecatedTLS,
      this.onCameraCaptureStateChanged,
      this.onMicrophoneCaptureStateChanged,
      this.onContentSizeChanged,
      this.initialUrlRequest,
      this.initialFile,
      this.initialData,
      this.initialSettings,
      this.contextMenu,
      this.initialUserScripts,
      this.pullToRefreshController,
      this.findInteractionController,
      this.onFindResultReceived});
}
