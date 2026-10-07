//
//  SceneKeyWindow.swift
//  zikzak_inappwebview
//

import UIKit

extension UIApplication {

    /// The app's key window, resolved through the UIScene lifecycle.
    ///
    /// `UIApplication.shared.keyWindow`, `UIApplication.shared.windows` and
    /// `UIApplication.shared.delegate?.window` are deprecated, and the
    /// AppDelegate `window` is `nil` once an app adopts the UIScene lifecycle
    /// (mandatory with the iOS 27 SDK), so window access must go through the
    /// connected `UIWindowScene`s: the foreground-active scene first, then any
    /// other connected scene (e.g. a lookup while the app is transitioning
    /// between activation states).
    ///
    /// `UIWindowScene.keyWindow` is iOS 15.0+, matching this package's
    /// deployment floor, so no availability guard is needed here.
    var sceneKeyWindow: UIWindow? {
        let windowScenes = connectedScenes.compactMap { $0 as? UIWindowScene }
        let foregroundScene = windowScenes.first {
            $0.activationState == .foregroundActive
        }
        return (foregroundScene ?? windowScenes.first)?.keyWindow
    }
}
