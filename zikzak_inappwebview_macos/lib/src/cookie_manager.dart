import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

class MacOSCookieManager extends PlatformCookieManager {
  MacOSCookieManager(PlatformCookieManagerCreationParams params)
    : super.implementation(params);

  @override
  Future<void> dispose() async {
    // TODO: implement dispose
  }
}
