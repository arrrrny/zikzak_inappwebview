# TDD Cycle Log — 015-webauthn-passkey-bridge

## Cycle 1 — PasskeyBridge.swift / PasskeysJS.swift / InAppWebView wiring (issue #358)

- **Red**: `flutter test test/passkey_bridge_test.dart` (in
  `zikzak_inappwebview_macos`) → `00:00 +0 -4: Some tests failed.`
  First failure: `PasskeyBridge.swift not found relative to package root`
  (setUpAll), plus the two InAppWebView wiring tests
  (`injects the shim at document start in every frame`,
  `intercepts the PasskeyBridge handler before the Dart round-trip`).
- **Green**: implemented the shim, the native bridge, and the wiring;
  same command → `00:00 +21: All tests passed!`
- **Full suite**: `flutter test` in `zikzak_inappwebview_macos` →
  `00:49 +97: All tests passed!`
- **Compile gate** (macOS tests are source-contract, not a type-check):
  `cd zikzak_inappwebview/example && flutter build macos --debug` →
  `✓ Built build/macos/Build/Products/Debug/example.app`
- **Analyze**: `flutter analyze --no-fatal-infos` → `No issues found!`

Note: end-to-end ceremony verification (webauthn.io registration +
authentication through the system sheet) requires an entitled host app —
that verification lives on the zuraffa_browser side (acceptance criteria
1–3 of issue #358); the plugin-side evidence is the suite + compile gate
above.
