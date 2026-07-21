import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'in_app_webview_windows_controller.dart';

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
  void dispose() {}

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
      // Determine user data folder from WebViewEnvironmentSettings or use default
      String userDataPath;
      final settings = widget.params.webViewEnvironment?.settings;
      if (settings?.userDataFolder != null) {
        userDataPath = settings!.userDataFolder!;
      } else {
        userDataPath = await _getDefaultUserDataFolder();
      }

      // Initialize the shared WebView2 environment with the user data folder
      await WebviewController.initializeEnvironment(userDataPath: userDataPath);

      await _controller.initialize();

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
