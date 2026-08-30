import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

class LinuxInAppWebViewController extends PlatformInAppWebViewController {
  LinuxInAppWebViewController(
    PlatformInAppWebViewControllerCreationParams params,
  ) : super.implementation(params) {
    _channel = MethodChannel('dev.zuzu/zikzak_inappwebview_${params.id}');
    _channel.setMethodCallHandler((call) async {
      try {
        return await handleMethod(call);
      } catch (e, stackTrace) {
        debugPrint(
          'LinuxInAppWebViewController: error handling ${call.method}: '
          '$e\n$stackTrace',
        );
      }
    });
  }

  LinuxInAppWebViewController.fromInAppBrowser(
    super.params,
    MethodChannel channel,
  ) : super.implementation() {
    _channel = channel;
  }

  LinuxInAppWebViewController.static()
    : super.implementation(
        PlatformInAppWebViewControllerCreationParams(id: 'static'),
      );

  late MethodChannel _channel;

  final Map<String, void Function(Map<String, dynamic>)>
      _devToolsProtocolEventListeners = {};

  Future<dynamic> handleMethod(MethodCall call) async {
    final controller = params.webviewParams?.controllerFromPlatform != null
        ? params.webviewParams!.controllerFromPlatform!(this)
        : this;

    switch (call.method) {
      case 'onLoadStart':
        if (params.webviewParams?.onLoadStart != null) {
          String? url = call.arguments['url'];
          params.webviewParams!.onLoadStart!(
            controller,
            url != null ? WebUri(url) : null,
          );
        }
        break;
      case 'onLoadStop':
        if (params.webviewParams?.onLoadStop != null) {
          String? url = call.arguments['url'];
          params.webviewParams!.onLoadStop!(
            controller,
            url != null ? WebUri(url) : null,
          );
        }
        break;
      case 'onCallJsHandler':
        final handlerName = call.arguments['handlerName'] as String?;
        final handlerArgs =
            (call.arguments['args'] as List?)?.cast<dynamic>() ?? const [];
        final callback = handlerName != null
            ? _javaScriptHandlers[handlerName]
            : null;
        if (callback != null) {
          return callback(handlerArgs);
        }
        break;
      case 'onReceivedError':
        if (params.webviewParams?.onReceivedError != null) {
          String? url = call.arguments['url'];
          int code = call.arguments['code'];
          String message = call.arguments['message'];

          params.webviewParams!.onReceivedError!(
            controller,
            WebResourceRequest(url: url != null ? WebUri(url) : WebUri('')),
            WebResourceError(
              type: WebResourceErrorType.values.firstWhere(
                (t) => t.index == code,
                orElse: () => WebResourceErrorType.UNKNOWN,
              ),
              description: message,
            ),
          );
        }
        break;
      case 'onReceivedHttpError':
        if (params.webviewParams?.onReceivedHttpError != null) {
          String? url = call.arguments['url'];
          int statusCode = call.arguments['statusCode'] ?? 0;
          String? description = call.arguments['description'];
          params.webviewParams!.onReceivedHttpError!(
            controller,
            WebResourceRequest(url: url != null ? WebUri(url) : WebUri('')),
            WebResourceResponse(
              statusCode: statusCode,
              reasonPhrase: description,
            ),
          );
        }
        break;
      case 'onProgressChanged':
        if (params.webviewParams?.onProgressChanged != null) {
          int progress = call.arguments['progress'];
          params.webviewParams!.onProgressChanged!(controller, progress);
        }
        break;
      case 'onUpdateVisitedHistory':
        if (params.webviewParams?.onUpdateVisitedHistory != null) {
          String? url = call.arguments['url'];
          bool? isReload = call.arguments['isReload'];
          params.webviewParams!.onUpdateVisitedHistory!(
            controller,
            url != null ? WebUri(url) : null,
            isReload,
          );
        }
        break;
      case 'onTitleChanged':
        if (params.webviewParams?.onTitleChanged != null) {
          String? title = call.arguments['title'];
          params.webviewParams!.onTitleChanged!(controller, title);
        }
        break;
      case 'shouldOverrideUrlLoading':
        if (params.webviewParams?.shouldOverrideUrlLoading != null) {
          Map<String, dynamic> arguments =
              call.arguments.cast<String, dynamic>();
          var navigationAction = NavigationAction.fromJson(
            arguments['navigationAction'].cast<String, dynamic>(),
          );
          var policy =
              await params.webviewParams!.shouldOverrideUrlLoading!(
            controller,
            navigationAction,
          );
          return policy?.index ?? NavigationActionPolicy.CANCEL.index;
        }
        return NavigationActionPolicy.ALLOW.index;
      case 'onConsoleMessage':
        if (params.webviewParams?.onConsoleMessage != null) {
          var consoleMessage = ConsoleMessage.fromJson(
            call.arguments.cast<String, dynamic>(),
          );
          params.webviewParams!.onConsoleMessage!(controller, consoleMessage);
        }
        break;
      case 'onScrollChanged':
        if (params.webviewParams?.onScrollChanged != null) {
          int scrollX = call.arguments['scrollX'] ?? 0;
          int scrollY = call.arguments['scrollY'] ?? 0;
          params.webviewParams!.onScrollChanged!(
            controller,
            scrollX,
            scrollY,
          );
        }
        break;
      case 'onDownloadStartRequest':
        if (params.webviewParams?.onDownloadStartRequest != null) {
          var downloadStartRequest = DownloadStartRequest.fromJson(
            call.arguments.cast<String, dynamic>(),
          );
          params.webviewParams!.onDownloadStartRequest!(
            controller,
            downloadStartRequest,
          );
        }
        break;
      case 'onLoadResourceWithCustomScheme':
        if (params.webviewParams?.onLoadResourceWithCustomScheme != null) {
          var request = WebResourceRequest.fromJson(
            call.arguments.cast<String, dynamic>(),
          );
          return await params.webviewParams!.onLoadResourceWithCustomScheme!(
            controller,
            request,
          );
        }
        break;
      case 'onCreateWindow':
        if (params.webviewParams?.onCreateWindow != null) {
          var createWindowAction = CreateWindowAction.fromJson(
            call.arguments.cast<String, dynamic>(),
          );
          var isHandled =
              await params.webviewParams!.onCreateWindow!(
            controller,
            createWindowAction,
          );
          return isHandled ?? false;
        }
        return false;
      case 'onCloseWindow':
        if (params.webviewParams?.onCloseWindow != null) {
          params.webviewParams!.onCloseWindow!(controller);
        }
        break;
      case 'onJsAlert':
        if (params.webviewParams?.onJsAlert != null) {
          var jsAlertRequest = JsAlertRequest.fromJson(
            call.arguments.cast<String, dynamic>(),
          );
          return await params.webviewParams!.onJsAlert!(
            controller,
            jsAlertRequest,
          );
        }
        break;
      case 'onJsConfirm':
        if (params.webviewParams?.onJsConfirm != null) {
          var jsConfirmRequest = JsConfirmRequest.fromJson(
            call.arguments.cast<String, dynamic>(),
          );
          return await params.webviewParams!.onJsConfirm!(
            controller,
            jsConfirmRequest,
          );
        }
        break;
      case 'onJsPrompt':
        if (params.webviewParams?.onJsPrompt != null) {
          var jsPromptRequest = JsPromptRequest.fromJson(
            call.arguments.cast<String, dynamic>(),
          );
          return await params.webviewParams!.onJsPrompt!(
            controller,
            jsPromptRequest,
          );
        }
        break;
      case 'onJsBeforeUnload':
        if (params.webviewParams?.onJsBeforeUnload != null) {
          var jsBeforeUnloadRequest = JsBeforeUnloadRequest.fromJson(
            call.arguments.cast<String, dynamic>(),
          );
          return await params.webviewParams!.onJsBeforeUnload!(
            controller,
            jsBeforeUnloadRequest,
          );
        }
        break;
      case 'onReceivedHttpAuthRequest':
        if (params.webviewParams?.onReceivedHttpAuthRequest != null) {
          var challenge = HttpAuthenticationChallenge.fromJson(
            call.arguments.cast<String, dynamic>(),
          );
          if (challenge == null) break;
          return await params.webviewParams!.onReceivedHttpAuthRequest!(
            controller,
            challenge,
          );
        }
        break;
      case 'onReceivedServerTrustAuthRequest':
        if (params.webviewParams?.onReceivedServerTrustAuthRequest != null) {
          var challenge = ServerTrustChallenge.fromJson(
            call.arguments.cast<String, dynamic>(),
          );
          if (challenge == null) break;
          return await params.webviewParams!
              .onReceivedServerTrustAuthRequest!(controller, challenge);
        }
        break;
      case 'onReceivedClientCertRequest':
        if (params.webviewParams?.onReceivedClientCertRequest != null) {
          var challenge = ClientCertChallenge.fromJson(
            call.arguments.cast<String, dynamic>(),
          );
          if (challenge == null) break;
          return await params.webviewParams!.onReceivedClientCertRequest!(
            controller,
            challenge,
          );
        }
        break;
      case 'onGeolocationPermissionsShowPrompt':
        if (params.webviewParams
            ?.onGeolocationPermissionsShowPrompt != null) {
          String origin = call.arguments['origin'] ?? '';
          return await params.webviewParams!
              .onGeolocationPermissionsShowPrompt!(controller, origin);
        }
        break;
      case 'onGeolocationPermissionsHidePrompt':
        if (params.webviewParams
            ?.onGeolocationPermissionsHidePrompt != null) {
          params.webviewParams!.onGeolocationPermissionsHidePrompt!(
            controller,
          );
        }
        break;
      case 'onFormResubmission':
        if (params.webviewParams?.onFormResubmission != null) {
          String? url = call.arguments['url'];
          return await params.webviewParams!.onFormResubmission!(
            controller,
            url != null ? WebUri(url) : null,
          );
        }
        break;
      case 'onZoomScaleChanged':
        if (params.webviewParams?.onZoomScaleChanged != null) {
          double oldScale = call.arguments['oldScale'] ?? 1.0;
          double newScale = call.arguments['newScale'] ?? 1.0;
          params.webviewParams!.onZoomScaleChanged!(
            controller,
            oldScale,
            newScale,
          );
        }
        break;
      case 'onReceivedIcon':
        if (params.webviewParams?.onReceivedIcon != null) {
          Uint8List icon = call.arguments['icon'] as Uint8List? ??
              Uint8List.fromList([]);
          params.webviewParams!.onReceivedIcon!(controller, icon);
        }
        break;
      case 'onReceivedTouchIconUrl':
        if (params.webviewParams?.onReceivedTouchIconUrl != null) {
          String? url = call.arguments['url'];
          bool precomposed = call.arguments['precomposed'] ?? false;
          params.webviewParams!.onReceivedTouchIconUrl!(
            controller,
            WebUri(url ?? ''),
            precomposed,
          );
        }
        break;
      case 'onPermissionRequest':
        if (params.webviewParams?.onPermissionRequest != null) {
          var request = PermissionRequest.fromJson(
            call.arguments.cast<String, dynamic>(),
          );
          return await params.webviewParams!.onPermissionRequest!(
            controller,
            request,
          );
        }
        break;
      case 'onPermissionRequestCanceled':
        if (params.webviewParams?.onPermissionRequestCanceled != null) {
          var request = PermissionRequest.fromJson(
            call.arguments.cast<String, dynamic>(),
          );
          params.webviewParams!.onPermissionRequestCanceled!(
            controller,
            request,
          );
        }
        break;
      case 'onRenderProcessGone':
        if (params.webviewParams?.onRenderProcessGone != null) {
          var detail = RenderProcessGoneDetail.fromJson(
            call.arguments.cast<String, dynamic>(),
          );
          params.webviewParams!.onRenderProcessGone!(controller, detail);
        }
        break;
      case 'onRenderProcessUnresponsive':
        if (params.webviewParams?.onRenderProcessUnresponsive != null) {
          params.webviewParams!.onRenderProcessUnresponsive!(controller);
        }
        break;
      case 'onRenderProcessResponsive':
        if (params.webviewParams?.onRenderProcessResponsive != null) {
          params.webviewParams!.onRenderProcessResponsive!(controller);
        }
        break;
      case 'onSafeBrowsingHit':
        if (params.webviewParams?.onSafeBrowsingHit != null) {
          var url = call.arguments['url'] ?? '';
          var threatTypeValue = call.arguments['threatType'];
          SafeBrowsingThreat threatType = SafeBrowsingThreat
              .values[threatTypeValue is int &&
                      threatTypeValue >= 0 &&
                      threatTypeValue <
                          SafeBrowsingThreat.values.length
                  ? threatTypeValue
                  : 0];
          params.webviewParams!.onSafeBrowsingHit!(
            controller,
            WebUri(url),
            threatType,
          );
        }
        break;
      case 'onEnterFullscreen':
        if (params.webviewParams?.onEnterFullscreen != null) {
          params.webviewParams!.onEnterFullscreen!(controller);
        }
        break;
      case 'onExitFullscreen':
        if (params.webviewParams?.onExitFullscreen != null) {
          params.webviewParams!.onExitFullscreen!(controller);
        }
        break;
      case 'onOverScrolled':
        if (params.webviewParams?.onOverScrolled != null) {
          int scrollX = call.arguments['scrollX'] ?? 0;
          int scrollY = call.arguments['scrollY'] ?? 0;
          bool clampedX = false;
          bool clampedY = false;
          final clampedXRaw = call.arguments['clampedX'];
          final clampedYRaw = call.arguments['clampedY'];
          if (clampedXRaw is bool) {
            clampedX = clampedXRaw;
          } else if (clampedXRaw is int) {
            clampedX = clampedXRaw != 0;
          }
          if (clampedYRaw is bool) {
            clampedY = clampedYRaw;
          } else if (clampedYRaw is int) {
            clampedY = clampedYRaw != 0;
          }
          params.webviewParams!.onOverScrolled!(
            controller,
            scrollX,
            scrollY,
            clampedX,
            clampedY,
          );
        }
        break;
      case 'onWindowFocus':
        if (params.webviewParams?.onWindowFocus != null) {
          params.webviewParams!.onWindowFocus!(controller);
        }
        break;
      case 'onWindowBlur':
        if (params.webviewParams?.onWindowBlur != null) {
          params.webviewParams!.onWindowBlur!(controller);
        }
        break;
      case 'onPrintRequest':
        if (params.webviewParams?.onPrintRequest != null) {
          String? url = call.arguments['url'];
          return await params.webviewParams!.onPrintRequest!(
            controller,
            url != null ? WebUri(url) : null,
            null,
          );
        }
        break;
      case 'onRequestFocus':
        if (params.webviewParams?.onRequestFocus != null) {
          params.webviewParams!.onRequestFocus!(controller);
        }
        break;
      case 'onReceivedLoginRequest':
        if (params.webviewParams?.onReceivedLoginRequest != null) {
          var request = LoginRequest.fromJson(
            call.arguments.cast<String, dynamic>(),
          );
          params.webviewParams!.onReceivedLoginRequest!(
            controller,
            request,
          );
        }
        break;
      case 'onLongPressHitTestResult':
        if (params.webviewParams?.onLongPressHitTestResult != null) {
          var hitTestResult = InAppWebViewHitTestResult.fromJson(
            call.arguments.cast<String, dynamic>(),
          );
          params.webviewParams!.onLongPressHitTestResult!(
            controller,
            hitTestResult,
          );
        }
        break;
      case 'onContentSizeChanged':
        if (params.webviewParams?.onContentSizeChanged != null) {
          var oldSizeMap = call.arguments['oldSize'];
          var newSizeMap = call.arguments['size'];
          Size oldContentSize = Size.zero;
          Size newContentSize = Size.zero;
          if (oldSizeMap is Map) {
            final m = oldSizeMap.cast<String, dynamic>();
            oldContentSize = Size(
              (m['width'] as num?)?.toDouble() ?? 0.0,
              (m['height'] as num?)?.toDouble() ?? 0.0,
            );
          }
          if (newSizeMap is Map) {
            final m = newSizeMap.cast<String, dynamic>();
            newContentSize = Size(
              (m['width'] as num?)?.toDouble() ?? 0.0,
              (m['height'] as num?)?.toDouble() ?? 0.0,
            );
          }
          params.webviewParams!.onContentSizeChanged!(
            controller,
            oldContentSize,
            newContentSize,
          );
        }
        break;
      case 'onCameraCaptureStateChanged':
        if (params.webviewParams?.onCameraCaptureStateChanged != null) {
          await params.webviewParams!.onCameraCaptureStateChanged!(
            controller,
            mediaCaptureStateFromWire(call.arguments['oldState']),
            mediaCaptureStateFromWire(call.arguments['newState']),
          );
        }
        break;
      case 'onMicrophoneCaptureStateChanged':
        if (params.webviewParams?.onMicrophoneCaptureStateChanged != null) {
          await params.webviewParams!.onMicrophoneCaptureStateChanged!(
            controller,
            mediaCaptureStateFromWire(call.arguments['oldState']),
            mediaCaptureStateFromWire(call.arguments['newState']),
          );
        }
        break;
      case 'onPageCommitVisible':
        if (params.webviewParams?.onPageCommitVisible != null) {
          String? url = call.arguments['url'];
          params.webviewParams!.onPageCommitVisible!(
            controller,
            url != null ? WebUri(url) : WebUri(''),
          );
        }
        break;
      default:
        // Check if this is a DevTools protocol event
        if (call.method.startsWith('onDevToolsProtocolEvent:')) {
          final eventName = call.method.substring('onDevToolsProtocolEvent:'.length);
          final callback = _devToolsProtocolEventListeners[eventName];
          if (callback != null) {
            final params = (call.arguments as Map?)?.cast<String, dynamic>() ?? {};
            callback(params);
          }
          break;
        }
        throw UnimplementedError("Unimplemented ${call.method} method");
    }
  }

  // --- Navigation ---

  @override
  Future<WebUri?> getUrl() async {
    final String? url = await _channel.invokeMethod<String>('getUrl');
    return url != null ? WebUri(url) : null;
  }

  @override
  Future<String?> getTitle() async {
    return await _channel.invokeMethod<String>('getTitle');
  }

  @override
  Future<int?> getProgress() async {
    return await _channel.invokeMethod<int>('getProgress');
  }

  @override
  Future<void> loadUrl({
    required URLRequest urlRequest,
    WebUri? allowingReadAccessTo,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('urlRequest', () => urlRequest.toJson());
    args.putIfAbsent(
      'allowingReadAccessTo',
      () => allowingReadAccessTo.toString(),
    );
    await _channel.invokeMethod('loadUrl', args);
  }

  @override
  Future<void> postUrl({required WebUri url, required Uint8List postData}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('url', () => url.toString());
    args.putIfAbsent('postData', () => postData);
    await _channel.invokeMethod('postUrl', args);
  }

  @override
  Future<void> loadData({
    required String data,
    String mimeType = "text/html",
    String encoding = "utf8",
    WebUri? baseUrl,
    WebUri? historyUrl,
    WebUri? allowingReadAccessTo,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('data', () => data);
    args.putIfAbsent('mimeType', () => mimeType);
    args.putIfAbsent('encoding', () => encoding);
    args.putIfAbsent('baseUrl', () => baseUrl?.toString());
    args.putIfAbsent('historyUrl', () => historyUrl?.toString());
    args.putIfAbsent(
      'allowingReadAccessTo',
      () => allowingReadAccessTo?.toString(),
    );
    await _channel.invokeMethod('loadData', args);
  }

  @override
  Future<void> loadFile({required String assetFilePath}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('assetFilePath', () => assetFilePath);
    await _channel.invokeMethod('loadFile', args);
  }

  @override
  Future<void> reload() async {
    await _channel.invokeMethod('reload');
  }

  @override
  Future<void> reloadFromOrigin() async {
    await _channel.invokeMethod('reloadFromOrigin');
  }

  @override
  Future<void> goBack() async {
    await _channel.invokeMethod('goBack');
  }

  @override
  Future<bool> canGoBack() async {
    return await _channel.invokeMethod<bool>('canGoBack') ?? false;
  }

  @override
  Future<void> goForward() async {
    await _channel.invokeMethod('goForward');
  }

  @override
  Future<bool> canGoForward() async {
    return await _channel.invokeMethod<bool>('canGoForward') ?? false;
  }

  @override
  Future<void> goBackOrForward({required int steps}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('steps', () => steps);
    await _channel.invokeMethod('goBackOrForward', args);
  }

  @override
  Future<bool> canGoBackOrForward({required int steps}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('steps', () => steps);
    return await _channel.invokeMethod<bool>('canGoBackOrForward', args) ??
        false;
  }

  @override
  Future<void> goTo({required WebHistoryItem historyItem}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('historyItem', () => historyItem.toJson());
    await _channel.invokeMethod('goTo', args);
  }

  @override
  Future<bool> isLoading() async {
    return await _channel.invokeMethod<bool>('isLoading') ?? false;
  }

  @override
  Future<void> stopLoading() async {
    await _channel.invokeMethod('stopLoading');
  }

  // --- JavaScript / CSS ---

  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('source', () => source);
    args.putIfAbsent('contentWorld', () => contentWorld?.toMap());
    return await _channel.invokeMethod('evaluateJavascript', args);
  }

  @override
  Future<void> injectJavascriptFileFromUrl({
    required WebUri urlFile,
    ScriptHtmlTagAttributes? scriptHtmlTagAttributes,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('urlFile', () => urlFile.toString());
    args.putIfAbsent(
      'scriptHtmlTagAttributes',
      () => scriptHtmlTagAttributes?.toMap(),
    );
    await _channel.invokeMethod('injectJavascriptFileFromUrl', args);
  }

  @override
  Future<dynamic> injectJavascriptFileFromAsset({
    required String assetFilePath,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('assetFilePath', () => assetFilePath);
    await _channel.invokeMethod('injectJavascriptFileFromAsset', args);
  }

  @override
  Future<void> injectCSSCode({required String source}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('source', () => source);
    await _channel.invokeMethod('injectCSSCode', args);
  }

  @override
  Future<void> injectCSSFileFromUrl({
    required WebUri urlFile,
    CSSLinkHtmlTagAttributes? cssLinkHtmlTagAttributes,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('urlFile', () => urlFile.toString());
    args.putIfAbsent(
      'cssLinkHtmlTagAttributes',
      () => cssLinkHtmlTagAttributes?.toJson(),
    );
    await _channel.invokeMethod('injectCSSFileFromUrl', args);
  }

  @override
  Future<void> injectCSSFileFromAsset({required String assetFilePath}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('assetFilePath', () => assetFilePath);
    await _channel.invokeMethod('injectCSSFileFromAsset', args);
  }

  @override
  Future<void> addUserScript({required UserScript userScript}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('userScript', () => userScript.toJson());
    await _channel.invokeMethod('addUserScript', args);
  }

  @override
  Future<void> addUserScripts({
    required List<UserScript> userScripts,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent(
      'userScripts',
      () => userScripts.map((e) => e.toJson()).toList(),
    );
    await _channel.invokeMethod('addUserScripts', args);
  }

  @override
  Future<bool> removeUserScript({required UserScript userScript}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('userScript', () => userScript.toJson());
    return await _channel.invokeMethod<bool>('removeUserScript', args) ??
        false;
  }

  @override
  Future<void> removeUserScripts({
    required List<UserScript> userScripts,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent(
      'userScripts',
      () => userScripts.map((e) => e.toJson()).toList(),
    );
    await _channel.invokeMethod('removeUserScripts', args);
  }

  @override
  Future<void> removeUserScriptsByGroupName({
    required String groupName,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('groupName', () => groupName);
    await _channel.invokeMethod('removeUserScriptsByGroupName', args);
  }

  @override
  Future<void> removeAllUserScripts() async {
    await _channel.invokeMethod('removeAllUserScripts');
  }

  @override
  Future<CallAsyncJavaScriptResult?> callAsyncJavaScript({
    required String functionBody,
    Map<String, dynamic> arguments = const <String, dynamic>{},
    ContentWorld? contentWorld,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('functionBody', () => functionBody);
    args.putIfAbsent('arguments', () => arguments);
    args.putIfAbsent('contentWorld', () => contentWorld?.toMap());
    final result =
        await _channel.invokeMethod<Map>('callAsyncJavaScript', args);
    if (result == null) return null;
    return CallAsyncJavaScriptResult.fromJson(
        result.cast<String, dynamic>());
  }

  // --- JavaScript Handlers ---

  final Map<String, JavaScriptHandlerCallback> _javaScriptHandlers =
      <String, JavaScriptHandlerCallback>{};

  @override
  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  }) {
    _javaScriptHandlers[handlerName] = callback;
    _channel
        .invokeMethod('addJavaScriptHandler', <String, dynamic>{
          'handlerName': handlerName,
        })
        .catchError((_) {});
  }

  @override
  JavaScriptHandlerCallback? removeJavaScriptHandler({
    required String handlerName,
  }) {
    final callback = _javaScriptHandlers.remove(handlerName);
    _channel
        .invokeMethod('removeJavaScriptHandler', <String, dynamic>{
          'handlerName': handlerName,
        })
        .catchError((_) {});
    return callback;
  }

  // --- Content / HTML / Screenshot ---

  @override
  Future<String?> getHtml() async {
    return await _channel.invokeMethod<String>('getHtml');
  }

  @override
  Future<Uint8List?> takeScreenshot({
    ScreenshotConfiguration? screenshotConfiguration,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent(
      'screenshotConfiguration',
      () => screenshotConfiguration?.toJson(),
    );
    return await _channel.invokeMethod<Uint8List?>('takeScreenshot', args);
  }

  @override
  Future<Uint8List?> createPdf({PDFConfiguration? pdfConfiguration}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('pdfConfiguration', () => pdfConfiguration?.toJson());
    return await _channel.invokeMethod<Uint8List?>('createPdf', args);
  }

  @override
  Future<List<Favicon>> getFavicons() async {
    List<dynamic>? favicons =
        await _channel.invokeMethod<List>('getFavicons');
    if (favicons == null) return [];
    return favicons
        .map((e) => Favicon.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  // --- Settings ---

  @override
  Future<void> setSettings({required InAppWebViewSettings settings}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('settings', () => settings.toJson());
    await _channel.invokeMethod('setSettings', args);
  }

  @override
  Future<InAppWebViewSettings?> getSettings() async {
    final settingsMap =
        await _channel.invokeMethod<Map>('getSettings');
    if (settingsMap == null) return null;
    // InAppWebViewSettings does not have fromMap;
    // Linux native side doesn't support reading settings back yet.
    return null;
  }

  // --- History ---

  @override
  Future<WebHistory?> getCopyBackForwardList() async {
    final result =
        await _channel.invokeMethod<Map>('getCopyBackForwardList');
    if (result == null) return null;
    return WebHistory.fromJson(result.cast<String, dynamic>());
  }

  @override
  Future<void> clearHistory() async {
    await _channel.invokeMethod('clearHistory');
  }

  // --- Scrolling ---

  @override
  Future<void> scrollTo({
    required int x,
    required int y,
    bool animated = false,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('x', () => x);
    args.putIfAbsent('y', () => y);
    args.putIfAbsent('animated', () => animated);
    await _channel.invokeMethod('scrollTo', args);
  }

  @override
  Future<void> scrollBy({
    required int x,
    required int y,
    bool animated = false,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('x', () => x);
    args.putIfAbsent('y', () => y);
    args.putIfAbsent('animated', () => animated);
    await _channel.invokeMethod('scrollBy', args);
  }

  @override
  Future<int?> getScrollX() async {
    return await _channel.invokeMethod<int>('getScrollX');
  }

  @override
  Future<int?> getScrollY() async {
    return await _channel.invokeMethod<int>('getScrollY');
  }

  @override
  Future<bool> canScrollVertically() async {
    return await _channel.invokeMethod<bool>('canScrollVertically') ?? false;
  }

  @override
  Future<bool> canScrollHorizontally() async {
    return await _channel.invokeMethod<bool>('canScrollHorizontally') ?? false;
  }

  @override
  Future<bool> pageDown({required bool bottom}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('bottom', () => bottom);
    return await _channel.invokeMethod<bool>('pageDown', args) ?? false;
  }

  @override
  Future<bool> pageUp({required bool top}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('top', () => top);
    return await _channel.invokeMethod<bool>('pageUp', args) ?? false;
  }

  // --- Zoom ---

  @override
  Future<void> zoomBy({
    required double zoomFactor,
    bool animated = false,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('zoomFactor', () => zoomFactor);
    args.putIfAbsent('animated', () => animated);
    await _channel.invokeMethod('zoomBy', args);
  }

  @override
  Future<double?> getZoomScale() async {
    return await _channel.invokeMethod<double>('getZoomScale');
  }

  @override
  Future<bool> zoomIn() async {
    return await _channel.invokeMethod<bool>('zoomIn') ?? false;
  }

  @override
  Future<bool> zoomOut() async {
    return await _channel.invokeMethod<bool>('zoomOut') ?? false;
  }

  // --- Content dimensions ---

  @override
  Future<int?> getContentHeight() async {
    return await _channel.invokeMethod<int>('getContentHeight');
  }

  @override
  Future<int?> getContentWidth() async {
    return await _channel.invokeMethod<int>('getContentWidth');
  }

  // --- Timers / Pause ---

  @override
  Future<void> pauseTimers() async {
    await _channel.invokeMethod('pauseTimers');
  }

  @override
  Future<void> resumeTimers() async {
    await _channel.invokeMethod('resumeTimers');
  }

  @override
  Future<void> pause() async {
    await _channel.invokeMethod('pause');
  }

  @override
  Future<void> resume() async {
    await _channel.invokeMethod('resume');
  }

  // --- Text / Hit test / Focus ---

  @override
  Future<String?> getSelectedText() async {
    return await _channel.invokeMethod<String>('getSelectedText');
  }

  @override
  Future<InAppWebViewHitTestResult?> getHitTestResult() async {
    final result =
        await _channel.invokeMethod<Map>('getHitTestResult');
    if (result == null) return null;
    return InAppWebViewHitTestResult.fromJson(
        result.cast<String, dynamic>());
  }

  @override
  Future<void> clearFocus() async {
    await _channel.invokeMethod('clearFocus');
  }

  // --- Context Menu / Meta ---

  @override
  Future<void> setContextMenu(ContextMenu? contextMenu) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('contextMenu', () => contextMenu?.toJson());
    await _channel.invokeMethod('setContextMenu', args);
  }

  @override
  Future<RequestFocusNodeHrefResult?> requestFocusNodeHref() async {
    final result =
        await _channel.invokeMethod<Map>('requestFocusNodeHref');
    if (result == null) return null;
    return RequestFocusNodeHrefResult.fromJson(
        result.cast<String, dynamic>());
  }

  @override
  Future<RequestImageRefResult?> requestImageRef() async {
    final result =
        await _channel.invokeMethod<Map>('requestImageRef');
    if (result == null) return null;
    return RequestImageRefResult.fromJson(result.cast<String, dynamic>());
  }

  @override
  Future<List<MetaTag>> getMetaTags() async {
    List<dynamic>? tags =
        await _channel.invokeMethod<List>('getMetaTags');
    if (tags == null) return [];
    return tags
        .map((e) => MetaTag.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<Color?> getMetaThemeColor() async {
    int? color = await _channel.invokeMethod<int>('getMetaThemeColor');
    if (color == null) return null;
    return Color(color);
  }

  @override
  Future<WebUri?> getOriginalUrl() async {
    String? url = await _channel.invokeMethod<String>('getOriginalUrl');
    return url != null ? WebUri(url) : null;
  }

  // --- Security / Context ---

  @override
  Future<bool> isSecureContext() async {
    return await _channel.invokeMethod<bool>('isSecureContext') ?? false;
  }

  @override
  Future<bool> hasOnlySecureContent() async {
    return await _channel.invokeMethod<bool>('hasOnlySecureContent') ?? false;
  }

  @override
  Future<SslCertificate?> getCertificate() async {
    final result =
        await _channel.invokeMethod<Map>('getCertificate');
    if (result == null) return null;
    return SslCertificate.fromMap(result.cast<String, dynamic>());
  }

  // --- Media ---

  @override
  Future<void> pauseAllMediaPlayback() async {
    await _channel.invokeMethod('pauseAllMediaPlayback');
  }

  @override
  Future<void> setAllMediaPlaybackSuspended({
    required bool suspended,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('suspended', () => suspended);
    await _channel.invokeMethod('setAllMediaPlaybackSuspended', args);
  }

  @override
  Future<void> closeAllMediaPresentations() async {
    await _channel.invokeMethod('closeAllMediaPresentations');
  }

  @override
  Future<MediaPlaybackState?> requestMediaPlaybackState() async {
    int? state =
        await _channel.invokeMethod<int>('requestMediaPlaybackState');
    return mediaPlaybackStateFromWire(state);
  }

  @override
  Future<bool> isInFullscreen() async {
    return await _channel.invokeMethod<bool>('isInFullscreen') ?? false;
  }

  @override
  Future<MediaCaptureState?> getCameraCaptureState() async {
    int? state =
        await _channel.invokeMethod<int>('getCameraCaptureState');
    return mediaCaptureStateFromWire(state);
  }

  @override
  Future<void> setCameraCaptureState({
    required MediaCaptureState state,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('state', () => state.index);
    await _channel.invokeMethod('setCameraCaptureState', args);
  }

  @override
  Future<MediaCaptureState?> getMicrophoneCaptureState() async {
    int? state =
        await _channel.invokeMethod<int>('getMicrophoneCaptureState');
    return mediaCaptureStateFromWire(state);
  }

  @override
  Future<void> setMicrophoneCaptureState({
    required MediaCaptureState state,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('state', () => state.index);
    await _channel.invokeMethod('setMicrophoneCaptureState', args);
  }

  // --- Cache / Data ---

  @override
  Future<void> clearAllCache({bool includeDiskFiles = true}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('includeDiskFiles', () => includeDiskFiles);
    await _channel.invokeMethod('clearAllCache', args);
  }

  @override
  Future<void> clearFormData() async {
    await _channel.invokeMethod('clearFormData');
  }

  @override
  Future<void> clearClientCertPreferences() async {
    await _channel.invokeMethod('clearClientCertPreferences');
  }

  // --- Print ---

  @override
  Future<PlatformPrintJobController?> printCurrentPage({
    PrintJobSettings? settings,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('settings', () => settings?.toJson());
    await _channel.invokeMethod('printCurrentPage', args);
    return null;
  }

  // --- DevTools ---

  @override
  Future<void> openDevTools() async {
    await _channel.invokeMethod('openDevTools');
  }

  @override
  Future<dynamic> callDevToolsProtocolMethod({
    required String methodName,
    Map<String, dynamic>? parameters,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('methodName', () => methodName);
    if (parameters != null) {
      args.putIfAbsent('parameters', () => parameters);
    }
    return await _channel.invokeMethod('callDevToolsProtocolMethod', args);
  }

  @override
  Future<void> addDevToolsProtocolEventListener({
    required String eventName,
    required void Function(Map<String, dynamic>) callback,
  }) async {
    _devToolsProtocolEventListeners[eventName] = callback;
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('eventName', () => eventName);
    await _channel.invokeMethod('addDevToolsProtocolEventListener', args);
  }

  @override
  Future<void> removeDevToolsProtocolEventListener({
    required String eventName,
  }) async {
    _devToolsProtocolEventListeners.remove(eventName);
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('eventName', () => eventName);
    await _channel.invokeMethod('removeDevToolsProtocolEventListener', args);
  }

  @override
  Future<String?> getIFrameId() async {
    return await _channel.invokeMethod<String>('getIFrameId');
  }

  // --- User Agent ---

  @override
  Future<String> getDefaultUserAgent() async {
    return await _channel.invokeMethod<String>('getDefaultUserAgent') ??
        'Mozilla/5.0';
  }

  // --- Safe Browsing ---

  @override
  Future<bool> startSafeBrowsing() async {
    return await _channel.invokeMethod<bool>('startSafeBrowsing') ?? false;
  }

  @override
  Future<void> clearSslPreferences() async {
    await _channel.invokeMethod('clearSslPreferences');
  }

  @override
  Future<WebUri?> getSafeBrowsingPrivacyPolicyUrl() async {
    String? url = await _channel
        .invokeMethod<String>('getSafeBrowsingPrivacyPolicyUrl');
    return url != null ? WebUri(url) : null;
  }

  @override
  Future<bool> setSafeBrowsingAllowlist({required List<String> hosts}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('hosts', () => hosts);
    return await _channel.invokeMethod<bool>(
      'setSafeBrowsingAllowlist',
      args,
    ) ?? false;
  }

  // --- WebView Info ---

  @override
  Future<WebViewPackageInfo?> getCurrentWebViewPackage() async {
    // Not applicable on Linux (WebKitGTK is system-provided).
    return null;
  }

  @override
  Future<void> setWebContentsDebuggingEnabled(
    bool debuggingEnabled,
  ) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('debuggingEnabled', () => debuggingEnabled);
    await _channel.invokeMethod('setWebContentsDebuggingEnabled', args);
  }

  @override
  Future<String?> getVariationsHeader() async {
    // Not applicable on Linux.
    return null;
  }

  @override
  Future<bool> isMultiProcessEnabled() async {
    // WebKitGTK is single-process.
    return false;
  }

  @override
  Future<void> disableWebView() async {
    // Not applicable on Linux.
  }

  @override
  Future<bool> handlesURLScheme(String urlScheme) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('urlScheme', () => urlScheme);
    return await _channel.invokeMethod<bool>('handlesURLScheme', args) ??
        false;
  }

  @override
  Future<void> disposeKeepAlive(InAppWebViewKeepAlive keepAlive) async {
    await _channel.invokeMethod(
      'disposeKeepAlive',
      <String, dynamic>{'id': keepAlive.id},
    );
  }

  // --- Web Archive ---

  @override
  Future<String?> saveWebArchive({
    required String filePath,
    bool autoname = true,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('filePath', () => filePath);
    args.putIfAbsent('autoname', () => autoname);
    return await _channel.invokeMethod<String>('saveWebArchive', args);
  }

  @override
  Future<Uint8List?> createWebArchiveData() async {
    return await _channel.invokeMethod<Uint8List>('createWebArchiveData');
  }

  // --- Simulated Request (testing) ---

  @override
  Future<void> loadSimulatedRequest({
    required Uint8List data,
    required URLRequest urlRequest,
    URLResponse? urlResponse,
  }) async {
    throw UnimplementedError(
      'loadSimulatedRequest is not implemented on Linux',
    );
  }

  // --- Web Message (not supported on Linux) ---

  @override
  Future<PlatformWebMessageChannel?> createWebMessageChannel() {
    throw UnimplementedError(
      'createWebMessageChannel is not implemented on Linux',
    );
  }

  @override
  Future<void> postWebMessage({
    required WebMessage message,
    WebUri? targetOrigin,
  }) {
    throw UnimplementedError('postWebMessage is not implemented on Linux');
  }

  @override
  Future<void> addWebMessageListener(
    PlatformWebMessageListener webMessageListener,
  ) {
    throw UnimplementedError(
      'addWebMessageListener is not implemented on Linux',
    );
  }

  // --- TRex Runner (offline error page) ---

  @override
  Future<String> get tRexRunnerHtml async =>
      await rootBundle.loadString(
        'packages/zikzak_inappwebview/assets/t_rex_runner/trex.html',
      );

  @override
  Future<String> get tRexRunnerCss async =>
      await rootBundle.loadString(
        'packages/zikzak_inappwebview/assets/t_rex_runner/trex.css',
      );

  // --- Dispose ---

  @override
  void dispose({bool isKeepAlive = false}) {
    if (!isKeepAlive) {
      _channel.setMethodCallHandler(null);
    }
    super.dispose(isKeepAlive: isKeepAlive);
  }
}
