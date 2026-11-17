import 'dart:async';

import 'package:material_ui/material_ui.dart';

import 'package:zikzak_webview_windows/zikzak_webview_windows.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'in_app_webview_windows_controller.dart';
import 'webview_environment.dart' show WindowsWebViewEnvironment;

class _VirtualHostMappingInfo {
  final String folderPath;
  final int accessKind;

  _VirtualHostMappingInfo({required this.folderPath, required this.accessKind});
}

/// Maps a [LoadingState] change onto the platform-agnostic load callbacks.
///
/// `loading` maps to `onLoadStart` + progress `0`, `navigationCompleted`
/// maps to `onLoadStop` + progress `100` (webview_windows exposes no
/// granular progress), and `none` produces no callbacks. Redirects produce
/// multiple start/stop cycles — one per top-level navigation.
///
/// [controller] is deliberately typed as [Object] rather than
/// [PlatformInAppWebViewController]. The value forwarded to the callbacks
/// is whatever `params.controllerFromPlatform` returned, and in the federated
/// plugin that is the app-facing `InAppWebViewController` from
/// `zikzak_inappwebview`, which *wraps* a [PlatformInAppWebViewController]
/// rather than implementing one. Declaring the parameter as
/// [PlatformInAppWebViewController] therefore inserts an implicit downcast at
/// the call site. That downcast runs inside a `Stream.listen` callback, so the
/// `TypeError` escapes as an unhandled zone error and every load event is
/// silently dropped: the webview renders normally while the host waits forever
/// for an `onLoadStop` that never arrives. The `params` callbacks are typed
/// `void Function(T, ...)` with `T = dynamic`, so passing the wrapper through
/// this parameter is the contract, not a hole in it.
@visibleForTesting
void dispatchLoadingStateChange({
  required LoadingState state,
  required String? url,
  required Object controller,
  required PlatformInAppWebViewWidgetCreationParams params,
}) {
  final uri = url == null ? null : WebUri(url);
  switch (state) {
    case LoadingState.loading:
      params.onProgressChanged?.call(controller, 0);
      params.onLoadStart?.call(controller, uri);
      break;
    case LoadingState.navigationCompleted:
      params.onProgressChanged?.call(controller, 100);
      params.onLoadStop?.call(controller, uri);
      break;
    case LoadingState.none:
      break;
  }
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

  /// Teardown is owned by the `State`, not by this object: the platform
  /// controller is created asynchronously in `initPlatformState`, and the
  /// state's own `dispose()` forwards disposal to it on unmount.
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

  /// The platform controller created by [initPlatformState], held so this
  /// state's `dispose()` can forward teardown to it.
  ///
  /// [InAppWebViewWindowsController] owns the `url` / `loadingState` /
  /// `historyChanged` subscriptions, and the raw [WebviewController] they sit
  /// on never closes its stream controllers. Without this call those listeners
  /// outlive an unmounted `InAppWebView` and keep the graph alive. Mirrors
  /// `MacOSInAppWebViewWidget`, which disposes its controller the same way.
  InAppWebViewWindowsController? _platformController;

  /// Native-event subscriptions. `WebviewController.dispose()` never closes
  /// its stream controllers, so these must be cancelled explicitly —
  /// otherwise in-flight events can invoke callbacks after this `State` is
  /// unmounted.
  StreamSubscription<LoadingState>? _loadingStateSubscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      // Resolve the WebView2 environment arguments from the user-supplied
      // [WebViewEnvironmentSettings] (or platform defaults). Previously only
      // `userDataFolder` was honored, which silently dropped
      // `additionalBrowserArguments` — so Chromium flags such as
      // `--disable-web-security` never reached WebView2 (issue #178).
      final settings = widget.params.webViewEnvironment?.settings;
      await WindowsWebViewEnvironment.initializeShared(settings: settings);

      await _controller.initialize();

      final controllerParams = PlatformInAppWebViewControllerCreationParams(
        id: widget.params.windowId,
        webviewParams: widget.params,
      );
      final controller = InAppWebViewWindowsController(
        controllerParams,
        _controller,
      );
      if (!mounted) {
        // The state was torn down while the environment was coming up, so
        // nothing will ever call dispose() on this controller.
        controller.dispose();
        return;
      }
      _platformController = controller;
      // The controller resolves its own app-facing wrapper from
      // `controllerFromPlatform` on first access, so there is no
      // post-construction field to assign.
      final callbackController = controller.callbackController;

      // Publish the controller BEFORE any listener or load can deliver load
      // events: onWebViewCreated must precede onLoadStart/onLoadStop, the
      // same contract every other platform implementation follows.
      if (widget.params.onWebViewCreated != null) {
        widget.params.onWebViewCreated!(callbackController);
      }

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
                existing.accessKind != mapping.accessKind.index) {
              print(
                'Warning: Skipping duplicate virtual host mapping for "$canonicalHostName" '
                'with conflicting folderPath or accessKind. '
                'Existing: folderPath="${existing.folderPath}", accessKind=${existing.accessKind}. '
                'Conflicting: folderPath="${mapping.folderPath}", accessKind=${mapping.accessKind.index}.',
              );
              continue;
            }
            // Compatible duplicate (same folderPath and accessKind), skip silently
            continue;
          }
          await _controller.addVirtualHostNameMapping(
            mapping.hostName,
            mapping.folderPath,
            WebviewHostResourceAccessKind.values[mapping.accessKind.index],
          );
          registeredMappings[canonicalHostName] = _VirtualHostMappingInfo(
            folderPath: mapping.folderPath,
            accessKind: mapping.accessKind.index,
          );
        }
      }

      // Setup listeners
      //
      // NOTE: `urlChanged` and `loadingStateChanged` arrive on two
      // independent stream controllers fed by the same native event channel,
      // so the relative ordering is not guaranteed: the URL passed to
      // onLoadStart/onLoadStop is best-effort and may be null or stale when
      // the loadingState event lands before the matching urlChanged event
      // (webview_windows 0.4.0 has no synchronous url getter).
      //
      // The URL comes from the controller's own cache rather than a second
      // subscription here: `WebviewController.url` is single-subscription, and
      // sharing one cache is what keeps this value and `getUrl()` from drifting
      // apart.
      _loadingStateSubscription = _controller.loadingState.listen((state) {
        if (!mounted) return;
        dispatchLoadingStateChange(
          state: state,
          url: controller.currentUrl,
          controller: callbackController,
          params: widget.params,
        );
      });

      if (!mounted) return;
      setState(() {
        _isInitialized = true;
      });

      // Load initial URL
      if (widget.params.initialUrlRequest != null) {
        await controller.loadUrl(urlRequest: widget.params.initialUrlRequest!);
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
    _loadingStateSubscription?.cancel();
    // Cancels the url / loadingState / historyChanged subscriptions too, and
    // disposes the underlying WebviewController when it is initialized.
    _platformController?.dispose();
    _platformController = null;
    super.dispose();
  }
}
