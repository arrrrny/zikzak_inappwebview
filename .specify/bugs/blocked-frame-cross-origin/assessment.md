# Bug Assessment: Blocked a frame with origin "null" from accessing a cross-origin frame

- **Slug**: blocked-frame-cross-origin
- **Created**: 2026-08-22
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/236
- **Verdict**: expected browser behavior / enhancement (not a simple plugin bug)
- **Severity**: medium

## Report (verbatim or summarized)

A page loaded inside an `<iframe>` tries to read `window.parent.window.zikzak_inappwebview` (the plugin's JS bridge object) and gets:
`SecurityError: Failed to read a named property 'zikzak_inappwebview' from 'Window': Blocked a frame with origin "null" from accessing a cross-origin frame.`

## Symptom

Cross-origin (or sandboxed / `file://`, i.e. origin `"null"`) iframes cannot access the bridge object that the plugin injects on the **main** frame.

## Reproduction

Load a page that embeds an iframe from a different origin (or a sandboxed iframe / local file) which executes `window.parent.window.zikzak_inappwebview`. The browser throws the SecurityError.

## Suspected Code Paths

- The JS bridge injection that sets `window.zikzak_inappwebview` on the top frame (typically in the WebView JS-channel / platform interface injection code). The object is not exposed to child frames, and cross-origin frames are blocked by the same-origin policy regardless.

## Root Cause Hypothesis

This is the browser's same-origin policy, not a plugin defect. An iframe with origin `"null"` is treated as a unique opaque origin and is barred from reading properties of the parent window. The plugin injects the bridge on the parent frame only; child frames cannot read it.

## Proposed Remediation

To support this access pattern the bridge would need a **postMessage-based proxy** (the main frame exposes a message handler that forwards calls to `window.zikzak_inappwebview` and returns results to the requesting frame), or the bridge must be injected into same-origin child frames. This is a design-level enhancement, not a one-line fix, and must be scoped carefully to avoid opening a cross-site scripting surface.

## Risks & Considerations

- A naive "expose the bridge to all frames" change would weaken the security boundary. Any solution must validate message origins.
- Recommend scoping as an enhancement with an explicit origin policy.

## Open Questions

- Should the bridge be available to same-origin iframes only, or also to cross-origin frames via a vetted postMessage protocol?
- What is the minimum viable API the iframe actually needs (callHandler? evaluateJavascript?)?
