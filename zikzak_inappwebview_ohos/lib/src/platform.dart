import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'controller.dart';
import 'cookie_manager.dart';

/// Registers ArkWeb behind the same public factories as the other platforms.
class OhosInAppWebViewPlatform extends InAppWebViewPlatform {
  static void registerWith() {
    InAppWebViewPlatform.instance = OhosInAppWebViewPlatform();
  }

  @override
  PlatformInAppWebViewWidget createPlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams params,
  ) => OhosInAppWebViewWidget(params);

  @override
  PlatformInAppWebViewController createPlatformInAppWebViewController(
    PlatformInAppWebViewControllerCreationParams params,
  ) => OhosInAppWebViewController(params);

  @override
  PlatformInAppWebViewController createPlatformInAppWebViewControllerStatic() =>
      OhosInAppWebViewController(
        const PlatformInAppWebViewControllerCreationParams(id: 'static'),
      );

  @override
  PlatformCookieManager createPlatformCookieManager(
    PlatformCookieManagerCreationParams params,
  ) => OhosCookieManager(params);
}

class OhosInAppWebViewWidget extends PlatformInAppWebViewWidget {
  OhosInAppWebViewWidget(super.params) : super.implementation();

  OhosInAppWebViewController? _controller;

  @override
  T controllerFromPlatform<T>(dynamic platformController) =>
      platformController as T;

  @override
  Widget build(BuildContext context) {
    if (params.headlessWebView != null ||
        params.keepAlive != null ||
        params.windowId != null) {
      throw UnsupportedError(
        'ArkWeb does not support adopting another WebView',
      );
    }
    return OhosView(
      key: params.key,
      viewType: 'wtf.zikzak/arkweb',
      layoutDirection: params.layoutDirection ?? Directionality.of(context),
      gestureRecognizers: params.gestureRecognizers,
      creationParamsCodec: const StandardMessageCodec(),
      creationParams: jsonEncode({
        'settings': params.initialSettings?.toJson() ?? {},
        'scripts':
            params.initialUserScripts
                ?.map((script) => script.toJson())
                .toList() ??
            [],
        'initialUrlRequest': params.initialUrlRequest?.toJson(),
        'initialData': params.initialData?.toJson(),
        'initialFile': params.initialFile,
        'interceptNavigation': params.shouldOverrideUrlLoading != null,
      }),
      onPlatformViewCreated: (id) {
        final controller = OhosInAppWebViewController(
          PlatformInAppWebViewControllerCreationParams(
            id: id,
            webviewParams: params,
          ),
        );
        _controller = controller;
        params.onWebViewCreated?.call(
          params.controllerFromPlatform?.call(controller) ?? controller,
        );
        unawaited(controller.startInitialLoad());
      },
    );
  }

  @override
  void dispose({bool isKeepAlive = false}) {
    _controller?.dispose();
    _controller = null;
  }
}
