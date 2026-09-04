import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

class MacOSProxyControllerCreationParams
    extends PlatformProxyControllerCreationParams {
  const MacOSProxyControllerCreationParams(
    PlatformProxyControllerCreationParams params,
  ) : super();

  factory MacOSProxyControllerCreationParams.fromPlatformProxyControllerCreationParams(
    PlatformProxyControllerCreationParams params,
  ) {
    return MacOSProxyControllerCreationParams(params);
  }
}

class MacOSProxyController extends PlatformProxyController
    with ChannelController {
  MacOSProxyController(PlatformProxyControllerCreationParams params)
    : super.implementation(
        params is MacOSProxyControllerCreationParams
            ? params
            : MacOSProxyControllerCreationParams
                .fromPlatformProxyControllerCreationParams(params),
      ) {
    channel = const MethodChannel(
      'wtf.zikzak/zikzak_inappwebview_proxycontroller',
    );
    handler = _handleMethod;
    initMethodCallHandler();
  }

  @override
  Future<void> setProxyOverride({required ProxySettings settings}) async {
    final args = <String, dynamic>{};
    args['settings'] = settings.iOSProxySettings?.toJson();
    await channel?.invokeMethod('setProxyOverride', args);
  }

  @override
  Future<void> clearProxyOverride() async {
    await channel?.invokeMethod('clearProxyOverride');
  }

  Future<dynamic> _handleMethod(MethodCall call) async {}

  @override
  void dispose({bool isKeepAlive = false}) {}
}
