import Foundation
import FlutterMacOS
import WebKit

public class HeadlessInAppWebView: NSObject {
    var id: String
    var channelDelegate: HeadlessWebViewChannelDelegate?
    var webView: InAppWebView?
    var registrar: FlutterPluginRegistrar
    weak var manager: HeadlessInAppWebViewManager?
    
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
        if let sizeMap = params["initialSize"] as? [String: Any],
           let width = sizeMap["width"] as? Double,
           let height = sizeMap["height"] as? Double {
            webView?.frame = NSRect(x: 0, y: 0, width: width, height: height)
        } else {
            webView?.frame = NSRect(x: 0, y: 0, width: 500, height: 500)
        }
        
        if let window = NSApplication.shared.mainWindow ?? NSApplication.shared.windows.first {
            webView?.alphaValue = 0.01
            window.contentView?.addSubview(webView!, positioned: .below, relativeTo: nil)
        }
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
        manager?.dispose(id: id)
        manager = nil
    }
    
    deinit {
        dispose()
    }
}
