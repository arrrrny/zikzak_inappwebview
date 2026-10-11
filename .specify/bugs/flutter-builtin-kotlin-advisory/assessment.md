# Bug Assessment: Flutter Built-in Kotlin advisory dump (mostly out of scope)

- **Slug**: flutter-builtin-kotlin-advisory
- **Created**: 2026-08-23
- **Source**: pasted text (build warning output from the consumer app `zik_zak`)
- **Verdict**: invalid (duplicate of `kotlin-migration-warnings` for the in-scope part; remainder is out of scope for this repo)
- **Severity**: low

## Report (verbatim or summarized)

The pasted output is a Flutter Android build log containing three categories of warnings:

1. **Kotlin version advisory**: `Flutter support for your project's Kotlin version (2.2.20) will soon be dropped. Please upgrade your Kotlin version to a version of at least 2.3.20 soon.` The advisory points at the consumer app's `settings.gradle` / `build.gradle` (`/Users/ahmettok/Developer/zik_zak/android/...`).
2. **KGP plugin advisory**: `Your app uses the following plugins that apply Kotlin Gradle Plugin (KGP): firebase_app_check, google_mlkit_barcode_scanning, google_mlkit_commons, google_mlkit_text_recognition, rate_my_app, sign_in_with_apple. Future versions of Flutter will fail to build if your app uses plugins that apply KGP.` (Generic Flutter "Migrate to Built-in Kotlin" boilerplate.)
3. **WebSettingsCompat `[removal]` deprecation** (this is the only part touching this repo):
   ```
   zikzak_inappwebview_android/.../webview/in_app_webview/InAppWebView.java:750: warning: [removal] setRequestedWithHeaderOriginAllowList(WebSettings,Set<String>) in WebSettingsCompat has been deprecated and marked for removal
   zikzak_inappwebview_android/.../webview/in_app_webview/InAppWebView.java:2230: warning: [removal] setRequestedWithHeaderOriginAllowList(WebSettings,Set<String>) in WebSettingsCompat has been deprecated and marked for removal
   zikzak_inappwebview_android/.../webview/in_app_webview/InAppWebViewSettings.java:1017: warning: [removal] getRequestedWithHeaderOriginAllowList(WebSettings) in WebSettingsCompat has been deprecated and marked for removal
   ```
   (Plus generic `-Xlint:deprecation` / `-Xlint:unchecked` notes.)

## Symptom

A developer building the consumer app sees a wall of build warnings. Only the `WebSettingsCompat` `[removal]` warnings originate from this plugin's source; the Kotlin-version and KGP-plugin warnings originate from the consumer app's own config and third-party plugins, not from `zikzak_inappwebview`.

## Reproduction

1. Build an Android app that depends on `zikzak_inappwebview` with a recent `androidx.webkit:webkit` (the plugin pins `1.15.0`) and recent Flutter tooling.
2. Observe the three `WebSettingsCompat.setRequestedWithHeaderOriginAllowList` / `getRequestedWithHeaderOriginAllowList` `[removal]` warnings.
3. The Kotlin-version / KGP-plugin warnings appear only when the **consumer app** itself uses Kotlin 2.2.20 or KGP-applying plugins — they do not reproduce from this repo in isolation.

- [NEEDS CLARIFICATION: Is the goal to file/track the consumer-app Kotlin/KGP warnings, or only the in-repo `WebSettingsCompat` deprecation? The former belongs to the app repo, not this one.]

## Suspected Code Paths

- `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebView.java:750` — `WebSettingsCompat.setRequestedWithHeaderOriginAllowList(...)` (already in `try/catch (ClassCastException)`).
- `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebView.java:2230` — same call, second site.
- `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebViewSettings.java:1017` — `WebSettingsCompat.getRequestedWithHeaderOriginAllowList(...)`.

These three sites are **already assessed** under slug `kotlin-migration-warnings` (assessment written 2026-08-22). No new code paths are implicated by this report.

The Kotlin-version and KGP-plugin warnings have **no** corresponding code path in this repo:
- `zikzak_inappwebview_android/android/build.gradle` applies only `com.android.library` and uses `sourceCompatibility JavaVersion.VERSION_17` — there is **no** `org.jetbrains.kotlin.android` plugin and no `ext.kotlin_version`. The module is pure Java.
- `zikzak_inappwebview_android/android/settings.gradle` contains only `rootProject.name`.
- None of the KGP-listed plugins (`firebase_app_check`, `google_mlkit_*`, `rate_my_app`, `sign_in_with_apple`) are this plugin.

## Root Cause Hypothesis

The `WebSettingsCompat` warnings are caused by AndroidX WebKit deprecating `setRequestedWithHeaderOriginAllowList` / `getRequestedWithHeaderOriginAllowList` for removal; the plugin still calls them for the `requestedWithHeaderOriginAllowList` setting. This is the **same root cause already tracked** in `kotlin-migration-warnings`.

The Kotlin-version and KGP-plugin warnings are emitted by Flutter's "Migrate to Built-in Kotlin" advisory against the **consumer application's** build, which is a different repository (`zik_zak`) and different set of plugins. They are unrelated to this plugin's source. Confidence: high (confirmed by inspecting this repo's Gradle files).

## Proposed Remediation

**Preferred**: No new fix is warranted from this report. The single in-repo actionable item (the `WebSettingsCompat` deprecation) is already captured in `.specify/bugs/kotlin-migration-warnings/assessment.md`. That bug should be the one taken to `/skill:speckit-bug-fix` (it requires an Android build to confirm the replacement API and is currently deferred).

**For the consumer app (`zik_zak`)**, which is out of scope here:
- Upgrade the app's Kotlin to ≥ 2.3.20 (edit the `org.jetbrains.kotlin.android` plugin version in the app's `settings.gradle`/`build.gradle`).
- Upgrade the KGP-applying plugins (`firebase_app_check`, `google_mlkit_*`, `rate_my_app`, `sign_in_with_apple`) to versions that support Built-in Kotlin, or migrate them per Flutter's guide.

**Files likely to change** (only if/when the existing `kotlin-migration-warnings` bug is worked):
- `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebView.java`
- `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebViewSettings.java`
- `zikzak_inappwebview_android/android/build.gradle` (bump `androidx.webkit:webkit` if needed for the replacement API)

**Tests to add or update**: Android build smoke test asserting zero `[removal]` warnings for `WebSettingsCompat` (requires an Android build environment).

## Risks & Considerations

- Editing the Android interop without a real Android build to verify the replacement signature can break the `requestedWithHeaderOriginAllowList` feature. This is why `kotlin-migration-warnings` is deferred; do not blindly patch it here.
- The "Built-in Kotlin" migration for *this plugin* is a separate, larger roadmap item (see `// See #70 for the planned AGP 9.0 / built-in Kotlin migration.` in `zikzak_inappwebview_android/android/build.gradle:14`). The KGP-plugin warnings in this report do **not** apply to this plugin today because it does not use KGP.
- This assessment does not modify any source files; it only triages the pasted report.

## Open Questions

- [NEEDS CLARIFICATION: Is the intent to also track the consumer-app Kotlin/KGP warnings? If so, those belong in the `zik_zak` app repository, not here.]
- Should the existing `kotlin-migration-warnings` assessment be updated to reference this duplicate report and the #70 AGP 9.0 / built-in-Kotlin roadmap note?
