import Cocoa
import FlutterMacOS

public class InAppWebViewFactory: NSObject, FlutterPlatformViewFactory {
    private var registrar: FlutterPluginRegistrar
    private static var associationKey: UInt8 = 0

    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
    }

    public func create(withViewIdentifier viewId: Int64, arguments args: Any?) -> NSView {
        let webViewController = FlutterWebViewController(
            registrar: registrar,
            withFrame: .zero,
            viewId: viewId,
            arguments: args)

        // Keep the FlutterWebViewController alive by associating it with the
        // container view. Flutter retains the view, so the controller stays
        // alive as long as the view is in the hierarchy.
        objc_setAssociatedObject(
            webViewController.view(),
            &Self.associationKey,
            webViewController,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return webViewController.view()
    }

    public func createArgsCodec() -> (FlutterMessageCodec & NSObjectProtocol)? {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
