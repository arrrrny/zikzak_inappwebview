//
//  HeadlessInAppWebViewManager.swift
//  zikzak_inappwebview
//
//  Created by ARRRRNY on 10/05/2020.
//

import UIKit

import Flutter
import UIKit
import WebKit
import UIKit
import AVFoundation

public class HeadlessInAppWebViewManager: ChannelDelegate {
    static let METHOD_CHANNEL_NAME = "wtf.zikzak/flutter_headless_inappwebview"
    var plugin: SwiftFlutterPlugin?
    var webViews: [String: HeadlessInAppWebView?] = [:]

    init(plugin: SwiftFlutterPlugin) {
        super.init(channel: FlutterMethodChannel(name: HeadlessInAppWebViewManager.METHOD_CHANNEL_NAME, binaryMessenger: plugin.registrar!.messenger()))
        self.plugin = plugin
    }

    public override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary
        let id: String = arguments!["id"] as! String

        switch call.method {
            case "run":
                let params = arguments!["params"] as! [String: Any?]
                run(id: id, params: params) {
                    result(true)
                }
                break
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }

    public func run(id: String, params: [String: Any?], completion: @escaping () -> Void) {
        guard let plugin = plugin else {
            completion()
            return
        }
        let flutterWebView = FlutterWebViewController(plugin: plugin,
            withFrame: CGRect.zero,
            viewIdentifier: id,
            params: params as NSDictionary)
        let headlessInAppWebView = HeadlessInAppWebView(plugin: plugin, id: id, flutterWebView: flutterWebView)
        webViews[id] = headlessInAppWebView

        headlessInAppWebView.prepare(params: params as NSDictionary)
        headlessInAppWebView.onWebViewCreated()

        // Readiness gate: WKWebView can silently DROP a navigation issued
        // while its content process is still booting (the initial about:blank
        // load from makeInitialLoad is in flight and the web process is
        // spawning). A consumer calling loadUrl immediately after run()
        // would see the first real navigation never start — no didStart,
        // no didFinish — and would only discover it via its own timeout.
        // So run() completes only after the initial navigation reaches a
        // terminal state (didFinish or didFail). Signal-driven on purpose:
        // no timeout constant — if no terminal event ever fires, that is a
        // wiring bug that must surface loudly, not be masked by a magic number.
        let webView = flutterWebView.webView()
        var gateFired = false
        webView?.firstNavigationCompleted = { [weak webView] in
            guard !gateFired else { return }
            gateFired = true
            webView?.firstNavigationCompleted = nil
            completion()
        }

        flutterWebView.makeInitialLoad(params: params as NSDictionary)
    }

    public override func dispose() {
        super.dispose()
        let headlessWebViews = webViews.values
        headlessWebViews.forEach { (headlessWebView: HeadlessInAppWebView?) in
            headlessWebView?.dispose()
        }
        webViews.removeAll()
        plugin = nil
    }

    deinit {
        dispose()
    }
}
