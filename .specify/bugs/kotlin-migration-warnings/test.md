# Bug Test: kotlin-migration-warnings

- **Slug**: kotlin-migration-warnings
- **Tested**: 2026-08-23
- **Result**: partial
- **Fix**: `.specify/bugs/kotlin-migration-warnings/fix.md`
- **Assessment**: `.specify/bugs/kotlin-migration-warnings/assessment.md`

## Reproduction (from assessment)

Build the Android example with `androidx.webkit:webkit:1.15.0` and confirm the build no longer emits:

```
warning: [removal] setRequestedWithHeaderOriginAllowList(...) in WebSettingsCompat has been deprecated and marked for removal
warning: [removal] getRequestedWithHeaderOriginAllowList(...) in WebSettingsCompat has been deprecated and marked for removal
```

## Checks executed

| Check | Method | Outcome |
|-------|--------|---------|
| Deprecated calls removed from source | `grep -rn "RequestedWithHeaderOriginAllowList" --include=*.java` over `zikzak_inappwebview_android/android/src/main` | **PASS** — 0 references remain (was 3). |
| No dangling symbols introduced | inspected removed blocks; `WebViewFeature.REQUESTED_WITH_HEADER_ALLOW_LIST` (constant, not deprecated) still used in `ZikZakSecurityManager.java`; `ArrayList` still used 4× in `InAppWebViewSettings.java` | **PASS** — no unused/dangling references. |
| Dart package still analyzes | `dart analyze lib` in `zikzak_inappwebview_android` | **PASS** — exit 0; 197 pre-existing `info`-level lints, no errors/warnings introduced by this Java-only change. |
| Android build emits zero `[removal]` warnings | `flutter build apk` / `./gradlew assemble` in the Android project | **NOT EXECUTED** — no Android SDK / Gradle in this environment. |

## Result: partial

The static and Dart-analysis checks pass, and the three deprecated call sites are confirmed removed. The **definitive** verification — an actual Android/Gradle build producing zero `[removal]` warnings — could not be run here because the environment has no Android SDK or Gradle. The edit is a conservative deletion of calls to still-existing no-op methods, so it is expected to compile and to clear the warnings, but this must be confirmed in a real Android build before merge.

## Required before merge

Run in an environment with the Android SDK:

```
cd zikzak_inappwebview_android/example
flutter build apk
# or, in the platform shell:
cd android && ./gradlew assembleDebug
```

and confirm there are no `warning: [removal] ... RequestedWithHeaderOriginAllowList` lines. (`androidx.webkit:webkit` is pinned to `1.15.0`.)

## Residual risk

If `androidx.webkit` were later bumped to a version that **removes** `setRequestedWithHeaderOriginAllowList` / `getRequestedWithHeaderOriginAllowList` entirely, this change is exactly what prevents the resulting hard compile break. No behavioral regression is expected because the methods are already no-ops (the X-Requested-With origin trial has ended).
