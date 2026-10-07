import AuthenticationServices
import Cocoa
import Foundation
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

    private weak var webView: InAppWebView?
    private var controller: ASAuthorizationController?
    private var completion: (([String: Any]) -> Void)?

    init(webView: InAppWebView) {
        self.webView = webView
    }

    // MARK: - Entry point

    /// `argsJson` is the JS bridge's `args` field: a JSON array whose first
    /// element is the shim's `{method, options}` payload object.
    func handleCall(argsJson: String, completion: @escaping ([String: Any]) -> Void) {
        guard let data = argsJson.data(using: .utf8),
              let args = try? JSONSerialization.jsonObject(with: data) as? [Any],
              let payload = args.first as? [String: Any],
              let method = payload["method"] as? String else {
            completion(Self.errorResult(name: "TypeError", message: "Malformed PasskeyBridge payload."))
            return
        }
        let options = payload["options"] as? [String: Any] ?? [:]
        switch method {
        case "create":
            performCreate(options: options, completion: completion)
        case "get":
            performGet(options: options, completion: completion)
        case "cancel":
            cancelCeremony()
            completion(["ok": true])
        case "isUvPaa":
            completion(["ok": true, "available": isPlatformAuthenticatorAvailable()])
        default:
            completion(Self.errorResult(name: "TypeError", message: "Unknown PasskeyBridge method '\(method)'."))
        }
    }

    // MARK: - Availability

    private func isPlatformAuthenticatorAvailable() -> Bool {
        guard let webView = webView, !webView.isHeadlessOffscreen, webView.window != nil else {
            return false
        }
        return true
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

    private func parseChallenge(_ options: [String: Any]) -> Result<Data, (String, String)> {
        guard let challenge = Self.decodeBase64urlField(options["challenge"]), !challenge.isEmpty else {
            return .failure(("TypeError", "The challenge is required and must be a base64url-encoded buffer."))
        }
        return .success(challenge)
    }

    private func parseRpId(_ options: [String: Any]) -> Result<String, (String, String)> {
        guard let rp = options["rp"] as? [String: Any],
              let rpId = rp["id"] as? String, !rpId.isEmpty else {
            return .failure(("TypeError", "publicKey.rp.id is required."))
        }
        if rpId.contains("://") || rpId.contains("/") {
            return .failure(("SecurityError", "publicKey.rp.id must be a domain, not a URL."))
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
                ASAuthorizationPublicKeyCredentialParameters(algorithm: ASAuthorizationCOSEAlgorithmIdentifier(rawValue: -7)),
                ASAuthorizationPublicKeyCredentialParameters(algorithm: ASAuthorizationCOSEAlgorithmIdentifier(rawValue: -257)),
            ]
        }
        return params.compactMap { param in
            guard let alg = param["alg"] as? Int else { return nil }
            return ASAuthorizationPublicKeyCredentialParameters(algorithm: ASAuthorizationCOSEAlgorithmIdentifier(rawValue: alg))
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
                    case "ble": return .bluetooth
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

    // MARK: - Ceremonies

    private func performCreate(options: [String: Any], completion: @escaping ([String: Any]) -> Void) {
        let rpId: String
        let challenge: Data
        switch (parseRpId(options), parseChallenge(options)) {
        case (.success(let rp), .success(let ch)):
            rpId = rp
            challenge = ch
        case (.failure(let e), _), (_, .failure(let e)):
            completion(Self.errorResult(name: e.0, message: e.1))
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
            let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: rpId)
            let request = provider.createCredentialRegistrationRequest(challenge: challenge, name: name, userID: userID)
            request.userVerificationPreference = userVerificationPreference(from: options)
            request.attestationPreference = attestationPreference(from: options)
            let excluded = platformDescriptors(from: options, key: "excludeCredentials")
            if !excluded.isEmpty { request.excludedCredentials = excluded }
            if #available(macOS 14.4, *) {
                request.residentKeyPreference = residentKeyPreference(from: options)
            }
            requests.append(request)
        }
        if wantsSecurityKey(options), #available(macOS 13.0, *) {
            let provider = ASAuthorizationSecurityKeyPublicKeyCredentialProvider(relyingPartyIdentifier: rpId)
            let request = provider.createCredentialRegistrationRequest(challenge: challenge, displayName: displayName, name: name, userID: userID)
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

    private func performGet(options: [String: Any], completion: @escaping ([String: Any]) -> Void) {
        let rpId: String
        let challenge: Data
        switch (parseRpId(options), parseChallenge(options)) {
        case (.success(let rp), .success(let ch)):
            rpId = rp
            challenge = ch
        case (.failure(let e), _), (_, .failure(let e)):
            completion(Self.errorResult(name: e.0, message: e.1))
            return
        }
        guard beginCeremony(completion: completion) else { return }

        var requests: [ASAuthorizationRequest] = []
        if wantsPlatform(options) {
            let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: rpId)
            let request = provider.createCredentialAssertionRequest(challenge: challenge)
            request.userVerificationPreference = userVerificationPreference(from: options)
            let allowed = platformDescriptors(from: options, key: "allowCredentials")
            if !allowed.isEmpty { request.allowedCredentials = allowed }
            requests.append(request)
        }
        if wantsSecurityKey(options), #available(macOS 13.0, *) {
            let provider = ASAuthorizationSecurityKeyPublicKeyCredentialProvider(relyingPartyIdentifier: rpId)
            let request = provider.createCredentialAssertionRequest(challenge: challenge)
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
        controller?.cancel()
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
            completion(["ok": true, "credential": Self.serializeRegistration(
                credentialID: registration.credentialID,
                clientDataJSON: registration.rawClientDataJSON,
                attestationObject: registration.rawAttestationObject,
                attachment: "platform")])
            return
        }
        if #available(macOS 13.0, *),
           let registration = authorization.credential as? ASAuthorizationSecurityKeyPublicKeyCredentialRegistration {
            completion(["ok": true, "credential": Self.serializeRegistration(
                credentialID: registration.credentialID,
                clientDataJSON: registration.rawClientDataJSON,
                attestationObject: registration.rawAttestationObject,
                attachment: "cross-platform")])
            return
        }
        if let assertion = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialAssertion {
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
            completion(["ok": true, "credential": Self.serializeAssertion(
                credentialID: assertion.credentialID,
                clientDataJSON: assertion.rawClientDataJSON,
                authenticatorData: assertion.rawAuthenticatorData,
                signature: assertion.signature,
                userHandle: assertion.userID,
                attachment: "cross-platform")])
            return
        }
        completion(Self.errorResult(name: "NotAllowedError", message: "The authorization returned an unrecognized credential type."))
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let completion = takeCompletion()
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
