import 'dart:core';

import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

class LinuxInAppWebViewController extends PlatformInAppWebViewController {
  LinuxInAppWebViewController(PlatformInAppWebViewControllerCreationParams params)
      : super.implementation(params) {
    _channel = MethodChannel('com.pichillilorenzo/flutter_inappwebview_${params.id}');
    _channel.setMethodCallHandler((call) async {
      try {
        return await handleMethod(call);
      } catch (e) {
        // ignore error
      }
    });
  }

  LinuxInAppWebViewController.fromInAppBrowser(
      PlatformInAppWebViewControllerCreationParams params,
      MethodChannel channel)
      : super.implementation(params) {
    _channel = channel;
  }

  LinuxInAppWebViewController.static()
      : super.implementation(
            PlatformInAppWebViewControllerCreationParams(id: 'static'));

  late MethodChannel _channel;

  Future<dynamic> handleMethod(MethodCall call) async {
    final controller = params.webviewParams?.controllerFromPlatform != null
        ? params.webviewParams!.controllerFromPlatform!(this)
        : this;

    switch (call.method) {
      case 'onLoadStart':
        if (params.webviewParams?.onLoadStart != null) {
          String? url = call.arguments['url'];
          params.webviewParams!.onLoadStart!(
              controller, url != null ? WebUri(url) : null);
        }
        break;
      case 'onLoadStop':
        if (params.webviewParams?.onLoadStop != null) {
          String? url = call.arguments['url'];
          params.webviewParams!.onLoadStop!(
              controller, url != null ? WebUri(url) : null);
        }
        break;
      case 'onReceivedError':
        if (params.webviewParams?.onReceivedError != null) {
          String? url = call.arguments['url'];
          int code = call.arguments['code'];
          String message = call.arguments['message'];

          params.webviewParams!.onReceivedError!(
              controller,
              WebResourceRequest(
                  url: url != null ? WebUri(url) : WebUri('')),
              WebResourceError(
                  type: WebResourceErrorType.fromNativeValue(code) ??
                      WebResourceErrorType.UNKNOWN,
                  description: message));
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
              controller, url != null ? WebUri(url) : null, isReload);
        }
        break;
      case 'onTitleChanged':
        if (params.webviewParams?.onTitleChanged != null) {
          String? title = call.arguments['title'];
          params.webviewParams!.onTitleChanged!(controller, title);
        }
        break;
      case 'shouldOverrideUrlLoading':
        // Linux might not support this fully yet, but we'll include it.
        if (params.webviewParams?.shouldOverrideUrlLoading != null) {
          Map<String, dynamic> arguments = call.arguments.cast<String, dynamic>();
          var navigationAction = NavigationAction.fromMap(arguments['navigationAction'].cast<String, dynamic>())!;
          var policy = await params.webviewParams!.shouldOverrideUrlLoading!(controller, navigationAction);
          return policy?.toNativeValue() ?? NavigationActionPolicy.CANCEL.toNativeValue();
        }
        return NavigationActionPolicy.ALLOW.toNativeValue();
      case 'onConsoleMessage':
        if (params.webviewParams?.onConsoleMessage != null) {
          var consoleMessage = ConsoleMessage.fromMap(call.arguments.cast<String, dynamic>())!;
          params.webviewParams!.onConsoleMessage!(controller, consoleMessage);
        }
        break;
      default:
        throw UnimplementedError("Unimplemented ${call.method} method");
    }
  }

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
  Future<void> loadUrl(
      {required URLRequest urlRequest, WebUri? allowingReadAccessTo}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('urlRequest', () => urlRequest.toMap());
    args.putIfAbsent('allowingReadAccessTo', () => allowingReadAccessTo.toString());
    await _channel.invokeMethod('loadUrl', args);
  }

  @override
  Future<void> reload() async {
    await _channel.invokeMethod('reload');
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
  Future<bool> isLoading() async {
    return await _channel.invokeMethod<bool>('isLoading') ?? false;
  }

  @override
  Future<void> stopLoading() async {
    await _channel.invokeMethod('stopLoading');
  }

  @override
  Future<void> evaluateJavascript(
      {required String source, ContentWorld? contentWorld}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('source', () => source);
    args.putIfAbsent('contentWorld', () => contentWorld?.toMap());
    await _channel.invokeMethod('evaluateJavascript', args);
  }

  @override
  Future<void> injectJavascriptFileFromUrl(
      {required WebUri urlFile,
      ScriptHtmlTagAttributes? scriptHtmlTagAttributes}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('urlFile', () => urlFile.toString());
    args.putIfAbsent('scriptHtmlTagAttributes', () => scriptHtmlTagAttributes?.toMap());
    await _channel.invokeMethod('injectJavascriptFileFromUrl', args);
  }

  @override
  Future<dynamic> injectJavascriptFileFromAsset(
      {required String assetFilePath}) async {
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
  Future<void> injectCSSFileFromUrl(
      {required WebUri urlFile,
      CSSLinkHtmlTagAttributes? cssLinkHtmlTagAttributes}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('urlFile', () => urlFile.toString());
    args.putIfAbsent('cssLinkHtmlTagAttributes', () => cssLinkHtmlTagAttributes?.toMap());
    await _channel.invokeMethod('injectCSSFileFromUrl', args);
  }

  @override
  Future<void> injectCSSFileFromAsset({required String assetFilePath}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('assetFilePath', () => assetFilePath);
    await _channel.invokeMethod('injectCSSFileFromAsset', args);
  }

  @override
  void dispose({bool isKeepAlive = false}) {
    if (!isKeepAlive) {
       _channel.setMethodCallHandler(null);
    }
  }
}
