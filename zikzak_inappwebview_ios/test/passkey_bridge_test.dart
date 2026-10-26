import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Issue #384 — WebAuthn/passkeys via JS→native bridge on iOS (Scope A),
/// plus the single-source shim contract shared with macOS.
///
/// The macOS bridge shipped in 6.2.2 (issue #358 / #359); this issue ports it
/// to iOS over the same `ASAuthorizationController` APIs and moves the JS
/// shim source into `zikzak_inappwebview_platform_interface` so the two
/// native copies cannot drift.
///
/// The iOS package tests cannot compile Swift (they read the sources as text
/// and assert on their shape — `build-ios` CI is the compile gate), so these
/// tests pin the bridge contract: the shim source, the native bridge source,
/// the InAppWebView wiring between them, the no-drift guarantee, and the
/// `webView()` accessor contract that keeps the iOS release build compiling
/// (issue #386).
void main() {
  final bridgeSwift = File(
    'ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/'
    'PasskeyBridge.swift',
  );
  final shimSwift = File(
    'ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/'
    'PluginScriptsJS/PasskeysJS.swift',
  );
  final webViewSwift = File(
    'ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/'
    'InAppWebView/InAppWebView.swift',
  );
  final settingsSwift = File(
    'ios/zikzak_inappwebview_ios/Sources/zikzak_inappwebview_ios/'
    'InAppWebView/InAppWebViewSettings.swift',
  );
  final macosShimSwift = File(
    '../zikzak_inappwebview_macos/macos/zikzak_inappwebview_macos/Sources/'
    'zikzak_inappwebview_macos/PluginScriptsJS/PasskeysJS.swift',
  );
  final canonicalDart = File(
    '../zikzak_inappwebview_platform_interface/lib/src/web_authentication/'
    'passkeys_js_source.dart',
  );

  group('PasskeyBridge.swift native bridge on iOS (issue #384)', () {
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

    test(
      'guards the iOS 15-floor package against newer ASAuthorization APIs',
      () {
        // Package.swift floors at iOS 15.0 (issue #316); the platform and
        // security-key public-key-credential providers are iOS 16.0+, so every
        // request-building path and credential-type cast must ride an
        // availability guard, mirroring the macOS 13.0 guards.
        expect(source, contains('#available(iOS 16.0'));
        expect(source, contains('@available(iOS 16.0, *)'));
      },
    );

    test('exposes create/get/cancel/isUvPaa entry points', () {
      expect(source, contains('"create"'));
      expect(source, contains('"get"'));
      expect(source, contains('"cancel"'));
      expect(source, contains('"isUvPaa"'));
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

    test('uses the webview window as the presentation anchor', () {
      // ASPresentationAnchor on iOS is UIWindow; the anchor comes from the
      // webview's own window and the bridge refuses to start a ceremony
      // without one (mirroring macOS's no-window guard).
      expect(
        source,
        contains(
          'presentationAnchor(for controller: ASAuthorizationController)',
        ),
      );
      expect(source, contains('webView?.window'));
    });

    test('fails fast with NotAllowedError for headless webviews', () {
      // Headless iOS WebViews live in a real off-screen UIWindow (issue #371
      // R3), so window == nil cannot detect them — the bridge must consult
      // the HeadlessInAppWebViewManager registry instead.
      expect(source, contains('headlessInAppWebViewManager'));
      expect(source, contains('webViews'));
    });

    test('allows only one ceremony at a time per webview', () {
      // A second performRequests while one is outstanding fails instantly
      // with ASAuthorizationError 1004; the bridge must gate it first.
      expect(source, contains('already in progress'));
    });

    test(
      'cancelCeremony is available-guarded and called on webview dispose',
      () {
        expect(source, contains('func cancelCeremony()'));
        expect(source, contains('cancel()'));
      },
    );
  });

  group('isHeadlessWebView accessor contract (issue #386)', () {
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

    test('walks the headless registry via the webView() accessor call', () {
      // FlutterWebViewController.webView is a method, not a property, so the
      // registry comparison must use the InAppWebView the accessor returns.
      final accessor = RegExp(
        r'flutterWebView\?\.webView\(\)\s*===\s*webView\b',
      );
      expect(
        accessor.hasMatch(source),
        isTrue,
        reason:
            'isHeadlessWebView() must compare against the InAppWebView '
            'returned by calling webView() (#386)',
      );
    });

    test('never uses the webView tear-off as an InAppWebView value', () {
      // `flutterWebView?.webView` without the call is a `(() ->
      // InAppWebView?)?` function value; `===` against InAppWebView then has
      // no single overload and Swift fails the iOS release build with "Type
      // of expression is ambiguous without a type annotation" anchored at the
      // preceding optional binding (#386). Only the build-ios job type-checks
      // this file, so pin the call here where every job runs.
      //
      // Line comments are stripped before matching so that documenting this
      // bug by quoting the tear-off does not turn the pin red, and the
      // trailing boundary plus the optional space keep it off future members
      // (`webViewTitle`) and the spaced call (`webView ()`).
      final code = source
          .split('\n')
          .map((line) => line.split('//').first)
          .join('\n');
      final tearOff = RegExp(r'flutterWebView\?*\.webView\b(?!\s*\()');
      expect(
        tearOff.hasMatch(code),
        isFalse,
        reason:
            'found flutterWebView?.webView used as a value — the accessor '
            'must be called: webView() (#386)',
      );
    });
  });

  group('PasskeysJS.swift shim on iOS (issue #384)', () {
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

    test(
      'exposes a PluginScript injected at document start in every frame',
      () {
        expect(source, contains('PASSKEYS_JS_PLUGIN_SCRIPT_GROUP_NAME'));
        final injection = RegExp(r'injectionTime:\s*\.atDocumentStart,');
        expect(injection.hasMatch(source), isTrue);
        expect(source, contains('forMainFrameOnly: false'));
      },
    );

    test('overrides navigator.credentials.create and get', () {
      expect(source, contains('navigator.credentials.create'));
      expect(source, contains('navigator.credentials.get'));
    });

    test('only intercepts publicKey credentials', () {
      // Password/OTP credentials must fall through to the platform default.
      expect(source, contains('options.publicKey'));
    });

    test('bridges through the PasskeyBridge JS handler', () {
      expect(source, contains("callHandler('PasskeyBridge'"));
    });

    test(
      'interpolates the JS bridge name (no literal backslash-paren in emitted JS)',
      () {
        // A `\(` inside the Swift multiline string emits a literal backslash —
        // a JS SyntaxError that kills the whole shim IIFE while every
        // `contains` assertion still passes. Pin the interpolation contract so
        // the next escape slip goes red.
        expect(source, contains(r'window.\(JAVASCRIPT_BRIDGE_NAME)'));
        expect(source, isNot(contains(r'window.\\(')));
      },
    );

    test('normalizes the top-level rpId for authentication options', () {
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

    test(
      'reports conditional mediation as unavailable (modal ceremonies only)',
      () {
        // isConditionalMediationAvailable → false is the honest v1 stance
        // (issue #384 B3 tracks conditional UI separately).
        expect(source, contains('isConditionalMediationAvailable'));
      },
    );

    test('honors AbortSignal by cancelling the native ceremony', () {
      expect(source, contains('signal'));
      expect(source, contains('abort'));
    });

    test('rejects bridge errors as DOMExceptions with the native name', () {
      expect(source, contains('DOMException'));
    });
  });

  group('InAppWebView passkey wiring on iOS (issue #384)', () {
    late String source;

    setUpAll(() {
      expect(webViewSwift.existsSync(), isTrue);
      source = webViewSwift.readAsStringSync();
    });

    test('injects the shim right after the JS bridge user script', () {
      // Order matters: the shim calls through the bridge it is injected
      // after (macOS parity, issue #358 FR-001).
      final bridgeAdd = source.indexOf(
        'addPluginScript(JAVASCRIPT_BRIDGE_JS_PLUGIN_SCRIPT)',
      );
      final passkeysAdd = source.indexOf(
        'addPluginScript(PASSKEYS_JS_PLUGIN_SCRIPT)',
      );
      expect(
        bridgeAdd,
        greaterThan(-1),
        reason: 'bridge plugin script add not found',
      );
      expect(
        passkeysAdd,
        greaterThan(-1),
        reason: 'passkeys plugin script add not found',
      );
      expect(passkeysAdd, greaterThan(bridgeAdd));
    });

    test('intercepts the PasskeyBridge handler before the Dart round-trip', () {
      // The interception must sit inside the callHandler branch and resolve
      // the JS promise itself; the generic Dart round-trip comes later.
      final intercept = source.indexOf('handlerName == "PasskeyBridge"');
      final generic = source.indexOf('CallJsHandlerCallback()');
      expect(intercept, greaterThan(-1));
      expect(generic, greaterThan(intercept));
    });

    test('routes popup ceremonies to the child webview via _windowId', () {
      // window.open children share the parent's WKUserContentController, so
      // their PasskeyBridge messages arrive at the opener's handler; the
      // target bridge must be resolved from the _windowId the shim posts.
      final intercept = source.indexOf('handlerName == "PasskeyBridge"');
      expect(intercept, greaterThan(-1));
      final block = source.substring(
        intercept,
        source.length > intercept + 4000 ? intercept + 4000 : source.length,
      );
      expect(block, contains('_windowId'));
      expect(block, contains('windowWebViews'));
    });

    test('gates arming on the passkeyBridgeEnabled setting', () {
      expect(source, contains('passkeyBridgeEnabled'));
    });

    test('cancels the ceremony and drops the bridge on dispose', () {
      final disposeIdx = source.indexOf('public func dispose()');
      expect(disposeIdx, greaterThan(-1));
      final block = source.substring(disposeIdx);
      expect(block, contains('cancelCeremony()'));
      expect(block, contains('passkeyBridge = nil'));
    });
  });

  group('passkeyBridgeEnabled opt-out setting on iOS (issue #384 B2)', () {
    late String source;

    setUpAll(() {
      expect(settingsSwift.existsSync(), isTrue);
      source = settingsSwift.readAsStringSync();
    });

    test('defaults to true', () {
      expect(source, contains('var passkeyBridgeEnabled = true'));
    });

    test(
      'records whether webAuthenticationSupport was explicitly requested',
      () {
        // iOS's native webAuthenticationSupport defaults to 0 (NONE) — see the
        // iOS's webAuthenticationSupport defaults to 0 (NONE) natively — see
        // the honest read-back of issue #352 — so "NONE disarms" can only
        // apply to an explicitly REQUESTED NONE, never to the unset default.
        expect(source, contains('webAuthenticationSupportExplicitlyRequested'));
      },
    );
  });

  group('canonical shim source — no drift (issue #384)', () {
    test('both native shim bodies equal the platform_interface canonical', () {
      expect(
        canonicalDart.existsSync(),
        isTrue,
        reason: 'canonical passkeys_js_source.dart missing',
      );
      expect(
        macosShimSwift.existsSync(),
        isTrue,
        reason: 'macOS PasskeysJS.swift missing',
      );
      expect(
        shimSwift.existsSync(),
        isTrue,
        reason: 'iOS PasskeysJS.swift missing',
      );

      String extractSwiftBody(String swiftSource) {
        final open = swiftSource.indexOf('let PASSKEYS_JS_SOURCE = """');
        expect(open, greaterThan(-1));
        final bodyStart = swiftSource.indexOf('\n', open) + 1;
        final close = swiftSource.indexOf('"""', bodyStart);
        expect(close, greaterThan(bodyStart));
        return swiftSource.substring(bodyStart, close);
      }

      String extractDartBody(String dartSource) {
        final marker = "const String passkeysJsSource = r'''";
        final open = dartSource.indexOf(marker);
        expect(
          open,
          greaterThan(-1),
          reason: 'canonical const not found in passkeys_js_source.dart',
        );
        final bodyStart = dartSource.indexOf('\n', open) + 1;
        final close = dartSource.indexOf("'''", bodyStart);
        expect(close, greaterThan(bodyStart));
        return dartSource.substring(bodyStart, close);
      }

      const bridgeName = 'zikzak_inappwebview';
      String normalize(String text) => text
          // Swift renders \\ as one backslash in the emitted JS; compare
          // the emitted bytes, then swap both placeholder spellings.
          .replaceAll(r'\\', r'\')
          .replaceAll(r'\(JAVASCRIPT_BRIDGE_NAME)', bridgeName)
          .replaceAll(r'$javascriptBridgeName', bridgeName);

      final canonical = normalize(
        extractDartBody(canonicalDart.readAsStringSync()),
      );
      expect(canonical, isNotEmpty);
      expect(
        normalize(extractSwiftBody(shimSwift.readAsStringSync())),
        equals(canonical),
        reason:
            'iOS PASSKEYS_JS_SOURCE drifted from the canonical shim — edit '
            'passkeys_js_source.dart and run scripts/generate_passkeys_shim.sh',
      );
      expect(
        normalize(extractSwiftBody(macosShimSwift.readAsStringSync())),
        equals(canonical),
        reason:
            'macOS PASSKEYS_JS_SOURCE drifted from the canonical shim — edit '
            'passkeys_js_source.dart and run scripts/generate_passkeys_shim.sh',
      );
    });
  });
}
