# Bug Assessment / Fix: Flutter 3.47.x rendering layer confusion with embedded WebViews (#331)

- **Slug**: flutter347-platformview-rendering
- **Recorded**: 2026-09-25
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/331
- **Verdict**: valid — **not a plugin code defect**; Flutter 3.47.x engine platform-view
  compositing regression
- **Fix status**: not-applied (nothing to change in the plugin — no plugin-side code
  path is wrong; fix belongs upstream in flutter/flutter)

## Reproduction (confirmed on this machine, 2026-09-25)

- Host: macOS 15.6 (darwin 24.6.0), Xcode 26, **Flutter 3.47.4 stable** (same 3.47
  line as the reporter's 3.47.2), iPhone 16e simulator (iOS 18.x).
- App: the issue's exact repro code, wrapped with an auto-open + auto-scroll hook and
  a `NO_WEBVIEW` dart-define control. Dependency: `zikzak_inappwebview ^6.0.2` **from
  pub.dev** (the reporter's resolution path — no local overrides).

Observed (evidence screenshots in this directory):

| File | Symptom |
|------|---------|
| `zkw331_run6_3.png` | **"Bottom invisible"** — the WebView list item renders, but every list item below it and the sheet's teal 60 px Footer are missing (blank sheet background) |
| `zkw331_run6_2.png` | **"Header invisible"** — an entire white frame mid-interaction (whole UI blank for a frame, matching the reporter's flicker) |
| `zkw331_noimp_3.png` | identical artifact with `FLTEnableImpeller=false` (Impeller disabled) |

## Root-cause analysis

1. The plugin's iOS embedding is a **plain `UiKitView`** with the standard
   `creationParams` (`zikzak_inappwebview_ios/lib/src/in_app_webview/in_app_webview.dart:231`)
   — the same standard embedding Google's `webview_flutter` uses. There is no
   plugin-side composition-mode manipulation that could be wrong, and iOS offers no
   alternative composition mode to switch to (the old hybrid-composition mode is gone;
   TLHC — texture layer hybrid composition — is the only mode).
2. The artifact reproduces with **Impeller disabled**, so it is not the Impeller
   rasterizer; it is the engine's TLHC platform-view **compositing/clipping** when a
   platform view coexists with overlay routes (bottom sheet) and lazy list items —
   content below/behind the platform view is dropped from the final frame.
3. Flutter 3.47's release notes call out changed platform-view handling ("improved
   gesture propagation for native iOS views embedded via platform views"); the 3.44.x
   line renders the same repro correctly (reporter, and #293's downgrade test).

Conclusion: an upstream flutter/flutter engine regression in the 3.47 line, not a
zikzak_inappwebview code defect. A plugin code change cannot fix engine compositing.

## Workarounds (documented for users)

1. Stay on the Flutter 3.44.x stable line until the engine regression is fixed
   (reporter's own mitigation; also what #293 concluded).
2. Structural mitigations on the app side: avoid overlapping the platform view with
   routes that rely on compositing over it (e.g. present the sheet without the
   underlying WebView on screen, or keep platform views out of lazy lists via
   `addAutomaticKeepAlives`-style flattenings). These reduce exposure but do not fix
   the engine bug.
3. Recommended follow-up: file the minimal repro upstream on flutter/flutter
   (platform-view → TLHC compositing, `UiKitView`), referencing this issue.

## Disposition

- No PR: there is no defect in this repository to fix; any code change here would be
  superstition, not remediation.
- Posted a full diagnostic comment on the issue with the reproduction evidence and
  workarounds. Issue left **open** for the maintainer to track upstream / decide on
  closing as upstream.
