# Bug Assessment: macOS find-in-page result delivery and virtualized rescan

- **Slug**: macos-find-walker-rescan
- **Created**: 2026-11-28
- **Source**: https://github.com/arrrrny/zikzak_inappwebview/issues/472 (GitHub host, allowlisted; read through `gh issue view`)
- **Verdict**: valid
- **Severity**: high

## Report (verbatim or summarized)

Find-in-page on long virtualized pages can miss off-window matches, strand the result count at `0/0` while navigation moves, and omit the final result post when the DOM changes during the walk. The issue asks for package-level hardening in `FIND_TEXT_HIGHLIGHT_JS_SOURCE`: deliver counts from `finally`, post unconditionally from `_findNext`, traverse shadow roots and same-origin iframes, and optionally rescan the active query after scrolling.

## Symptom

On a virtualized GitHub blob page, visible matches are missed and the Dart-side count can remain stale even though highlight navigation changes the active match. The expected behavior is a result post after every completed or failed walk and every navigation attempt, plus a fresh scan when scrolling mounts new content.

## Reproduction

1. Inject `FIND_TEXT_HIGHLIGHT_JS_SOURCE` into a DOM whose body contains searchable text.
2. Start `_findAllAsync(keyword)` and throw from a DOM operation after at least one highlight has been inserted; no `onFindResultReceived` message arrives on the current code.
3. Run `_findAllAsync` for multiple matches, remove one entry from `_highlightNodes`, and call `_findNext`; no result message arrives when the selected entry is missing.
4. Run a query, append newly mounted matching text, and dispatch `scrollend`; the active query is not rerun.

The issue also reports a jsdom reproduction against GitHub's 6,630-line `models.json` blob: only mounted rows are searched, while rendering the embedded `rawLines` restores the expected 350 `gemini` and 82 `openai` matches.

## Suspected Code Paths

- `zikzak_inappwebview_macos/macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/FindInteractionJS.swift:101` — `_findAllAsync` walks and posts without `try/finally`, so a mutation-time exception drops the only final count message.
- `zikzak_inappwebview_macos/macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/FindInteractionJS.swift:180` — `_findNext` returns without a post for zero matches and posts only inside `if (scrollTo)`, so a missing highlight strands the count.
- `zikzak_inappwebview_macos/macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/FindInteractionJS.swift:16` — the walker already descends into open shadow roots and same-origin iframe documents following #1155; this part of the report is already implemented and needs regression coverage rather than another implementation.
- `zikzak_inappwebview_macos/test/find_shadow_dom_contract_test.dart:51` — existing tests assert source shapes for nested-root traversal and final count fields but do not execute the injected JavaScript.

## Root Cause Hypothesis

High confidence: result delivery is coupled to successful control flow. `_findAllAsync` posts only after the walk returns normally, and `_findNext` posts only when the indexed highlight exists and is scrolled. Virtualization additionally mounts new rows without any active-query rescan, so the walker never revisits newly available text. The earlier #1155 change already solved nested-root discovery and highlight lookup, but not these delivery and rescan paths.

## Proposed Remediation

**Preferred**: Keep the existing nested-root walker. Wrap the `_findAllAsync` walk in `try/finally`, mark counting done and post the current count from the `finally`, and move `_findNext` result delivery outside the optional scroll branch (with a `finally` so navigation errors cannot suppress it). Store the normalized active keyword, install one capture-phase `scrollend` listener, debounce rescans, and cancel pending rescans when matches are cleared. Skip missing entries while updating highlight colors.

**Alternatives** (optional):

- Only add source-shape assertions for `finally` and unconditional posts. This is smaller but does not prove the injected script's observable bridge behavior.
- Poll the DOM on a timer. This would cover virtualization without relying on `scrollend` but adds continuous work and battery cost; a debounced event-driven rescan is preferable.

**Files likely to change**:

- `zikzak_inappwebview_macos/macos/zikzak_inappwebview_macos/Sources/zikzak_inappwebview_macos/FindInteractionJS.swift`
- `zikzak_inappwebview_macos/test/find_shadow_dom_contract_test.dart`
- `zikzak_inappwebview_macos/test/fixtures/find_interaction_harness.js`
- `.specify/bugs/macos-find-walker-rescan/` TDD and fix-report artifacts

**Tests to add or update**:

- Execute the exact extracted injected script in a small Node DOM harness and assert a final count post still arrives when the walk throws after a partial highlight.
- Assert `_findNext` posts the current counts when the active highlight is missing and when there are zero matches.
- Assert a debounced `scrollend` reruns the active query after new text mounts, and clearing matches cancels a pending rescan.
- Assert shadow-root and same-origin iframe text is found and cleared by the real script.

## Risks & Considerations

- Rescanning on every scroll can be expensive on large documents; debounce and run only while a non-empty query is active.
- A rescan resets the active ordinal. This matches a newly rebuilt highlight list and is preferable to retaining an index that may point at recycled content.
- Cross-origin iframes must remain inaccessible; only a non-null `contentDocument` may be traversed.
- The macOS Dart tests do not compile Swift. The changed Swift file must also be compiled through the macOS package/example build.

## Open Questions

None.
