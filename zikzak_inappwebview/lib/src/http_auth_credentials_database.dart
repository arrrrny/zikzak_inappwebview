import 'dart:async';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

///{@macro zikzak_inappwebview_platform_interface.PlatformHttpAuthCredentialDatabase}
class HttpAuthCredentialDatabase {
  ///{@macro zikzak_inappwebview_platform_interface.PlatformHttpAuthCredentialDatabase}
  HttpAuthCredentialDatabase()
      : this.fromPlatformCreationParams(
          const PlatformHttpAuthCredentialDatabaseCreationParams(),
        );

  /// Constructs a [HttpAuthCredentialDatabase] from creation params for a specific
  /// platform.
  HttpAuthCredentialDatabase.fromPlatformCreationParams(
    PlatformHttpAuthCredentialDatabaseCreationParams params,
  ) : this.fromPlatform(PlatformHttpAuthCredentialDatabase(params));

  /// Constructs a [HttpAuthCredentialDatabase] from a specific platform
  /// implementation.
  HttpAuthCredentialDatabase.fromPlatform(this.platform);

  /// Implementation of [PlatformHttpAuthCredentialDatabase] for the current platform.
  final PlatformHttpAuthCredentialDatabase platform;

  static HttpAuthCredentialDatabase? _instance;

  ///Gets the [HttpAuthCredentialDatabase] shared instance.
  static HttpAuthCredentialDatabase instance() {
    if (_instance == null) {
      _instance = HttpAuthCredentialDatabase();
    }
    return _instance!;
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformHttpAuthCredentialDatabase.getAllAuthCredentials}
  Future<List<URLProtectionSpaceHttpAuthCredentials>> getAllAuthCredentials() =>
      platform.getAllAuthCredentials();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformHttpAuthCredentialDatabase.getHttpAuthCredentials}
  Future<List<URLCredential>> getHttpAuthCredentials(
          {required URLProtectionSpace protectionSpace}) =>
      platform.getHttpAuthCredentials(protectionSpace: protectionSpace);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformHttpAuthCredentialDatabase.setHttpAuthCredential}
  Future<void> setHttpAuthCredential(
          {required URLProtectionSpace protectionSpace,
          required URLCredential credential}) =>
      platform.setHttpAuthCredential(
          protectionSpace: protectionSpace, credential: credential);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformHttpAuthCredentialDatabase.removeHttpAuthCredential}
  Future<void> removeHttpAuthCredential(
          {required URLProtectionSpace protectionSpace,
          required URLCredential credential}) =>
      platform.removeHttpAuthCredential(
          protectionSpace: protectionSpace, credential: credential);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformHttpAuthCredentialDatabase.removeHttpAuthCredentials}
  Future<void> removeHttpAuthCredentials(
          {required URLProtectionSpace protectionSpace}) =>
      platform.removeHttpAuthCredentials(protectionSpace: protectionSpace);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformHttpAuthCredentialDatabase.clearAllAuthCredentials}
  Future<void> clearAllAuthCredentials() => platform.clearAllAuthCredentials();
}
