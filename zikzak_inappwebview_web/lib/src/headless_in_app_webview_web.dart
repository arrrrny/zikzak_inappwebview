import 'dart:async';
import 'dart:html' as html;
import 'dart:ui';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'in_app_webview_web_controller.dart';

class HeadlessInAppWebViewWeb extends PlatformHeadlessInAppWebView {
  HeadlessInAppWebViewWeb(PlatformHeadlessInAppWebViewCreationParams params)
    : super.implementation(params);

  html.IFrameElement? _iframe;
  InAppWebViewWebController? _webViewController;

  @override
  PlatformInAppWebViewController? get webViewController => _webViewController;

  @override
  String get id => params.windowId?.toString() ?? '';

  @override
  Future<void> run() async {
    if (_iframe != null) return;

    _iframe = html.IFrameElement();
    // Hide the iframe but keep it active
    _iframe!.style.visibility = 'hidden';
    _iframe!.style.position = 'absolute';
    _iframe!.style.left = '-9999px';
    _iframe!.style.top = '-9999px';
    _iframe!.style.border = 'none';

    if (params.initialSize.width != -1) {
      _iframe!.style.width = '${params.initialSize.width}px';
    } else {
      _iframe!.style.width = '0px';
    }
    if (params.initialSize.height != -1) {
      _iframe!.style.height = '${params.initialSize.height}px';
    } else {
      _iframe!.style.height = '0px';
    }

    // Create controller
    final controllerParams = PlatformInAppWebViewControllerCreationParams(
      id: params.windowId,
      webviewParams: params,
    );

    _webViewController = InAppWebViewWebController(controllerParams, _iframe!);

    // Setup listeners
    _iframe!.onLoad.listen((event) {
      if (params.onLoadStop != null) {
        final url = _iframe!.src != null ? WebUri(_iframe!.src!) : null;
        final controller = _convertController(_webViewController!);
        params.onLoadStop!(controller, url);
      }
    });

    _webViewController!.onLoadStartCallback = (url) {
      if (params.onLoadStart != null) {
        final controller = _convertController(_webViewController!);
        params.onLoadStart!(controller, url);
      }
    };

    // Initial load
    if (params.initialUrlRequest != null) {
      _webViewController!.loadUrl(urlRequest: params.initialUrlRequest!);
    } else if (params.initialData != null) {
      _webViewController!.loadData(
        data: params.initialData!.data,
        mimeType: params.initialData!.mimeType,
        encoding: params.initialData!.encoding,
        baseUrl: params.initialData!.baseUrl,
        historyUrl: params.initialData!.historyUrl,
      );
    } else if (params.initialFile != null) {
      _webViewController!.loadFile(assetFilePath: params.initialFile!);
    }

    html.document.body!.append(_iframe!);

    if (params.onWebViewCreated != null) {
      final controller = _convertController(_webViewController!);
      params.onWebViewCreated!(controller);
    }
  }

  dynamic _convertController(PlatformInAppWebViewController controller) {
    if (params.controllerFromPlatform != null) {
      return params.controllerFromPlatform!(controller);
    }
    return controller;
  }

  @override
  Future<void> dispose() async {
    _iframe?.remove();
    _iframe = null;
    _webViewController = null;
  }

  @override
  bool isRunning() {
    return _iframe != null;
  }

  @override
  Future<void> setSize(Size size) async {
    if (_iframe != null) {
      _iframe!.style.width = '${size.width}px';
      _iframe!.style.height = '${size.height}px';
    }
  }

  @override
  Future<Size?> getSize() async {
    if (_iframe != null) {
      return Size(
        double.tryParse(_iframe!.style.width.replaceAll('px', '')) ?? 0,
        double.tryParse(_iframe!.style.height.replaceAll('px', '')) ?? 0,
      );
    }
    return null;
  }
}
