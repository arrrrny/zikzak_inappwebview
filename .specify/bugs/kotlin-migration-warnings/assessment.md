# Bug Assessment: [Migrate to Built-in Kotlin] New warnings on version 5.0.0

- **Slug**: kotlin-migration-warnings
- **Created**: 2026-08-22
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/235
- **Verdict**: valid, low severity, deferred (needs Android build to verify replacement API)
- **Severity**: low

## Report (verbatim or summarized)

Flutter's "Migrate to Built-in Kotlin" advisory fires deprecation `[removal]` warnings during the Android build for `WebSettingsCompat.setRequestedWithHeaderOriginAllowList` / `getRequestedWithHeaderOriginAllowList` in `InAppWebView.java` (lines 750, 2230) and `InAppWebViewSettings.java` (line 978). These are warnings, not errors — the method still functions and is already wrapped in a `try/catch (ClassCastException)`.

## Symptom

`warning: [removal] setRequestedWithHeaderOriginAllowList(...) in WebSettingsCompat has been deprecated and marked for removal` during `./gradlew` assemble.

## Reproduction

Build the Android example with a recent `androidx.webkit:webkit` (1.11.0+ where the method is marked for removal). Observe the three `[removal]` warnings.

## Suspected Code Paths

- `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebView.java:750`, `:2230`
- `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebViewSettings.java:978`

## Root Cause Hypothesis

AndroidX WebKit deprecated `WebSettingsCompat.setRequestedWithHeaderOriginAllowList` for removal. The plugin still calls it for the `requestedWithHeaderOriginAllowList` setting.

## Proposed Remediation

Migrate to the replacement API (or remove the call if the functionality moved). This requires bumping `androidx.webkit` and confirming the exact replacement signature, which **cannot be verified in this environment (no Android SDK/build)**. Recommend a dedicated PR that also bumps the WebKit dependency and runs a real Android build to confirm zero `[removal]` warnings. Left as-is for now to avoid shipping an unverified Android change.

## Risks & Considerations

- Editing Android interop blindly without a build to verify can break the `requestedWithHeaderOriginAllowList` feature. Defer until an Android build is available.
- The "Built-in Kotlin" migration itself (removing the `kotlin-android` Gradle plugin) is a separate, larger change not covered here.

## Open Questions

- What is the exact replacement API in the target `androidx.webkit` version? (Needs a build environment to confirm.)
