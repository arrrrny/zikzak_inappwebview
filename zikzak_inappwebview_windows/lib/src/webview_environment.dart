import 'dart:io';
import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_webview_windows/zikzak_webview_windows.dart';

/// The companion plugin owns one native environment per process. Cookie
/// operations and visible webviews await the same initialization Future.
/// Creating another wrapper cannot create an independent native profile.
class WindowsWebViewEnvironment extends PlatformWebViewEnvironment {
  WindowsWebViewEnvironment(super.params) : super.implementation();

  static FutureOr<_EnvironmentOptions>? _initialization;
  static FutureOr<WebviewController>? _cookieController;

  @override
  String get id => 'webview2-$pid';

  @override
  Future<WindowsWebViewEnvironment> create({
    WebViewEnvironmentSettings? settings,
  }) async {
    final requested = settings ?? this.settings;
    final environment = WindowsWebViewEnvironment(
      PlatformWebViewEnvironmentCreationParams(settings: requested),
    );
    await initializeShared(settings: requested);
    return environment;
  }

  static Future<_EnvironmentOptions> _initialize(
    WebViewEnvironmentSettings? settings,
  ) async {
    try {
      final folder =
          settings?.userDataFolder ??
          p.join(
            (await getApplicationSupportDirectory()).path,
            'zikzak_webview2_data',
          );
      await Directory(folder).create(recursive: true);
      final args = _EnvironmentOptions(
        userDataPath: folder,
        browserExePath: settings?.browserExecutableFolder,
        additionalArguments: settings?.additionalBrowserArguments,
      );
      await WebviewController.initializeEnvironment(
        userDataPath: args.userDataPath,
        browserExePath: args.browserExePath,
        additionalArguments: args.additionalArguments,
      );
      _initialization = args;
      return args;
    } catch (_) {
      _initialization = null;
      rethrow;
    }
  }

  /// Null options reuse the current process profile. Explicit conflicting
  /// options fail instead of silently using another profile or proxy.
  ///
  /// The message names both the option that was requested and the one already
  /// in use, because the throw happens at a call site that has nothing to do
  /// with the option that caused it: a cookie operation without an explicit
  /// environment claims the DEFAULT profile, and a later `create` or webview
  /// passing its own `userDataFolder` or `additionalBrowserArguments` (the
  /// `--disable-web-security` case) is where that surfaces.
  static Future<void> initializeShared({
    WebViewEnvironmentSettings? settings,
  }) async {
    final pending = _initialization ??= _initialize(settings);
    final args = pending is _EnvironmentOptions ? pending : await pending;
    if (settings == null) return;
    final conflicts = <String>[
      if (settings.userDataFolder != null &&
          !_samePath(settings.userDataFolder, args.userDataPath))
        'userDataFolder "${settings.userDataFolder}"',
      if (settings.browserExecutableFolder != null &&
          !_samePath(settings.browserExecutableFolder, args.browserExePath))
        'browserExecutableFolder "${settings.browserExecutableFolder}"',
      if (settings.additionalBrowserArguments != null &&
          settings.additionalBrowserArguments != args.additionalArguments)
        'additionalBrowserArguments "${settings.additionalBrowserArguments}"',
    ];
    if (conflicts.isEmpty) return;
    throw StateError(
      'WebView2 already uses a different process-wide environment '
      '(userDataFolder "${args.userDataPath}"'
      '${args.browserExePath == null ? '' : ', browserExecutableFolder "${args.browserExePath}"'}'
      '${args.additionalArguments == null ? '' : ', additionalBrowserArguments "${args.additionalArguments}"'})'
      ': the requested ${conflicts.join(' and ')} '
      '${conflicts.length == 1 ? 'conflicts' : 'conflict'} with it. '
      'Create the desired environment before any webview or cookie operation; '
      'a cookie operation without an explicit webViewEnvironment claims the '
      'default profile.',
    );
  }

  /// Path comparison that tolerates a null on either side and a trailing
  /// separator, the two ways the same folder can be spelled differently by the
  /// caller and by [getApplicationSupportDirectory].
  static bool _samePath(String? requested, String? inUse) =>
      requested == null || inUse == null
      ? requested == inUse
      : p.equals(requested, inUse);

  /// A non-navigating controller provides CDP access before a visible webview
  /// exists. It shares the process profile and is released by [dispose].
  static Future<WebviewController> cookieController({
    WebViewEnvironmentSettings? settings,
  }) async {
    await initializeShared(settings: settings);
    return _cookieController ??= _createCookieController();
  }

  static Future<WebviewController> _createCookieController() async {
    final controller = WebviewController();
    try {
      await controller.initialize();
      _cookieController = controller;
      return controller;
    } catch (_) {
      _cookieController = null;
      if (controller.value.isInitialized) await controller.dispose();
      rethrow;
    }
  }

  @override
  Future<String?> getAvailableVersion({String? browserExecutableFolder}) {
    if (browserExecutableFolder != null) {
      throw UnsupportedError(
        'Querying a fixed WebView2 runtime is not supported',
      );
    }
    return WebviewController.getWebViewVersion();
  }

  @override
  Future<void> dispose({bool isKeepAlive = false}) async {
    if (isKeepAlive) return;
    final controller = _cookieController;
    _cookieController = null;
    if (controller != null) await (await controller).dispose();
    // The companion's native environment remains alive for the process.
  }
}

class _EnvironmentOptions {
  const _EnvironmentOptions({
    required this.userDataPath,
    this.browserExePath,
    this.additionalArguments,
  });

  final String userDataPath;
  final String? browserExePath;
  final String? additionalArguments;
}
