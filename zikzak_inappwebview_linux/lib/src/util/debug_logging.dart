import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// Argument key that tells the native side whether to print its info logs.
///
/// Sent with every call that creates something native (webview widget,
/// headless webview, InAppBrowser) and read by `linux/utils/log.h`. Errors are
/// always logged natively; only info logs follow this flag.
const String debugLoggingEnabledArg = 'debugLoggingEnabled';

/// Native info logging follows the webview controller's debug logging
/// settings, the same switch that controls this package's Dart-side tracing.
bool get nativeDebugLoggingEnabled =>
    PlatformInAppWebViewController.debugLoggingSettings.enabled;
