import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

class InAppWebViewWebController extends PlatformInAppWebViewController {
  final html.IFrameElement _iframe;
  Function(WebUri? url)? onLoadStartCallback;

  InAppWebViewWebController(
    PlatformInAppWebViewControllerCreationParams params,
    this._iframe,
  ) : super.implementation(params) {
    _iframe.onLoad.listen((event) {
      // print("Iframe loaded: ${_iframe.src}");
      // Use a small delay to ensure the window object is ready and accessible
      Future.delayed(const Duration(milliseconds: 100), () {
        _injectConsoleInterception();
      });
    });

    html.window.onMessage.listen((event) {
      if (event.data is! String) return;
      final raw = event.data as String;
      if (!raw.contains('"type":"console"')) return;
      try {
        final data = jsonDecode(raw);
        if (data is Map && data['type'] == 'console') {
          final message = data['message'];
          final level = data['level'];
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
              consoleLevel = ConsoleMessageLevel
                  .LOG; // Fallback to LOG if INFO is missing in the enum
              break;
          }

          if (params.webviewParams?.onConsoleMessage != null) {
            params.webviewParams!.onConsoleMessage!(
              this,
              ConsoleMessage(message: message, messageLevel: consoleLevel),
            );
          }
        }
      } catch (_) {
        // Ignore invalid JSON
      }
    });
  }

  void _injectConsoleInterception() {
    try {
      final window = _iframe.contentWindow;
      // When using about:blank, contentWindow is accessible as a same-origin Window.
      // We can cast it to html.Window directly.
      if (window is html.Window) {
        print("Injecting console interception script...");
        final doc = window.document;
        final script = doc.createElement('script');
        script.text = """
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
            
            console.log("ZikZak: Console interception active");
          })();
        """;
        // Type casting to HtmlDocument to access body
        if (doc is html.HtmlDocument && doc.body != null) {
          doc.body!.append(script);
        } else {
          doc.documentElement?.append(script);
        }
      } else {
        // Fallback for cases where Dart might wrap it differently, though about:blank should be fine.
        // If we are here, it might be Cross-Origin or Dart's type system being tricky.
        print(
          "Content window is not an html.Window (likely cross-origin blocked or type mismatch)",
        );

        // Strategy 2: Try accessing contentDocument directly from the iframe element via JS interop
        // This bypasses the contentWindow wrapper which might be causing issues.
        print(
          "Attempting to access contentDocument via JS interop on iframe element...",
        );
        try {
          final jsIframe = js.JsObject.fromBrowserObject(_iframe);
          if (jsIframe.hasProperty('contentDocument')) {
            final doc = jsIframe['contentDocument'];
            if (doc != null) {
              print("Successfully accessed contentDocument via JS interop");
              final script = doc.callMethod('createElement', ['script']);
              script['text'] = """
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
                  
                  console.log("ZikZak: Console interception active");
                })();
                """;

              // Try to append to body or head or documentElement
              var appended = false;
              if (doc.hasProperty('body') && doc['body'] != null) {
                doc['body'].callMethod('appendChild', [script]);
                appended = true;
              } else if (doc.hasProperty('head') && doc['head'] != null) {
                doc['head'].callMethod('appendChild', [script]);
                appended = true;
              } else if (doc.hasProperty('documentElement') &&
                  doc['documentElement'] != null) {
                doc['documentElement'].callMethod('appendChild', [script]);
                appended = true;
              }

              if (appended) {
                print("Script appended successfully via contentDocument");
                return;
              } else {
                print(
                  "Could not find body/head/documentElement to append script",
                );
              }
            }
          }
        } catch (e) {
          print("Failed to access contentDocument: $e");
        }

        // Strategy 3: Original JS interop fallback (as last resort)
        if (window != null) {
          print("Attempting JS interop fallback on window...");
          final jsWindow = js.JsObject.fromBrowserObject(window);

          // Check for document property
          if (jsWindow.hasProperty('document')) {
            final doc = jsWindow['document'];
            final script = doc.callMethod('createElement', ['script']);
            script['text'] = """
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
                  
                  console.log("ZikZak: Console interception active");
                })();
                """;
            final body = doc['body'];
            body.callMethod('appendChild', [script]);
          } else {
            print("JS Interop: Window has no 'document' property");
          }
        }
      }
    } catch (e) {
      print("Failed to inject console interception: $e");
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
      _iframe.setAttribute('srcdoc', data);
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
    // Note: Cross-origin restrictions might prevent accessing contentWindow.location.href
    // if the iframe content is on a different domain.
    try {
      final window = _iframe.contentWindow as html.Window?;
      final href = window?.location.href;
      return href != null ? WebUri(href) : null;
    } catch (e) {
      // Fallback for cross-origin or other errors
      final src = _iframe.src;
      return src != null ? WebUri(src) : null;
    }
  }

  @override
  Future<String?> getTitle() async {
    try {
      final window = _iframe.contentWindow as html.Window?;
      final document = window?.document as html.HtmlDocument?;
      return document?.title;
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
      final window = _iframe.contentWindow;
      if (window != null) {
        // This only works for same-origin iframes.
        // For cross-origin iframes, you would typically need postMessage,
        // but standard evaluateJavascript implies direct execution.
        // We'll use JS interop to execute in the context of the iframe window if possible.
        // However, dart:html's window.location.href access throws on cross-origin.
        // There is no standard way to inject arbitrary JS into a cross-origin iframe from the parent
        // due to security policies (SOP).

        // Assuming same-origin for now or accepting the limitation.
        // We can try to use `window.eval(source)` if available/accessible.
        // Note: dart:html Window doesn't expose eval directly easily.

        // A common workaround in Flutter Web for "eval" is using dart:js_interop or similar,
        // but here we are targeting a specific iframe window.

        // We can try using postMessage if we had a listener inside, but we don't control the page content generally.

        // Best effort:
        // Create a script element in the iframe's document (only works for same-origin).
        final doc = (window as html.Window).document as html.HtmlDocument;
        final script = doc.createElement('script');
        script.text = source;
        doc.body?.append(script);
        // Getting the result is harder with this method.
        // For 'eval' with return value, we might try:
        // return (window as dynamic).eval(source);
        return "Executed (Return value capture not supported)";
      }
    } catch (e) {
      // Likely SecurityError due to cross-origin
      // print("evaluateJavascript failed (likely due to Cross-Origin restrictions): $e");
    }
    return null;
  }

  @override
  Future<void> reload() async {
    try {
      final window = _iframe.contentWindow as html.Window?;
      window?.location.reload();
    } catch (e) {
      // Fallback for cross-origin
      final src = _iframe.src;
      if (src != null) {
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
      final window = _iframe.contentWindow as html.Window?;
      window?.stop();
    } catch (e) {
      // Ignore
    }
  }

  @override
  void dispose({bool isKeepAlive = false}) {
    if (isKeepAlive) {
      // Handle keep alive logic if necessary
    }
    // Cleanup if needed
  }
}
