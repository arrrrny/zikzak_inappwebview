import Foundation
import FlutterMacOS

public class HeadlessInAppWebViewManager: NSObject {
    static let METHOD_CHANNEL_NAME = "wtf.zikzak/flutter_headless_inappwebview"
    ///Ceiling for how long `run()` waits on the first navigation's terminal
    ///event. Bounds the readiness gate so a dropped/stalled initial load
    ///cannot hang `run()` forever (see `run(id:params:completion:)`).
    static let firstNavigationTimeout: TimeInterval = 15
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

        // Nothing to wait for when no initial load was requested: on macOS a
        // freshly created WKWebView does not fire any navigation event until
        // an explicit load is issued (no automatic about:blank navigation),
        // so arming the gate here would hang run() forever. Dart sends null
        // for absent values, which arrives as NSNull — the `as?` casts below
        // reject both nil and NSNull.
        let hasInitialLoad =
            params["initialUrlRequest"] is [String: Any]
            || params["initialFile"] is String
            || params["initialData"] is [String: Any]
        guard hasInitialLoad else {
            completion()
            return
        }

        // Readiness gate — same WKWebView process-boot race as iOS: a
        // navigation issued while the content process is still starting can
        // be silently dropped. run() therefore completes only after the first
        // navigation reaches a terminal state (didFinish / didFail). The
        // initial load is fired via makeInitialLoad AFTER the hook is armed,
        // so the gate always covers it (parity with the iOS port).
        //
        // The wait is bounded: a dropped or stalled initial load (the very
        // race this gate exists to close, or a slow/stalled network request)
        // must not turn run() into a permanent hang — that surfaces as a
        // headless webview that never becomes "running". The fallback logs a
        // warning and completes anyway; the consumer can then retry with
        // loadUrl once the process has settled.
        var gateFired = false
        let fireGate = { [weak webView] in
            guard !gateFired else { return }
            gateFired = true
            webView?.firstNavigationCompleted = nil
            completion()
        }
        webView.firstNavigationCompleted = { [weak webView] in
            webView?.firstNavigationCompleted = nil
            fireGate()
        }
        DispatchQueue.main.asyncAfter(
            deadline: .now() + HeadlessInAppWebViewManager.firstNavigationTimeout
        ) {
            guard !gateFired else { return }
            NSLog(
                "[zikzak_inappwebview] HeadlessInAppWebView \(id): first navigation did not "
                + "complete within \(HeadlessInAppWebViewManager.firstNavigationTimeout)s; "
                + "completing run() anyway."
            )
            fireGate()
        }

        // Fire the initial load only now, with the gate armed.
        webView.makeInitialLoad(params: params)
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
