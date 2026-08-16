import Foundation
import FlutterMacOS

public class HeadlessInAppWebViewManager: NSObject {
    static let METHOD_CHANNEL_NAME = "wtf.zikzak/flutter_headless_inappwebview"
    var registrar: FlutterPluginRegistrar
    var webViews: [String: HeadlessInAppWebView?] = [:]
    
    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
        let channel = FlutterMethodChannel(name: HeadlessInAppWebViewManager.METHOD_CHANNEL_NAME, binaryMessenger: registrar.messenger)
        channel.setMethodCallHandler(self.handle)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        let id = arguments?["id"] as? String

        switch call.method {
            case "run":
                let params = arguments?["params"] as? [String: Any]
                run(id: id!, params: params!) {
                    result(true)
                }
                break
            case "dispose":
                if let id = id {
                    dispose(id: id)
                    result(true)
                } else {
                    result(FlutterError(code: "HeadlessInAppWebViewManager", message: "id is null", details: nil))
                }
                break
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }

    public func run(id: String, params: [String: Any], completion: @escaping () -> Void) {
        let headlessInAppWebView = HeadlessInAppWebView(manager: self, registrar: registrar, id: id, params: params)
        if let oldHeadlessInAppWebView = webViews[id] {
             oldHeadlessInAppWebView?.dispose()
        }
        webViews[id] = headlessInAppWebView

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
        webViews[id] = nil
    }
    
    public func dispose() {
        let headlessWebViews = webViews.values
        headlessWebViews.forEach { (headlessWebView: HeadlessInAppWebView?) in
            headlessWebView?.dispose()
        }
        webViews.removeAll()
    }
}
