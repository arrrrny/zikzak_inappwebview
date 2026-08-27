# Bug Fix: ClassCastException String cannot be cast to Integer (Android settings)

- **Slug**: classcastexception-string-integer
- **Fixed**: 2026-08-22
- **Assessment**: ./assessment.md
- **Status**: applied (via merged external PR #246)

## Summary

The crash `java.lang.ClassCastException: java.lang.String cannot be cast to java.lang.Integer` at `InAppWebViewSettings.parse` was caused by the Dart `InAppWebViewSettings.toJson()` serializing enum fields as **string names** (e.g. `"OFF"`) while the Java `parse()` does a direct `(Integer) value` cast expecting **integer wire values**. This was introduced in 5.0.0 when the model layer migrated to the Zorphy/code-generated entities and the enum `@JsonKey` annotations lost their integer serialization.

The fix already exists in the `development` branch via **merged PR #246** (merge commit `333965e63a408c1d2fe30e197ea473983872d007`). It adds `toJson`/`fromJson` converters on the `@JsonKey` annotations for the affected enum fields, reusing the existing `toWire`/`fromWire` functions that map enums to their integer wire values (forceDark, forceDarkStrategy, mixedContentMode, cacheMode, disabledActionModeMenuItems, overScrollMode, scrollBarStyle, verticalScrollbarPosition, preferredContentMode, webAuthenticationSupport).

## Changes

| File | Change | Notes |
|------|--------|-------|
| `zikzak_inappwebview_platform_interface/lib/src/domain/entities/in_app_webview_settings/in_app_web_view_settings.zorphy.dart` | modified (in PR #246) | enum fields now serialized via `toWire`/`fromWire` integer converters (e.g. `forceDarkToWire`). Java `(Integer) value` cast is now correct. |
| `zikzak_inappwebview_android/.../InAppWebViewSettings.java` | unchanged | The `(Integer) value` casts were always correct; the bug was on the Dart side. |

## Diff Highlights

Generated model now emits integer wire values:

```dart
@JsonKey(
  toJson: forceDarkToWire,
  fromJson: forceDarkFromWire,
)
final ForceDark? forceDark;
```

## Tests Added or Updated

- No new tests were added in this session; the remediation shipped via PR #246. The crash is a serialization contract mismatch, validated by the model generation change.

## Local Verification

- `grep -c "forceDarkToWire" in_app_web_view_settings.zorphy.dart` → present (merge commit `333965e…` is an ancestor of `development`).
- Confirmed PR #246 is MERGED and its merge commit is reachable from the current `development` HEAD.

## Deviations from Assessment

None — the assessment's root-cause hypothesis (Dart side emitting strings for enum settings) matches the merged fix exactly.

## Follow-ups

- None required for this bug. Consider adding a Dart-side unit test asserting the serialized JSON contains integers (not strings) for enum settings, to prevent regression.
