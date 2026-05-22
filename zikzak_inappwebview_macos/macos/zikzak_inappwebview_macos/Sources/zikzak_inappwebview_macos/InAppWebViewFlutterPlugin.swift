import Cocoa
import FlutterMacOS

public class InAppWebViewFlutterPlugin: NSObject, FlutterPlugin {
    var headlessInAppWebViewManager: HeadlessInAppWebViewManager?
    var inAppBrowserManager: InAppBrowserManager?
    var myCookieManager: MyCookieManager?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "dev.zuzu/flutter_inappwebview", binaryMessenger: registrar.messenger)
        let instance = InAppWebViewFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let factory = InAppWebViewFactory(registrar: registrar)
        registrar.register(factory, withId: "dev.zuzu/flutter_inappwebview")
        
        instance.headlessInAppWebViewManager = HeadlessInAppWebViewManager(registrar: registrar)
        instance.inAppBrowserManager = InAppBrowserManager(registrar: registrar)
        instance.myCookieManager = MyCookieManager(registrar: registrar)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(FlutterMethodNotImplemented)
    }
}
