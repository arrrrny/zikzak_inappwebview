import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../util/wire.dart';

/// Object specifying creation parameters for creating a [LinuxProxyController].
///
/// When adding additional fields make sure they can be null or have a default
/// value to avoid breaking changes. See [PlatformProxyControllerCreationParams] for
/// more information.
@immutable
class LinuxProxyControllerCreationParams
    extends PlatformProxyControllerCreationParams {
  /// Creates a new [LinuxProxyControllerCreationParams] instance.
  const LinuxProxyControllerCreationParams(
    // This parameter prevents breaking changes later.
    // ignore: avoid_unused_constructor_parameters
    PlatformProxyControllerCreationParams params,
  ) : super();

  /// Creates a [LinuxProxyControllerCreationParams] instance based on [PlatformProxyControllerCreationParams].
  factory LinuxProxyControllerCreationParams.fromPlatformProxyControllerCreationParams(
    PlatformProxyControllerCreationParams params,
  ) {
    return LinuxProxyControllerCreationParams(params);
  }
}

///{@macro zikzak_inappwebview_platform_interface.PlatformProxyController}
///
/// Linux implementation of [PlatformProxyController] using WPE WebKit's
/// [WebKitNetworkProxySettings](https://wpewebkit.org/reference/stable/wpe-webkit-2.0/struct.NetworkProxySettings.html).
class LinuxProxyController extends PlatformProxyController {
  static const MethodChannel _channel = MethodChannel(
    'wtf.zikzak/zikzak_inappwebview_proxycontroller',
  );

  /// Creates a new [LinuxProxyController].
  LinuxProxyController(PlatformProxyControllerCreationParams params)
    : super.implementation(
        params is LinuxProxyControllerCreationParams
            ? params
            : LinuxProxyControllerCreationParams.fromPlatformProxyControllerCreationParams(
                params,
              ),
      );

  static LinuxProxyController? _instance;

  /// Gets the [LinuxProxyController] shared instance.
  static LinuxProxyController instance() {
    return (_instance != null) ? _instance! : _init();
  }

  static LinuxProxyController _init() {
    _instance = LinuxProxyController(
      LinuxProxyControllerCreationParams(
        const PlatformProxyControllerCreationParams(),
      ),
    );
    return _instance!;
  }

  static final LinuxProxyController _staticValue = LinuxProxyController(
    LinuxProxyControllerCreationParams(
      const PlatformProxyControllerCreationParams(),
    ),
  );

  /// Provide static access.
  factory LinuxProxyController.static() {
    return _staticValue;
  }

  @override
  Future<void> setProxyOverride({required ProxySettings settings}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("settings", () => proxySettingsToWire(settings));
    await _channel.invokeMethod('setProxyOverride', args);
  }

  /// [profileId] is not used on Linux: WPE has one proxy configuration per
  /// network session.
  @override
  Future<void> clearProxyOverride({String? profileId}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    await _channel.invokeMethod('clearProxyOverride', args);
  }

  /// The controller is a singleton on a static channel; nothing to release.
  @override
  void dispose({bool isKeepAlive = false}) {}
}
