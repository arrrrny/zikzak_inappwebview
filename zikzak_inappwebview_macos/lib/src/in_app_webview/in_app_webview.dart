import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../find_interaction/find_interaction_controller.dart';
import 'in_app_webview_controller.dart';

class MacOSInAppWebViewWidget extends PlatformInAppWebViewWidget {
  MacOSInAppWebViewWidget(PlatformInAppWebViewWidgetCreationParams params)
      : super.implementation(params);

  MacOSInAppWebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'initialUrlRequest': params.initialUrlRequest?.toMap(),
      'initialSettings': params.initialSettings?.toMap(),
      'initialUserScripts':
          params.initialUserScripts?.map((e) => e.toMap()).toList(),
      'contextMenu': params.contextMenu?.toMap(),
      'windowId': params.windowId,
      'initialData': params.initialData?.toMap(),
      'initialFile': params.initialFile,
    };

    return AppKitView(
      viewType: 'com.pichillilorenzo/flutter_inappwebview',
      onPlatformViewCreated: _onPlatformViewCreated,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  void _onPlatformViewCreated(int id) {
    _controller = MacOSInAppWebViewController(
      PlatformInAppWebViewControllerCreationParams(id: id, webviewParams: params),
    );

    if (params.findInteractionController != null) {
      var findInteractionController =
          params.findInteractionController as MacOSFindInteractionController;
      findInteractionController.channel = MethodChannel(
          'wtf.zikzak/zikzak_inappwebview_find_interaction_$id');
      findInteractionController.setupMethodHandler();
    }

    if (params.onWebViewCreated != null) {
      params.onWebViewCreated!(controllerFromPlatform(_controller!));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  T controllerFromPlatform<T>(PlatformInAppWebViewController controller) {
    if (params.controllerFromPlatform != null) {
      return params.controllerFromPlatform!(controller) as T;
    }
    return controller as T;
  }
}
