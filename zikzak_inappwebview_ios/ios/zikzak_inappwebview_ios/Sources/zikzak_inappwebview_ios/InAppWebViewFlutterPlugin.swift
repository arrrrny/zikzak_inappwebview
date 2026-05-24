import Flutter

@objc(InAppWebViewFlutterPlugin)
public class InAppWebViewFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        SwiftFlutterPlugin.register(with: registrar)
    }
}
