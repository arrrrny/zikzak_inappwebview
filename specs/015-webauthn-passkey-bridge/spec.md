# Feature Specification: WebAuthn/Passkey Bridge (macOS)

**Feature Branch**: `feat/issue-358`
**Created**: 2026-10-07
**Issue**: [arrrrny/zikzak_inappwebview#358](https://github.com/arrrrny/zikzak_inappwebview/issues/358)
**Status**: Implemented

## Summary

Implement WebAuthn/passkey support on macOS the way Apple documents for
custom browser engines: inject a JS shim that overrides
`navigator.credentials.create` / `navigator.credentials.get` for
PublicKeyCredential options, forward the ceremony over the plugin's
JS-handler channel to native `ASAuthorizationController`, and hand a
WebAuthn-shaped credential object back to JS. This bypasses WebKit's
in-page WKWebView mediation, which is broken for entitled custom-browser
apps (zuraffa_browser#278: ASCAgent dies with `AuthorizationError Code=1`
~2 ms after "Allowing request from web browser.", no UI shown).

iOS is a follow-up (same `ASAuthorizationController` APIs, needs its own
entitlement-state verification — tracked in the epic). The zuraffa_browser
app-side enablement (consent bootstrap, lane routing) lives in
zuraffa_browser and is out of scope for this plugin PR.

## User Scenarios & Testing

### US-1: Registration ceremony in a GUI tab (P1)

A site calls `navigator.credentials.create({publicKey: ...})` in a GUI
webview. The shim forwards the options to the native bridge, which runs
`ASAuthorizationController` with a platform (and, absent
`authenticatorAttachment`, security-key) registration request anchored to
the webview's window. The system sheet completes (Touch ID) and JS
receives a PublicKeyCredential-shaped object with `id`, `rawId`
(ArrayBuffer), `type: "public-key"`, `authenticatorAttachment`, and
`response.{clientDataJSON, attestationObject}` as ArrayBuffers, plus
`getClientExtensionResults()`.

### US-2: Authentication ceremony (P1)

`navigator.credentials.get({publicKey: ...})` returns an assertion-shaped
credential: `response.{clientDataJSON, authenticatorData, signature,
userHandle}`.

### US-3: Headless fail-fast (P1)

A headless WebView calling the same APIs is rejected immediately with
`NotAllowedError` (regression guard for today's NONE stance).

### US-4: Non-publicKey credentials untouched (P2)

Password/OTP credential calls fall through to the platform default
implementation.

### US-5: AbortSignal (P2)

An aborted `options.signal` cancels the outstanding
`ASAuthorizationController` and rejects with `AbortError`.

## Functional Requirements

- **FR-001**: Inject `PASSKEYS_JS_SOURCE` as a `WKUserScript` at
  `atDocumentStart`, `forMainFrameOnly: false` (every frame).
- **FR-002**: Intercept `callHandler('PasskeyBridge', ...)` natively in
  `InAppWebView.userContentController(_:didReceive:)` before the Dart
  round-trip.
- **FR-003**: Map WebAuthn options → provider requests: rpId (default
  `location.hostname` in the shim), challenge/user.id/credential ids as
  base64url→Data, pubKeyCredParams (COSE alg ints, default ES256+RS256 on
  the security-key request), excludeCredentials/allowCredentials,
  attestation, userVerification (`required`/`preferred`/`discouraged`),
  residentKey (macOS 14.4+).
- **FR-004**: Presentation anchor is the webview's window; headless
  (`isHeadlessOffscreen`) or window-less webviews fail fast with
  `NotAllowedError`.
- **FR-005**: Serialize results back as base64url fields; errors resolve
  as `{ok: false, error: {name, message}}` and the shim throws a
  DOMException with that name (user cancel / timeout / no credentials →
  `NotAllowedError`; malformed options → `TypeError`; non-domain rpId →
  `SecurityError`).
- **FR-006**: `PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable()`
  bridges to native availability; `isConditionalMediationAvailable()`
  resolves `false` (conditional UI not bridged).
- **FR-007**: Only one ceremony per webview at a time (a second
  `performRequests` would fail with `ASAuthorizationError` 1004).

## Success Criteria

1. webauthn.io registration completes in a GUI tab (requires an entitled
   host app — manual verification, zuraffa_browser side).
2. webauthn.io authentication completes with the created credential.
3. Credential visible in Passwords.app / `platformCredentials(forRelyingParty:)`.
4. Headless WebViews still reject `navigator.credentials` immediately with
   `NotAllowedError` — covered by `passkey_bridge_test.dart`
   ("fails fast with NotAllowedError for headless webviews").
