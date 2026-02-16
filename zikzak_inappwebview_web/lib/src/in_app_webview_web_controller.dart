import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:web/web.dart' as web;
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

class InAppWebViewWebController extends PlatformInAppWebViewController {
  final web.HTMLIFrameElement _iframe;
  Function(WebUri? url)? onLoadStartCallback;

  InAppWebViewWebController(
    PlatformInAppWebViewControllerCreationParams params,
    this._iframe,
  ) : super.implementation(params) {
    _iframe.addEventListener(
      'load',
      ((web.Event event) {
        // Use a small delay to ensure the window object is ready and accessible
        Future.delayed(const Duration(milliseconds: 100), () {
          _injectConsoleInterception();
        });
      }).toJS,
    );

    web.window.addEventListener(
      'message',
      ((web.MessageEvent event) {
        final data = event.data;
        if (data == null) return;
        final raw = data.dartify();
        if (raw is! String) return;
        if (!raw.contains('"type":"console"')) return;
        try {
          final decoded = jsonDecode(raw);
          if (decoded is Map && decoded['type'] == 'console') {
            final message = decoded['message'];
            final level = decoded['level'];
            ConsoleMessageLevel consoleLevel = ConsoleMessageLevel.LOG;
            switch (level) {
              case 'WARNING':
                consoleLevel = ConsoleMessageLevel.WARNING;
                break;
              case 'ERROR':
                consoleLevel = ConsoleMessageLevel.ERROR;
                break;
              case 'DEBUG':
                consoleLevel = ConsoleMessageLevel.DEBUG;
                break;
              case 'INFO':
                consoleLevel = ConsoleMessageLevel.LOG;
                break;
            }

            if (params.webviewParams?.onConsoleMessage != null) {
              params.webviewParams!.onConsoleMessage!(
                this,
                ConsoleMessage(
                  message: message?.toString() ?? '',
                  messageLevel: consoleLevel,
                ),
              );
            }
          }
        } catch (e) {
          // Ignore JSON parse errors
        }
      }).toJS,
    );
  }

  static const String _consoleInterceptionScript = """
    (function() {
      var oldLog = console.log;
      var oldWarn = console.warn;
      var oldError = console.error;
      var oldDebug = console.debug;
      var oldInfo = console.info;

      function sendConsoleMessage(message, level) {
        try {
          window.parent.postMessage(JSON.stringify({
            'type': 'console',
            'message': message,
            'level': level
          }), '*');
        } catch(e) {
          oldError.call(console, "Failed to send console message: " + e);
        }
      }

      console.log = function(message) {
        oldLog.apply(console, arguments);
        sendConsoleMessage(Array.from(arguments).join(' '), 'LOG');
      };
      console.warn = function(message) {
        oldWarn.apply(console, arguments);
        sendConsoleMessage(Array.from(arguments).join(' '), 'WARNING');
      };
      console.error = function(message) {
        oldError.apply(console, arguments);
        sendConsoleMessage(Array.from(arguments).join(' '), 'ERROR');
      };
      console.debug = function(message) {
        oldDebug.apply(console, arguments);
        sendConsoleMessage(Array.from(arguments).join(' '), 'DEBUG');
      };
      console.info = function(message) {
        oldInfo.apply(console, arguments);
        sendConsoleMessage(Array.from(arguments).join(' '), 'INFO');
      };
    })();
  """;

  void _injectConsoleInterception() {
    try {
      final doc = _iframe.contentDocument;
      if (doc != null) {
        final script = doc.createElement('script') as web.HTMLScriptElement;
        script.text = _consoleInterceptionScript;
        final body = doc.body;
        if (body != null) {
          body.appendChild(script);
        } else {
          doc.documentElement?.appendChild(script);
        }
        return;
      }
    } catch (e) {
      // Likely cross-origin
    }

    // Fallback: try via JS interop on the iframe object
    try {
      final jsIframe = _iframe as JSObject;
      if (jsIframe.has('contentDocument')) {
        final doc = jsIframe['contentDocument'] as JSObject?;
        if (doc != null) {
          final script =
              doc.callMethod('createElement'.toJS, 'script'.toJS) as JSObject;
          script['text'] = _consoleInterceptionScript.toJS;

          JSObject? target;
          if (doc.has('body') && doc['body'] != null) {
            target = doc['body'] as JSObject;
          } else if (doc.has('head') && doc['head'] != null) {
            target = doc['head'] as JSObject;
          } else if (doc.has('documentElement') &&
              doc['documentElement'] != null) {
            target = doc['documentElement'] as JSObject;
          }
          target?.callMethod('appendChild'.toJS, script);
        }
      }
    } catch (e) {
      // Ignore
    }
  }

  @override
  Future<void> loadUrl({
    required URLRequest urlRequest,
    WebUri? allowingReadAccessTo,
  }) async {
    if (urlRequest.url != null) {
      if (onLoadStartCallback != null) {
        onLoadStartCallback!(urlRequest.url);
      }
      _iframe.src = urlRequest.url.toString();
    }
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
    if (onLoadStartCallback != null) {
      onLoadStartCallback!(baseUrl);
    }
    // Use srcdoc for HTML content to keep the iframe same-origin,
    // which allows console interception and JS evaluation to work.
    if (mimeType == "text/html") {
      _iframe.srcdoc = data.toJS;
    } else {
      final dataUri = Uri.dataFromString(
        data,
        mimeType: mimeType,
        encoding: Encoding.getByName(encoding),
      ).toString();
      _iframe.src = dataUri;
    }
  }

  @override
  Future<Uint8List?> createPdf({
    PDFConfiguration? pdfConfiguration,
  }) async {
    return null;
  }

  @override
  Future<void> loadFile({required String assetFilePath}) async {
    // On web, assets are served under assets/
    final url = WebUri('assets/$assetFilePath');
    if (onLoadStartCallback != null) {
      onLoadStartCallback!(url);
    }
    _iframe.src = url.toString();
  }

  @override
  Future<WebUri?> getUrl() async {
    try {
      final window = _iframe.contentWindow;
      if (window != null) {
        final href = window.location.href;
        return WebUri(href);
      }
    } catch (e) {
      // Fallback for cross-origin or other errors
    }
    final src = _iframe.src;
    return src.isNotEmpty ? WebUri(src) : null;
  }

  @override
  Future<String?> getTitle() async {
    try {
      final doc = _iframe.contentDocument;
      return doc?.title;
    } catch (e) {
      // Not accessible for cross-origin iframes
      return null;
    }
  }

  @override
  Future<int?> getProgress() async {
    // Not supported on basic iframe
    return null;
  }

  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) async {
    try {
      final doc = _iframe.contentDocument;
      if (doc != null) {
        final script = doc.createElement('script') as web.HTMLScriptElement;
        script.text = source;
        doc.body?.appendChild(script);
        return "Executed (Return value capture not supported)";
      }
    } catch (e) {
      // Likely SecurityError due to cross-origin
    }
    return null;
  }

  @override
  Future<void> reload() async {
    try {
      final window = _iframe.contentWindow;
      window?.location.reload();
    } catch (e) {
      // Fallback for cross-origin
      final src = _iframe.src;
      if (src.isNotEmpty) {
        _iframe.src = src;
      }
    }
  }

  @override
  Future<void> goBack() async {
    try {
      _iframe.contentWindow?.history.back();
    } catch (e) {
      // Cannot go back if cross-origin blocked
    }
  }

  @override
  Future<void> goForward() async {
    try {
      _iframe.contentWindow?.history.forward();
    } catch (e) {
      // Cannot go forward if cross-origin blocked
    }
  }

  @override
  Future<void> stopLoading() async {
    try {
      _iframe.contentWindow?.stop();
    } catch (_) {
      // Ignore
    }
  }

  @override
  Future<String?> getHtml() async {
    // Strategy 1: Use contentDocument directly (works for same-origin / srcdoc)
    try {
      final doc = _iframe.contentDocument;
      if (doc != null) {
        final outerHTML = doc.documentElement?.outerHTML;
        if (outerHTML != null) {
          final html = (outerHTML as JSString).toDart;
          if (html.isNotEmpty) return html;
        }
      }
    } catch (e) {
      // Cross-origin or other errors
    }

    // Strategy 2: Use contentWindow.document
    try {
      final window = _iframe.contentWindow;
      if (window != null) {
        final outerHTML = window.document.documentElement?.outerHTML;
        if (outerHTML != null) {
          final html = (outerHTML as JSString).toDart;
          if (html.isNotEmpty) return html;
        }
      }
    } catch (e) {
      // Cross-origin or other errors
    }

    // Strategy 3: JS interop fallback
    try {
      final jsIframe = _iframe as JSObject;
      if (jsIframe.has('contentDocument')) {
        final doc = jsIframe['contentDocument'] as JSObject?;
        if (doc != null &&
            doc.has('documentElement') &&
            doc['documentElement'] != null) {
          final docEl = doc['documentElement'] as JSObject;
          if (docEl.has('outerHTML')) {
            final result = docEl['outerHTML'];
            if (result != null) {
              return (result as JSString).toDart;
            }
          }
        }
      }
    } catch (e) {
      // Ignore errors
    }

    return null;
  }

  @override
  Future<PlatformPrintJobController?> printCurrentPage({PrintJobSettings? settings}) async {
    try {
      _iframe.contentWindow?.print();
    } catch (e) {
      // Ignore cross-origin errors
    }
    return null;
  }

  @override
  void dispose({bool isKeepAlive = false}) {
    // Cleanup if needed
  }
}
