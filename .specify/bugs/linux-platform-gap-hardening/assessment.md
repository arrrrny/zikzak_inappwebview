# Bug Assessment: [Linux] Platform gap analysis & hardening

- **Slug**: linux-platform-gap-hardening
- **Created**: 2026-08-24
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/251
- **Verdict**: likely valid, needs reproduction
- **Severity**: unknown

## Report (verbatim or summarized)

Consolidated Linux hardening report: a real logic bug in `onReceivedError`
(String==int compare makes every error `UNKNOWN`), swallowed callback errors,
incomplete `dispose`, stubbed `CookieManager` (no-ops), ~20% controller API
coverage (~71 methods throw `UnimplementedError`), and an unverified native
build. Several fixes (e.g. #227/#229) reportedly already landed on `development`.

## Symptom

Linux port is fragile and partially non-functional: error types lost, cookies
never persisted, many controller APIs unimplemented.

## Reproduction

`flutter build linux` (toolchain unavailable here) + runtime smoke tests.

## Suspected Code Paths

- `zikzak_inappwebview_linux/lib/src/in_app_webview_controller.dart` (onReceivedError, handleMethod, dispose)
- `zikzak_inappwebview_linux/lib/src/cookie_manager.dart` (stubbed)
- `zikzak_inappwebview_linux/lib/src/...` controller method coverage

## Root Cause Hypothesis

Deferred platform: logic bug + incomplete port + no CI coverage.

## Proposed Remediation

Merge the `onReceivedError` index-compare fix, stop swallowing errors, wire
CookieManager to WebKitGTK, implement `setSettings`, document/implement missing
methods, add a Linux CI job. Several items may already be on `development`.

## Risks & Considerations

- Substantial multi-file port work; native build unverifiable in this environment.
- Some fixes may already be merged on `development` — verify before re-implementing.

## Open Questions

- Which recommended fixes already landed on `development`?
