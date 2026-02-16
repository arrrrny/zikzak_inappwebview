import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import '../find_interaction/find_interaction_controller.dart';
import '../pull_to_refresh/pull_to_refresh_controller.dart';
import 'in_app_webview_controller.dart';

/// Object specifying creation parameters for creating a [IOSHeadlessInAppWebView].
///
/// When adding additional fields make sure they can be null or have a default
/// value to avoid breaking changes. See [PlatformHeadlessInAppWebViewCreationParams] for
/// more information.
class IOSHeadlessInAppWebViewCreationParams
    extends PlatformHeadlessInAppWebViewCreationParams {
  /// Creates a new [IOSHeadlessInAppWebViewCreationParams] instance.
  IOSHeadlessInAppWebViewCreationParams({
    super.controllerFromPlatform,
    super.initialSize,
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
    this.findInteractionController,
  });

  /// Creates a [IOSHeadlessInAppWebViewCreationParams] instance based on [PlatformHeadlessInAppWebViewCreationParams].
  IOSHeadlessInAppWebViewCreationParams.fromPlatformHeadlessInAppWebViewCreationParams(
    PlatformHeadlessInAppWebViewCreationParams params,
  ) : this(
        controllerFromPlatform: params.controllerFromPlatform,
        initialSize: params.initialSize,
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
        onWebContentProcessDidTerminate: params.onWebContentProcessDidTerminate,
        onDidReceiveServerRedirectForProvisionalNavigation:
            params.onDidReceiveServerRedirectForProvisionalNavigation,
        onNavigationResponse: params.onNavigationResponse,
        shouldAllowDeprecatedTLS: params.shouldAllowDeprecatedTLS,
        onCameraCaptureStateChanged: params.onCameraCaptureStateChanged,
        onMicrophoneCaptureStateChanged: params.onMicrophoneCaptureStateChanged,
        onContentSizeChanged: params.onContentSizeChanged,
        initialUrlRequest: params.initialUrlRequest,
        initialFile: params.initialFile,
        initialData: params.initialData,
        initialSettings: params.initialSettings,
        contextMenu: params.contextMenu,
        initialUserScripts: params.initialUserScripts,
        pullToRefreshController:
            params.pullToRefreshController as IOSPullToRefreshController?,
        findInteractionController:
            params.findInteractionController as IOSFindInteractionController?,
      );

  @override
  final IOSFindInteractionController? findInteractionController;

  @override
  final IOSPullToRefreshController? pullToRefreshController;
}

///{@macro zikzak_inappwebview_platform_interface.PlatformHeadlessInAppWebView}
class IOSHeadlessInAppWebView extends PlatformHeadlessInAppWebView
    with ChannelController {
  @override
  late final String id;

  bool _started = false;
  bool _running = false;

  static const MethodChannel _sharedChannel = const MethodChannel(
    'wtf.zikzak/flutter_headless_inappwebview',
  );

  IOSInAppWebViewController? _webViewController;

  /// Constructs a [IOSHeadlessInAppWebView].
  IOSHeadlessInAppWebView(PlatformHeadlessInAppWebViewCreationParams params)
    : super.implementation(
        params is IOSHeadlessInAppWebViewCreationParams
            ? params
            : IOSHeadlessInAppWebViewCreationParams.fromPlatformHeadlessInAppWebViewCreationParams(
                params,
              ),
      ) {
    id = IdGenerator.generate();
  }

  @override
  IOSInAppWebViewController? get webViewController => _webViewController;

  dynamic _controllerFromPlatform;

  IOSHeadlessInAppWebViewCreationParams get _iosParams =>
      params as IOSHeadlessInAppWebViewCreationParams;

  _init() {
    _webViewController = IOSInAppWebViewController(
      IOSInAppWebViewControllerCreationParams(id: id, webviewParams: params),
    );
    _controllerFromPlatform =
        params.controllerFromPlatform?.call(_webViewController!) ??
        _webViewController!;
    _iosParams.pullToRefreshController?.init(id);
    _iosParams.findInteractionController?.init(id);
    channel = MethodChannel('wtf.zikzak/flutter_headless_inappwebview_$id');
    handler = _handleMethod;
    initMethodCallHandler();
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onWebViewCreated":
        if (params.onWebViewCreated != null && _webViewController != null) {
          params.onWebViewCreated!(_controllerFromPlatform);
        }
        break;
      default:
        throw UnimplementedError("Unimplemented ${call.method} method");
    }
    return null;
  }

  Future<void> run() async {
    if (_started) {
      return;
    }
    _started = true;
    _init();

    final initialSettings = params.initialSettings ?? InAppWebViewSettings();
    _inferInitialSettings(initialSettings);

    Map<String, dynamic> settingsMap =
        (params.initialSettings != null ? initialSettings.toMap() : null) ??
        initialSettings.toMap();

    Map<String, dynamic> pullToRefreshSettings =
        _iosParams.pullToRefreshController?.settings?.toMap() ??
        PullToRefreshSettings(enabled: false).toMap();

    Map<String, dynamic> findInteractionSettings =
        _iosParams.findInteractionController?.onFindResultReceived != null
        ? {}
        : {};

    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('id', () => id);
    args.putIfAbsent(
      'params',
      () => <String, dynamic>{
        'initialUrlRequest': params.initialUrlRequest?.toMap(),
        'initialFile': params.initialFile,
        'initialData': params.initialData?.toMap(),
        'initialSettings': settingsMap,
        'contextMenu': params.contextMenu?.toMap() ?? {},
        'windowId': params.windowId,
        'initialUserScripts':
            params.initialUserScripts?.map((e) => e.toMap()).toList() ?? [],
        'pullToRefreshSettings': pullToRefreshSettings,
        'findInteractionSettings': findInteractionSettings,
        'initialSize': params.initialSize.toMap(),
      },
    );
    await _sharedChannel.invokeMethod('run', args);
    _running = true;
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
    if (params.shouldInterceptAjaxRequest != null &&
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
  bool isRunning() {
    return _running;
  }

  @override
  Future<void> setSize(Size size) async {
    if (!_running) {
      return;
    }

    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('size', () => size.toMap());
    await channel?.invokeMethod('setSize', args);
  }

  @override
  Future<Size?> getSize() async {
    if (!_running) {
      return null;
    }

    Map<String, dynamic> args = <String, dynamic>{};
    Map<String, dynamic> sizeMap = (await channel?.invokeMethod(
      'getSize',
      args,
    ))?.cast<String, dynamic>();
    return MapSize.fromMap(sizeMap);
  }

  @override
  Future<void> dispose() async {
    if (!_running) {
      return;
    }
    Map<String, dynamic> args = <String, dynamic>{};
    await channel?.invokeMethod('dispose', args);
    disposeChannel();
    _started = false;
    _running = false;
    _webViewController?.dispose();
    _webViewController = null;
    _controllerFromPlatform = null;
    _iosParams.pullToRefreshController?.dispose();
    _iosParams.findInteractionController?.dispose();
  }
}

extension InternalHeadlessInAppWebView on IOSHeadlessInAppWebView {
  Future<void> internalDispose() async {
    _started = false;
    _running = false;
  }
}
