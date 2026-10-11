# Bug Assessment: Docs: JS bridge global object renamed to `window.zikzak_inappwebview`

- **Slug**: docs-js-bridge-global-rename
- **Created**: 2026-08-24
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/258
- **Verdict**: likely valid, needs reproduction
- **Severity**: unknown

## Report (verbatim or summarized)

The fork renamed the injected JS bridge global from `window.flutter_inappwebview`
to `window.zikzak_inappwebview`, but the README/migration docs still imply the
old name. Migrators hit a silent `TypeError: Cannot read properties of undefined
(reading 'callHandler')` with no hint about the rename. The
`flutterInAppWebViewPlatformReady` event name is unchanged.

## Symptom

After migrating from flutter_inappwebview, `window.flutter_inappwebview.callHandler(...)`
throws because the bridge global is actually `window.zikzak_inappwebview`.

## Reproduction

Load a WebView, wait for `flutterInAppWebViewPlatformReady`, then call
`window.flutter_inappwebview.callHandler(...)`. Observe the TypeError. Calling
`window.zikzak_inappwebview.callHandler(...)` works.

## Suspected Code Paths

- Injected bridge global name set in the platform native/web layers (Android/iOS/web).
- README / migration guide documentation.

## Root Cause Hypothesis

Documentation gap: the rename of the JS bridge global was not reflected in docs.

## Proposed Remediation

Document the `window.zikzak_inappwebview` bridge global explicitly in the README
and migration guide (and JS communication guide), noting the
`flutterInAppWebViewPlatformReady` event name is unchanged.

## Risks & Considerations

- Loaded from an existing GitHub issue; triage is incomplete until refined.
- Confirm the exact injected global name on each platform before documenting.

## Open Questions

- Is the global name `window.zikzak_inappwebview` on all platforms (Android/iOS/web)?
