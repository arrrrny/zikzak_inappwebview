// Decode direction: what native sends to Dart. Each test builds a fully
// populated UPSTREAM object, takes its toMap() (the shape upstream's native
// code emits), runs it through zikzak's decoder and compares zikzak's
// re-encoding with the original map. See `decode` in support.dart.
import 'dart:typed_data';

import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart' as u;
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart' as z;

import 'settings_enums.dart';
import 'support.dart';

u.URLRequest _ureq() => u.URLRequest(url: u.WebUri('https://a.b/p?q=1'), method: 'POST', headers: {'h': 'v'}, body: Uint8List.fromList([1, 2]));

u.FrameInfo _uframe() => u.FrameInfo(
      isMainFrame: false,
      request: _ureq(),
      securityOrigin: u.SecurityOrigin(host: 'a.b', port: 443, protocol: 'https'),
      name: 'frame',
      frameId: 3,
      kind: u.FrameKind.values.last,
    );

u.SslCertificate _ucert() => u.SslCertificate(
      issuedBy: u.SslCertificateDName(CName: 'c1', DName: 'd1', OName: 'o1', UName: 'u1'),
      issuedTo: u.SslCertificateDName(CName: 'c2', DName: 'd2', OName: 'o2', UName: 'u2'),
      validNotAfterDate: DateTime.utc(2030, 1, 2, 3, 4, 5),
      validNotBeforeDate: DateTime.utc(2020, 1, 2, 3, 4, 5),
    );

u.URLProtectionSpace _uspace({u.URLProtectionSpaceAuthenticationMethod? method, u.URLProtectionSpaceProxyType? proxy}) => u.URLProtectionSpace(
      host: 'a.b',
      protocol: 'https',
      realm: 'r',
      port: 443,
      // Native always sends sslCertificate null (url_protection_space.cc:52);
      // SslCertificate has its own test.
      sslError: u.SslError(code: u.SslErrorType.values.last, message: 'bad'),
      authenticationMethod: method ?? u.URLProtectionSpaceAuthenticationMethod.values.last,
      receivesCredentialSecurely: true,
      proxyType: proxy ?? u.URLProtectionSpaceProxyType.values.last,
    );

u.URLResponse _uresp() => u.URLResponse(url: u.WebUri('https://a.b/'), expectedContentLength: 12, mimeType: 'text/html', suggestedFilename: 'f.html', textEncodingName: 'utf-8', headers: {'h': 'v'}, statusCode: 200);

class _UPort implements u.IWebMessagePort {
  @override
  dynamic noSuchMethod(Invocation i) => i.memberName == #toMap ? <String, dynamic>{'index': 1} : super.noSuchMethod(i);
}

void main() {
  registerParityCheck();

  test('NavigationAction', () {
    u.NavigationAction mk(u.NavigationType t) => u.NavigationAction(
          request: _ureq(),
          isForMainFrame: true,
          hasGesture: true,
          isRedirect: true,
          navigationType: t,
          sourceFrame: _uframe(),
          targetFrame: _uframe(),
          shouldPerformDownload: true,
        );
    decodeVariants('NavigationAction.navigationType', u.NavigationType.values, (t) => mk(t).toMap(), (m) => z.NavigationAction.fromJson(m).toJson());
  });

  test('NavigationResponse', () {
    decode('NavigationResponse', u.NavigationResponse(response: _uresp(), isForMainFrame: true, canShowMIMEType: true).toMap(), (m) => z.NavigationResponse.fromJson(m).toJson());
  });

  test('WebResourceRequest', () {
    decode(
      'WebResourceRequest',
      u.WebResourceRequest(url: u.WebUri('https://a.b/x'), headers: {'h': 'v'}, method: 'PUT', hasGesture: true, isForMainFrame: true, isRedirect: true).toMap(),
      (m) => z.WebResourceRequest.fromJson(m).toJson(),
    );
  });

  test('WebResourceResponse', () {
    decode(
      'WebResourceResponse',
      u.WebResourceResponse(contentType: 'text/css', contentEncoding: 'latin1', data: Uint8List.fromList([1, 2, 3]), headers: {'h': 'v'}, statusCode: 404, reasonPhrase: 'Not Found').toMap(),
      (m) => z.WebResourceResponse.fromJson(m).toJson(),
    );
  });

  test('WebResourceError', () {
    decodeVariants('WebResourceError.type', u.WebResourceErrorType.values, (t) => u.WebResourceError(type: t, description: 'oops').toMap(), (m) => z.WebResourceError.fromJson(m).toJson());
  });

  test('Cookie', () {
    decodeVariants(
      'Cookie.sameSite',
      u.HTTPCookieSameSitePolicy.values,
      (s) => u.Cookie(name: 'n', value: 'v', expiresDate: 1700000000000, isSessionOnly: true, domain: 'a.b', sameSite: s, isSecure: true, isHttpOnly: true, path: '/p').toMap(),
      (m) => z.Cookie.fromJson(m).toJson(),
    );
  });

  test('JsAlertRequest', () {
    decode('JsAlertRequest', u.JsAlertRequest(url: u.WebUri('https://a.b/'), message: 'm', isMainFrame: true).toMap(), (m) => z.JsAlertRequest.fromJson(m).toJson());
  });

  test('JsConfirmRequest', () {
    decode('JsConfirmRequest', u.JsConfirmRequest(url: u.WebUri('https://a.b/'), message: 'm', isMainFrame: true).toMap(), (m) => z.JsConfirmRequest.fromJson(m).toJson());
  });

  test('JsPromptRequest', () {
    decode('JsPromptRequest', u.JsPromptRequest(url: u.WebUri('https://a.b/'), message: 'm', defaultValue: 'd', isMainFrame: true).toMap(), (m) => z.JsPromptRequest.fromJson(m).toJson());
  });

  test('JsBeforeUnloadRequest', () {
    decode('JsBeforeUnloadRequest', u.JsBeforeUnloadRequest(url: u.WebUri('https://a.b/'), message: 'm').toMap(), (m) => z.JsBeforeUnloadRequest.fromJson(m).toJson());
  });

  test('PermissionRequest', () {
    decodeVariants(
      'PermissionRequest.resource',
      u.PermissionResourceType.values,
      (r) => u.PermissionRequest(origin: u.WebUri('https://a.b'), resources: [r], frame: _uframe()).toMap(),
      (m) => z.PermissionRequest.fromJson(m).toJson(),
    );
  });

  test('challenges', () {
    decodeVariants(
      'URLProtectionSpace.authenticationMethod',
      u.URLProtectionSpaceAuthenticationMethod.values,
      (a) => _uspace(method: a).toMap(),
      (m) => z.URLProtectionSpace.fromJson(m).toJson(),
    );
    decodeVariants('URLProtectionSpace.proxyType', u.URLProtectionSpaceProxyType.values, (a) => _uspace(proxy: a).toMap(), (m) => z.URLProtectionSpace.fromJson(m).toJson());
    decodeVariants('SslError.code', u.SslErrorType.values, (c) => u.SslError(code: c, message: 'bad').toMap(), (m) => z.SslError.fromJson(m).toJson());
    decode(
      'HttpAuthenticationChallenge',
      u.HttpAuthenticationChallenge(
        previousFailureCount: 2,
        protectionSpace: _uspace(),
        failureResponse: _uresp(),
        proposedCredential: u.URLCredential(username: 'u', password: 'p', persistence: u.URLCredentialPersistence.values.last),
        error: 'e',
      ).toMap(),
      (m) => z.HttpAuthenticationChallenge.fromJson(m)?.toJson(),
    );
    decode('ServerTrustChallenge', u.ServerTrustChallenge(protectionSpace: _uspace()).toMap(), (m) => z.ServerTrustChallenge.fromJson(m)?.toJson());
    decode(
      'ClientCertChallenge',
      u.ClientCertChallenge(
        protectionSpace: _uspace(),
        principals: ['p'],
        keyTypes: ['rsa'],
        allowedCertificateAuthorities: ['ca'],
        isProxy: true,
        mutuallyTrustedCertificates: [_ucert()],
      ).toMap(),
      (m) => z.ClientCertChallenge.fromJson(m)?.toJson(),
    );
    decodeVariants(
      'URLCredential.persistence',
      u.URLCredentialPersistence.values,
      (p) => u.URLCredential(username: 'u', password: 'p', persistence: p).toMap(),
      (m) => z.URLCredential.fromJson(m).toJson(),
    );
    decode(
      'URLProtectionSpaceHttpAuthCredentials',
      u.URLProtectionSpaceHttpAuthCredentials(protectionSpace: _uspace(), credentials: [u.URLCredential(username: 'u', password: 'p')]).toMap(),
      (m) => z.URLProtectionSpaceHttpAuthCredentials.fromJson(m).toJson(),
    );
  });

  test('SslCertificate', () {
    // x509Certificate is a parsed DER blob with no stable wire form here and is
    // left null; zikzak's decoder requires it.
    decode('SslCertificate', _ucert().toMap(), (m) => z.SslCertificate.fromMap(m)?.toJson());
  });

  test('CreateWindowAction', () {
    decode(
      'CreateWindowAction',
      u.CreateWindowAction(
        windowId: 5,
        isDialog: true,
        windowFeatures: u.WindowFeatures(allowsResizing: true, height: 1.5, menuBarVisibility: true, statusBarVisibility: true, toolbarsVisibility: true, width: 2.5, x: 3.5, y: 4.5),
        request: _ureq(),
        isForMainFrame: true,
      ).toMap(),
      (m) => z.CreateWindowAction.fromJson(m).toJson(),
    );
  });

  test('ConsoleMessage', () {
    decodeVariants('ConsoleMessage.messageLevel', u.ConsoleMessageLevel.values, (l) => u.ConsoleMessage(message: 'hi', messageLevel: l).toMap(), (m) => z.ConsoleMessage.fromJson(m).toJson());
  });

  test('DownloadStartRequest', () {
    decode(
      'DownloadStartRequest',
      u.DownloadStartRequest(url: u.WebUri('https://a.b/f.zip'), userAgent: 'ua', contentDisposition: 'attachment', mimeType: 'application/zip', contentLength: 99, suggestedFilename: 'f.zip', textEncodingName: 'utf-8').toMap(),
      (m) => z.DownloadStartRequest.fromJson(m).toJson(),
    );
  });

  test('LoadedResource', () {
    decode('LoadedResource', u.LoadedResource(initiatorType: 'img', url: u.WebUri('https://a.b/i.png'), startTime: 1.5, duration: 2.5).toMap(), (m) => z.LoadedResource.fromJson(m).toJson());
  });

  test('AjaxRequest', () {
    u.AjaxRequest mk({u.AjaxRequestReadyState? r, u.AjaxRequestEvent? e, u.AjaxRequestAction? a}) => u.AjaxRequest(
          data: 'body',
          method: 'POST',
          url: u.WebUri('https://a.b/x'),
          isAsync: true,
          user: 'u',
          password: 'p',
          withCredentials: true,
          headers: u.AjaxRequestHeaders({'h': 'v'}),
          readyState: r ?? u.AjaxRequestReadyState.values.last,
          status: 200,
          responseURL: u.WebUri('https://a.b/y'),
          responseType: 'text',
          response: 'resp',
          responseText: 'txt',
          responseXML: 'xml',
          statusText: 'OK',
          responseHeaders: {'h': 'v'},
          event: e ?? u.AjaxRequestEvent(type: u.AjaxRequestEventType.values.last, lengthComputable: true, loaded: 1, total: 2),
          action: a ?? u.AjaxRequestAction.values.last,
        );
    decodeVariants('AjaxRequest.readyState', u.AjaxRequestReadyState.values, (r) => mk(r: r).toMap(), (m) => z.AjaxRequest.fromJson(m).toJson());
    decodeVariants('AjaxRequest.action', u.AjaxRequestAction.values, (a) => mk(a: a).toMap(), (m) => z.AjaxRequest.fromJson(m).toJson());
    decodeVariants(
      'AjaxRequest.event.type',
      u.AjaxRequestEventType.values,
      (t) => mk(e: u.AjaxRequestEvent(type: t, lengthComputable: true, loaded: 1, total: 2)).toMap(),
      (m) => z.AjaxRequest.fromJson(m).toJson(),
    );
  });

  test('FetchRequest', () {
    u.FetchRequest mk({u.FetchRequestCredential? c, u.ReferrerPolicy? r, u.FetchRequestAction? a}) => u.FetchRequest(
          url: u.WebUri('https://a.b/x'),
          method: 'POST',
          headers: {'h': 'v'},
          body: 'b',
          mode: 'cors',
          credentials: c ?? u.FetchRequestCredentialDefault(type: 'default'),
          cache: 'no-cache',
          redirect: 'follow',
          referrer: 'https://r/',
          referrerPolicy: r ?? u.ReferrerPolicy.ORIGIN,
          integrity: 'sha',
          keepalive: true,
          action: a ?? u.FetchRequestAction.values.last,
        );
    decodeVariants('FetchRequest.referrerPolicy', u.ReferrerPolicy.values, (r) => mk(r: r).toMap(), (m) => z.FetchRequest.fromJson(m).toJson());
    decodeVariants('FetchRequest.action', u.FetchRequestAction.values, (a) => mk(a: a).toMap(), (m) => z.FetchRequest.fromJson(m).toJson());
  });

  test('FindSession', () {
    decodeVariants(
      'FindSession.searchResultDisplayStyle',
      u.SearchResultDisplayStyle.values,
      (s) => u.FindSession(resultCount: 4, highlightedResultIndex: 2, searchResultDisplayStyle: s).toMap(),
      (m) => z.FindSession.fromJson(m).toJson(),
    );
    // What linux/types/find_session.cc actually emits: no display style.
    decode('FindSession.nativeShape', {'resultCount': 4, 'highlightedResultIndex': 2}, (m) => z.FindSession.fromJson(m).toJson());
  });

  test('WebHistory', () {
    decode(
      'WebHistory',
      u.WebHistory(
        list: [u.WebHistoryItem(originalUrl: u.WebUri('https://o/'), title: 't', url: u.WebUri('https://a.b/'), index: 1, offset: -1, entryId: 7)],
        currentIndex: 0,
      ).toMap(),
      (m) => z.WebHistory.fromJson(m).toJson(),
    );
  });

  test('InAppWebViewHitTestResult', () {
    decodeVariants('InAppWebViewHitTestResult.type', u.InAppWebViewHitTestResultType.values, (t) => u.InAppWebViewHitTestResult(type: t, extra: 'x').toMap(), (m) => z.InAppWebViewHitTestResult.fromJson(m).toJson());
  });

  test('RenderProcessGoneDetail', () {
    decodeVariants('RenderProcessGoneDetail.rendererPriorityAtExit', u.RendererPriority.values, (p) => u.RenderProcessGoneDetail(didCrash: true, rendererPriorityAtExit: p).toMap(), (m) => z.RenderProcessGoneDetail.fromJson(m).toJson());
  });

  test('WebMessage', () {
    // Native -> Dart: a message with no ports (ports are live objects).
    decode('WebMessage.string', u.WebMessage(data: 'hello', type: u.WebMessageType.STRING).toMap(), (m) => z.WebMessage.fromJson(m).toJson());
    decode('WebMessage.arrayBuffer', u.WebMessage(data: Uint8List.fromList([1, 2]), type: u.WebMessageType.ARRAY_BUFFER).toMap(), (m) => z.WebMessage.fromJson(m).toJson());
  });

  test('WebMessage with ports', () {
    // Native never sends ports; this pins how zikzak's decoder handles the
    // port maps upstream's toMap() produces (see webMessageFromWire).
    decode('WebMessage.withPorts', u.WebMessage(data: 'hello', type: u.WebMessageType.STRING, ports: [_UPort()]).toMap(), (m) => z.WebMessage.fromJson(m).toJson());
  });

  test('InAppBrowserClassSettings', () {
    final browserKeys = u.InAppBrowserSettings().toMap().keys.toSet();
    decodeVariants(
      'InAppBrowserSettings.windowType',
      u.WindowType.values,
      (w) => u.InAppBrowserSettings(hidden: true, hideToolbarTop: true, hideUrlBar: true, hideProgressBar: true, hideDefaultMenuItems: true, toolbarTopFixedTitle: 'T', windowType: w, windowAlphaValue: 0.5, windowFrame: u.InAppWebViewRect(x: 1, y: 2, width: 3, height: 4)).toMap(),
      (m) => z.InAppBrowserClassSettings.fromMap(m).toMap()..removeWhere((k, _) => !browserKeys.contains(k)),
    );
  });

  test('InAppWebViewSettings', () {
    // getSettings(): native -> Dart.
    final up = u.InAppWebViewSettings().toMap();
    final shared = z.InAppWebViewSettings().toJson().keys.toSet();
    final map = {for (final e in up.entries) if (shared.contains(e.key)) e.key: e.value};
    // Upstream's int-encoded enum keys make zikzak's decoder throw ...
    Object? rt(Map<String, dynamic> m) => z.InAppWebViewSettings.fromJson(m).toJson()..removeWhere((k, _) => m[k] == null);
    decode('InAppWebViewSettings.withEnumKeys', map, rt);
    // ... so check everything else without them. zikzak's decoder fills in its
    // own defaults for keys native does not send, so only keys present in the
    // payload are compared.
    const enumWire = {'contentInsetAdjustmentBehavior', 'selectionGranularity', 'iframeReferrerPolicy'};
    decode('InAppWebViewSettings', {for (final e in map.entries) if (!enumWire.contains(e.key)) e.key: e.value}, rt);
    // Every enum-valued setting from its native wire form, once per enum value
    // (one key per payload so one failing key cannot hide the others).
    forEachSettingsEnum(<U, Z>(key, uv, zv, mkU, mkZ) {
      for (final v in uv) {
        final name = (v as dynamic).name() as String;
        final value = mkU(v).toMap()[key];
        decode('InAppWebViewSettings.$key.$name', {key: value}, rt);
      }
    });
    // Fully populated non-enum settings.
    final scalars = u.InAppWebViewSettings().toMap();
    final withEnums = {for (final e in scalars.entries) if (shared.contains(e.key) && e.value != null && !enumWire.contains(e.key)) e.key: e.value};
    decode('InAppWebViewSettings.defaults', withEnums, rt);
  });

  // Skipped, with the reason for each:
  // - ShowFileChooserRequest.fromMap: zikzak has no such type and no
  //   onShowFileChooser callback.
  // - JavaScriptHandlerFunctionData.fromMap: zikzak has no such class; the
  //   controller reads the {args, origin, isMainFrame, requestUrl} payload
  //   with plain map access.
  // - MapSize.fromMap: zikzak's `MapSize` is an extension on Size with the same
  //   {width, height} shape; covered by 'Size' in encode_test.dart.
  // - InAppBrowserClassOptions.fromMap: deprecated upstream type, no zikzak
  //   counterpart.
  // - CacheModel.fromNativeValue: zikzak has no CacheModel (Linux has no
  //   WebViewEnvironment).
  // - MediaCaptureState / MediaPlaybackState.fromNativeValue: see enums_test.dart.
}
