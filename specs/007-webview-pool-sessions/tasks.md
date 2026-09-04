# Tasks: WebViewPool — Mission-Scoped Sessions, Domain Affinity, and Memory-Pressure Disposal

## Phase 0: Setup

- [ ] T001: Create feature directory structure for WebViewPool module
- [ ] T002: Add WebViewPool to public API exports (lib/src/main.dart)

## Phase 1: Core WebViewPool Implementation

### A1: Acquire for new session creates instance, liveCount = 1
- [ ] T003 [A1]: **Test** - Write acceptance test for A1: acquire new session creates instance, liveCount = 1
- [ ] T004 [A1]: **Implement** - Implement acquire() to create HeadlessInAppWebView for new sessionId

### A2: Re-acquire same sessionId returns same instance
- [ ] T005 [A2]: **Test** - Write acceptance test for A2: re-acquire same sessionId returns same instance
- [ ] T006 [A2]: **Implement** - Implement sessionId tracking to return existing live instance

### A3: Release returns instance to idle, updates liveCount
- [ ] T007 [A3]: **Test** - Write acceptance test for A3: release moves to idle, updates liveCount
- [ ] T008 [A3]: **Implement** - Implement release() to move instance from live to idle pool

### A4: disposeAll disposes all instances, liveCount = 0
- [ ] T009 [A4]: **Test** - Write acceptance test for A4: disposeAll clears all pools
- [ ] T010 [A4]: **Implement** - Implement disposeAll() to dispose all live and idle instances

### U1: Singleton instance consistency
- [ ] T011 [U1]: **Test** - Write unit test for singleton pattern
- [ ] T012 [U1]: **Implement** - Implement WebViewPool as singleton

### U2: acquire() composes settings onto defaults
- [ ] T013 [U2]: **Test** - Write unit test for settings composition
- [ ] T014 [U2]: **Implement** - Implement InAppWebViewSettings merging in acquire()

### U3: acquire() returns existing live instance for same sessionId
- [ ] T015 [U3]: **Test** - Write unit test for sessionId deduplication
- [ ] T016 [U3]: **Implement** - Implement live session tracking map

### U4: release() moves instance live → idle; sessions() updated
- [ ] T017 [U4]: **Test** - Write unit test for release state transition
- [ ] T018 [U4]: **Implement** - Implement live→idle transition and sessions() snapshot

### U5: disposeAll() disposes all and clears pools
- [ ] T019 [U5]: **Test** - Write unit test for disposeAll behavior
- [ ] T020 [U5]: **Implement** - Implement full pool disposal

### U9: sessions() returns snapshot with sessionId, domain, status
- [ ] T021 [U9]: **Test** - Write unit test for sessions() introspection
- [ ] T022 [U9]: **Implement** - Implement sessions() returning consistent snapshot

### U10: liveCount equals live + idle count
- [ ] T023 [U10]: **Test** - Write unit test for liveCount accuracy
- [ ] T024 [U10]: **Implement** - Implement liveCount getter

## Phase 2: Domain Affinity

### A5: Affine acquire reuses warm idle instance (affinity hit)
- [ ] T025 [A5]: **Test** - Write acceptance test for A5: same eTLD+1 reuses warm instance
- [ ] T026 [A5]: **Implement** - Implement domain affinity selection logic

### A6: Affine re-acquisition preserves cookie/JS state
- [ ] T027 [A6]: **Test** - Write acceptance test for A6: state preservation across affine acquire
- [ ] T028 [A6]: **Implement** - Ensure instance state persists across affine reuse

### A7: Non-affine acquire reuses generic idle or creates new
- [ ] T029 [A7]: **Test** - Write acceptance test for A7: non-affine falls back to generic idle
- [ ] T030 [A7]: **Implement** - Implement generic idle fallback logic

### A8: sessions() reports eTLD+1 domain association
- [ ] T031 [A8]: **Test** - Write acceptance test for A8: sessions() includes domain
- [ ] T032 [A8]: **Implement** - Track and report domainHint in sessions()

### U6: Domain affinity selects matching eTLD+1 over generic idle
- [ ] T033 [U6]: **Test** - Write unit test for affinity selection priority
- [ ] T034 [U6]: **Implement** - Implement eTLD+1 affinity matching

### U7: Affine instance retains state for subsequent acquires
- [ ] T035 [U7]: **Test** - Write unit test for state retention
- [ ] T036 [U7]: **Implement** - Ensure instance not reset on affine reuse

### U8: Non-affine acquire re-scopes generic idle to new domain
- [ ] T037 [U8]: **Test** - Write unit test for generic re-scoping
- [ ] T038 [U8]: **Implement** - Implement domain re-scoping on acquire

### U27-U31: eTLD+1 extraction
- [ ] T039 [U27-U31]: **Test** - Write unit tests for eTLD+1 extraction (standard, IP, localhost, multi-part TLD, unknown)
- [ ] T040 [U27-U31]: **Implement** - Implement eTLD+1 extraction utility

## Phase 3: Caps, TTL, and Memory Pressure

### A9: Idle TTL eviction disposes idle instances
- [ ] T041 [A9]: **Test** - Write acceptance test for A9: TTL eviction reduces liveCount
- [ ] T042 [A9]: **Implement** - Implement idle TTL sweep timer

### A10: Max-per-domain cap evicts oldest idle same-domain
- [ ] T043 [A10]: **Test** - Write acceptance test for A10: per-domain cap enforcement
- [ ] T044 [A10]: **Implement** - Implement per-domain cap with LRU eviction

### A11: Memory-pressure disposes idle first, spares active
- [ ] T045 [A11]: **Test** - Write acceptance test for A11: lifecycle event disposes idle only
- [ ] T046 [A11]: **Implement** - Implement AppLifecycleListener hook for memory pressure

### A12: Platform-aware defaults apply correct max-live per platform
- [ ] T047 [A12]: **Test** - Write acceptance test for A12: platform defaults
- [ ] T048 [A12]: **Implement** - Implement platform-aware default configuration

### U11: Idle TTL sweep disposes expired idle; timer resets on activity
- [ ] T049 [U11]: **Test** - Write unit test for TTL sweep behavior
- [ ] T050 [U11]: **Implement** - Implement periodic TTL sweep with activity reset

### U12: Max-per-domain cap with LRU eviction
- [ ] T051 [U12]: **Test** - Write unit test for per-domain LRU
- [ ] T052 [U12]: **Implement** - Implement per-domain instance tracking with LRU

### U13: Max-live cap blocks or evicts per policy
- [ ] T053 [U13]: **Test** - Write unit test for max-live enforcement
- [ ] T054 [U13]: **Implement** - Implement max-live cap enforcement

### U14: AppLifecycleListener on pause/memory pressure disposes idle first
- [ ] T055 [U14]: **Test** - Write unit test for lifecycle hook behavior
- [ ] T056 [U14]: **Implement** - Implement lifecycle listener registration and callback

### U15: Platform-aware defaults: iOS/Android lower; desktop/web higher
- [ ] T057 [U15]: **Test** - Write unit test for platform defaults
- [ ] T058 [U15]: **Implement** - Implement platform detection and default config

## Phase 4: Concurrency Safety

### A13: Concurrent acquires same sessionId → exactly one instance
- [ ] T059 [A13]: **Test** - Write acceptance test for A13: concurrent same-session acquire
- [ ] T060 [A13]: **Implement** - Implement locking for same sessionId acquire

### A14: Concurrent distinct sessions → liveCount = M, no aliasing
- [ ] T061 [A14]: **Test** - Write acceptance test for A14: concurrent distinct sessions
- [ ] T062 [A14]: **Implement** - Implement fine-grained locking across sessions

### A15: High-contention burst no exception/deadlock; introspection consistent
- [ ] T063 [A15]: **Test** - Write acceptance test for A15: contention stress test
- [ ] T064 [A15]: **Implement** - Ensure lock ordering and consistency

### U16: Concurrent acquire same sessionId uses locking to prevent duplicates
- [ ] T065 [U16]: **Test** - Write unit test for acquire locking
- [ ] T066 [U16]: **Implement** - Implement per-sessionId lock

### U17: Concurrent acquire/release distinct sessions uses fine-grained locking
- [ ] T067 [U17]: **Test** - Write unit test for cross-session locking
- [ ] T068 [U17]: **Implement** - Implement lock striping or per-session locks

### U18: Introspection thread-safe, returns consistent snapshot
- [ ] T069 [U18]: **Test** - Write unit test for thread-safe introspection
- [ ] T070 [U18]: **Implement** - Implement synchronized snapshot reads

## Phase 5: Per-Acquisition Configuration

### A16: Per-acquisition settings applied to instance only (no bleed)
- [ ] T071 [A16]: **Test** - Write acceptance test for A16: settings isolation
- [ ] T072 [A16]: **Implement** - Implement per-instance settings application

### A17: Different sessions retain own configuration
- [ ] T073 [A17]: **Test** - Write acceptance test for A17: settings don't bleed
- [ ] T074 [A17]: **Implement** - Ensure independent settings per instance

### A18: No settings override uses pool default base config
- [ ] T075 [A18]: **Test** - Write acceptance test for A18: default config fallback
- [ ] T076 [A18]: **Implement** - Implement default base configuration

### U19: acquire() merges caller settings onto pool defaults per-instance
- [ ] T077 [U19]: **Test** - Write unit test for settings merge
- [ ] T078 [U19]: **Implement** - Implement settings composition logic

### U20: Settings not shared across sessions; independent config
- [ ] T079 [U20]: **Test** - Write unit test for settings independence
- [ ] T080 [U20]: **Implement** - Ensure each instance has own settings copy

### U21: Null settings uses pool default base configuration
- [ ] T081 [U21]: **Test** - Write unit test for null settings fallback
- [ ] T082 [U21]: **Implement** - Handle null settings in acquire()

## Phase 6: Edge Cases and Robustness

### A19: Acquire after disposeAll creates fresh instance
- [ ] T083 [A19]: **Test** - Write acceptance test for A19: post-disposeAll acquire
- [ ] T084 [A19]: **Implement** - Ensure disposeAll fully resets pool state

### A20: Release unknown sessionId is safe no-op
- [ ] T085 [A20]: **Test** - Write acceptance test for A20: unknown release no-op
- [ ] T086 [A20]: **Implement** - Implement safe no-op for unknown sessionId

### U22: release() unknown sessionId no-op, no exception
- [ ] T087 [U22]: **Test** - Write unit test for unknown release
- [ ] T088 [U22]: **Implement** - Add guard for unknown sessionId

### U23: disposeAll() on disposed pool no-op; fresh acquire works
- [ ] T089 [U23]: **Test** - Write unit test for double disposeAll
- [ ] T090 [U23]: **Implement** - Make disposeAll idempotent

### U24: eTLD+1 handles IP, localhost, multi-part TLDs without throwing
- [ ] T091 [U24]: **Test** - Write unit test for edge case domain hints
- [ ] T092 [U24]: **Implement** - Robust eTLD+1 extraction with fallbacks

### U25: Domain hint omitted/null = generic non-affine acquisition
- [ ] T093 [U25]: **Test** - Write unit test for null domain hint
- [ ] T094 [U25]: **Implement** - Treat null/omitted hint as generic

### U26: Memory-pressure hook no-op on platforms without signal; caps/TTL apply
- [ ] T095 [U26]: **Test** - Write unit test for no-op lifecycle on unsupported platforms
- [ ] T096 [U26]: **Implement** - Graceful degradation for missing lifecycle signal

## Phase 7: Documentation and Public API

### SC-008: Public API consumable without MCP/zuraffa; documented with example
- [ ] T097: **Test** - Verify public API exports compile without MCP/zuraffa deps
- [ ] T098: **Implement** - Add WebViewPool to public exports
- [ ] T099: **Document** - Write API documentation for WebViewPool
- [ ] T100: **Example** - Add example app section demonstrating manual pool usage

## Phase 8: Success Criteria Verification

- [ ] T101 [SC-001]: **Test** - 20-mission simulated run: liveCount == 0 after all release/disposeAll
- [ ] T102 [SC-002]: **Test** - ≥10 concurrent acquires same sessionId → exactly 1 instance
- [ ] T103 [SC-003]: **Test** - Affine re-acquisition preserves cookie/JS state artifact
- [ ] T104 [SC-004]: **Test** - TTL eviction and memory-pressure disposal verified
- [ ] T105 [SC-005]: **Test** - Caps never exceeded under burst acquisition
- [ ] T106 [SC-006]: **Test** - Introspection consistent under concurrent mutations
- [ ] T107 [SC-007]: **Test** - Settings isolation verified across sessions
- [ ] T108 [SC-008]: **Verify** - Public API compiles and documented

## Notes

- Tests are **mandatory** and must be observed failing (red) before implementation (green).
- Each behavioral task carries a marker like `[A1]` or `[U1]` linking it to the test list.
- Outer-loop acceptance tests (A1–A20) must pass through the real public API entry point.
- Inner-loop unit tests (U1–U31) test component behaviors in isolation.
- Characterization tests (BASELINE) are not needed for this feature as it is greenfield.
- The two pre-existing compile-broken test files (`headless_dispose_test.dart`, `webview_sessions_test.dart`) are NOT this feature's responsibility and must be resolved separately.