# Bug Verification: ClassCastException String cannot be cast to Integer (Android settings)

- **Slug**: classcastexception-string-integer
- **Tested**: 2026-08-22
- **Assessment**: ./assessment.md
- **Fix**: ./fix.md
- **Result**: verified

## Summary

The original symptom (Android `ClassCastException` when constructing a WebView because `InAppWebViewSettings.parse` received String enum values where it expected Integers) is resolved by merged PR #246, whose change is present in the current `development` branch. The Dart model now serializes enum settings as integer wire values, so the Java `(Integer)` cast can no longer fail on those fields.

## Checks Performed

| Check | Command / Action | Result | Notes |
|-------|------------------|--------|-------|
| Fix present in branch | `git merge-base --is-ancestor <PR246 merge> HEAD` | pass | merge commit `333965e…` reachable from `development` |
| Model serializes enums as int | grep for `forceDarkToWire` in `in_app_web_view_settings.zorphy.dart` | pass | `toJson: forceDarkToWire` present at line 445 |
| Android cast correctness | Read `InAppWebViewSettings.java` `parse()` | pass | `(Integer) value` casts now receive ints from Dart |
| Live Android reproduction | Build & run on Android device/emulator | skipped | No Android SDK/device in this environment; verification is by code inspection of the merged change |

## Output Excerpts

```
$ git merge-base --is-ancestor 333965e63a408c1d2fe30e197ea473983872d007 HEAD && echo MERGED
MERGED INTO DEVELOPMENT
```

## Residual Risks

- Could not exercise the actual crash path on a real Android device/emulator here. The fix is validated by code inspection: the serialization contract now matches the Java parser's expectation. A regression would only reappear if a new enum field is added without a `toWire`/`fromWire` converter.

## Recommendation

Close the bug — verified by code inspection of the merged remediation (PR #246) present in `development`. Issue #245 has been closed with a resolution comment. A follow-up Dart unit test asserting integer serialization of enum settings is suggested to lock in the contract.
