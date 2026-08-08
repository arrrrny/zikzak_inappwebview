//
//  ContextMenuSettings.swift
//  zikzak_inappwebview
//
//  Ported from iOS to support macOS custom context menus.
//  https://github.com/arrrrny/zikzak_inappwebview/issues/196
//

import Foundation

public class ContextMenuSettings: ISettings<NSObject> {

    /// Whether all the default system context menu items should be hidden or not.
    /// When `true`, only the custom [ContextMenu] menu items are shown.
    /// The default value is `false`.
    var hideDefaultSystemContextMenuItems = false

    override init() {
        super.init()
    }
}
