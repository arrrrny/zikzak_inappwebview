import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../find_interaction/find_interaction_controller.dart';
import '../util/wire.dart';
import 'in_app_webview_controller.dart';
import 'custom_platform_view.dart';

/// Object specifying creation parameters for creating a [PlatformInAppWebViewWidget].
///
/// Platform specific implementations can add additional fields by extending
/// this class.
class LinuxInAppWebViewWidgetCreationParams
    extends PlatformInAppWebViewWidgetCreationParams {
  LinuxInAppWebViewWidgetCreationParams({
    super.key,
    super.layoutDirection,
    super.gestureRecognizers,
    super.headlessWebView,
    super.keepAlive,
    super.preventGestureDelay,
    super.webViewEnvironment,
    super.controllerFromPlatform,
    super.windowId,
    super.onWebViewCreated,
    super.onLoadStart,
    super.onLoadStop,
    super.onReceivedError,
    super.onReceivedHttpError,
    super.onProgressChanged,
    super.onConsoleMessage,
    super.shouldOverrideUrlLoading,
    super.onLoadResource,
    super.onScrollChanged,
    super.onDownloadStartRequest,
    super.onLoadResourceWithCustomScheme,
    super.onCreateWindow,
    super.onCloseWindow,
    super.onJsAlert,
    super.onJsConfirm,
    super.onJsPrompt,
    super.onReceivedHttpAuthRequest,
    super.onReceivedServerTrustAuthRequest,
    super.onReceivedClientCertRequest,
    super.shouldInterceptAjaxRequest,
    super.onAjaxReadyStateChange,
    super.onAjaxProgress,
    super.shouldInterceptFetchRequest,
    super.onUpdateVisitedHistory,
    super.onPrintRequest,
    super.onLongPressHitTestResult,
    super.onEnterFullscreen,
    super.onExitFullscreen,
    super.onPageCommitVisible,
    super.onTitleChanged,
    super.onWindowFocus,
    super.onWindowBlur,
    super.onOverScrolled,
    super.onZoomScaleChanged,
    super.onSafeBrowsingHit,
    super.onPermissionRequest,
    super.onGeolocationPermissionsShowPrompt,
    super.onGeolocationPermissionsHidePrompt,
    super.shouldInterceptRequest,
    super.onRenderProcessGone,
    super.onRenderProcessResponsive,
    super.onRenderProcessUnresponsive,
    super.onFormResubmission,
    super.onReceivedIcon,
    super.onReceivedTouchIconUrl,
    super.onJsBeforeUnload,
    super.onReceivedLoginRequest,
    super.onPermissionRequestCanceled,
    super.onRequestFocus,
    super.onWebContentProcessDidTerminate,
    super.onDidReceiveServerRedirectForProvisionalNavigation,
    super.onNavigationResponse,
    super.shouldAllowDeprecatedTLS,
    super.onCameraCaptureStateChanged,
    super.onMicrophoneCaptureStateChanged,
    super.onContentSizeChanged,
    super.onNetworkRequest,
    super.onNetworkResponse,
    super.onNetworkLoadingFinished,
    super.initialUrlRequest,
    super.initialFile,
    super.initialData,
    super.initialSettings,
    super.contextMenu,
    super.initialUserScripts,
    super.pullToRefreshController,
    super.findInteractionController,
  });

  /// Constructs a [LinuxInAppWebViewWidgetCreationParams] using a
  /// [PlatformInAppWebViewWidgetCreationParams].
  LinuxInAppWebViewWidgetCreationParams.fromPlatformInAppWebViewWidgetCreationParams(
    PlatformInAppWebViewWidgetCreationParams params,
  ) : this(
        key: params.key,
        layoutDirection: params.layoutDirection,
        gestureRecognizers: params.gestureRecognizers,
        headlessWebView: params.headlessWebView,
        keepAlive: params.keepAlive,
        preventGestureDelay: params.preventGestureDelay,
        webViewEnvironment: params.webViewEnvironment,
        controllerFromPlatform: params.controllerFromPlatform,
        windowId: params.windowId,
        onWebViewCreated: params.onWebViewCreated,
        onLoadStart: params.onLoadStart,
        onLoadStop: params.onLoadStop,
        onReceivedError: params.onReceivedError,
        onReceivedHttpError: params.onReceivedHttpError,
        onProgressChanged: params.onProgressChanged,
        onConsoleMessage: params.onConsoleMessage,
        shouldOverrideUrlLoading: params.shouldOverrideUrlLoading,
        onLoadResource: params.onLoadResource,
        onScrollChanged: params.onScrollChanged,
        onDownloadStartRequest: params.onDownloadStartRequest,
        onLoadResourceWithCustomScheme: params.onLoadResourceWithCustomScheme,
        onCreateWindow: params.onCreateWindow,
        onCloseWindow: params.onCloseWindow,
        onJsAlert: params.onJsAlert,
        onJsConfirm: params.onJsConfirm,
        onJsPrompt: params.onJsPrompt,
        onReceivedHttpAuthRequest: params.onReceivedHttpAuthRequest,
        onReceivedServerTrustAuthRequest: params.onReceivedServerTrustAuthRequest,
        onReceivedClientCertRequest: params.onReceivedClientCertRequest,
        shouldInterceptAjaxRequest: params.shouldInterceptAjaxRequest,
        onAjaxReadyStateChange: params.onAjaxReadyStateChange,
        onAjaxProgress: params.onAjaxProgress,
        shouldInterceptFetchRequest: params.shouldInterceptFetchRequest,
        onUpdateVisitedHistory: params.onUpdateVisitedHistory,
        onPrintRequest: params.onPrintRequest,
        onLongPressHitTestResult: params.onLongPressHitTestResult,
        onEnterFullscreen: params.onEnterFullscreen,
        onExitFullscreen: params.onExitFullscreen,
        onPageCommitVisible: params.onPageCommitVisible,
        onTitleChanged: params.onTitleChanged,
        onWindowFocus: params.onWindowFocus,
        onWindowBlur: params.onWindowBlur,
        onOverScrolled: params.onOverScrolled,
        onZoomScaleChanged: params.onZoomScaleChanged,
        onSafeBrowsingHit: params.onSafeBrowsingHit,
        onPermissionRequest: params.onPermissionRequest,
        onGeolocationPermissionsShowPrompt: params.onGeolocationPermissionsShowPrompt,
        onGeolocationPermissionsHidePrompt: params.onGeolocationPermissionsHidePrompt,
        shouldInterceptRequest: params.shouldInterceptRequest,
        onRenderProcessGone: params.onRenderProcessGone,
        onRenderProcessResponsive: params.onRenderProcessResponsive,
        onRenderProcessUnresponsive: params.onRenderProcessUnresponsive,
        onFormResubmission: params.onFormResubmission,
        onReceivedIcon: params.onReceivedIcon,
        onReceivedTouchIconUrl: params.onReceivedTouchIconUrl,
        onJsBeforeUnload: params.onJsBeforeUnload,
        onReceivedLoginRequest: params.onReceivedLoginRequest,
        onPermissionRequestCanceled: params.onPermissionRequestCanceled,
        onRequestFocus: params.onRequestFocus,
        onWebContentProcessDidTerminate: params.onWebContentProcessDidTerminate,
        onDidReceiveServerRedirectForProvisionalNavigation: params.onDidReceiveServerRedirectForProvisionalNavigation,
        onNavigationResponse: params.onNavigationResponse,
        shouldAllowDeprecatedTLS: params.shouldAllowDeprecatedTLS,
        onCameraCaptureStateChanged: params.onCameraCaptureStateChanged,
        onMicrophoneCaptureStateChanged: params.onMicrophoneCaptureStateChanged,
        onContentSizeChanged: params.onContentSizeChanged,
        onNetworkRequest: params.onNetworkRequest,
        onNetworkResponse: params.onNetworkResponse,
        onNetworkLoadingFinished: params.onNetworkLoadingFinished,
        initialUrlRequest: params.initialUrlRequest,
        initialFile: params.initialFile,
        initialData: params.initialData,
        initialSettings: params.initialSettings,
        contextMenu: params.contextMenu,
        initialUserScripts: params.initialUserScripts,
        pullToRefreshController: params.pullToRefreshController,
        findInteractionController: params.findInteractionController,
      );
}

///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewWidget}
class LinuxInAppWebViewWidget extends PlatformInAppWebViewWidget {
  /// Constructs a [LinuxInAppWebViewWidget].
  ///
  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewWidget}
  LinuxInAppWebViewWidget(PlatformInAppWebViewWidgetCreationParams params)
    : super.implementation(
        params is LinuxInAppWebViewWidgetCreationParams
            ? params
            : LinuxInAppWebViewWidgetCreationParams.fromPlatformInAppWebViewWidgetCreationParams(
                params,
              ),
      );

  LinuxInAppWebViewWidgetCreationParams get _linuxParams =>
      params as LinuxInAppWebViewWidgetCreationParams;

  LinuxInAppWebViewController? _controller;

  static final LinuxInAppWebViewWidget _staticValue = LinuxInAppWebViewWidget(
    LinuxInAppWebViewWidgetCreationParams(),
  );

  factory LinuxInAppWebViewWidget.static() {
    return _staticValue;
  }

  @override
  Widget build(BuildContext context) {
    final initialSettings = _inferInitialSettings(
      params.initialSettings ?? InAppWebViewSettings(),
    );
    Map<String, dynamic> settingsMap = withAjaxEventFlags(
      inAppWebViewSettingsToWire(initialSettings),
      onReadyStateChange: params.onAjaxReadyStateChange != null,
      onProgress: params.onAjaxProgress != null,
    );

    if ((params.headlessWebView?.isRunning() ?? false) &&
        params.keepAlive != null) {
      final headlessId = params.headlessWebView?.id;
      if (headlessId != null) {
        // force keep alive id to match headless webview id
        params.keepAlive?.id = headlessId;
      }
    }

    return CustomPlatformView(
      onPlatformViewCreated: _onPlatformViewCreated,
      creationParams: <String, dynamic>{
        'initialUrlRequest': params.initialUrlRequest?.toJson(),
        'initialFile': params.initialFile,
        'initialData': params.initialData?.toJson(),
        'initialSettings': settingsMap,
        'contextMenu': params.contextMenu?.toMap() ?? {},
        'windowId': params.windowId,
        'headlessWebViewId': params.headlessWebView?.isRunning() ?? false
            ? params.headlessWebView?.id
            : null,
        'initialUserScripts':
            params.initialUserScripts?.map(userScriptToWire).toList() ?? [],
        'keepAliveId': params.keepAlive?.id,
      },
    );
  }

  void _onPlatformViewCreated(int id) {
    dynamic viewId = id;
    if (params.headlessWebView?.isRunning() ?? false) {
      viewId = params.headlessWebView?.id;
    }
    viewId = params.keepAlive?.id ?? viewId ?? id;

    _controller = LinuxInAppWebViewController(
      PlatformInAppWebViewControllerCreationParams(
        id: viewId,
        webviewParams: params,
      ),
    );

    // Initialize the find interaction controller with the same view ID
    if (_linuxParams.findInteractionController != null) {
      var findInteractionController =
          _linuxParams.findInteractionController
              as LinuxFindInteractionController;
      findInteractionController.init(viewId);
    }

    debugLog(
      className: runtimeType.toString(),
      id: viewId?.toString(),
      debugLoggingSettings: PlatformInAppWebViewController.debugLoggingSettings,
      method: "onWebViewCreated",
      args: [],
    );
    if (params.onWebViewCreated != null) {
      params.onWebViewCreated!(
        params.controllerFromPlatform?.call(_controller!) ?? _controller!,
      );
    }
  }

  InAppWebViewSettings _inferInitialSettings(InAppWebViewSettings settings) {
    var inferred = settings;
    if (params.shouldOverrideUrlLoading != null &&
        settings.useShouldOverrideUrlLoading == null) {
      inferred = inferred.copyWith(useShouldOverrideUrlLoading: true);
    }
    if (params.onLoadResource != null && settings.useOnLoadResource == null) {
      inferred = inferred.copyWith(useOnLoadResource: true);
    }
    if (params.onDownloadStartRequest != null &&
        settings.useOnDownloadStart == null) {
      inferred = inferred.copyWith(useOnDownloadStart: true);
    }
    if ((params.shouldInterceptAjaxRequest != null ||
            params.onAjaxProgress != null ||
            params.onAjaxReadyStateChange != null) &&
        settings.useShouldInterceptAjaxRequest == null) {
      inferred = inferred.copyWith(useShouldInterceptAjaxRequest: true);
    }
    if (params.shouldInterceptFetchRequest != null &&
        settings.useShouldInterceptFetchRequest == null) {
      inferred = inferred.copyWith(useShouldInterceptFetchRequest: true);
    }
    if (params.shouldInterceptRequest != null &&
        settings.useShouldInterceptRequest == null) {
      inferred = inferred.copyWith(useShouldInterceptRequest: true);
    }
    if (params.onRenderProcessGone != null &&
        settings.useOnRenderProcessGone == null) {
      inferred = inferred.copyWith(useOnRenderProcessGone: true);
    }
    if (params.onNavigationResponse != null &&
        settings.useOnNavigationResponse == null) {
      inferred = inferred.copyWith(useOnNavigationResponse: true);
    }
    return inferred;
  }

  @override
  void dispose({bool isKeepAlive = false}) {
    dynamic viewId = _controller?.id;
    debugLog(
      className: runtimeType.toString(),
      id: viewId?.toString(),
      debugLoggingSettings: PlatformInAppWebViewController.debugLoggingSettings,
      method: "dispose",
      args: [],
    );
    final keepAlive = isKeepAlive || params.keepAlive != null;
    _controller?.dispose(isKeepAlive: keepAlive);
    _controller = null;
    params.findInteractionController?.dispose(isKeepAlive: keepAlive);
  }

  @override
  T controllerFromPlatform<T>(PlatformInAppWebViewController controller) {
    // unused
    throw UnimplementedError();
  }
}
