import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Issue #358 — WebAuthn/passkeys via JS→native bridge on macOS.
///
/// WebKit's in-page WKWebView WebAuthn mediation is broken for entitled
/// custom-browser apps (ASCAgent dies with
/// `com.apple.AuthenticationServicesCore.AuthorizationError Code=1` ~2 ms
/// after "Allowing request from web browser.", no UI shown — see
/// zuraffa_browser#278). The fix bypasses WebKit mediation: a JS shim
/// overrides `navigator.credentials.create/get` for PublicKeyCredential
/// options and forwards the ceremony over the plugin's JS-handler channel
/// to a native `PasskeyBridge` driving `ASAuthorizationController`.
///
/// The macOS package tests cannot compile Swift (they read the sources as
/// text and assert on their shape — `build-macos` CI is the compile gate),
/// so these tests pin the bridge contract: the shim source, the native
/// bridge source, and the InAppWebView wiring between them.
void main() {
  final bridgeSwift = File(
    'macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/'
    'PasskeyBridge.swift',
  );
  final shimSwift = File(
    'macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/'
    'PluginScriptsJS/PasskeysJS.swift',
  );
  final webViewSwift = File(
    'macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/'
    'InAppWebView.swift',
  );

  group('PasskeyBridge.swift native bridge (issue #358)', () {
    late String source;

    setUpAll(() {
      expect(
        bridgeSwift.existsSync(),
        isTrue,
        reason:
            'PasskeyBridge.swift not found relative to package root '
            '(cwd: ${Directory.current.path})',
      );
      source = bridgeSwift.readAsStringSync();
    });

    test(
      'imports AuthenticationServices and drives ASAuthorizationController',
      () {
        expect(source, contains('import AuthenticationServices'));
        expect(source, contains('ASAuthorizationController'));
        expect(source, contains('ASAuthorizationControllerDelegate'));
        expect(
          source,
          contains('ASAuthorizationControllerPresentationContextProviding'),
        );
      },
    );

    test('offers platform and security-key credential providers', () {
      expect(
        source,
        contains('ASAuthorizationPlatformPublicKeyCredentialProvider'),
      );
      expect(
        source,
        contains('ASAuthorizationSecurityKeyPublicKeyCredentialProvider'),
      );
    });

    test('exposes create/get/cancel entry points', () {
      expect(source, contains('"create"'));
      expect(source, contains('"get"'));
      expect(source, contains('"cancel"'));
    });

    test('maps userVerification to the ASAuthorization preference enum', () {
      expect(
        source,
        contains(
          'ASAuthorizationPublicKeyCredentialUserVerificationPreference',
        ),
      );
      expect(source, contains('.required'));
      expect(source, contains('.preferred'));
      expect(source, contains('.discouraged'));
    });

    test('decodes base64url challenges and credential ids', () {
      // WebAuthn transports binary fields as base64url — a plain
      // Data(base64Encoded:) rejects `-`/`_` and unpadded input, so the
      // bridge must carry its own decoder.
      expect(source, contains('base64url'));
    });

    test('maps attestation preference and pubKeyCredParams', () {
      expect(source, contains('attestationPreference'));
      expect(source, contains('pubKeyCredParams'));
    });

    test('maps excludeCredentials and allowCredentials descriptors', () {
      expect(source, contains('excludeCredentials'));
      expect(source, contains('allowCredentials'));
    });

    test('accepts the top-level rpId fallback for authentication options', () {
      // Authentication options never carry `rp.id`; the native side must
      // read the top-level `rpId` too (issue #359 review finding 2).
      expect(source, contains('?["id"] as? String'));
      expect(source, contains('options["rpId"] as? String'));
    });

    test('serializes attestation and assertion responses back to JS', () {
      expect(source, contains('attestationObject'));
      expect(source, contains('clientDataJSON'));
      expect(source, contains('authenticatorData'));
      expect(source, contains('signature'));
      expect(source, contains('userHandle'));
      expect(source, contains('authenticatorAttachment'));
    });

    test('maps errors to DOMException names', () {
      expect(source, contains('NotAllowedError'));
      expect(source, contains('SecurityError'));
      expect(source, contains('TypeError'));
    });

    test('uses the webview window as presentation anchor', () {
      expect(
        source,
        contains(
          'presentationAnchor(for controller: ASAuthorizationController)',
        ),
      );
      expect(source, contains('webView?.window'));
    });

    test('fails fast with NotAllowedError for headless webviews', () {
      // Headless WebViews have no user-visible presentation surface; the
      // bridge must reject immediately (matching today's NONE stance)
      // instead of hanging the JS promise.
      expect(source, contains('isHeadlessOffscreen'));
    });
    test(
      'answers isUvPaa from device passkey configuration, not Touch ID enrollment (#427)',
      () {
        // A configured Mac without an enrolled fingerprint still verifies
        // passkey ceremonies with the login password: the biometrics-only
        // LAContext floor answered false there and re-broke ASC
        // (zuraffa_browser#836). Measured 2026-11-14, macOS 26.7.1:
        // biometrics false, deviceOwnerAuthentication true,
        // isDeviceConfiguredForPasskeys true.
        expect(source, contains('isDeviceConfiguredForPasskeys'));
        expect(source, contains('deviceOwnerAuthentication'));
        expect(
          source,
          isNot(contains('deviceOwnerAuthenticationWithBiometrics')),
          reason:
              'the biometrics-only floor answered false on every '
              'fingerprint-less configured Mac (issue #427)',
        );
        expect(source, contains('if #available(macOS 26.2'));
      },
    );
  });

  group('isUvPaa availability contract (issue #422)', () {
    late String source;

    setUpAll(() {
      source = bridgeSwift.readAsStringSync();
    });

    /// Extracts a Swift function body: from the signature line to the first
    /// closing brace at the function's own indentation (4 spaces).
    String functionBody(String signature) {
      final start = source.indexOf(signature);
      expect(start, isNot(-1), reason: 'signature not found: $signature');
      final end = source.indexOf('\n    }', start);
      expect(end, isNot(-1), reason: 'function body not found: $signature');
      return source.substring(start, end);
    }

    test('the availability static never reads window presence', () {
      // isUvPaa must report whether a user-verifying platform authenticator
      // EXISTS on this machine — Safari answers true for background tabs, and
      // sites gate their passkey UX on the static (ASC's red "browser needs
      // to be updated" warning, zuraffa_browser#836). A background tab's
      // WebView has no window, so a window-presence check answers false
      // there and every hidden tab advertises "no platform authenticator".
      final body = functionBody(
        'private func isPlatformAuthenticatorAvailable() -> Bool {',
      );
      expect(
        body,
        isNot(contains('.window')),
        reason:
            'the availability static must not read webView.window — window '
            'presence is a ceremony-time concern (beginCeremony), not a '
            'capability answer (issue #422)',
      );
    });

    test('the availability static still fails fast for headless webviews', () {
      // The headless/offscreen fail-fast stance is app-side pinned
      // (zuraffa_browser test/platform/macos_headless_webauthn_test.dart) and
      // is independent of the window-presence decoupling.
      final body = functionBody(
        'private func isPlatformAuthenticatorAvailable() -> Bool {',
      );
      expect(body, contains('isHeadlessOffscreen'));
    });

    test('the availability static answers from platform capability', () {
      // LAContext's biometry query is the capability floor: Touch ID
      // hardware is the user-verifying platform authenticator on macOS.
      // (ASAuthorizationWebBrowserPublicKeyCredentialManager carries no
      // availability query before macOS 26.2, so it cannot answer the
      // static on the deployment target.)
      final body = functionBody(
        'private func isPlatformAuthenticatorAvailable() -> Bool {',
      );
      expect(body, contains('LAContext'));
      expect(body, contains('canEvaluatePolicy'));
      expect(body, contains('deviceOwnerAuthenticationWithBiometrics'));
      expect(source, contains('import LocalAuthentication'));
    });

    test('the window check stays at ceremony time', () {
      // Decoupling the static must not remove the ceremony-time guard:
      // presenting the passkey sheet still requires a window, and
      // beginCeremony is where that failure belongs (NotAllowedError).
      final body = functionBody(
        'private func beginCeremony(completion: @escaping ([String: Any]) -> Void) -> Bool {',
      );
      expect(body, contains('webView.window != nil'));
      expect(body, contains('no window to present the passkey sheet'));
    });
  });

  group('PasskeysJS.swift shim (issue #358)', () {
    late String source;

    setUpAll(() {
      expect(
        shimSwift.existsSync(),
        isTrue,
        reason:
            'PasskeysJS.swift not found relative to package root '
            '(cwd: ${Directory.current.path})',
      );
      source = shimSwift.readAsStringSync();
    });

    test('exposes a PASSKEYS_JS_SOURCE user-script constant', () {
      expect(source, contains('PASSKEYS_JS_SOURCE'));
    });

    test('overrides navigator.credentials.create and get', () {
      expect(source, contains('navigator.credentials.create'));
      expect(source, contains('navigator.credentials.get'));
    });

    test('only intercepts PublicKeyCredential options', () {
      // Password/OTP credentials must fall through to the platform default.
      expect(source, contains('options.publicKey'));
    });

    test('bridges through the PasskeyBridge JS handler', () {
      expect(source, contains("callHandler('PasskeyBridge'"));
    });

    test('interpolates the JS bridge name (no literal backslash-paren in emitted JS)', () {
      // A `\\(` inside the Swift multiline string emits a literal
      // backslash — a JS SyntaxError that kills the whole shim IIFE while
      // every `contains` assertion still passes. Pin the interpolation
      // contract so the next escape slip goes red.
      expect(source, contains(r'window.\(JAVASCRIPT_BRIDGE_NAME)'));
      expect(source, isNot(contains(r'window.\\(')));
    });

    test('normalizes the top-level rpId for authentication options', () {
      // PublicKeyCredentialRequestOptions carries the optional rpId at the
      // top level — there is no `rp` object — so the shim must map it onto
      // both shapes for the native bridge.
      expect(source, contains('publicKey.rpId'));
    });

    test('rejects an rpId outside the caller origin with SecurityError', () {
      expect(source, contains('registrable suffix of the caller origin'));
    });

    test(
      'returns PublicKeyCredential-shaped objects with ArrayBuffer fields',
      () {
        expect(source, contains('rawId'));
        expect(source, contains('ArrayBuffer'));
        expect(source, contains('getClientExtensionResults'));
        expect(source, contains('authenticatorAttachment'));
        expect(source, contains('"public-key"'));
      },
    );

    test('implements isUserVerifyingPlatformAuthenticatorAvailable', () {
      expect(source, contains('isUserVerifyingPlatformAuthenticatorAvailable'));
    });

    test('honors AbortSignal by cancelling the native ceremony', () {
      expect(source, contains('signal'));
      expect(source, contains('abort'));
    });

    test('rejects bridge errors as DOMExceptions with the native name', () {
      expect(source, contains('DOMException'));
    });
  });

  group('InAppWebView passkey wiring (issue #358)', () {
    late String source;

    setUpAll(() {
      source = webViewSwift.readAsStringSync();
    });

    test('injects the shim at document start in every frame', () {
      final injection = RegExp(
        r'WKUserScript\(\s*'
        r'source:\s*PASSKEYS_JS_SOURCE,\s*'
        r'injectionTime:\s*\.atDocumentStart,\s*'
        r'forMainFrameOnly:\s*false\s*\)',
      );
      expect(
        injection.hasMatch(source),
        isTrue,
        reason:
            'the passkey shim must be injected atDocumentStart into every '
            'frame, alongside the JS bridge user script',
      );
    });

    test('intercepts the PasskeyBridge handler before the Dart round-trip', () {
      expect(source, contains('"PasskeyBridge"'));
    });
  });
}
