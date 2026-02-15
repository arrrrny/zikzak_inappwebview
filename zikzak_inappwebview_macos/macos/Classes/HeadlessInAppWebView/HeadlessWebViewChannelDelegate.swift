import Foundation
import FlutterMacOS

public class HeadlessWebViewChannelDelegate: NSObject {
    private weak var headlessWebView: HeadlessInAppWebView?
    private var channel: FlutterMethodChannel
    
    public init(headlessWebView: HeadlessInAppWebView, channel: FlutterMethodChannel) {
        self.headlessWebView = headlessWebView
        self.channel = channel
        super.init()
        self.channel.setMethodCallHandler(self.handle)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        
        switch call.method {
        case "dispose":
            if let headlessWebView = headlessWebView {
                headlessWebView.dispose()
                result(true)
            } else {
                result(false)
            }
            break
        case "setSize":
            if let headlessWebView = headlessWebView {
                let sizeMap = arguments!["size"] as? [String: Any]
                headlessWebView.setSize(size: sizeMap!)
                result(true)
            } else {
                result(false)
            }
            break
        case "getSize":
            result(headlessWebView?.getSize())
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
    
    public func onWebViewCreated() {
        let arguments: [String: Any] = [:]
        channel.invokeMethod("onWebViewCreated", arguments: arguments)
    }
    
    public func dispose() {
        headlessWebView = nil
        channel.setMethodCallHandler(nil)
    }
    
    deinit {
        dispose()
    }
}
