import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Issue #384 — macOS follow-ups B1 (stale diagnostics) and B2 (consumer
/// opt-out) for the passkey bridge shipped by #358/#359.
///
/// Since #359 the bridge bypasses WebKit mediation entirely, so the old
/// FOR_BROWSER warning pointing integrators at the webcredentials
/// Associated Domains / AASA flow misleads them into a dead end. And the
/// shim intercepted `navigator.credentials` on every macOS webview with no
/// way to opt out; `passkeyBridgeEnabled` (default on) is the switch, with
/// an explicitly requested `webAuthenticationSupport == NONE` disarming as
/// well.
///
/// These are source-contract tests: they read the Swift sources as text and
/// assert on their shape (`build-macos` CI is the compile gate).
void main() {
  final webViewSwift = File(
    'macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/'
    'InAppWebView.swift',
  );
  final settingsSwift = File(
    'macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/'
    'InAppWebViewSettings.swift',
  );

  group(
    'B1 - FOR_BROWSER diagnostics no longer point at AASA (issue #384)',
    () {
      late String source;

      setUpAll(() {
        expect(webViewSwift.existsSync(), isTrue);
        source = webViewSwift.readAsStringSync();
      });

      test('the associated-domains / AASA dead-end text is gone', () {
        expect(
          source,
          isNot(
            contains(
              'webcredentials Associated Domains entry plus apple-app-site-association',
            ),
          ),
        );
      });

      test('creation-time block states the bridge stance instead', () {
        expect(
          source,
          contains('in-page ceremonies ride the unconditional #358 bridge'),
        );
        expect(source, contains('diagnostic-only on macOS'));
      });

      test('setSettings counterpart carries the same stance', () {
        final setSettings = source.indexOf('func setSettings(');
        expect(setSettings, greaterThan(-1));
        final window = source.substring(
          setSettings,
          source.length > setSettings + 3000
              ? setSettings + 3000
              : source.length,
        );
        expect(
          window,
          contains('diagnostic-only on macOS'),
          reason:
              'the setSettings webAuthenticationSupport warning must carry '
              'the same rewritten stance as the creation-time block',
        );
      });
    },
  );

  group('B2 - passkeyBridgeEnabled consumer opt-out (issue #384)', () {
    late String webView;

    setUpAll(() {
      expect(webViewSwift.existsSync(), isTrue);
      expect(settingsSwift.existsSync(), isTrue);
      webView = webViewSwift.readAsStringSync();
    });

    test('the native settings class carries the switch defaulting to on', () {
      expect(
        settingsSwift.readAsStringSync(),
        contains('var passkeyBridgeEnabled = true'),
      );
    });

    test('bridge creation is gated, not unconditional', () {
      final armedIdx = webView.indexOf('passkeysArmed');
      final creationIdx = webView.indexOf('PasskeyBridge(webView: self)');
      expect(creationIdx, greaterThan(-1), reason: 'bridge creation not found');
      expect(
        armedIdx,
        greaterThan(-1),
        reason: 'the arming gate is missing entirely',
      );
      expect(
        armedIdx,
        lessThan(creationIdx),
        reason: 'the bridge must be created behind the arming gate',
      );
      expect(webView, contains('passkeyBridgeEnabled'));
    });

    test('shim injection is gated on the same switch', () {
      final armedIdx = webView.indexOf('passkeysArmed');
      final injectionIdx = webView.indexOf('addUserScript(passkeysScript)');
      expect(injectionIdx, greaterThan(-1), reason: 'shim injection not found');
      expect(armedIdx, greaterThan(-1));
      expect(
        armedIdx,
        lessThan(injectionIdx),
        reason: 'the shim injection must sit behind the arming gate',
      );
    });

    test('an explicitly requested webAuthenticationSupport NONE disarms', () {
      // macOS reads the raw creation-time settings map, so an explicitly
      // requested NONE is distinguishable from the unset default there.
      final armedIdx = webView.indexOf('passkeysArmed');
      expect(armedIdx, greaterThan(-1));
      final window = webView.substring(
        armedIdx,
        webView.length > armedIdx + 2500 ? armedIdx + 2500 : webView.length,
      );
      expect(window, contains('webAuthenticationSupport'));
    });
  });
}
