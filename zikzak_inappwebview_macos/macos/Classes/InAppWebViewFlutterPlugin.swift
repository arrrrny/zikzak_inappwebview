import Cocoa
import FlutterMacOS

public class InAppWebViewFlutterPlugin: NSObject, FlutterPlugin {
    var headlessInAppWebViewManager: HeadlessInAppWebViewManager?
    var inAppBrowserManager: InAppBrowserManager?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.pichillilorenzo/flutter_inappwebview", binaryMessenger: registrar.messenger)
        let instance = InAppWebViewFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let factory = InAppWebViewFactory(registrar: registrar)
        registrar.register(factory, withId: "com.pichillilorenzo/flutter_inappwebview")
        
        instance.headlessInAppWebViewManager = HeadlessInAppWebViewManager(registrar: registrar)
        instance.inAppBrowserManager = InAppBrowserManager(registrar: registrar)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(FlutterMethodNotImplemented)
    }
}
