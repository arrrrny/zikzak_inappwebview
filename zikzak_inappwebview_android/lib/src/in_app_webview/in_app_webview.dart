import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'headless_in_app_webview.dart';

import '../find_interaction/find_interaction_controller.dart';
import 'in_app_webview_controller.dart';
import '../pull_to_refresh/main.dart';
import '../pull_to_refresh/pull_to_refresh_controller.dart';

/// Object specifying creation parameters for creating a [PlatformInAppWebViewWidget].
///
/// Platform specific implementations can add additional fields by extending
/// this class.
class AndroidInAppWebViewWidgetCreationParams
    extends PlatformInAppWebViewWidgetCreationParams {
  AndroidInAppWebViewWidgetCreationParams(
      {super.controllerFromPlatform,
      super.key,
      super.layoutDirection,
      super.gestureRecognizers,
      super.headlessWebView,
      super.keepAlive,
      super.preventGestureDelay,
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
      super.initialUrlRequest,
      super.initialFile,
      super.initialData,
      super.initialSettings,
      super.contextMenu,
      super.initialUserScripts,
      this.pullToRefreshController,
      this.findInteractionController});

  /// Constructs a [AndroidInAppWebViewWidgetCreationParams] using a
  /// [PlatformInAppWebViewWidgetCreationParams].
  AndroidInAppWebViewWidgetCreationParams.fromPlatformInAppWebViewWidgetCreationParams(
      PlatformInAppWebViewWidgetCreationParams params)
      : this(
            controllerFromPlatform: params.controllerFromPlatform,
            key: params.key,
            layoutDirection: params.layoutDirection,
            gestureRecognizers: params.gestureRecognizers,
            headlessWebView: params.headlessWebView,
            keepAlive: params.keepAlive,
            preventGestureDelay: params.preventGestureDelay,
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
            onLoadResourceWithCustomScheme:
                params.onLoadResourceWithCustomScheme,
            onCreateWindow: params.onCreateWindow,
            onCloseWindow: params.onCloseWindow,
            onJsAlert: params.onJsAlert,
            onJsConfirm: params.onJsConfirm,
            onJsPrompt: params.onJsPrompt,
            onReceivedHttpAuthRequest: params.onReceivedHttpAuthRequest,
            onReceivedServerTrustAuthRequest:
                params.onReceivedServerTrustAuthRequest,
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
            onGeolocationPermissionsShowPrompt:
                params.onGeolocationPermissionsShowPrompt,
            onGeolocationPermissionsHidePrompt:
                params.onGeolocationPermissionsHidePrompt,
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
            onWebContentProcessDidTerminate:
                params.onWebContentProcessDidTerminate,
            onDidReceiveServerRedirectForProvisionalNavigation:
                params.onDidReceiveServerRedirectForProvisionalNavigation,
            onNavigationResponse: params.onNavigationResponse,
            shouldAllowDeprecatedTLS: params.shouldAllowDeprecatedTLS,
            onCameraCaptureStateChanged: params.onCameraCaptureStateChanged,
            onMicrophoneCaptureStateChanged:
                params.onMicrophoneCaptureStateChanged,
            onContentSizeChanged: params.onContentSizeChanged,
            initialUrlRequest: params.initialUrlRequest,
            initialFile: params.initialFile,
            initialData: params.initialData,
            initialSettings: params.initialSettings,
            contextMenu: params.contextMenu,
            initialUserScripts: params.initialUserScripts,
            pullToRefreshController: params.pullToRefreshController
                as AndroidPullToRefreshController?,
            findInteractionController: params.findInteractionController
                as AndroidFindInteractionController?);

  @override
  final AndroidFindInteractionController? findInteractionController;

  @override
  final AndroidPullToRefreshController? pullToRefreshController;
}

///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewWidget}
class AndroidInAppWebViewWidget extends PlatformInAppWebViewWidget {
  /// Constructs a [AndroidInAppWebViewWidget].
  ///
  ///{@macro zikzak_inappwebview_platform_interface.PlatformInAppWebViewWidget}
  AndroidInAppWebViewWidget(PlatformInAppWebViewWidgetCreationParams params)
      : super.implementation(
          params is AndroidInAppWebViewWidgetCreationParams
              ? params
              : AndroidInAppWebViewWidgetCreationParams
                  .fromPlatformInAppWebViewWidgetCreationParams(params),
        );

  AndroidInAppWebViewWidgetCreationParams get _androidParams =>
      params as AndroidInAppWebViewWidgetCreationParams;

  AndroidInAppWebViewController? _controller;

  AndroidHeadlessInAppWebView? get _androidHeadlessInAppWebView =>
      params.headlessWebView as AndroidHeadlessInAppWebView?;

  @override
  Widget build(BuildContext context) {
    final initialSettings = params.initialSettings ?? InAppWebViewSettings();
    _inferInitialSettings(initialSettings);

    Map<String, dynamic> settingsMap =
        (params.initialSettings != null ? initialSettings.toMap() : null) ??
            initialSettings.toMap();

    Map<String, dynamic> pullToRefreshSettings =
        params.pullToRefreshController?.params.settings?.toMap() ??
            PullToRefreshSettings(enabled: false).toMap();

    if ((params.headlessWebView?.isRunning() ?? false) &&
        params.keepAlive != null) {
      final headlessId = params.headlessWebView?.id;
      if (headlessId != null) {
        // force keep alive id to match headless webview id
        params.keepAlive?.id = headlessId;
      }
    }

    var useHybridComposition = initialSettings.useHybridComposition ?? true;

    return PlatformViewLink(
      key: params.key,
      viewType: 'wtf.zikzak/zikzak_inappwebview',
      surfaceFactory: (
        BuildContext context,
        PlatformViewController controller,
      ) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: params.gestureRecognizers ??
              const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        return _createAndroidViewController(
          hybridComposition: useHybridComposition,
          id: params.id,
          viewType: 'wtf.zikzak/zikzak_inappwebview',
          layoutDirection: this.params.layoutDirection ??
              Directionality.maybeOf(context) ??
              TextDirection.rtl,
          creationParams: <String, dynamic>{
            'initialUrlRequest': this.params.initialUrlRequest?.toMap(),
            'initialFile': this.params.initialFile,
            'initialData': this.params.initialData?.toMap(),
            'initialSettings': settingsMap,
            'contextMenu': this.params.contextMenu?.toMap() ?? {},
            'windowId': this.params.windowId,
            'headlessWebViewId':
                this.params.headlessWebView?.isRunning() ?? false
                    ? this.params.headlessWebView?.id
                    : null,
            'initialUserScripts': this
                    .params
                    .initialUserScripts
                    ?.map((e) => e.toMap())
                    .toList() ??
                [],
            'pullToRefreshSettings': pullToRefreshSettings,
            'keepAliveId': this.params.keepAlive?.id
          },
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..addOnPlatformViewCreatedListener((id) => _onPlatformViewCreated(id))
          ..create();
      },
    );
  }

  AndroidViewController _createAndroidViewController({
    required bool hybridComposition,
    required int id,
    required String viewType,
    required TextDirection layoutDirection,
    required Map<String, dynamic> creationParams,
  }) {
    if (hybridComposition) {
      return PlatformViewsService.initExpensiveAndroidView(
        id: id,
        viewType: viewType,
        layoutDirection: layoutDirection,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return PlatformViewsService.initSurfaceAndroidView(
      id: id,
      viewType: viewType,
      layoutDirection: layoutDirection,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  void _onPlatformViewCreated(int id) {
    dynamic viewId = id;
    if (params.headlessWebView?.isRunning() ?? false) {
      viewId = params.headlessWebView?.id;
    }
    viewId = params.keepAlive?.id ?? viewId ?? id;
    _androidHeadlessInAppWebView?.internalDispose();
    _controller = AndroidInAppWebViewController(
        PlatformInAppWebViewControllerCreationParams(
            id: viewId, webviewParams: params));
    _androidParams.pullToRefreshController?.init(viewId);
    _androidParams.findInteractionController?.init(viewId);
    debugLog(
        className: runtimeType.toString(),
        id: viewId?.toString(),
        debugLoggingSettings:
            PlatformInAppWebViewController.debugLoggingSettings,
        method: "onWebViewCreated",
        args: []);
    if (params.onWebViewCreated != null) {
      params.onWebViewCreated!(
          params.controllerFromPlatform?.call(_controller!) ?? _controller!);
    }
  }

  void _inferInitialSettings(InAppWebViewSettings settings) {
    if (params.shouldOverrideUrlLoading != null &&
        settings.useShouldOverrideUrlLoading == null) {
      settings.useShouldOverrideUrlLoading = true;
    }
    if (params.onLoadResource != null && settings.useOnLoadResource == null) {
      settings.useOnLoadResource = true;
    }
    if (params.onDownloadStartRequest != null &&
        settings.useOnDownloadStart == null) {
      settings.useOnDownloadStart = true;
    }
    if ((params.shouldInterceptAjaxRequest != null ||
            params.onAjaxProgress != null ||
            params.onAjaxReadyStateChange != null) &&
        settings.useShouldInterceptAjaxRequest == null) {
      settings.useShouldInterceptAjaxRequest = true;
    }
    if (params.shouldInterceptFetchRequest != null &&
        settings.useShouldInterceptFetchRequest == null) {
      settings.useShouldInterceptFetchRequest = true;
    }
    if (params.shouldInterceptRequest != null &&
        settings.useShouldInterceptRequest == null) {
      settings.useShouldInterceptRequest = true;
    }
    if (params.onRenderProcessGone != null &&
        settings.useOnRenderProcessGone == null) {
      settings.useOnRenderProcessGone = true;
    }
    if (params.onNavigationResponse != null &&
        settings.useOnNavigationResponse == null) {
      settings.useOnNavigationResponse = true;
    }
  }

  @override
  void dispose() {
    dynamic viewId = _controller?.getViewId();
    debugLog(
        className: runtimeType.toString(),
        id: viewId?.toString(),
        debugLoggingSettings:
            PlatformInAppWebViewController.debugLoggingSettings,
        method: "dispose",
        args: []);
    final isKeepAlive = params.keepAlive != null;
    _controller?.dispose(isKeepAlive: isKeepAlive);
    _controller = null;
    params.pullToRefreshController?.dispose(isKeepAlive: isKeepAlive);
    params.findInteractionController?.dispose(isKeepAlive: isKeepAlive);
  }

  @override
  T controllerFromPlatform<T>(PlatformInAppWebViewController controller) {
    // unused
    throw UnimplementedError();
  }
}
