import Cocoa
import FlutterMacOS

public class InAppBrowserManager: NSObject {
    static let METHOD_CHANNEL_NAME = "com.pichillilorenzo/flutter_inappbrowser"
    var registrar: FlutterPluginRegistrar
    var browsers: [String: InAppBrowserWebViewController] = [:]
    
    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
        let channel = FlutterMethodChannel(name: InAppBrowserManager.METHOD_CHANNEL_NAME, binaryMessenger: registrar.messenger)
        channel.setMethodCallHandler(self.handle)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        
        switch call.method {
            case "open":
                let id = arguments?["id"] as! String
                let urlRequest = arguments?["urlRequest"] as? [String: Any]
                let assetFilePath = arguments?["assetFilePath"] as? String
                let data = arguments?["data"] as? String
                let mimeType = arguments?["mimeType"] as? String
                let encoding = arguments?["encoding"] as? String
                let baseUrl = arguments?["baseUrl"] as? String
                let historyUrl = arguments?["historyUrl"] as? String
                let settings = arguments?["settings"] as? [String: Any]
                let contextMenu = arguments?["contextMenu"] as? [String: Any]
                let windowId = arguments?["windowId"] as? Int
                let initialUserScripts = arguments?["initialUserScripts"] as? [[String: Any]]
                let menuItems = arguments?["menuItems"] as? [[String: Any]]
                
                open(id: id, urlRequest: urlRequest, assetFilePath: assetFilePath, data: data, mimeType: mimeType, encoding: encoding, baseUrl: baseUrl, historyUrl: historyUrl, settings: settings, contextMenu: contextMenu, windowId: windowId, initialUserScripts: initialUserScripts, menuItems: menuItems)
                result(true)
                break
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }
    
    public func open(id: String, urlRequest: [String: Any]?, assetFilePath: String?, data: String?, mimeType: String?, encoding: String?, baseUrl: String?, historyUrl: String?, settings: [String: Any]?, contextMenu: [String: Any]?, windowId: Int?, initialUserScripts: [[String: Any]]?, menuItems: [[String: Any]]?) {
        let browser = InAppBrowserWebViewController(manager: self, id: id, windowId: windowId)
        browsers[id] = browser
        browser.prepare(urlRequest: urlRequest, assetFilePath: assetFilePath, data: data, mimeType: mimeType, encoding: encoding, baseUrl: baseUrl, historyUrl: historyUrl, settings: settings, contextMenu: contextMenu, initialUserScripts: initialUserScripts, menuItems: menuItems)
        browser.showWindow(self)
        browser.window?.makeKeyAndOrderFront(nil)
    }
    
    public func dispose(id: String) {
        browsers[id] = nil
    }
}
