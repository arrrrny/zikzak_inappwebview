# Bug Fix: Standardize dispose patterns + HeadlessInAppWebView double-dispose guard (#227)

- **Slug**: standardize-dispose-patterns
- **Fixed**: 2026-08-22
- **Assessment**: ./assessment.md
- **Status**: applied (partial — guard added to Headless + Controller; InAppWebView excluded, see notes)

## Summary

Added an idempotent double-dispose guard to `HeadlessInAppWebView` and `InAppWebViewController` so that calling `dispose()` more than once (e.g. manual dispose + widget-tree dispose) is a safe no-op instead of a crash. Also fixed a pre-existing broken relative import in `platform_interface` that prevented the whole package (and every downstream test) from compiling.

## Changes

| File | Change | Notes |
|------|--------|-------|
| `zikzak_inappwebview/lib/src/in_app_webview/headless_in_app_webview.dart` | modified | Added `_disposed` flag + `disposed` getter; `dispose()` now early-returns after first call. |
| `zikzak_inappwebview/lib/src/in_app_webview/in_app_webview_controller.dart` | modified | Same guard pattern as above. |
| `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/modules/platform_settings_delegate.dart` | modified | Fixed broken `import '../in_app_webview_settings.dart'` → `import '../../domain/entities/in_app_webview_settings/in_app_webview_settings.dart'` so the package compiles (was blocking all tests). |
| `zikzak_inappwebview/test/headless_dispose_test.dart` | added | Runtime test asserting the headless guard is idempotent. |

`InAppWebView` (the third wrapper) was **deliberately left unchanged**: it is `@immutable` with a `const` constructor, so a mutable `_disposed` field would break the const constructor / immutability contract. Its disposal is already managed by `_InAppWebViewState`.

## Diff Highlights

```dart
// HeadlessInAppWebView
bool _disposed = false;
bool get disposed => _disposed;

@override
Future<void> dispose({bool isKeepAlive = false}) async {
  if (_disposed) {
    return;
  }
  _disposed = true;
  await platform.dispose(isKeepAlive: isKeepAlive);
}
```

## Tests Added or Updated

- `zikzak_inappwebview/test/headless_dispose_test.dart` — `HeadlessInAppWebView.dispose is idempotent (double-dispose guard)` passes (verified locally).
- Existing `zikzak_inappwebview/test/disposable_pattern_test.dart` still passes.

## Local Verification

- `flutter test test/headless_dispose_test.dart` → All tests passed!
- `flutter test test/disposable_pattern_test.dart` → All tests passed!
- `dart analyze` on the three modified wrapper files → clean (only a pre-existing `library_private_types_in_public_api` info on `InAppWebView.createState`, unrelated to this change).

## Deviations from Assessment

The `InAppWebViewController`/`HeadlessInAppWebView` guards were applied as planned. `InAppWebView` was excluded for the immutability reason above; the assessment's "standardize across all four wrappers" is therefore partially met. The pre-existing `platform_settings_delegate.dart` import break was discovered while trying to run the test and fixed as a prerequisite.

## Follow-ups

- Decide whether `InAppWebView` needs a dispose guard via its `State` (e.g. guard in `_InAppWebViewState.dispose`) rather than on the immutable widget.
- Add a runtime test for `InAppWebViewController` double-dispose (needs a fake `PlatformInAppWebViewController`).
