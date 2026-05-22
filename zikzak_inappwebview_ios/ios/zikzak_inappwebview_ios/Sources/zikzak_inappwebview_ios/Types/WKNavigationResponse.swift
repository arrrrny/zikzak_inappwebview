//
//  WKNavigationResponse.swift
//  zikzak_inappwebview
//
//  Created by ARRRRNY on 19/02/21.
//

import Foundation
import WebKit

extension WKNavigationResponse {
    public func toMap () -> [String:Any?] {
        return [
            "response": response.toMap(),
            "isForMainFrame": isForMainFrame,
            "canShowMIMEType": canShowMIMEType,
        ]
    }
}
