# Bug Spec: Reliable macOS find-in-page results on virtualized pages

## User story

As a user finding text in a long or dynamically rendered WebView page, I want the result count and highlight navigation to stay accurate when the DOM mutates or new rows mount, so the find navigator does not report stale `0/0` values or miss mounted matches.

## Acceptance criteria

### AC-1 — Count delivery survives a failed walk

If the DOM walk throws after inserting at least one highlight, `onFindResultReceived` still receives one final message with the partial `numberOfMatches` and `isDoneCounting: true` before the exception propagates.

### AC-2 — Missing active highlight does not suppress navigation counts

Given multiple matches and a missing entry in the tracked highlight list, `_findNext` updates the active ordinal and posts the current `numberOfMatches` without requiring the missing node to scroll.

### AC-3 — Zero-match navigation still reports counts

Given a completed search with zero matches, `_findNext` posts `activeMatchOrdinal: 0`, `numberOfMatches: 0`, and `isDoneCounting: true`.

### AC-4 — Newly mounted text is rescanned after scrolling

Given an active non-empty query, appending newly mounted matching text and dispatching `scrollend` causes no rerun before 150 ms after the latest event, then exactly one rerun whose final result count includes the new match.

### AC-5 — Clearing matches stops pending rescans

Given a pending debounced rescan, clearing matches cancels it; a later `scrollend` does not rerun the old query or post another result.

### AC-6 — Nested roots remain searchable

Text in an open shadow root and in a same-origin iframe document is found by the injected script, and rerunning a query clears the prior nested-root highlights.

## Functional requirements

- **FR-1**: `_findAllAsync` delivers its final result message from `finally`.
- **FR-2**: `_findNext` delivers a result message independently of whether a scroll target exists.
- **FR-3**: The normalized active query is retained for debounced `scrollend` rescans and cleared with the matches.
- **FR-4**: Open shadow roots and accessible same-origin iframe documents remain part of traversal and cleanup.
- **FR-5**: A rescan listener is installed once per injected script and does not access cross-origin frame documents.

## Out of scope

- Parsing GitHub's embedded `rawLines` hydration payload or virtualizing the page in the package.
- Changing `zuraffa_browser` count-readback reconciliation.
- Changing native WebKit find configuration or public Dart APIs.
- Changing empty-query semantics; callers already avoid starting an empty search.
- Dependency upgrades, version bumps, and generated code.
