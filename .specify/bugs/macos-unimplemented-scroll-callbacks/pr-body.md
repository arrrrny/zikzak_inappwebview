## Summary

The native macOS side already emits `onScrollChanged` / `onContentSizeChanged` / `onOverScrolled` over the method channel (issue #197), but the Dart `handleMethod` dispatcher in `MacOSInAppWebViewController` had no `case` arms for them. They fell through to `default:` and threw `UnimplementedError` on every page load and scroll, spamming the console and silently never delivering the registered callbacks.

This adds the three missing `case` arms (mirroring the existing `onProgressChanged` arm), each null-guarded and decoding the native payload, so the callbacks forward to `params.webviewParams` when registered.

## Changes

| File | Change |
|------|--------|
| `zikzak_inappwebview_macos/lib/src/in_app_webview/in_app_webview_controller.dart` | Added `case 'onScrollChanged'`, `case 'onContentSizeChanged'`, `case 'onOverScrolled'` before `default:`, each forwarding decoded native args to the corresponding `webviewParams` callback. |
| `zikzak_inappwebview_macos/test/in_app_webview_controller_test.dart` | Added `scroll callbacks (issue #197)` group: 4 tests pinning the Dart-side channel contract (and that `default:` is no longer hit for these names). |

## Verification

- `dart analyze lib` → 0 errors.
- `flutter test` (macos package) → 41/41 passed, including the 4 new scroll-callback tests.

## Notes

- Pure additive change to the macOS plugin; no platform-interface or cross-platform API breakage.
- Does not change behavior for consumers that do not register these callbacks (null-guarded).

Assessment: `.specify/bugs/macos-unimplemented-scroll-callbacks/assessment.md`
