//
//  WKSecurityOrigin.swift
//  zikzak_inappwebview
//
//  Created by ARRRRNY on 19/02/21.
//

import Foundation
import WebKit

extension WKSecurityOrigin {
    public func toMap () -> [String:Any?] {
        return [
            "host": host,
            "port": port,
            "protocol": self.protocol
        ]
    }
}
