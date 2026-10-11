// GREEN repro for issue #317 — shape-exact with the POST-FIX macOS UserScript.
//
// Same WebKit stand-ins and same consumer construction as red_repro.swift, but
// the UserScript subclass now carries the fourth initializer exactly as the fix
// adds it to
// zikzak_inappwebview_macos/macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/Types/UserScript.swift
// (and exactly as the iOS implementation declares it):
//
//   public override init(
//       source: String, injectionTime: WKUserScriptInjectionTime,
//       forMainFrameOnly: Bool, in contentWorld: WKContentWorld
//   )

import Foundation

// ---- WebKit stand-ins -------------------------------------------------------

public enum WKUserScriptInjectionTime: Int {
    case atDocumentStart
    case atDocumentEnd
}

public class WKContentWorld {
    public static let page = WKContentWorld()
    public static let defaultClient = WKContentWorld()
    public init() {}
}

public class WKUserScript {
    public init(source: String, injectionTime: WKUserScriptInjectionTime, forMainFrameOnly: Bool) {}
    public init(source: String, injectionTime: WKUserScriptInjectionTime, forMainFrameOnly: Bool, in contentWorld: WKContentWorld) {}
}

// ---- macOS UserScript — POST-FIX shape ---------------------------------------

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

    public override init(
        source: String, injectionTime: WKUserScriptInjectionTime, forMainFrameOnly: Bool,
        in contentWorld: WKContentWorld
    ) {
        super.init(
            source: source, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly,
            in: contentWorld)
        self.contentWorld = contentWorld
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
}

// ---- Issue #317 construction site --------------------------------------------

// With the fix the initializer named in the issue exists and the construction
// compiles.
let script = UserScript(
    source: "window.flutter_inappwebview = {};",
    injectionTime: .atDocumentStart,
    forMainFrameOnly: true,
    in: WKContentWorld.page
)
_ = script
