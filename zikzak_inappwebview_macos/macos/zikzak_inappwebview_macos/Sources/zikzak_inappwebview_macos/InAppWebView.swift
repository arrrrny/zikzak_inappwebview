import Cocoa
import FlutterMacOS
import WebKit

public class InAppWebView: WKWebView, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate, NSMenuDelegate {
    var channel: FlutterMethodChannel!
    var registrar: FlutterPluginRegistrar? = nil
    var plugin: InAppWebViewFlutterPlugin?
    private var findInteractionChannel: FlutterMethodChannel!
    private var searchText: String?
    private var isDisposed = false
    public var settings: InAppWebViewSettings?
    var contextMenu: [String: Any]?
    var contextMenuIsShowing = false

    /// Set by the WKUIDelegate when returning `nil` from
    /// `webView(_:contextMenuForElement:willDisplayWithHighlight:)` in the
    /// cases where we want to actually suppress the menu (not let WebKit
    /// show its default NSMenu). Consumed by `willOpenMenu(_:with:)`, which
    /// cancels tracking on the upcoming default menu.
    ///
    /// Currently set when `hideDefaultSystemContextMenuItems == true` and no
    /// custom menu items are present (the only case where the setting is
    /// observable on macOS — when custom items exist they already *replace*
    /// the default menu, so there's nothing to hide).
    var suppressDefaultMenuNext = false
    /// Retains ContextMenuItemTarget objects for the lifetime of the currently
    /// displayed menu so NSMenuItem targets are not deallocated before click.
    var contextMenuItemTargets: [ContextMenuItemTarget] = []

    private static var sslCertificatesMap: [String: SslCertificate] = [:]
    private static var credentialsProposed: [URLCredential] = []
    var channelDelegate: WebViewChannelDelegate?

    // MARK: - Issue #197 state (method-channel parity with iOS)

    /// Active `WebMessageChannel` instances, keyed by id. Populated by
    /// `createWebMessageChannel`; the Dart side holds the matching id.
    var webMessageChannels: [String: WebMessageChannel] = [:]

    /// Active `WebMessageListener` instances, keyed by id.
    var webMessageListeners: [String: WebMessageListener] = [:]

    /// `pauseTimers` / `resumeTimers` use the same alert()-based hack the iOS
    /// port uses (WebKit has no public "pause JS timers" API).
    private var isPausedTimers = false
    private var isPausedTimersCompletionHandler: (() -> Void)?

    /// Last right-click location in view coordinates. macOS has no long-press
    /// gesture; right-click is the closest equivalent and is what we use to
    /// fire `onLongPressHitTestResult` and back `getHitTestResult`.
    private var lastRightClickPoint: NSPoint?

    /// User scripts added via the Dart `addUserScript` API. WKUserContentController
    /// has no group concept and no single-script removal, so we track the
    /// `(groupName, WKUserScript)` list here and rebuild the controller on
    /// removal. Mirrors the iOS `userOnlyScripts` OrderedSet.
    private var userOnlyScripts: [UserScript] = []

    /// Tracked for `onZoomScaleChanged` KVO (macOS `pageZoom`, macOS 11+).
    private var lastPageZoom: CGFloat = 1.0

    /// Tracked for `onScrollChanged` / `onOverScrolled` (debounced via JS).
    private var lastScrollX: Int = 0
    private var lastScrollY: Int = 0

    init(
        registrar: FlutterPluginRegistrar, viewId: Any, arguments: Any?, channelName: String? = nil, plugin: InAppWebViewFlutterPlugin? = nil
    ) {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        configuration.userContentController = userContentController

        self.registrar = registrar
        super.init(frame: .zero, configuration: configuration)
        self.plugin = plugin
        self.autoresizingMask = [.width, .height]
        self.navigationDelegate = self
        self.uiDelegate = self

        userContentController.add(WeakScriptMessageHandler(delegate: self), name: "consoleHandler")
        userContentController.add(
            WeakScriptMessageHandler(delegate: self), name: "onFindResultReceived")
        userContentController.add(
            WeakScriptMessageHandler(delegate: self), name: "callHandler")
        // WebMessage (issue #197): port + listener message handlers.
        userContentController.add(
            WeakScriptMessageHandler(delegate: self), name: "onWebMessagePortMessageReceived")
        userContentController.add(
            WeakScriptMessageHandler(delegate: self), name: "onWebMessageListenerPostMessageReceived")
        // Scroll / content-size events (issue #197): posted from JS.
        userContentController.add(
            WeakScriptMessageHandler(delegate: self), name: "onScrollChangedReceived")

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

        // WebMessage listener constructor + origin-matching helpers (#197).
        let webMessageListenerScript = WKUserScript(
            source: WEB_MESSAGE_LISTENER_JS_SOURCE, injectionTime: .atDocumentStart,
            forMainFrameOnly: false)
        userContentController.addUserScript(webMessageListenerScript)

        // Initialise the in-page webMessageChannels map + scroll/content-size
        // observers. The scroll observer is debounced via requestAnimationFrame
        // so we don't flood the native channel on momentum scroll.
        let webMessageInitScript = WKUserScript(
            source: """
            window.\(JAVASCRIPT_BRIDGE_NAME)._webMessageChannels = {};
            (function() {
                var pending = false;
                function postScroll() {
                    if (pending) return;
                    pending = true;
                    requestAnimationFrame(function() {
                        pending = false;
                        try {
                            window.webkit.messageHandlers.onScrollChangedReceived.postMessage({
                                "x": window.scrollX || window.pageXOffset || 0,
                                "y": window.scrollY || window.pageYOffset || 0,
                                "contentWidth": document.documentElement.scrollWidth || document.body.scrollWidth || 0,
                                "contentHeight": document.documentElement.scrollHeight || document.body.scrollHeight || 0,
                                "viewportWidth": window.innerWidth,
                                "viewportHeight": window.innerHeight
                            });
                        } catch (e) {}
                    });
                }
                window.addEventListener("scroll", postScroll, {passive: true});
                window.addEventListener("resize", postScroll, {passive: true});
                if (typeof ResizeObserver !== "undefined") {
                    try {
                        new ResizeObserver(postScroll).observe(document.documentElement);
                    } catch (e) {}
                }
            })();
            """,
            injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userContentController.addUserScript(webMessageInitScript)

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
                    if let userScript = UserScript.fromMap(map: scriptMap) {
                        configuration.userContentController.addUserScript(userScript)
                        self.userOnlyScripts.append(userScript)
                    }
                }
            }

            if let contextMenu = args["contextMenu"] as? [String: Any] {
                self.contextMenu = contextMenu
            }
        }

        self.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.addObserver(self, forKeyPath: "url", options: .new, context: nil)
        self.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        // onZoomScaleChanged (#197): pageZoom is macOS 11+, floor is macOS 12.
        self.addObserver(self, forKeyPath: "pageZoom", options: .new, context: nil)
    }


    public func printCurrentPage(
        settings: PrintJobSettings? = nil
    ) -> String? {
        var printJobId: String? = nil
        if let settings = settings, settings.handledByClient {
            printJobId = UUID().uuidString
        }

        let printInfo = NSPrintInfo()
        // NOTE: macOS NSPrintInfo has no jobName (iOS-only); the print job
        // label comes from PrintJobController.settings.jobName instead.
        if let settings = settings {
            if let orientationValue = settings.orientation,
               let orientation = NSPrintInfo.PaperOrientation.init(rawValue: orientationValue)
            {
                printInfo.orientation = orientation
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
            self.configuration.userContentController.removeScriptMessageHandler(
                forName: "callHandler")
            self.configuration.userContentController.removeScriptMessageHandler(
                forName: "onWebMessagePortMessageReceived")
            self.configuration.userContentController.removeScriptMessageHandler(
                forName: "onWebMessageListenerPostMessageReceived")
            self.configuration.userContentController.removeScriptMessageHandler(
                forName: "onScrollChangedReceived")
            self.removeObserver(self, forKeyPath: "estimatedProgress")
            self.removeObserver(self, forKeyPath: "url")
            self.removeObserver(self, forKeyPath: "title")
            self.removeObserver(self, forKeyPath: "pageZoom")
            // Dispose any active WebMessage channels / listeners (#197).
            for (_, wmc) in webMessageChannels { wmc.dispose() }
            webMessageChannels.removeAll()
            for (_, wml) in webMessageListeners { wml.dispose() }
            webMessageListeners.removeAll()
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
        } else if keyPath == "pageZoom" {
            // onZoomScaleChanged (#197). pageZoom is macOS 11+; floor is 12.
            let newScale = Float(self.pageZoom)
            let oldScale = Float(self.lastPageZoom)
            self.lastPageZoom = self.pageZoom
            channel?.invokeMethod(
                "onZoomScaleChanged", arguments: ["newScale": newScale, "oldScale": oldScale])
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
        case "postUrl":
            if let args = call.arguments as? [String: Any],
               let urlStr = args["url"] as? String,
               let url = URL(string: urlStr),
               let postData = (args["postData"] as? FlutterStandardTypedData)?.data
            {
                var request = URLRequest(url: url)
                request.addValue(
                    "application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                request.httpBody = postData
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
                let mimeType = args["mimeType"] as? String ?? "text/html"
                let encoding = args["encoding"] as? String ?? "utf-8"
                let baseURL = URL(string: baseUrl)
                if let dataData = data.data(using: .utf8) {
                    self.load(
                        dataData, mimeType: mimeType,
                        characterEncodingName: encoding, baseURL: baseURL ?? URL(string: "about:blank")!)
                } else {
                    self.loadHTMLString(data, baseURL: baseURL)
                }
                result(true)
            } else {
                result(
                    FlutterError(code: "InAppWebView", message: "Invalid arguments", details: nil))
            }
        case "loadFile":
            if let args = call.arguments as? [String: Any],
               let assetFilePath = args["assetFilePath"] as? String
            {
                guard let registrar = self.registrar else {
                    result(
                        FlutterError(code: "InAppWebView", message: "Registrar not available", details: nil))
                    return
                }
                do {
                    let assetURL = try Util.getUrlAsset(
                        registrar: registrar, assetFilePath: assetFilePath)
                    if assetURL.isFileURL {
                        self.loadFileURL(
                            assetURL, allowingReadAccessTo: assetURL.deletingLastPathComponent())
                    } else {
                        self.load(URLRequest(url: assetURL))
                    }
                    result(true)
                } catch let error as NSError {
                    result(
                        FlutterError(
                            code: "InAppWebView", message: error.domain, details: nil))
                }
            } else {
                result(
                    FlutterError(code: "InAppWebView", message: "Invalid arguments", details: nil))
            }
        case "reload":
            self.reload()
            result(true)
        case "reloadFromOrigin":
            self.reloadFromOrigin()
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
        case "goBackOrForward":
            if let args = call.arguments as? [String: Any], let steps = args["steps"] as? Int {
                self.goBackOrForward(steps: steps)
            }
            result(true)
        case "canGoBack":
            result(self.canGoBack)
        case "canGoForward":
            result(self.canGoForward)
        case "canGoBackOrForward":
            if let args = call.arguments as? [String: Any], let steps = args["steps"] as? Int {
                result(self.canGoBackOrForward(steps: steps))
            } else {
                result(false)
            }
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
        case "getCopyBackForwardList":
            result(self.getCopyBackForwardList())
        case "getOriginalUrl":
            // WKWebView has no `currentOriginalUrl` like the iOS port caches;
            // backForwardList.currentItem?.initialURL is the closest analogue.
            result(self.backForwardList.currentItem?.initialURL.absoluteString)
        case "hasOnlySecureContent":
            result(self.hasOnlySecureContent)
        case "getCertificate":
            // macOS WKWebView does not expose the server trust object publicly,
            // so the certificate is only available via the auth-challenge flow
            // (tracked separately on the macOS auth-challenges branch). Return
            // nil rather than throwing MissingPluginException.
            result(nil)
        case "isSecureContext":
            self.evaluateJavaScript("window.isSecureContext") { (value, _) in
                result((value as? Bool) ?? false)
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
        case "createWebArchiveData":
            if #available(macOS 11.0, *) {
                self.createWebArchiveData(completionHandler: { res in
                    switch res {
                    case .success(let data):
                        result(data)
                    case .failure(_):
                        result(nil)
                    }
                })
            } else {
                result(nil)
            }
        case "saveWebArchive":
            if let args = call.arguments as? [String: Any],
               let filePath = args["filePath"] as? String,
               let autoname = args["autoname"] as? Bool,
               #available(macOS 11.0, *)
            {
                self.createWebArchiveData(completionHandler: { res in
                    switch res {
                    case .success(let data):
                        var localUrl = URL(fileURLWithPath: filePath)
                        if autoname {
                            if let url = self.url {
                                let invalidCharacters = CharacterSet(charactersIn: "\\/:*?\"<>|")
                                    .union(.newlines)
                                    .union(.illegalCharacters)
                                    .union(.controlCharacters)
                                let currentPageUrlFileName = url.path
                                    .components(separatedBy: invalidCharacters)
                                    .joined(separator: "")
                                let fullPath = filePath + "/" + currentPageUrlFileName + ".webarchive"
                                localUrl = URL(fileURLWithPath: fullPath)
                            } else {
                                result(nil)
                                return
                            }
                        }
                        do {
                            try data.write(to: localUrl)
                            result(localUrl.path)
                        } catch {
                            result(nil)
                        }
                    case .failure(_):
                        result(nil)
                    }
                })
            } else {
                result(nil)
            }
        case "loadSimulatedRequest":
            if let args = call.arguments as? [String: Any],
               let urlRequestMap = args["urlRequest"] as? [String: Any],
               #available(macOS 11.0, *)
            {
                let request = URLRequest(fromPluginMap: urlRequestMap)
                if let dataTyped = args["data"] as? FlutterStandardTypedData {
                    let data = dataTyped.data
                    if let urlResponseMap = args["urlResponse"] as? [String: Any],
                       let urlString = urlResponseMap["url"] as? String,
                       let url = URL(string: urlString)
                    {
                        let mimeType = urlResponseMap["mimeType"] as? String ?? "text/html"
                        let encoding = urlResponseMap["encoding"] as? String ?? "utf-8"
                        let statusCode = urlResponseMap["statusCode"] as? Int ?? 200
                        let response = HTTPURLResponse(
                            url: url, statusCode: statusCode, httpVersion: nil,
                            headerFields: urlResponseMap["headers"] as? [String: String])!
                        self.loadSimulatedRequest(request, response: response, responseData: data)
                    } else {
                        let html = String(data: data, encoding: .utf8) ?? ""
                        self.loadSimulatedRequest(request, responseHTML: html)
                    }
                    result(true)
                } else {
                    result(false)
                }
            } else {
                result(false)
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
                let contentWorldMap = args["contentWorld"] as? [String: Any?]
                if let contentWorldMap = contentWorldMap,
                   let contentWorld = WKContentWorld.fromMap(map: contentWorldMap)
                {
                    // macOS 11+ WKContentWorld — floor is macOS 12, no gating needed.
                    self.evaluateJavaScript(source, in: nil, in: contentWorld) { outcome in
                        switch outcome {
                        case .success(let value):
                            result(value ?? NSNull())
                        case .failure(let error):
                            result(
                                FlutterError(
                                    code: "InAppWebView", message: error.localizedDescription,
                                    details: nil))
                        }
                    }
                } else {
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
                }
            } else {
                result(
                    FlutterError(code: "InAppWebView", message: "Invalid arguments", details: nil))
            }
        case "callAsyncJavaScript":
            if let args = call.arguments as? [String: Any],
               let functionBody = args["functionBody"] as? String,
               #available(macOS 11.0, *)
            {
                let functionArguments = args["arguments"] as? [String: Any] ?? [:]
                var contentWorld = WKContentWorld.page
                if let contentWorldMap = args["contentWorld"] as? [String: Any?] {
                    contentWorld = WKContentWorld.fromMap(map: contentWorldMap) ?? .page
                }
                self.callAsyncJavaScript(
                    functionBody, arguments: functionArguments, in: nil, in: contentWorld
                ) { (evalResult) in
                    var body: [String: Any?] = [
                        "value": nil,
                        "error": nil,
                    ]
                    switch evalResult {
                    case .success(let value):
                        body["value"] = value
                    case .failure(let error):
                        let userInfo = (error as NSError).userInfo
                        body["error"] =
                            userInfo["WKJavaScriptExceptionMessage"]
                            ?? userInfo["NSLocalizedDescription"] as? String
                            ?? error.localizedDescription
                    }
                    result(body)
                }
            } else {
                result(nil)
            }
        case "injectJavascriptFileFromUrl":
            if let args = call.arguments as? [String: Any],
               let urlFile = args["urlFile"] as? String
            {
                self.injectJavascriptFileFromUrl(
                    urlFile: urlFile,
                    scriptHtmlTagAttributes: args["scriptHtmlTagAttributes"] as? [String: Any?])
                result(true)
            } else {
                result(
                    FlutterError(code: "InAppWebView", message: "Invalid arguments", details: nil))
            }
        case "injectCSSCode":
            if let args = call.arguments as? [String: Any], let source = args["source"] as? String {
                self.injectCSSCode(source: source)
                result(true)
            } else {
                result(
                    FlutterError(code: "InAppWebView", message: "Invalid arguments", details: nil))
            }
        case "injectCSSFileFromUrl":
            if let args = call.arguments as? [String: Any],
               let urlFile = args["urlFile"] as? String
            {
                self.injectCSSFileFromUrl(
                    urlFile: urlFile,
                    cssLinkHtmlTagAttributes: args["cssLinkHtmlTagAttributes"] as? [String: Any?])
                result(true)
            } else {
                result(
                    FlutterError(code: "InAppWebView", message: "Invalid arguments", details: nil))
            }
        case "addUserScript":
            if let args = call.arguments as? [String: Any],
               let userScriptMap = args["userScript"] as? [String: Any?],
               let userScript = UserScript.fromMap(map: userScriptMap)
            {
                self.configuration.userContentController.addUserScript(userScript)
                self.userOnlyScripts.append(userScript)
            }
            result(true)
        case "removeUserScript":
            if let args = call.arguments as? [String: Any],
               let index = args["index"] as? Int,
               let userScriptMap = args["userScript"] as? [String: Any?],
               let userScript = UserScript.fromMap(map: userScriptMap)
            {
                self.removeUserOnlyScript(at: index, matching: userScript)
            }
            result(true)
        case "removeUserScriptsByGroupName":
            if let args = call.arguments as? [String: Any],
               let groupName = args["groupName"] as? String
            {
                self.removeUserOnlyScriptsByGroupName(groupName: groupName)
            }
            result(true)
        case "removeAllUserScripts":
            self.removeAllUserOnlyScripts()
            result(true)
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
        case "scrollTo":
            if let args = call.arguments as? [String: Any],
               let x = args["x"] as? Int, let y = args["y"] as? Int
            {
                let animated = args["animated"] as? Bool ?? false
                self.scrollTo(x: x, y: y, animated: animated)
            }
            result(true)
        case "scrollBy":
            if let args = call.arguments as? [String: Any],
               let x = args["x"] as? Int, let y = args["y"] as? Int
            {
                let animated = args["animated"] as? Bool ?? false
                self.scrollBy(x: x, y: y, animated: animated)
            }
            result(true)
        case "getScrollX":
            result(Int(self.enclosingScrollView?.contentView.bounds.origin.x ?? 0))
        case "getScrollY":
            result(Int(self.enclosingScrollView?.contentView.bounds.origin.y ?? 0))
        case "getContentHeight":
            result(Int64(self.enclosingScrollView?.documentView?.bounds.height ?? 0))
        case "getContentWidth":
            result(Int64(self.enclosingScrollView?.documentView?.bounds.width ?? 0))
        case "zoomBy":
            if let args = call.arguments as? [String: Any],
               let zoomFactor = (args["zoomFactor"] as? NSNumber)?.floatValue
            {
                // macOS WKWebView uses `pageZoom` (macOS 11+) rather than
                // UIScrollView.zoomScale. `animated` is ignored — pageZoom is
                // not animatable.
                if #available(macOS 11.0, *) {
                    self.pageZoom = self.pageZoom * CGFloat(zoomFactor)
                }
            }
            result(true)
        case "getZoomScale":
            if #available(macOS 11.0, *) {
                result(Float(self.pageZoom))
            } else {
                result(Float(1.0))
            }
        case "canScrollVertically":
            let contentHeight = Int64(self.enclosingScrollView?.documentView?.bounds.height ?? 0)
            result(contentHeight > Int64(self.bounds.height))
        case "canScrollHorizontally":
            let contentWidth = Int64(self.enclosingScrollView?.documentView?.bounds.width ?? 0)
            result(contentWidth > Int64(self.bounds.width))
        case "pauseTimers":
            self.pauseTimers()
            result(true)
        case "resumeTimers":
            self.resumeTimers()
            result(true)
        case "getSelectedText":
            if self.configuration.defaultWebpagePreferences.allowsContentJavaScript {
                self.evaluateJavaScript(PluginScriptsUtil.GET_SELECTED_TEXT_JS_SOURCE) { (value, _) in
                    result(value ?? "")
                }
            } else {
                result("")
            }
        case "getHitTestResult":
            self.getHitTestResult { (hitTestResult) in
                result(hitTestResult.toMap())
            }
        case "clearFocus":
            self.window?.makeFirstResponder(nil)
            result(true)
        case "setContextMenu":
            if let args = call.arguments as? [String: Any] {
                self.contextMenu = args["contextMenu"] as? [String: Any]
            }
            result(true)
        case "requestFocusNodeHref":
            // No equivalent of the iOS `_lastAnchorOrImageTouched` plugin
            // script on macOS; query the focused anchor directly.
            self.evaluateJavaScript("""
                (function() {
                    var el = document.activeElement;
                    if (el && el.tagName && el.tagName.toLowerCase() === 'a') {
                        return {"href": el.href, "text": el.text, "url": el.href};
                    }
                    return null;
                })();
                """) { (value, _) in
                result(value)
            }
        case "requestImageRef":
            // Query the last right-clicked image if available.
            if let point = self.lastRightClickPoint {
                let x = Int(point.x)
                let y = Int(point.y)
                self.evaluateJavaScript(self.hitTestJS(x: x, y: y)) { (value, _) in
                    result(value)
                }
            } else {
                result(nil)
            }
        case "getMetaThemeColor":
            if #available(macOS 11.0, *) {
                // WKWebView.themeColor is macOS 11+; hexString helper is not
                // ported, so format manually.
                if let color = self.themeColor {
                    result(self.nsColorToHexString(color))
                } else {
                    result(nil)
                }
            } else {
                result(nil)
            }
        case "isInFullscreen":
            // macOS WKWebView has no `fullscreenState` / `inFullscreen`
            // property. Element-fullscreen is handled by the app via
            // custom JS; return false as a documented exception.
            result(false)
        case "pauseAllMediaPlayback":
            if #available(macOS 11.0, *) {
                self.pauseAllMediaPlayback(completionHandler: {
                    result(true)
                })
            } else {
                result(false)
            }
        case "setAllMediaPlaybackSuspended":
            if let args = call.arguments as? [String: Any],
               let suspended = args["suspended"] as? Bool,
               #available(macOS 11.0, *)
            {
                self.setAllMediaPlaybackSuspended(suspended, completionHandler: {
                    result(true)
                })
            } else {
                result(false)
            }
        case "closeAllMediaPresentations":
            if #available(macOS 11.0, *) {
                self.closeAllMediaPresentations(completionHandler: {
                    result(true)
                })
            } else {
                result(false)
            }
        case "requestMediaPlaybackState":
            if #available(macOS 11.0, *) {
                self.requestMediaPlaybackState(completionHandler: { (state) in
                    result(state.rawValue)
                })
            } else {
                result(nil)
            }
        case "getCameraCaptureState":
            if #available(macOS 11.0, *) {
                result(self.cameraCaptureState.rawValue)
            } else {
                result(nil)
            }
        case "setCameraCaptureState":
            if let args = call.arguments as? [String: Any],
               let stateInt = args["state"] as? Int,
               let state = WKMediaCaptureState.init(rawValue: stateInt),
               #available(macOS 11.0, *)
            {
                self.setCameraCaptureState(state) {
                    result(true)
                }
            } else {
                result(false)
            }
        case "getMicrophoneCaptureState":
            if #available(macOS 11.0, *) {
                result(self.microphoneCaptureState.rawValue)
            } else {
                result(nil)
            }
        case "setMicrophoneCaptureState":
            if let args = call.arguments as? [String: Any],
               let stateInt = args["state"] as? Int,
               let state = WKMediaCaptureState.init(rawValue: stateInt),
               #available(macOS 11.0, *)
            {
                self.setMicrophoneCaptureState(state) {
                    result(true)
                }
            } else {
                result(false)
            }
        case "createWebMessageChannel":
            if let plugin = self.plugin {
                let id = UUID().uuidString
                let webMessageChannel = WebMessageChannel(plugin: plugin, id: id)
                webMessageChannels[id] = webMessageChannel
                webMessageChannel.initJsInstance(webView: self) { (_) in
                    result(webMessageChannel.toMap())
                }
            } else {
                result(nil)
            }
        case "postWebMessage":
            if let args = call.arguments as? [String: Any],
               let messageMap = args["message"] as? [String: Any?]
            {
                let targetOrigin = args["targetOrigin"] as? String ?? "*"
                let message = WebMessage.fromMap(map: messageMap)
                // Resolve any port references to active WebMessageChannels.
                var ports: [WebMessagePort] = []
                if let notConnectedPorts = message.ports {
                    for notConnectedPort in notConnectedPorts {
                        if let webMessageChannel = webMessageChannels[notConnectedPort.webMessageChannelId] {
                            ports.append(webMessageChannel.ports[Int(notConnectedPort.index)])
                        }
                    }
                }
                message.ports = ports
                do {
                    try self.postWebMessage(message: message, targetOrigin: targetOrigin) {
                        (_) in
                        result(true)
                    }
                } catch let error as NSError {
                    result(
                        FlutterError(
                            code: "InAppWebView", message: error.domain, details: nil))
                }
            } else {
                result(false)
            }
        case "addWebMessageListener":
            if let args = call.arguments as? [String: Any],
               let listenerMap = args["webMessageListener"] as? [String: Any?],
               let plugin = self.plugin,
               let webMessageListener = WebMessageListener.fromMap(plugin: plugin, map: listenerMap)
            {
                webMessageListeners[webMessageListener.id] = webMessageListener
                webMessageListener.initJsInstance(webView: self)
                result(true)
            } else {
                result(false)
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
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Issue #197 helper methods

    func goBackOrForward(steps: Int) {
        if canGoBackOrForward(steps: steps) {
            if steps > 0 {
                let index = steps - 1
                if index < self.backForwardList.forwardList.count {
                    go(to: self.backForwardList.forwardList[index])
                }
            } else if steps < 0 {
                let backListLength = self.backForwardList.backList.count
                let index = backListLength + steps
                if index >= 0 && index < backListLength {
                    go(to: self.backForwardList.backList[index])
                }
            }
        }
    }

    func canGoBackOrForward(steps: Int) -> Bool {
        let currentIndex = self.backForwardList.backList.count
        return (steps >= 0)
            ? steps <= self.backForwardList.forwardList.count
            : currentIndex + steps >= 0
    }

    func getCopyBackForwardList() -> [String: Any] {
        let currentList = backForwardList
        let currentIndex = currentList.backList.count
        var completeList = currentList.backList
        if currentList.currentItem != nil {
            completeList.append(currentList.currentItem!)
        }
        completeList.append(contentsOf: currentList.forwardList)

        var history: [[String: String]] = []
        for historyItem in completeList {
            var historyItemMap: [String: String] = [:]
            historyItemMap["originalUrl"] = historyItem.initialURL.absoluteString
            historyItemMap["title"] = historyItem.title ?? ""
            historyItemMap["url"] = historyItem.url.absoluteString
            history.append(historyItemMap)
        }

        var result: [String: Any] = [:]
        result["list"] = history
        result["currentIndex"] = currentIndex
        return result
    }

    func scrollTo(x: Int, y: Int, animated: Bool) {
        guard let clipView = enclosingScrollView?.contentView else {
            self.evaluateJavaScript("window.scrollTo(\(x), \(y));", completionHandler: nil)
            return
        }
        let point = NSPoint(x: x, y: y)
        if animated {
            NSAnimationContext.runAnimationGroup({ context in
                context.allowsImplicitAnimation = true
                context.duration = 0.25
                clipView.scroll(to: point)
                enclosingScrollView?.reflectScrolledClipView(clipView)
            }, completionHandler: nil)
        } else {
            clipView.scroll(to: point)
            enclosingScrollView?.reflectScrolledClipView(clipView)
        }
    }

    func scrollBy(x: Int, y: Int, animated: Bool) {
        let origin = enclosingScrollView?.contentView.bounds.origin ?? .zero
        scrollTo(x: Int(origin.x) + x, y: Int(origin.y) + y, animated: animated)
    }

    func pauseTimers() {
        if !isPausedTimers {
            isPausedTimers = true
            // Same alert()-based hack the iOS port uses — WebKit has no public
            // "pause JS timers" API. The alert dialog blocks the JS thread,
            // which effectively pauses timers. resumeTimers dismisses it.
            let script = "alert();"
            self.evaluateJavaScript(script, completionHandler: nil)
        }
    }

    func resumeTimers() {
        if isPausedTimers {
            if let completionHandler = isPausedTimersCompletionHandler {
                self.isPausedTimersCompletionHandler = nil
                completionHandler()
            }
            isPausedTimers = false
        }
    }

    func injectJavascriptFileFromUrl(urlFile: String, scriptHtmlTagAttributes: [String: Any?]?) {
        var scriptAttributes = ""
        if let attrs = scriptHtmlTagAttributes {
            if let typeAttr = attrs["type"] as? String {
                scriptAttributes +=
                    " script.type = '\(typeAttr.replacingOccurrences(of: "\'", with: "\\'"))'; "
            }
            if let idAttr = attrs["id"] as? String {
                let id = idAttr.replacingOccurrences(of: "\'", with: "\\'")
                scriptAttributes += " script.id = '\(id)'; "
                scriptAttributes += """
                    script.onload = function() {
                        if (window.\(JAVASCRIPT_BRIDGE_NAME) != null) {
                            window.\(JAVASCRIPT_BRIDGE_NAME).callHandler('onInjectedScriptLoaded', '\(id)');
                        }
                    };
                    script.onerror = function() {
                        if (window.\(JAVASCRIPT_BRIDGE_NAME) != null) {
                            window.\(JAVASCRIPT_BRIDGE_NAME).callHandler('onInjectedScriptError', '\(id)');
                        }
                    };
                    """
            }
            if let asyncAttr = attrs["async"] as? Bool, asyncAttr {
                scriptAttributes += " script.async = true; "
            }
            if let deferAttr = attrs["defer"] as? Bool, deferAttr {
                scriptAttributes += " script.defer = true; "
            }
            if let crossOriginAttr = attrs["crossOrigin"] as? String {
                scriptAttributes +=
                    " script.crossOrigin = '\(crossOriginAttr.replacingOccurrences(of: "\'", with: "\\'"))'; "
            }
            if let integrityAttr = attrs["integrity"] as? String {
                scriptAttributes +=
                    " script.integrity = '\(integrityAttr.replacingOccurrences(of: "\'", with: "\\'"))'; "
            }
            if let noModuleAttr = attrs["noModule"] as? Bool, noModuleAttr {
                scriptAttributes += " script.noModule = true; "
            }
            if let nonceAttr = attrs["nonce"] as? String {
                scriptAttributes +=
                    " script.nonce = '\(nonceAttr.replacingOccurrences(of: "\'", with: "\\'"))'; "
            }
            if let referrerPolicyAttr = attrs["referrerPolicy"] as? String {
                scriptAttributes +=
                    " script.referrerPolicy = '\(referrerPolicyAttr.replacingOccurrences(of: "\'", with: "\\'"))'; "
            }
        }
        // %@ is replaced by the JSON-escaped urlFile via injectDeferredObject.
        let jsWrapper =
            "(function(d) { var script = d.createElement('script'); \(scriptAttributes) script.src = %@; d.body.appendChild(script); })(document);"
        injectDeferredObject(source: urlFile, withWrapper: jsWrapper)
    }

    func injectCSSCode(source: String) {
        let jsWrapper =
            "(function(d) { var style = d.createElement('style'); style.innerHTML = %@; d.head.appendChild(style); })(document);"
        injectDeferredObject(source: source, withWrapper: jsWrapper)
    }

    func injectCSSFileFromUrl(urlFile: String, cssLinkHtmlTagAttributes: [String: Any?]?) {
        var cssLinkAttributes = ""
        var alternateStylesheet = ""
        if let attrs = cssLinkHtmlTagAttributes {
            if let idAttr = attrs["id"] as? String {
                cssLinkAttributes +=
                    " link.id = '\(idAttr.replacingOccurrences(of: "\'", with: "\\'"))'; "
            }
            if let mediaAttr = attrs["media"] as? String {
                cssLinkAttributes +=
                    " link.media = '\(mediaAttr.replacingOccurrences(of: "\'", with: "\\'"))'; "
            }
            if let crossOriginAttr = attrs["crossOrigin"] as? String {
                cssLinkAttributes +=
                    " link.crossOrigin = '\(crossOriginAttr.replacingOccurrences(of: "\'", with: "\\'"))'; "
            }
            if let integrityAttr = attrs["integrity"] as? String {
                cssLinkAttributes +=
                    " link.integrity = '\(integrityAttr.replacingOccurrences(of: "\'", with: "\\'"))'; "
            }
            if let referrerPolicyAttr = attrs["referrerPolicy"] as? String {
                cssLinkAttributes +=
                    " link.referrerPolicy = '\(referrerPolicyAttr.replacingOccurrences(of: "\'", with: "\\'"))'; "
            }
            if let disabledAttr = attrs["disabled"] as? Bool, disabledAttr {
                cssLinkAttributes += " link.disabled = true; "
            }
            if let alternateAttr = attrs["alternate"] as? Bool, alternateAttr {
                alternateStylesheet = "alternate "
            }
            if let titleAttr = attrs["title"] as? String {
                cssLinkAttributes +=
                    " link.title = '\(titleAttr.replacingOccurrences(of: "\'", with: "\\'"))'; "
            }
        }
        let jsWrapper =
            "(function(d) { var link = d.createElement('link'); link.rel='\(alternateStylesheet)stylesheet', link.type='text/css'; \(cssLinkAttributes) link.href = %@; d.head.appendChild(link); })(document);"
        injectDeferredObject(source: urlFile, withWrapper: jsWrapper)
    }

    /// Common helper for the `inject*` family. `withWrapper` must contain a
    /// single `%@` placeholder which is replaced by the JSON-encoded `source`.
    private func injectDeferredObject(source: String, withWrapper: String?) {
        let jsonData = Util.JSONStringify(value: source)
        if let withWrapper = withWrapper {
            let script = withWrapper.replacingOccurrences(of: "%@", with: jsonData)
            self.evaluateJavaScript(script, completionHandler: nil)
        } else {
            self.evaluateJavaScript(source, completionHandler: nil)
        }
    }

    func getHitTestResult(completionHandler: @escaping (HitTestResult) -> Void) {
        guard let point = lastRightClickPoint else {
            completionHandler(HitTestResult(type: .unknownType, extra: nil))
            return
        }
        let x = Int(point.x)
        let y = Int(point.y)
        self.evaluateJavaScript(hitTestJS(x: x, y: y)) { (value, _) in
            if let map = value as? [String: Any?],
               let hitTestResult = HitTestResult.fromMap(map: map)
            {
                completionHandler(hitTestResult)
            } else {
                completionHandler(HitTestResult(type: .unknownType, extra: nil))
            }
        }
    }

    /// JS hit-test helper used by both `getHitTestResult` and
    /// `onLongPressHitTestResult` (right-click on macOS).
    private func hitTestJS(x: Int, y: Int) -> String {
        return """
        (function(x, y) {
            var el = document.elementFromPoint(x, y);
            if (!el) return {"type": 0, "extra": null};
            var type = 0; var extra = null;
            var tag = el.tagName ? el.tagName.toLowerCase() : "";
            if (tag === 'a') { type = 7; extra = el.href; }
            else if (tag === 'img') { type = 5; extra = el.src; }
            else if (tag === 'input' || tag === 'textarea') { type = 9; }
            else {
                var anchor = el.closest('a');
                if (anchor) { type = 8; extra = anchor.href; }
                else {
                    var img = el.closest('img');
                    if (img) { type = 5; extra = img.src; }
                }
            }
            return {"type": type, "extra": extra};
        })(\(x), \(y));
        """
    }

    /// Remove a single user script at `index` matching `script`. WKUserContentController
    /// has no single-script removal, so we rebuild the whole list.
    private func removeUserOnlyScript(at index: Int, matching script: UserScript) {
        guard index >= 0 && index < userOnlyScripts.count else { return }
        // Only remove if the entry at `index` matches the supplied script
        // (same source + injectionTime), mirroring iOS behaviour.
        let entry = userOnlyScripts[index]
        if entry.source == script.source && entry.injectionTime == script.injectionTime {
            userOnlyScripts.remove(at: index)
            rebuildUserOnlyScripts()
        }
    }

    private func removeUserOnlyScriptsByGroupName(groupName: String) {
        userOnlyScripts.removeAll(where: { $0.groupName == groupName })
        rebuildUserOnlyScripts()
    }

    private func removeAllUserOnlyScripts() {
        userOnlyScripts.removeAll()
        configuration.userContentController.removeAllUserScripts()
        // Re-add the plugin scripts that should always be present.
        configuration.userContentController.addUserScript(
            WKUserScript(source: JAVASCRIPT_BRIDGE_JS_SOURCE, injectionTime: .atDocumentStart, forMainFrameOnly: false))
    }

    /// Rebuild the WKUserContentController's user script list from the tracked
    /// `userOnlyScripts` array. Called after any removal.
    private func rebuildUserOnlyScripts() {
        let ucc = configuration.userContentController
        ucc.removeAllUserScripts()
        // Re-add the plugin scripts that should always be present.
        ucc.addUserScript(
            WKUserScript(source: JAVASCRIPT_BRIDGE_JS_SOURCE, injectionTime: .atDocumentStart, forMainFrameOnly: false))
        for s in userOnlyScripts {
            ucc.addUserScript(s)
        }
    }

    /// Post a WebMessage to the page, optionally transferring ports.
    func postWebMessage(
        message: WebMessage, targetOrigin: String, completionHandler: ((Any?) -> Void)? = nil
    ) throws {
        var portsString = "null"
        if let ports = message.ports {
            var portArrayString: [String] = []
            for port in ports {
                if port.isStarted {
                    throw NSError(domain: "Port is already started", code: 0)
                }
                if port.isClosed || port.isTransferred {
                    throw NSError(domain: "Port is already closed or transferred", code: 0)
                }
                port.isTransferred = true
                portArrayString.append(
                    "\(WEB_MESSAGE_CHANNELS_VARIABLE_NAME)['\(port.webMessageChannelId)'].\(port.name)"
                )
            }
            portsString = "[" + portArrayString.joined(separator: ", ") + "]"
        }

        let url = URL(string: targetOrigin)?.absoluteString ?? "*"
        let source = """
            (function() {
                var targetOrigin = "\(url)";
                try {
                    window.postMessage(\(message.jsData), targetOrigin, \(portsString));
                } catch (e) {
                    // Some pages override window.postMessage; fall back to
                    // dispatching a MessageEvent directly.
                    var event = new MessageEvent('message', {
                        data: \(message.jsData),
                        origin: targetOrigin,
                        ports: \(portsString) === "null" ? [] : \(portsString)
                    });
                    window.dispatchEvent(event);
                }
            })();
            """
        self.evaluateJavaScript(source) { (_, _) in
            completionHandler?(nil)
        }
        message.dispose()
    }

    /// Convert an NSColor to a #RRGGBBAA / #RRGGBB hex string for
    /// `getMetaThemeColor` (the iOS port uses a UIColor.hexString extension).
    private func nsColorToHexString(_ color: NSColor) -> String? {
        guard let rgb = color.usingColorSpace(.sRGB) else { return nil }
        let r = Int(round(rgb.redComponent * 255))
        let g = Int(round(rgb.greenComponent * 255))
        let b = Int(round(rgb.blueComponent * 255))
        let a = rgb.alphaComponent
        if a >= 0.999 {
            return String(format: "#%02X%02X%02X", r, g, b)
        }
        let ai = Int(round(a * 255))
        return String(format: "#%02X%02X%02X%02X", r, g, b, ai)
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
            configuration.defaultWebpagePreferences.allowsContentJavaScript = newSettings.javaScriptEnabled
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
        _ webView: WKWebView, didCommit navigation: WKNavigation!
    ) {
        // onPageCommitVisible (#197) — fires when the page is first painted.
        channel?.invokeMethod("onPageCommitVisible", arguments: ["url": webView.url?.absoluteString])
    }

    public func webView(
        _ webView: WKWebView,
        didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!
    ) {
        // onDidReceiveServerRedirectForProvisionalNavigation (#197).
        channel?.invokeMethod(
            "onDidReceiveServerRedirectForProvisionalNavigation", arguments: [:])
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


    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        channel?.invokeMethod("onWebContentProcessDidTerminate", arguments: [:])
        // Auto-reload to recover from the content-process termination.
        // Mirrors the iOS implementation (issue #154) so apps get a sensible
        // default recovery while still receiving the Dart-side callback first.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self, !self.isDisposed else { return }
            self.reload()
        }
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
        } else if message.name == "onWebMessagePortMessageReceived",
            let body = message.body as? [String: Any],
            let webMessageChannelId = body["webMessageChannelId"] as? String,
            let index = body["index"] as? Int64
        {
            // WebMessageChannel port message (#197).
            if let wmc = webMessageChannels[webMessageChannelId] {
                var messageData: Any? = nil
                var messageType = WebMessageType.string
                if let msg = body["message"] as? [String: Any] {
                    messageData = msg["data"]
                    if let typeInt = msg["type"] as? Int,
                       let type = WebMessageType(rawValue: typeInt)
                    {
                        messageType = type
                    }
                }
                let webMessage = WebMessage(data: messageData, type: messageType, ports: nil)
                wmc.channelDelegate?.onMessage(message: webMessage, index: index)
            }
        } else if message.name == "onWebMessageListenerPostMessageReceived",
            let body = message.body as? [String: Any],
            let jsObjectName = body["jsObjectName"] as? String
        {
            // WebMessageListener page→Dart message (#197).
            for (_, wml) in webMessageListeners {
                if wml.jsObjectName == jsObjectName {
                    var messageData: Any? = nil
                    var messageType = WebMessageType.string
                    if let msg = body["message"] as? [String: Any] {
                        messageData = msg["data"]
                        if let typeInt = msg["type"] as? Int,
                           let type = WebMessageType(rawValue: typeInt)
                        {
                            messageType = type
                        }
                    }
                    let webMessage = WebMessage(data: messageData, type: messageType, ports: nil)
                    wml.channelDelegate?.onPostMessage(message: webMessage)
                    break
                }
            }
        } else if message.name == "onScrollChangedReceived", let body = message.body as? [String: Any] {
            // onScrollChanged / onContentSizeChanged / onOverScrolled (#197).
            let x = body["x"] as? Int ?? 0
            let y = body["y"] as? Int ?? 0
            let contentWidth = body["contentWidth"] as? Int ?? 0
            let contentHeight = body["contentHeight"] as? Int ?? 0
            let viewportWidth = body["viewportWidth"] as? Int ?? 0
            let viewportHeight = body["viewportHeight"] as? Int ?? 0

            channel?.invokeMethod("onScrollChanged", arguments: ["x": x, "y": y])

            let newContentSize = NSSize(width: contentWidth, height: contentHeight)
            if Int(newContentSize.width) != Int(lastNotifiedContentSize.width)
                || Int(newContentSize.height) != Int(lastNotifiedContentSize.height)
            {
                let oldContentSize = lastNotifiedContentSize
                lastNotifiedContentSize = newContentSize
                channel?.invokeMethod(
                    "onContentSizeChanged",
                    arguments: [
                        "oldContentSize": ["width": oldContentSize.width, "height": oldContentSize.height],
                        "newContentSize": ["width": newContentSize.width, "height": newContentSize.height],
                    ])
            }

            // onOverScrolled — fire when reaching an edge.
            let clampedX = x <= 0 || (contentWidth > 0 && x + viewportWidth >= contentWidth)
            let clampedY = y <= 0 || (contentHeight > 0 && y + viewportHeight >= contentHeight)
            if clampedX || clampedY {
                channel?.invokeMethod(
                    "onOverScrolled",
                    arguments: [
                        "x": x, "y": y, "clampedX": clampedX, "clampedY": clampedY,
                    ])
            }
            lastScrollX = x
            lastScrollY = y
        }
    }

    /// Tracked for `onContentSizeChanged` (debounced via JS observer).
    private var lastNotifiedContentSize: NSSize = .zero

    // MARK: - Right-click → onLongPressHitTestResult (#197)

    public override func rightMouseDown(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        lastRightClickPoint = point
        let x = Int(point.x)
        let y = Int(point.y)
        self.evaluateJavaScript(hitTestJS(x: x, y: y)) { (value, _) in
            if let map = value as? [String: Any?],
               let hitTestResult = HitTestResult.fromMap(map: map)
            {
                self.channel?.invokeMethod(
                    "onLongPressHitTestResult", arguments: hitTestResult.toMap())
            } else {
                self.channel?.invokeMethod(
                    "onLongPressHitTestResult",
                    arguments: HitTestResult(type: .unknownType, extra: nil).toMap())
            }
        }
        // Do NOT call super — we don't want the default context menu to appear
        // for the web content (the Dart side manages context menus). However,
        // if no Dart handler is registered the page loses right-click entirely,
        // so we forward to super to keep the native menu as a fallback.
        super.rightMouseDown(with: event)
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
        // pauseTimers hack: an alert() is used to block the JS thread. If
        // pauseTimers is active, swallow the alert and stash the completion
        // handler so resumeTimers can invoke it.
        if isPausedTimers {
            isPausedTimersCompletionHandler = completionHandler
            return
        }
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

    // MARK: - Media capture / device orientation permission (macOS 12+)
    //
    // Ports the iOS WKUIDelegate implementation
    // (zikzak_inappwebview_ios/.../InAppWebView/InAppWebView.swift:2044+) to
    // macOS. Without these, any page calling getUserMedia() (camera/microphone)
    // is silently denied on macOS because WKWebView defaults to
    // WKPermissionDecision.deny when the delegate does not implement
    // requestMediaCapturePermissionForOrigin. See issue #195.
    //
    // The delegate dispatches onPermissionRequest to Dart (the same event the
    // iOS port and the shared Dart platform interface already use) and maps the
    // returned PermissionResponse.action back to WKPermissionDecision:
    //   0 -> .deny, 1 -> .grant, 2 -> .prompt  (see PermissionResponseAction).
    // If Dart returns no action (or the channel has no handler), we default to
    // .deny - matching the iOS callback.defaultBehaviour - so we never leave
    // the async decisionHandler uncalled (which would otherwise hang WebKit).
    //
    // SAFETY: We guard on `isDisposed` before invoking the FlutterMethodChannel
    // to prevent crashes if the InAppWebView is torn down while a permission
    // request is in flight. If disposed, we immediately deny — this matches the
    // iOS channelDelegate-nil fallback and is always safe.

    /// Resolves a PermissionResponse into a WKPermissionDecision, guarding
    /// against double-invocation of the decisionHandler (which WebKit forbids).
    @available(macOS 12.0, *)
    private static func resolvePermissionDecision(
        response: PermissionResponse?,
        decisionHandler: @escaping (WKPermissionDecision) -> Void,
        decisionHandlerCalled: inout Bool
    ) {
        guard !decisionHandlerCalled else { return }
        decisionHandlerCalled = true
        if let action = response?.action {
            switch action {
            case 1:  // PermissionResponseAction.GRANT
                decisionHandler(.grant)
            case 2:  // PermissionResponseAction.PROMPT
                decisionHandler(.prompt)
            default:  // 0 == PermissionResponseAction.DENY
                decisionHandler(.deny)
            }
        } else {
            decisionHandler(.deny)
        }
    }

    // MARK: - Context Menu (WKUIDelegate)

    @available(macOS 12.0, *)
    public func webView(
        _ webView: WKWebView,
        requestMediaCapturePermissionFor origin: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping (WKPermissionDecision) -> Void
    ) {
        // If the WebView is already disposed, deny immediately to avoid
        // invoking a torn-down FlutterMethodChannel.
        guard !isDisposed else {
            decisionHandler(.deny)
            return
        }

        let originString =
            "\(origin.protocol)://\(origin.host)"
            + (origin.port != 0 ? ":" + String(origin.port) : "")
        let permissionRequest = PermissionRequest(
            origin: originString, resources: [type.rawValue], frame: frame)

        var decisionHandlerCalled = false
        channel.invokeMethod(
            "onPermissionRequest",
            arguments: permissionRequest.toMap()
        ) { result in
            if let map = result as? [String: Any] {
                InAppWebView.resolvePermissionDecision(
                    response: PermissionResponse.fromMap(map: map),
                    decisionHandler: decisionHandler,
                    decisionHandlerCalled: &decisionHandlerCalled)
            } else {
                // Log non-dictionary results (FlutterError / not-implemented)
                // for debuggability, then deny — matching iOS callback.error.
                if let error = result as? FlutterError {
                    print("[InAppWebView] onPermissionRequest error: \(error.code) – \(error.message ?? "")")
                }
                InAppWebView.resolvePermissionDecision(
                    response: nil,
                    decisionHandler: decisionHandler,
                    decisionHandlerCalled: &decisionHandlerCalled)
            }
        }
    }



    // MARK: - Default-menu suppression (WKWebView default NSMenu)

    /// Called by AppKit when a contextual menu is about to be displayed.
    ///
    /// When the WKUIDelegate returns `nil` from
    /// `webView(_:contextMenuForElement:willDisplayWithHighlight:)`, WebKit
    /// falls back to its default NSMenu (per Apple's documentation). To
    /// honor `hideDefaultSystemContextMenuItems == true` with no custom items,
    /// we set `suppressDefaultMenuNext` in the delegate and cancel tracking
    /// here before the default menu becomes visible.
    ///
    /// This override is the supported macOS menu-override path (per
    /// CodeRabbit's review of commit 62971480). It only fires when the
    /// delegate returned `nil`; when the delegate returned our custom
    /// `NSMenu`, the flag is false and we simply forward to `super`.
    public override func willOpenMenu(_ menu: NSMenu, with event: NSEvent) {
        super.willOpenMenu(menu, with: event)
        if suppressDefaultMenuNext {
            suppressDefaultMenuNext = false
            // Cancel tracking on the default menu so it is not displayed.
            // Dispatching async ensures the menu has entered its tracking
            // loop before we cancel (cancelTracking on a menu that has not
            // yet started tracking is a no-op).
            DispatchQueue.main.async { [weak menu] in
                menu?.cancelTracking()
            }
        }
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
            "title": title,
        ]
        channel?.invokeMethod("onContextMenuActionItemClicked", arguments: arguments)
        // After a custom item is clicked, fire onHideContextMenu to match iOS.
        onHideContextMenu()
    }
}
