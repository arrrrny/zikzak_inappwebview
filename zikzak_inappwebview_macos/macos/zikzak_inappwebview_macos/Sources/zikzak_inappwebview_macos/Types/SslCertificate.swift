//
//  SslCertificate.swift
//  zikzak_inappwebview
//
//  macOS port of the iOS SslCertificate type. On macOS WKWebView does not
//  expose the server trust object directly (there is no public
//  `serverTrust` property), so the certificate is only populated when the
//  WKNavigationDelegate auth-challenge flow caches it. Until that flow is
//  ported (tracked separately — see the macOS auth-challenges branch),
//  `InAppWebView.getCertificate()` returns nil. The type itself is kept so
//  the Dart side decodes a consistent map shape on both platforms.
//

import Foundation

public class SslCertificate: NSObject {
    var x509Certificate: Data
    var issuedBy: Any?
    var issuedTo: Any?
    var validNotAfterDate: Any?
    var validNotBeforeDate: Any?

    public init(x509Certificate: Data) {
        self.x509Certificate = x509Certificate
    }

    public func toMap() -> [String: Any?] {
        return [
            "x509Certificate": x509Certificate,
            "issuedBy": issuedBy,
            "issuedTo": issuedTo,
            "validNotAfterDate": validNotAfterDate,
            "validNotBeforeDate": validNotBeforeDate,
        ]
    }
}
