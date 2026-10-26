# TDD Cycle Log — 016-ios-passkey-bridge (issue #384)

## Scope A — iOS passkey bridge parity (FR-001..FR-007, FR-010)

- **RED** `zikzak_inappwebview_ios/test/passkey_bridge_test.dart`
  (22 source-contract tests): observed failing before implementation —
  `PasskeyBridge.swift` missing (`setUpAll` file-expect red), shim-injection
  and handler-interception indexOf assertions `-1`, settings-gate assertions
  on empty blocks. Drift gate already green (canonical shim extracted
  byte-exact from shipped macOS 6.2.2 `PasskeysJS.swift`).
- **GREEN**: wrote `PasskeyBridge.swift` (iOS port of the macOS bridge;
  per-API availability guards measured from the iPhoneOS26.2 SDK headers —
  platform/security-key provider+descriptor+result classes iOS 15.0,
  `ASAuthorizationController.cancel()` iOS 16.0, platform
  `excludedCredentials` iOS 17.4, security-key `residentKeyPreference`
  iOS 17.4); wired `InAppWebView/InAppWebView.swift` (shim injected right
  after the JS bridge script, gated on arming; `PasskeyBridge` callHandler
  interception before the Dart round-trip, `_windowId` →
  `inAppWebViewManager.windowWebViews` popup routing, dispose cancel);
  added `passkeyBridgeEnabled` + `webAuthenticationSupportExplicitlyRequested`
  to `InAppWebView/InAppWebViewSettings.swift` (parse() records key
  presence after NSNull stripping).
- **Evidence**: `flutter test` → `00:00 +36: All tests passed!`
  (suite file alone), full package `+75: All tests passed!`

## Scope B — macOS follow-ups

- **B1 (FR-009) RED** `zikzak_inappwebview_macos/test/passkey_opt_out_test.dart`:
  AASA dead-end phrase still present, stance lines missing.
- **B1 GREEN**: FOR_BROWSER creation-time warning and `setSettings`
  counterpart rewritten (`in-page ceremonies ride the unconditional #358
  bridge`, `diagnostic-only on macOS`; AASA phrase removed).
- **B2 (FR-008) RED**: no arming gate, no settings switch.
- **B2 GREEN**: `passkeyBridgeEnabled` on macOS
  `InAppWebViewSettings.swift`; `passkeysArmed` computed from the raw
  creation-time map (`passkeyBridgeEnabled` unset → armed; explicit
  `webAuthenticationSupport` NONE disarms), gating both `PasskeyBridge`
  creation and `PASSKEYS_JS_SOURCE` injection; iOS mirrors the same gate
  via `passkeyBridgeEnabled` + `webAuthenticationSupportExplicitlyRequested`
  (iOS's native default is NONE, so only an explicit NONE disarms there).
- **Evidence**: `flutter test test/passkey_opt_out_test.dart` →
  `+7: All tests passed!`; full macOS package `+133: All tests passed!`

## Entity (FR-008, Dart surface)

- `zikzak_inappwebview_platform_interface/test/passkey_bridge_setting_test.dart`
  — `passkeyBridgeEnabled` (`bool?`, `@JsonKey(defaultValue: true)`) wired
  through Zorphy regen; `+3: All tests passed!`; full package
  `+309: All tests passed!`.
- Canonical shim: `passkeys_js_source.dart` +
  `scripts/generate_passkeys_shim.sh`; three-way identity pinned by the
  iOS drift test.

## Gates

- analyze: ios 192 infos (baseline-exact), macos 0 issues,
  platform_interface 77 infos (baseline-exact).
- compile: `flutter build ios --release --no-codesign` and
  `flutter build macos --debug` in `zikzak_inappwebview/example`
  (run at PR time; see PR body).
