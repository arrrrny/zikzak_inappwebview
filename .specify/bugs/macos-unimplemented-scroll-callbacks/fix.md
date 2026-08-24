# Bug Fix: macOS fires scroll callbacks into a `default:` that throws `UnimplementedError`

- **Slug**: macos-unimplemented-scroll-callbacks
- **Fixed**: 2026-08-24
- **Assessment**: ./assessment.md
- **Status**: applied

## Summary

The macOS plugin already received `onScrollChanged` / `onContentSizeChanged` / `onOverScrolled` from the native side (issue #197), but the Dart `handleMethod` dispatcher had no `case` arms for them, so they hit `default:` and threw `UnimplementedError` on every load and scroll. Added the three missing `case` arms (mirroring the existing `onProgressChanged` arm) so the callbacks forward to `params.webviewParams` when registered.

## Changes

| File | Change | Notes |
|------|--------|-------|
| `zikzak_inappwebview_macos/lib/src/in_app_webview/in_app_webview_controller.dart` | modified | Added `case 'onScrollChanged'`, `case 'onContentSizeChanged'`, `case 'onOverScrolled'` before `default:`, each null-guarded and decoding the native payload. |
| `zikzak_inappwebview_macos/test/in_app_webview_controller_test.dart` | added test | New `scroll callbacks (issue #197)` group: 4 tests pinning the Dart-side channel contract. |

## Diff Highlights

```dart
      case 'onScrollChanged':
        if (params.webviewParams?.onScrollChanged != null) {
          params.webviewParams!.onScrollChanged!(
            controller,
            call.arguments['x'] as int? ?? 0,
            call.arguments['y'] as int? ?? 0,
          );
        }
        break;
      case 'onContentSizeChanged':
        if (params.webviewParams?.onContentSizeChanged != null) {
          final old = call.arguments['oldContentSize'] as Map? ?? {};
          final neu = call.arguments['newContentSize'] as Map? ?? {};
          params.webviewParams!.onContentSizeChanged!(
            controller,
            Size((old['width'] as num? ?? 0).toDouble(), (old['height'] as num? ?? 0).toDouble()),
            Size((neu['width'] as num? ?? 0).toDouble(), (neu['height'] as num? ?? 0).toDouble()),
          );
        }
        break;
      case 'onOverScrolled':
        if (params.webviewParams?.onOverScrolled != null) {
          params.webviewParams!.onOverScrolled!(
            controller,
            call.arguments['x'] as int? ?? 0,
            call.arguments['y'] as int? ?? 0,
            call.arguments['clampedX'] as bool? ?? false,
            call.arguments['clampedY'] as bool? ?? false,
          );
        }
        break;
```

## Tests Added or Updated

- `zikzak_inappwebview_macos/test/in_app_webview_controller_test.dart::scroll callbacks (issue #197)` — `onScrollChanged invokes the callback with decoded x/y`, `onContentSizeChanged invokes the callback with decoded sizes`, `onOverScrolled invokes the callback with decoded flags`, `does not throw when no callback is registered`. The last test proves the `default:` throw is no longer hit for these three method names.

## Local Verification

- `dart analyze lib` → 0 errors (only a pre-existing unrelated `unnecessary_import` info in `cookie_manager.dart`).
- `flutter test` (macos package) → 41/41 passed, including the 4 new scroll-callback tests (`--plain-name "scroll callbacks"` → 4/4 passed).

## Deviations from Assessment

None. The applied fix matches the proposed remediation exactly.

## Follow-ups

- Consider a follow-up that makes `default:` a silent no-op (return null) so any *future* unhandled method does not spam `UnimplementedError`. Deferred per the assessment (primary fix is the three handlers; silent default would mask genuinely missing handlers).
