import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/swift_source.dart';

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
      // The platform capability is the device's passkey configuration
      // (isDeviceConfiguredForPasskeys, macOS 26.2+), with the LAContext
      // deviceOwnerAuthentication query — biometrics OR the login
      // password — as the pre-26.2 fallback. Biometrics-only enrollment
      // never was the capability floor (issue #427).
      final body = functionBody(
        'private func isPlatformAuthenticatorAvailable() -> Bool {',
      );
      expect(body, contains('LAContext'));
      expect(body, contains('canEvaluatePolicy'));
      expect(body, contains('deviceOwnerAuthentication'));
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

  group('Passkey ceremony signs the web caller origin (issue #446)', () {
    // The app-context `createCredential*Request(challenge:)` API lets
    // AuthenticationServices derive the signed origin from the relying-party
    // identifier, so an RP used from a cross-origin iframe signed the RP
    // origin (`https://apple.com` for Apple's `idmsa.apple.com` iframe) and
    // App Store Connect failed the assertion. The browser client-data API
    // signs the origin the native side supplies, which must come from
    // WebKit's own view of the calling frame — never from JS.
    late String source;
    late String callerContextSource;
    late String webViewSource;

    setUpAll(() {
      source = bridgeSwift.readAsStringSync();
      webViewSource = webViewSwift.readAsStringSync();
      final callerContextSwift = File(
        'macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/'
        'PasskeyCallerContext.swift',
      );
      expect(
        callerContextSwift.existsSync(),
        isTrue,
        reason: 'PasskeyCallerContext.swift not found — issue #446',
      );
      callerContextSource = callerContextSwift.readAsStringSync();
    });

    test('derives the caller origin from the WebKit frame, not from JS', () {
      expect(
        callerContextSource,
        contains('securityOrigin'),
        reason:
            'the caller origin must come from WKFrameInfo.securityOrigin, '
            'WebKit\'s own view of the calling frame',
      );
      expect(callerContextSource, contains('frameInfo'));
      expect(
        source,
        isNot(contains('options["origin"]')),
        reason:
            'a JavaScript-provided origin is attacker-controlled; the bridge '
            'must only trust the frame the message arrived on',
      );
    });

    test('hands the calling frame to the bridge', () {
      expect(
        source,
        contains('caller: PasskeyCallerContext?'),
        reason: 'handleCall must accept the resolved caller context',
      );
      expect(
        webViewSource,
        contains('message.frameInfo'),
        reason:
            'the WKScriptMessage handler is the only place that knows which '
            'frame posted the ceremony request',
      );
      expect(webViewSource, contains('PasskeyCallerContext.from'));
    });

    test('builds assertion requests from client data when available', () {
      expect(
        source,
        contains('ASPublicKeyCredentialClientData(challenge:'),
        reason: 'the browser request must carry challenge AND origin',
      );
      expect(
        source,
        matches(RegExp(r'createCredentialAssertionRequest\(\s*clientData:')),
      );
      expect(source, contains('if #available(macOS 13.5, *)'));
    });

    test('builds registration requests from client data when available', () {
      expect(
        source,
        matches(RegExp(r'createCredentialRegistrationRequest\(\s*clientData:')),
      );
    });

    test(
      'signs security-key browser requests from client data where available',
      () {
        expect(
          source,
          matches(
            RegExp(
              r'if #available\(macOS 14\.4, \*\)[\s\S]{0,600}'
              r'createCredentialRegistrationRequest\(\s*clientData:',
            ),
          ),
          reason:
              'the security-key provider carries the client-data requests from '
              'macOS 14.4 and must use them too',
        );
      },
    );

    test('keeps the challenge-only path as the documented fallback', () {
      expect(
        source,
        matches(RegExp(r'createCredentialAssertionRequest\(\s*challenge:')),
        reason:
            'below macOS 13.5 the app-context API is the only one available '
            'and must still serve ceremonies',
      );
      expect(
        source,
        matches(RegExp(r'createCredentialRegistrationRequest\(\s*challenge:')),
      );
      expect(
        source,
        contains('signs the relying-party origin'),
        reason: 'the fallback\'s origin limitation must be documented in code',
      );
    });

    test('carries the cross-origin metadata the client data exposes', () {
      expect(source, contains('crossOrigin'));
      expect(source, contains('topOrigin'));
      expect(source, contains('.sameOriginWithAncestors'));
      expect(source, contains('.crossOrigin'));
      expect(
        callerContextSource,
        contains('sameOriginWithAncestors'),
        reason:
            'a same-origin subframe is still a subframe: the client data must '
            'say so instead of claiming a top-level ceremony',
      );
    });

    test('never claims a top-level ceremony for a known subframe', () {
      expect(
        callerContextSource,
        contains('return isMainFrame ? .notSet : .crossOrigin'),
        reason:
            'a subframe whose top-level origin has no serializable host '
            '(`about:blank`, `file://`) is still a subframe: `.notSet` reads '
            'as a top-level ceremony, which is the mismatch #446 fixes',
      );
    });

    test('re-brackets an IPv6 literal host in the serialized origin', () {
      expect(
        callerContextSource,
        contains(r'host.contains(":") && !host.hasPrefix("[")'),
        reason:
            'WKSecurityOrigin.host and URL.host both strip the brackets of an '
            'IPv6 literal, so the serialization has to put them back',
      );
      expect(
        callerContextSource,
        contains(r'"[\(host)]"'),
        reason: 'RFC 6454 serializes an IPv6 literal host in brackets',
      );
    });

    test('logs the app-context fallback instead of failing silently', () {
      expect(
        source,
        contains('no trusted caller origin'),
        reason:
            'the app-context fallback signs the relying-party origin — the '
            '#446 defect — so choosing it must leave a trace in the log',
      );
    });
  });

  group('iframe ceremonies settle through the reply handler (#446)', () {
    // The legacy `callHandler` reply is a main-frame `evaluateJavaScript`, so a
    // ceremony started in App Store Connect's cross-origin idmsa.apple.com
    // iframe never resolves its `postMessage` promise and the RP page times
    // out into the generic "browser needs to be updated" banner. macOS
    // therefore registers `PasskeyBridge` with the reply-capable
    // `addScriptMessageHandler(_:contentWorld:name:)` overload. These are
    // source-contract tests: the package cannot compile Swift, so `build-macos`
    // stays the compile gate.
    late String source;
    late String replyHandlerSwift;
    late String replyHandlerBody;

    setUpAll(() {
      source = webViewSwift.readAsStringSync();
      final replyHandlerFile = File(
        'macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/'
        'WeakReplyScriptMessageHandler.swift',
      );
      expect(
        replyHandlerFile.existsSync(),
        isTrue,
        reason: 'WeakReplyScriptMessageHandler.swift not found (#446)',
      );
      replyHandlerSwift = replyHandlerFile.readAsStringSync();
      replyHandlerBody = functionBody(
        source,
        'func userContentController(\n'
        '        _ userContentController: WKUserContentController, didReceive '
        'message: WKScriptMessage,\n'
        '        replyHandler: @escaping (Any?, String?) -> Void\n'
        '    )',
      );
    });

    test('registers PasskeyBridge through the reply-capable overload', () {
      expect(
        source,
        matches(
          RegExp(
            r'addScriptMessageHandler\(\s*'
            r'WeakReplyScriptMessageHandler\(delegate: self\),\s*'
            r'contentWorld: \.page,\s*'
            r'name: "PasskeyBridge"\s*\)',
          ),
        ),
        reason:
            'the reply-capable overload is the one that resolves the reply in '
            'the sending frame; the plain `add(_:name:)` overload would leave '
            'an iframe ceremony hanging',
      );
      expect(
        source,
        isNot(
          matches(
            RegExp(
              r'userContentController\.add\([\s\S]{0,200}?name: "PasskeyBridge"',
            ),
          ),
        ),
        reason:
            'a plain registration under the same name would shadow the reply '
            'path: WebKit would deliver the message without a reply handler',
      );
    });

    test('the wrapper conforms only to WKScriptMessageHandlerWithReply', () {
      // A helper that also conforms to the plain protocol resolves the plain
      // overload at the call site, and WebKit then registers it as plain —
      // postMessage never reaches the reply delegate.
      final code = stripSwiftNonCode(replyHandlerSwift);
      expect(
        code,
        contains('WKScriptMessageHandlerWithReply'),
        reason: 'the wrapper must be reply-capable',
      );
      expect(
        code,
        isNot(matches(RegExp(r'WKScriptMessageHandler\b'))),
        reason:
            'conforming to the plain WKScriptMessageHandler alongside the '
            'reply-capable one silently downgrades the registration',
      );
      expect(
        code,
        contains('replyHandler'),
        reason: 'the wrapper must forward the reply closure to its delegate',
      );
    });

    test('the handler reads the body through the #309 sanitizer', () {
      expect(
        replyHandlerBody,
        contains(
          'WeakScriptMessageHandler.defensivelyDeserializeBody(of: message)',
        ),
        reason:
            'the handler is registered under a name any page can post to, so '
            'it owes the same defensive read as every plain handler — a page '
            'posting a DOMException otherwise SIGSEGVs in CloneDeserializer '
            '(#309)',
      );
      expect(
        replyHandlerBody,
        isNot(contains('message.body as? [String: Any]')),
        reason: 'message.body must not be read directly on this path',
      );
      expect(
        replyHandlerBody,
        contains('deserializationError'),
        reason:
            'a body WebKit could not deserialize must be answered, not '
            'silently turned into an empty payload',
      );
    });

    test('a disarmed bridge answers an error instead of hanging the page', () {
      // The handler is registered unconditionally; `passkeyBridge` exists only
      // behind the creation-time arming gate. `passkeyBridge?.handleCall(...)`
      // therefore dropped the reply on the floor and left the page promise
      // unsettled forever.
      expect(
        replyHandlerBody,
        contains('guard let passkeyBridge else'),
        reason:
            'the nil bridge must be handled before it is used, not skipped '
            'with optional chaining',
      );
      expect(
        replyHandlerBody,
        contains('Passkey bridge is not armed.'),
        reason:
            'the page needs a DOMException-shaped answer the shim can reject; '
            'a dropped reply is what hangs the ceremony',
      );
      expect(
        replyHandlerBody,
        isNot(contains('passkeyBridge?.handleCall')),
        reason:
            'optional chaining is the hang: it calls nothing and never '
            'replies',
      );
      expect(
        replyHandlerBody,
        contains('PasskeyBridge.errorResult('),
        reason:
            'the error must be the bridge\'s own error shape, which the shim '
            'turns back into a DOMException with the right name',
      );
    });

    test('every reply path settles the page', () {
      // A path that returns without calling replyHandler is a hang by
      // construction — WebKit keeps the reply alive until it is called.
      final settled = RegExp(r'replyHandler\(').allMatches(replyHandlerBody);
      expect(
        settled.length,
        greaterThanOrEqualTo(3),
        reason:
            'expected the normal bridge reply plus the two error replies '
            '(undeserializable body, disarmed bridge); found '
            '${settled.length}',
      );
    });
  });
}
