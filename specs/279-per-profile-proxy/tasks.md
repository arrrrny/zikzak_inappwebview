# Tasks: Per-profile and global proxy support (spec 279)

Source: GitHub issue #279. One PR for the spec. TDD loop per
`.specify/extensions/tdd` (red → green → refactor → verify).

## Phase 1: Feature scaffold

- [X] T000 Create `zuraffa_browser` package skeleton (pubspec, analysis
      options, gitignore, library doc) + feature records (spec.md, plan.md,
      tasks.md, tdd/test-list.md, tdd/cycle-log.md baseline) and record the
      pre-existing suite baseline.

## Phase 2: T001 — Global proxy API (RED → GREEN)

- [X] T001a RED: `test/global_proxy_test.dart` + `test/proxy_config_test.dart`
      — global set/get/clear, persistence through the store, application
      through the applier; ProxyConfig value-object units (U1-U19).
- [X] T001b GREEN: `ProxyType`, `ProxyConfig`, `ProxyConfigRecord`,
      `ProxyConfigStore` (InMemory + File), `SecretVault` (InMemory),
      `ProxyApplier` port, `Browser.open/setProxy/clearProxy/proxy`.

## Phase 3: T002 — Per-profile proxy (RED → GREEN)

- [ ] T002a RED: `test/profile_proxy_test.dart` — per-profile override,
      fallback on remove, inheritance by profiles without explicit proxy,
      per-profile persistence (A2/A3/A8, U20-U25).
- [X] T002b GREEN: `Profile` (setProxy/clearProxy/proxy/effectiveProxy),
      `ProxyResolver` precedence, per-profile store records.

## Phase 4: T003 — Browser/Page programmatic API (RED → GREEN)

- [X] T003a RED: `test/page_api_test.dart` — page override precedence,
      page fallback, authenticated proxy vault flow, platform mapping
      (A5/A6, U26-U30).
- [X] T003b GREEN: `BrowserPage` (setProxy/clearProxy/effectiveProxy),
      `PageHost` port + fake factory, `proxySettingsFromConfig` pure mapping,
      `PlatformProxyApplier`, password vaulting on set.

## Phase 5: T004 — Lifecycle (RED → GREEN)

- [X] T004a RED: `test/lifecycle_test.dart` — apply-before-load ordering,
      not-retroactive (no applier call until next navigation), idempotent
      re-apply, direct-connection default, profile/browser dispose (A7,
      U31-U36).
- [X] T004b GREEN: navigate-time application, last-applied tracking,
      `Profile.dispose`, `Browser.dispose`, post-dispose guards.

## Phase 6: T005 — Refactor + verify

- [ ] T005a Refactor via tooling: `dart format .`, `flutter analyze` clean,
      no analyzer warnings in `zuraffa_browser`.
- [ ] T005b Full verification: `flutter analyze && flutter test` in
      `zikzak_inappwebview` and `zikzak_inappwebview_platform_interface`
      (NO NEW failures vs baseline), `dart format .` zero-diff in
      `zikzak_inappwebview`.
- [ ] T005c Update test-list states, cycle-log entries, README.

## Phase 7: Verify + PR

- [ ] T006 Run `/speckit.tdd.verify` (auditor protocol) → commit
      `specs/279-per-profile-proxy/tdd/verification.md` generated FRESH from
      this session's real run.
- [ ] T007 Push branch + open PR
      `spec(279): per-profile and global proxy support (closes #279)`.
