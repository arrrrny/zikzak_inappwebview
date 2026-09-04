import WebKit
import ZikzakExceptionCatcher

/// Internal contract for delegates that consume an already-sanitized message
/// body instead of re-reading `WKScriptMessage.body`.
///
/// #309: `WKScriptMessage.body` is the WebKit deserialization boundary for
/// script messages. Reading it unguarded can crash the host process
/// (SIGSEGV inside `CloneDeserializer::readDOMException` when a page posts a
/// `DOMException` through the bridge) or hand values the Flutter standard
/// message codec cannot carry. `WeakScriptMessageHandler` is the single
/// registration point for every zikzak macOS script message handler
/// (`consoleHandler`, `callHandler`, `onFindResultReceived`,
/// `onWebMessagePortMessageReceived`, `onWebMessageListenerPostMessageReceived`,
/// `onScrollChangedReceived`), so the defensive deserialization lives here:
/// the body is read exactly once, inside an ObjC exception boundary, sanitized
/// for the message codec, and only then passed on.
protocol DefensivelyDeserializedScriptMessageHandling: WKScriptMessageHandler {
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage,
        sanitizedBody: Any,
        deserializationError: String?
    )
}

class WeakScriptMessageHandler: NSObject, WKScriptMessageHandler {
    weak var delegate: WKScriptMessageHandler?

    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let delegate = self.delegate else {
            return
        }

        // #309 — defensive deserialization choke point (macOS).
        // Touch `message.body` exactly once, inside the ObjC exception
        // boundary, and never forward non-cloneable values to Dart.
        let (sanitizedBody, deserializationError) = Self.defensivelyDeserializeBody(of: message)

        if let defensiveDelegate = delegate as? DefensivelyDeserializedScriptMessageHandling {
            defensiveDelegate.userContentController(
                userContentController,
                didReceive: message,
                sanitizedBody: sanitizedBody,
                deserializationError: deserializationError)
        } else {
            // Foreign delegate: legacy forwarding, still defensively read so a
            // fragile body never crosses this boundary unguarded.
            delegate.userContentController(userContentController, didReceive: message)
        }
    }

    // MARK: - #309 defensive deserialization

    /// Reads `message.body` inside an ObjC exception boundary and sanitizes the
    /// result for the Flutter standard message codec.
    ///
    /// - Returns: the sanitized body — plain codec-safe containers whose leaves
    ///   are strings/numbers/booleans/data (anything else is converted to its
    ///   string representation) — plus a non-nil error string when WebKit's
    ///   deserializer threw while producing the body.
    static func defensivelyDeserializeBody(of message: WKScriptMessage) -> (body: Any, error: String?) {
        var body: Any? = nil
        var thrown: NSException? = nil
        if let exception = ZikzakCatchException({ body = message.body }) {
            thrown = exception
        }
        if let exception = thrown {
            let reason = exception.reason ?? exception.name.rawValue
            let errorDescription =
                "Failed to deserialize script message body for handler '\(message.name)': \(reason)"
            return (errorDescription, errorDescription)
        }
        guard let body = body else {
            return (NSNull(), nil)
        }
        return (sanitizeValueForMessageCodec(body), nil)
    }

    /// Recursively converts values the Flutter standard message codec cannot
    /// carry (e.g. a `DOMException` that survived deserialization as a foreign
    /// class, `NSDate`, `NSURL`, opaque objects, unsupported nested leaves)
    /// into their string representation (#309).
    static func sanitizeValueForMessageCodec(_ value: Any) -> Any {
        switch value {
        case is NSNull, is String, is NSNumber, is Bool, is Int, is Int32, is Int64,
            is UInt, is Double, is Float, is Data:
            return value
        case let dictionary as NSDictionary:
            var sanitized: [String: Any] = [:]
            for (rawKey, rawValue) in dictionary {
                let key = sanitizeValueForMessageCodec(rawKey)
                if let stringKey = key as? String {
                    sanitized[stringKey] = sanitizeValueForMessageCodec(rawValue)
                } else {
                    sanitized[String(describing: key)] = sanitizeValueForMessageCodec(rawValue)
                }
            }
            return sanitized
        case let array as NSArray:
            return array.map { sanitizeValueForMessageCodec($0) }
        case is NSDate:
            return String(describing: value)
        case is URL:
            return String(describing: value)
        default:
            // Non-cloneable / opaque object: string representation instead of
            // feeding the method channel codec something it cannot encode.
            return String(describing: value)
        }
    }
}
