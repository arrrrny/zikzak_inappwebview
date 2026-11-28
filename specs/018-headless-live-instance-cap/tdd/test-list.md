# Behavioral test list

| Requirement | Test entry point | Initial state |
| --- | --- | --- |
| Platform defaults remain 3/3/5/8 | `zikzak_inappwebview/test/headless_cap_test.dart` — defaults match the native platform ceilings | Green observed |
| Cap values below one are rejected | `zikzak_inappwebview/test/headless_cap_test.dart` — rejects caps below one | Green observed |
| Setter propagates before `run()` and updates registry defaults | `zikzak_inappwebview/test/headless_cap_test.dart` — propagates the cap and updates registry defaults; run observes the cap before native creation | Green observed |
| Live headless views block cap changes | `zikzak_inappwebview/test/headless_cap_test.dart` — run observes the cap before native creation and blocks live changes | Green observed |
| Module pool follows the process-wide cap | `zikzak_inappwebview_module/test/webview_pool_test.dart` — WebViewPool process-wide cap | Green observed |
| iOS channel and native manager honor the cap | `zikzak_inappwebview_ios/test/headless_lifecycle_contract_test.dart` — live cap propagation; native cap is mutable | Green observed |
| Android channel and native manager honor the cap | `zikzak_inappwebview_android/test/headless_lifecycle_contract_test.dart` — live cap propagation; native cap is mutable | Green observed |
| macOS channel and native manager honor the cap | `zikzak_inappwebview_macos/test/headless_lifecycle_contract_test.dart` — live cap propagation; native cap is mutable | Green observed |
