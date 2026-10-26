# Feature Specification: WebAuthn/Passkey Bridge on iOS + macOS follow-ups

**Feature Branch**: `feat/issue-384`
**Created**: 2026-10-26
**Issue**: [arrrrny/zikzak_inappwebview#384](https://github.com/arrrrny/zikzak_inappwebview/issues/384)
**Status**: Implemented
**Prior art**: [specs/015-webauthn-passkey-bridge](../015-webauthn-passkey-bridge/spec.md) (macOS half, issue #358, shipped 6.2.2)

## Summary

Port the shipped macOS WebAuthn/passkey bridge to iOS: a JS shim overriding
`navigator.credentials.create/get` for PublicKeyCredential options forwards
ceremonies over the plugin's JS-handler channel to a native `PasskeyBridge`
driving `ASAuthorizationController` (platform + security-key providers),
anchored to the iOS webview's window. The shim source moves to
`zikzak_inappwebview_platform_interface` as the single canonical copy, with a
generator script rendering both native `PasskeysJS.swift` files so macOS and
iOS cannot drift. Three macOS follow-ups ship alongside: B1 replaces the
stale AASA/associated-domains diagnostics text, B2 adds a consumer opt-out
(`passkeyBridgeEnabled`, default on; explicit `webAuthenticationSupport ==
NONE` also disarms), B3 tracks conditional mediation as a separate milestone.

## User Scenarios & Testing

### US-1: Registration ceremony on iOS (P1)

A site calls `navigator.credentials.create({publicKey: ...})` in a GUI iOS
webview. The shim forwards options to the native bridge, which runs
`ASAuthorizationController` (platform provider, plus security-key provider
unless `authenticatorAttachment` pins one side) anchored to the webview's
window. JS receives a PublicKeyCredential-shaped object with b64url
`id`/`rawId` and `response.{clientDataJSON, attestationObject}`.
**Device-gated**: webauthn.io registration/authentication on an entitled
build requires a real iOS device with Face/Touch ID and the pkc entitlement
— acceptance criteria 1–4 and 6 of the issue cannot be produced in this
environment; they are recorded as the app-side verification debt (same
posture spec 015 took: plugin evidence = source-contract suite + compile
gate, ceremony evidence = app side).

### US-2: Authentication ceremony on iOS (P1)

`navigator.credentials.get({publicKey: ...})` returns an assertion-shaped
credential: `response.{clientDataJSON, authenticatorData, signature,
userHandle}`. Device-gated as above.

### US-3: Headless fail-fast on iOS (P1)

A headless iOS WebView (parked in `HeadlessWebViewContainer`'s off-screen
`UIWindow`, issue #371 R3 — so `window == nil` cannot detect it) is rejected
immediately with `NotAllowedError` via the headless registry lookup
(`HeadlessInAppWebViewManager.webViews`). Covered by source-contract test.

### US-4: Non-publicKey credentials untouched (P2)

Password/OTP `navigator.credentials` calls fall through to the platform
default (shim behavior, identical source on both platforms).

### US-5: AbortSignal (P2)

An aborted `options.signal` cancels the outstanding
`ASAuthorizationController` and rejects with `AbortError`.

### US-6: No drift between the two native shims (P1)

The JS shim body is single-sourced in the platform_interface package; both
native `PasskeysJS.swift` files are generated from it. A source-contract
test in the iOS package extracts all three copies, normalizes the
named-bridge placeholder, and asserts they are identical — an edited copy
without regenerating goes red.

### US-7: Consumer opt-out (P1, macOS B2)

`passkeyBridgeEnabled` (default `true`) withholds both the shim injection
and the bridge construction when `false`. An explicitly requested
`webAuthenticationSupport == NONE` disarms too. Unset / `FOR_APP` /
`FOR_BROWSER` all arm (6.2.2 default behavior preserved). Creation-time
only: like `webAuthenticationSupport`, it cannot be toggled after the
WKWebView exists (the shim rides the immutable configuration); a runtime
change attempt is surfaced, not dropped silently (macOS, matching its
existing `webAuthenticationSupport` warning).

### US-8: Honest diagnostics (P2, macOS B1)

The FOR_BROWSER creation-time warning no longer points integrators at the
AASA/associated-domains dead end; it states that in-page ceremonies ride the
unconditional #358 bridge and the WebKit setting is diagnostic-only on
macOS.

## Functional Requirements

- **FR-001**: iOS injects `PASSKEYS_JS_PLUGIN_SCRIPT` (canonical shim source)
  at document start, every frame, right after the JS bridge user script.
- **FR-002**: iOS intercepts `callHandler('PasskeyBridge', ...)` natively in
  `InAppWebView.userContentController(_:didReceive:)` before the Dart
  round-trip; the target webview is resolved from `_windowId` (popup children
  get their own bridge instance), and the JS promise resolves by evaluating
  on that target webview.
- **FR-003**: iOS maps WebAuthn options → provider requests exactly as macOS
  (rpId normalization, base64url fields, pubKeyCredParams default
  ES256+RS256, excludeCredentials/allowCredentials, attestation,
  userVerification; security-key `residentKey` where the OS supports it).
- **FR-004**: Per-API availability guards at the iOS 15.0 package floor:
  the request-building classes and providers run unguarded at the 15.0
  floor, with each over-floor API carrying its own guard —
  `ASAuthorizationController.cancel()` under iOS 16.0, the platform
  registration request's `excludedCredentials` under iOS 17.4, and the
  security-key `residentKeyPreference` under iOS 17.4 (macOS parity at its
  own 13.0/14.4 numbers), consent manager (`ASAuthorizationWebBrowserPublicKeyCredentialManager`)
  not consulted in v1 on either platform — the macOS shipped the same
  window/entitlement-agnostic availability probe, and the iOS availability
  numbers for the manager (`isDeviceConfiguredForPasskeys` and friends) must
  be measured on a device before wiring, not assumed (recorded as follow-up).
- **FR-005**: Presentation anchor is the webview's window (`webView.window`,
  an `ASPresentationAnchor` on iOS); fail fast with `NotAllowedError` when
  the webview is headless (registry lookup) or window-less at ceremony time;
  single-ceremony gate (second concurrent ceremony → `NotAllowedError`);
  `cancelCeremony()` on webview dispose.
- **FR-006**: Same serialization/error contract as macOS: `{"ok": true,
  "credential": {...}}` / `{"ok": false, "error": {name, message}}`, b64url
  binary fields, DOMException name mapping (user cancel / timeout / none →
  `NotAllowedError`; bad options → `SecurityError`/`TypeError`).
- **FR-007**: Canonical shim source lives in
  `zikzak_inappwebview_platform_interface/lib/src/web_authentication/passkeys_js_source.dart`;
  `scripts/generate_passkeys_shim.sh` renders both native files from it; the
  iOS source-contract suite pins the three copies identical.
- **FR-008**: `passkeyBridgeEnabled` exists in the Dart settings entity
  (default `true`), both native settings classes, and gates arming on both
  platforms; explicit `webAuthenticationSupport == NONE` disarms as well.
- **FR-009**: macOS FOR_BROWSER diagnostics text rewritten per US-8, in the
  creation-time block and its `setSettings` counterpart.
- **FR-010**: Conditional mediation (passkey autofill) is tracked as a
  separate milestone issue; the shim keeps reporting
  `isConditionalMediationAvailable → false`.

**Deliberate parity note (iframe permissions-policy):** the shim overrides
`navigator.credentials` in every frame (`forMainFrameOnly: false`) with no
`publickey-credentials-create/get` permissions-policy check, so a
cross-origin iframe can run bridged ceremonies for its own RP where WebKit
would normally enforce the policy. This matches the shipped 6.2.x macOS shim
on purpose, and the shim's rp.id registrable-suffix check binds each
ceremony to the calling frame's origin — capability widens, scope does not.
Gating on the frame's permissions policy is recorded as a follow-up, not v1
scope.

## Success Criteria

1. iOS source-contract suite (`zikzak_inappwebview_ios/test/passkey_bridge_test.dart`)
   green; drift test green; macOS suite still green; analyze clean in every
   touched package.
2. Swift compile gate: `flutter build ios --release --no-codesign` and
   `flutter build macos --debug` in `zikzak_inappwebview/example` succeed.
3. Device-gated acceptance (webauthn.io ceremonies, consent numbers,
   Passwords.app visibility) recorded as open verification debt on the issue,
   with the gotchas (stale ASCAgent, late-availability manager APIs) carried
   over from #358.
