import Flutter
import UIKit

//
//  HeadlessInAppWebView.swift
//  zikzak_inappwebview
//
//  Created by ARRRRNY on 26/03/21.
//

public class HeadlessInAppWebView: Disposable {
    static let METHOD_CHANNEL_NAME_PREFIX = "wtf.zikzak/flutter_headless_inappwebview_"

    var id: String
    var channelDelegate: HeadlessWebViewChannelDelegate?
    var flutterWebView: FlutterWebViewController?
    var plugin: SwiftFlutterPlugin?

    public init(plugin: SwiftFlutterPlugin, id: String, flutterWebView: FlutterWebViewController) {
        self.id = id
        self.flutterWebView = flutterWebView
        self.plugin = plugin
        let channel = FlutterMethodChannel(
            name: HeadlessInAppWebView.METHOD_CHANNEL_NAME_PREFIX + id,
            binaryMessenger: plugin.registrar!.messenger())
        self.channelDelegate = HeadlessWebViewChannelDelegate(
            headlessWebView: self, channel: channel)
    }

    public func onWebViewCreated() {
        channelDelegate?.onWebViewCreated()
    }

    public func prepare(params: NSDictionary) {
        if let view = flutterWebView?.view() {
            view.alpha = 1.0
            let initialSize = params["initialSize"] as? [String: Any?]
            if let size = Size2D.fromMap(map: initialSize) {
                setSize(size: size)
            } else {
                view.frame = CGRect(
                    x: 0.0, y: 0.0, width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height)
            }
            /// Note: the WKWebView behaves very unreliable when rendering
            /// offscreen on a device. This is especially true with JavaScript,
            /// which simply won't be executed sometimes.
            /// So, the headless WKWebView has to live in a real window — but
            /// NOT in the app's key window (issue #371 R3): parking an
            /// unbounded number of live WebViews behind the Flutter view made
            /// them part of the visible hierarchy. `HeadlessWebViewContainer`
            /// gives them their own off-screen UIWindow on the same scene,
            /// mirroring what macOS already does with a dedicated NSWindow.
            let scene = UIApplication.shared.sceneKeyWindow?.windowScene
            HeadlessWebViewContainer.shared.attach(view, scene: scene)
        }
    }

    public func setSize(size: Size2D) {
        if let view = flutterWebView?.view() {
            let width = size.width == -1.0 ? UIScreen.main.bounds.width : CGFloat(size.width)
            let height = size.height == -1.0 ? UIScreen.main.bounds.height : CGFloat(size.height)
            view.frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        }
    }

    public func getSize() -> Size2D? {
        if let view = flutterWebView?.view() {
            return Size2D(width: Double(view.frame.width), height: Double(view.frame.height))
        }
        return nil
    }

    public func disposeAndGetFlutterWebView(withFrame frame: CGRect) -> FlutterWebViewController? {
        let newFlutterWebView = flutterWebView
        if let view = flutterWebView?.view() {
            // restore WebView frame and alpha
            view.frame = frame
            view.alpha = 1.0
            // remove from parent
            view.removeFromSuperview()
            dispose(disposeWebView: false)
        }
        return newFlutterWebView
    }

    public func dispose(disposeWebView: Bool) {
        channelDelegate?.dispose()
        channelDelegate = nil
        plugin?.headlessInAppWebViewManager?.webViews[id] = nil
        if disposeWebView {
            flutterWebView?.dispose(removeFromSuperview: true)
        }
        flutterWebView = nil
        plugin = nil
    }

    public func dispose() {
        dispose(disposeWebView: true)
    }

    deinit {
        flutterWebView?.webView()?.stopLoading()
        flutterWebView?.webView()?.configuration.userContentController.removeAllUserScripts()
        dispose()
    }
}
