//
//  WKFrameInfo.swift
//  zikzak_inappwebview
//
//  Ported from iOS so PermissionRequest.toMap() can serialise the frame that
//  initiated a media-capture permission request. The Dart FrameInfo.fromMap
//  expects: isMainFrame, request (map), securityOrigin (map).
//
//  NOTE: `self.request` can throw EXC_BREAKPOINT when the WKFrameInfo comes
//  from a WKNavigationAction.sourceFrame, so we read it via valueForKey as
//  the iOS port does, falling back to nil.
//

import WebKit

extension WKFrameInfo {
    public func toMap() -> [String: Any?] {
        let securityOrigin: [String: Any?]? = self.securityOrigin.toMap()
        // self.request throws EXC_BREAKPOINT when coming from
        // WKNavigationAction.sourceFrame; read via KVC like the iOS port.
        let request: URLRequest? = self.value(forKey: "request") as? URLRequest
        return [
            "isMainFrame": isMainFrame,
            "request": request?.toMap(),
            "securityOrigin": securityOrigin,
        ]
    }
}
