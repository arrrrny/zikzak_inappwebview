# Feature Specification: Per-profile and global proxy support (zuraffa_browser)

**Feature Branch**: `spec/279-per-profile-proxy`
**Feature Directory**: `specs/279-per-profile-proxy`
**Created**: 2026-09-03
**Status**: In progress
**Input**: GitHub issue #279 — "Feature: Per-profile and global proxy support" (https://github.com/arrrrny/zikzak_inappwebview/issues/279), read as the sole spec input.

## Summary

Add proxy support to `zuraffa_browser` at two levels: a **global proxy** (all
profiles share one proxy configuration) and **per-profile proxies** (each
profile routes through its own proxy, isolating network identity alongside
session data). Configuration is exposed programmatically on the Browser /
Profile / Page API (`setProxy`, `clearProxy`, getters), persists across app
restarts, and takes effect on the next navigation/launch. The browser layer
resolves the effective proxy per navigation (page override > per-profile >
global > direct) and applies it through zikzak_inappwebview's existing proxy
infrastructure (`ProxyController` / `PlatformProxyController`, `ProxyRule`,
`ProxySettings`).

## Problem

Automation workloads and multi-account use cases commonly need network-level
isolation or routing that the current in-app WebView provides no control over:

- **Scraping / automation through specific IPs** — rotate or pin exit IPs
  without leaving the app.
- **Geo-restricted content** — access region-locked pages from a specific
  profile via a geo-proxied endpoint.
- **Privacy / multi-account isolation** — separate the network identity
  (source IP, DNS) of each profile so that session isolation (cookies /
  localStorage) is complemented by transport isolation.
- **Corporate proxy requirements** — enterprise deployments where all traffic
  must traverse an authenticated proxy.

The underlying zikzak_inappwebview platform already exposes proxy
infrastructure (`ProxyManager`, `PlatformProxyController`, `ProxyRule`) but
the browser layer does not use any of it.

## User Scenarios & Testing

### User Story 1 — Global proxy (P1)

As a developer, I set one proxy for the whole browser; every profile's traffic
exits through it, it survives an app restart, and I can clear it.

**Acceptance Scenarios**:
1. **Given** a fresh browser, **When** `browser.setProxy(config)` is called,
   **Then** `browser.proxy` returns the config, the config is persisted, and
   the next navigation in any profile is routed through it.
2. **Given** a set global proxy, **When** the app restarts (a new `Browser`
   over the same store), **Then** the global proxy is restored.
3. **Given** a set global proxy, **When** `browser.clearProxy()` is called,
   **Then** `browser.proxy` is null, the persisted record is removed, and
   navigations fall back to direct connection.

### User Story 2 — Per-profile proxy (P1)

As a developer with multiple profiles, I assign each profile its own proxy; it
overrides the global proxy for that profile only, and removing it falls back
to the global proxy (or direct connection).

**Acceptance Scenarios**:
1. **Given** a global proxy and a profile with its own proxy, **When** the
   profile's page navigates, **Then** the profile proxy applies, and other
   profiles still use the global proxy.
2. **Given** a profile proxy, **When** `profile.clearProxy()` is called,
   **Then** the profile falls back to the global proxy (or direct connection
   if none).
3. **Given** a profile proxy, **When** the app restarts, **Then** the
   per-profile proxy is restored with the profile.
4. **Given** a profile without an explicit proxy, **Then** it inherits the
   global proxy.

### User Story 3 — Programmatic API (P1)

As a developer, I configure proxies entirely programmatically: on the Browser
(set/clear/get), on a Profile, and as a one-off override on a single Page.

**Acceptance Scenarios**:
1. **Given** a page with a proxy override, **When** it navigates, **Then**
   the page override wins over the profile and global configuration for that
   navigation only.
2. **Given** a page override cleared, **When** it navigates, **Then** the
   profile (or global) configuration applies again.

### User Story 4 — Lifecycle (P2)

As a developer, I expect proxy changes to affect the next navigation/launch
(never the already-loaded page), and disposing a profile to release its
proxy-related resources.

**Acceptance Scenarios**:
1. **Given** a page already loaded, **When** any proxy is set or changed,
   **Then** the loaded page is untouched and the change applies from the next
   navigation onward.
2. **Given** a profile with a proxy, **When** `profile.dispose()` is called,
   **Then** its pages are closed and the applied proxy state is released
   (falls back to the global proxy or direct connection).

## Requirements

- **FR-001**: The browser MUST support a global proxy configuration (host,
  port, type HTTP/HTTPS/SOCKS5, optional username/password) settable,
  changeable, clearable, and readable programmatically.
- **FR-002**: The global proxy MUST persist across app restarts.
- **FR-003**: Each profile MAY have its own proxy configuration; a per-profile
  proxy MUST override the global proxy for that profile only.
- **FR-004**: Removing a per-profile proxy MUST fall back to the global proxy
  (or direct connection when no global proxy is set).
- **FR-005**: Per-profile proxies MUST be persisted with the profile across
  restarts.
- **FR-006**: Proxy configuration MUST be exposed programmatically on the
  Browser / Profile / Page levels, including a per-page override for one-off
  requests (page override > profile > global).
- **FR-007**: Proxy changes MUST take effect on the next navigation/launch;
  they MUST NOT retroactively affect an already-loaded page.
- **FR-008**: Disposing a profile MUST release its proxy-related resources.
- **FR-009**: Authenticated proxies (username/password) MUST be supported;
  passwords MUST NOT be persisted in plaintext — they go through an injectable
  secret vault port (OS keychain / secure storage in production apps).
- **FR-010**: With no configuration at any level, the effective behavior MUST
  be a direct connection (no proxy).
- **FR-011**: Existing profiles without an explicit proxy MUST inherit the
  global proxy.
- **FR-012**: Application of the resolved proxy MUST go through
  zikzak_inappwebview's proxy infrastructure (`ProxyController` /
  `ProxySettings` / `ProxyRule`) behind an injectable port so unit tests can
  run without platform channels.

## Acceptance Criteria

- [ ] AC1: Global proxy can be set via API, persisted, and applied to all profiles
- [ ] AC2: Per-profile proxy overrides global for that profile only
- [ ] AC3: Removing a per-profile proxy falls back to global
- [ ] AC4: Proxy configuration survives app restart
- [ ] AC5: Authenticated proxies are supported (username/password)
- [ ] AC6: Programmatic set/clear/get on Browser and Page levels
- [ ] AC7: No proxy (direct connection) is the default when none is configured
- [ ] AC8: Existing profiles without explicit proxy inherit the global proxy

## Technical Considerations

- zikzak_inappwebview already has `ProxyManager` + `PlatformProxyController`
  infrastructure on iOS 17+/macOS and Android (`ProxyController` over
  androidx.webkit). The platform override is **process-wide**; per-profile
  isolation is enforced at the browser layer by resolving and applying the
  effective proxy at navigation time (FR-007), and documented as such.
- Proxy config is profile-scoped, not page-scoped; the per-page override is a
  one-off that resolves on top of the profile scope.
- Passwords are never persisted in plaintext: the config store persists a
  secret reference; the vault port resolves it at apply time. The default
  in-memory vault is for tests; apps inject a keychain-backed implementation.
- WKWebView does not natively support SOCKS5; the SOCKS5 mapping is passed to
  the platform proxy URL as-is and platform support may differ.

## Out of scope (v1)

- Per-WebView-instance proxy routing on platforms that only expose a
  process-wide override.
- PAC (proxy auto-config) scripts and proxy rotation strategies.
- Capturing/changing proxy per sub-resource request.
