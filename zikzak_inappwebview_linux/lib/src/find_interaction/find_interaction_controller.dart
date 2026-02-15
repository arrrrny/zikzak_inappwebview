import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

class LinuxFindInteractionController extends PlatformFindInteractionController
    with ChannelController {
  LinuxFindInteractionController(
      PlatformFindInteractionControllerCreationParams params)
      : super.implementation(params);

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onFindResultReceived":
        if (onFindResultReceived != null) {
          int activeMatchOrdinal = call.arguments["activeMatchOrdinal"];
          int numberOfMatches = call.arguments["numberOfMatches"];
          bool isDoneCounting = call.arguments["isDoneCounting"];
          onFindResultReceived!(
              this, activeMatchOrdinal, numberOfMatches, isDoneCounting);
        }
        break;
      default:
        throw UnimplementedError("Unimplemented ${call.method} method");
    }
    return null;
  }

  @override
  Future<void> findAll({String? find}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('find', () => find);
    await channel?.invokeMethod('findAll', args);
  }

  @override
  Future<void> findNext({bool forward = true}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('forward', () => forward);
    await channel?.invokeMethod('findNext', args);
  }

  @override
  Future<void> clearMatches() async {
    Map<String, dynamic> args = <String, dynamic>{};
    await channel?.invokeMethod('clearMatches', args);
  }

  @override
  Future<void> setSearchText(String? searchText) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('searchText', () => searchText);
    await channel?.invokeMethod('setSearchText', args);
  }

  @override
  Future<String?> getSearchText() async {
    Map<String, dynamic> args = <String, dynamic>{};
    return await channel?.invokeMethod<String?>('getSearchText', args);
  }

  @override
  Future<bool?> isFindNavigatorVisible() async {
    return false;
  }

  @override
  Future<void> updateResultCount() async {}

  @override
  Future<void> presentFindNavigator() async {}

  @override
  Future<void> dismissFindNavigator() async {}

  @override
  Future<FindSession?> getActiveFindSession() async {
    return null;
  }

  @override
  void dispose({bool isKeepAlive = false}) {
    disposeChannel();
  }

  void setupMethodHandler() {
    handler = _handleMethod;
    initMethodCallHandler();
  }
}
