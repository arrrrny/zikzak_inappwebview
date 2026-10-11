---
feature: 008-vcr-record-replay
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 16
planned_at: f349d421
updated_at: f349d421
suite_baseline: green
---

# Test List: VCR Deterministic Record/Replay for HeadlessInAppWebView

> **Outer-only plan.** `plan.md` is absent for this feature, so the inner loop
> (unit behaviors `U*`) is skipped. The 16 acceptance behaviors below are derived
> from the 16 acceptance scenarios in `spec.md` (user stories 1–5, in spec order),
> each traced to a real `FR-*` / `SC-*` id. Unit behaviors, boundary thresholds,
> and characterization baselines will be added once `plan.md` exists. The Edge
> Cases section of `spec.md` is captured under "Invariants and edge cases still to
> place" for that later inner loop.
>
> **suite_baseline note:** recorded `green` for the default stack
> (`zikzak_inappwebview_platform_interface`, 300 passed). The feature wraps
> `HeadlessInAppWebView` (umbrella `zikzak_inappwebview`) and reuses cassette
> model types that live in `zikzak_inappwebview_module`; both those stacks are
> `blocked` by the zuraffa pub-cache corruption (`flutter pub cache repair`). VCR
> tests should run from the relevant package once that is fixed; the commands
> below are the profile's verified defaults.

## Outer loop: acceptance behaviors

One per acceptance criterion (acceptance scenario) in `spec.md`. Each stays red
until the feature works end to end through its real entry point — the VCR wrapper
around `HeadlessInAppWebView` driven in record or replay mode through its shared
public API.

| id  | behavior                                                                                                                              | traces        | kind    | state   | test |
| --- | ----------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------- | ------- | ---- |
| A1  | Recording a scripted navigation in record mode yields one cassette entry per navigation carrying that navigation's URL, served HTML, and cookie snapshot | FR-001, FR-002 | example | PENDING |      |
| A2  | Completing an XHR/fetch request in record mode appends a network-capture event (request headers/body and response headers/body) to the cassette | FR-002, FR-005 | example | PENDING |      |
| A3  | A completed recording is written as gzipped JSON that declares a format version                                                      | FR-003, FR-009 | example | PENDING |      |
| A4  | Replaying a cassette for URL U and calling `loadUrl(U)` returns U's recorded HTML via `loadData` with zero outbound network requests  | FR-001, FR-004 | example | PENDING |      |
| A5  | Replaying a recorded request surfaces a synthesized network-capture event identical to the recorded request/response/body            | FR-005        | example | PENDING |      |
| A6  | Calling `getHtml()` in replay returns the recorded HTML with no change to the consuming logic                                        | FR-004, FR-005 | example | PENDING |      |
| A7  | Replaying the same cassette 10 times yields identical `getHtml()` output and identical network-entry ordering on every run           | FR-006, SC-003 | example | PENDING |      |
| A8  | A replay request whose URL matches but whose normalized body differs resolves, with best-match enabled, to the closest recorded entry deterministically | FR-006        | example | PENDING |      |
| A9  | An unmatched replay request under the default hard policy fails with a clear error naming the unmatched key                          | FR-007        | example | PENDING |      |
| A10 | An unmatched replay request under a soft policy proceeds with a logged warning and an empty response instead of failing              | FR-007        | example | PENDING |      |
| A11 | A recorded request carrying an `Authorization` header has its header value scrubbed by the redaction hook before the cassette is written | FR-008, SC-002 | example | PENDING |      |
| A12 | Redaction redacts recorded cookie values from the cassette while retaining non-secret metadata (name, domain, flags)                | FR-008, SC-002 | example | PENDING |      |
| A13 | A custom redaction rule supplied to the wrapper is applied to matching headers/cookies before the cassette is written               | FR-008        | example | PENDING |      |
| A14 | Loading a cassette validates its declared format version against the supported version and rejects an incompatible version with a clear error | FR-009, SC-006 | example | PENDING |      |
| A15 | A captured response body exceeding the configured cap (default 50 KB) is written capped at that limit using the existing capture settings | FR-010, SC-005 | example | PENDING |      |
| A16 | A cassette smaller than the cap is written gzip-compressed and under a commit-friendly size threshold                                | FR-003, FR-010, SC-005 | example | PENDING |      |

## Inner loop: unit behaviors

**Skipped — `plan.md` is absent for this feature.** No component breakdown exists
yet, so unit behaviors (`U*`), boundary thresholds (both sides of the 50 KB cap,
hard/soft policy switch), specific error paths, and characterization baselines
are not listed here. They will be generated from `plan.md` by the inner loop once
it is written.

## Invariants and edge cases still to place

Belong to the feature but have no home component yet (await `plan.md` / inner
loop). Each must become a numbered behavior before the feature is done, or be
dropped with a reason.

- A URL navigated multiple times with different content stores per-navigation
  entries in sequence; matching uses the (URL, normalized request) key plus
  occurrence order so repeated loads resolve to the correct capture (FR-006).
- A recorded page issues requests not captured (unsupported scheme / skipped by
  capture settings): those become unmatched replay calls handled by the hard/soft
  policy (FR-007).
- Redaction disabled or a custom hook empty: the wrapper emits a warning or
  refuses to write to a commit path, configurable per environment (FR-008).
- Gzip decompression or JSON parsing fails: the loader rejects the cassette with a
  clear "corrupt/unsupported" error rather than partially loading it (FR-003,
  FR-009).
- Best-match fallback still finds nothing: the request falls through to the
  unmatched policy exactly as if no entry existed (FR-006, FR-007).
- An empty cassette (no navigations recorded): replay of any `loadUrl` is an
  unmatched hard failure by default (FR-007).
- A cassette recorded on one platform replays identically on any other supported
  platform (FR-011, SC-001).

## Out of scope

- Live webview traffic / real network during record: record runs against a real
  `HeadlessInAppWebView`; tests assert capture artifacts, not live fetches.
- Full (non-headless) `InAppWebView`: out of scope per spec assumptions — only
  `HeadlessInAppWebView` is in scope.
- The external `zfa agent replay` eval harness (zuraffa) and `dws_playground`
  scenario pack: named as intended downstream consumers but out of this module's
  scope.
- Committing the 3 example retailer cassettes under `test/fixtures/` (SC-004): a
  success criterion satisfied by running the record/replay tests, not a separate
  testable behavior in this list.

## Verification commands

Copied verbatim from `.specify/memory/tdd-profile.md` (default stack,
`zikzak_inappwebview_platform_interface`) at planning time. Run from the relevant
package directory (`zikzak_inappwebview_module` or `zikzak_inappwebview` once the
zuraffa cache is repaired; the command strings are identical across stacks):

- Single test: `flutter test --plain-name "{name}"`
- File: `flutter test {file}`
- Suite: `flutter test`
- Coverage: `flutter test --coverage`
