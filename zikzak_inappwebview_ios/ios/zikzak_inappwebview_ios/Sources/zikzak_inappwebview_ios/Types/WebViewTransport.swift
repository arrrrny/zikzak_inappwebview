//
//  WebViewTransport.swift
//  zikzak_inappwebview
//
//  Created by ARRRRNY on 16/02/21.
//

import UIKit

public class WebViewTransport: NSObject {
    var webView: InAppWebView
    var request: URLRequest
    
    init(webView: InAppWebView, request: URLRequest) {
        self.webView = webView
        self.request = request
    }
}
