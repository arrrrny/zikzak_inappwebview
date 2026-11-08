import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

class IosProxyControllerCreationParams
    extends PlatformProxyControllerCreationParams {
  /// Creates a new [IosProxyControllerCreationParams] instance.
  const IosProxyControllerCreationParams(
    // This parameter prevents breaking changes later.
    // ignore: avoid_unused_constructor_parameters
    PlatformProxyControllerCreationParams params,
  ) : super();

  /// Creates a [IosProxyControllerCreationParams] instance based on [PlatformProxyControllerCreationParams].
  factory IosProxyControllerCreationParams.fromPlatformProxyControllerCreationParams(
    PlatformProxyControllerCreationParams params,
  ) {
    return IosProxyControllerCreationParams(params);
  }
}

class IosProxyController extends PlatformProxyController
    with ChannelController {
  IosProxyController(PlatformProxyControllerCreationParams params)
    : super.implementation(
        params is IosProxyControllerCreationParams
            ? params
            : IosProxyControllerCreationParams.fromPlatformProxyControllerCreationParams(
                params,
              ),
      ) {
    channel = const MethodChannel(
      'wtf.zikzak/zikzak_inappwebview_proxycontroller',
    );
    handler = _handleMethod;
    initMethodCallHandler();
  }

  static IosProxyController? _instance;

  static IosProxyController instance() {
    return (_instance != null) ? _instance! : _init();
  }

  static IosProxyController _init() {
    _instance = IosProxyController(
      IosProxyControllerCreationParams(
        const PlatformProxyControllerCreationParams(),
      ),
    );
    return _instance!;
  }

  @override
  Future<void> setProxyOverride({required ProxySettings settings}) async {
    final args = <String, dynamic>{
      'settings': settings.iOSProxySettings?.toJson(),
    };
    // Per-profile proxies (issue #410 / consumer FR-007): the profileId keys
    // the native registry the WebView factory consults when a persistent
    // WKWebsiteDataStore is created — without it the configuration only ever
    // reaches the default store, and isolated profiles egress directly.
    if (settings.profileId != null) {
      args['profileId'] = settings.profileId;
    }
    await channel?.invokeMethod('setProxyOverride', args);
  }

  @override
  Future<void> clearProxyOverride({String? profileId}) async {
    final args = <String, dynamic>{};
    if (profileId != null) {
      args['profileId'] = profileId;
    }
    await channel?.invokeMethod('clearProxyOverride', args);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {}

  @override
  void dispose({bool isKeepAlive = false}) {
    // empty.
  }
}
