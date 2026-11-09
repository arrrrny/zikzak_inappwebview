import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import '../find_interaction/find_interaction_controller.dart';
import '../util/wire.dart';
import 'in_app_webview_controller.dart';

/// Object specifying creation parameters for creating a [LinuxHeadlessInAppWebView].
///
/// When adding additional fields make sure they can be null or have a default
/// value to avoid breaking changes. See [PlatformHeadlessInAppWebViewCreationParams] for
/// more information.
@immutable
class LinuxHeadlessInAppWebViewCreationParams
    extends PlatformHeadlessInAppWebViewCreationParams {
  /// Creates a new [LinuxHeadlessInAppWebViewCreationParams] instance.
  const LinuxHeadlessInAppWebViewCreationParams({
    super.initialSize,
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
    LinuxFindInteractionController? super.findInteractionController,
  });

  /// Creates a [LinuxHeadlessInAppWebViewCreationParams] instance based on [PlatformHeadlessInAppWebViewCreationParams].
  LinuxHeadlessInAppWebViewCreationParams.fromPlatformHeadlessInAppWebViewCreationParams(
    PlatformHeadlessInAppWebViewCreationParams params,
  ) : this(
        initialSize: params.initialSize,
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
        findInteractionController:
            params.findInteractionController as LinuxFindInteractionController?,
      );

  @override
  LinuxFindInteractionController? get findInteractionController =>
      super.findInteractionController as LinuxFindInteractionController?;
}

///{@macro zikzak_inappwebview_platform_interface.PlatformHeadlessInAppWebView}
class LinuxHeadlessInAppWebView extends PlatformHeadlessInAppWebView
    with ChannelController {
  @override
  late final String id;

  bool _started = false;
  bool _running = false;

  /// Set by [dispose]; kept apart from [_running] so that a [dispose] issued
  /// while [run] is still in flight is not ignored.
  bool _disposed = false;

  /// Completes when an in-flight [run] finishes, including the deferred
  /// native teardown it performs when [dispose] was called mid-startup.
  Completer<void>? _runCompleter;

  static const MethodChannel _sharedChannel = MethodChannel(
    'wtf.zikzak/flutter_headless_inappwebview',
  );

  LinuxInAppWebViewController? _webViewController;

  /// Constructs a [LinuxHeadlessInAppWebView].
  LinuxHeadlessInAppWebView(PlatformHeadlessInAppWebViewCreationParams params)
    : super.implementation(
        params is LinuxHeadlessInAppWebViewCreationParams
            ? params
            : LinuxHeadlessInAppWebViewCreationParams.fromPlatformHeadlessInAppWebViewCreationParams(
                params,
              ),
      ) {
    id = IdGenerator.generate();
  }

  static final LinuxHeadlessInAppWebView _staticValue =
      LinuxHeadlessInAppWebView(LinuxHeadlessInAppWebViewCreationParams());

  factory LinuxHeadlessInAppWebView.static() {
    return _staticValue;
  }

  @override
  LinuxInAppWebViewController? get webViewController => _webViewController;

  dynamic _controllerFromPlatform;

  LinuxHeadlessInAppWebViewCreationParams get _linuxParams =>
      params as LinuxHeadlessInAppWebViewCreationParams;

  void _init() {
    _webViewController = LinuxInAppWebViewController(
      LinuxInAppWebViewControllerCreationParams(id: id, webviewParams: params),
    );
    _controllerFromPlatform =
        params.controllerFromPlatform?.call(_webViewController!) ??
        _webViewController!;
    // Initialize the find interaction controller with the same ID
    _linuxParams.findInteractionController?.init(id);
    channel = MethodChannel(
      'wtf.zikzak/flutter_headless_inappwebview_$id',
    );
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
    if (_started || _disposed) {
      return;
    }
    _started = true;
    _init();

    final initialSettings = _inferInitialSettings(
      params.initialSettings ?? InAppWebViewSettings(),
    );
    Map<String, dynamic> settingsMap = withAjaxEventFlags(
      inAppWebViewSettingsToWire(initialSettings),
      onReadyStateChange: params.onAjaxReadyStateChange != null,
      onProgress: params.onAjaxProgress != null,
    );

    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('id', () => id);
    args.putIfAbsent(
      'params',
      () => <String, dynamic>{
        'initialUrlRequest': params.initialUrlRequest?.toJson(),
        'initialFile': params.initialFile,
        'initialData': params.initialData?.toJson(),
        'initialSettings': settingsMap,
        'contextMenu': params.contextMenu?.toMap() ?? {},
        'windowId': params.windowId,
        'initialUserScripts':
            params.initialUserScripts?.map(userScriptToWire).toList() ?? [],
        'initialSize': params.initialSize.toJson(),
      },
    );
    final runCompleter = Completer<void>();
    _runCompleter = runCompleter;
    try {
      await _sharedChannel.invokeMethod('run', args);
      _running = true;
      if (_disposed) {
        // dispose() was called while the native WebView was still starting:
        // tear it down now that it exists.
        await _disposeNative();
      }
    } catch (e) {
      // Release what _init() created, so a retried run() starts clean.
      _releaseDart();
      rethrow;
    } finally {
      // Unblock a dispose() waiting for this run().
      runCompleter.complete();
      if (identical(_runCompleter, runCompleter)) {
        _runCompleter = null;
      }
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
  bool isRunning() {
    return _running;
  }

  @override
  Future<void> setSize(Size size) async {
    if (!_running) {
      return;
    }

    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('size', () => size.toJson());
    await channel?.invokeMethod('setSize', args);
  }

  @override
  Future<Size?> getSize() async {
    if (!_running) {
      return null;
    }

    Map<String, dynamic> args = <String, dynamic>{};
    final sizeMap = wireMap(await channel?.invokeMethod('getSize', args));
    if (sizeMap == null) {
      return null;
    }
    return MapSize.fromMap(sizeMap);
  }

  @override
  Future<void> dispose({bool isKeepAlive = false}) async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    if (!_running) {
      // run() has not finished (or was never called). If it is in flight,
      // wait for it: it releases the native side itself once it exists.
      await _runCompleter?.future;
      return;
    }
    await _disposeNative();
  }

  Future<void> _disposeNative() async {
    try {
      Map<String, dynamic> args = <String, dynamic>{};
      await channel?.invokeMethod('dispose', args);
    } finally {
      // Release the Dart side even when native teardown fails.
      _releaseDart();
    }
  }

  /// Releases the channel, controller and find controller [_init] set up.
  void _releaseDart() {
    disposeChannel();
    _started = false;
    _running = false;
    _webViewController?.dispose();
    _webViewController = null;
    _controllerFromPlatform = null;
    _linuxParams.findInteractionController?.dispose();
  }
}

extension InternalHeadlessInAppWebView on LinuxHeadlessInAppWebView {
  Future<void> internalDispose() async {
    _started = false;
    _running = false;
  }
}
