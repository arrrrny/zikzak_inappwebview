//
//  WKContentWorld.swift
//  zikzak_inappwebview
//
//  macOS port of the iOS WKContentWorld extension. macOS floor is 12.0, so
//  WKContentWorld (available macOS 11+) is always available — no @available
//  gating needed. See issue #197.
//

import WebKit

extension WKContentWorld {
    public static func fromMap(map: [String: Any?]?) -> WKContentWorld? {
        guard let map = map else { return nil }
        let name = map["name"] as! String
        return Util.getContentWorld(name: name)
    }
}
