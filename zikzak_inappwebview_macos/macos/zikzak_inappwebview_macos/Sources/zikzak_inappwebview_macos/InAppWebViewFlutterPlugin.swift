import Cocoa
import FlutterMacOS

public class InAppWebViewFlutterPlugin: NSObject, FlutterPlugin {
    var headlessInAppWebViewManager: HeadlessInAppWebViewManager?
    var inAppBrowserManager: InAppBrowserManager?
    var myCookieManager: MyCookieManager?
    var credentialDatabase: CredentialDatabase?
    var printJobManager: PrintJobManager?
    var registrar: FlutterPluginRegistrar?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "dev.zuzu/zikzak_inappwebview", binaryMessenger: registrar.messenger)
        let instance = InAppWebViewFlutterPlugin()
        instance.registrar = registrar
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let factory = InAppWebViewFactory(registrar: registrar, plugin: instance)
        registrar.register(factory, withId: "dev.zuzu/zikzak_inappwebview")
        
        instance.headlessInAppWebViewManager = HeadlessInAppWebViewManager(registrar: registrar)
        instance.inAppBrowserManager = InAppBrowserManager(registrar: registrar)
        instance.myCookieManager = MyCookieManager(registrar: registrar)
        instance.credentialDatabase = CredentialDatabase(plugin: instance)
        instance.printJobManager = PrintJobManager(plugin: instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(FlutterMethodNotImplemented)
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        headlessInAppWebViewManager = nil
        inAppBrowserManager = nil
        myCookieManager = nil
        credentialDatabase?.dispose()
        credentialDatabase = nil
        printJobManager?.dispose()
        printJobManager = nil
    }
}
