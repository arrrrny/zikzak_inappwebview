# Bug Assessment: fix(publish): platform_interface 5.0.1 broken

- **Slug**: platform-interface-publish-broken
- **Created**: 2026-08-24
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/255
- **Verdict**: likely valid, needs reproduction
- **Severity**: unknown

## Report (verbatim or summarized)

DUPLICATE of issue #249 (`platform-interface-compile-error`). The published
`zikzak_inappwebview_platform_interface-5.0.1` has a stale import in
`lib/src/in_app_webview/modules/platform_settings_delegate.dart` (line 3):
`import '../in_app_webview_settings.dart';` — but the Zorphy migration moved
`in_app_webview_settings.dart` to `lib/src/domain/entities/in_app_webview_settings/`.
The local repo compiles (imports via the barrel) but the published artifact is
broken, so every consumer of `^5.0.0` fails to compile.

## Symptom

Consumers of hosted `zikzak_inappwebview_platform_interface: ^5.0.0` fail to
compile with "No such file or directory ... in_app_webview_settings.dart".

## Reproduction

`flutter pub add zikzak_inappwebview` (5.x) in a fresh app and build; observe the
missing-file import error from `platform_settings_delegate.dart`.

## Suspected Code Paths

- `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/modules/platform_settings_delegate.dart:3`
- `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/main.dart` (barrel export)

## Root Cause Hypothesis

Stale relative import left in place after the Zorphy entity-path migration; only
the published package is affected (repo compiles via barrel).

## Proposed Remediation

Repoint the import in `platform_settings_delegate.dart` to the new entity path (or
via the barrel) and republish platform_interface; then cut 5.1.0.

## Risks & Considerations

- This is the same incident as #249 and #257; treat them as one fix and close the
  duplicates once resolved.
- Republishing requires a version bump and a clean publish of platform_interface.

## Open Questions

- Does `development` already contain the corrected import?
