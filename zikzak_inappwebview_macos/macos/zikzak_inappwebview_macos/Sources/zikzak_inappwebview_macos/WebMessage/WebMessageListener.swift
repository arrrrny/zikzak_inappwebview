//
//  WebMessageListener.swift
//  zikzak_inappwebview
//
//  macOS port of the iOS WebMessageListener. Registers its own
//  FlutterMethodChannel (same name scheme as iOS) so the Dart
//  `WebMessageListener` controller works unchanged on macOS. See issue #197.
//

import Foundation
import FlutterMacOS
import WebKit

public class WebMessageListener: NSObject {
    static var METHOD_CHANNEL_NAME_PREFIX = "wtf.zikzak/zikzak_inappwebview_web_message_listener_"
    var id: String
    var jsObjectName: String
    var allowedOriginRules: Set<String>
    var channelDelegate: WebMessageListenerChannelDelegate?
    weak var webView: InAppWebView?
    var plugin: InAppWebViewFlutterPlugin?

    public init(
        plugin: InAppWebViewFlutterPlugin, id: String, jsObjectName: String,
        allowedOriginRules: Set<String>
    ) {
        self.id = id
        self.plugin = plugin
        self.jsObjectName = jsObjectName
        self.allowedOriginRules = allowedOriginRules
        super.init()
        if let registrar = plugin.registrar {
            let channel = FlutterMethodChannel(
                name: WebMessageListener.METHOD_CHANNEL_NAME_PREFIX + self.id + "_"
                    + self.jsObjectName,
                binaryMessenger: registrar.messenger)
            self.channelDelegate = WebMessageListenerChannelDelegate(
                webMessageListener: self, channel: channel)
        }
    }

    public func initJsInstance(webView: InAppWebView) {
        self.webView = webView
        let jsObjectNameEscaped = jsObjectName.replacingOccurrences(of: "\'", with: "\\'")
        let allowedOriginRulesString = allowedOriginRules.map { (allowedOriginRule) -> String in
            if allowedOriginRule == "*" {
                return "'*'"
            }
            let rule = URL(string: allowedOriginRule)!
            let host =
                rule.host != nil
                ? "'" + rule.host!.replacingOccurrences(of: "\'", with: "\\'") + "'" : "null"
            return """
                {scheme: '\(rule.scheme!)', host: \(host), port: \(rule.port != nil ? String(rule.port!) : "null")}
                """
        }.joined(separator: ", ")
        let source = """
            (function() {
                var allowedOriginRules = [\(allowedOriginRulesString)];
                var isPageBlank = window.location.href === "about:blank";
                var scheme = !isPageBlank ? window.location.protocol.replace(":", "") : null;
                var host = !isPageBlank ? window.location.hostname : null;
                var port = !isPageBlank ? window.location.port : null;
                if (window.\(JAVASCRIPT_BRIDGE_NAME)._isOriginAllowed(allowedOriginRules, scheme, host, port)) {
                    window['\(jsObjectNameEscaped)'] = new FlutterInAppWebViewWebMessageListener('\(jsObjectNameEscaped)');
                }
            })();
            """
        // Inject as a one-shot user script on the current document. The iOS
        // port uses addPluginScript so it re-injects on every navigation; we
        // approximate that by adding it to the user content controller.
        let userScript = WKUserScript(
            source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        webView.configuration.userContentController.addUserScript(userScript)
    }

    public static func fromMap(plugin: InAppWebViewFlutterPlugin, map: [String: Any?]?)
        -> WebMessageListener?
    {
        guard let map = map else { return nil }
        return WebMessageListener(
            plugin: plugin,
            id: map["id"] as! String,
            jsObjectName: map["jsObjectName"] as! String,
            allowedOriginRules: Set(map["allowedOriginRules"] as! [String])
        )
    }

    public func dispose() {
        channelDelegate?.dispose()
        channelDelegate = nil
        webView = nil
        plugin = nil
    }

    deinit {
        dispose()
    }
}
