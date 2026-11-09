// Encode direction: what the Dart side sends to native.
import 'dart:typed_data';
import 'dart:ui' show Color, Size;

import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart' as u;
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart' as z;

import 'support.dart';

/// Stand-in for a live message port: both packages encode ports through
/// `toMap()`, so a fixed map exercises the `WebMessage.ports` path.
class _UPort implements u.IWebMessagePort {
  @override
  dynamic noSuchMethod(Invocation i) => i.memberName == #toMap ? <String, dynamic>{'index': 1} : super.noSuchMethod(i);
}

class _ZPort implements z.IWebMessagePort {
  @override
  dynamic noSuchMethod(Invocation i) => i.memberName == #toMap ? <String, dynamic>{'index': 1} : super.noSuchMethod(i);
}

void main() {
  registerParityCheck();

  test('URLRequest', () {
    Object? up(u.URLRequestCachePolicy? c, u.URLRequestNetworkServiceType? n, u.URLRequestAttribution? a) => u.URLRequest(
          url: u.WebUri('https://a.b/p?q=1'),
          method: 'POST',
          headers: {'h': 'v'},
          body: Uint8List.fromList([1, 2]),
          allowsCellularAccess: false,
          allowsConstrainedNetworkAccess: false,
          allowsExpensiveNetworkAccess: false,
          cachePolicy: c,
          httpShouldHandleCookies: false,
          httpShouldUsePipelining: true,
          networkServiceType: n,
          timeoutInterval: 7.5,
          mainDocumentURL: u.WebUri('https://m.d/'),
          assumesHTTP3Capable: true,
          attribution: a,
        ).toMap();
    Object? zp(z.URLRequestCachePolicy? c, z.URLRequestNetworkServiceType? n, z.URLRequestAttribution? a) => z.URLRequest(
          url: z.WebUri('https://a.b/p?q=1'),
          method: 'POST',
          headers: {'h': 'v'},
          body: Uint8List.fromList([1, 2]),
          allowsCellularAccess: false,
          allowsConstrainedNetworkAccess: false,
          allowsExpensiveNetworkAccess: false,
          cachePolicy: c,
          httpShouldHandleCookies: false,
          httpShouldUsePipelining: true,
          networkServiceType: n,
          timeoutInterval: 7.5,
          mainDocumentURL: z.WebUri('https://m.d/'),
          attribution: a,
        ).toJson();
    enumVariants('URLRequest.cachePolicy', u.URLRequestCachePolicy.values, z.URLRequestCachePolicy.values,
        (e) => up(e, u.URLRequestNetworkServiceType.DEFAULT, u.URLRequestAttribution.DEVELOPER), (e) => zp(e, z.URLRequestNetworkServiceType.DEFAULT, z.URLRequestAttribution.DEVELOPER));
    enumVariants('URLRequest.networkServiceType', u.URLRequestNetworkServiceType.values, z.URLRequestNetworkServiceType.values,
        (e) => up(u.URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_CACHE_DATA, e, u.URLRequestAttribution.DEVELOPER), (e) => zp(z.URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_CACHE_DATA, e, z.URLRequestAttribution.DEVELOPER));
    enumVariants('URLRequest.attribution', u.URLRequestAttribution.values, z.URLRequestAttribution.values,
        (e) => up(u.URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_CACHE_DATA, u.URLRequestNetworkServiceType.DEFAULT, e), (e) => zp(z.URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_CACHE_DATA, z.URLRequestNetworkServiceType.DEFAULT, e));
  });

  test('ContentWorld', () {
    // Used for UserScript.contentWorld and the contentWorld argument of
    // evaluateJavascript / callAsyncJavaScript.
    expectSame('ContentWorld.PAGE', u.ContentWorld.PAGE.toMap(), z.ContentWorld.PAGE.toMap());
    expectSame('ContentWorld.DEFAULT_CLIENT', u.ContentWorld.DEFAULT_CLIENT.toMap(), z.ContentWorld.DEFAULT_CLIENT.toMap());
    expectSame('ContentWorld.world', u.ContentWorld.world(name: 'mine').toMap(), z.ContentWorld.world(name: 'mine').toMap());
  });

  test('UserScript', () {
    Object? up(u.UserScriptInjectionTime t, bool main, u.ContentWorld w) =>
        u.UserScript(source: 's', injectionTime: t, groupName: 'g', forMainFrameOnly: main, allowedOriginRules: {'https://a.b'}, contentWorld: w).toMap();
    Object? zp(z.UserScriptInjectionTime t, bool main, z.ContentWorld w) =>
        z.UserScript(source: 's', injectionTime: t, groupName: 'g', forMainFrameOnly: main, allowedOriginRules: {'https://a.b'}, contentWorld: w).toJson();
    enumVariants('UserScript.injectionTime', u.UserScriptInjectionTime.values, z.UserScriptInjectionTime.values,
        (e) => up(e, false, u.ContentWorld.world(name: 'mine')), (e) => zp(e, false, z.ContentWorld.world(name: 'mine')));
    // Without a contentWorld upstream still sends the page world;
    // userScriptToWire fills it in.
    expectSame(
      'UserScript.defaultWorld',
      u.UserScript(source: 's', injectionTime: u.UserScriptInjectionTime.AT_DOCUMENT_START).toMap(),
      z.UserScript(source: 's', injectionTime: z.UserScriptInjectionTime.AT_DOCUMENT_START).toJson(),
    );
    expectSame('UserScript', up(u.UserScriptInjectionTime.AT_DOCUMENT_END, true, u.ContentWorld.PAGE), zp(z.UserScriptInjectionTime.AT_DOCUMENT_END, true, z.ContentWorld.PAGE));
  });

  test('WebMessage', () {
    expectSame(
      'WebMessage.string',
      u.WebMessage(data: 'hello', type: u.WebMessageType.STRING, ports: [_UPort()]).toMap(),
      z.WebMessage(data: 'hello', type: z.WebMessageType.STRING, ports: [_ZPort()]).toJson(),
    );
    expectSame(
      'WebMessage.arrayBuffer',
      u.WebMessage(data: Uint8List.fromList([1, 2]), type: u.WebMessageType.ARRAY_BUFFER, ports: [_UPort()]).toMap(),
      z.WebMessage(data: Uint8List.fromList([1, 2]), type: z.WebMessageType.ARRAY_BUFFER, ports: [_ZPort()]).toJson(),
    );
  });

  test('InAppWebViewInitialData', () {
    expectSame(
      'InAppWebViewInitialData',
      u.InAppWebViewInitialData(data: '<b>x</b>', mimeType: 'text/plain', encoding: 'latin1', baseUrl: u.WebUri('https://b.c/'), historyUrl: u.WebUri('https://h.c/')).toMap(),
      z.InAppWebViewInitialData(data: '<b>x</b>', mimeType: 'text/plain', encoding: 'latin1', baseUrl: z.WebUri('https://b.c/'), historyUrl: z.WebUri('https://h.c/')).toJson(),
    );
  });

  test('JsAlertResponse', () {
    enumVariants('JsAlertResponse.action', u.JsAlertResponseAction.values, z.JsAlertResponseAction.values,
        (a) => u.JsAlertResponse(message: 'm', confirmButtonTitle: 'ok', handledByClient: true, action: a).toMap(),
        (a) => z.JsAlertResponse(message: 'm', confirmButtonTitle: 'ok', handledByClient: true, action: a).toJson());
  });

  test('JsConfirmResponse', () {
    enumVariants('JsConfirmResponse.action', u.JsConfirmResponseAction.values, z.JsConfirmResponseAction.values,
        (a) => u.JsConfirmResponse(message: 'm', confirmButtonTitle: 'ok', cancelButtonTitle: 'no', handledByClient: true, action: a).toMap(),
        (a) => z.JsConfirmResponse(message: 'm', confirmButtonTitle: 'ok', cancelButtonTitle: 'no', handledByClient: true, action: a).toJson());
  });

  test('JsPromptResponse', () {
    enumVariants('JsPromptResponse.action', u.JsPromptResponseAction.values, z.JsPromptResponseAction.values,
        (a) => u.JsPromptResponse(message: 'm', defaultValue: 'd', confirmButtonTitle: 'ok', cancelButtonTitle: 'no', handledByClient: true, value: 'v', action: a).toMap(),
        (a) => z.JsPromptResponse(message: 'm', defaultValue: 'd', confirmButtonTitle: 'ok', cancelButtonTitle: 'no', handledByClient: true, value: 'v', action: a).toJson());
  });

  test('JsBeforeUnloadResponse', () {
    enumVariants('JsBeforeUnloadResponse.action', u.JsBeforeUnloadResponseAction.values, z.JsBeforeUnloadResponseAction.values,
        (a) => u.JsBeforeUnloadResponse(message: 'm', confirmButtonTitle: 'ok', cancelButtonTitle: 'no', handledByClient: true, action: a).toMap(),
        (a) => z.JsBeforeUnloadResponse(message: 'm', confirmButtonTitle: 'ok', cancelButtonTitle: 'no', handledByClient: true, action: a).toJson());
  });

  test('PermissionResponse', () {
    enumVariants('PermissionResponse.action', u.PermissionResponseAction.values, z.PermissionResponseAction.values,
        (a) => u.PermissionResponse(resources: [u.PermissionResourceType.CAMERA, u.PermissionResourceType.MICROPHONE], action: a).toMap(),
        (a) => z.PermissionResponse(resources: [z.PermissionResourceType.CAMERA, z.PermissionResourceType.MICROPHONE], action: a).toJson());
    enumVariants('PermissionResponse.resource', u.PermissionResourceType.values, z.PermissionResourceType.values,
        (r) => u.PermissionResponse(resources: [r], action: u.PermissionResponseAction.GRANT).toMap(),
        (r) => z.PermissionResponse(resources: [r], action: z.PermissionResponseAction.GRANT).toJson());
  });

  test('HttpAuthResponse', () {
    enumVariants('HttpAuthResponse.action', u.HttpAuthResponseAction.values, z.HttpAuthResponseAction.values,
        (a) => u.HttpAuthResponse(username: 'u', password: 'p', permanentPersistence: true, action: a).toMap(),
        (a) => z.HttpAuthResponse(username: 'u', password: 'p', permanentPersistence: true, action: a).toJson());
  });

  test('ServerTrustAuthResponse', () {
    enumVariants('ServerTrustAuthResponse.action', u.ServerTrustAuthResponseAction.values, z.ServerTrustAuthResponseAction.values,
        (a) => u.ServerTrustAuthResponse(action: a).toMap(), (a) => z.ServerTrustAuthResponse(action: a).toJson());
  });

  test('ClientCertResponse', () {
    // zikzak has no selectedCertificate field; upstream's is set to 3.
    enumVariants('ClientCertResponse.action', u.ClientCertResponseAction.values, z.ClientCertResponseAction.values,
        (a) => u.ClientCertResponse(certificatePath: '/c.p12', certificatePassword: 'pw', keyStoreType: 'JKS', selectedCertificate: 3, action: a).toMap(),
        (a) => z.ClientCertResponse(certificatePath: '/c.p12', certificatePassword: 'pw', keyStoreType: 'JKS', action: a).toJson());
  });

  test('CustomSchemeResponse', () {
    expectSame(
      'CustomSchemeResponse',
      u.CustomSchemeResponse(data: Uint8List.fromList([1, 2, 3]), contentType: 'text/css', contentEncoding: 'latin1').toMap(),
      z.CustomSchemeResponse(data: Uint8List.fromList([1, 2, 3]), contentType: 'text/css', contentEncoding: 'latin1').toJson(),
    );
  });

  // ProxySettings is skipped: zikzak's ProxySettings is a different shape
  // (androidProxySettings / iOSProxySettings / profileId, no toJson), so there
  // is nothing to compare field by field. proxySettingsToWire maps it.

  test('ScreenshotConfiguration', () {
    enumVariants('ScreenshotConfiguration.compressFormat', u.CompressFormat.values, z.CompressFormat.values,
        (f) => u.ScreenshotConfiguration(rect: u.InAppWebViewRect(x: 1, y: 2, width: 3, height: 4), snapshotWidth: 50, compressFormat: f, quality: 80, afterScreenUpdates: false).toMap(),
        (f) => z.ScreenshotConfiguration(rect: z.InAppWebViewRect(x: 1, y: 2, width: 3, height: 4), snapshotWidth: 50, compressFormat: f, quality: 80, afterScreenUpdates: false).toJson());
  });

  test('PullToRefreshSettings', () {
    enumVariants('PullToRefreshSettings.size', u.PullToRefreshSize.values, z.PullToRefreshSize.values,
        (s) => u.PullToRefreshSettings(enabled: false, color: Color.fromRGBO(1, 2, 3, 1), backgroundColor: Color.fromRGBO(4, 5, 6, 1), distanceToTriggerSync: 10, slingshotDistance: 20, size: s, attributedTitle: u.AttributedString(string: 't')).toMap(),
        (s) => z.PullToRefreshSettings(enabled: false, color: Color.fromRGBO(1, 2, 3, 1), backgroundColor: Color.fromRGBO(4, 5, 6, 1), distanceToTriggerSync: 10, slingshotDistance: 20, size: s, attributedTitle: z.AttributedString(string: 't')).toJson());
  });

  test('AttributedString', () {
    // Used as PullToRefreshSettings.attributedTitle.
    final c = Color.fromRGBO(9, 8, 7, 1);
    enumVariants('AttributedString.underlineStyle', u.UnderlineStyle.values, z.UnderlineStyle.values,
        (s) => u.AttributedString(string: 't', backgroundColor: c, baselineOffset: 1.5, expansion: 2.5, foregroundColor: c, kern: 3.5, ligature: 2, obliqueness: 4.5, strikethroughColor: c, strikethroughStyle: u.UnderlineStyle.SINGLE, strokeColor: c, strokeWidth: 5.5, textEffect: u.AttributedStringTextEffectStyle.LETTERPRESS_STYLE, underlineColor: c, underlineStyle: s).toMap(),
        (s) => z.AttributedString(string: 't', backgroundColor: c, baselineOffset: 1.5, expansion: 2.5, foregroundColor: c, kern: 3.5, ligature: 2, obliqueness: 4.5, strikethroughColor: c, strikethroughStyle: z.UnderlineStyle.SINGLE, strokeColor: c, strokeWidth: 5.5, textEffect: z.AttributedStringTextEffectStyle.LETTERPRESS_STYLE, underlineColor: c, underlineStyle: s).toJson());
    enumVariants('AttributedString.textEffect', u.AttributedStringTextEffectStyle.values, z.AttributedStringTextEffectStyle.values,
        (s) => u.AttributedString(string: 't', textEffect: s).toMap(), (s) => z.AttributedString(string: 't', textEffect: s).toJson());
  });

  test('CSSLinkHtmlTagAttributes', () {
    Object? up(u.CrossOrigin c, u.ReferrerPolicy r) =>
        u.CSSLinkHtmlTagAttributes(id: 'i', media: 'print', crossOrigin: c, integrity: 'sha', referrerPolicy: r, disabled: true, alternate: true, title: 't').toMap();
    Object? zp(z.CrossOrigin c, z.ReferrerPolicy r) =>
        z.CSSLinkHtmlTagAttributes(id: 'i', media: 'print', crossOrigin: c, integrity: 'sha', referrerPolicy: r, disabled: true, alternate: true, title: 't').toJson();
    enumVariants('CSSLinkHtmlTagAttributes.crossOrigin', u.CrossOrigin.values, z.CrossOrigin.values,
        (e) => up(e, u.ReferrerPolicy.ORIGIN), (e) => zp(e, z.ReferrerPolicy.ORIGIN));
    enumVariants('CSSLinkHtmlTagAttributes.referrerPolicy', u.ReferrerPolicy.values, z.ReferrerPolicy.values,
        (e) => up(u.CrossOrigin.USE_CREDENTIALS, e), (e) => zp(z.CrossOrigin.USE_CREDENTIALS, e));
  });

  test('ScriptHtmlTagAttributes', () {
    Object? up(u.CrossOrigin c, u.ReferrerPolicy r) =>
        u.ScriptHtmlTagAttributes(type: 'module', id: 'i', async: true, defer: true, crossOrigin: c, integrity: 'sha', noModule: true, nonce: 'n', referrerPolicy: r).toMap();
    Object? zp(z.CrossOrigin c, z.ReferrerPolicy r) =>
        z.ScriptHtmlTagAttributes(type: 'module', id: 'i', async: true, defer: true, crossOrigin: c, integrity: 'sha', noModule: true, nonce: 'n', referrerPolicy: r).toJson();
    enumVariants('ScriptHtmlTagAttributes.crossOrigin', u.CrossOrigin.values, z.CrossOrigin.values,
        (e) => up(e, u.ReferrerPolicy.ORIGIN), (e) => zp(e, z.ReferrerPolicy.ORIGIN));
    enumVariants('ScriptHtmlTagAttributes.referrerPolicy', u.ReferrerPolicy.values, z.ReferrerPolicy.values,
        (e) => up(u.CrossOrigin.USE_CREDENTIALS, e), (e) => zp(z.CrossOrigin.USE_CREDENTIALS, e));
  });

  test('Size', () {
    // initialSize of the headless webview and the `size` argument of setSize.
    expectSame('Size', u.MapSize(const Size(12.5, 7.25)).toMap(), z.MapSize(const Size(12.5, 7.25)).toMap());
  });

  test('ContextMenu', () {
    expectSame(
      'ContextMenu',
      u.ContextMenu(
        menuItems: [u.ContextMenuItem(id: 7, title: 'one'), u.ContextMenuItem(id: 'two', title: 'two')],
        settings: u.ContextMenuSettings(hideDefaultSystemContextMenuItems: true),
      ).toMap(),
      z.ContextMenu(
        menuItems: [z.ContextMenuItem(id: 7, title: 'one'), z.ContextMenuItem(id: 'two', title: 'two')],
        settings: z.ContextMenuSettings(hideDefaultSystemContextMenuItems: true),
      ).toJson(),
    );
  });

  test('InAppBrowserClassSettings', () {
    // InAppBrowserClassSettings.toMap() is the browser settings merged with
    // InAppWebViewSettings.toMap() (the latter is covered by settings_test), so
    // only the keys of upstream's InAppBrowserSettings are compared here. The
    // set includes the keys read by linux/in_app_browser/in_app_browser_settings.cc;
    // windowType is iterated.
    final browserKeys = u.InAppBrowserSettings().toMap().keys.toSet();
    final c = Color.fromRGBO(1, 2, 3, 1);
    enumVariants('InAppBrowserSettings.windowType', u.WindowType.values, z.WindowType.values,
        (w) => u.InAppBrowserSettings(hidden: true, hideToolbarTop: true, toolbarTopBackgroundColor: c, hideUrlBar: true, hideProgressBar: true, hideDefaultMenuItems: true, toolbarTopFixedTitle: 'T', windowType: w, windowAlphaValue: 0.5, windowFrame: u.InAppWebViewRect(x: 1, y: 2, width: 3, height: 4)).toMap(),
        (w) => z.InAppBrowserClassSettings(browserSettings: z.InAppBrowserSettings(hidden: true, hideToolbarTop: true, toolbarTopBackgroundColor: c, hideUrlBar: true, hideProgressBar: true, hideDefaultMenuItems: true, toolbarTopFixedTitle: 'T', windowType: w, windowAlphaValue: 0.5, windowFrame: z.InAppWebViewRect(x: 1, y: 2, width: 3, height: 4))).toMap()..removeWhere((k, _) => !browserKeys.contains(k)));
  });

  test('WebViewEnvironmentSettings', () {
    expectSame(
      'WebViewEnvironmentSettings',
      u.WebViewEnvironmentSettings(
        browserExecutableFolder: '/b',
        userDataFolder: '/d',
        additionalBrowserArguments: '--x',
        allowSingleSignOnUsingOSPrimaryAccount: true,
        language: 'de',
        targetCompatibleBrowserVersion: '1.0',
        customSchemeRegistrations: [u.CustomSchemeRegistration(scheme: 's', allowedOrigins: ['o'], treatAsSecure: true)],
        exclusiveUserDataFolderAccess: true,
        isCustomCrashReportingEnabled: true,
        enableTrackingPrevention: true,
        areBrowserExtensionsEnabled: true,
        channelSearchKind: u.EnvironmentChannelSearchKind.LEAST_STABLE,
        releaseChannels: u.EnvironmentReleaseChannels.BETA,
        scrollbarStyle: u.EnvironmentScrollbarStyle.FLUENT_OVERLAY,
        cacheModel: u.CacheModel.DOCUMENT_BROWSER,
        spellCheckingEnabled: true,
        spellCheckingLanguages: ['en'],
        preferredLanguages: ['de'],
        automationAllowed: true,
        timeZoneOverride: 'UTC',
        webProcessExtensionsDirectory: '/w',
        sandboxPaths: ['/s'],
      ).toMap(),
      z.WebViewEnvironmentSettings(
        browserExecutableFolder: '/b',
        userDataFolder: '/d',
        additionalBrowserArguments: '--x',
        allowSingleSignOnUsingOSPrimaryAccount: true,
        language: 'de',
        targetCompatibleBrowserVersion: '1.0',
        virtualHostMappings: [z.VirtualHostMapping(hostName: 'h', folderPath: '/f', accessKind: z.HostResourceAccessKind.allowCors)],
      ).toJson(),
    );
    // CacheModel has no zikzak counterpart (see the knownDifferences entry).
  });

  // Skipped, with the reason for each:
  // - WebMessageListener.toMap(): implemented by the platform class in the
  //   Linux package (lib/src/web_message/web_message_listener.dart); both
  //   interface packages only declare it as UnimplementedError, so there is no
  //   interface encoding to compare.
  // - pullToRefreshController.options.toMap(): upstream's deprecated
  //   PullToRefreshOptions; zikzak has no such type (PullToRefreshSettings is
  //   covered above).
  // - initialUserScripts: a list of UserScript.toMap(), covered by 'UserScript'.
  // - JavaScriptHandler args: plain JSON values, no model class on either side.
  // - ProxySettings: see the note above.
}
