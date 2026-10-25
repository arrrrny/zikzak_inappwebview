//
//  HeadlessInAppWebViewManager.swift
//  zikzak_inappwebview
//
//  Created by ARRRRNY on 10/05/2020.
//

import Flutter
import UIKit
import WebKit

public class HeadlessInAppWebViewManager: ChannelDelegate {
    static let METHOD_CHANNEL_NAME = "wtf.zikzak/flutter_headless_inappwebview"

    /// Hard ceiling on live headless WebViews (issue #371 R4).
    ///
    /// Every headless WebView owns a WebContent process and its own navigation
    /// queue, so a per-domain scraper that creates one per host used to grow
    /// without bound until the transport's own navigations stopped committing.
    /// Creating beyond the cap fails loudly instead of silently growing; the
    /// Dart-side `HeadlessWebViewRegistry` uses the same platform cap and can
    /// evict an idle instance before the ceiling is ever reached.
    static let maxLiveWebViews = 3

    var plugin: SwiftFlutterPlugin?
    var webViews: [String: HeadlessInAppWebView?] = [:]

    /// Live ids, oldest registration first — the cap's ordering.
    private var liveOrder: [String] = []

    init(plugin: SwiftFlutterPlugin) {
        super.init(channel: FlutterMethodChannel(name: HeadlessInAppWebViewManager.METHOD_CHANNEL_NAME, binaryMessenger: plugin.registrar!.messenger()))
        self.plugin = plugin
    }

    public override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary
        // Read the id defensively: this used to force-unwrap both the
        // arguments dictionary and the id cast, so a shared-channel call
        // without an id trapped the app instead of returning an error
        // (issue #371 R2).
        let id = arguments?["id"] as? String

        switch call.method {
            case "run":
                guard let id = id else {
                    result(FlutterError(code: "headless_invalid_arguments", message: "id is null", details: nil))
                    return
                }
                guard let params = arguments?["params"] as? [String: Any?] else {
                    result(FlutterError(code: "headless_invalid_arguments", message: "params is null", details: nil))
                    return
                }
                pruneLiveOrder()
                guard instance(id) != nil || liveOrder.count < HeadlessInAppWebViewManager.maxLiveWebViews else {
                    result(FlutterError(
                        code: "headless_cap_exceeded",
                        message: "headless WebView cap reached",
                        details: [
                            "maxLiveWebViews": HeadlessInAppWebViewManager.maxLiveWebViews,
                            "liveWebViews": liveOrder.count,
                        ]))
                    return
                }
                run(id: id, params: params) {
                    result(true)
                }
                break
            case "dispose":
                // The shared manager channel is the one dispose path (issue
                // #371 R1): it releases the instance, not only its map entry.
                guard let id = id else {
                    result(FlutterError(code: "headless_invalid_arguments", message: "id is null", details: nil))
                    return
                }
                dispose(id: id)
                result(true)
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
        track(id: id)

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
        guard let webView = flutterWebView.webView() else {
            // No web view — fail run() immediately instead of leaving the
            // readiness gate unarmed and the caller hanging forever.
            completion()
            return
        }
        var gateFired = false
        webView.firstNavigationCompleted = { [weak webView] in
            guard !gateFired else { return }
            gateFired = true
            webView?.firstNavigationCompleted = nil
            completion()
        }

        flutterWebView.makeInitialLoad(params: params as NSDictionary)
    }

    /// Releases one headless WebView: the instance is torn down and its map
    /// entry removed, so nothing is left alive behind a dropped reference.
    public func dispose(id: String) {
        let headlessInAppWebView = instance(id)
        webViews[id] = nil
        liveOrder.removeAll { $0 == id }
        headlessInAppWebView?.dispose()
    }

    public override func dispose() {
        super.dispose()
        let headlessWebViews = webViews.values
        headlessWebViews.forEach { (headlessWebView: HeadlessInAppWebView?) in
            headlessWebView?.dispose()
        }
        webViews.removeAll()
        liveOrder.removeAll()
        HeadlessWebViewContainer.shared.dispose()
        plugin = nil
    }

    deinit {
        dispose()
    }

    /// The live instance for [id], or `nil` when the entry is absent or empty.
    private func instance(_ id: String) -> HeadlessInAppWebView? {
        return webViews[id] ?? nil
    }

    private func track(id: String) {
        liveOrder.removeAll { $0 == id }
        liveOrder.append(id)
    }

    /// Drops ids whose instance disposed itself through the per-instance
    /// channel, so the cap counts live WebViews rather than dead entries.
    private func pruneLiveOrder() {
        liveOrder.removeAll { instance($0) == nil }
    }
}
