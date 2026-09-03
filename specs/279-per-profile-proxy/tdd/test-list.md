---
feature: 279-per-profile-proxy
loop: inside-out
profile: .specify/memory/tdd-profile.md
spec_criteria: 8
planned_at: a841cee2
updated_at: a841cee2
suite_baseline: red
---

# Test List: Per-profile and global proxy support (zuraffa_browser)

`loop: inside-out` — the feature is a pure library with no user-visible
surface of its own; every behavior is exercised through the package's Dart
API with fakes at the ports (per the profile: fakes defined inline per file).

Baseline note: `suite_baseline: red` refers to the **other** packages'
pre-existing failures (umbrella `+240 -2`, platform_interface `+305 -1`,
recorded in `cycle-log.md`); the `zuraffa_browser` package itself starts
empty. Cycles run inside `zuraffa_browser/` only, and the loop does not start
on top of a red of its own.

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md`.

| id  | behavior                                                                 | traces          | kind      | state   | test                                                                        |
| --- | ------------------------------------------------------------------------ | --------------- | --------- | ------- | --------------------------------------------------------------------------- |
| A1  | Global proxy set via API, persisted, and applied to all profiles         | AC1, FR-001/002 | example   | RED | `test/global_proxy_test.dart::global proxy (AC1/FR-001) ...`                |
| A2  | Per-profile proxy overrides global for that profile only                 | AC2, FR-003     | example   | RED    | `test/profile_proxy_test.dart::per-profile proxy (AC2/FR-003) ...`          |
| A3  | Removing a per-profile proxy falls back to global (or direct)            | AC3, FR-004     | example   | RED    | `test/profile_proxy_test.dart::per-profile proxy (AC3/FR-004) ...`          |
| A4  | Proxy configuration survives app restart (global + per-profile)          | AC4, FR-002/005 | example   | PLANNED | `test/global_proxy_test.dart` + `test/profile_proxy_test.dart` restart tests |
| A5  | Authenticated proxies supported; password vaulted, never in plaintext    | AC5, FR-009     | example   | PLANNED | `test/page_api_test.dart::authenticated proxies (AC5/FR-009) ...`           |
| A6  | Programmatic set/clear/get on Browser and Page levels + page override    | AC6, FR-006     | example   | PLANNED | `test/page_api_test.dart::page-level override (AC6/FR-006) ...`             |
| A7  | No proxy anywhere = direct connection; first navigation clears override  | AC7, FR-010     | example   | PLANNED | `test/lifecycle_test.dart::direct connection default (AC7/FR-010)`          |
| A8  | Profiles without explicit proxy inherit the global proxy                 | AC8, FR-011     | example   | RED    | `test/profile_proxy_test.dart::inheritance (AC8/FR-011)`                    |

## Inner loop: unit behaviors

### `zuraffa_browser/lib/src/proxy_config.dart`

| id  | behavior                                                            | traces     | kind             | state   | test                                   |
| --- | ------------------------------------------------------------------- | ---------- | ---------------- | ------- | -------------------------------------- |
| U1  | toProxyUrl maps type http/https/socks5 to scheme://host:port        | FR-001     | characterization | GREEN | `test/proxy_config_test.dart`          |
| U2  | toProxyUrl embeds user:pass@ when credentials present               | FR-009     | characterization | GREEN | `test/proxy_config_test.dart`          |
| U3  | toProxyUrl omits @ when no credentials                              | FR-001     | characterization | GREEN | `test/proxy_config_test.dart`          |
| U4  | toJson/fromJson round-trip host, port, type, username               | FR-002     | characterization | GREEN | `test/proxy_config_test.dart`          |
| U5  | toJson never contains the password                                  | FR-009     | characterization | GREEN | `test/proxy_config_test.dart`          |
| U6  | toString redacts the password                                       | FR-009     | characterization | GREEN | `test/proxy_config_test.dart`          |
| U7  | equality on host/port/type; different port ≠                        | FR-003     | characterization | GREEN | `test/proxy_config_test.dart`          |
| U8  | invalid port (0, 65536) rejected; empty host rejected               | FR-001     | characterization | GREEN | `test/proxy_config_test.dart`          |
| U9  | ProxyConfigRecord round-trips through toJson/fromJson with secretRef | FR-009    | characterization | GREEN | `test/proxy_config_test.dart`          |
| U10 | ProxyType enum wire values are the lowercase scheme strings         | FR-001     | characterization | GREEN | `test/proxy_config_test.dart`          |

### `zuraffa_browser/lib/src/proxy_ports.dart`

| id  | behavior                                                            | traces     | kind             | state   | test                                   |
| --- | ------------------------------------------------------------------- | ---------- | ---------------- | ------- | -------------------------------------- |
| U11 | InMemoryProxyConfigStore saves/loads/clears the global record       | FR-002     | characterization | GREEN | `test/proxy_config_test.dart`          |
| U12 | InMemoryProxyConfigStore saves/loads/clears per-profile records     | FR-005     | characterization | GREEN | `test/proxy_config_test.dart`          |
| U13 | FileProxyConfigStore round-trips records through a JSON file        | FR-002/005 | characterization | GREEN | `test/proxy_config_test.dart`          |
| U14 | InMemorySecretVault write/read/delete round-trip                    | FR-009     | characterization | GREEN | `test/proxy_config_test.dart`          |

### `zuraffa_browser/lib/src/proxy_resolver.dart`

| id  | behavior                                                            | traces     | kind             | state   | test                                   |
| --- | ------------------------------------------------------------------- | ---------- | ---------------- | ------- | -------------------------------------- |
| U15 | effective = page ?? profile ?? global at each missing level         | FR-006/011 | characterization | PLANNED | `test/profile_proxy_test.dart`         |
| U16 | all levels null → null (direct connection)                          | FR-010     | characterization | PLANNED | `test/lifecycle_test.dart`             |

### `zuraffa_browser/lib/src/browser.dart`

| id  | behavior                                                            | traces     | kind             | state   | test                                   |
| --- | -------------------------------------------------------------------- | --------- | ---------------- | ------- | -------------------------------------- |
| U17 | setProxy stores the config and the getter returns it                | FR-001     | characterization | GREEN | `test/global_proxy_test.dart`          |
| U18 | clearProxy nulls the getter and removes the stored record           | FR-001     | characterization | GREEN | `test/global_proxy_test.dart`          |
| U19 | Browser.open over the same store restores the global proxy          | FR-002     | characterization | GREEN | `test/global_proxy_test.dart`          |
| U19b| Global setProxy applies the new config through the applier          | AC1        | characterization | GREEN | `test/global_proxy_test.dart`          |

### `zuraffa_browser/lib/src/profile.dart`

| id  | behavior                                                            | traces     | kind             | state   | test                                   |
| --- | -------------------------------------------------------------------- | --------- | ---------------- | ------- | -------------------------------------- |
| U20 | profile.setProxy sets the explicit proxy; getter returns it         | FR-003     | characterization | RED    | `test/profile_proxy_test.dart`         |
| U21 | effectiveProxy: explicit beats global; none → global; neither → null | FR-003/011 | characterization | RED    | `test/profile_proxy_test.dart`         |
| U22 | profile.clearProxy falls back to global; no global → null           | FR-004     | characterization | RED    | `test/profile_proxy_test.dart`         |
| U23 | Per-profile record is keyed by profileId (no cross-profile leak)    | FR-003     | characterization | RED    | `test/profile_proxy_test.dart`         |
| U24 | Browser.open restores per-profile records keyed by profile          | FR-005     | characterization | RED    | `test/profile_proxy_test.dart`         |
| U25 | Profiles created without proxy inherit global immediately           | FR-011     | characterization | RED    | `test/profile_proxy_test.dart`         |

### `zuraffa_browser/lib/src/page.dart`

| id  | behavior                                                            | traces     | kind             | state   | test                                   |
| --- | -------------------------------------------------------------------- | --------- | ---------------- | ------- | -------------------------------------- |
| U26 | page.setProxy sets the override; effective = page ?? profile.eff.   | FR-006     | characterization | PLANNED | `test/page_api_test.dart`              |
| U27 | page.clearProxyOverride falls back to profile/global                | FR-006     | characterization | PLANNED | `test/page_api_test.dart`              |
| U28 | Browser-level set/clear/get remains usable page-independently       | AC6        | characterization | PLANNED | `test/page_api_test.dart`              |
| U29 | setProxy with password routes password to vault; store record carries secretRef only; applier resolves password from vault | FR-009 | characterization | PLANNED | `test/page_api_test.dart`              |
| U30 | proxySettingsFromConfig builds Android rules + iOS proxyUrl per type | FR-012    | characterization | PLANNED | `test/page_api_test.dart`              |

### `zuraffa_browser/lib/src/browser.dart` (lifecycle)

| id  | behavior                                                            | traces     | kind             | state   | test                                   |
| --- | -------------------------------------------------------------------- | --------- | ---------------- | ------- | -------------------------------------- |
| U31 | navigate applies effective proxy BEFORE host.loadUrl                | FR-007     | characterization | PLANNED | `test/lifecycle_test.dart`             |
| U32 | profile/page setProxy does NOT call the applier until next navigate  | FR-007     | characterization | PLANNED | `test/lifecycle_test.dart`             |
| U33 | unchanged effective config → no redundant applier call              | FR-007     | characterization | PLANNED | `test/lifecycle_test.dart`             |
| U34 | no config anywhere → navigate applies clear (direct connection)     | FR-010     | characterization | PLANNED | `test/lifecycle_test.dart`             |
| U35 | Profile.dispose closes pages, drops profile, re-applies fallback    | FR-008     | characterization | PLANNED | `test/lifecycle_test.dart`             |
| U36 | Browser.dispose disposes applier; post-dispose API throws StateError | FR-008    | characterization | PLANNED | `test/lifecycle_test.dart`             |
