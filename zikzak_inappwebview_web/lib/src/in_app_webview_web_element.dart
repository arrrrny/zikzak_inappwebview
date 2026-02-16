import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'in_app_webview_web_controller.dart';

class InAppWebViewWebElement extends PlatformInAppWebViewWidget {
  final web.HTMLIFrameElement _iframe;
  late final InAppWebViewWebController _controller;

  InAppWebViewWebElement(PlatformInAppWebViewWidgetCreationParams params)
    : _iframe = web.HTMLIFrameElement(),
      super.implementation(params) {
    _iframe.style.width = '100%';
    _iframe.style.height = '100%';
    _iframe.style.border = 'none';

    final controllerParams = PlatformInAppWebViewControllerCreationParams(
      id: params.windowId,
      webviewParams: params,
    );
    _controller = InAppWebViewWebController(controllerParams, _iframe);

    _controller.onLoadStartCallback = (url) {
      if (params.onLoadStart != null) {
        params.onLoadStart!(controllerFromPlatform(_controller), url);
      }
    };

    _iframe.addEventListener(
      'load',
      ((web.Event event) {
        if (params.onLoadStop != null) {
          WebUri? url;
          try {
            final href = _iframe.contentWindow?.location.href;
            if (href != null && href.isNotEmpty) url = WebUri(href);
          } catch (_) {}
          url ??= _iframe.src.isNotEmpty ? WebUri(_iframe.src) : null;
          params.onLoadStop!(controllerFromPlatform(_controller), url);
        }
      }).toJS,
    );

    if (params.initialUrlRequest != null) {
      _controller.loadUrl(urlRequest: params.initialUrlRequest!);
    } else if (params.initialFile != null) {
      _controller.loadFile(assetFilePath: params.initialFile!);
    } else if (params.initialData != null) {
      _controller.loadData(
        data: params.initialData!.data,
        mimeType: params.initialData!.mimeType,
        encoding: params.initialData!.encoding,
        baseUrl: params.initialData!.baseUrl,
        historyUrl: params.initialData!.historyUrl,
      );
    }

    if (params.onWebViewCreated != null) {
      params.onWebViewCreated!(controllerFromPlatform(_controller));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generate a unique view ID based on windowId or fallback to unique hash
    final String viewType =
        'zikzak_inappwebview_web_${params.windowId ?? hashCode}';

    // Register the view factory
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      return _iframe;
    });

    return HtmlElementView(viewType: viewType);
  }

  @override
  T controllerFromPlatform<T>(PlatformInAppWebViewController controller) {
    if (params.controllerFromPlatform != null) {
      return params.controllerFromPlatform!(controller) as T;
    }
    return controller as T;
  }

  @override
  void dispose() {
    _controller.dispose();
  }
}
