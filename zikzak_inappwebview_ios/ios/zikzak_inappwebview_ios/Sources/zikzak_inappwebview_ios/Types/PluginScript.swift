//
//  PluginScript.swift
//  zikzak_inappwebview
//
//  Created by ARRRRNY on 17/02/21.
//

import Foundation
import WebKit

public class PluginScript: UserScript {
    var requiredInAllContentWorlds = false
    var messageHandlerNames: [String] = []
    
    public override init(source: String, injectionTime: WKUserScriptInjectionTime, forMainFrameOnly: Bool) {
        super.init(source: source, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly)
    }
    
    public init(groupName: String, source: String, injectionTime: WKUserScriptInjectionTime, forMainFrameOnly: Bool, requiredInAllContentWorlds: Bool = false, messageHandlerNames: [String] = []) {
        super.init(groupName: groupName, source: source, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly)
        self.requiredInAllContentWorlds = requiredInAllContentWorlds
        self.messageHandlerNames = messageHandlerNames
    }

    public override init(source: String, injectionTime: WKUserScriptInjectionTime, forMainFrameOnly: Bool, in contentWorld: WKContentWorld) {
        super.init(source: source, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly, in: contentWorld)
        self.contentWorld = contentWorld
    }

    public init(source: String, injectionTime: WKUserScriptInjectionTime, forMainFrameOnly: Bool, in contentWorld: WKContentWorld, requiredInAllContentWorlds: Bool = false, messageHandlerNames: [String] = []) {
        super.init(source: source, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly, in: contentWorld)
        self.requiredInAllContentWorlds = requiredInAllContentWorlds
        self.messageHandlerNames = messageHandlerNames
    }

    public init(groupName: String, source: String, injectionTime: WKUserScriptInjectionTime, forMainFrameOnly: Bool, in contentWorld: WKContentWorld, requiredInAllContentWorlds: Bool = false, messageHandlerNames: [String] = []) {
        super.init(groupName: groupName, source: source, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly, in: contentWorld)
        self.requiredInAllContentWorlds = requiredInAllContentWorlds
        self.messageHandlerNames = messageHandlerNames
    }
    
    public func copyAndSet(groupName: String? = nil,
                           source: String? = nil,
                           injectionTime: WKUserScriptInjectionTime? = nil,
                           forMainFrameOnly: Bool? = nil,
                           requiredInAllContentWorlds: Bool? = nil,
                           messageHandlerNames: [String]? = nil) -> PluginScript {
        return PluginScript(
            groupName: groupName ?? self.groupName!,
            source: source ?? self.source,
            injectionTime: injectionTime ?? self.injectionTime,
            forMainFrameOnly: forMainFrameOnly ?? self.isForMainFrameOnly,
            in: self.contentWorld,
            requiredInAllContentWorlds: requiredInAllContentWorlds ?? self.requiredInAllContentWorlds,
            messageHandlerNames: messageHandlerNames ?? self.messageHandlerNames
        )
    }

    public func copyAndSet(groupName: String? = nil,
                           source: String? = nil,
                           injectionTime: WKUserScriptInjectionTime? = nil,
                           forMainFrameOnly: Bool? = nil,
                           contentWorld: WKContentWorld? = nil,
                           requiredInAllContentWorlds: Bool? = nil,
                           messageHandlerNames: [String]? = nil) -> PluginScript {
        return PluginScript(
            groupName: groupName ?? self.groupName!,
            source: source ?? self.source,
            injectionTime: injectionTime ?? self.injectionTime,
            forMainFrameOnly: forMainFrameOnly ?? self.isForMainFrameOnly,
            in: contentWorld ?? self.contentWorld,
            requiredInAllContentWorlds: requiredInAllContentWorlds ?? self.requiredInAllContentWorlds,
            messageHandlerNames: messageHandlerNames ?? self.messageHandlerNames
        )
    }

    static func == (lhs: PluginScript, rhs: PluginScript) -> Bool {
        return lhs.groupName == rhs.groupName &&
            lhs.source == rhs.source &&
            lhs.injectionTime == rhs.injectionTime &&
            lhs.isForMainFrameOnly == rhs.isForMainFrameOnly &&
            lhs.contentWorld == rhs.contentWorld &&
            lhs.requiredInAllContentWorlds == rhs.requiredInAllContentWorlds &&
            lhs.messageHandlerNames == rhs.messageHandlerNames
    }
}
