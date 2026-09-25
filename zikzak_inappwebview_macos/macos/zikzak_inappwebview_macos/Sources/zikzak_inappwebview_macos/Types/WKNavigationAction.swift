//
//  WKNavigationAction.swift
//  zikzak_inappwebview
//
//  Safe serialization of a WKNavigationAction's source frame.
//
//  On macOS 15.x WebKit can deliver a navigation action whose runtime
//  `sourceFrame` object is nil even though the Swift overlay declares the
//  member non-optional. Reading it as a member performs an unconditional
//  ObjC bridge that traps (EXC_BREAKPOINT in
//  URLRequest._unconditionallyBridgeFromObjectiveC — issue #327), so the
//  frame, its request and its security origin are read via KVC instead: a
//  nil runtime object then yields nil, mirroring the `value(forKey:)` read
//  the package already ships in WKFrameInfo.toMap().
//

import WebKit

extension WKNavigationAction {
    /// Map for the `sourceFrame` channel key, or `nil` when the runtime frame
    /// is absent. When the frame is present the emitted keys and value types
    /// are identical to the pre-#327 handler maps.
    public func sourceFrameMap() -> [String: Any?]? {
        guard let frame = value(forKey: "sourceFrame") as? WKFrameInfo else {
            return nil
        }
        let request: URLRequest? = frame.value(forKey: "request") as? URLRequest
        let origin = frame.value(forKey: "securityOrigin") as? WKSecurityOrigin
        return [
            "isMainFrame": frame.isMainFrame,
            "request": ["url": request?.url?.absoluteString ?? ""],
            "securityOrigin": [
                "host": origin?.host ?? "",
                "port": origin?.port ?? 0,
                "protocol": origin?.protocol ?? "",
            ],
        ]
    }
}
