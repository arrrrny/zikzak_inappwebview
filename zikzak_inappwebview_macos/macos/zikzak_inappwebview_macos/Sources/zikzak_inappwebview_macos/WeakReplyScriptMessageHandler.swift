import Foundation
import WebKit

/// Weak wrapper for the reply-capable passkey handler — the same
/// retain-cycle rationale as `WeakScriptMessageHandler` (the user content
/// controller retains its handlers strongly; the webview owns the
/// controller). Registered only for the `PasskeyBridge` handler, whose
/// reply must reach the exact frame that sent the message (issue #446
/// follow-up: iframe ceremonies).
///
/// The class conforms ONLY to `WKScriptMessageHandlerWithReply`. That is
/// not cosmetic: `WKUserContentController` has two distinct registration
/// selectors — `addScriptMessageHandler:contentWorld:name:` (plain) and
/// `addScriptMessageHandlerWithReply:contentWorld:name:` (reply-capable,
/// surfaced in Swift as `addScriptMessageHandler(_:contentWorld:name:)`).
/// A handler that also conforms to the plain `WKScriptMessageHandler`
/// protocol resolves the plain overload at the call site, and WebKit then
/// registers it as plain: `postMessage` never reaches the reply delegate,
/// and its promise resolves with `undefined` — which the PasskeysJS shim
/// reads as a failed ceremony (ASC's "browser needs to be updated" banner).
@available(macOS 12.0, *)
class WeakReplyScriptMessageHandler: NSObject, WKScriptMessageHandlerWithReply
{
    weak var delegate: (any WKScriptMessageHandlerWithReply)?

    init(delegate: any WKScriptMessageHandlerWithReply) {
        self.delegate = delegate
    }

    func userContentController(
        _ userContentController: WKUserContentController, didReceive message: WKScriptMessage,
        replyHandler: @escaping (Any?, String?) -> Void
    ) {
        delegate?.userContentController(
            userContentController, didReceive: message, replyHandler: replyHandler)
    }
}
