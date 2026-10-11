# Bug Assessment: platform_interface 5.0.1 settings.dart missing

- **Slug**: platform-interface-settings-missing
- **Created**: 2026-08-24
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/257
- **Verdict**: likely valid, needs reproduction
- **Severity**: unknown

## Report (verbatim or summarized)

DUPLICATE of issue #249 (`platform-interface-compile-error`) and #255. Raw
compiler output showing `platform_settings_delegate.dart` cannot read
`in_app_webview_settings.dart` (No such file or directory) and therefore cannot
find `InAppWebViewSettings`.

## Symptom

Compile error from `platform_settings_delegate.dart` importing a missing
`in_app_webview_settings.dart`, with `InAppWebViewSettings` unresolved.

## Reproduction

Consume hosted `zikzak_inappwebview_platform_interface: ^5.0.0` and build.

## Suspected Code Paths

- `zikzak_inappwebview_platform_interface/lib/src/in_app_webview/modules/platform_settings_delegate.dart:3`

## Root Cause Hypothesis

Same as #249/#255: stale import path after Zorphy entity migration; only the
published package is broken.

## Proposed Remediation

Same fix as #249/#255: correct the import and republish; then close #249/#255/#257
as resolved/duplicate.

## Risks & Considerations

- Tracked as one incident with #249 and #255.

## Open Questions

- None beyond the parent incident.
