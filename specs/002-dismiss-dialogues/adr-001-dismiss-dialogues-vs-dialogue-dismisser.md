# ADR 001 — `dismissDialogues` (brute-force) vs `DialogueDismisser` (content-aware)

- **Status:** Accepted
- **Date:** 2026-08-29
- **Spec:** 002-dismiss-dialogues
- **Supersedes:** none
- **Related:** `specs/002-dismiss-dialogues/tdd/test-list.md` "Critical finding" (divergence between the two implementations)

## Context

Spec 002 defines a single boolean `InAppWebViewSettings.dismissDialogues` (default
`false`) whose contract is, verbatim, to remove **all** `position: fixed` /
`position: sticky` elements when enabled (acceptance criteria SC-001..SC-005).

The repository ships **two** related-but-divergent implementations of "dialogue
dismissal":

1. **Inline brute-force** — `InAppWebView` (`lib/src/in_app_webview/in_app_webview.dart:337`)
   and `HeadlessInAppWebView` run a 3× retry loop in `onLoadStop` that removes every
   `fixed`/`sticky` element. This is what the `dismissDialogues` setting drives and
   what acceptance behaviors A1–A5 assert.
2. **`DialogueDismisser`** — `lib/src/dialogue_dismisser/` is a *content-aware* module
   that removes **only** overlays whose text matches keyword presets
   (cookie/gdpr/download/newsletter). It exposes the same wiring shape as the other
   optional feature modules — `DialogueDismisser.maybeCreate` → `mergeUserScripts` →
   `attach(controller)` — mirroring `NetworkCaptureManager` / `NavigationTracker`.

A grep across `lib/` confirms `DialogueDismisser.maybeCreate` / `.mergeUserScripts` /
`.attach` are **never called** from `InAppWebView` or `HeadlessInAppWebView`. The
module is fully implemented and self-tested (`test/dialogue_dismisser/…`, U1–U7) but
is **not wired** to any setting. Its class doc itself states it differs from the
legacy boolean "which removes EVERY `position: fixed/sticky` element".

## Decision

Keep **both**, but do **not** wire `DialogueDismisser` behind the existing
`dismissDialogues` boolean.

- `dismissDialogues` (inline brute-force) remains the **shipped, spec-compliant**
  behavior. It is the only implementation on the acceptance trace (A1–A5) and is the
  contract SC-002 enforces ("removes all fixed/sticky overlays"). It stays as-is.
- `DialogueDismisser` remains an **intentionally unwired, experimental module.**
  Wiring it behind `dismissDialogues` would violate SC-002: it is *content-aware*,
  so it would leave non-matching sticky/fixed elements (legitimate nav bars, price
  banners, chat widgets) in place — the opposite of the spec's "remove all" contract.

## Rationale

- The spec's acceptance criteria are met by implementation #1 today and are covered
  by passing integration tests on real WebViews (iOS sim, macOS, Android emulator).
- Implementation #2 is a *superset capability* (surgical dismissal) with a cleaner,
  composable architecture, but different semantics. Conflating it with the boolean
  would either break SC-002 or silently change the documented behavior.
- The module's wiring API already matches the established `maybeCreate` →
  `mergeUserScripts` → `attach` convention, so it can be promoted to a first-class
  feature with **zero architectural change** when a distinct setting is added.

## Consequences

- **Now:** no source change. `DialogueDismisser` stays unwired; its characterization
  tests (U1–U7) are recorded as `BASELINE` / out-of-trace in the TDD test list.
- **Future (optional):** expose content-aware dismissal through a *new, separate*
  setting (e.g. `dismissDialoguesMode: all | contentAware`) rather than overloading
  the existing boolean. At that point `DialogueDismisser.maybeCreate` is called in
  `InAppWebView`/`HeadlessInAppWebView` exactly where `NetworkCaptureManager` is
  today, and a new acceptance criterion is added to trace to it.
- The divergence between the spec's contract and the unwired module is preserved as
  an explicit finding in `tdd/test-list.md` and `tdd/verification.md` so the audit
  does not mistake U1–U7 for coverage of SC-001..SC-005.

## Alternatives considered

- **Wire `DialogueDismisser` behind `dismissDialogues` now.** Rejected: contradicts
  SC-002 ("removes all fixed/sticky overlays") and would regress A2/A4.
- **Delete `DialogueDismisser`.** Rejected: it is a working, tested, architecturally
  correct module that is the natural basis for a finer-grained future setting; its
  removal would discard reusable work.
- **Make `dismissDialogues` content-aware.** Rejected: changes the documented
  contract and the passing acceptance tests for no spec-driven benefit.
