import Flutter
//
//  HeadlessWebViewChannelDelegate.swift
//  zikzak_inappwebview
//
//  Created by ARRRRNY on 05/05/22.
//

import UIKit

public class HeadlessWebViewChannelDelegate: ChannelDelegate {
    private weak var headlessWebView: HeadlessInAppWebView?
    
    public init(headlessWebView: HeadlessInAppWebView, channel: FlutterMethodChannel) {
        super.init(channel: channel)
        self.headlessWebView = headlessWebView
    }
    
    public override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary

        // Touch the LRU clock: this instance just received a per-instance
        // call, so a later eviction recycles the least-recently-used id
        // rather than the longest-lived one (issue #371 review).
        if let headlessWebView = headlessWebView {
            headlessWebView.plugin?.headlessInAppWebViewManager?.touch(id: headlessWebView.id)
        }

        switch call.method {
        case "dispose":
            if let headlessWebView = headlessWebView {
                headlessWebView.dispose()
                result(true)
            } else {
                result(false)
            }
            break
        case "setSize":
            if let headlessWebView = headlessWebView {
                let sizeMap = arguments!["size"] as? [String: Any?]
                if let size = Size2D.fromMap(map: sizeMap) {
                    headlessWebView.setSize(size: size)
                }
                result(true)
            } else {
                result(false)
            }
            break
        case "getSize":
            result(headlessWebView?.getSize()?.toMap())
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
    
    public func onWebViewCreated() {
        let arguments: [String: Any?] = [:]
        channel?.invokeMethod("onWebViewCreated", arguments: arguments)
    }

    /// Notifies the Dart owner that the native manager evicted this instance to
    /// stay under the live-instance cap (issue #371). Invoked BEFORE the
    /// handler is cleared so the per-instance channel is still routed.
    public func onEvicted() {
        let arguments: [String: Any?] = [:]
        channel?.invokeMethod("onEvicted", arguments: arguments)
    }
    
    public override func dispose() {
        super.dispose()
        headlessWebView = nil
    }
    
    deinit {
        dispose()
    }
}
