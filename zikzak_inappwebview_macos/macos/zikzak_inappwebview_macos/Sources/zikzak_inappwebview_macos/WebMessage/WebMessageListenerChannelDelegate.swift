//
//  WebMessageListenerChannelDelegate.swift
//  zikzak_inappwebview
//
//  macOS port of the iOS WebMessageListenerChannelDelegate. Handles the
//  `postMessage` and `dispose` calls from the Dart WebMessageListener.
//  See issue #197.
//

import Foundation
import FlutterMacOS

public class WebMessageListenerChannelDelegate {
    private var channel: FlutterMethodChannel?
    weak var webMessageListener: WebMessageListener?

    public init(webMessageListener: WebMessageListener, channel: FlutterMethodChannel) {
        self.webMessageListener = webMessageListener
        self.channel = channel
        channel.setMethodCallHandler(self.handle)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary

        switch call.method {
        case "postMessage":
            if let webView = webMessageListener?.webView {
                let message = WebMessage.fromMap(
                    map: arguments?["message"] as! [String: Any?])
                let jsObjectName = webMessageListener?.jsObjectName ?? ""
                _ = message.jsData
                // Forward the message to the page-side listener object.
                webView.evaluateJavaScript(
                    """
                    (function() {
                        var listener = window['\(jsObjectName)'];
                        if (listener != null && listener.onmessage != null) {
                            listener.onmessage(\(message.jsData));
                        }
                    })();
                    """,
                    completionHandler: { (_, _) in
                        result(true)
                    })
            } else {
                result(false)
            }
        case "dispose":
            webMessageListener?.dispose()
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func onPostMessage(message: WebMessage) {
        let arguments: [String: Any?] = [
            "message": message.toMap(),
        ]
        channel?.invokeMethod("onPostMessage", arguments: arguments)
    }

    public func dispose() {
        channel?.setMethodCallHandler(nil)
        channel = nil
        webMessageListener = nil
    }

    deinit {
        dispose()
    }
}
