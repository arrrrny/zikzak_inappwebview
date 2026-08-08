//
//  UserScript.swift
//  zikzak_inappwebview
//
//  macOS port of the iOS InAppWebViewUserScript type. Tracks a `groupName`
//  so that `removeUserScriptsByGroupName` can find scripts injected via the
//  Dart `addUserScript` API (WKUserContentController itself has no group
//  concept). See issue #197.
//

import WebKit

public class UserScript: WKUserScript {
    var groupName: String?

    private var contentWorldWrapper: Any?
    var contentWorld: WKContentWorld {
        get {
            if let value = contentWorldWrapper as? WKContentWorld {
                return value
            }
            return .page
        }
        set { contentWorldWrapper = newValue }
    }

    public override init(
        source: String, injectionTime: WKUserScriptInjectionTime, forMainFrameOnly: Bool
    ) {
        super.init(
            source: source, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly)
    }

    public init(
        groupName: String?, source: String, injectionTime: WKUserScriptInjectionTime,
        forMainFrameOnly: Bool
    ) {
        super.init(
            source: source, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly)
        self.groupName = groupName
    }

    public init(
        groupName: String?, source: String, injectionTime: WKUserScriptInjectionTime,
        forMainFrameOnly: Bool, in contentWorld: WKContentWorld
    ) {
        super.init(
            source: source, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly,
            in: contentWorld)
        self.groupName = groupName
        self.contentWorld = contentWorld
    }

    public static func fromMap(map: [String: Any?]?) -> UserScript? {
        guard let map = map else { return nil }
        let source = map["source"] as! String
        let injectionTime =
            WKUserScriptInjectionTime.init(rawValue: map["injectionTime"] as! Int)
            ?? .atDocumentStart
        let forMainFrameOnly = map["forMainFrameOnly"] as! Bool
        let groupName = map["groupName"] as? String

        if let contentWorldMap = map["contentWorld"] as? [String: Any?] {
            let contentWorld = WKContentWorld.fromMap(map: contentWorldMap)!
            return UserScript(
                groupName: groupName, source: source, injectionTime: injectionTime,
                forMainFrameOnly: forMainFrameOnly, in: contentWorld)
        }
        return UserScript(
            groupName: groupName, source: source, injectionTime: injectionTime,
            forMainFrameOnly: forMainFrameOnly)
    }
}
