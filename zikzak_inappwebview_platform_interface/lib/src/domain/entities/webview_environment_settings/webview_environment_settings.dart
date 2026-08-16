import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../../../webview_environment/platform_webview_environment.dart';

part 'webview_environment_settings.zorphy.dart';
part 'webview_environment_settings.g.dart';

///The access kind for resources mapped by [VirtualHostMapping].
///
///The values match the WebView2
///`COREWEBVIEW2_HOST_RESOURCE_ACCESS_KIND` enum.
enum HostResourceAccessKind {
  ///The host resource access is denied.
  deny,

  ///The host resource can be accessed from the same origin.
  allow,

  ///The host resource can be accessed from any origin (CORS allowed).
  allowCors,
}

///Represents a mapping between a virtual host name and a local folder,
///used to serve local content through the WebView.
///
///The WebView serves the [folderPath] content at `https://[hostName]/`.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $VirtualHostMapping {
  ///The host name to map (e.g. `app.localhost`).
  @JsonKey(fromJson: _hostNameFromJson, toJson: _hostNameToJson)
  String get hostName;

  ///The absolute folder path to map to the host name.
  @JsonKey(fromJson: _folderPathFromJson, toJson: _folderPathToJson)
  String get folderPath;

  ///The access kind for the mapped resources.
  @JsonKey(
    defaultValue: HostResourceAccessKind.allow,
    fromJson: _accessKindFromJson,
    toJson: _accessKindToJson,
  )
  HostResourceAccessKind get accessKind;
}

///This class represents all the [PlatformWebViewEnvironment] settings available.
///
///The [browserExecutableFolder], [userDataFolder] and [additionalBrowserArguments]
///may be overridden by values either specified in environment variables or in the registry.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $WebViewEnvironmentSettings {
  ///Use [browserExecutableFolder] to specify whether WebView2 controls use a fixed
  ///or installed version of the WebView2 Runtime that exists on a user machine.
  ///To use a fixed version of the WebView2 Runtime, pass the folder path that contains
  ///the fixed version of the WebView2 Runtime to [browserExecutableFolder].
  ///BrowserExecutableFolder supports both relative (to the application's executable) and absolute files paths.
  ///To create WebView2 controls that use the installed version of the WebView2 Runtime that exists on user machines,
  ///pass a `null` or empty string to [browserExecutableFolder].
  ///In this scenario, the API tries to find a compatible version of the WebView2 Runtime
  ///that is installed on the user machine (first at the machine level, and then per user) using the selected channel preference.
  ///The path of fixed version of the WebView2 Runtime should not contain `\Edge\Application\`.
  ///When such a path is used, the API fails with `HRESULT_FROM_WIN32(ERROR_NOT_SUPPORTED)`.
  ///
  ///The default channel search order is the WebView2 Runtime, Beta, Dev, and Canary.
  ///When an override `WEBVIEW2_RELEASE_CHANNEL_PREFERENCE` environment variable or
  ///applicable `releaseChannelPreference` registry value is set to `1`, the channel search order is reversed.
  String? get browserExecutableFolder;

  ///You may specify the [userDataFolder] to change the default user data folder location for WebView2.
  ///The path is either an absolute file path or a relative file path that is interpreted as relative
  ///to the compiled code for the current process.
  ///For UWP apps, the default user data folder is the app data folder for the package.
  ///For non-UWP apps, the default user data (`{Executable File Name}.WebView2`) folder
  ///is created in the same directory next to the compiled code for the app.
  ///WebView2 creation fails if the compiled code is running in a directory in which the
  ///process does not have permission to create a new directory.
  ///The app is responsible to clean up the associated user data folder when it is done.
  ///
  ///**NOTE**: As a browser process may be shared among WebViews,
  ///WebView creation fails with `HRESULT_FROM_WIN32(ERROR_INVALID_STATE)` if the specified
  ///settings does not match the settings of the WebViews that are currently
  ///running in the shared browser process.
  String? get userDataFolder;

  ///If there are multiple switches, there should be a space in between them.
  ///The one exception is if multiple features are being enabled/disabled for a single switch,
  ///in which case the features should be comma-seperated.
  ///Example: `"--disable-features=feature1,feature2 --some-other-switch --do-something"`
  String? get additionalBrowserArguments;

  ///This property is used to enable single sign on with Azure Active Directory (AAD)
  ///and personal Microsoft Account (MSA) resources inside WebView.
  bool? get allowSingleSignOnUsingOSPrimaryAccount;

  ///The default display language for WebView.
  String? get language;

  ///Specifies the version of the WebView2 Runtime binaries required to be compatible with your app.
  String? get targetCompatibleBrowserVersion;

  ///Virtual host name to folder path mappings applied to the WebView.
  ///
  ///Each mapping serves the given local [VirtualHostMapping.folderPath] at
  ///`https://[VirtualHostMapping.hostName]/`, which bypasses CORS for local
  ///resources (use [HostResourceAccessKind.allowCors] to allow cross-origin
  ///access). Currently honored by the Windows implementation.
  @JsonKey(
    fromJson: _virtualHostMappingsFromJson,
    toJson: _virtualHostMappingsToJson,
  )
  List<VirtualHostMapping>? get virtualHostMappings;
}

String _hostNameFromJson(Object? value) => value as String? ?? '';

Object? _hostNameToJson(String value) => value;

String _folderPathFromJson(Object? value) => value as String? ?? '';

Object? _folderPathToJson(String value) => value;

///The old wire coerced a missing/invalid accessKind to
///[HostResourceAccessKind.allow].
HostResourceAccessKind _accessKindFromJson(Object? value) {
  if (value is! int) return HostResourceAccessKind.allow;
  return value >= 0 && value < HostResourceAccessKind.values.length
      ? HostResourceAccessKind.values[value]
      : HostResourceAccessKind.allow;
}

Object? _accessKindToJson(HostResourceAccessKind accessKind) =>
    accessKind.index;

List<VirtualHostMapping>? _virtualHostMappingsFromJson(Object? value) {
  if (value is! List) return null;
  return value
      .map(
        (e) => VirtualHostMapping.fromJson((e as Map).cast<String, dynamic>()),
      )
      .toList();
}

Object? _virtualHostMappingsToJson(List<VirtualHostMapping>? mappings) =>
    mappings?.map((e) => e.toJson()).toList();
