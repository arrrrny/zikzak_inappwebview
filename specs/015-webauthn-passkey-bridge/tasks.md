# Tasks: WebAuthn/Passkey Bridge (macOS)

- [x] T001 Write failing source-contract tests `zikzak_inappwebview_macos/test/passkey_bridge_test.dart` (FR-001..FR-007)
- [x] T002 `PluginScriptsJS/PasskeysJS.swift` — JS shim (create/get override, base64url codec, credential reconstruction, AbortSignal, PublicKeyCredential statics)
- [x] T003 `PasskeyBridge.swift` — native ASAuthorizationController bridge (option mapping, ceremonies, serialization, error names, headless fail-fast)
- [x] T004 `InAppWebView.swift` — shim injection, `PasskeyBridge` handler interception, dispose cleanup
- [x] T005 Green: `flutter test` in `zikzak_inappwebview_macos` (97 pass)
- [x] T006 Compile gate: `flutter build macos --debug` in `zikzak_inappwebview/example`
- [x] T007 `flutter analyze --no-fatal-infos` clean in `zikzak_inappwebview_macos`
