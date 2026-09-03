# zuraffa_browser

Profile-isolated browser abstraction for
[zikzak_inappwebview](../zikzak_inappwebview) — per-profile and global proxy
support (spec 279,
[issue #279](https://github.com/arrrrny/zikzak_inappwebview/issues/279)).

The package layers a `Browser / Profile / Page` API on top of the plugin
core's public surface and adds **network-level isolation** to session-level
isolation:

- **Global proxy** — one proxy (host, port, HTTP/HTTPS/SOCKS5, optional
  username/password) shared by all profiles; persisted across restarts;
  set/change/clear programmatically.
- **Per-profile proxy** — each profile may carry its own proxy; it overrides
  the global proxy for that profile only; removing it falls back to the
  global proxy (or direct connection); persisted with the profile.
- **Per-page override** — a one-off, non-persisted override for single pages
  (wins over profile and global for that page only).
- **Lifecycle** — changes are never retroactive: the effective proxy
  (`page ?? profile ?? global ?? direct`) is applied through the platform
  proxy infrastructure right BEFORE the next navigation, and only when it
  differs from what is currently applied. Disposing a profile releases its
  proxy resources (falls back to global/direct).
- **Secrets** — passwords are never persisted in plaintext: the config store
  persists a secret reference; the password lives in an injectable
  `SecretVault` (in production, inject an OS-keychain / secure-storage
  implementation).

## Quick start

```dart
import 'package:zuraffa_browser/zuraffa_browser.dart';

final browser = await Browser.open(
  store: FileProxyConfigStore(file: supportDir / 'proxy_config.json'),
  vault: MyKeychainVault(),                       // or InMemorySecretVault()
  applier: PlatformProxyApplier(),                // wraps ProxyController
);

// Global proxy — all profiles.
await browser.setProxy(ProxyConfig(
  host: 'proxy.example.com', port: 8080, type: ProxyType.http,
));

// Per-profile proxy — overrides the global proxy for this profile only.
final work = browser.createProfile('work');
await work.setProxy(ProxyConfig(
  host: 'gate.example.com', port: 3128, type: ProxyType.https,
  username: 'alice', password: '…',               // password goes to the vault
));

// Per-page override — one-off, not persisted.
final page = work.openPage();
await page.setProxy(ProxyConfig(
  host: 'socks.example.com', port: 1080, type: ProxyType.socks5,
));
await page.navigate(WebUri('https://example.com/'));

await work.dispose();   // closes pages, releases proxy resources
await browser.dispose();
```

## Resolution order

`effective = page override ?? profile proxy ?? global proxy ?? direct`

No configuration anywhere means a direct connection; the first navigation
establishes that explicitly.

## Platform notes

- The underlying `ProxyController` override is **process-wide** (androidx
  webkit on Android, iOS 17+ proxy configuration). Per-profile isolation is
  enforced at this layer: each navigation applies the navigating scope's
  resolved proxy before loading.
- `ProxySchemeFilter` has no SOCKS entry; SOCKS5 rules carry the scheme in
  the rule URL.
- WKWebView does not natively support SOCKS5 — the proxy URL is passed
  through as-is; platform support may differ.

## Tests

```bash
cd zuraffa_browser && flutter test
```

44 tests cover the full behavior matrix (TDD evidence:
`../specs/279-per-profile-proxy/tdd/`).
