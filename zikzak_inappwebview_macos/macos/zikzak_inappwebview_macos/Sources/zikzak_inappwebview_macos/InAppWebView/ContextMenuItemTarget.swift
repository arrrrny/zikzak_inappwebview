//
//  ContextMenuItemTarget.swift
//  zikzak_inappwebview
//
//  Target-action bridge for custom NSMenu items on macOS.
//  NSMenuItem uses the target/action pattern (no block API), so each custom
//  item is paired with a dedicated target object that holds the Dart-supplied
//  id/title and invokes the channel callback when the item is clicked.
//  https://github.com/arrrrny/zikzak_inappwebview/issues/196
//

import AppKit

/// Holds the Dart metadata for a single custom context-menu item and acts as
/// the NSMenuItem target. Kept alive by being retained on the owning
/// `InAppWebView` for the lifetime of the menu.
public class ContextMenuItemTarget: NSObject {
    public let id: Any
    public let title: String
    private let onClick: (Any, String) -> Void

    public init(id: Any, title: String, onClick: @escaping (Any, String) -> Void) {
        self.id = id
        self.title = title
        self.onClick = onClick
        super.init()
    }

    @objc func itemClicked() {
        onClick(id, title)
    }
}
