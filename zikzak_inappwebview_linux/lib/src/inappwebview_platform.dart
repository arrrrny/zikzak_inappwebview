import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'cookie_manager/cookie_manager.dart';
import 'find_interaction/find_interaction_controller.dart';
import 'http_auth_credentials_database.dart';
import 'in_app_browser/in_app_browser.dart';
import 'in_app_webview/in_app_webview.dart';
import 'in_app_webview/in_app_webview_controller.dart';
import 'in_app_webview/headless_in_app_webview.dart';
import 'proxy_controller/proxy_controller.dart';
import 'web_message/web_message_channel.dart';
import 'web_message/web_message_listener.dart';
import 'web_message/web_message_port.dart';
import 'web_storage/web_storage.dart';
import 'web_storage/web_storage_manager.dart';

/// Implementation of [InAppWebViewPlatform] using WPE WebKit.
class LinuxInAppWebViewPlatform extends InAppWebViewPlatform {
  /// Registers this class as the default instance of [InAppWebViewPlatform].
  static void registerWith() {
    InAppWebViewPlatform.instance = LinuxInAppWebViewPlatform();
  }

  /// Creates a new [LinuxInAppWebViewController].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [InAppWebViewController] in `zikzak_inappwebview` instead.
  @override
  LinuxInAppWebViewController createPlatformInAppWebViewController(
    PlatformInAppWebViewControllerCreationParams params,
  ) {
    return LinuxInAppWebViewController(params);
  }

  /// Creates a new empty [LinuxInAppWebViewController] to access static methods.
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [InAppWebViewController] in `zikzak_inappwebview` instead.
  @override
  LinuxInAppWebViewController createPlatformInAppWebViewControllerStatic() {
    return LinuxInAppWebViewController.static();
  }

  /// Creates a new [LinuxInAppWebViewWidget].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [InAppWebView] in `zikzak_inappwebview` instead.
  @override
  LinuxInAppWebViewWidget createPlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams params,
  ) {
    return LinuxInAppWebViewWidget(params);
  }

  /// Creates a new [LinuxCookieManager].
  @override
  LinuxCookieManager createPlatformCookieManager(
    PlatformCookieManagerCreationParams params,
  ) {
    return LinuxCookieManager(params);
  }

  // ************************************************************************ //
  // Create static instances of unsupported classes to be able to call        //
  // isClassSupported, isMethodSupported, isPropertySupported, etc.           //
  // static methods without throwing a missing platform implementation        //
  // exception.                                                               //
  // ************************************************************************ //

  /// Creates a new empty [PlatformChromeSafariBrowser] to access static methods.
  @override
  PlatformChromeSafariBrowser createPlatformChromeSafariBrowserStatic() {
    return _PlatformChromeSafariBrowser.static();
  }

  /// Creates a new [LinuxHttpAuthCredentialDatabase].
  @override
  LinuxHttpAuthCredentialDatabase createPlatformHttpAuthCredentialDatabase(
    PlatformHttpAuthCredentialDatabaseCreationParams params,
  ) {
    return LinuxHttpAuthCredentialDatabase(params);
  }

  /// Creates a new empty [LinuxInAppBrowser] to access static methods.
  @override
  LinuxInAppBrowser createPlatformInAppBrowserStatic() {
    return LinuxInAppBrowser.static();
  }

  /// Creates a new [LinuxInAppBrowser].
  @override
  LinuxInAppBrowser createPlatformInAppBrowser(
    PlatformInAppBrowserCreationParams params,
  ) {
    return LinuxInAppBrowser(params);
  }

  /// Creates a new [LinuxHeadlessInAppWebView].
  @override
  LinuxHeadlessInAppWebView createPlatformHeadlessInAppWebView(
    PlatformHeadlessInAppWebViewCreationParams params,
  ) {
    return LinuxHeadlessInAppWebView(params);
  }

  /// Creates a new [LinuxProxyController].
  @override
  LinuxProxyController createPlatformProxyController(
    PlatformProxyControllerCreationParams params,
  ) {
    return LinuxProxyController(params);
  }

  /// Creates a new empty [PlatformServiceWorkerController] to access static methods.
  @override
  PlatformServiceWorkerController
  createPlatformServiceWorkerControllerStatic() {
    return _PlatformServiceWorkerController.static();
  }

  /// Creates a new [LinuxFindInteractionController].
  @override
  LinuxFindInteractionController createPlatformFindInteractionController(
    PlatformFindInteractionControllerCreationParams params,
  ) {
    return LinuxFindInteractionController(params);
  }

  /// Creates a new empty [PlatformWebAuthenticationSession] to access static methods.
  @override
  PlatformWebAuthenticationSession
  createPlatformWebAuthenticationSessionStatic() {
    return _PlatformWebAuthenticationSession.static();
  }

  /// Creates a new empty [LinuxWebMessageChannel] to access static methods.
  @override
  LinuxWebMessageChannel createPlatformWebMessageChannelStatic() {
    return LinuxWebMessageChannel.static();
  }

  /// Creates a new [LinuxWebMessageChannel].
  @override
  LinuxWebMessageChannel createPlatformWebMessageChannel(
    PlatformWebMessageChannelCreationParams params,
  ) {
    return LinuxWebMessageChannel(params);
  }

  /// Creates a new [LinuxWebMessagePort].
  @override
  LinuxWebMessagePort createPlatformWebMessagePort(
    PlatformWebMessagePortCreationParams params,
  ) {
    return LinuxWebMessagePort(params);
  }

  /// Creates a new [LinuxWebMessageListener].
  @override
  LinuxWebMessageListener createPlatformWebMessageListener(
    PlatformWebMessageListenerCreationParams params,
  ) {
    return LinuxWebMessageListener(params);
  }

  /// Creates a new [LinuxWebStorage].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [WebStorage] in `zikzak_inappwebview` instead.
  @override
  LinuxWebStorage createPlatformWebStorage(
    PlatformWebStorageCreationParams params,
  ) {
    return LinuxWebStorage(params);
  }

  /// Creates a new [LinuxLocalStorage].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [LocalStorage] in `zikzak_inappwebview` instead.
  @override
  LinuxLocalStorage createPlatformLocalStorage(
    PlatformLocalStorageCreationParams params,
  ) {
    return LinuxLocalStorage(params);
  }

  /// Creates a new [LinuxSessionStorage].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [SessionStorage] in `zikzak_inappwebview` instead.
  @override
  LinuxSessionStorage createPlatformSessionStorage(
    PlatformSessionStorageCreationParams params,
  ) {
    return LinuxSessionStorage(params);
  }

  /// Creates a new [LinuxWebStorageManager].
  @override
  LinuxWebStorageManager createPlatformWebStorageManager(
    PlatformWebStorageManagerCreationParams params,
  ) {
    return LinuxWebStorageManager(params);
  }

  /// Creates a new [DefaultInAppLocalhostServer].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [InAppLocalhostServer] in `zikzak_inappwebview` instead.
  @override
  DefaultInAppLocalhostServer createPlatformInAppLocalhostServer(
    PlatformInAppLocalhostServerCreationParams params,
  ) {
    return DefaultInAppLocalhostServer(params);
  }

  /// Creates a new empty [PlatformWebViewFeature] to access static methods.
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [WebViewFeature] in `zikzak_inappwebview` instead
  @override
  PlatformWebViewFeature createPlatformWebViewFeatureStatic() {
    return _PlatformWebViewFeature.static();
  }
}

// Stub implementations for unsupported classes

class _PlatformChromeSafariBrowser extends PlatformChromeSafariBrowser {
  _PlatformChromeSafariBrowser(super.params)
    : super.implementation();
  static final _PlatformChromeSafariBrowser _staticValue =
      _PlatformChromeSafariBrowser(
        const PlatformChromeSafariBrowserCreationParams(),
      );

  factory _PlatformChromeSafariBrowser.static() => _staticValue;
}

class _PlatformServiceWorkerController extends PlatformServiceWorkerController {
  _PlatformServiceWorkerController(
    super.params,
  ) : super.implementation();
  static final _PlatformServiceWorkerController _staticValue =
      _PlatformServiceWorkerController(
        const PlatformServiceWorkerControllerCreationParams(),
      );

  factory _PlatformServiceWorkerController.static() => _staticValue;

  // Static-only stub: holds no resources.
  @override
  void dispose({bool isKeepAlive = false}) {}

  @override
  ServiceWorkerClient? get serviceWorkerClient => throw UnimplementedError();
}

class _PlatformWebAuthenticationSession
    extends PlatformWebAuthenticationSession {
  _PlatformWebAuthenticationSession(
    super.params,
  ) : super.implementation();

  static final _PlatformWebAuthenticationSession _staticValue =
      _PlatformWebAuthenticationSession(
        const PlatformWebAuthenticationSessionCreationParams(),
      );

  factory _PlatformWebAuthenticationSession.static() => _staticValue;
}

class _PlatformWebViewFeature extends PlatformWebViewFeature {
  _PlatformWebViewFeature(super.params)
    : super.implementation();

  static final _PlatformWebViewFeature _staticValue = _PlatformWebViewFeature(
    PlatformWebViewFeatureCreationParams(),
  );
  factory _PlatformWebViewFeature.static() => _staticValue;

  // Static-only stub: holds no resources.
  @override
  void dispose({bool isKeepAlive = false}) {}
}

