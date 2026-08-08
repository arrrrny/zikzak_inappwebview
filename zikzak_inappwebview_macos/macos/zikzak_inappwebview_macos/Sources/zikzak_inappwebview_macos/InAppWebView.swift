import Cocoa
import FlutterMacOS
import WebKit

public class InAppWebView: WKWebView, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate, NSMenuDelegate {
    var channel: FlutterMethodChannel!
    var registrar: FlutterPluginRegistrar
    var plugin: InAppWebViewFlutterPlugin?
    private var findInteractionChannel: FlutterMethodChannel!
    private var searchText: String?
    private var isDisposed = false
    public var settings: InAppWebViewSettings?
    var contextMenu: [String: Any]?
    var contextMenuIsShowing = false
    /// Retains ContextMenuItemTarget objects for the lifetime of the currently
    /// displayed menu so NSMenuItem targets are not deallocated before click.
    var contextMenuItemTargets: [ContextMenuItemTarget] = []

    private static var sslCertificatesMap: [String: SslCertificate] = [:]
    private static var credentialsProposed: [URLCredential] = []
    var channelDelegate: WebViewChannelDelegate?

    init(
        registrar: FlutterPluginRegistrar, viewId: Any, arguments: Any?, channelName: String? = nil, plugin: InAppWebViewFlutterPlugin? = nil
    ) {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        configuration.userContentController = userContentController

        super.init(frame: .zero, configuration: configuration)
        self.registrar = registrar
        self.plugin = plugin
        self.autoresizingMask = [.width, .height]
        self.navigationDelegate = self
        self.uiDelegate = self

        userContentController.add(WeakScriptMessageHandler(delegate: self), name: "consoleHandler")
        userContentController.add(
            WeakScriptMessageHandler(delegate: self), name: "onFindResultReceived")
        userContentController.add(
            WeakScriptMessageHandler(delegate: self), name: "callHandler")

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
        let userScript = WKUserScript(
            source: consoleOverrideScript, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userContentController.addUserScript(userScript)

        let bridgeScript = WKUserScript(
            source: JAVASCRIPT_BRIDGE_JS_SOURCE, injectionTime: .atDocumentStart,
            forMainFrameOnly: false)
        userContentController.addUserScript(bridgeScript)
        let printScript = WKUserScript(
            source: PRINT_JS_SOURCE, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        userContentController.addUserScript(printScript)

        let findInteractionUserScript = WKUserScript(
            source: FIND_TEXT_HIGHLIGHT_JS_SOURCE, injectionTime: .atDocumentStart,
            forMainFrameOnly: true)
        userContentController.addUserScript(findInteractionUserScript)

        let finalChannelName = channelName ?? "dev.zuzu/zikzak_inappwebview_\(viewId)"
        channel = FlutterMethodChannel(name: finalChannelName, binaryMessenger: registrar.messenger)
        channel.setMethodCallHandler(self.handle)
        channelDelegate = WebViewChannelDelegate(channel: channel)

        let findInteractionChannelName = "wtf.zikzak/zikzak_inappwebview_find_interaction_\(viewId)"
        findInteractionChannel = FlutterMethodChannel(
            name: findInteractionChannelName, binaryMessenger: registrar.messenger)
        findInteractionChannel.setMethodCallHandler(self.handleFindInteraction)

        if let args = arguments as? [String: Any] {
            if let initialUrlRequest = args["initialUrlRequest"] as? [String: Any] {
                let request = URLRequest(fromPluginMap: initialUrlRequest)
                self.load(request)
            }

            if let settingsMap = args["settings"] as? [String: Any?] {
                let newSettings = InAppWebViewSettings()
                let _ = newSettings.parse(settings: settingsMap)
                self.setSettings(
                    newSettings: newSettings, newSettingsMap: settingsMap as! [String: Any])
            }

            if let initialUserScripts = args["initialUserScripts"] as? [[String: Any]] {
                for scriptMap in initialUserScripts {
                    guard let source = scriptMap["source"] as? String else { continue }
                    let injectionTimeValue = scriptMap["injectionTime"] as? Int ?? 0
                    let forMainFrameOnly = scriptMap["forMainFrameOnly"] as? Bool ?? true
                    let wkInjectionTime: WKUserScriptInjectionTime =
                        injectionTimeValue == 1 ? .atDocumentEnd : .atDocumentStart
                    let userScript = WKUserScript(
                        source: source,
                        injectionTime: wkInjectionTime,
                        forMainFrameOnly: forMainFrameOnly)
                    userContentController.addUserScript(userScript)
                }
            }

            if let contextMenu = args["contextMenu"] as? [String: Any] {
                self.contextMenu = contextMenu
            }
        }

        self.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.addObserver(self, forKeyPath: "url", options: .new, context: nil)
        self.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }


    public func printCurrentPage(
        settings: PrintJobSettings? = nil
    ) -> String? {
        var printJobId: String? = nil
        if let settings = settings, settings.handledByClient {
            printJobId = UUID().uuidString
        }

        let printInfo = NSPrintInfo(dictionary: nil)
        printInfo.jobName =
            settings?.jobName ?? (title ?? url?.absoluteString ?? "") + " Document"
        if let settings = settings {
            if let orientationValue = settings.orientation,
               let orientation = NSPrintInfo.PaperOrientation.init(rawValue: orientationValue)
            {
                printInfo.orientation = orientation
            }
            if let duplexModeValue = settings.duplexMode,
               let duplexMode = NSPrintInfo.DuplexMode.init(rawValue: duplexModeValue)
            {
                printInfo.duplex = duplexMode
            }
            if let margins = settings.margins {
                printInfo.topMargin = margins.top
                printInfo.bottomMargin = margins.bottom
                printInfo.leftMargin = margins.left
                printInfo.rightMargin = margins.right
            }
        }

        let printOperation = NSPrintOperation(view: self, printInfo: printInfo)
        printOperation.showsPrintPanel = settings?.animated ?? true
        printOperation.showsProgressPanel = true

        let animated = settings?.animated ?? true
        if let id = printJobId, let plugin = plugin {
            let printJob = PrintJobController(
                plugin: plugin, id: id, printOperation: printOperation, settings: settings, webView: self)
            plugin.printJobManager?.jobs[id] = printJob
            printJob.present(animated: animated)
        } else {
            printOperation.run()
        }

        return printJobId
    }
    deinit {
        dispose()
    }

    public func dispose() {
        if !isDisposed {
            self.configuration.userContentController.removeScriptMessageHandler(
                forName: "consoleHandler")
            self.configuration.userContentController.removeScriptMessageHandler(
                forName: "onFindResultReceived")
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

    public override func layout() {
        super.layout()
        guard let superview = superview else { return }
        let targetFrame = superview.bounds
        if frame != targetFrame {
            frame = targetFrame
        }
    }

    public override func observeValue(
        forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard !isDisposed else { return }

        if keyPath == "estimatedProgress" {
            let progress = Int(self.estimatedProgress * 100)
            channel?.invokeMethod("onProgressChanged", arguments: ["progress": progress])
        } else if keyPath == "url" {
            var arguments: [String: Any] = ["isReload": false]
            if let url = self.url?.absoluteString {
                arguments["url"] = url
            }
            channel?.invokeMethod("onUpdateVisitedHistory", arguments: arguments)
        } else if keyPath == "title" {
            var arguments: [String: Any] = [:]
            if let title = self.title {
                arguments["title"] = title
            }
            channel?.invokeMethod("onTitleChanged", arguments: arguments)
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
                let urlRequest = args["urlRequest"] as? [String: Any]
            {
                let request = URLRequest(fromPluginMap: urlRequest)
                self.load(request)
                result(true)
            } else {
                result(
                    FlutterError(code: "InAppWebView", message: "Invalid arguments", details: nil))
            }
        case "loadData":
            if let args = call.arguments as? [String: Any],
                let data = args["data"] as? String,
                let baseUrl = args["baseUrl"] as? String
            {
                self.loadHTMLString(data, baseURL: URL(string: baseUrl))
                result(true)
            } else {
                result(
                    FlutterError(code: "InAppWebView", message: "Invalid arguments", details: nil))
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
                    result(
                        FlutterError(
                            code: "InAppWebView", message: error.localizedDescription, details: nil)
                    )
                } else {
                    result(value)
                }
            }
        case "createPdf":
            if #available(macOS 11.0, *) {
                let pdfConfiguration = WKPDFConfiguration()
                if let args = call.arguments as? [String: Any],
                    let configMap = args["pdfConfiguration"] as? [String: Any]
                {
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
                    case .failure(_):
                        result(nil)
                    }
                }
            } else {
                result(nil)
            }
        case "takeScreenshot":
            if #available(macOS 10.13, *) {
                var snapshotConfiguration: WKSnapshotConfiguration? = nil
                if let args = call.arguments as? [String: Any],
                    let configMap = args["screenshotConfiguration"] as? [String: Any?]
                {
                    snapshotConfiguration = WKSnapshotConfiguration()
                    if let rectMap = configMap["rect"] as? [String: Double] {
                        snapshotConfiguration!.rect = CGRect(
                            x: rectMap["x"] ?? 0,
                            y: rectMap["y"] ?? 0,
                            width: rectMap["width"] ?? 0,
                            height: rectMap["height"] ?? 0
                        )
                    }
                    if let snapshotWidth = configMap["snapshotWidth"] as? Double {
                        snapshotConfiguration!.snapshotWidth = NSNumber(value: snapshotWidth)
                    }
                    if let afterScreenUpdates = configMap["afterScreenUpdates"] as? Bool {
                        snapshotConfiguration!.afterScreenUpdates = afterScreenUpdates
                    }
                }

                self.takeSnapshot(with: snapshotConfiguration) { (image, error) -> Void in
                    var imageData: Data? = nil
                    if let screenshot = image {
                        if let configMap = (call.arguments as? [String: Any])?[
                            "screenshotConfiguration"] as? [String: Any?]
                        {
                            let compressFormat = configMap["compressFormat"] as? String ?? "PNG"
                            switch compressFormat {
                            case "JPEG":
                                let quality = Float((configMap["quality"] as? Int) ?? 100) / 100.0
                                if let tiffData = screenshot.tiffRepresentation,
                                    let bitmapRep = NSBitmapImageRep(data: tiffData)
                                {
                                    let properties: [NSBitmapImageRep.PropertyKey: Any] = [
                                        .compressionFactor: quality
                                    ]
                                    imageData = bitmapRep.representation(
                                        using: .jpeg, properties: properties)
                                }
                                break
                            case "PNG":
                                fallthrough
                            default:
                                if let tiffData = screenshot.tiffRepresentation,
                                    let bitmapRep = NSBitmapImageRep(data: tiffData)
                                {
                                    imageData = bitmapRep.representation(
                                        using: .png, properties: [:])
                                }
                            }
                        } else {
                            if let tiffData = screenshot.tiffRepresentation,
                                let bitmapRep = NSBitmapImageRep(data: tiffData)
                            {
                                imageData = bitmapRep.representation(using: .png, properties: [:])
                            }
                        }
                    }
                    result(imageData)
                }
            } else {
                result(nil)
            }
        case "evaluateJavascript":
            if let args = call.arguments as? [String: Any],
                let source = args["source"] as? String
            {
                self.evaluateJavaScript(source) { (value, error) in
                    if let error = error {
                        result(
                            FlutterError(
                                code: "InAppWebView", message: error.localizedDescription,
                                details: nil))
                    } else {
                        // WKWebView returns nil for undefined/void/Promise results.
                        // Return NSNull() so Dart receives null instead of crashing with
                        // "JavaScript execution returned a result of an unsupported type".
                        result(value ?? NSNull())
                    }
                }
            } else {
                result(
                    FlutterError(code: "InAppWebView", message: "Invalid arguments", details: nil))
            }
        case "setSettings":
            if let args = call.arguments as? [String: Any],
                let settingsMap = args["settings"] as? [String: Any?]
            {
                let newSettings = InAppWebViewSettings()
                let _ = newSettings.parse(settings: settingsMap)
                self.setSettings(
                    newSettings: newSettings, newSettingsMap: settingsMap as! [String: Any])
                result(true)
            } else {
                result(
                    FlutterError(code: "InAppWebView", message: "Invalid arguments", details: nil))
            }
        case "getSettings":
            if let settings = self.settings {
                result(settings.getRealSettings(obj: self))
            } else {
                result([String: Any?]())
            }
        case "printCurrentPage":
            if let args = call.arguments as? [String: Any],
               let settingsMap = args["settings"] as? [String: Any?] {
                let settings = PrintJobSettings()
                let _ = settings.parse(settings: settingsMap)
                result(self.printCurrentPage(settings: settings))
            } else {
                result(self.printCurrentPage())
            }
            break
        case "setContextMenu":
            if let args = call.arguments as? [String: Any] {
                self.contextMenu = args["contextMenu"] as? [String: Any]
                result(true)
            } else {
                result(false)
            }
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func setSettings(newSettings: InAppWebViewSettings, newSettingsMap: [String: Any]) {
        if newSettingsMap["userAgent"] != nil
            && settings?.userAgent != newSettings.userAgent
            && newSettings.userAgent != ""
        {
            customUserAgent = newSettings.userAgent
        }

        if newSettingsMap["applicationNameForUserAgent"] != nil
            && settings?.applicationNameForUserAgent != newSettings.applicationNameForUserAgent
            && newSettings.applicationNameForUserAgent != ""
        {
            configuration.applicationNameForUserAgent = newSettings.applicationNameForUserAgent
        }

        if newSettingsMap["javaScriptEnabled"] != nil
            && settings?.javaScriptEnabled != newSettings.javaScriptEnabled
        {
            configuration.preferences.javaScriptEnabled = newSettings.javaScriptEnabled
        }

        if newSettingsMap["javaScriptCanOpenWindowsAutomatically"] != nil
            && settings?.javaScriptCanOpenWindowsAutomatically
                != newSettings.javaScriptCanOpenWindowsAutomatically
        {
            configuration.preferences.javaScriptCanOpenWindowsAutomatically =
                newSettings.javaScriptCanOpenWindowsAutomatically
        }

        if newSettingsMap["suppressesIncrementalRendering"] != nil
            && settings?.suppressesIncrementalRendering
                != newSettings.suppressesIncrementalRendering
        {
            configuration.suppressesIncrementalRendering =
                newSettings.suppressesIncrementalRendering
        }

        if newSettingsMap["allowsBackForwardNavigationGestures"] != nil
            && settings?.allowsBackForwardNavigationGestures
                != newSettings.allowsBackForwardNavigationGestures
        {
            allowsBackForwardNavigationGestures = newSettings.allowsBackForwardNavigationGestures
        }

        if newSettingsMap["allowsLinkPreview"] != nil
            && settings?.allowsLinkPreview != newSettings.allowsLinkPreview
        {
            allowsLinkPreview = newSettings.allowsLinkPreview
        }

        if newSettingsMap["allowsAirPlayForMediaPlayback"] != nil
            && settings?.allowsAirPlayForMediaPlayback != newSettings.allowsAirPlayForMediaPlayback
        {
            configuration.allowsAirPlayForMediaPlayback = newSettings.allowsAirPlayForMediaPlayback
        }

        if newSettingsMap["minimumFontSize"] != nil
            && settings?.minimumFontSize != newSettings.minimumFontSize
        {
            configuration.preferences.minimumFontSize = CGFloat(newSettings.minimumFontSize)
        }

        if #available(macOS 10.12, *) {
            if newSettingsMap["mediaPlaybackRequiresUserGesture"] != nil
                && settings?.mediaPlaybackRequiresUserGesture
                    != newSettings.mediaPlaybackRequiresUserGesture
            {
                configuration.mediaTypesRequiringUserActionForPlayback =
                    newSettings.mediaPlaybackRequiresUserGesture ? .all : []
            }
        }

        // allowsInlineMediaPlayback is not available on macOS

        if newSettingsMap["allowUniversalAccessFromFileURLs"] != nil
            && settings?.allowUniversalAccessFromFileURLs
                != newSettings.allowUniversalAccessFromFileURLs
        {
            configuration.setValue(
                newSettings.allowUniversalAccessFromFileURLs,
                forKey: "allowUniversalAccessFromFileURLs")
        }

        if newSettingsMap["allowFileAccessFromFileURLs"] != nil
            && settings?.allowFileAccessFromFileURLs != newSettings.allowFileAccessFromFileURLs
        {
            configuration.preferences.setValue(
                newSettings.allowFileAccessFromFileURLs, forKey: "allowFileAccessFromFileURLs")
        }

        if newSettingsMap["transparentBackground"] != nil
            && settings?.transparentBackground != newSettings.transparentBackground
        {
            if newSettings.transparentBackground {
                self.setValue(false, forKey: "drawsBackground")
                self.layer?.backgroundColor = NSColor.clear.cgColor
            } else {
                self.setValue(true, forKey: "drawsBackground")
                self.layer?.backgroundColor = nil
            }
        }

        if newSettingsMap["incognito"] != nil && settings?.incognito != newSettings.incognito
            && newSettings.incognito
        {
            configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        } else if newSettingsMap["cacheEnabled"] != nil
            && settings?.cacheEnabled != newSettings.cacheEnabled && newSettings.cacheEnabled
        {
            configuration.websiteDataStore = WKWebsiteDataStore.default()
        }

        if #available(macOS 11.0, *) {
            if newSettingsMap["pageZoom"] != nil && settings?.pageZoom != newSettings.pageZoom {
                pageZoom = CGFloat(newSettings.pageZoom)
            }
            if newSettingsMap["limitsNavigationsToAppBoundDomains"] != nil
                && settings?.limitsNavigationsToAppBoundDomains
                    != newSettings.limitsNavigationsToAppBoundDomains
            {
                configuration.limitsNavigationsToAppBoundDomains =
                    newSettings.limitsNavigationsToAppBoundDomains
            }
            if newSettingsMap["mediaType"] != nil && settings?.mediaType != newSettings.mediaType {
                mediaType = newSettings.mediaType
            }
        }

        if #available(macOS 13.3, *) {
            if newSettingsMap["isTextInteractionEnabled"] != nil
                && settings?.isTextInteractionEnabled != newSettings.isTextInteractionEnabled
            {
                configuration.preferences.isTextInteractionEnabled =
                    newSettings.isTextInteractionEnabled
            }
            if newSettingsMap["upgradeKnownHostsToHTTPS"] != nil
                && settings?.upgradeKnownHostsToHTTPS != newSettings.upgradeKnownHostsToHTTPS
            {
                configuration.upgradeKnownHostsToHTTPS = newSettings.upgradeKnownHostsToHTTPS
            }
            if newSettingsMap["underPageBackgroundColor"] != nil
                && settings?.underPageBackgroundColor != newSettings.underPageBackgroundColor
                && newSettings.underPageBackgroundColor != nil
                && !newSettings.underPageBackgroundColor!.isEmpty
            {
                self.underPageBackgroundColor = NSColor(
                    hexString: newSettings.underPageBackgroundColor!)
            }
        }

        if #available(macOS 14.0, *) {
            if newSettingsMap["isInspectable"] != nil
                && settings?.isInspectable != newSettings.isInspectable
            {
                self.isInspectable = newSettings.isInspectable
            }
            if newSettingsMap["shouldPrintBackgrounds"] != nil
                && settings?.shouldPrintBackgrounds != newSettings.shouldPrintBackgrounds
            {
                configuration.preferences.shouldPrintBackgrounds =
                    newSettings.shouldPrintBackgrounds
            }
        }

        if newSettingsMap["clearCache"] != nil && newSettings.clearCache {
            clearCache()
        }

        self.settings = newSettings
    }

    func clearCache() {
        let dataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let date = Date(timeIntervalSince1970: 0)
        configuration.websiteDataStore.removeData(
            ofTypes: dataTypes, modifiedSince: date, completionHandler: {})
    }

    public func webView(
        _ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!
    ) {
        channel?.invokeMethod("onLoadStart", arguments: ["url": webView.url?.absoluteString])
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        InAppWebView.credentialsProposed = []
        channel?.invokeMethod("onLoadStop", arguments: ["url": webView.url?.absoluteString])
    }

    public func webView(
        _ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error
    ) {
        InAppWebView.credentialsProposed = []
        onReceivedError(error: error)
    }

    public func webView(
        _ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        InAppWebView.credentialsProposed = []
        onReceivedError(error: error)
    }

    private func onReceivedError(error: Error) {
        var arguments: [String: Any] = [:]
        arguments["url"] = self.url?.absoluteString
        arguments["code"] = (error as NSError).code
        arguments["message"] = error.localizedDescription
        channel?.invokeMethod("onReceivedError", arguments: arguments)
    }
    public func webView(
        _ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        var completionHandlerCalled = false
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic
            || challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodDefault
            || challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPDigest
            || challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNegotiate
            || challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNTLM
        {
            let host = challenge.protectionSpace.host
            let prot = challenge.protectionSpace.protocol
            let realm = challenge.protectionSpace.realm
            let port = challenge.protectionSpace.port

            let callback = WebViewChannelDelegate.ReceivedHttpAuthRequestCallback()
            callback.nonNullSuccess = { (response: HttpAuthResponse) in
                if let action = response.action {
                    completionHandlerCalled = true
                    switch action {
                    case 0:
                        InAppWebView.credentialsProposed = []
                        completionHandler(.performDefaultHandling, nil)
                        break
                    case 1:
                        let username = response.username
                        let password = response.password
                        let permanentPersistence = response.permanentPersistence
                        let persistence =
                            (permanentPersistence)
                            ? URLCredential.Persistence.permanent
                            : URLCredential.Persistence.forSession
                        let credential = URLCredential(
                            user: username, password: password, persistence: persistence)
                        completionHandler(.useCredential, credential)
                        break
                    case 2:
                        if InAppWebView.credentialsProposed.count == 0 {
                            for (protectionSpace, credentials) in CredentialDatabase.credentialStore
                                .allCredentials
                            {
                                if protectionSpace.host == host && protectionSpace.realm == realm
                                    && protectionSpace.protocol == prot
                                    && protectionSpace.port == port
                                {
                                    for credential in credentials {
                                        InAppWebView.credentialsProposed.append(credential.value)
                                    }
                                    break
                                }
                            }
                        }
                        if InAppWebView.credentialsProposed.count == 0,
                            let credential = challenge.proposedCredential
                        {
                            InAppWebView.credentialsProposed.append(credential)
                        }

                        if let credential = InAppWebView.credentialsProposed.popLast() {
                            completionHandler(.useCredential, credential)
                        } else {
                            completionHandler(.performDefaultHandling, nil)
                        }
                        break
                    default:
                        InAppWebView.credentialsProposed = []
                        completionHandler(.performDefaultHandling, nil)
                    }
                    return false
                }
                return true
            }
            callback.defaultBehaviour = { (response: HttpAuthResponse?) in
                if !completionHandlerCalled {
                    completionHandlerCalled = true
                    completionHandler(.performDefaultHandling, nil)
                }
            }
            callback.error = { [weak callback] (code: String, message: String?, details: Any?) in
                print(code + ", " + (message ?? ""))
                callback?.defaultBehaviour(nil)
            }

            let runCallback = {
                if let channelDelegate = self.channelDelegate {
                    channelDelegate.onReceivedHttpAuthRequest(
                        challenge: HttpAuthenticationChallenge(fromChallenge: challenge),
                        callback: callback)
                } else {
                    callback.defaultBehaviour(nil)
                }
            }

            runCallback()
        } else if challenge.protectionSpace.authenticationMethod
            == NSURLAuthenticationMethodServerTrust
        {
            guard let serverTrust = challenge.protectionSpace.serverTrust else {
                completionHandler(.performDefaultHandling, nil)
                return
            }

            if let scheme = challenge.protectionSpace.protocol, scheme == "https" {
                DispatchQueue.global(qos: .background).async {
                    if let sslCertificate = challenge.protectionSpace.sslCertificate {
                        DispatchQueue.main.async {
                            InAppWebView.sslCertificatesMap[challenge.protectionSpace.host] =
                                sslCertificate
                        }
                    }
                }
            }

            let callback = WebViewChannelDelegate.ReceivedServerTrustAuthRequestCallback()
            callback.nonNullSuccess = { (response: ServerTrustAuthResponse) in
                if let action = response.action {
                    completionHandlerCalled = true
                    switch action {
                    case 0:
                        InAppWebView.credentialsProposed = []
                        completionHandler(.cancelAuthenticationChallenge, nil)
                        break
                    case 1:
                        DispatchQueue.global(qos: .background).async {
                            let exceptions = SecTrustCopyExceptions(serverTrust)
                            SecTrustSetExceptions(serverTrust, exceptions)
                            let credential = URLCredential(trust: serverTrust)
                            completionHandler(.useCredential, credential)
                        }
                        break
                    default:
                        InAppWebView.credentialsProposed = []
                        completionHandler(.performDefaultHandling, nil)
                    }
                    return false
                }
                return true
            }
            callback.defaultBehaviour = { (response: ServerTrustAuthResponse?) in
                if !completionHandlerCalled {
                    completionHandlerCalled = true
                    completionHandler(.performDefaultHandling, nil)
                }
            }
            callback.error = { [weak callback] (code: String, message: String?, details: Any?) in
                print(code + ", " + (message ?? ""))
                callback?.defaultBehaviour(nil)
            }

            let runCallback = {
                if let channelDelegate = self.channelDelegate {
                    channelDelegate.onReceivedServerTrustAuthRequest(
                        challenge: ServerTrustChallenge(fromChallenge: challenge),
                        callback: callback)
                } else {
                    callback.defaultBehaviour(nil)
                }
            }

            runCallback()
        } else if challenge.protectionSpace.authenticationMethod
            == NSURLAuthenticationMethodClientCertificate
        {
            let callback = WebViewChannelDelegate.ReceivedClientCertRequestCallback()
            callback.nonNullSuccess = { (response: ClientCertResponse) in
                if let action = response.action {
                    completionHandlerCalled = true
                    switch action {
                    case 0:
                        completionHandler(.cancelAuthenticationChallenge, nil)
                        break
                    case 1:
                        let certificatePath = response.certificatePath
                        let certificatePassword = response.certificatePassword ?? ""

                        var path: String = certificatePath
                        do {
                            if let plugin = self.plugin {
                                path = try Util.getAbsPathAsset(
                                    plugin: plugin, assetFilePath: certificatePath)
                            }
                        } catch {}

                        if let PKCS12Data = NSData(contentsOfFile: path),
                            let identityAndTrust: IdentityAndTrust = self.extractIdentity(
                                PKCS12Data: PKCS12Data, password: certificatePassword)
                        {
                            let urlCredential: URLCredential = URLCredential(
                                identity: identityAndTrust.identityRef,
                                certificates: identityAndTrust.certArray as? [AnyObject],
                                persistence: URLCredential.Persistence.forSession)
                            completionHandler(.useCredential, urlCredential)
                        } else {
                            completionHandler(.performDefaultHandling, nil)
                        }

                        break
                    case 2:
                        completionHandler(.cancelAuthenticationChallenge, nil)
                        break
                    default:
                        completionHandler(.performDefaultHandling, nil)
                    }
                    return false
                }
                return true
            }
            callback.defaultBehaviour = { (response: ClientCertResponse?) in
                if !completionHandlerCalled {
                    completionHandlerCalled = true
                    completionHandler(.performDefaultHandling, nil)
                }
            }
            callback.error = { [weak callback] (code: String, message: String?, details: Any?) in
                print(code + ", " + (message ?? ""))
                callback?.defaultBehaviour(nil)
            }

            let runCallback = {
                if let channelDelegate = self.channelDelegate {
                    channelDelegate.onReceivedClientCertRequest(
                        challenge: ClientCertChallenge(fromChallenge: challenge), callback: callback
                    )
                } else {
                    callback.defaultBehaviour(nil)
                }
            }

            runCallback()
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }

    struct IdentityAndTrust {
        var identityRef: SecIdentity
        var trust: SecTrust
        var certArray: AnyObject
    }

    func extractIdentity(PKCS12Data: NSData, password: String) -> IdentityAndTrust? {
        var identityAndTrust: IdentityAndTrust?
        var securityError: OSStatus = errSecSuccess

        var importResult: CFArray?
        securityError = SecPKCS12Import(
            PKCS12Data as NSData,
            [kSecImportExportPassphrase as String: password] as NSDictionary,
            &importResult
        )

        if securityError == errSecSuccess {
            let certItems: CFArray = importResult! as CFArray
            let certItemsArray: Array = certItems as Array
            let dict: AnyObject? = certItemsArray.first
            if let certEntry: Dictionary = dict as? [String: AnyObject] {
                let identityPointer: AnyObject? = certEntry["identity"]
                let secIdentityRef: SecIdentity = (identityPointer as! SecIdentity?)!
                let trustPointer: AnyObject? = certEntry["trust"]
                let trustRef: SecTrust = trustPointer as! SecTrust
                let chainPointer: AnyObject? = certEntry["chain"]
                identityAndTrust = IdentityAndTrust(
                    identityRef: secIdentityRef, trust: trustRef, certArray: chainPointer!)
            }
        } else {
            print("Security Error: " + securityError.description)
        }
        return identityAndTrust
    }


    public func userContentController(
        _ userContentController: WKUserContentController, didReceive message: WKScriptMessage
    ) {
        if message.name == "consoleHandler", let body = message.body as? [String: Any] {
            var arguments: [String: Any] = [:]
            arguments["message"] = (body["message"] as? String) ?? ""

            var level = 1  // LOG
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
            channel?.invokeMethod("onConsoleMessage", arguments: arguments)
        } else if message.name == "callHandler",
            let bodyString = message.body as? String,
            let bodyData = bodyString.data(using: .utf8),
            let body = try? JSONSerialization.jsonObject(with: bodyData) as? [String: Any]
        {
            let handlerName = body["handlerName"] as? String ?? ""
            if handlerName == "onPrintRequest" {
                let url = self.url
                let settings = PrintJobSettings()
                settings.handledByClient = true
                if let printJobId = printCurrentPage(settings: settings) {
                    channel?.invokeMethod("onPrintRequest", arguments: [
                        "url": url?.absoluteString,
                        "printJobId": printJobId
                    ]) { (result) in
                        if let handledByClient = result as? Bool, !handledByClient {
                            if let printJob = self.plugin?.printJobManager?.jobs[printJobId] {
                                printJob?.dispose()
                            }
                        }
                    }
                }
                return
            }
            let _callHandlerID = body["_callHandlerID"] as? Int64 ?? 0
            let args = body["args"] as? String ?? ""

            channel?.invokeMethod(
                "callHandler",
                arguments: [
                    "handlerName": handlerName,
                    "args": args,
                ]
            ) { (result) in
                if let error = result as? FlutterError {
                    let escapedError =
                        error.message?.replacingOccurrences(of: "'", with: "\\\\'")
                        ?? "Unknown error"
                    self.evaluateJavaScript(
                        """
                            if(window.\(JAVASCRIPT_BRIDGE_NAME)[\(_callHandlerID)] != null) {
                                window.\(JAVASCRIPT_BRIDGE_NAME)[\(_callHandlerID)].reject(new Error('\(escapedError)'));
                                delete window.\(JAVASCRIPT_BRIDGE_NAME)[\(_callHandlerID)];
                            }
                        """, completionHandler: nil)
                } else if FlutterMethodNotImplemented.isEqual(to: result) {
                    self.evaluateJavaScript(
                        """
                            if(window.\(JAVASCRIPT_BRIDGE_NAME)[\(_callHandlerID)] != null) {
                                window.\(JAVASCRIPT_BRIDGE_NAME)[\(_callHandlerID)].reject(new Error('Method not implemented'));
                                delete window.\(JAVASCRIPT_BRIDGE_NAME)[\(_callHandlerID)];
                            }
                        """, completionHandler: nil)
                } else {
                    var json: String
                    if let resultData = try? JSONSerialization.data(
                        withJSONObject: result ?? NSNull(), options: []),
                        let resultString = String(data: resultData, encoding: .utf8)
                    {
                        json = resultString
                    } else if let simpleResult = result {
                        json = "\"\(simpleResult)\""
                    } else {
                        json = "null"
                    }
                    self.evaluateJavaScript(
                        """
                            if(window.\(JAVASCRIPT_BRIDGE_NAME)[\(_callHandlerID)] != null) {
                                window.\(JAVASCRIPT_BRIDGE_NAME)[\(_callHandlerID)].resolve(\(json));
                                delete window.\(JAVASCRIPT_BRIDGE_NAME)[\(_callHandlerID)];
                            }
                        """, completionHandler: nil)
                }
            }
        } else if message.name == "onFindResultReceived", let body = message.body as? [String: Any]
        {
            findInteractionChannel?.invokeMethod("onFindResultReceived", arguments: body)
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
            if let args = call.arguments as? [String: Any],
                let searchText = args["searchText"] as? String
            {
                self.searchText = searchText
            }
            result(true)
        case "getSearchText":
            result(self.searchText)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func webView(
        _ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        var arguments: [String: Any] = [:]
        let request: [String: Any] = [
            "url": navigationAction.request.url?.absoluteString ?? "",
            "method": navigationAction.request.httpMethod ?? "GET",
            "headers": navigationAction.request.allHTTPHeaderFields ?? [:],
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
                "protocol": navigationAction.sourceFrame.securityOrigin.protocol,
            ],
        ]

        var targetFrame: [String: Any] = [:]
        if let target = navigationAction.targetFrame {
            targetFrame["isMainFrame"] = target.isMainFrame
            targetFrame["request"] = ["url": target.request.url?.absoluteString ?? ""]
            targetFrame["securityOrigin"] = [
                "host": target.securityOrigin.host,
                "port": target.securityOrigin.port,
                "protocol": target.securityOrigin.protocol,
            ]
        }

        arguments["navigationAction"] = [
            "request": request,
            "isForMainFrame": navigationAction.targetFrame?.isMainFrame ?? false,
            "hasGesture": navigationAction.navigationType == .linkActivated
                || navigationAction.navigationType == .formSubmitted,
            "isRedirect": false,
            "navigationType": navigationAction.navigationType.rawValue,
            "sourceFrame": sourceFrame,
            "targetFrame": targetFrame,
        ]

        // Honor `useShouldOverrideUrlLoading` opt-in (mirrors iOS). When the
        // Dart side has not enabled the callback, fall through to the default
        // `.allow` policy without round-tripping through the method channel.
        let useShouldOverrideUrlLoading =
            (settings?.useShouldOverrideUrlLoading == true)
        guard useShouldOverrideUrlLoading else {
            decisionHandler(.allow)
            return
        }

        guard let channel = self.channel else {
            decisionHandler(.allow)
            return
        }

        // Await the Dart-side `shouldOverrideUrlLoading` callback before
        // resolving the navigation policy. Previously this was invoked
        // fire-and-forget and `decisionHandler(.allow)` was called
        // unconditionally, so the user's `NavigationActionPolicy.CANCEL`
        // (e.g. to block `intent:` or custom schemes) was silently ignored.
        //
        // The Dart handler returns the `NavigationActionPolicy` native int:
        //   0 = CANCEL, 1 = ALLOW, 2 = DOWNLOAD (iOS 14.5+ only — not yet
        //   exposed on macOS; treat as CANCEL to honor the user's intent to
        //   block rather than silently allow).
        var decisionHandlerCalled = false
        let resolvePolicy: (WKNavigationActionPolicy) -> Void = { policy in
            guard !decisionHandlerCalled else { return }
            decisionHandlerCalled = true
            decisionHandler(policy)
        }

        channel.invokeMethod(
            "shouldOverrideUrlLoading",
            arguments: arguments
        ) { result in
            let policy: WKNavigationActionPolicy
            if let action = result as? Int {
                switch action {
                case 1:
                    policy = .allow
                case 0, 2:
                    // 0 = CANCEL; 2 = DOWNLOAD (not supported on macOS yet —
                    // fall back to CANCEL so we never silently allow a
                    // navigation the user explicitly tried to block).
                    policy = .cancel
                default:
                    policy = .cancel
                }
            } else if let action = result as? NSNumber {
                // The Flutter channel may surface the int as NSNumber on
                // macOS. Normalize before comparing.
                switch action.intValue {
                case 1: policy = .allow
                default: policy = .cancel
                }
            } else {
                // Dart side returns ALLOW (1) when no callback is registered
                // and CANCEL (0) when the callback returns null. Any other
                // shape is treated as a safe-default CANCEL so a buggy
                // handler can never accidentally allow a blocked scheme.
                policy = .cancel
            }
            resolvePolicy(policy)
        }
    }

    public func webView(
        _ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        if let response = navigationResponse.response as? HTTPURLResponse,
            response.statusCode >= 400
        {
            var arguments: [String: Any] = [:]
            arguments["request"] = [
                "url": response.url?.absoluteString ?? ""
            ]
            arguments["errorResponse"] = [
                "statusCode": response.statusCode,
                "reasonPhrase": HTTPURLResponse.localizedString(forStatusCode: response.statusCode),
                "headers": response.allHeaderFields,
            ]
            channel?.invokeMethod("onReceivedHttpError", arguments: arguments)
        }
        decisionHandler(.allow)
    }

    public func webView(
        _ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void
    ) {
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

    public func webView(
        _ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void
    ) {
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

    public func webView(
        _ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String,
        defaultText: String?, initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (String?) -> Void
    ) {
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

    // MARK: - Context Menu (WKUIDelegate)

    @available(macOS 12.0, *)
    public func webView(
        _ webView: WKWebView,
        contextMenuForElement elementInfo: WKContextMenuElementInfo,
        willDisplayWithHighlight highlight: Bool
    ) -> NSMenu? {
        // 1. Honor `disableContextMenu` — suppress the menu entirely but still
        //    fire onCreateContextMenu so Dart parity with iOS/Android is kept.
        //    We invoke the channel directly (bypassing `onCreateContextMenu(...)`
        //    which would set `contextMenuIsShowing = true`): no NSMenu is shown,
        //    so `menuDidClose(_:)` never fires and the flag would otherwise stay
        //    true forever. iOS uses a separate debounce flag for the same reason.
        if settings?.disableContextMenu == true {
            let hit = hitTestResult(for: elementInfo)
            channel?.invokeMethod("onCreateContextMenu", arguments: hit.toMap())
            return nil
        }

        // 2. Honor `disableLongPressContextMenuOnLinks` — on macOS the right-click
        //    menu on a link is the equivalent of the iOS long-press menu on links.
        //    When the setting is true and the hit element is a link, suppress.
        if settings?.disableLongPressContextMenuOnLinks == true,
           elementInfo.linkURL != nil
        {
            return nil
        }

        let hitTestResult = self.hitTestResult(for: elementInfo)
        onCreateContextMenu(hitTestResult: hitTestResult)

        // 3. Build the menu. If no custom contextMenu was set via Dart, return nil
        //    so WebKit shows its default menu (and we still fired onCreateContextMenu).
        guard let menu = self.contextMenu else {
            return nil
        }

        let contextMenuSettings = ContextMenuSettings()
        if let contextMenuSettingsMap = menu["settings"] as? [String: Any?] {
            let _ = contextMenuSettings.parse(settings: contextMenuSettingsMap)
        }

        let customMenu = NSMenu()
        contextMenuItemTargets = []

        if let menuItems = menu["menuItems"] as? [[String: Any]] {
            for menuItem in menuItems {
                guard let id = menuItem["id"] else {
                    // Skip items without an id — Dart's `assert(id != null)`
                    // is stripped in release builds, so we must guard here.
                    continue
                }
                let title = menuItem["title"] as? String ?? ""
                let target = ContextMenuItemTarget(id: id, title: title) { [weak self] itemId, itemTitle in
                    self?.onContextMenuActionItemClicked(id: itemId, title: itemTitle)
                }
                contextMenuItemTargets.append(target)
                let item = NSMenuItem(
                    title: title,
                    action: #selector(ContextMenuItemTarget.itemClicked),
                    keyEquivalent: "")
                item.target = target
                customMenu.addItem(item)
            }
        }

        // WKWebView does not expose its default NSMenu, so we cannot append
        // custom items to the system items — when any custom items are present
        // they *replace* the default menu. `hideDefaultSystemContextMenuItems`
        // therefore only changes behavior when there are NO custom items:
        //   true  + no custom items => suppress the menu entirely (return nil)
        //   false + no custom items => let WebKit show its default menu (also
        //                              return nil here; we cannot fetch defaults
        //                              without dropping the uiDelegate — see note)
        // To literally merge with defaults you would need to temporarily nil-out
        // `webView.uiDelegate`, ask WebKit for the default menu, then restore
        // the delegate — left as a follow-up.
        if customMenu.items.isEmpty {
            return nil
        }
        customMenu.delegate = self
        return customMenu
    }

    /// Builds a `HitTestResult` from the `WKContextMenuElementInfo` provided by
    /// WebKit. Maps linkURL/imageURL to the same `HitTestResultType` values used
    /// on iOS so Dart receives a consistent result across platforms.
    private func hitTestResult(for elementInfo: WKContextMenuElementInfo) -> HitTestResult {
        let linkURL = elementInfo.linkURL?.absoluteString
        let imageURL = elementInfo.imageURL?.absoluteString

        var type: HitTestResultType = .unknownType
        var extra: String? = nil

        if let link = linkURL, let image = imageURL, !link.isEmpty, !image.isEmpty {
            type = .srcImageAnchorType
            extra = link
        } else if let image = imageURL, !image.isEmpty {
            type = .imageType
            extra = image
        } else if let link = linkURL, !link.isEmpty {
            if link.hasPrefix("mailto:") {
                type = .emailType
                extra = String(link.dropFirst("mailto:".count))
            } else if link.hasPrefix("tel:") {
                type = .phoneType
                extra = String(link.dropFirst("tel:".count))
            } else if link.hasPrefix("geo:") {
                type = .geoType
                extra = String(link.dropFirst("geo:".count))
            } else {
                type = .srcAnchorType
                extra = link
            }
        }

        return HitTestResult(type: type, extra: extra)
    }

    // MARK: - NSMenuDelegate

    public func menuDidClose(_ menu: NSMenu) {
        onHideContextMenu()
    }

    // MARK: - Context Menu channel events

    func onCreateContextMenu(hitTestResult: HitTestResult) {
        contextMenuIsShowing = true
        channel?.invokeMethod("onCreateContextMenu", arguments: hitTestResult.toMap())
    }

    func onHideContextMenu() {
        if !contextMenuIsShowing {
            return
        }
        contextMenuIsShowing = false
        contextMenuItemTargets = []
        let arguments: [String: Any?] = [:]
        channel?.invokeMethod("onHideContextMenu", arguments: arguments)
    }

    func onContextMenuActionItemClicked(id: Any, title: String) {
        let arguments: [String: Any?] = [
            "id": id,
            "iosId": id is Int64 ? String(id as! Int64) : (id as? String),
            "androidId": nil,
            "title": title,
        ]
        channel?.invokeMethod("onContextMenuActionItemClicked", arguments: arguments)
        // After a custom item is clicked, fire onHideContextMenu to match iOS.
        onHideContextMenu()
    }
}
