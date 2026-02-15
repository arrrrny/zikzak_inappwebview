import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

///{@macro zikzak_inappwebview_platform_interface.PlatformWebMessagePort}
class WebMessagePort implements IWebMessagePort {
  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebMessagePort}
  WebMessagePort({required int index})
      : this.fromPlatformCreationParams(
            params: PlatformWebMessagePortCreationParams(index: index));

  /// Constructs a [WebMessagePort].
  ///
  /// See [WebMessagePort.fromPlatformCreationParams] for setting parameters for
  /// a specific platform.
  WebMessagePort.fromPlatformCreationParams({
    required PlatformWebMessagePortCreationParams params,
  }) : this.fromPlatform(platform: PlatformWebMessagePort(params));

  /// Constructs a [WebMessagePort] from a specific platform implementation.
  WebMessagePort.fromPlatform({required this.platform});

  /// Implementation of [PlatformWebMessagePort] for the current platform.
  final PlatformWebMessagePort platform;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebMessagePort.setWebMessageCallback}
  Future<void> setWebMessageCallback(WebMessageCallback? onMessage) =>
      platform.setWebMessageCallback(onMessage);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebMessagePort.postMessage}
  Future<void> postMessage(WebMessage message) => platform.postMessage(message);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebMessagePort.close}
  Future<void> close() => platform.close();

  Map<String, dynamic> toMap() => platform.toMap();

  Map<String, dynamic> toJson() => platform.toJson();

  @override
  String toString() => platform.toString();
}
