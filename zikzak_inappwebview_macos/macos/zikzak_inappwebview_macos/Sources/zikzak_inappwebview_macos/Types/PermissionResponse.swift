//
//  PermissionResponse.swift
//  zikzak_inappwebview
//
//  Ported from iOS. Decodes the map returned by the Dart-side
//  onPermissionRequest callback so the WKUIDelegate can map `action` to a
//  WKPermissionDecision:
//    0 -> .deny, 1 -> .grant, 2 -> .prompt
//  `resources` is currently unused by the WebKit decision path (the action is
//  applied to the single requested resource), but is preserved for parity with
//  the iOS port and the Dart PermissionResponse contract.
//
//  NOTE: on macOS the FlutterMethodChannel result callback delivers an
//  NSDictionary bridged to [String: Any] (not [String: Any?]), so fromMap
//  accepts [String: Any]? here — unlike the iOS port which goes through the
//  WebViewChannelDelegate BaseCallbackResult and uses [String: Any?]?.
//

import Foundation

public class PermissionResponse: NSObject {
    var resources: [Any]
    var action: Int?

    public init(resources: [Any], action: Int? = nil) {
        self.resources = resources
        self.action = action
    }

    public static func fromMap(map: [String: Any]?) -> PermissionResponse? {
        guard let map = map else {
            return nil
        }
        let resources = map["resources"] as? [Any] ?? []
        let action = map["action"] as? Int
        return PermissionResponse(resources: resources, action: action)
    }
}
