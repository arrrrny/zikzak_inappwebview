# AGENTS.md — ZikZak InAppWebView

**Audience:** AI coding agents. This file assumes you know nothing about the repository. Read it before editing code.

---

## ⚠️ LANGUAGE RULE — MANDATORY

**ALL responses (chat, commit messages, PR descriptions, docs) MUST be in English ONLY.** Never respond in Turkish, Chinese, or any other language, regardless of the user's locale or non-English content in the codebase. Hard rule, no exceptions.

---

## 🔍 Code Search — MANDATORY FIRST STEP

**STOP. Before using `grep`, `find`, `rg`, `ripgrep`, or any shell-based search, use semantic search first.**

```bash
mcp__claude_context__search_code(query="what you're looking for", path="/Users/ahmettok/Developer/zikzak_inappwebview")
```

**Why:** Semantic search understands code relationships and catches things grep misses.

**Rules:**
1. ALWAYS start with `mcp__claude_context__search_code` for code discovery.
2. ONLY fall back to `Grep`/`rg` when you need an exact literal string, an unindexed path, or a filename (not content).
3. NEVER use grep as your first code search tool.

**Indexing:** If search fails with "not indexed", run `mcp__claude_context__index_codebase(path="/Users/ahmettok/Developer/zikzak_inappwebview")` first, then retry.

---

## 📚 Zread Wiki — Check Before Crawling Source

The `zread` CLI is installed (`/usr/local/bin/zread`), but **this repo currently has no `.zread/` wiki** (checked 2026-08-31). If one is generated later, read it before crawling source files.

```bash
cat .zread/wiki/current 2>/dev/null && echo "Wiki exists" || echo "No wiki"
ls .zread/wiki/versions/$(cat .zread/wiki/current)/    # pages; wiki.json holds the TOC
zread generate --stdio                                  # (re)generate
```

---

## 📦 Project Overview

`zikzak_inappwebview` is a **Flutter plugin** (a community fork of `flutter_inappwebview`, API-equivalent to upstream 6.x, published as fork version 4.x/5.x) that provides an inline WebView, a headless WebView, and an in-app browser window across **6 platforms**: Android, iOS, macOS, Web, Windows, Linux.

It is a **Dart/Flutter monorepo** made of **9 independent pub packages** that form one federated plugin. It is NOT a single app. The `zikzak_inappwebview` package is the "umbrella" / app-facing package; the rest are platform implementations plus a shared platform-interface package.

- **License:** Apache License 2.0 (see `LICENSE`). Dart source files do NOT carry per-file Apache headers — don't add them.
- **Homepage / docs:** https://arrrrny.github.io/zikzak_inappwebview
- **Pub:** https://pub.dev/packages/zikzak_inappwebview
- **SDK floor (all packages):** `sdk: >=3.8.0 <4.0.0`, `flutter: >=3.38.6`. Installed toolchain on this machine: Flutter 3.47.1 / Dart 3.13.1.

### The JavaScript bridge global

The injected JS bridge global is **`window.zikzak_inappwebview`** (NOT `window.flutter_inappwebview`). After migrating from upstream, JS calls handlers via `window.zikzak_inappwebview.callHandler(...)`. The `flutterInAppWebViewPlatformReady` event name is unchanged. The native bridge name constant is `JAVASCRIPT_BRIDGE_NAME = "zikzak_inappwebview"` (e.g. `zikzak_inappwebview_android/.../plugin_scripts_js/JavaScriptBridgeJS.java`).

---

## 🗂️ Repository Layout

```
zikzak_inappwebview/                 # UMBRELLA package (app-facing; version 5.0.0)
  lib/
    zikzak_inappwebview.dart        # public barrel: re-exports platform_interface + src/main.dart (+ webview_sessions)
    src/
      in_app_webview/               # InAppWebView widget, InAppWebViewController, HeadlessInAppWebView, controllers/, network_capture/, android/, apple/
      in_app_browser/               # InAppBrowser widget
      chrome_safari_browser/        # ChromeSafariBrowser (custom tabs)
      web_storage/ cookie_manager.dart proxy_controller.dart tracing_controller.dart
      service_worker_controller.dart process_global_config.dart webview_environment/
      navigation_tracker/ session_recipe/ dialogue_dismisser/ webview_sessions/ ...
  test/                             # unit/behavioral tests (run headless; no device needed)
  example/                          # example app; holds integration_test/ (E2E on device/simulator)
  .gym/                             # GYM exercises (see Development Conventions)

zikzak_inappwebview_platform_interface/   # shared abstract interface (version 5.1.2) — 449 Dart files
  lib/src/inappwebview_platform.dart      # InAppWebViewPlatform + all PlatformXxx abstract facades
  lib/src/domain/entities/                # 97 Zorphy-generated model families (cookie/, ajax_request/, ...)

zikzak_inappwebview_android/        # Android impl — Java (159 files) under android/src/main/java/wtf/zikzak/...
zikzak_inappwebview_ios/            # iOS impl — Swift (141 files) under ios/ (Swift Package Manager; Package.swift present)
zikzak_inappwebview_macos/          # macOS impl — Swift (70 files) under macos/ (Package.swift present)
zikzak_inappwebview_web/            # Web impl — pure Dart using `dart:js_interop` / `package:web` (no native code)
zikzak_inappwebview_windows/        # Windows impl — Dart facade over `webview_windows` package (no own native code)
zikzak_inappwebview_linux/          # Linux impl — Dart + C++ (in_app_webview.cc, plugin private .h) over WebKitGTK
zikzak_inappwebview_module/         # value-add "intelligence" layer (publish_to: none; dev only)

scripts/                            # publish + grep_gate shell scripts (see Deployment)
specs/                             # feature specs (spec-kit): spec.md, plan.md, tasks.md, tdd/
.specify/                          # spec-kit config, extensions, bugs/, workflows/, memory/ (constitution.md, tdd-profile.md)
```

### Two-tier architecture (Core vs Module)

Defined in `SPLIT_MAP.md`. The plugin is being split into:

- **Core Tier** — stays in `zikzak_inappwebview`: the thin platform plugin (widgets, controller facades, platform_interface, native packages). Raw APIs only.
- **Module Tier** — `zikzak_inappwebview_module`: all policy/state/intelligence/agent surface (WebViewPool, CaptureSource, CassetteEngine/VCR, DialogueDismissPort, RecipePort, NavigationTrackerPort, SessionStore). It depends ONLY on the plugin core's public API (`InAppWebView`, `InAppWebViewController`, `HeadlessInAppWebView`, `CookieManager`, capture-event types, `InAppBrowser`, `ChromeSafariBrowser`) and MUST NOT import `zikzak_inappwebview_platform_interface` internals.

**The grep gate enforces this split:** `bash scripts/grep_gate.sh` exits non-zero if any module-tier identifier (`WebViewPool`, `CaptureSource`, `CassetteEngine`, `DialogueDismissPort`, `RecipePort`, `NavigationTrackerPort`, `capture_service`, `cassette_engine`, `webview_pool`) appears in core, or if the module imports `zikzak_inappwebview_platform_interface` directly. Run it after refactors.

---

## 🧱 Architecture & Module Divisions

### Federated plugin wiring
Each platform package declares `flutter: plugin: implements: zikzak_inappwebview` in its `pubspec.yaml` with a `pluginClass` (native registration) and a `dartPluginClass` (e.g. `AndroidInAppWebViewPlatform`). The umbrella `pubspec.yaml` lists each platform under `plugin: platforms: <os>: default_package:`. At runtime the active platform's `dartPluginClass` sets `InAppWebViewPlatform.instance`.

### Platform interface (the seam)
- `zikzak_inappwebview_platform_interface/lib/src/inappwebview_platform.dart` defines the abstract `InAppWebViewPlatform` and all `PlatformXxx` facades.
- The abstract `PlatformInAppWebViewController` lives in `lib/src/in_app_webview/platform_inappwebview_controller.dart`. It was **split into four domain delegates** (issue #229): `navigationDelegate`, `javaScriptDelegate`, `cookieDelegate`, `settingsDelegate` (each defaulting to `null` and overridden per platform).
- The app-facing `InAppWebViewController` (`zikzak_inappwebview/lib/src/in_app_webview/in_app_webview_controller.dart`) exposes matching lazily-created facades: `navigation` → `NavigationController`, `javaScript` → `JavaScriptController`, **`cookies`** (plural) → `CookieController`, `settings` → `SettingsController`. Implementations live in `lib/src/in_app_webview/controllers/`.

### Model / entity layer (Zorphy, not Freezed)
Models were migrated from the old `@ExchangeableObject`/`@ExchangeableEnum` build_runner codegen to **Zorphy entities** (see `PROGRESS.md`). Each entity family lives in its own folder, e.g. `lib/src/domain/entities/cookie/{cookie.dart, cookie.zorphy.dart, cookie.g.dart}`:
- `cookie.dart` is hand-written with `@Zorphy(kind: ZorphyKind.valueObject, generateJson: true, ...)` on an abstract `$Cookie` class.
- `cookie.zorphy.dart` + `cookie.g.dart` are GENERATED — do not edit by hand; run `flutter pub run build_runner build --delete-conflicting-outputs` in the platform_interface package.
- `build.yaml` (platform_interface) scopes `zorphy` + `json_serializable` builders to `lib/src/domain/entities/**`.
- Remaining `ExchangeableObject` mentions in comments are historical; the codegen is gone (no `dev_packages/` directory).

### Native layers
- **Android:** Java (NOT Kotlin despite older docs). Package `wtf.zikzak.zikzak_inappwebview_android`. `android/build.gradle`: AGP 8.13.1, `compileSdk 36`, Java 17, `minSdk 24` (Android 7.0), depends on `androidx.webkit:webkit:1.15.0`, `androidx.browser:browser:1.8.0`. 16KB page-size alignment is on (AGP >= 8.5.1).
- **iOS / macOS:** Swift, consumed via **Swift Package Manager** (`ios/zikzak_inappwebview_ios/Package.swift`, `macos/.../Package.swift`). `build_ios_xcframework.sh` rebuilds the XCFramework.
- **Linux:** C++ (`linux/in_app_webview.cc`, `linux/zikzak_inappwebview_linux_plugin.cc`, `linux/CMakeLists.txt`) over WebKitGTK; requires WebKitGTK 2.40+ at runtime.
- **Windows:** no own native code — a Dart wrapper over the external `webview_windows` package (plus `path`, `path_provider`). Requires the WebView2 Runtime on the target machine.
- **Web:** pure Dart using `dart:js_interop` / `package:web` (`^1.1.1`). Some APIs (e.g. screenshot/PDF) are deliberate stubs returning `null`.
- **Runtime minimums** (from `README.md`): Android API 24+, iOS 16.0+, macOS 12.0+, Windows 10+, Linux WebKitGTK 2.40+.

### App-facing Dart organization (umbrella `lib/src/main.dart`)
Exports are grouped by feature: `in_app_webview`, `in_app_browser`, `chrome_safari_browser`, `web_storage`, `cookie_manager`, `pull_to_refresh`, `web_message`, `web_authentication_session`, `print_job`, `find_interaction`, `service_worker_controller`, `proxy_controller`, `webview_asset_loader`, `tracing_controller`, `process_global_config`, `in_app_localhost_server`, `webview_environment`, `webview_navigation_guards`, `navigation_tracker`, `session_recipe`, `dialogue_dismisser`, plus `webview_sessions` (the `zikzak_session`-backed portable session API, spec 014).

---

## 🛠️ Build & Test Commands

**CRITICAL:** `flutter test` / `flutter analyze` must run **inside the package that owns the file**. There is no root pubspec to resolve against. Each package is its own pub root. Always `cd` into the package first.

### Per-package `flutter test`

| Package | cwd | Runner | Notes |
| --- | --- | --- | --- |
| `zikzak_inappwebview` | `zikzak_inappwebview` | flutter_test | umbrella; richest behavior tests |
| `zikzak_inappwebview_platform_interface` | `zikzak_inappwebview_platform_interface` | flutter_test | entity/fromJson coverage |
| `zikzak_inappwebview_android` | `zikzak_inappwebview_android` | flutter_test | |
| `zikzak_inappwebview_ios` | `zikzak_inappwebview_ios` | flutter_test | |
| `zikzak_inappwebview_macos` | `zikzak_inappwebview_macos` | flutter_test | |
| `zikzak_inappwebview_web` | `zikzak_inappwebview_web` | flutter_test **`--platform chrome`** | REQUIRES Chrome: uses `dart:js_interop` |
| `zikzak_inappwebview_windows` | `zikzak_inappwebview_windows` | flutter_test | |
| `zikzak_inappwebview_linux` | `zikzak_inappwebview_linux` | flutter_test | |
| `zikzak_inappwebview_module` | `zikzak_inappwebview_module` | flutter_test | dev-only; see Known Issues |

Generic shapes (run from inside the package):
```bash
flutter pub get                                   # first time / after pubspec change
flutter test                                      # full suite
flutter test test/<file>_test.dart               # one file
flutter test test/<file>_test.dart --plain-name "Behavior name"   # one test
flutter test --coverage                           # emits coverage/lcov.info
flutter analyze                                   # lint/type check
```

To regenerate Zorphy/json_serializable output (only in `zikzak_inappwebview_platform_interface`):
```bash
cd zikzak_inappwebview_platform_interface && flutter pub run build_runner build --delete-conflicting-outputs
```

### Acceptance / E2E layer (`example/integration_test`)
Lives in `zikzak_inappwebview/example/integration_test/` (e.g. `dismiss_dialogues_test.dart`, `get_html_test.dart`, `lifecycle_test.dart`, `android_take_screenshot_test.dart`, `ios_take_screenshot_test.dart`, `macos_take_screenshot_test.dart`). Runs on a real device/simulator:
```bash
cd zikzak_inappwebview/example && flutter test integration_test/<file>.dart -d <device>
```
**Observed platform status (2026-08-31):** iOS Simulator runs the integration suite reliably. **macOS desktop** (`-d macos`) fails — `controller.loadData(...)` never completes (native method-channel response lost in the headless desktop WebView; times out 20s). **Android emulator** fails earlier at `adb install` (`Can't find service: package`) — needs a working ADB bridge. These are environment/tooling limits, not feature regressions.

### GYM exercises (`.gym/`)
`zikzak_inappwebview/.gym/gym.yaml` defines a package-level GYM: warmup reps `01-deps` (flutter pub get), `02-build` (analyze), `03-bridge-smoke` (flutter test `.gym/warmup/03-bridge-smoke_test.dart`), plus graded exercises (e.g. `js-bridge-round-trip`) graded by exit code.

### Known repository state — measured on `master` at 2026-08-31

**Do NOT assume a green baseline.** Actual `flutter test` results per package:

| Package | Result |
| --- | --- |
| `zikzak_inappwebview_macos` | 42 pass — GREEN |
| `zikzak_inappwebview_windows` | 14 pass — GREEN |
| `zikzak_inappwebview_linux` | 9 pass — GREEN |
| `zikzak_inappwebview_web` | 1 pass — GREEN, but ONLY with `--platform chrome` |
| `zikzak_inappwebview` | 240 pass / **2 fail** |
| `zikzak_inappwebview_platform_interface` | 305 pass / **1 fail** |
| `zikzak_inappwebview_android` | **does not compile** |
| `zikzak_inappwebview_ios` | **does not compile** |
| `zikzak_inappwebview_module` | **does not compile** (dependency, not source) |

Pre-existing failures (not caused by you):
- `zikzak_inappwebview/test/domain_controllers_behavioral_test.dart` — "U14 loadSimulatedRequest delegates to parent identically".
- `zikzak_inappwebview/test/in_app_webview_dispose_test.dart` — "U9: a later dispose(isKeepAlive: false) after dispose(isKeepAlive: true) forwards false and fully releases" (expected 2, actual 1).
- `zikzak_inappwebview_platform_interface/test/types/final_gap_entities_test.dart` — "PDFConfiguration wire: rect as nested map".

Compile breakages:
- `zikzak_inappwebview_android` and `zikzak_inappwebview_ios`: a committed merge left **duplicate** `_navigationDelegate` / `_javaScriptDelegate` / `_cookieDelegate` / `_settingsDelegate` field+getter declarations in `lib/src/in_app_webview/in_app_webview_controller.dart` — one set near lines 120–150 typed as `AndroidXxxDelegate?`/`IOSXxxDelegate?`, a second set near lines 2740–2775 typed as `PlatformXxxDelegate?`. `flutter analyze` reports 12 errors per package (`duplicate_definition` + `return_of_invalid_type`). Remove the duplicated block before working in these packages.
- `zikzak_inappwebview_module`: `pubspec.lock` pins `zuraffa 6.0.0`, whose local pub-cache entry is missing `lib/src/extensions/future_extensions.dart`. A cache/version problem, not source. This package is `publish_to: none` and is not in the publish set.

Doc staleness to be aware of:
- `.specify/memory/tdd-profile.md` claims 10 umbrella test files / 112 tests and a green baseline — reality is ~28 test files / 242 tests with 2 red. Treat it as partially outdated.
- Package versions are skewed: umbrella `zikzak_inappwebview` is `5.0.0` while every other published package is `5.1.2`. `README.md` still tells consumers to install `^4.6.0`.

---

## 🧪 Testing Strategy & Conventions

Per `.specify/memory/constitution.md` and `tdd-profile.md`:

- **TDD is the mandated discipline (NON-NEGOTIABLE in the constitution):** every behavior change is driven by a test observed failing first; red→green→refactor. Record cycles in `specs/<feature>/tdd/cycle-log.md`.
- **Test files:** `<name>_test.dart` under the package `test/`, mirroring `src/`. Use `package:flutter_test/flutter_test.dart`; assert with `expect(...)` + matchers (`isTrue`, `equals`, `same`, `throwsA`, …). Group with `group(...)`, name tests after the behavior; reference spec FR/US ids in group names (e.g. `cookie mapping (FR-005)`).
- **No mocking library (no mockito).** Use real objects or small hand-written inline fakes (e.g. `_InMemoryPort implements SessionPort`, `_ProbeDisposable implements Disposable`). Prefer state-based assertions on observable results. **No shared test-helper package** — each test builds its own minimal fixtures.
- **Behavioral tests** should call the real class and assert observable output, not merely reference symbols. The active behavioral exemplar is `zikzak_inappwebview/test/webview_sessions_test.dart`.
- **Never** call `DateTime.now()` in production code under test without injecting a clock.
- Many existing tests are compile-time probes (assert a signature exists); new tests should be behavioral.

---

## 🎨 Code Style Guidelines

- `analysis_options.yaml` in each package `include: package:flutter_lints/flutter.yaml`. Common overrides: `constant_identifier_names: ignore`, `deprecated_member_use(_from_same_package): ignore`, `unnecessary_cast/import: ignore` (deprecated-member errors are suppressed repo-wide — do not "fix" by removing deprecated calls unless the spec calls for it). The `module` package additionally enforces `prefer_single_quotes` and `avoid_print`.
- Analyzer `exclude` lists `build/**` and all native platform dirs (`android/`, `ios/`, `web/`, `macos/`, `windows/`, `linux/`) so native code is not Dart-analyzed.
- Native style follows each platform's norm: Java (Android), Swift (iOS/macOS) with `#if !os(macOS)` guards where an API is iOS-only (see `INSIGHTS.md` for WKWebView iOS/macOS divergences), C++ (Linux).
- Commits follow Conventional Commits (`feat(...)`, `fix(...)`, `test(...)`, `refactor(...)`, `docs(...)`); scopes are package- or spec-based (e.g. `test(in_app_webview)`, `fix(android)`, `docs(specs)`, `test(001): ...` referencing a spec number). PRs are merged into `master` via GitHub merge commits (`Merge pull request #NNN from arrrrny/<branch>`); feature branches are named `feat/...`, `fix/...`, or `<NNN>-<slug>`.
- **There is no CI in this repo.** `.github/` contains only `FUNDING.yml` and `autolabeler.yml` — no GitHub Actions workflows, no Makefile, no Jenkinsfile. The authoritative gate is running `flutter analyze` + `flutter test` yourself in each affected package. Do not assume a pipeline will catch anything.

---

## 🚀 Development Conventions

- **Spec-kit workflow:** features live in `specs/<NNN>-<slug>/` (`spec.md`, `plan.md`, `tasks.md`, `tdd/`, `contracts/`, `checklists/`). Config in `.specify/` (`extensions.yml`, `workflows/speckit`, `bugs/`). `feature.json` points at the active feature dir. Bug triage lives in `.specify/bugs/<slug>/` (`assessment.md`, `issue.md`).
- **Two-tier split gate:** `bash scripts/grep_gate.sh` must stay green after any core↔module refactor.
- **Consumer migration:** `CONSUMER_TRANSITION_PLAN.md` describes how value-add classes move from core to `zikzak_inappwebview_module` (re-export-then-remove with `@Deprecated`).
- **Upstream issue tracking:** `UPSTREAM_ISSUES_TRIAGE.md` (156+ triaged upstream issues) and `PROGRESS.md` (Zorphy migration log) are the project memory of what changed and why.

---

## 📦 Deployment / Publishing

Controlled by `scripts/` and documented in `PUBLISH.md`. **8 packages** publish to pub.dev, in this exact dependency order (from `scripts/publish.sh` / `scripts/prepare_for_publish.sh`):

```
zikzak_inappwebview_platform_interface → _android → _ios → _web → _macos → _windows → _linux → zikzak_inappwebview
```

`zikzak_inappwebview_module` is NOT published (`publish_to: none`). Note `PUBLISH.md` lists a 9th, first package `zikzak_inappwebview_internal_annotations` that no longer exists in this repo — its package list is stale; trust the scripts.

Scripts:
- `scripts/prepare_for_publish.sh <version>` — branch, bump versions, convert path deps → versioned constraints, propagate changelogs, commit. (Interactive; pipe `echo ""` for default.)
- `scripts/publish.sh` — publish to pub.dev in order (needs **≥20 min** timeout; pub.dev propagation between packages).
- `scripts/push_to_master.sh -f` — merge publish branch to master, tag, auto-delete branch.
- `scripts/restore_dev_setup.sh` — revert to path dependencies for local dev.
- `scripts/revert_publish_changes.sh` — discard publish changes.

**Pre-publish rules:**
- Convert ALL path deps to caret version constraints; **no `: any`** allowed in any `pubspec.yaml` (publish-manager validates this).
- The root `CHANGELOG.md` is the single source of truth; `prepare_for_publish.sh` reads the new version's entry and propagates it to every sub-package CHANGELOG. (Note: the repo currently has **no root CHANGELOG.md** — per-package CHANGELOG.md files exist instead. Reconcile before relying on the script.)
- Example app (`zikzak_inappwebview/example`) uses `dependency_overrides` pointing at local platform packages for dev; these are stripped before publish.

---

## 🔒 Security Considerations

- **Enhanced URL validation** and **content-process recovery** are explicit features (README). Touch `webview_navigation_guards.dart` / `process_global_config.dart` carefully — they are part of the modern-security surface.
- **Network capture** (`network_capture/`, `NetworkCaptureManager`) includes a **secret redactor** (`secret_redactor.dart`) — any new captured field must be run through the redactor to avoid leaking credentials/cookies into logs or VCR cassettes.
- `false_secrets` in the umbrella `pubspec.yaml` excludes `test_node_server/*.pem` and `*.pfx` from secret scanning.
- Native Android uses `consumerProguardFiles` and R8 minify in release; keep public API names stable or update the platform interface contract.

---

## 🧭 Quick Orientation for Common Tasks

- **Add a new WebView setting/option:** add it to the entity under `zikzak_inappwebview_platform_interface/lib/src/domain/entities/...`, regenerate, then wire Android (`android/.../types/`), iOS/macOS (`ios/.../Swift`), and the umbrella controller.
- **Add a platform method:** extend the `PlatformXxx` facade in `platform_interface`, implement in each platform package's `dartPluginClass`, and expose via the umbrella facade.
- **Add intelligence/policy (pool, VCR, capture, recipe, dialogue):** put it in `zikzak_inappwebview_module` behind a port interface; never import `platform_interface` directly; keep `scripts/grep_gate.sh` green.
- **Find where a feature lives:** run `mcp__claude_context__search_code` (mandatory) before grep.
- **Verify your change:** `cd <affected package> && flutter analyze && flutter test`. For anything touching core↔module boundaries also run `bash scripts/grep_gate.sh`. For native/UI behavior, run the matching `example/integration_test` file on the iOS Simulator (the only platform where that layer currently works).

---

## 📖 Reference Documents (repo root)

| File | What it holds |
| --- | --- |
| `README.md` | User-facing overview, install, platform requirements, migration notes |
| `SPLIT_MAP.md` | Authoritative Core-vs-Module class inventory + seam contract + validation rules |
| `CONSUMER_TRANSITION_PLAN.md` | How downstream consumers migrate to `zikzak_inappwebview_module` |
| `PROGRESS.md` | Long-form log of the `@ExchangeableObject` → Zorphy entity migration (phases, PRs, gotchas) |
| `INSIGHTS.md` | Hard-won non-obvious findings (macOS vs iOS WKWebView API divergence, CocoaPods deintegration, headless `run()` semantics) |
| `UPSTREAM_ISSUES_TRIAGE.md` | 156+ triaged upstream `flutter_inappwebview` issues |
| `PUBLISH.md` | Release workflow (package list slightly stale — see Deployment) |
| `CLAUDE.md` | Auto-generated spec-kit stub; largely template placeholders, low value |
| `.specify/memory/constitution.md` | Project constitution — only the TDD principle is filled in; the rest is unfilled template |
| `.specify/memory/tdd-profile.md` | Verified test commands per stack (counts/baseline partially stale) |
