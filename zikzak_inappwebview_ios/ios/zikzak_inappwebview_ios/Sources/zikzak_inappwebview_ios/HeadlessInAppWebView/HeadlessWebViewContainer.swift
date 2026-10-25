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

    /// Views whose `attach` ran before a scene existed. Held weakly: the caller
    /// owns the WebView, and a disposed one must not keep the container alive.
    private var pendingViews: [WeakView] = []
    private var sceneObserver: NSObjectProtocol?

    private init() {}

    /// Ensures [view] is hosted by the container.
    ///
    /// Returns `false` when no scene is connected yet — the caller still owns a
    /// ready view, and the view is attached as soon as a scene activates
    /// (`UIScene.didActivateNotification`), or on the next `attach` call.
    @discardableResult
    public func attach(_ view: UIView, scene: UIWindowScene?) -> Bool {
        guard let host = ensureHostView(scene: scene) else {
            enqueuePending(view)
            return false
        }
        if view.superview !== host {
            host.addSubview(view)
        }
        return true
    }

    /// Removes [view] from the container, if it is currently hosted there.
    public func detach(_ view: UIView) {
        pendingViews.removeAll { $0.view === view }
        if view.superview === hostView {
            view.removeFromSuperview()
        }
    }

    /// Tears the container window down. Called when the plugin detaches.
    public func dispose() {
        removeSceneObserver()
        pendingViews.removeAll()
        hostView?.subviews.forEach { $0.removeFromSuperview() }
        window?.isHidden = true
        window = nil
        hostView = nil
    }

    private func enqueuePending(_ view: UIView) {
        pendingViews.removeAll { $0.view == nil }
        if !pendingViews.contains(where: { $0.view === view }) {
            pendingViews.append(WeakView(view))
        }
        installSceneObserver()
    }

    /// Observes the first scene activation so a view attached before any scene
    /// existed stops waiting. Without this the "next `attach` retries" promise
    /// was empty: `prepare()` is the only caller and runs once.
    private func installSceneObserver() {
        guard sceneObserver == nil else { return }
        sceneObserver = NotificationCenter.default.addObserver(
            forName: UIScene.didActivateNotification, object: nil, queue: .main
        ) { [weak self] _ in
            self?.attachPendingViews()
        }
    }

    private func removeSceneObserver() {
        if let sceneObserver = sceneObserver {
            NotificationCenter.default.removeObserver(sceneObserver)
            self.sceneObserver = nil
        }
    }

    private func attachPendingViews() {
        let views = pendingViews.compactMap { $0.view }
        pendingViews.removeAll()
        guard let host = ensureHostView(scene: nil) else {
            pendingViews = views.map { WeakView($0) }
            return
        }
        for view in views where view.superview !== host {
            host.addSubview(view)
        }
        removeSceneObserver()
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

/// Weak reference holder for [HeadlessWebViewContainer.pendingViews].
private final class WeakView {
    weak var view: UIView?

    init(_ view: UIView) {
        self.view = view
    }
}
