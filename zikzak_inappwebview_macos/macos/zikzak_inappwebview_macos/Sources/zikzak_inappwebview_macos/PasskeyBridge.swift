import AuthenticationServices
import Cocoa
import Foundation
import LocalAuthentication
import ObjectiveC
import WebKit

/// Issue #358 — WebAuthn/passkey ceremonies over `ASAuthorizationController`.
///
/// WebKit's in-page WKWebView WebAuthn mediation is broken for entitled
/// custom-browser apps (zuraffa_browser#278), so the injected PasskeysJS
/// shim forwards `navigator.credentials.create/get` calls here over the
/// plugin's JS-handler channel. This bridge maps the WebAuthn JSON-ish
/// options onto platform/security-key credential provider requests, runs
/// the system ceremony anchored to the webview's window, and hands a
/// WebAuthn-shaped credential dictionary back to JS.
///
/// Protocol: every call resolves with
/// `{"ok": true, "credential": {...}}` / `{"ok": true, "available": Bool}`
/// or `{"ok": false, "error": {"name": <DOMException name>, "message": ...}}`.
/// The shim converts the error payload into a real DOMException, preserving
/// the WebAuthn error-name contract (user cancel / timeout / no credentials
/// all surface as `NotAllowedError`).
public class PasskeyBridge: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    /// Binary WebAuthn fields arrive from the shim as `{"$b64url": "..."}`
    /// markers (JSON cannot carry ArrayBuffers). A plain base64url string is
    /// also accepted so hand-crafted payloads work.
    static let base64urlMarker = "$b64url"


    /// Read once at first use; the injected PasskeysJS shim interpolates
    /// this into `var telemetryEnabled = …` so the RP round-trip logger and
    /// ceremony telemetry exist in the page ONLY under the same env-var
    /// gate as the native prints. One source of truth for passkey
    /// diagnostics.
    static let telemetryEnabled: Bool = {
        let env = ProcessInfo.processInfo.environment
        return env["ZURAFFA_PASSKEY_DEBUG"] == "1" || env["ZIKZAK_PASSKEY_DEBUG"] == "1"
    }()

    /// Diagnostics gate: ceremony/network tracing prints only when
    /// ZURAFFA_PASSKEY_DEBUG=1 (or ZIKZAK_PASSKEY_DEBUG=1) is set in the
    /// process environment. Default OFF — a release app must not log
    /// credential metadata or RP request/response bodies to stdout.
    static func pkDebug(_ message: String) {
        guard telemetryEnabled else { return }
        print(message)
    }
    private weak var webView: InAppWebView?
    private var controller: ASAuthorizationController?
    private var completion: (([String: Any]) -> Void)?

    init(webView: InAppWebView) {
        self.webView = webView
        PasskeyClientDataJSONFixer.install()
    }

    // MARK: - Entry point

    /// `argsJson` is the JS bridge's `args` field: a JSON array whose first
    /// element is the shim's `{method, options}` payload object. `caller` is
    /// the trusted web-caller context the `WKScriptMessage` handler resolved
    /// from the frame the request arrived on (issue #446) — the bridge never
    /// reads an origin out of the payload.
    func handleCall(
        argsJson: String,
        caller: PasskeyCallerContext?,
        completion: @escaping ([String: Any]) -> Void
    ) {
        guard let data = argsJson.data(using: .utf8),
              let args = try? JSONSerialization.jsonObject(with: data) as? [Any],
              let payload = args.first as? [String: Any],
              let method = payload["method"] as? String else {
            PasskeyBridge.pkDebug("[PKDBG] handleCall: MALFORMED payload "
                + "(argsJson prefix \(argsJson.prefix(200)))")
            completion(Self.errorResult(name: "TypeError", message: "Malformed PasskeyBridge payload."))
            return
        }
        PasskeyBridge.pkDebug("[PKDBG] handleCall: method=\(method) "
            + "caller=\(caller.map { "origin=\($0.origin) topOrigin=\($0.topOrigin ?? "nil") crossOrigin=\($0.crossOrigin)" } ?? "nil")")
        let options = payload["options"] as? [String: Any] ?? [:]
        let logged = Self.pkCompletion(completion)
        switch method {
        case "create":
            performCreate(options: options, caller: caller, completion: logged)
        case "get":
            performGet(options: options, caller: caller, completion: logged)
        case "cancel":
            cancelCeremony()
            completion(["ok": true])
        case "isUvPaa":
            let available = isPlatformAuthenticatorAvailable()
            PasskeyBridge.pkDebug("[PKDBG] handleCall: isUvPaa -> \(available)")
            completion(["ok": true, "available": available])
        case "telemetry":
            // Fire-and-forget observability channel from the injected shim
            // (assertion serialization, RP network round-trips inside
            // cross-origin iframes). Apple's widget no-ops console.* in
            // production, so console-forwarded lines never arrive — this
            // rides the same trusted bridge the ceremonies use.
            let text = (payload["options"] as? [String: Any])?["text"] as? String ?? ""
            PasskeyBridge.pkDebug("[PKTEL] \(text)")
            completion(["ok": true])
        default:
            PasskeyBridge.pkDebug("[PKDBG] handleCall: UNKNOWN method '\(method)'")
            completion(Self.errorResult(name: "TypeError", message: "Unknown PasskeyBridge method '\(method)'."))
        }
    }

    /// PKDBG: wrap a completion so every error result the bridge returns is
    /// visible — ASC's "browser needs to be updated" banner is its client-side
    /// mapping of a rejected navigator.credentials call, and the error paths
    /// below were silent.
    static func pkCompletion(
        _ completion: @escaping ([String: Any]) -> Void
    ) -> ([String: Any]) -> Void {
        return { result in
            if let ok = result["ok"] as? Bool, !ok,
               let error = result["error"] as? [String: Any] {
                PasskeyBridge.pkDebug("[PKDBG] ceremony ERROR: \(error["name"] ?? "?") — \(error["message"] ?? "?")")
            }
            completion(result)
        }
    }

    // MARK: - Availability

    /// Capability check — NOT an entitlement, consent, or presentation probe.
    /// The WebAuthn static answers whether a user-verifying platform
    /// authenticator EXISTS on this machine; it must not depend on this
    /// document being currently presentable. Safari answers `true` for
    /// background tabs, and sites gate their passkey UX on the static — a
    /// window-presence check here made every hidden tab advertise "no
    /// platform authenticator" (issue #422; consumer report
    /// zuraffa_browser#836, ASC's red "browser needs to be updated"
    /// warning). Presentation stays a ceremony-time concern:
    /// `beginCeremony` still fails with NotAllowedError when there is no
    /// window to anchor the sheet to.
    ///
    /// The authoritative probe is the browser passkey manager's
    /// `isDeviceConfiguredForPasskeys` (class static, macOS 26.2+): it
    /// answers whether the DEVICE is configured for passkeys. Touch ID
    /// enrollment is NOT a capability gate — a fingerprint-less Mac still
    /// verifies ceremonies with the login password, and a biometrics-only
    /// floor answered false on every configured-but-fingerprint-less Mac
    /// (issue #427; consumer report zuraffa_browser#836 — ASC's red
    /// "browser needs to be updated" warning, again). Below 26.2 the floor
    /// is LAContext `.deviceOwnerAuthentication` — biometrics OR the
    /// account password — never biometrics-only.
    private func isPlatformAuthenticatorAvailable() -> Bool {
        guard let webView = webView, !webView.isHeadlessOffscreen else {
            return false
        }
        var error: NSError?
        if #available(macOS 26.2, *) {
            // `isDeviceConfiguredForPasskeys` is only declared in the macOS
            // 26.2 SDK, but this package compiles against older SDKs (CI
            // builds the macOS package on the macOS 15 SDK), where a direct
            // static call is a compile error even behind `#available`. The
            // class-property getter is resolved through the ObjC runtime
            // instead, and a class without the getter falls back to the
            // LAContext floor below.
            let managerClass: NSObject.Type =
                ASAuthorizationWebBrowserPublicKeyCredentialManager.self
            let selector = NSSelectorFromString("isDeviceConfiguredForPasskeys")
            if let method = class_getClassMethod(managerClass, selector) {
                typealias ClassGetter = @convention(c) (AnyObject, Selector) -> Bool
                let getter = unsafeBitCast(
                    method_getImplementation(method),
                    to: ClassGetter.self
                )
                return getter(managerClass, selector)
            }
        }
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
    }

    // MARK: - base64url

    /// WebAuthn transports binary fields as base64url — a plain
    /// `Data(base64Encoded:)` rejects `-`/`_` and unpadded input, so the
    /// bridge carries its own decoder.
    static func decodeBase64url(_ text: String) -> Data? {
        var base64 = text.replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let padding = (4 - base64.count % 4) % 4
        if padding > 0 { base64 += String(repeating: "=", count: padding) }
        return Data(base64Encoded: base64)
    }

    static func encodeBase64url(_ data: Data) -> String {
        return data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    static func decodeBase64urlField(_ value: Any?) -> Data? {
        if let marker = value as? [String: Any], let text = marker[base64urlMarker] as? String {
            return decodeBase64url(text)
        }
        if let text = value as? String {
            return decodeBase64url(text)
        }
        return nil
    }

    // MARK: - Option mapping

    /// DOMException-shaped option-parse error. A `(String, String)` tuple
    /// cannot be a `Result` failure (tuples do not conform to `Error`), so
    /// the parsers carry name/message in this struct instead.
    private struct PasskeyOptionError: Error {
        let name: String
        let message: String
    }

    private func parseChallenge(_ options: [String: Any]) -> Result<Data, PasskeyOptionError> {
        guard let challenge = Self.decodeBase64urlField(options["challenge"]), !challenge.isEmpty else {
            return .failure(PasskeyOptionError(name: "TypeError", message: "The challenge is required and must be a base64url-encoded buffer."))
        }
        return .success(challenge)
    }

    private func parseRpId(_ options: [String: Any]) -> Result<String, PasskeyOptionError> {
        // Authentication options carry the optional rpId at the top level
        // (PublicKeyCredentialRequestOptions has no `rp` object); creation
        // options nest it under rp.id. Accept both shapes.
        let rpId = (options["rp"] as? [String: Any])?["id"] as? String
            ?? (options["rpId"] as? String)
        guard let rpId = rpId, !rpId.isEmpty else {
            return .failure(PasskeyOptionError(name: "TypeError", message: "publicKey.rp.id is required."))
        }
        if rpId.contains("://") || rpId.contains("/") {
            return .failure(PasskeyOptionError(name: "SecurityError", message: "publicKey.rp.id must be a domain, not a URL."))
        }
        return .success(rpId)
    }

    private func userVerificationPreference(from options: [String: Any]) -> ASAuthorizationPublicKeyCredentialUserVerificationPreference {
        switch options["userVerification"] as? String {
        case "required": return .required
        case "discouraged": return .discouraged
        default: return .preferred
        }
    }

    private func attestationPreference(from options: [String: Any]) -> ASAuthorizationPublicKeyCredentialAttestationKind {
        switch options["attestation"] as? String {
        case "direct": return .direct
        case "indirect": return .indirect
        case "enterprise": return .enterprise
        default: return .none
        }
    }

    private func credentialParameters(from options: [String: Any]) -> [ASAuthorizationPublicKeyCredentialParameters] {
        guard let params = options["pubKeyCredParams"] as? [[String: Any]], !params.isEmpty else {
            // WebAuthn default when the RP omits the list.
            return [
                ASAuthorizationPublicKeyCredentialParameters(algorithm: ASCOSEAlgorithmIdentifier(rawValue: -7)),
                ASAuthorizationPublicKeyCredentialParameters(algorithm: ASCOSEAlgorithmIdentifier(rawValue: -257)),
            ]
        }
        return params.compactMap { param in
            guard let alg = param["alg"] as? Int else { return nil }
            return ASAuthorizationPublicKeyCredentialParameters(algorithm: ASCOSEAlgorithmIdentifier(rawValue: alg))
        }
    }

    private func platformDescriptors(from options: [String: Any], key: String) -> [ASAuthorizationPlatformPublicKeyCredentialDescriptor] {
        guard let list = options[key] as? [[String: Any]] else { return [] }
        return list.compactMap { entry in
            guard let id = Self.decodeBase64urlField(entry["id"]) else { return nil }
            return ASAuthorizationPlatformPublicKeyCredentialDescriptor(credentialID: id)
        }
    }

    @available(macOS 13.0, *)
    private func securityKeyDescriptors(from options: [String: Any], key: String) -> [ASAuthorizationSecurityKeyPublicKeyCredentialDescriptor] {
        guard let list = options[key] as? [[String: Any]] else { return [] }
        return list.compactMap { entry in
            guard let id = Self.decodeBase64urlField(entry["id"]) else { return nil }
            let transports: [ASAuthorizationSecurityKeyPublicKeyCredentialDescriptor.Transport] =
                (entry["transports"] as? [String] ?? []).compactMap {
                    switch $0 {
                    case "usb": return .usb
                    case "nfc": return .nfc
                    case "ble", "hybrid", "cable": return .bluetooth
                    default: return nil
                    }
                }
            return ASAuthorizationSecurityKeyPublicKeyCredentialDescriptor(credentialID: id, transports: transports)
        }
    }

    /// Which providers to offer. `authenticatorSelection.authenticatorAttachment`
    /// pins one side; without it both platform and security-key requests are
    /// offered together so the system sheet presents the full choice.
    private func wantsPlatform(_ options: [String: Any]) -> Bool {
        let selection = options["authenticatorSelection"] as? [String: Any]
        return selection?["authenticatorAttachment"] as? String != "cross-platform"
    }

    private func wantsSecurityKey(_ options: [String: Any]) -> Bool {
        let selection = options["authenticatorSelection"] as? [String: Any]
        return selection?["authenticatorAttachment"] as? String != "platform"
    }

    // MARK: - Browser client data

    /// Issue #446 — the client data of a browser request: the calling frame's
    /// real origin, plus the top-level origin and cross-origin flag when the
    /// ceremony runs from a subframe.
    ///
    /// Returns nil when the caller context is unknown or the OS predates the
    /// client-data API; the caller then builds the app-context request, whose
    /// signed origin is the relying party's rather than the frame's. A nil
    /// return is therefore the issue #446 defect, and it is logged where it
    /// happens — the fallback is silent otherwise, and a ceremony that signed
    /// the wrong origin leaves no trace at all.
    @available(macOS 13.5, *)
    private func clientData(challenge: Data, caller: PasskeyCallerContext?) -> ASPublicKeyCredentialClientData? {
        guard let caller = caller, !caller.origin.isEmpty else {
            print("[PasskeyBridge] no trusted caller origin (a `file://` or "
                + "`about:blank` frame has no security origin) — falling back "
                + "to the app-context request, which signs the relying-party "
                + "origin instead (issue #446)")
            return nil
        }
        var clientData = ASPublicKeyCredentialClientData(challenge: challenge, origin: caller.origin,
            topOrigin: caller.topOrigin,
            crossOrigin: Self.crossOriginValue(caller.crossOrigin))
        return clientData
    }

    /// Swift imports the cross-origin value as an optional: `nil` is the
    /// not-set state, so a top-level ceremony leaves it alone rather than
    /// naming a case the SDK does not expose to Swift.
    @available(macOS 13.5, *)
    private static func crossOriginValue(
        _ value: PasskeyCallerContext.CrossOrigin
    ) -> ASPublicKeyCredentialClientData.CrossOriginValue? {
        switch value {
        case .notSet: return nil
        case .crossOrigin: return .crossOrigin
        case .sameOriginWithAncestors: return .sameOriginWithAncestors
        }
    }

    // MARK: - Requests

    /// Platform registration as a browser request when the caller context and
    /// the client-data API allow it, otherwise as the app-context request.
    private func platformRegistrationRequest(
        rpId: String, challenge: Data, name: String, userID: Data,
        caller: PasskeyCallerContext?
    ) -> ASAuthorizationPlatformPublicKeyCredentialRegistrationRequest {
        let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: rpId)
        if #available(macOS 13.5, *),
           let clientData = clientData(challenge: challenge, caller: caller)
        {
            return provider.createCredentialRegistrationRequest(
                clientData: clientData, name: name, userID: userID)
        }
        // Below macOS 13.5 there is no client-data API: this app-context
        // request signs the relying-party origin, not the calling frame's
        // (issue #446). The limitation is inherent to the API, not a choice.
        return provider.createCredentialRegistrationRequest(
            challenge: challenge, name: name, userID: userID)
    }

    private func platformAssertionRequest(
        rpId: String, challenge: Data, caller: PasskeyCallerContext?
    ) -> ASAuthorizationPlatformPublicKeyCredentialAssertionRequest {
        let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: rpId)
        if #available(macOS 13.5, *),
           let clientData = clientData(challenge: challenge, caller: caller)
        {
            return provider.createCredentialAssertionRequest(clientData: clientData)
        }
        // Below macOS 13.5 there is no client-data API: this app-context
        // request signs the relying-party origin, not the calling frame's
        // (issue #446). The limitation is inherent to the API, not a choice.
        return provider.createCredentialAssertionRequest(challenge: challenge)
    }

    @available(macOS 13.0, *)
    private func securityKeyRegistrationRequest(
        rpId: String, challenge: Data, displayName: String, name: String,
        userID: Data, caller: PasskeyCallerContext?
    ) -> ASAuthorizationSecurityKeyPublicKeyCredentialRegistrationRequest {
        let provider = ASAuthorizationSecurityKeyPublicKeyCredentialProvider(relyingPartyIdentifier: rpId)
        if #available(macOS 14.4, *),
           let clientData = clientData(challenge: challenge, caller: caller)
        {
            return provider.createCredentialRegistrationRequest(
                clientData: clientData, displayName: displayName, name: name,
                userID: userID)
        }
        // Below macOS 14.4 the security-key provider carries no client-data
        // request: this app-context request signs the relying-party origin,
        // not the calling frame's (issue #446).
        return provider.createCredentialRegistrationRequest(
            challenge: challenge, displayName: displayName, name: name,
            userID: userID)
    }

    @available(macOS 13.0, *)
    private func securityKeyAssertionRequest(
        rpId: String, challenge: Data, caller: PasskeyCallerContext?
    ) -> ASAuthorizationSecurityKeyPublicKeyCredentialAssertionRequest {
        let provider = ASAuthorizationSecurityKeyPublicKeyCredentialProvider(relyingPartyIdentifier: rpId)
        if #available(macOS 14.4, *),
           let clientData = clientData(challenge: challenge, caller: caller)
        {
            return provider.createCredentialAssertionRequest(clientData: clientData)
        }
        // Below macOS 14.4 the security-key provider carries no client-data
        // request: this app-context request signs the relying-party origin,
        // not the calling frame's (issue #446).
        return provider.createCredentialAssertionRequest(challenge: challenge)
    }

    // MARK: - Ceremonies

    private func performCreate(
        options: [String: Any], caller: PasskeyCallerContext?,
        completion: @escaping ([String: Any]) -> Void
    ) {
        let rpId: String
        let challenge: Data
        switch (parseRpId(options), parseChallenge(options)) {
        case (.success(let rp), .success(let ch)):
            rpId = rp
            challenge = ch
        case (.failure(let e), _), (_, .failure(let e)):
            completion(Self.errorResult(name: e.name, message: e.message))
            return
        }
        guard let user = options["user"] as? [String: Any],
              let userID = Self.decodeBase64urlField(user["id"]), !userID.isEmpty,
              let name = user["name"] as? String, !name.isEmpty else {
            completion(Self.errorResult(name: "TypeError", message: "publicKey.user {id, name} is required for create()."))
            return
        }
        let displayName = user["displayName"] as? String ?? name
        guard beginCeremony(completion: completion) else { return }

        var requests: [ASAuthorizationRequest] = []
        if wantsPlatform(options) {
            let request = platformRegistrationRequest(
                rpId: rpId, challenge: challenge, name: name, userID: userID,
                caller: caller)
            request.userVerificationPreference = userVerificationPreference(from: options)
            request.attestationPreference = attestationPreference(from: options)
            let excluded = platformDescriptors(from: options, key: "excludeCredentials")
            // The browser-request protocol carrying `excludedCredentials`
            // only reaches the platform registration request on macOS 13.5+.
            if #available(macOS 13.5, *) {
                if !excluded.isEmpty { request.excludedCredentials = excluded }
            }
            requests.append(request)
        }
        if wantsSecurityKey(options), #available(macOS 13.0, *) {
            let request = securityKeyRegistrationRequest(
                rpId: rpId, challenge: challenge, displayName: displayName,
                name: name, userID: userID, caller: caller)
            request.userVerificationPreference = userVerificationPreference(from: options)
            request.attestationPreference = attestationPreference(from: options)
            request.credentialParameters = credentialParameters(from: options)
            let excluded = securityKeyDescriptors(from: options, key: "excludeCredentials")
            if !excluded.isEmpty { request.excludedCredentials = excluded }
            if #available(macOS 14.4, *) {
                request.residentKeyPreference = residentKeyPreference(from: options)
            }
            requests.append(request)
        }
        run(requests: requests, completion: completion)
    }

    private func performGet(
        options: [String: Any], caller: PasskeyCallerContext?,
        completion: @escaping ([String: Any]) -> Void
    ) {
        let rpId: String
        let challenge: Data
        switch (parseRpId(options), parseChallenge(options)) {
        case (.success(let rp), .success(let ch)):
            rpId = rp
            challenge = ch
        case (.failure(let e), _), (_, .failure(let e)):
            completion(Self.errorResult(name: e.name, message: e.message))
            return
        }
        guard beginCeremony(completion: completion) else { return }

        var requests: [ASAuthorizationRequest] = []
        if wantsPlatform(options) {
            let request = platformAssertionRequest(
                rpId: rpId, challenge: challenge, caller: caller)
            request.userVerificationPreference = userVerificationPreference(from: options)
            let allowed = platformDescriptors(from: options, key: "allowCredentials")
            if !allowed.isEmpty { request.allowedCredentials = allowed }
            requests.append(request)
        }
        if wantsSecurityKey(options), #available(macOS 13.0, *) {
            let request = securityKeyAssertionRequest(
                rpId: rpId, challenge: challenge, caller: caller)
            request.userVerificationPreference = userVerificationPreference(from: options)
            let allowed = securityKeyDescriptors(from: options, key: "allowCredentials")
            if !allowed.isEmpty { request.allowedCredentials = allowed }
            requests.append(request)
        }
        run(requests: requests, completion: completion)
    }

    @available(macOS 14.4, *)
    private func residentKeyPreference(from options: [String: Any]) -> ASAuthorizationPublicKeyCredentialResidentKeyPreference {
        let selection = options["authenticatorSelection"] as? [String: Any]
        switch selection?["residentKey"] as? String {
        case "required": return .required
        case "discouraged": return .discouraged
        default: return .preferred
        }
    }

    /// Shared pre-flight: headless WebViews have no presentation surface and
    /// must fail fast (matching the pre-bridge NONE stance), and only one
    /// ceremony may run at a time per webview — a second `performRequests`
    /// while one is outstanding fails instantly with `ASAuthorizationError`
    /// code 1004 ("Request already in progress for specified application
    /// identifier").
    private func beginCeremony(completion: @escaping ([String: Any]) -> Void) -> Bool {
        guard let webView = webView, !webView.isHeadlessOffscreen else {
            completion(Self.errorResult(name: "NotAllowedError", message: "Passkey ceremonies are not available in a headless WebView."))
            return false
        }
        guard webView.window != nil else {
            completion(Self.errorResult(name: "NotAllowedError", message: "The WebView has no window to present the passkey sheet from."))
            return false
        }
        guard controller == nil else {
            completion(Self.errorResult(name: "NotAllowedError", message: "A passkey ceremony is already in progress."))
            return false
        }
        return true
    }

    private func run(requests: [ASAuthorizationRequest], completion: @escaping ([String: Any]) -> Void) {
        guard !requests.isEmpty else {
            completion(Self.errorResult(name: "NotAllowedError", message: "No credential provider is available for these options on this system."))
            return
        }
        // ASAuthorizationController exposes no per-request timeout knob; the
        // WebAuthn `timeout` option is enforced by the system UI itself.
        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = self
        controller.presentationContextProvider = self
        self.controller = controller
        self.completion = completion
        controller.performRequests()
    }

    func cancelCeremony() {
        // `ASAuthorizationController.cancel()` is macOS 13.0+; on 12.x the
        // ceremony simply runs to its own timeout.
        if #available(macOS 13.0, *) {
            controller?.cancel()
        }
    }

    // MARK: - ASAuthorizationControllerPresentationContextProviding

    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // beginCeremony guarantees a window; the fallback only satisfies the
        // non-optional protocol requirement.
        return webView?.window ?? NSWindow()
    }

    // MARK: - ASAuthorizationControllerDelegate

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        let completion = takeCompletion()
        if let registration = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialRegistration {
            Self.logClientData("platform registration", registration.rawClientDataJSON)
            completion(["ok": true, "credential": Self.serializeRegistration(
                credentialID: registration.credentialID,
                clientDataJSON: registration.rawClientDataJSON,
                attestationObject: registration.rawAttestationObject,
                attachment: "platform")])
            return
        }
        if #available(macOS 13.0, *),
           let registration = authorization.credential as? ASAuthorizationSecurityKeyPublicKeyCredentialRegistration {
            Self.logClientData("security-key registration (hybrid/caBLE)", registration.rawClientDataJSON)
            completion(["ok": true, "credential": Self.serializeRegistration(
                credentialID: registration.credentialID,
                clientDataJSON: registration.rawClientDataJSON,
                attestationObject: registration.rawAttestationObject,
                attachment: "cross-platform")])
            return
        }
        if let assertion = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialAssertion {
            Self.logClientData("platform assertion", assertion.rawClientDataJSON)
            completion(["ok": true, "credential": Self.serializeAssertion(
                credentialID: assertion.credentialID,
                clientDataJSON: assertion.rawClientDataJSON,
                authenticatorData: assertion.rawAuthenticatorData,
                signature: assertion.signature,
                userHandle: assertion.userID,
                attachment: "platform")])
            return
        }
        if #available(macOS 13.0, *),
           let assertion = authorization.credential as? ASAuthorizationSecurityKeyPublicKeyCredentialAssertion {
            Self.logClientData("security-key assertion (hybrid/caBLE)", assertion.rawClientDataJSON)
            completion(["ok": true, "credential": Self.serializeAssertion(
                credentialID: assertion.credentialID,
                clientDataJSON: assertion.rawClientDataJSON,
                authenticatorData: assertion.rawAuthenticatorData,
                signature: assertion.signature,
                userHandle: assertion.userID,
                attachment: "cross-platform")])
            return
        }
        PasskeyBridge.pkDebug("[PKDBG] authorization: unrecognized credential "
            + "type \(type(of: authorization.credential))")
        completion(Self.errorResult(name: "NotAllowedError", message: "The authorization returned an unrecognized credential type."))
    }

    /// PKDBG (cross-device trace): decode the clientDataJSON macOS stamped on
    /// a returned credential, so a cross-origin relying party mismatch is
    /// observable — the hybrid/caBLE leg is a SECURITY-KEY credential whose
    /// client data macOS derives itself, and if it stamps the RP origin
    /// instead of the calling frame's origin the assertion is rejected
    /// (App Store Connect's "browser needs to be updated" banner).
    static func logClientData(_ kind: String, _ data: Data?) {
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else {
            PasskeyBridge.pkDebug("[PKDBG] \(kind): clientDataJSON unreadable")
            return
        }
        PasskeyBridge.pkDebug("[PKDBG] \(kind): origin=\(json["origin"] ?? "nil") "
            + "topOrigin=\(json["topOrigin"] ?? "nil") "
            + "crossOrigin=\(json["crossOrigin"] ?? "nil") "
            + "type=\(json["type"] ?? "nil") rpId=\(json["rpId"] ?? "nil")")
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let completion = takeCompletion()
        let nsError = error as NSError
        PasskeyBridge.pkDebug("[PKDBG] didCompleteWithError: domain=\(nsError.domain) "
            + "code=\(nsError.code) message=\(nsError.localizedDescription) "
            + "underlying=\(String(describing: nsError.userInfo[NSUnderlyingErrorKey]))")
        // Every ASAuthorizationError surface (user cancel, timeout, no
        // credentials, not interactive) maps to NotAllowedError per the
        // WebAuthn error contract; the underlying message is preserved for
        // debugging.
        completion(Self.errorResult(name: "NotAllowedError", message: error.localizedDescription))
    }

    private func takeCompletion() -> ([String: Any]) -> Void {
        let completion = self.completion ?? { _ in }
        self.completion = nil
        self.controller = nil
        return completion
    }

    // MARK: - Result serialization

    private static func serializeRegistration(credentialID: Data, clientDataJSON: Data?, attestationObject: Data?, attachment: String) -> [String: Any] {
        let encodedId = encodeBase64url(credentialID)
        var response: [String: Any] = [:]
        if let clientDataJSON = clientDataJSON { response["clientDataJSON"] = encodeBase64url(clientDataJSON) }
        if let attestationObject = attestationObject { response["attestationObject"] = encodeBase64url(attestationObject) }
        return [
            "id": encodedId,
            "rawId": encodedId,
            "type": "public-key",
            "kind": "attestation",
            "authenticatorAttachment": attachment,
            "response": response,
            "clientExtensionResults": [:],
        ]
    }

    private static func serializeAssertion(credentialID: Data, clientDataJSON: Data?, authenticatorData: Data?, signature: Data?, userHandle: Data?, attachment: String) -> [String: Any] {
        let encodedId = encodeBase64url(credentialID)
        var response: [String: Any] = [:]
        if let clientDataJSON = clientDataJSON { response["clientDataJSON"] = encodeBase64url(clientDataJSON) }
        if let authenticatorData = authenticatorData { response["authenticatorData"] = encodeBase64url(authenticatorData) }
        if let signature = signature { response["signature"] = encodeBase64url(signature) }
        if let userHandle = userHandle { response["userHandle"] = encodeBase64url(userHandle) }
        return [
            "id": encodedId,
            "rawId": encodedId,
            "type": "public-key",
            "kind": "assertion",
            "authenticatorAttachment": attachment,
            "response": response,
            "clientExtensionResults": [:],
        ]
    }

    static func errorResult(name: String, message: String) -> [String: Any] {
        return ["ok": false, "error": ["name": name, "message": message]]
    }
}

/// Issue #446 — macOS's `ASPublicKeyCredentialClientData` jsonForOperationType:
/// emits `{"type","challenge","origin","crossOrigin"}` but NEVER `topOrigin`,
/// even when the object carries one (verified at the raw ObjC level: every
/// crossOrigin value, both assignment orders, and re-derived options all
/// omit the field). Chromium's CollectedClientData contract
/// (components/webauthn/core/browser/client_data_json.cc) requires
/// `"crossOrigin":true,"topOrigin":"<top>"` for cross-origin iframe
/// ceremonies, and relying parties that validate the embedding origin —
/// App Store Connect's idmsa.apple.com widget above all — reject the
/// assertion without it. The signature covers the hash of this JSON, so it
/// cannot be fixed after the fact; the only interception point is the
/// generator itself.
///
/// `ASPublicKeyCredentialClientData` is NS_REFINED_FOR_SWIFT: the Swift
/// -visible type is a refinement, not the ObjC class, so neither `#selector`
/// nor an @objc extension nor `Type.self -> AnyClass` work on it. The swizzle
/// therefore runs entirely at the ObjC runtime level: resolve the class by
/// its runtime name, save the original IMP, and install a non-capturing
/// C-ABI replacement with `method_setImplementation`. The replacement calls
/// the saved original IMP, reads `topOrigin` off the receiver via KVC, and
/// injects it into the emitted JSON when Apple's own output says
/// `crossOrigin:true` and the field is absent. Same-origin output passes
/// through byte-identical.
enum PasskeyClientDataJSONFixer {
    /// The original IMP, saved at install time for re-entry. Nil means the
    /// replacement never runs (install failed), so the static is safe to
    /// force-unwrap inside the replacement only after a successful install.
    private static var originalJSONIMP: IMP?

    /// Thread-safe single execution: two InAppWebView instances can init
    /// concurrently, and a second exchange would capture the replacement as
    /// the "original" (the ceremony then recurses — the stack overflow in
    /// Zuraffa-2026-11-18-210521.ips). `static let` is lazy + thread-safe
    /// (dispatch_once semantics) in Swift.
    ///
    /// The closure contains the logic DIRECTLY — it must not call back into
    /// `install()`, which reads `installOnce` and would re-enter the
    /// dispatch_once that is currently running (reentrant callout = SIGILL,
    /// caught live as Zuraffa-2026-11-18-221739.ips).
    private static let installOnce: Void = {
        if #available(macOS 13.5, *) {
            install13_5()
        } else {
            // Below 13.5 there is no ASPublicKeyCredentialClientData and no
            // client-data API at all — the app-context request path runs
            // there and needs no fix.
            PasskeyBridge.pkDebug("[PasskeyBridge] clientDataJSON fixer: macOS < 13.5, not installed")
        }
    }()

    static func install() {
        _ = installOnce
    }

    @available(macOS 13.5, *)
    private static func install13_5() {
        // Idempotence is load-bearing: install() runs on every PasskeyBridge
        // init (one per webview), and a second run would capture THIS
        // replacement as the "original" — the replacement then re-enters
        // itself and the ceremony crashes the app with stack overflow
        // (Zuraffa-2026-11-18-210521.ips).
        guard !installed else { return }
        guard let cls: AnyClass = NSClassFromString("ASPublicKeyCredentialClientData"),
              let method = class_getInstanceMethod(cls, NSSelectorFromString("jsonForOperationType:")) else {
            PasskeyBridge.pkDebug("[PasskeyBridge] clientDataJSON fixer: class or method not found, not installed")
            return
        }
        originalJSONIMP = method_getImplementation(method)
        let replacement = unsafeBitCast(replacementIMP, to: IMP.self)
        method_setImplementation(method, replacement)
        installed = true
        PasskeyBridge.pkDebug("[PasskeyBridge] clientDataJSON fixer installed")
    }

    private static var installed = false

    /// The C-ABI replacement IMP. Non-capturing: it reads state from the
    /// receiver (KVC) and the saved original IMP (static), so it converts to
    /// a plain function pointer.
    private static let replacementIMP: @convention(c) (AnyObject, Selector, UInt) -> NSData = { receiver, sel, operationType in
        guard let originalIMP = PasskeyClientDataJSONFixer.originalJSONIMP else {
            return NSData()
        }
        let original = unsafeBitCast(
            originalIMP,
            to: (@convention(c) (AnyObject, Selector, UInt) -> NSData).self)
        let appleJSON = original(receiver, sel, operationType)
        // KVC guard: if Apple renames/removes the backing property in a
        // future macOS release, value(forKey:) throws an uncatchable
        // NSUndefinedKeyException and crashes the host. responds(to:) keeps
        // the fixer a no-op instead.
        let receiverObject = receiver as? NSObject
        let topOrigin = (receiverObject?.responds(to: NSSelectorFromString("topOrigin")) == true)
            ? receiverObject?.value(forKey: "topOrigin") as? String
            : nil
        return PasskeyClientDataJSONFixer.injectTopOrigin(
            originalJSON: appleJSON, topOrigin: topOrigin)
    }

    /// Parse Apple's emitted JSON, insert `topOrigin` after `crossOrigin`
    /// when the flag reads true and the field is absent. The emitted JSON is
    /// Apple's own serialization of the object's state, so its
    /// `origin`/`crossOrigin` values are authoritative; `topOrigin` is only
    /// ever ADDED, never rewritten. Same-origin output passes through
    /// untouched.
    static func injectTopOrigin(originalJSON: NSData, topOrigin: String?) -> NSData {
        guard let object = try? JSONSerialization.jsonObject(with: originalJSON as Data),
              var dict = object as? [String: Any] else {
            return originalJSON
        }
        let crossOrigin = dict["crossOrigin"] as? Bool ?? false
        guard crossOrigin, dict["topOrigin"] == nil,
              let topOrigin = topOrigin, !topOrigin.isEmpty else {
            return originalJSON
        }
        // STRING INSERTION, not a Dictionary rebuild: a Dictionary round
        // trip through JSONSerialization randomizes key order per process
        // (Swift hashing), and App Store Connect's validator rejected a
        // clientDataJSON whose challenge sat at the END of the object — the
        // -900030 browser wall returned on exactly such a run. Chromium's
        // client_data_json.cc and Safari emit
        // type,challenge,origin,crossOrigin,topOrigin; Apple's generator
        // emits type,challenge,origin,crossOrigin — the topOrigin slot is
        // always right after crossOrigin. So: insert into APPLE'S OWN
        // emitted bytes at exactly that position and reorder nothing. The
        // injected value rides Apple's serialization (no escaped slashes).
        guard let jsonString = String(data: originalJSON as Data, encoding: .utf8) else {
            return originalJSON
        }
        guard let crossRange = jsonString.range(of: "\"crossOrigin\":true") else {
            return originalJSON
        }
        // RFC 8259 string escaping for the injected value (defensive: the
        // origin is a plain scheme://host string, but stay correct).
        var escaped = ""
        for ch in topOrigin.unicodeScalars {
            switch ch {
            case .init(34): escaped += "\""
            case .init(92): escaped += "\\"
            default: escaped.unicodeScalars.append(ch)
            }
        }
        var result = jsonString
        result.insert(contentsOf: ",\"topOrigin\":\"\(escaped)\"", at: crossRange.upperBound)
        guard let data = result.data(using: .utf8) else {
            return originalJSON
        }
        print("[PasskeyBridge] clientDataJSON fixer: injected topOrigin=\(topOrigin)")
        return data as NSData
    }
}
