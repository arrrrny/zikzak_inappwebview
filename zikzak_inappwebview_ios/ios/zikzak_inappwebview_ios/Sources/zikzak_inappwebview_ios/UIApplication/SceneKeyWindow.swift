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
    /// connected `UIWindowScene`s: the foreground-active scene's `keyWindow`
    /// when one is connected, otherwise any other connected scene's
    /// `keyWindow` (e.g. a lookup while the app is transitioning between
    /// activation states). The fallback is scene-level, not keyWindow-level:
    /// another scene is consulted only when no foreground-active scene is
    /// connected — a foreground-active scene whose `keyWindow` is momentarily
    /// `nil` (all its windows hidden, mid-relayout) yields `nil`.
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
