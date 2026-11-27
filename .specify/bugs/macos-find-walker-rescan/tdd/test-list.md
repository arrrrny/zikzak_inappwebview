---
feature: macos-find-walker-rescan
loop: outside-in
profile: .specify/memory/tdd-profile.md
spec_criteria: 6
planned_at: 19b13d24
updated_at: d15341ea
suite_baseline: green
---

# Test List: Reliable macOS find-in-page results on virtualized pages

## Outer loop: acceptance behaviors

The real entry point is the exact JavaScript extracted from `FIND_TEXT_HIGHLIGHT_JS_SOURCE`, executed by the Node DOM harness from the macOS Flutter test suite. There is no separate `plan.md`; this bug uses the assessment as its implementation plan and an outer-only test list.

| id  | behavior                                                                                  | traces | kind             | state   | test                                                                                  |
| --- | ----------------------------------------------------------------------------------------- | ------ | ---------------- | ------- | -------------------------------------------------------------------------------------- |
| A1  | A walk that throws after a partial highlight still posts the final partial count as done  | AC-1   | example          | DONE | `test/find_shadow_dom_contract_test.dart::failed walks still post final counts`     |
| A2  | Navigation with a missing active highlight still posts the updated ordinal and count      | AC-2   | example          | PENDING | `test/find_shadow_dom_contract_test.dart::missing highlights still post navigation counts` |
| A3  | Navigation with zero matches posts an explicit zero-count result                           | AC-3   | example          | PENDING | `test/find_shadow_dom_contract_test.dart::zero-match navigation posts counts`        |
| A4  | A debounced scrollend rerun includes text mounted after the active query started          | AC-4   | example          | PENDING | `test/find_shadow_dom_contract_test.dart::scrollend rescans newly mounted matches`   |
| A5  | Clearing matches cancels a pending rescan and prevents old-query result posts             | AC-5   | example          | PENDING | `test/find_shadow_dom_contract_test.dart::clearing matches cancels pending rescans`  |
| A6  | Open shadow-root and same-origin iframe text is found and cleared by the injected script   | AC-6   | characterization | BASELINE | `test/find_shadow_dom_contract_test.dart::nested roots are searched and cleared`     |

## Inner loop: unit behaviors

None. The acceptance behaviors exercise the injected script directly; no lower-level component plan exists for this bug.

## Invariants and edge cases still to place

- Cross-origin iframe access remains a safe no-op because `contentDocument` is null; covered by the existing source contract and not expanded into a new behavior in this fix.
- A missing highlight is skipped while peer highlight colors update, so one recycled node cannot suppress the navigation result post.

## Out of scope

- GitHub `rawLines` payload parsing and consumer-side count reconciliation.
- Empty-query behavior, native WebKit configuration, public Dart API changes, dependency upgrades, and version bumps.

## Verification commands

- Single test: `flutter test test/find_shadow_dom_contract_test.dart --plain-name "<name>" --concurrency=2`
- Full suite: `flutter test --concurrency=2`
- Coverage: `flutter test --coverage --concurrency=2`
- Mutation: no mutation tool is recorded; use deliberate mutants on A1, A2, A4, and the A6 characterization baseline.
