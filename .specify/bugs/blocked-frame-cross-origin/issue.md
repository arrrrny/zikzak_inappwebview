# Bug Issue: Blocked a frame with origin "null" from accessing a cross-origin frame.

- **Slug**: blocked-frame-cross-origin
- **Fetched**: 2026-08-22T21:09:19
- **Issue**: 236
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/236
- **State**: open
- **Severity**: unknown
- **Author**: Andrekarma
- **Labels**: none

## Body

When trying from an Iframe to access the javascriptHandler, there seems to be some origin problems

window.parent.window.zikzak_inappwebview
VM74:1 Uncaught SecurityError: Failed to read a named property 'zikzak_inappwebview' from 'Window': Blocked a frame with origin "null" from accessing a cross-origin frame.
    at _startVoipCall (script.js:851:3)
    at chiamacustom (script.js:846:3)
    at HTMLButtonElement.onclick (202608170845-turn.html?t=1786976627476:665:709)

## Comments

None.
