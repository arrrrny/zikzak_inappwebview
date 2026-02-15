import Cocoa
import FlutterMacOS
import WebKit

public class InAppBrowserWebView: InAppWebView {
    weak var browserController: InAppBrowserWebViewController?
    
    public override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "close":
                browserController?.close()
                result(true)
                break
            case "show":
                browserController?.window?.makeKeyAndOrderFront(nil)
                result(true)
                break
            case "hide":
                browserController?.window?.orderOut(nil)
                result(true)
                break
            case "isHidden":
                result(!(browserController?.window?.isVisible ?? false))
                break
            default:
                super.handle(call, result: result)
                break
        }
    }
}

public class InAppBrowserWebViewController: NSWindowController, NSWindowDelegate {
    var manager: InAppBrowserManager
    var id: String
    var windowId: Int?
    var webView: InAppBrowserWebView?
    
    init(manager: InAppBrowserManager, id: String, windowId: Int?) {
        self.manager = manager
        self.id = id
        self.windowId = windowId
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered, defer: false)
        super.init(window: window)
        
        window.delegate = self
        window.title = "InAppBrowser"
        window.center()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func prepare(urlRequest: [String: Any]?, assetFilePath: String?, data: String?, mimeType: String?, encoding: String?, baseUrl: String?, historyUrl: String?, settings: [String: Any]?, contextMenu: [String: Any]?, initialUserScripts: [[String: Any]]?, menuItems: [[String: Any]]?) {
        
        let channelName = "com.pichillilorenzo/flutter_inappbrowser_\(id)"
        
        // Setup WebView
        let arguments: [String: Any] = [
            "initialUrlRequest": urlRequest ?? [:],
            "initialUserScripts": initialUserScripts ?? [],
            "settings": settings ?? [:]
        ]
        
        webView = InAppBrowserWebView(registrar: manager.registrar, viewId: id, arguments: arguments, channelName: channelName)
        webView?.frame = window?.contentView?.bounds ?? NSRect(x: 0, y: 0, width: 800, height: 600)
        webView?.autoresizingMask = [.width, .height]
        webView?.browserController = self
        window?.contentView = webView
        
        // Handle loading if not handled by init arguments
        if urlRequest == nil {
             if let assetFilePath = assetFilePath {
                 let key = manager.registrar.lookupKey(forAsset: assetFilePath)
                 if let path = Bundle.main.path(forResource: key, ofType: nil) {
                     let url = URL(fileURLWithPath: path)
                     webView?.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
                 }
            } else if let data = data {
                 webView?.loadHTMLString(data, baseURL: baseUrl != nil ? URL(string: baseUrl!) : nil)
            }
        }
        
        // Notify browser created
        webView?.channel?.invokeMethod("onBrowserCreated", arguments: [:])
    }
    
    public func windowWillClose(_ notification: Notification) {
        webView?.channel?.invokeMethod("onExit", arguments: [:])
        webView?.dispose()
        webView = nil
        manager.dispose(id: id)
    }
}
