import UIKit

/// Dedicated off-screen host for headless WKWebViews (issue #371 R3).
///
/// Historically every headless WebView was inserted behind the app's key
/// window (`insertSubview(view, at: 0)`), because a WKWebView that is truly
/// detached often refuses to run JavaScript. That made every headless instance
/// a child of the visible app hierarchy: a consumer that creates one per host
/// ended up with several live WebViews rendering inside the app's own window,
/// each holding a WebContent process, and the transport's navigations stopped
/// committing.
///
/// This container keeps the "must be in a real window" property while removing
/// the "must be in the app's window" one: the views live in their own
/// `UIWindow`, attached to the same `UIWindowScene`, below the app's windows and
/// positioned off-screen. It is the iOS counterpart of the macOS implementation,
/// which already hosts headless views in a dedicated off-screen `NSWindow`.
public final class HeadlessWebViewContainer {
    public static let shared = HeadlessWebViewContainer()

    private var window: UIWindow?
    private var hostView: UIView?

    private init() {}

    /// Ensures [view] is hosted by the container.
    ///
    /// Returns `false` when no scene is connected yet — the caller still owns a
    /// ready view, and the next `attach` call retries.
    @discardableResult
    public func attach(_ view: UIView, scene: UIWindowScene?) -> Bool {
        guard let host = ensureHostView(scene: scene) else {
            return false
        }
        if view.superview !== host {
            host.addSubview(view)
        }
        return true
    }

    /// Removes [view] from the container, if it is currently hosted there.
    public func detach(_ view: UIView) {
        if view.superview === hostView {
            view.removeFromSuperview()
        }
    }

    /// Tears the container window down. Called when the plugin detaches.
    public func dispose() {
        hostView?.subviews.forEach { $0.removeFromSuperview() }
        window?.isHidden = true
        window = nil
        hostView = nil
    }

    private func ensureHostView(scene: UIWindowScene?) -> UIView? {
        if let hostView = hostView, let window = window, window.windowScene != nil {
            return hostView
        }

        let resolvedScene = scene ?? UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first
        guard let windowScene = resolvedScene else {
            return nil
        }

        let bounds = windowScene.coordinateSpace.bounds
        let offscreenWindow = UIWindow(
            frame: CGRect(x: -bounds.width, y: 0, width: bounds.width, height: bounds.height))
        offscreenWindow.windowScene = windowScene
        // Below the app's own windows and never interactive: the container must
        // render (JS needs a live, composited window) without ever competing
        // with the app UI for touches or z-order.
        offscreenWindow.windowLevel = UIWindow.Level(rawValue: UIWindow.Level.normal.rawValue - 1)
        offscreenWindow.isUserInteractionEnabled = false
        offscreenWindow.backgroundColor = .clear

        let rootViewController = UIViewController()
        rootViewController.view.backgroundColor = .clear
        offscreenWindow.rootViewController = rootViewController
        offscreenWindow.isHidden = false

        window = offscreenWindow
        hostView = rootViewController.view
        return hostView
    }
}
