import Cocoa
import FlutterMacOS
import WebKit

/// macOS wrapper for an InAppWebView, modelled after the iOS FlutterWebViewController.
///
/// Creates a container NSView that holds the InAppWebView as a subview, mirroring
/// the iOS pattern. This ensures the WKWebView is properly embedded in the view
/// hierarchy with correct sizing via autoresizing masks.
public class FlutterWebViewController: NSObject {
    /// The container view returned to Flutter as the platform view.
    private var myView: NSView?

    /// The InAppWebView managed by this controller.
    private(set) var webView: InAppWebView?

    init(
        registrar: FlutterPluginRegistrar, withFrame frame: NSRect, viewId: Any,
        arguments args: Any?
    ) {
        super.init()

        let container = NSView(frame: frame)
        container.clipsToBounds = true
        container.autoresizesSubviews = true
        container.autoresizingMask = [.width, .height]

        let webView = InAppWebView(
            registrar: registrar, viewId: viewId, arguments: args)
        webView.autoresizingMask = [.width, .height]
        webView.frame = container.bounds
        container.addSubview(webView)

        self.webView = webView
        self.myView = container
    }

    /// Returns the container view for use as the Flutter platform view.
    func view() -> NSView {
        return myView!
    }

    func dispose() {
        webView?.dispose()
        webView?.removeFromSuperview()
        webView = nil
        myView?.removeFromSuperview()
        myView = nil
    }

    deinit {
        dispose()
    }
}
