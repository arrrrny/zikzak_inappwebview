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

        // Readiness gate — same WKWebView process-boot race as iOS: a
        // navigation issued while the content process is still starting can
        // be silently dropped. The initial load is fired inside
        // InAppWebView.init (synchronously, before this point), and its
        // terminal event (didFinish / didFail) arrives on a later runloop
        // turn, so arming the hook here still catches it. Signal-driven on
        // purpose: no timeout constant — a missing terminal event is a wiring
        // bug that must surface loudly, not be masked by a magic number.
        // If no initial load was requested there is nothing to wait for —
        // complete immediately.
        // If no initial load was requested there is nothing to wait for —
        // complete immediately.
        guard params["initialUrlRequest"] != nil
            || params["initialFile"] != nil
            || params["initialData"] != nil,
            let webView = headlessInAppWebView.webView else {
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
