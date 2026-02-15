import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import '../find_interaction/find_interaction_controller.dart';
import 'in_app_webview_controller.dart';

class LinuxHeadlessInAppWebViewCreationParams
    extends PlatformHeadlessInAppWebViewCreationParams {
  LinuxHeadlessInAppWebViewCreationParams(
      {super.controllerFromPlatform,
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
      super.pullToRefreshController,
      this.findInteractionController});

  LinuxHeadlessInAppWebViewCreationParams.fromPlatformHeadlessInAppWebViewCreationParams(
      PlatformHeadlessInAppWebViewCreationParams params)
      : this(
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
            pullToRefreshController: params.pullToRefreshController,
            findInteractionController: params.findInteractionController
                as LinuxFindInteractionController?);

  @override
  final LinuxFindInteractionController? findInteractionController;
}

class LinuxHeadlessInAppWebView extends PlatformHeadlessInAppWebView
    with ChannelController {

  bool _started = false;
  bool _running = false;

  static const MethodChannel _sharedChannel =
      MethodChannel('wtf.zikzak/flutter_headless_inappwebview');

  LinuxInAppWebViewController? _webViewController;

  LinuxHeadlessInAppWebView(PlatformHeadlessInAppWebViewCreationParams params)
      : super.implementation(
          params is LinuxHeadlessInAppWebViewCreationParams
              ? params
              : LinuxHeadlessInAppWebViewCreationParams
                  .fromPlatformHeadlessInAppWebViewCreationParams(params),
        );

  @override
  LinuxInAppWebViewController? get webViewController => _webViewController;

  dynamic get controllerFromPlatform => _controllerFromPlatform;
  dynamic _controllerFromPlatform;

  LinuxHeadlessInAppWebViewCreationParams get _linuxParams =>
      params as LinuxHeadlessInAppWebViewCreationParams;

  _init() {
    _webViewController = LinuxInAppWebViewController(
      PlatformInAppWebViewControllerCreationParams(
          id: id, webviewParams: params),
    );
    _controllerFromPlatform =
        params.controllerFromPlatform?.call(_webViewController!) ??
            _webViewController!;
    if (_linuxParams.findInteractionController != null) {
      _linuxParams.findInteractionController!.channel = MethodChannel(
          'wtf.zikzak/zikzak_inappwebview_find_interaction_$id');
      _linuxParams.findInteractionController!.setupMethodHandler();
    }
    
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

  @override
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
        PullToRefreshSettings(enabled: false).toMap();

    Map<String, dynamic> findInteractionSettings =
        _linuxParams.findInteractionController?.onFindResultReceived != null
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
                  params.initialUserScripts?.map((e) => e.toMap()).toList() ??
                      [],
              'pullToRefreshSettings': pullToRefreshSettings,
              'findInteractionSettings': findInteractionSettings,
              'initialSize': params.initialSize.toMap()
            });
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
    Map<String, dynamic> sizeMap =
        (await channel?.invokeMethod('getSize', args))?.cast<String, dynamic>();
    return MapSize.fromMap(sizeMap);
  }

  @override
  Future<void> dispose() async {
    if (!_running) {
      return;
    }
    await _sharedChannel.invokeMethod('dispose', <String, dynamic>{'id': id});
    disposeChannel();
    _started = false;
    _running = false;
    _webViewController?.dispose();
    _webViewController = null;
    _controllerFromPlatform = null;
    _linuxParams.findInteractionController?.dispose();
  }
}
