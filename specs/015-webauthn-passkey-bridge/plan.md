# Implementation Plan: WebAuthn/Passkey Bridge (macOS)

**Spec**: `specs/015-webauthn-passkey-bridge/spec.md` · **Issue**: #358

## Technical Context

- macOS plugin package `zikzak_inappwebview_macos` (Swift, SPM, macOS 12.0
  floor). AuthenticationServices: platform provider macOS 12+, security-key
  provider macOS 13+ (runtime-guarded), residentKeyPreference macOS 14.4+
  (runtime-guarded).
- The macOS package test suite is source-contract only (Swift is read as
  text); the compile gate is `cd zikzak_inappwebview/example && flutter
  build macos --debug` (mirrors CI's `build-macos` job).

## Design

1. **`PluginScriptsJS/PasskeysJS.swift`** — `PASSKEYS_JS_SOURCE`: overrides
   `navigator.credentials.create/get` for `options.publicKey` only
   (password/OTP fall through), encodes ArrayBuffers as `{"$b64url": ...}`
   markers, defaults `rp.id` to `location.hostname`, bridges via
   `window.zikzak_inappwebview.callHandler('PasskeyBridge', ...)`, rebuilds
   PublicKeyCredential-shaped objects, honors `AbortSignal` (bridge
   `cancel` + `AbortError`), and provides the `PublicKeyCredential` static
   feature-detection methods.
2. **`PasskeyBridge.swift`** — per-webview `ASAuthorizationController`
   driver: option mapping (FR-003), platform + security-key providers
   (both offered when `authenticatorAttachment` is unspecified),
   presentation anchor = webview window, headless fail-fast
   (`NotAllowedError`), one ceremony at a time, base64url codec, result
   serialization, DOMException error-name mapping.
3. **`InAppWebView.swift`** — injects the shim at `atDocumentStart` in
   every frame (popup webviews share the configuration, so they inherit
   it), intercepts `handlerName == "PasskeyBridge"` before the Dart
   round-trip, resolves the JS promise with the bridge's result JSON, and
   cancels outstanding ceremonies on dispose.

## Out of scope

- iOS (follow-up in the epic; entitlement state unverified).
- zuraffa_browser app-side enablement and consent bootstrap
  (`ASAuthorizationWebBrowserPublicKeyCredentialManager`) — different repo.
- Conditional UI / autofill mediation (`isConditionalMediationAvailable`
  reports false).

## Constitution check

TDD: source-contract tests written red first
(`passkey_bridge_test.dart`, `+0 -4`), then green (`+21`). No generated
code touched. No new dependencies.
