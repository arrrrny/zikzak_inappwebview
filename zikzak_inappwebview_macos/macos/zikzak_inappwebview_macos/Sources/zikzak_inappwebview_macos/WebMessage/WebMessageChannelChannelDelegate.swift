//
//  WebMessageChannelChannelDelegate.swift
//  zikzak_inappwebview
//
//  macOS port of the iOS WebMessageChannelChannelDelegate. Handles the
//  per-port method-channel calls (postMessage / close / setWebMessageCallback
//  / dispose) that the Dart `WebMessageChannel` controller dispatches.
//  See issue #197.
//

import Foundation
import FlutterMacOS

public class WebMessageChannelChannelDelegate {
    private var channel: FlutterMethodChannel?
    weak var webMessageChannel: WebMessageChannel?

    public init(webMessageChannel: WebMessageChannel, channel: FlutterMethodChannel) {
        self.webMessageChannel = webMessageChannel
        self.channel = channel
        channel.setMethodCallHandler(self.handle)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary

        switch call.method {
        case "postMessage":
            if let webView = webMessageChannel?.webView,
                let index = arguments?["index"] as? Int64,
                let ports = webMessageChannel?.ports,
                index >= 0 && index < Int64(ports.count)
            {
                let port = ports[Int(index)]
                let message = WebMessage.fromMap(
                    map: arguments?["message"] as! [String: Any?])
                do {
                    try port.postMessage(message: message) { (_) in
                        result(true)
                    }
                } catch let error as NSError {
                    result(
                        FlutterError(
                            code: "WebMessageChannelChannelDelegate",
                            message: error.domain, details: nil))
                }
            } else {
                result(false)
            }
        case "setWebMessageCallback":
            if let webView = webMessageChannel?.webView,
                let index = arguments?["index"] as? Int64,
                let ports = webMessageChannel?.ports,
                index >= 0 && index < Int64(ports.count)
            {
                let port = ports[Int(index)]
                do {
                    try port.setWebMessageCallback { (_) in
                        result(true)
                    }
                } catch let error as NSError {
                    result(
                        FlutterError(
                            code: "WebMessageChannelChannelDelegate",
                            message: error.domain, details: nil))
                }
            } else {
                result(false)
            }
        case "close":
            if let index = arguments?["index"] as? Int64,
                let ports = webMessageChannel?.ports,
                index >= 0 && index < Int64(ports.count)
            {
                let port = ports[Int(index)]
                do {
                    try port.close { (_) in
                        result(true)
                    }
                } catch let error as NSError {
                    result(
                        FlutterError(
                            code: "WebMessageChannelChannelDelegate",
                            message: error.domain, details: nil))
                }
            } else {
                result(false)
            }
        case "dispose":
            webMessageChannel?.dispose()
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func onMessage(message: WebMessage, index: Int64) {
        let arguments: [String: Any?] = [
            "message": message.toMap(),
            "index": index,
        ]
        channel?.invokeMethod("onMessage", arguments: arguments)
    }

    public func dispose() {
        channel?.setMethodCallHandler(nil)
        channel = nil
        webMessageChannel = nil
    }

    deinit {
        dispose()
    }
}
