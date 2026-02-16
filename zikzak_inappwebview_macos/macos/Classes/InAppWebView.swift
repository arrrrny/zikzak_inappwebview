import Cocoa
import FlutterMacOS
import WebKit

public class InAppWebView: WKWebView, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate {
    var channel: FlutterMethodChannel!
    private var findInteractionChannel: FlutterMethodChannel!
    private var searchText: String?
    private var isDisposed = false
    
    init(registrar: FlutterPluginRegistrar, viewId: Any, arguments: Any?, channelName: String? = nil) {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        configuration.userContentController = userContentController
        
        super.init(frame: .zero, configuration: configuration)
        self.navigationDelegate = self
        self.uiDelegate = self
        
        userContentController.add(WeakScriptMessageHandler(delegate: self), name: "consoleHandler")
        userContentController.add(WeakScriptMessageHandler(delegate: self), name: "onFindResultReceived")
        
        let consoleOverrideScript = """
        (function() {
            var originalLog = console.log;
            var originalDebug = console.debug;
            var originalInfo = console.info;
            var originalWarn = console.warn;
            var originalError = console.error;
            
            function log(level, message) {
                window.webkit.messageHandlers.consoleHandler.postMessage({
                    "message": message,
                    "messageLevel": level
                });
            }
            console.log = function(message) { log("LOG", message); if (originalLog) originalLog.call(console, message); };
            console.debug = function(message) { log("DEBUG", message); if (originalDebug) originalDebug.call(console, message); };
            console.info = function(message) { log("INFO", message); if (originalInfo) originalInfo.call(console, message); };
            console.warn = function(message) { log("WARNING", message); if (originalWarn) originalWarn.call(console, message); };
            console.error = function(message) { log("ERROR", message); if (originalError) originalError.call(console, message); };
        })();
        """
        let userScript = WKUserScript(source: consoleOverrideScript, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userContentController.addUserScript(userScript)
        
        let findInteractionUserScript = WKUserScript(source: FIND_TEXT_HIGHLIGHT_JS_SOURCE, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        userContentController.addUserScript(findInteractionUserScript)
        
        let finalChannelName = channelName ?? "dev.zuzu/zikzak_inappwebview_\(viewId)"
        channel = FlutterMethodChannel(name: finalChannelName, binaryMessenger: registrar.messenger)
        channel.setMethodCallHandler(self.handle)
        
        let findInteractionChannelName = "wtf.zikzak/zikzak_inappwebview_find_interaction_\(viewId)"
        findInteractionChannel = FlutterMethodChannel(name: findInteractionChannelName, binaryMessenger: registrar.messenger)
        findInteractionChannel.setMethodCallHandler(self.handleFindInteraction)
        
        if let args = arguments as? [String: Any] {
            if let initialUrlRequest = args["initialUrlRequest"] as? [String: Any],
               let urlString = initialUrlRequest["url"] as? String,
               let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                self.load(request)
            }
        }
        
        self.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.addObserver(self, forKeyPath: "url", options: .new, context: nil)
        self.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }
    
    deinit {
        dispose()
    }
    
    public func dispose() {
        if !isDisposed {
            self.configuration.userContentController.removeScriptMessageHandler(forName: "consoleHandler")
            self.configuration.userContentController.removeScriptMessageHandler(forName: "onFindResultReceived")
            self.removeObserver(self, forKeyPath: "estimatedProgress")
            self.removeObserver(self, forKeyPath: "url")
            self.removeObserver(self, forKeyPath: "title")
            channel.setMethodCallHandler(nil)
            findInteractionChannel.setMethodCallHandler(nil)
            isDisposed = true
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let progress = Int(self.estimatedProgress * 100)
            channel.invokeMethod("onProgressChanged", arguments: ["progress": progress])
        } else if keyPath == "url" {
            var arguments: [String: Any] = ["isReload": false]
            if let url = self.url?.absoluteString {
                arguments["url"] = url
            }
            channel.invokeMethod("onUpdateVisitedHistory", arguments: arguments)
        } else if keyPath == "title" {
            var arguments: [String: Any] = [:]
            if let title = self.title {
                arguments["title"] = title
            }
            channel.invokeMethod("onTitleChanged", arguments: arguments)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getUrl":
            result(self.url?.absoluteString)
        case "getTitle":
            result(self.title)
        case "getProgress":
            result(Int(self.estimatedProgress * 100))
        case "loadUrl":
            if let args = call.arguments as? [String: Any],
               let urlRequest = args["urlRequest"] as? [String: Any],
               let urlString = urlRequest["url"] as? String,
               let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                self.load(request)
                result(true)
            } else {
                result(FlutterError(code: "InAppWebView", message: "Invalid arguments", details: nil))
            }
        case "loadData":
            if let args = call.arguments as? [String: Any],
               let data = args["data"] as? String,
               let baseUrl = args["baseUrl"] as? String {
                self.loadHTMLString(data, baseURL: URL(string: baseUrl))
                result(true)
            } else {
                result(FlutterError(code: "InAppWebView", message: "Invalid arguments", details: nil))
            }
        case "reload":
            self.reload()
            result(true)
        case "goBack":
            if self.canGoBack {
                self.goBack()
            }
            result(true)
        case "goForward":
            if self.canGoForward {
                self.goForward()
            }
            result(true)
        case "canGoBack":
            result(self.canGoBack)
        case "canGoForward":
            result(self.canGoForward)
        case "isLoading":
            result(self.isLoading)
        case "stopLoading":
            self.stopLoading()
            result(true)
        case "getHtml":
            self.evaluateJavaScript("document.documentElement.outerHTML") { (value, error) in
                if let error = error {
                    result(FlutterError(code: "InAppWebView", message: error.localizedDescription, details: nil))
                } else {
                    result(value)
                }
            }
        case "createPdf":
            if #available(macOS 11.0, *) {
                let pdfConfiguration = WKPDFConfiguration()
                if let args = call.arguments as? [String: Any],
                   let configMap = args["pdfConfiguration"] as? [String: Any] {
                    if let rectMap = configMap["rect"] as? [String: Double] {
                        let x = rectMap["x"] ?? 0
                        let y = rectMap["y"] ?? 0
                        let width = rectMap["width"] ?? 0
                        let height = rectMap["height"] ?? 0
                        pdfConfiguration.rect = CGRect(x: x, y: y, width: width, height: height)
                    }
                }
                
                self.createPDF(configuration: pdfConfiguration) { res in
                    switch res {
                    case .success(let data):
                        result(data)
                    case .failure(let error):
                        result(nil)
                    }
                }
            } else {
                result(nil)
            }
        case "evaluateJavascript":
            if let args = call.arguments as? [String: Any],
               let source = args["source"] as? String {
                self.evaluateJavaScript(source) { (value, error) in
                    if let error = error {
                        result(FlutterError(code: "InAppWebView", message: error.localizedDescription, details: nil))
                    } else {
                        result(value)
                    }
                }
            } else {
                 result(FlutterError(code: "InAppWebView", message: "Invalid arguments", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        channel.invokeMethod("onLoadStart", arguments: ["url": webView.url?.absoluteString])
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        channel.invokeMethod("onLoadStop", arguments: ["url": webView.url?.absoluteString])
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        onReceivedError(error: error)
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        onReceivedError(error: error)
    }

    private func onReceivedError(error: Error) {
        var arguments: [String: Any] = [:]
        arguments["url"] = self.url?.absoluteString
        arguments["code"] = (error as NSError).code
        arguments["message"] = error.localizedDescription
        channel.invokeMethod("onReceivedError", arguments: arguments)
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "consoleHandler", let body = message.body as? [String: Any] {
            var arguments: [String: Any] = [:]
            arguments["message"] = body["message"] as? String
            
            var level = 1 // LOG
            if let messageLevel = body["messageLevel"] as? String {
                switch messageLevel {
                case "LOG":
                    level = 1
                case "DEBUG":
                    level = 4
                case "ERROR":
                    level = 3
                case "INFO":
                    level = 1
                case "WARNING":
                    level = 2
                default:
                    level = 1
                }
            }
            arguments["messageLevel"] = level
            channel.invokeMethod("onConsoleMessage", arguments: arguments)
        } else if message.name == "onFindResultReceived", let body = message.body as? [String: Any] {
            findInteractionChannel.invokeMethod("onFindResultReceived", arguments: body)
        }
    }
    
    public func handleFindInteraction(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "findAll":
            if let args = call.arguments as? [String: Any], let find = args["find"] as? String {
                let js = "window.\(JAVASCRIPT_BRIDGE_NAME)._findAllAsync('\(find)');"
                self.evaluateJavaScript(js, completionHandler: nil)
            }
            result(true)
        case "findNext":
             if let args = call.arguments as? [String: Any], let forward = args["forward"] as? Bool {
                let js = "window.\(JAVASCRIPT_BRIDGE_NAME)._findNext(\(forward));"
                self.evaluateJavaScript(js, completionHandler: nil)
             }
             result(true)
        case "clearMatches":
             let js = "window.\(JAVASCRIPT_BRIDGE_NAME)._clearMatches();"
             self.evaluateJavaScript(js, completionHandler: nil)
             result(true)
        case "setSearchText":
             if let args = call.arguments as? [String: Any], let searchText = args["searchText"] as? String {
                self.searchText = searchText
             }
             result(true)
        case "getSearchText":
             result(self.searchText)
        default:
             result(FlutterMethodNotImplemented)
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var arguments: [String: Any] = [:]
        let request: [String: Any] = [
            "url": navigationAction.request.url?.absoluteString ?? "",
            "method": navigationAction.request.httpMethod ?? "GET",
            "headers": navigationAction.request.allHTTPHeaderFields ?? [:]
        ]
        // body is skipped for now
        
        let sourceFrame: [String: Any] = [
            "isMainFrame": navigationAction.sourceFrame.isMainFrame,
            "request": [
                "url": navigationAction.sourceFrame.request.url?.absoluteString ?? ""
            ],
            "securityOrigin": [
                "host": navigationAction.sourceFrame.securityOrigin.host,
                "port": navigationAction.sourceFrame.securityOrigin.port,
                "protocol": navigationAction.sourceFrame.securityOrigin.protocol
            ]
        ]
        
        var targetFrame: [String: Any] = [:]
        if let target = navigationAction.targetFrame {
            targetFrame["isMainFrame"] = target.isMainFrame
            targetFrame["request"] = ["url": target.request.url?.absoluteString ?? ""]
            targetFrame["securityOrigin"] = [
                "host": target.securityOrigin.host,
                "port": target.securityOrigin.port,
                "protocol": target.securityOrigin.protocol
            ]
        }
        
        arguments["navigationAction"] = [
            "request": request,
            "isForMainFrame": navigationAction.targetFrame?.isMainFrame ?? false,
            "hasGesture": navigationAction.navigationType == .linkActivated || navigationAction.navigationType == .formSubmitted,
            "isRedirect": false,
            "navigationType": navigationAction.navigationType.rawValue,
            "sourceFrame": sourceFrame,
            "targetFrame": targetFrame
        ]
        
        channel.invokeMethod("shouldOverrideUrlLoading", arguments: arguments) { result in
                    if let result = result as? Int {
                        if result == 0 {
                            decisionHandler(.cancel)
                            return
                        } else if result == 1 {
                            decisionHandler(.allow)
                            return
                        } else if result == 2 {
                            if #available(macOS 11.3, *) {
                                decisionHandler(.download)
                            } else {
                                decisionHandler(.cancel)
                            }
                            return
                        }
                    }
                    decisionHandler(.allow)
                }
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse, response.statusCode >= 400 {
            var arguments: [String: Any] = [:]
            arguments["request"] = [
                "url": response.url?.absoluteString ?? ""
            ]
            arguments["errorResponse"] = [
                "statusCode": response.statusCode,
                "reasonPhrase": HTTPURLResponse.localizedString(forStatusCode: response.statusCode),
                "headers": response.allHeaderFields
            ]
            channel.invokeMethod("onReceivedHttpError", arguments: arguments)
        }
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        var arguments: [String: Any] = [:]
        arguments["message"] = message
        arguments["url"] = frame.request.url?.absoluteString ?? ""
        arguments["isMainFrame"] = frame.isMainFrame
        arguments["iosIsMainFrame"] = frame.isMainFrame
        
        channel.invokeMethod("onJsAlert", arguments: arguments) { result in
            if let result = result as? [String: Any] {
                let handledByClient = result["handledByClient"] as? Bool ?? false
                if !handledByClient {
                    let alert = NSAlert()
                    alert.messageText = message
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                }
            } else {
                 let alert = NSAlert()
                 alert.messageText = message
                 alert.addButton(withTitle: "OK")
                 alert.runModal()
            }
            completionHandler()
        }
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        var arguments: [String: Any] = [:]
        arguments["message"] = message
        arguments["url"] = frame.request.url?.absoluteString ?? ""
        arguments["isMainFrame"] = frame.isMainFrame
        arguments["iosIsMainFrame"] = frame.isMainFrame

        channel.invokeMethod("onJsConfirm", arguments: arguments) { result in
            if let result = result as? [String: Any] {
                let handledByClient = result["handledByClient"] as? Bool ?? false
                if !handledByClient {
                    let alert = NSAlert()
                    alert.messageText = message
                    alert.addButton(withTitle: "OK")
                    alert.addButton(withTitle: "Cancel")
                    let res = alert.runModal()
                    completionHandler(res == .alertFirstButtonReturn)
                } else {
                    let action = result["action"] as? Int
                    completionHandler(action == 0)
                }
            } else {
                let alert = NSAlert()
                alert.messageText = message
                alert.addButton(withTitle: "OK")
                alert.addButton(withTitle: "Cancel")
                let res = alert.runModal()
                completionHandler(res == .alertFirstButtonReturn)
            }
        }
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        var arguments: [String: Any] = [:]
        arguments["message"] = prompt
        arguments["defaultValue"] = defaultText
        arguments["url"] = frame.request.url?.absoluteString ?? ""
        arguments["isMainFrame"] = frame.isMainFrame
        arguments["iosIsMainFrame"] = frame.isMainFrame

        channel.invokeMethod("onJsPrompt", arguments: arguments) { result in
            if let result = result as? [String: Any] {
                let handledByClient = result["handledByClient"] as? Bool ?? false
                if !handledByClient {
                    let alert = NSAlert()
                    alert.messageText = prompt
                    alert.addButton(withTitle: "OK")
                    alert.addButton(withTitle: "Cancel")
                    
                    let input = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
                    input.stringValue = defaultText ?? ""
                    alert.accessoryView = input
                    
                    let res = alert.runModal()
                    if res == .alertFirstButtonReturn {
                        completionHandler(input.stringValue)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    let action = result["action"] as? Int
                    let value = result["value"] as? String
                    if action == 0 {
                        completionHandler(value)
                    } else {
                        completionHandler(nil)
                    }
                }
            } else {
                let alert = NSAlert()
                alert.messageText = prompt
                alert.addButton(withTitle: "OK")
                alert.addButton(withTitle: "Cancel")
                
                let input = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
                input.stringValue = defaultText ?? ""
                alert.accessoryView = input
                
                let res = alert.runModal()
                if res == .alertFirstButtonReturn {
                    completionHandler(input.stringValue)
                } else {
                    completionHandler(nil)
                }
            }
        }
    }
}
