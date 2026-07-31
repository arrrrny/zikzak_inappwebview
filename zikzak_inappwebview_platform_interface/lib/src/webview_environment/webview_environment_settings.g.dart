// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webview_environment_settings.dart';

// **************************************************************************
// ExchangeableEnumGenerator
// **************************************************************************

///The access kind for resources mapped by [VirtualHostMapping].
///
///The values match the WebView2
///`COREWEBVIEW2_HOST_RESOURCE_ACCESS_KIND` enum.
class HostResourceAccessKind {
  final int _value;
  final int _nativeValue;
  const HostResourceAccessKind._internal(this._value, this._nativeValue);
  // ignore: unused_element
  factory HostResourceAccessKind._internalMultiPlatform(
    int value,
    Function nativeValue,
  ) => HostResourceAccessKind._internal(value, nativeValue());

  ///The host resource can be accessed from the same origin.
  static const allow = HostResourceAccessKind._internal(1, 1);

  ///The host resource can be accessed from any origin (CORS allowed).
  static const allowCors = HostResourceAccessKind._internal(2, 2);

  ///The host resource access is denied.
  static const deny = HostResourceAccessKind._internal(0, 0);

  ///Set of all values of [HostResourceAccessKind].
  static final Set<HostResourceAccessKind> values = [
    HostResourceAccessKind.allow,
    HostResourceAccessKind.allowCors,
    HostResourceAccessKind.deny,
  ].toSet();

  ///Gets a possible [HostResourceAccessKind] instance from [int] value.
  static HostResourceAccessKind? fromValue(int? value) {
    if (value != null) {
      try {
        return HostResourceAccessKind.values.firstWhere(
          (element) => element.toValue() == value,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [HostResourceAccessKind] instance from a native value.
  static HostResourceAccessKind? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return HostResourceAccessKind.values.firstWhere(
          (element) => element.toNativeValue() == value,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets [int] value.
  int toValue() => _value;

  ///Gets [int] native value.
  int toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    switch (_value) {
      case 1:
        return 'allow';
      case 2:
        return 'allowCors';
      case 0:
        return 'deny';
    }
    return _value.toString();
  }
}

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///Represents a mapping between a virtual host name and a local folder,
///used to serve local content through the WebView.
///
///The WebView serves the [folderPath] content at `https://[hostName]/`.
class VirtualHostMapping {
  ///The access kind for the mapped resources.
  final HostResourceAccessKind accessKind;

  ///The absolute folder path to map to the host name.
  final String folderPath;

  ///The host name to map (e.g. `app.localhost`).
  final String hostName;
  VirtualHostMapping({
    this.accessKind = HostResourceAccessKind.allow,
    required this.folderPath,
    required this.hostName,
  });

  ///Gets a possible [VirtualHostMapping] instance from a [Map] value.
  static VirtualHostMapping? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = VirtualHostMapping(
      accessKind:
          HostResourceAccessKind.fromNativeValue(map['accessKind']) ??
          HostResourceAccessKind.allow,
      folderPath: map['folderPath'] as String? ?? '',
      hostName: map['hostName'] as String? ?? '',
    );
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "accessKind": accessKind.toNativeValue(),
      "folderPath": folderPath,
      "hostName": hostName,
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'VirtualHostMapping{accessKind: $accessKind, folderPath: $folderPath, hostName: $hostName}';
  }
}

///This class represents all the [PlatformWebViewEnvironment] settings available.
///
///The [browserExecutableFolder], [userDataFolder] and [additionalBrowserArguments]
///may be overridden by values either specified in environment variables or in the registry.
///
///**Officially Supported Platforms/Implementations**:
///- Windows
class WebViewEnvironmentSettings {
  ///If there are multiple switches, there should be a space in between them.
  ///The one exception is if multiple features are being enabled/disabled for a single switch,
  ///in which case the features should be comma-seperated.
  ///Example: `"--disable-features=feature1,feature2 --some-other-switch --do-something"`
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Windows ([Official API - ICoreWebView2EnvironmentOptions.put_AdditionalBrowserArguments](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2environmentoptions?view=webview2-1.0.2210.55#put_additionalbrowserarguments))
  final String? additionalBrowserArguments;

  ///This property is used to enable single sign on with Azure Active Directory (AAD)
  ///and personal Microsoft Account (MSA) resources inside WebView.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Windows ([Official API - ICoreWebView2EnvironmentOptions.put_AllowSingleSignOnUsingOSPrimaryAccount](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2environmentoptions?view=webview2-1.0.2210.55#put_allowsinglesignonusingosprimaryaccount))
  final bool? allowSingleSignOnUsingOSPrimaryAccount;

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
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Windows ([Official API - CreateCoreWebView2EnvironmentWithOptions.browserExecutableFolder](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#createcorewebview2environmentwithoptions))
  final String? browserExecutableFolder;

  ///The default display language for WebView.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Windows ([Official API - ICoreWebView2EnvironmentOptions.put_Language](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2environmentoptions?view=webview2-1.0.2210.55#put_language))
  final String? language;

  ///Specifies the version of the WebView2 Runtime binaries required to be compatible with your app.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Windows ([Official API - ICoreWebView2EnvironmentOptions.put_TargetCompatibleBrowserVersion](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2environmentoptions?view=webview2-1.0.2210.55#put_targetcompatiblebrowserversion))
  final String? targetCompatibleBrowserVersion;

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
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Windows ([Official API - CreateCoreWebView2EnvironmentWithOptions.userDataFolder](https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#createcorewebview2environmentwithoptions))
  final String? userDataFolder;

  ///Virtual host name to folder path mappings applied to the WebView.
  ///
  ///Each mapping serves the given local [VirtualHostMapping.folderPath] at
  ///`https://[VirtualHostMapping.hostName]/`, which bypasses CORS for local
  ///resources (use [HostResourceAccessKind.allowCors] to allow cross-origin
  ///access). Currently honored by the Windows implementation.
  final List<VirtualHostMapping>? virtualHostMappings;

  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Windows
  WebViewEnvironmentSettings({
    this.additionalBrowserArguments,
    this.allowSingleSignOnUsingOSPrimaryAccount,
    this.browserExecutableFolder,
    this.language,
    this.targetCompatibleBrowserVersion,
    this.userDataFolder,
    this.virtualHostMappings,
  });

  ///Gets a possible [WebViewEnvironmentSettings] instance from a [Map] value.
  static WebViewEnvironmentSettings? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WebViewEnvironmentSettings(
      additionalBrowserArguments: map['additionalBrowserArguments'],
      allowSingleSignOnUsingOSPrimaryAccount:
          map['allowSingleSignOnUsingOSPrimaryAccount'],
      browserExecutableFolder: map['browserExecutableFolder'],
      language: map['language'],
      targetCompatibleBrowserVersion: map['targetCompatibleBrowserVersion'],
      userDataFolder: map['userDataFolder'],
      virtualHostMappings: map['virtualHostMappings'] != null
          ? List<VirtualHostMapping>.from(
              map['virtualHostMappings'].map(
                (e) => VirtualHostMapping.fromMap(e?.cast<String, dynamic>())!,
              ),
            )
          : null,
    );
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "additionalBrowserArguments": additionalBrowserArguments,
      "allowSingleSignOnUsingOSPrimaryAccount":
          allowSingleSignOnUsingOSPrimaryAccount,
      "browserExecutableFolder": browserExecutableFolder,
      "language": language,
      "targetCompatibleBrowserVersion": targetCompatibleBrowserVersion,
      "userDataFolder": userDataFolder,
      "virtualHostMappings": virtualHostMappings
          ?.map((e) => e.toMap())
          .toList(),
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  ///Returns a copy of WebViewEnvironmentSettings.
  WebViewEnvironmentSettings copy() {
    return WebViewEnvironmentSettings.fromMap(toMap()) ??
        WebViewEnvironmentSettings();
  }

  @override
  String toString() {
    return 'WebViewEnvironmentSettings{additionalBrowserArguments: $additionalBrowserArguments, allowSingleSignOnUsingOSPrimaryAccount: $allowSingleSignOnUsingOSPrimaryAccount, browserExecutableFolder: $browserExecutableFolder, language: $language, targetCompatibleBrowserVersion: $targetCompatibleBrowserVersion, userDataFolder: $userDataFolder, virtualHostMappings: $virtualHostMappings}';
  }
}
