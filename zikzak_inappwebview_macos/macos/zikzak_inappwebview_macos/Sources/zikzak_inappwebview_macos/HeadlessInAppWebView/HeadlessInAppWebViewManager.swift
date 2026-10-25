import Foundation
import FlutterMacOS

public class HeadlessInAppWebViewManager: NSObject {
    static let METHOD_CHANNEL_NAME = "wtf.zikzak/flutter_headless_inappwebview"

    /// Hard ceiling on live headless WebViews (issue #371 R4).
    ///
    /// Every headless WebView owns a WebContent process and its own navigation
    /// queue. Creating beyond the cap fails loudly instead of silently growing;
    /// the Dart-side HeadlessWebViewRegistry uses the same platform cap and can
    /// evict an idle instance before the ceiling is ever reached.
    static let maxLiveWebViews = 5

    var registrar: FlutterPluginRegistrar
    var webViews: [String: HeadlessInAppWebView?] = [:]

    /// Live ids, oldest registration first — the cap's ordering.
    private var liveOrder: [String] = []

    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
        let channel = FlutterMethodChannel(name: HeadlessInAppWebViewManager.METHOD_CHANNEL_NAME, binaryMessenger: registrar.messenger)
        channel.setMethodCallHandler(self.handle)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        // Never force-unwrap channel arguments (issue #371 R2): a shared-channel
        // call without an id used to trap on the force-unwrapped id.
        let id = arguments?["id"] as? String

        switch call.method {
            case "run":
                guard let id = id else {
                    result(FlutterError(code: "headless_invalid_arguments", message: "id is null", details: nil))
                    return
                }
                guard let params = arguments?["params"] as? [String: Any] else {
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
                // Tear the instance down, not only its map entry (issue #371 R1).
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

    public func run(id: String, params: [String: Any], completion: @escaping () -> Void) {
        let headlessInAppWebView = HeadlessInAppWebView(manager: self, registrar: registrar, id: id, params: params)
        if let oldHeadlessInAppWebView = instance(id) {
             oldHeadlessInAppWebView.dispose()
        }
        webViews[id] = headlessInAppWebView
        track(id: id)

        headlessInAppWebView.prepare(params: params)
        headlessInAppWebView.onWebViewCreated()

        guard let webView = headlessInAppWebView.webView else {
            completion()
            return
        }

        // Process-readiness ping — a signal-driven replacement for a
        // navigation-based gate. WKWebView can SILENTLY DROP a navigation
        // issued while its WebContent XPC process is still booting (no
        // didStart / didFinish / didFail — the navigation simply never
        // happens), and a fresh macOS WKWebView fires no navigation events
        // at all until an explicit load is issued (no automatic about:blank
        // navigation, unlike iOS). WebKit guarantees that
        // evaluateJavaScript messages are queued until the WebContent
        // process is fully up and its default JS context exists, so the
        // completion handler below is the exact "process ready" signal —
        // local IPC, no network, no timeout constant.
        webView.evaluateJavaScript("true") { [weak webView, weak headlessInAppWebView] (_, _) in
            // Fire the initial load only now: with the process confirmed
            // ready, the navigation cannot be dropped by the boot race. A
            // stalled initial load (slow network) no longer blocks run()
            // either — it proceeds in the background and surfaces through
            // the regular onLoadStart/onReceivedError/onLoadStop events.
            headlessInAppWebView?.webView?.makeInitialLoad(params: params)
            completion()
        }
    }

    public func dispose(id: String) {
        let headlessInAppWebView = instance(id)
        webViews[id] = nil
        liveOrder.removeAll { $0 == id }
        // Dropping the map entry left the native WKWebView alive until the
        // whole plugin tore down; the shared channel is a dispose path now, so
        // it has to release the instance (issue #371 R1).
        headlessInAppWebView?.dispose()
    }

    public func dispose() {
        let headlessWebViews = webViews.values
        headlessWebViews.forEach { (headlessWebView: HeadlessInAppWebView?) in
            headlessWebView?.dispose()
        }
        webViews.removeAll()
        liveOrder.removeAll()
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
