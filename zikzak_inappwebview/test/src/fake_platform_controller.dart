import 'dart:typed_data';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

/// A recording fake of [PlatformInAppWebViewController] for behavioral tests of
/// the domain controller split (spec 011).
///
/// Every method under test records its name and arguments in [calls] so a test
/// can assert that a facade method delegated to the parent controller and,
/// ultimately, to the platform with identical arguments. Methods that are not
/// exercised by the facades under test inherit the `throw UnimplementedError`
/// body from the base class.
class FakePlatformInAppWebViewController
    extends PlatformInAppWebViewController {
  FakePlatformInAppWebViewController([
    PlatformInAppWebViewControllerCreationParams? params,
  ]) : super.implementation(
          params ??
              const PlatformInAppWebViewControllerCreationParams(id: 0),
        );

  /// Ordered record of every recorded method call.
  final List<_Call> calls = [];

  /// Configurable canned return values.
  WebUri? nextUrl;
  bool nextBool = true;
  WebHistory? nextHistory;
  InAppWebViewSettings? nextSettings;
  dynamic nextEvaluate;
  CallAsyncJavaScriptResult? nextAsyncResult;
  dynamic nextInjectAsset;

  List<_Call> recorded(String name) =>
      calls.where((c) => c.method == name).toList();

  void _record(String method, [Map<String, Object?> args = const {}]) =>
      calls.add(_Call(method, args));

  @override
  Future<WebUri?> getUrl() async {
    _record('getUrl');
    return nextUrl;
  }

  @override
  Future<void> loadUrl({
    required URLRequest urlRequest,
    WebUri? allowingReadAccessTo,
  }) async {
    _record('loadUrl', {
      'urlRequest': urlRequest,
      'allowingReadAccessTo': allowingReadAccessTo,
    });
  }

  @override
  Future<void> postUrl({required WebUri url, required Uint8List postData}) async {
    _record('postUrl', {'url': url, 'postData': postData});
  }

  @override
  Future<void> loadData({
    required String data,
    String mimeType = "text/html",
    String encoding = "utf8",
    WebUri? baseUrl,
    WebUri? historyUrl,
    WebUri? allowingReadAccessTo,
  }) async {
    _record('loadData', {
      'data': data,
      'mimeType': mimeType,
      'encoding': encoding,
      'baseUrl': baseUrl,
      'historyUrl': historyUrl,
      'allowingReadAccessTo': allowingReadAccessTo,
    });
  }

  @override
  Future<void> loadFile({required String assetFilePath}) async {
    _record('loadFile', {'assetFilePath': assetFilePath});
  }

  @override
  Future<void> loadSimulatedRequest({
    required URLRequest urlRequest,
    required Uint8List data,
    URLResponse? urlResponse,
  }) async {
    _record('loadSimulatedRequest', {
      'urlRequest': urlRequest,
      'data': data,
      'urlResponse': urlResponse,
    });
  }

  @override
  Future<void> reload() async => _record('reload');

  @override
  Future<void> reloadFromOrigin() async => _record('reloadFromOrigin');

  @override
  Future<void> stopLoading() async => _record('stopLoading');

  @override
  Future<bool> isLoading() async {
    _record('isLoading');
    return nextBool;
  }

  @override
  Future<void> goBack() async => _record('goBack');

  @override
  Future<void> goForward() async => _record('goForward');

  @override
  Future<void> goBackOrForward({required int steps}) async {
    _record('goBackOrForward', {'steps': steps});
  }

  @override
  Future<bool> canGoBack() async {
    _record('canGoBack');
    return nextBool;
  }

  @override
  Future<bool> canGoForward() async {
    _record('canGoForward');
    return nextBool;
  }

  @override
  Future<bool> canGoBackOrForward({required int steps}) async {
    _record('canGoBackOrForward', {'steps': steps});
    return nextBool;
  }

  @override
  Future<void> goTo({required WebHistoryItem historyItem}) async {
    _record('goTo', {'historyItem': historyItem});
  }

  @override
  Future<WebHistory?> getCopyBackForwardList() async {
    _record('getCopyBackForwardList');
    return nextHistory;
  }

  @override
  Future<void> clearHistory() async => _record('clearHistory');

  @override
  Future<InAppWebViewSettings?> getSettings() async {
    _record('getSettings');
    return nextSettings;
  }

  @override
  Future<void> setSettings({required InAppWebViewSettings settings}) async {
    _record('setSettings', {'settings': settings});
  }

  // --- JavaScript facade recordings ---

  JavaScriptHandlerCallback? nextHandler;

  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) async {
    _record('evaluateJavascript', {
      'source': source,
      'contentWorld': contentWorld,
    });
    return nextEvaluate;
  }

  @override
  Future<CallAsyncJavaScriptResult?> callAsyncJavaScript({
    required String functionBody,
    Map<String, dynamic> arguments = const <String, dynamic>{},
    ContentWorld? contentWorld,
  }) async {
    _record('callAsyncJavaScript', {
      'functionBody': functionBody,
      'arguments': arguments,
      'contentWorld': contentWorld,
    });
    return nextAsyncResult;
  }

  @override
  Future<void> injectJavascriptFileFromUrl({
    required WebUri urlFile,
    ScriptHtmlTagAttributes? scriptHtmlTagAttributes,
  }) async {
    _record('injectJavascriptFileFromUrl', {
      'urlFile': urlFile,
      'scriptHtmlTagAttributes': scriptHtmlTagAttributes,
    });
  }

  @override
  Future<dynamic> injectJavascriptFileFromAsset({
    required String assetFilePath,
  }) async {
    _record('injectJavascriptFileFromAsset', {'assetFilePath': assetFilePath});
    return nextInjectAsset;
  }

  @override
  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  }) {
    _record('addJavaScriptHandler', {
      'handlerName': handlerName,
      'callback': callback,
    });
  }

  @override
  JavaScriptHandlerCallback? removeJavaScriptHandler({
    required String handlerName,
  }) {
    _record('removeJavaScriptHandler', {'handlerName': handlerName});
    return nextHandler;
  }

  @override
  bool hasJavaScriptHandler({required String handlerName}) {
    _record('hasJavaScriptHandler', {'handlerName': handlerName});
    return nextBool;
  }

  @override
  Future<void> addUserScript({required UserScript userScript}) async {
    _record('addUserScript', {'userScript': userScript});
  }

  @override
  Future<void> addUserScripts({required List<UserScript> userScripts}) async {
    _record('addUserScripts', {'userScripts': userScripts});
  }

  @override
  Future<bool> removeUserScript({required UserScript userScript}) async {
    _record('removeUserScript', {'userScript': userScript});
    return nextBool;
  }

  @override
  Future<void> removeUserScripts({
    required List<UserScript> userScripts,
  }) async {
    _record('removeUserScripts', {'userScripts': userScripts});
  }

  @override
  Future<void> removeUserScriptsByGroupName({
    required String groupName,
  }) async {
    _record('removeUserScriptsByGroupName', {'groupName': groupName});
  }

  @override
  Future<void> removeAllUserScripts() async =>
      _record('removeAllUserScripts');

  @override
  bool hasUserScript({required UserScript userScript}) {
    _record('hasUserScript', {'userScript': userScript});
    return nextBool;
  }
}

/// A single recorded method invocation.
class _Call {
  const _Call(this.method, this.args);
  final String method;
  final Map<String, Object?> args;
}
