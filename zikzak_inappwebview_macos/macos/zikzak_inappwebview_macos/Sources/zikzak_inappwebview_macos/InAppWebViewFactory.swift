import Cocoa
import FlutterMacOS

public class InAppWebViewFactory: NSObject, FlutterPlatformViewFactory {
    private var registrar: FlutterPluginRegistrar
    private static var associationKey: UInt8 = 0

    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
    }

    public func create(withViewIdentifier viewId: Int64, arguments args: Any?) -> NSView {
        let container = NSView(frame: .zero)
        container.clipsToBounds = true
        container.autoresizesSubviews = true
        container.autoresizingMask = [.width, .height]

        if let args = args as? [String: Any],
            let windowId = args["windowId"] as? Int64,
            let webView = InAppWebView.windowWebViews[windowId]
        {
            // Reparent an existing popup webview created by createWebViewWith
            // into this new Flutter platform view. Close the temporary
            // off-screen window and attach the webview to the container.
            webView.popupWindow?.close()
            webView.popupWindow = nil
            webView.bindChannels(registrar: registrar, viewId: viewId)
            webView.frame = container.bounds
            webView.autoresizingMask = [.width, .height]
            container.addSubview(webView)
            return container
        }

        let webViewController = FlutterWebViewController(
            registrar: registrar,
            withFrame: .zero,
            viewId: viewId,
            arguments: args)

        // Keep the FlutterWebViewController alive by associating it with the
        // container view. Flutter retains the view, so the controller stays
        // alive as long as the view is in the hierarchy.
        objc_setAssociatedObject(
            webViewController.view(),
            &Self.associationKey,
            webViewController,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return webViewController.view()
    }

    public func createArgsCodec() -> (FlutterMessageCodec & NSObjectProtocol)? {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
