import Foundation
import FlutterMacOS
import WebKit

public class HeadlessInAppWebView: NSObject {
    var id: String
    var channelDelegate: HeadlessWebViewChannelDelegate?
    var webView: InAppWebView?
    var registrar: FlutterPluginRegistrar
    weak var manager: HeadlessInAppWebViewManager?
    private var offscreenWindow: NSWindow?

    public init(manager: HeadlessInAppWebViewManager, registrar: FlutterPluginRegistrar, id: String, params: [String: Any]) {
        self.id = id
        self.manager = manager
        self.registrar = registrar
        super.init()

        self.webView = InAppWebView(registrar: registrar, viewId: id, arguments: params)

        let channel = FlutterMethodChannel(name: "wtf.zikzak/flutter_headless_inappwebview_" + id,
                                           binaryMessenger: registrar.messenger)
        self.channelDelegate = HeadlessWebViewChannelDelegate(headlessWebView: self, channel: channel)
    }

    public func prepare(params: [String: Any]) {
        let width: Double
        let height: Double
        if let sizeMap = params["initialSize"] as? [String: Any],
           let w = sizeMap["width"] as? Double,
           let h = sizeMap["height"] as? Double {
            width = w
            height = h
        } else {
            width = 500
            height = 500
        }

        webView?.frame = NSRect(x: 0, y: 0, width: width, height: height)

        // Host the WebView in an off-screen window. WKWebView on macOS
        // needs to be in a view hierarchy for proper rendering and JS
        // execution, but adding it to the main window would cause it to
        // intercept mouse events behind the Flutter view surface.
        // An off-screen window provides the needed hierarchy without
        // any user-visible or interactive side effects.
        let window = NSWindow(
            contentRect: NSRect(x: -5000, y: -5000, width: width, height: height),
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.contentView?.addSubview(webView!)
        offscreenWindow = window
    }

    public func onWebViewCreated() {
        channelDelegate?.onWebViewCreated()
    }

    public func setSize(size: [String: Any]) {
        if let width = size["width"] as? Double,
           let height = size["height"] as? Double {
            webView?.frame = NSRect(x: 0, y: 0, width: width, height: height)
        }
    }

    public func getSize() -> [String: Any]? {
        if let view = webView {
            return ["width": view.frame.width, "height": view.frame.height]
        }
        return nil
    }

    public func dispose() {
        channelDelegate?.dispose()
        channelDelegate = nil
        webView?.removeFromSuperview()
        webView?.dispose()
        webView = nil
        offscreenWindow?.close()
        offscreenWindow = nil
        manager?.dispose(id: id)
        manager = nil
    }

    deinit {
        dispose()
    }
}
