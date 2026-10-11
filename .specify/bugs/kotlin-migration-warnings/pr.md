# Bug PR: kotlin-migration-warnings

- **Slug**: kotlin-migration-warnings
- **Opened**: 2026-08-23
- **PR**: https://github.com/arrrrny/zikzak_inappwebview/pull/254
- **Branch**: `fix/kotlin-migration-warnings` (pushed to `origin`, based on `master`)
- **Linked issue**: #235 (referenced via "Closes #235" — auto-closes on merge)
- **Status**: opened

## What the PR does

Removes the three deprecated-for-removal `WebSettingsCompat.setRequestedWithHeaderOriginAllowList` / `getRequestedWithHeaderOriginAllowList` call sites (the X-Requested-With origin-trial API is now a no-op with no replacement), eliminating the `[removal]` build warnings and preventing a future hard compile break. Retains the public Dart `requestedWithHeaderOriginAllowList` setting for API compatibility.

## Files in the PR

- `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebView.java`
- `zikzak_inappwebview_android/android/src/main/java/wtf/zikzak/zikzak_inappwebview_android/webview/in_app_webview/InAppWebViewSettings.java`
- `zikzak_inappwebview_android/CHANGELOG.md`

(Excluded: `.specify/bugs/**` triage artifacts — local workflow files only.)

## Verification status

- Static + `dart analyze`: pass (see `test.md`).
- Android build (`flutter build apk` / `./gradlew assemble`): **not run** in prep env — flagged in the PR description for a maintainer to confirm before merge.

## Next steps

- Maintainer to confirm an Android build emits zero `[removal]` warnings.
- On merge, issue #235 auto-closes.
