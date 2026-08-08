//
//  WKSecurityOrigin.swift
//  zikzak_inappwebview
//
//  Ported from iOS so PermissionRequest.toMap() can serialise the security
//  origin of the frame that initiated a media-capture permission request.
//  The Dart SecurityOrigin.fromMap expects exactly: host, port, protocol.
//

import WebKit

extension WKSecurityOrigin {
    public func toMap() -> [String: Any?] {
        return [
            "host": host,
            "port": port,
            "protocol": self.protocol,
        ]
    }
}
