import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'in_app_webview_windows_controller.dart';

class _VirtualHostMappingInfo {
  final String folderPath;
  final int accessKind;

  _VirtualHostMappingInfo({required this.folderPath, required this.accessKind});
}

class InAppWebViewWindowsPlatform extends PlatformInAppWebViewController {
  InAppWebViewWindowsPlatform(
    PlatformInAppWebViewControllerCreationParams params,
  ) : super.implementation(params);

  // TODO: Implement platform controller logic for Windows
}

class InAppWebViewWindowsWidget extends PlatformInAppWebViewWidget {
  InAppWebViewWindowsWidget(PlatformInAppWebViewWidgetCreationParams params)
    : super.implementation(params);

  @override
  Widget build(BuildContext context) {
    return _InAppWebViewWindowsWidgetState(params);
  }

  @override
  void dispose({bool isKeepAlive = false}) {}

  @override
  T controllerFromPlatform<T>(dynamic platformController) {
    return platformController as T;
  }
}

class _InAppWebViewWindowsWidgetState extends StatefulWidget {
  final PlatformInAppWebViewWidgetCreationParams params;

  _InAppWebViewWindowsWidgetState(this.params);

  @override
  State<_InAppWebViewWindowsWidgetState> createState() =>
      _InAppWebViewWindowsWidgetStateImpl();
}

class _InAppWebViewWindowsWidgetStateImpl
    extends State<_InAppWebViewWindowsWidgetState> {
  final _controller = WebviewController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<String> _getDefaultUserDataFolder() async {
    final directory = await getApplicationSupportDirectory();
    final path = '${directory.path}/zikzak_webview2_data';
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    // Verify writability
    final testFile = File('$path/.write_test');
    try {
      await testFile.writeAsString('test');
      try {
        await testFile.delete();
      } catch (_) {
        // Ignore deletion errors (e.g., temporary file locks from AV)
      }
      return path;
    } catch (e) {
      throw StateError('WebView2 user data folder is not writable: $path');
    }
  }

  Future<void> initPlatformState() async {
    try {
      // Resolve the WebView2 environment arguments from the user-supplied
      // [WebViewEnvironmentSettings] (or platform defaults). Previously only
      // `userDataFolder` was honored, which silently dropped
      // `additionalBrowserArguments` — so Chromium flags such as
      // `--disable-web-security` never reached WebView2 (issue #178).
      final settings = widget.params.webViewEnvironment?.settings;
      final defaultUserDataFolder = await _getDefaultUserDataFolder();
      final args = resolveEnvironmentInitArgs(
        settings: settings,
        defaultUserDataFolder: () => defaultUserDataFolder,
      );

      // Initialize the shared WebView2 environment with the resolved args.
      await WebviewController.initializeEnvironment(
        userDataPath: args.userDataPath,
        browserExePath: args.browserExePath,
        additionalArguments: args.additionalArguments,
      );

      await _controller.initialize();

      // Apply virtual host mappings from the environment settings. Each
      // mapping serves a local folder at https://<hostName>/ and bypasses
      // CORS for those resources when the access kind is allowCors.
      final virtualHostMappings =
          widget.params.webViewEnvironment?.settings?.virtualHostMappings;
      if (virtualHostMappings != null) {
        final registeredMappings = <String, _VirtualHostMappingInfo>{};
        for (final mapping in virtualHostMappings) {
          final canonicalHostName = mapping.hostName.toLowerCase();
          if (registeredMappings.containsKey(canonicalHostName)) {
            final existing = registeredMappings[canonicalHostName]!;
            if (existing.folderPath != mapping.folderPath ||
                existing.accessKind != mapping.accessKind.toNativeValue()) {
              print(
                'Warning: Skipping duplicate virtual host mapping for "$canonicalHostName" '
                'with conflicting folderPath or accessKind. '
                'Existing: folderPath="${existing.folderPath}", accessKind=${existing.accessKind}. '
                'Conflicting: folderPath="${mapping.folderPath}", accessKind=${mapping.accessKind.toNativeValue()}.',
              );
              continue;
            }
            // Compatible duplicate (same folderPath and accessKind), skip silently
            continue;
          }
          await _controller.addVirtualHostNameMapping(
            mapping.hostName,
            mapping.folderPath,
            WebviewHostResourceAccessKind.values[mapping.accessKind
                .toNativeValue()],
          );
          registeredMappings[canonicalHostName] = _VirtualHostMappingInfo(
            folderPath: mapping.folderPath,
            accessKind: mapping.accessKind.toNativeValue(),
          );
        }
      }

      // Setup listeners
      _controller.url.listen((url) {
        // TODO: handle url change
      });

      _controller.loadingState.listen((state) {
        if (state == LoadingState.navigationCompleted) {
          // TODO: handle load stop
        } else if (state == LoadingState.loading) {
          // TODO: handle load start
        }
      });

      if (!mounted) return;
      setState(() {
        _isInitialized = true;
      });

      // Load initial URL
      if (widget.params.initialUrlRequest != null) {
        await _controller.loadUrl(
          widget.params.initialUrlRequest!.url.toString(),
        );
      }

      // Create controller
      final controllerParams = PlatformInAppWebViewControllerCreationParams(
        id: widget.params.windowId,
        webviewParams: widget.params,
      );

      final controller = InAppWebViewWindowsController(
        controllerParams,
        _controller,
      );

      if (widget.params.onWebViewCreated != null) {
        widget.params.onWebViewCreated!(
          widget.params.controllerFromPlatform!(controller),
        );
      }
    } catch (e) {
      print("Failed to initialize webview: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? Webview(_controller)
        : const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Arguments forwarded to [WebviewController.initializeEnvironment] when
/// bringing up the shared WebView2 environment.
///
/// Exposed as a typed record so the mapping from
/// [WebViewEnvironmentSettings] to the underlying `webview_windows` API
/// can be unit-tested without a live WebView2 runtime.
class WebViewEnvironmentInitArgs {
  const WebViewEnvironmentInitArgs({
    required this.userDataPath,
    this.browserExePath,
    this.additionalArguments,
  });

  /// User-data folder to use for the WebView2 runtime. Always non-null —
  /// falls back to the platform default when the caller did not supply one.
  final String userDataPath;

  /// Path to a fixed-version WebView2 runtime, or `null` to use the
  /// installed runtime.
  final String? browserExePath;

  /// Raw Chromium command-line switches forwarded to WebView2's
  /// `ICoreWebView2EnvironmentOptions::put_AdditionalBrowserArguments`.
  ///
  /// Example: `"--disable-web-security --allow-running-insecure-content"`.
  final String? additionalArguments;
}

/// Maps a [WebViewEnvironmentSettings] into the parameters accepted by
/// [WebviewController.initializeEnvironment].
///
/// This is the single source of truth for which Windows-only settings are
/// forwarded to the WebView2 runtime. Before this helper existed, only
/// [WebViewEnvironmentSettings.userDataFolder] was honored, silently
/// dropping `additionalBrowserArguments` — so Chromium flags such as
/// `--disable-web-security` never reached WebView2 and local CORS could
/// not be disabled (issue #178).
///
/// Pure and synchronous so it can be unit-tested without a live WebView2
/// runtime; the caller supplies the default user-data folder via
/// [defaultUserDataFolder] (which is only invoked when [settings] is `null`
/// or does not specify `userDataFolder`).
WebViewEnvironmentInitArgs resolveEnvironmentInitArgs({
  required WebViewEnvironmentSettings? settings,
  required String Function() defaultUserDataFolder,
}) {
  if (settings == null) {
    return WebViewEnvironmentInitArgs(userDataPath: defaultUserDataFolder());
  }
  return WebViewEnvironmentInitArgs(
    userDataPath: settings.userDataFolder ?? defaultUserDataFolder(),
    browserExePath: settings.browserExecutableFolder,
    additionalArguments: settings.additionalBrowserArguments,
  );
}
