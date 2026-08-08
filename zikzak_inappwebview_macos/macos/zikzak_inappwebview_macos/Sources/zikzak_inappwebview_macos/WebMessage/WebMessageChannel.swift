//
//  WebMessageChannel.swift
//  zikzak_inappwebview
//
//  macOS port of the iOS WebMessageChannel. Registers its own
//  FlutterMethodChannel (same name scheme as iOS) so the Dart
//  `WebMessageChannel` controller works unchanged on macOS. See issue #197.
//

import Foundation
import FlutterMacOS
import WebKit

public class WebMessageChannel: NSObject {
    static var METHOD_CHANNEL_NAME_PREFIX = "wtf.zikzak/zikzak_inappwebview_web_message_channel_"
    var id: String
    var plugin: InAppWebViewFlutterPlugin?
    var channelDelegate: WebMessageChannelChannelDelegate?
    weak var webView: InAppWebView?
    var ports: [WebMessagePort] = []

    public init(plugin: InAppWebViewFlutterPlugin, id: String) {
        self.id = id
        self.plugin = plugin
        super.init()
        if let registrar = plugin.registrar {
            let channel = FlutterMethodChannel(
                name: WebMessageChannel.METHOD_CHANNEL_NAME_PREFIX + id,
                binaryMessenger: registrar.messenger)
            self.channelDelegate = WebMessageChannelChannelDelegate(
                webMessageChannel: self, channel: channel)
        }
        self.ports = [
            WebMessagePort(
                name: "port1", index: 0, webMessageChannelId: self.id, webMessageChannel: self),
            WebMessagePort(
                name: "port2", index: 1, webMessageChannelId: self.id, webMessageChannel: self),
        ]
    }

    public func initJsInstance(
        webView: InAppWebView, completionHandler: ((WebMessageChannel?) -> Void)? = nil
    ) {
        self.webView = webView
        if let webView = self.webView {
            webView.evaluateJavaScript(
                """
                (function() {
                    \(WEB_MESSAGE_CHANNELS_VARIABLE_NAME)["\(id)"] = new MessageChannel();
                })();
                """,
                completionHandler: { (_, _) in
                    completionHandler?(self)
                })
        } else {
            completionHandler?(nil)
        }
    }

    public func toMap() -> [String: Any?] {
        return ["id": id]
    }

    public func dispose() {
        channelDelegate?.dispose()
        channelDelegate = nil
        for port in ports {
            port.dispose()
        }
        ports.removeAll()
        webView?.evaluateJavaScript(
            """
            (function() {
                var webMessageChannel = \(WEB_MESSAGE_CHANNELS_VARIABLE_NAME)["\(id)"];
                if (webMessageChannel != null) {
                    webMessageChannel.port1.close();
                    webMessageChannel.port2.close();
                    delete \(WEB_MESSAGE_CHANNELS_VARIABLE_NAME)["\(id)"];
                }
            })();
            """,
            completionHandler: nil)
        webView = nil
        plugin = nil
    }

    deinit {
        dispose()
    }
}
