import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart";

/// Object specifying creation parameters for creating a [MacOSPrintJobController].
@immutable
class MacOSPrintJobControllerCreationParams
    extends PlatformPrintJobControllerCreationParams {
  const MacOSPrintJobControllerCreationParams({
    required super.id,
    super.onComplete,
  });

  factory MacOSPrintJobControllerCreationParams.fromPlatformPrintJobControllerCreationParams(
    PlatformPrintJobControllerCreationParams params,
  ) {
    return MacOSPrintJobControllerCreationParams(
      id: params.id,
      onComplete: params.onComplete,
    );
  }
}

///{@macro zikzak_inappwebview_platform_interface.PlatformPrintJobController}
class MacOSPrintJobController extends PlatformPrintJobController
    with ChannelController {
  MacOSPrintJobController(PlatformPrintJobControllerCreationParams params)
      : super.implementation(
          params is MacOSPrintJobControllerCreationParams
              ? params
              : MacOSPrintJobControllerCreationParams.fromPlatformPrintJobControllerCreationParams(
                  params,
                ),
        ) {
    onComplete = params.onComplete;
    channel = MethodChannel(
      "wtf.zikzak/zikzak_inappwebview_printjobcontroller_${params.id}",
    );
    handler = _handleMethod;
    initMethodCallHandler();
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onComplete":
        bool completed = call.arguments["completed"];
        String? error = call.arguments["error"];
        if (onComplete != null) {
          onComplete!(completed, error);
        }
        break;
      default:
        throw UnimplementedError("Unimplemented ${call.method} method");
    }
  }

  @override
  Future<void> dismiss({bool animated = true}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("animated", () => animated);
    await channel?.invokeMethod("dismiss", args);
  }

  @override
  Future<PrintJobInfo?> getInfo() async {
    Map<String, dynamic> args = <String, dynamic>{};
    Map<String, dynamic>? infoMap = (await channel?.invokeMethod(
      "getInfo",
      args,
    ))?.cast<String, dynamic>();
    return infoMap == null ? null : PrintJobInfo.fromJson(infoMap);
  }

  @override
  Future<void> dispose({bool isKeepAlive = false}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    await channel?.invokeMethod("dispose", args);
    disposeChannel();
  }
}
