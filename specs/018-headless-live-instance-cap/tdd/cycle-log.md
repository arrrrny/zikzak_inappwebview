# TDD cycle log

## Cycle 1 — process-wide headless cap

### Red

Commands were run from each owning package with `--concurrency=2`:

- `flutter test test/headless_cap_test.dart --concurrency=2`
- `flutter test test/webview_pool_test.dart --concurrency=2`
- `flutter test test/headless_lifecycle_contract_test.dart --concurrency=2` in the iOS, Android, and macOS packages

All five commands exited 1 before implementation. Representative exact failures:

- `test/headless_cap_test.dart:49:35: Error: Member not found: 'maxLiveWebViews'.`
- `test/webview_pool_test.dart:529:28: Error: Setter not found: 'maxLiveWebViews'.`
- `zikzak_inappwebview_ios/test/headless_lifecycle_contract_test.dart:149:39: Error: Member not found: 'IOSHeadlessInAppWebView.setMaxLiveWebViews'.`
- `zikzak_inappwebview_android/test/headless_lifecycle_contract_test.dart:120:43: Error: Member not found: 'AndroidHeadlessInAppWebView.setMaxLiveWebViews'.`
- `zikzak_inappwebview_macos/test/headless_lifecycle_contract_test.dart:113:41: Error: Member not found: 'MacOSHeadlessInAppWebView.setMaxLiveWebViews'.`

### Green

The same five focused commands passed after implementation:

- Umbrella cap tests: `4` passed.
- Module pool tests: `22` passed.
- iOS lifecycle contract tests: `8` passed.
- Android lifecycle contract tests: `7` passed.
- macOS lifecycle contract tests: `7` passed.

Package-wide `flutter test --concurrency=2` verification passed:

- `zikzak_inappwebview_platform_interface`: `314` passed.
- `zikzak_inappwebview`: `282` passed.
- `zikzak_inappwebview_module`: `28` passed.
- `zikzak_inappwebview_ios`: `137` passed.
- `zikzak_inappwebview_android`: `41` passed.
- `zikzak_inappwebview_macos`: `195` passed.

`flutter analyze --no-fatal-infos` passed in all six packages with no warnings or errors. The core/module `scripts/grep_gate.sh` gate passed.

## Native verification

- `flutter build macos --debug --no-pub` passed and produced `build/macos/Build/Products/Debug/example.app`.
- `flutter build ios --release --no-codesign --no-pub` passed and produced `build/ios/iphoneos/Runner.app`.
- `flutter build apk --debug --no-pub` was attempted but could not start Java compilation because the host has no Java runtime (`Unable to locate a Java Runtime`). Android Dart analysis and lifecycle/source-contract tests passed.
