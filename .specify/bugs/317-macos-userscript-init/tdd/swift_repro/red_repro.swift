// RED repro for issue #317 — shape-exact with the PRE-FIX macOS UserScript.
//
// WebKit/FlutterMacOS are unavailable on Linux, so WKUserScript/WKContentWorld
// are stood in by local stubs carrying the same designated-initializer surface
// that WKUserScript exposes (both ObjC designated initializers:
// initWithSource:injectionTime:forMainFrameOnly: and
// initWithSource:injectionTime:forMainFrameOnly:inContentWorld:).
//
// The UserScript subclass below is the macOS implementation as of 0c51cce8
// (three initializers). The consumer call at the bottom constructs the exact
// initializer shape named in issue #317.

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

// ---- macOS UserScript — PRE-FIX shape (0c51cce8) ----------------------------

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
}

// ---- Issue #317 construction site --------------------------------------------

// The initializer shape named in the issue: init(source:injectionTime:forMainFrameOnly:in:)
// With the pre-fix shape this fails to compile because the subclass declares its
// own designated initializers and therefore does not inherit this one from
// WKUserScript.
let script = UserScript(
    source: "window.flutter_inappwebview = {};",
    injectionTime: .atDocumentStart,
    forMainFrameOnly: true,
    in: WKContentWorld.page
)
_ = script
