import Foundation
import WebKit

/// Issue #446 — the trusted web-caller context of a passkey ceremony.
///
/// A WebAuthn ceremony signs the origin of the frame that called
/// `navigator.credentials.get/create`. The app-context
/// `ASAuthorizationPlatformPublicKeyCredentialProvider` request built from a
/// bare challenge leaves that origin to AuthenticationServices, which derives
/// it from the relying-party identifier instead — so an RP used from a
/// cross-origin iframe signed the RP origin (Apple's `https://apple.com` for
/// the `https://idmsa.apple.com` iframe App Store Connect loads) and the
/// server rejected the assertion.
///
/// This context is derived from `WKScriptMessage.frameInfo`, WebKit's own view
/// of the frame the message arrived on, and never from a value the page
/// supplies. `PasskeyBridge` turns it into the `ASPublicKeyCredentialClientData`
/// of a browser request (iOS 17.4+, macOS 13.5+); below that the bridge falls
/// back to the app-context request and its origin limitation stands.
struct PasskeyCallerContext {
    /// Where the calling frame sits relative to the top-level origin.
    ///
    /// Mirrors `ASPublicKeyCredentialClientData.CrossOriginValue`, which the
    /// SDK declares only from iOS 17.4 / macOS 13.5 — the bridge maps this
    /// onto it behind that availability gate.
    enum CrossOrigin {
        /// The calling frame is the top-level frame.
        case notSet
        /// The calling frame's origin differs from the top-level origin.
        case crossOrigin
        /// The calling frame is a subframe whose origin equals the top-level
        /// origin.
        case sameOriginWithAncestors
    }

    /// The calling frame's origin, e.g. `https://idmsa.apple.com`.
    let origin: String

    /// The top-level frame's origin, for a subframe whose top-level document
    /// the bridge can see. Nil for a top-level call, and nil when the webview
    /// has no main-frame URL to compare against.
    let topOrigin: String?

    /// The calling frame's position relative to the top-level origin.
    let crossOrigin: CrossOrigin

    /// Derives the context from the frame a script message arrived on.
    ///
    /// `mainFrameURL` is the URL of the webview's own main frame — the closest
    /// thing to the top-level document this bridge can see. It only decides
    /// whether the caller is cross-origin; the origin that gets signed always
    /// comes from `frameInfo`.
    static func from(frameInfo: WKFrameInfo?, mainFrameURL: URL?) -> PasskeyCallerContext? {
        guard let frameInfo = frameInfo else { return nil }
        let securityOrigin = frameInfo.securityOrigin
        let origin = originString(
            scheme: securityOrigin.`protocol`,
            host: securityOrigin.host,
            port: securityOrigin.port
        )
        guard !origin.isEmpty else { return nil }

        let topOrigin = mainFrameURL.flatMap(originString(from:))
        let isMainFrame = frameInfo.isMainFrame
        return PasskeyCallerContext(
            origin: origin,
            topOrigin: isMainFrame ? nil : topOrigin,
            crossOrigin: crossOrigin(
                isMainFrame: isMainFrame, origin: origin, topOrigin: topOrigin)
        )
    }

    private static func crossOrigin(
        isMainFrame: Bool, origin: String, topOrigin: String?
    ) -> CrossOrigin {
        if isMainFrame { return .notSet }
        // A subframe whose top-level origin the bridge cannot see is not
        // claimed either way: an invented value here is a statement the
        // relying party would act on, and this bridge has nothing to base it
        // on.
        guard let topOrigin = topOrigin, !topOrigin.isEmpty else { return .notSet }
        return origin == topOrigin ? .sameOriginWithAncestors : .crossOrigin
    }

    /// Renders a security origin as the serialization WebAuthn client data
    /// uses: `scheme://host[:port]`, with the scheme's default port omitted so
    /// that a `WKSecurityOrigin` and a parsed `URL` of the same origin render
    /// identically.
    static func originString(scheme: String?, host: String?, port: Int) -> String {
        guard let scheme = scheme?.lowercased(), !scheme.isEmpty,
            let host = host?.lowercased(), !host.isEmpty
        else { return "" }
        var origin = "\(scheme)://\(host)"
        if let port = canonicalPort(port, scheme: scheme) {
            origin += ":\(port)"
        }
        return origin
    }

    static func originString(from url: URL) -> String? {
        guard let scheme = url.scheme, let host = url.host, !host.isEmpty else { return nil }
        return originString(scheme: scheme, host: host, port: url.port ?? 0)
    }

    private static func canonicalPort(_ port: Int, scheme: String) -> Int? {
        switch (scheme, port) {
        case ("http", 80), ("https", 443), ("ws", 80), ("wss", 443), ("ftp", 21):
            return nil
        case (_, 0):
            return nil
        default:
            return port
        }
    }
}