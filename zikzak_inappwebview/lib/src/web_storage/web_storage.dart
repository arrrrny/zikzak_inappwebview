import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../in_app_webview/in_app_webview_controller.dart';

///{@macro zikzak_inappwebview_platform_interface.PlatformWebStorage}
class WebStorage {
  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebStorage}
  WebStorage(
      {required PlatformLocalStorage localStorage,
      required PlatformSessionStorage sessionStorage})
      : this.fromPlatformCreationParams(
            params: PlatformWebStorageCreationParams(
                localStorage: localStorage, sessionStorage: sessionStorage));

  /// Constructs a [WebStorage].
  ///
  /// See [WebStorage.fromPlatformCreationParams] for setting parameters for
  /// a specific platform.
  WebStorage.fromPlatformCreationParams({
    required PlatformWebStorageCreationParams params,
  }) : this.fromPlatform(platform: PlatformWebStorage(params));

  /// Constructs a [WebStorage] from a specific platform implementation.
  WebStorage.fromPlatform({required this.platform});

  /// Implementation of [PlatformWebStorage] for the current platform.
  final PlatformWebStorage platform;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebStorage.localStorage}
  LocalStorage get localStorage =>
      LocalStorage.fromPlatform(platform: platform.localStorage);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebStorage.sessionStorage}
  SessionStorage get sessionStorage =>
      SessionStorage.fromPlatform(platform: platform.sessionStorage);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformWebStorage.dispose}
  void dispose() => platform.dispose();
}

///{@macro zikzak_inappwebview_platform_interface.PlatformStorage}
abstract class Storage implements PlatformStorage {
  /// Constructs a [Storage] from a specific platform implementation.
  Storage.fromPlatform({required this.platform});

  /// Implementation of [PlatformStorage] for the current platform.
  final PlatformStorage platform;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformStorage.controller}
  PlatformInAppWebViewController? get controller => platform.controller;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformStorage.webStorageType}
  WebStorageType get webStorageType => platform.webStorageType;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformStorage.length}
  Future<int?> length() => platform.length();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformStorage.setItem}
  Future<void> setItem({required String key, required dynamic value}) =>
      platform.setItem(key: key, value: value);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformStorage.getItem}
  Future<dynamic> getItem({required String key}) => platform.getItem(key: key);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformStorage.removeItem}
  Future<void> removeItem({required String key}) =>
      platform.removeItem(key: key);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformStorage.getItems}
  Future<List<WebStorageItem>> getItems() => platform.getItems();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformStorage.clear}
  Future<void> clear() => platform.clear();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformStorage.key}
  Future<String> key({required int index}) => platform.key(index: index);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformStorage.dispose}
  void dispose() => platform.dispose();
}

///{@macro zikzak_inappwebview_platform_interface.PlatformLocalStorage}
class LocalStorage extends Storage {
  ///{@macro zikzak_inappwebview_platform_interface.PlatformLocalStorage}
  LocalStorage({required InAppWebViewController? controller})
      : this.fromPlatformCreationParams(
            params: PlatformLocalStorageCreationParams(
                PlatformStorageCreationParams(
                    controller: controller?.platform,
                    webStorageType: WebStorageType.LOCAL_STORAGE)));

  /// Constructs a [LocalStorage].
  ///
  /// See [LocalStorage.fromPlatformCreationParams] for setting parameters for
  /// a specific platform.
  LocalStorage.fromPlatformCreationParams({
    required PlatformLocalStorageCreationParams params,
  }) : this.fromPlatform(platform: PlatformLocalStorage(params));

  /// Constructs a [LocalStorage] from a specific platform implementation.
  LocalStorage.fromPlatform({required this.platform})
      : super.fromPlatform(platform: platform);

  /// Implementation of [PlatformLocalStorage] for the current platform.
  final PlatformLocalStorage platform;
}

///{@macro zikzak_inappwebview_platform_interface.PlatformSessionStorage}
class SessionStorage extends Storage {
  ///{@macro zikzak_inappwebview_platform_interface.PlatformSessionStorage}
  SessionStorage({required InAppWebViewController? controller})
      : this.fromPlatformCreationParams(
            params: PlatformSessionStorageCreationParams(
                PlatformStorageCreationParams(
                    controller: controller?.platform,
                    webStorageType: WebStorageType.SESSION_STORAGE)));

  /// Constructs a [SessionStorage].
  ///
  /// See [SessionStorage.fromPlatformCreationParams] for setting parameters for
  /// a specific platform.
  SessionStorage.fromPlatformCreationParams({
    required PlatformSessionStorageCreationParams params,
  }) : this.fromPlatform(platform: PlatformSessionStorage(params));

  /// Constructs a [SessionStorage] from a specific platform implementation.
  SessionStorage.fromPlatform({required this.platform})
      : super.fromPlatform(platform: platform);

  /// Implementation of [PlatformSessionStorage] for the current platform.
  final PlatformSessionStorage platform;
}
