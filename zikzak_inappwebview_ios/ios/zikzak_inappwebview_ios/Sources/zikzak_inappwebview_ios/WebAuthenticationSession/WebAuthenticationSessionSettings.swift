//
//  WebAuthenticationSessionSettings.swift
//  zikzak_inappwebview
//
//  Created by ARRRRNY on 08/05/22.
//

import UIKit
import AuthenticationServices
import SafariServices

@objcMembers
public class WebAuthenticationSessionSettings: ISettings<WebAuthenticationSession> {

    var prefersEphemeralWebBrowserSession = false
    var additionalHeaderFields: [String: String]?

    override init(){
        super.init()
    }

    override func getRealSettings(obj: WebAuthenticationSession?) -> [String: Any?] {
        var realOptions: [String: Any?] = toMap()
        if #available(iOS 12.0, *), let session = obj?.session as? ASWebAuthenticationSession {
            if #available(iOS 13.0, *) {
                realOptions["prefersEphemeralWebBrowserSession"] = session.prefersEphemeralWebBrowserSession
            }
            if #available(iOS 17.4, *) {
                realOptions["additionalHeaderFields"] = session.additionalHeaderFields
            }
        }
        return realOptions
    }
}
