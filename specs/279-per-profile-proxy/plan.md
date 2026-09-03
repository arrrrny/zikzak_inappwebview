# Implementation Plan: Per-profile and global proxy support

**Feature Branch**: `spec/279-per-profile-proxy`
**Spec**: `specs/279-per-profile-proxy/spec.md`
**Input**: GitHub issue #279

## Approach

New sibling package `zuraffa_browser/` at the repo root (same layout convention
as `zikzak_inappwebview_module/`): a profile-isolated browser abstraction that
consumes only the plugin core's public API. The proxy feature is implemented
entirely at this layer, behind injectable ports so the full behavior suite runs
as plain unit tests without platform channels.

## Package layout

```
zuraffa_browser/
├── pubspec.yaml                    depends on zikzak_inappwebview (path)
├── analysis_options.yaml           flutter_lints, prefer_single_quotes
├── lib/
│   ├── zuraffa_browser.dart        public exports
│   └── src/
│       ├── proxy_config.dart       ProxyType, ProxyConfig, ProxyConfigRecord
│       ├── proxy_ports.dart        ProxyConfigStore (+InMemory/File),
│       │                           SecretVault (+InMemory), ProxyApplier
│       ├── proxy_resolver.dart     effective resolution + change detection
│       ├── platform_settings.dart  ProxyConfig -> ProxySettings mapping (pure)
│       ├── platform_proxy_applier.dart  ProxyApplier over ProxyController
│       ├── page_host.dart          PageHost port + HeadlessPageHost factory
│       ├── page.dart               BrowserPage (per-page override, navigate)
│       ├── profile.dart            Profile (per-profile proxy, pages, dispose)
│       └── browser.dart            Browser (global proxy, profiles, restore)
└── test/
    ├── proxy_config_test.dart      units U1-U14
    ├── global_proxy_test.dart      A1/A4/A5 units U17-U19
    ├── profile_proxy_test.dart     A2/A3/A8 units U20-U25
    ├── page_api_test.dart          A5/A6 units U26-U30
    └── lifecycle_test.dart         A7 lifecycle U31-U36
```

## Components and boundaries

### ProxyConfig (value object)

`host` (non-empty), `port` (1-65535), `type` (`http` | `https` | `socks5`),
optional `username`, transient `password`. `toProxyUrl()` renders
`[scheme://][user:pass@]host:port`. JSON serialization never includes the
password (`toJson` redacts; `toString` redacts). `ProxyConfigRecord` is the
persistable projection (adds `secretRef` for the vault key; no password).

### Ports (injectable, fakes in tests)

- `ProxyConfigStore` — load/save global + per-profile records; `null` record
  clears. `InMemoryProxyConfigStore` for tests; `FileProxyConfigStore` (JSON,
  injectable directory) as the default restart-survival implementation.
- `SecretVault` — `write/read/delete(key, secret)`. `InMemorySecretVault` for
  tests; production apps inject a keychain-backed implementation (FR-009).
- `ProxyApplier` — `apply(ResolvedProxy?)`; `null` means "clear override →
  direct connection". `PlatformProxyApplier` wraps
  `ProxyController.instance()` (`setProxyOverride` / `clearProxyOverride`)
  with `ProxySettings` built by the pure `proxySettingsFromConfig` mapping
  (`ProxyRule(url, schemeFilter)` for Android, `IOSProxySettings(proxyUrl)`
  for iOS).

### Resolution and lifecycle

`effective = page ?? profile ?? global ?? null` (FR-006, FR-010, FR-011).
The browser tracks the last-applied resolved proxy per scope; a navigation
applies the effective config through the `ProxyApplier` **before** `loadUrl`
only when it differs from the last-applied value (FR-007: not retroactive;
setProxy at profile/page level does not call the applier by itself). Global
`setProxy` applies immediately (process-wide platform semantics — future
connections of every profile), and every later navigation re-checks.

### Disposal

`Profile.dispose()` closes its pages, drops the profile from the live list,
and re-applies the fallback (global or direct) when the disposed profile's
proxy was the applied one (FR-008). `Browser.dispose()` disposes profiles and
the applier; post-dispose API calls throw `StateError`.

### Restart survival

`Browser.open({store, vault, applier, pageHostFactory})` is an async factory
that restores the global and per-profile records from the store before
returning (FR-002, FR-005). Passwords are re-resolved lazily from the vault at
apply time.

## Risks / trade-offs

- The platform override is process-wide; true per-WebView routing is out of
  scope (documented in spec). Per-profile isolation is enforced by applying
  the navigating scope's resolved proxy at navigation time.
- `FileProxyConfigStore` persists config JSON without passwords; the vault
  reference is a key only.
- SOCKS5 on iOS/WKWebView: passed through as `socks5://host:port` proxy URL;
  platform support may differ (documented in spec).

## Test strategy

All behaviors are unit-tested in `zuraffa_browser/test/` with inline fakes
(`RecordingProxyApplier`, fake `PageHost`), per the repo's tdd-profile
conventions (fakes defined inline per file). The pure
`proxySettingsFromConfig` mapping is tested against real platform_interface
value objects. Suite command: `flutter test` run inside `zuraffa_browser/`.
