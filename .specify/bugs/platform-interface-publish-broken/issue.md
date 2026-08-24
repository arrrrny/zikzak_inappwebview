# Bug Issue: fix(publish): platform_interface 5.0.1 broken — platform_settings_delegate.dart imports the pre-migration in_app_webview_settings.dart path

- **Slug**: platform-interface-publish-broken
- **Fetched**: 2026-08-24
- **Issue**: 255
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/255
- **State**: open
- **Severity**: unknown
- **Author**: arrrrny
- **Labels**: none

## Body

## Symptom
Any package that depends on hosted `zikzak_inappwebview_platform_interface: ^5.0.0` (i.e. every consumer of `zikzak_inappwebview` 5.x) fails to compile:
```
Error when reading '.../zikzak_inappwebview_platform_interface-5.0.1/lib/src/in_app_webview/in_app_webview_settings.dart': No such file or directory
import '../in_app_webview_settings.dart';
```

## Root cause
The Zorphy migration moved `in_app_webview_settings.dart` to `lib/src/domain/entities/in_app_webview_settings/`, and `in_app_webview/main.dart` was updated to export the new path — but `lib/src/in_app_webview/modules/platform_settings_delegate.dart` (line 3) still imports the **old** relative path `../in_app_webview_settings.dart`. The stale import shipped in published 5.0.1, making the package un-importable.

The local checkout's copy imports the entity through the barrel (`main.dart`), so the repo itself compiles — only the published artifact is broken.

## Fix
Update `platform_settings_delegate.dart` to import the settings entity from its new location (or via the barrel, like the rest of the migrated files) and republish. Consumers meanwhile can `dependency_overrides` to the git repo.

Found while wiring `zikzak_session` portable sessions into `zikzak_inappwebview` (spec 014) — the main package resolves hosted platform-interface 5.0.1 and cannot compile against it.

## Comments

None.
