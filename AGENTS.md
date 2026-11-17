# AGENTS.md — ZikZak InAppWebView

<!-- misfire-rule:begin -->
## ZURAFFA MISFIRE RULE (HARD, NON-NEGOTIABLE — HARDCODED TOP RULE)

**On ANY misfire (test failure, compilation error, runtime crash, unexpected output) related to zuraffa:**

1. **STOP IMMEDIATELY** on the first misfire.
2. **Report the issue** to zuraffa GitHub (`arrrrny/zuraffa`) with: the command that failed, expected vs actual output, and root cause.
3. **Continue with a workaround** to make the task pass (e.g., skip the failing test, use an alternative approach, or mock the failing component).
4. **Add a comment** in the code explaining the workaround applied and linking to the zuraffa GitHub issue.

**On ANY misfire related to the repo itself (not zuraffa):**

1. **STOP IMMEDIATELY** on the first misfire.
2. **Report the issue** to the repo's GitHub with full details.
3. **Continue with a workaround** to make the task pass.
4. **Add a comment** in the code explaining the workaround applied.

This rule takes precedence over all other rules. Never skip a misfire or rationalize it away.
<!-- misfire-rule:end -->

<!-- pool-pr:begin -->
## The forklift pool owns the PR — never merge a pull request yourself

Every pull request in these repos is reviewed by the **forklift pool**
(`arrrrny/forklift` — the local PR-review pipeline). It mints three tasks, in
this order, and that chain is the only sanctioned way from "PR opened" to "PR
merged":

1. `PR review <repo>#<n>` — the automated review; it posts its actionable
   findings on the PR.
2. `Apply review fixes <repo>#<n>` — one fixes round, pushed onto the PR's
   branch.
3. `Merge PR <repo>#<n>` — the merge itself; the task refuses while reviewer
   findings are still unaddressed.

**Never merge or close a PR by hand, and never merge one because it "looks
finished".** A hand merge lands the code while findings are still open: the
pool's fixes task is then killed by its closed-PR guard — the dispatcher log
says `…#<n> is closed — cancelled, no agent started` — and every finding the
review posted is dropped with nobody to own it. That is not a review, it is a
race the pipeline cannot win.

**Wait for the pool, and read the pool for the state.** The three task rows are
the truth; the PR page is not:

```bash
# the pool's board — loopback, IPv4-only (never `localhost`)
curl -s http://127.0.0.1:8888/tasks \
  | jq -r '.[] | select(.title | test("PR review|Apply review fixes|Merge PR")) \
          | [.title, .status, .id] | @tsv'
```

One row per stage. `status` is one of `queued`, `running`, `done`, `failed`,
`needsInput`, `cancelled`, `paused`. The PR is done when the
`Merge PR <repo>#<n>` row reads `done`. A fixes row that reads `failed` or
`cancelled` means the PR was **not** reviewed-and-fixed: read the row's
`errorMessage`, fix the cause, and let the pipeline requeue it (relabelling a
failed task requeues it in the same call — `POST /tasks/<id>/label`).

**An agent can simply wait for the whole process** — poll the board above until
the `Merge PR` row is terminal. Everything else is the pool's job: it drives
the review, the fixes round and the merge.
<!-- pool-pr:end -->

<!-- tmp-clone:begin -->
## Work in a `/tmp` clone — never in `~/Developer`

Every piece of work on a PR or an issue happens in its own clone under `/tmp`,
and that clone dies with the task:

```bash
git clone https://github.com/<owner>/<repo>.git /tmp/<repo>-<pr-or-issue>
```

Never clone into `~/Developer`, and never clone into the forklift checkout —
a bare repo slug as the clone target is how a stray checkout ends up inside the
repo root, and a clone left behind in `~/Developer` is indistinguishable from
the primary checkout. The pool's lanes already mint their clones this way
(`/tmp/fix-pr-<n>`, `/tmp/review-pr-<n>`, `/tmp/issue-<n>`, …) and remove them
when the task settles.
<!-- tmp-clone:end -->

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

## 🌐 `HTTPS_PROXY` — an OPENCODE-ONLY problem. Do not replicate the workaround.

**Read this before you copy `env -u HTTPS_PROXY` out of any doc or commit message in this repo.**

`~/.zshrc` (and `~/.bash_profile`) define the agent CLI as an alias that injects a proxy into *that command's* environment only:

```sh
alias opencode='HTTPS_PROXY=https://$(head -n1 ~/.secrets/proxy-node-auth)@proxy-node.zuzu.dev NO_PROXY=localhost,127.0.0.1 opencode'
```

Note "Scoped to the `opencode` command ONLY" in the comment above it. It is **not** an exported login-shell variable — prove it yourself:

```bash
env -i /bin/zsh -c 'echo "[${HTTPS_PROXY}]"'   # -> []
```

So `HTTPS_PROXY` is inherited by the processes **opencode** spawns (its Bash tool, and every `flutter`/`dart`/`git`/`curl` under it) and by **nothing else**.

**Why it bites:** Dart pub refuses a proxy URL that carries embedded credentials, so *every* pub operation dies before it starts:

```
Invalid proxy configuration PROXY proxy:TOKEN@proxy-node.zuzu.dev
Failed to update packages.                                  # exit 69
```

That takes down `flutter pub get` — and therefore `flutter analyze`, `flutter test` and `pub publish`, which all resolve dependencies first. It looks like a red build; it is not. It is the proxy.

**The rule — who does what:**

| Where the command runs | Has `HTTPS_PROXY`? | What to do |
| --- | --- | --- |
| **Inside opencode** (this file's audience: the Bash tool, `scripts/local_ci.sh`, `scripts/publish.sh`) | yes | Prefix pub-touching commands: `env -u HTTPS_PROXY -u https_proxy bash scripts/publish.sh` |
| **Kimi**, any other editor/agent, a plain terminal, a CI runner, a human | **no** | **Nothing.** Do not add `env -u …`, do not wrap your commands in it, do not "fix" a script by adding it |

**If you are not opencode:** `env -u HTTPS_PROXY` unsets a variable you never had, so it is a no-op at best. Writing it into scripts, docs or commits — or reporting it as a fix — is cargo-culting a defect that does not exist in your environment. One command settles it:

```bash
echo "${HTTPS_PROXY:-unset}"    # "unset" -> this section does not apply to you
```

**Never bake the unset into the repo.** `scripts/local_ci.sh` and `scripts/publish.sh` must stay proxy-agnostic: they cannot know who launched them, and a hard-coded `env -u` would silently mask a genuinely broken proxy for a caller who does have one configured.

The same workaround is quoted in the `6.2.x` `CHANGELOG.md` entries and in `PUBLISH.md`. Those references carry this same opencode-only scope — if you are grepping this repo for `HTTPS_PROXY` because a command failed, the answer is in this section, not in the command you were about to copy.

---

## 📦 Project Overview

`zikzak_inappwebview` is a **Flutter plugin** (a community fork of `flutter_inappwebview`, API-equivalent to upstream 6.x, published as fork version 4.x/5.x) that provides an inline WebView, a headless WebView, and an in-app browser window across **6 platforms**: Android, iOS, macOS, Web, Windows, Linux.

It is a **Dart/Flutter monorepo** made of **10 independent pub packages** that form one federated plugin. It is NOT a single app. The `zikzak_inappwebview` package is the "umbrella" / app-facing package; the rest are platform implementations plus a shared platform-interface package. One of them, `zikzak_webview_windows`, is not a zikzak platform facade at all — it is a BSD-3 fork of `webview_windows` (see below).

- **License:** Apache License 2.0 (see `LICENSE`). Dart source files do NOT carry per-file Apache headers — don't add them.
- **Homepage / docs:** https://arrrrny.github.io/zikzak_inappwebview
- **Pub:** https://pub.dev/packages/zikzak_inappwebview
- **SDK floor (all packages):** `sdk: >=3.8.0 <4.0.0`, `flutter: >=3.47.0` (Dart 3.13.0 — the real minimum since every zuraffa 7.x needs `meta ^1.19.0`, which Flutter only allows from 3.47.0; see #393). Installed toolchain on this machine: Flutter 3.47.7 / Dart 3.13.5.

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
zikzak_webview_windows/             # BSD-3 fork of `webview_windows` 0.4.0 (Niklas Schulze), renamed + DevTools protocol API; own native C++ (version 0.5.0, NOT lockstep with the 6.x line)
zikzak_inappwebview_windows/        # Windows impl — Dart facade over `zikzak_webview_windows` (no own native code)
zikzak_inappwebview_linux/          # Linux impl — Dart + C++ over WPE WebKit (headless WPEPlatform; not WebKitGTK since 6.4.0)
zikzak_inappwebview_module/         # value-add "intelligence" layer (publish_to: none; dev only)

scripts/                            # publish + grep_gate shell scripts (see Deployment)
specs/                             # feature specs (spec-kit): spec.md, plan.md, tasks.md, tdd/
.specify/                          # spec-kit config, extensions, bugs/, workflows/, memory/ (constitution.md, tdd-profile.md)
```

### The `zikzak_webview_windows` fork

`zikzak_inappwebview_windows` is a Dart facade; the native WebView2 implementation lives in
`zikzak_webview_windows`, which is a **BSD-3 fork of `webview_windows` 0.4.0 by Niklas Schulze**
(`jnschulze/flutter-webview-windows`), taken at `ba0940e`. It exists for one reason: the fork carries the
WebView2 DevTools protocol API (`callDevToolsProtocolMethod`, `devToolsProtocolEvent`, devtools listener
add/remove) from [upstream PR #334](https://github.com/jnschulze/flutter-webview-windows/pull/334), which **no
hosted `webview_windows` release has**. The facade compiles against that API, so a hosted 0.4.0 would not compile.

Three consequences worth knowing before touching it:

- **It does not share the monorepo's version line.** Every other publishable package is `6.x` in lockstep; this one
  is `0.5.0`, because it mirrors upstream's numbering plus the fork delta. `prepare_for_publish.sh` must never be
  pointed at it, and `publish.sh` does not publish it — see PUBLISH.md for the separate step.
- **Renaming is not cosmetic.** Flutter's Windows plugin registrant derives the include path and the registration
  symbol from the package name (`_cppPluginRegistryImplementationTemplate` in `flutter_tools` emits
  `<name>/<filename>.h` and `<class>RegisterWithRegistrar`), so the native plugin, its CMake target
  (`zikzak_webview_windows_plugin`) and `ZikzakWebviewWindowsPlugin` all follow the package name. The
  `io.jns.webview.win` method-channel prefix and the `flutter_webview_windows` data directory deliberately do not —
  they are internal strings shared with the native side.
- **Windows native code cannot be compiled or CI-gated here.** This machine is macOS and the CI matrix has no
  Windows runner, so a C++ break in `windows/` is invisible to `flutter analyze` and `flutter test`. A green
  monorepo run says nothing about the native build; only `flutter build windows` on a Windows host does.

Syncing from upstream means re-taking the diff, not merging: the fork carries a rename, so a plain upstream merge
conflicts on every renamed path. Prefer re-applying upstream's `lib/` and `windows/` changes on top and re-running
the rename steps.

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
- **Linux:** C++ (`linux/in_app_webview.cc`, `linux/zikzak_inappwebview_linux_plugin.cc`, `linux/CMakeLists.txt`) over **WPE WebKit** — re-based in 6.4.0 (#420), so the runtime requirement is WPE WebKit 2.50+ with the headless `WPEPlatform` backend (`wpe-webkit-2.0`, `wpe-platform-2.0`, `wpe-platform-headless-2.0`, `wpe-1.0`), not WebKitGTK 2.40+.
- **Windows:** no own native code — a Dart wrapper over the external `webview_windows` package (plus `path`, `path_provider`). Requires the WebView2 Runtime on the target machine.
- **Web:** pure Dart using `dart:js_interop` / `package:web` (`^1.1.1`). Some APIs (e.g. screenshot/PDF) are deliberate stubs returning `null`.
- **Runtime minimums** (from `README.md`): Flutter 3.47.0+, Android API 24+, iOS 15.0+, macOS 12.0+, Windows 10+, Linux WPE WebKit 2.50+, Web any.

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

### Known repository state — measured on `master` at 2026-10-17, after the `6.2.1` release

`master` is **green**: the 21-job CI matrix passes, and every number below was reproduced locally on this release's tree (1028 test cases, 0 warnings anywhere) via a per-package `flutter analyze --no-fatal-infos` + `flutter test --concurrency=2` sweep. Re-measure before leaning on it — this table moves.

| Package | test files | `flutter test` | `flutter analyze` |
| --- | --- | --- | --- |
| `zikzak_inappwebview` | 29 | 269 pass — GREEN | 44 infos, 0 warnings, 0 errors |
| `zikzak_inappwebview_platform_interface` | 39 | 309 pass — GREEN | 77 infos, 0 warnings, 0 errors |
| `zikzak_inappwebview_macos` | 19 | 156 pass — GREEN | clean |
| `zikzak_inappwebview_ios` | 17 | 113 pass — GREEN | 192 infos, 0 warnings, 0 errors |
| `zikzak_inappwebview_windows` | 7 | 55 pass — GREEN | clean |
| `zikzak_webview_windows` | 1 | 2 pass — GREEN | 6 infos, 0 warnings, 0 errors |
| `zikzak_inappwebview_linux` | 10 | 67 pass — GREEN | 4 infos, 0 warnings, 0 errors |
| `zikzak_inappwebview_web` | 1 | 1 pass — GREEN, but ONLY with `--platform chrome` | clean |
| `zikzak_inappwebview_android` | 7 | 29 pass — outside the CI matrix | 197 infos, 0 warnings, 0 errors |
| `zikzak_inappwebview_module` | 2 | 27 pass — outside the CI matrix | clean (`publish_to: none`, never published) |

The remaining infos are style-level and deliberately tolerated (`--no-fatal-infos`). Warnings are **not** tolerated — a new warning in any matrix package is a red build. Note that `zikzak_inappwebview_android` and `zikzak_inappwebview_module` are simply absent from both matrices (`analyze` covers 8 packages, `test` covers 7 plus the `--platform chrome` web job); both are green when measured locally, so their exclusion is not a lint-debt gate. Treat their numbers as unverified-in-CI.

`zikzak_webview_windows`'s two tests are Dart-only surface probes. Nothing in either matrix compiles its C++ — see the Windows caveat in "The `zikzak_webview_windows` fork" above.

One local-CI step is not fully exercised on this machine: a `build-ios` "Check the toolchain compiles the arm this job exists for" step asserts a pre-Swift-6 toolchain on any runner that is not `macos-15`, and the local Xcode is Swift 6.x, so that branch would fail here by construction. Since #412 no pre-Swift-6 runner is in the matrix, so only the `macos-15` branch is reachable in CI — it asserts Swift 6, which this machine's Xcode satisfies, so it passes; the `else` branch is unreachable until a pre-Swift-6 runner is added back, and the assertion stays for whoever does. Both Swift builds — `flutter build ios --release --no-codesign` and `flutter build macos --debug` — do run and pass locally, so the Swift sources are genuinely compiled.

### Local-source dependencies (dev mode)

Every publishable package resolves its intra-repo dependencies through `dependency_overrides:` pointing at sibling directories, so one checkout builds and tests against itself — that is what makes the CI matrix exercise monorepo source rather than pub.dev artifacts.

**Use `dependency_overrides`, not `path:` under `dependencies:`.** A plain path dependency makes `flutter analyze` report `invalid_dependency` ("Publishable packages can't have 'path' dependencies") in every publishable package, and that diagnostic is a warning, i.e. fatal under the gate. `scripts/prepare_for_publish.sh` deletes the whole `dependency_overrides:` section before publishing, and also deletes bare `path:` lines. `scripts/restore_dev_setup.sh` writes path deps under `dependencies:` — it drives analyze red, so prefer editing the overrides by hand.

Doc staleness to be aware of:
- `.specify/memory/tdd-profile.md` claims 10 umbrella test files / 112 tests and a green baseline — the umbrella now has 27 files / 250 tests. Treat it as partially outdated.
- Every package is at `6.4.1`, and README installation snippets match.

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

- `analysis_options.yaml` in each package `include: package:flutter_lints/flutter.yaml`. Common overrides: `deprecated_member_use(_from_same_package): ignore`, `unnecessary_cast/import: ignore` (deprecated-member errors are suppressed repo-wide — do not "fix" by removing deprecated calls unless the spec calls for it). The `module` package additionally enforces `prefer_single_quotes` and `avoid_print`. To disable a lint rule, write `rule_name: false` under `linter: rules:` — the value `ignore` is **not** accepted there and silently leaves the rule enabled (that mistake cost `constant_identifier_names` 558 findings in `platform_interface`); `ignore` is only valid under `analyzer: errors:`.
- Analyzer `exclude` lists `build/**` and all native platform dirs (`android/`, `ios/`, `web/`, `macos/`, `windows/`, `linux/`) so native code is not Dart-analyzed.
- Native style follows each platform's norm: Java (Android), Swift (iOS/macOS) with `#if !os(macOS)` guards where an API is iOS-only (see `INSIGHTS.md` for WKWebView iOS/macOS divergences), C++ (Linux).
- Commits follow Conventional Commits (`feat(...)`, `fix(...)`, `test(...)`, `refactor(...)`, `docs(...)`); scopes are package- or spec-based (e.g. `test(in_app_webview)`, `fix(android)`, `docs(specs)`, `test(001): ...` referencing a spec number). PRs are merged into `master` via GitHub merge commits (`Merge pull request #NNN from arrrrny/<branch>`); feature branches are named `feat/...`, `fix/...`, or `<NNN>-<slug>`.
- **CI exists and gates `master`.** `.github/workflows/ci.yml` runs a 21-job matrix (jobs × matrix legs) on every push to `master` and every PR into it: `flutter analyze` and `flutter test` for `platform_interface`, `webview_windows` (the fork), `ios`, `web`, `macos`, `windows`, `linux` and `zikzak_inappwebview` (`web` with `--platform chrome`), plus a `build-ios` job (`macos-15`; `macos-14` was dropped in #412 when its runner image retired) that compiles the iOS Swift sources, a `build-macos` job (`macos-15`) that compiles the macOS Swift sources — both by building the example app from this checkout via a `pubspec_overrides.yaml` path override — and a `resolve-floor` job that pins the declared Flutter floor (3.47.0) and resolves a minimal consumer app (`equatable: ^3.0.0` + this checkout; the #393 repro), asserting path resolution and a nocterm-free zuraffa 7.x. `zikzak_inappwebview_android` is the only published package still outside the matrix. There is no Makefile or Jenkinsfile. The authoritative gate remains running `flutter analyze --no-fatal-infos` + `flutter test` yourself in each affected package before you push.
- The analyze step passes `--no-fatal-infos`: compile **errors and warnings fail the job**, style-level infos do not. A new warning in any matrix package is a red build.
- **Only `build-ios` and `build-macos` compile Swift.** The other jobs are pure Dart, so a Swift-only break — a bad `#available` scope, an override whose signature stops matching a different SDK, a typo in a `WKDownloadDelegate` method — passes all of them. Run `cd zikzak_inappwebview/example && flutter build ios --release --no-codesign` (or `flutter build macos --debug`) locally when you touch iOS/macOS Swift, and be aware that a local Xcode may be newer than the runner's: the `evaluateJavaScript` override in `InAppWebView.swift` compiled on Xcode 26 and failed on the runner's older SDK, which is exactly the class of bug this job exists to catch. Since #333 the iOS job ran on both `macos-14` (Swift 5.10, compiling the `#else` arm of that override) and `macos-15` (Swift 6, compiling the `#if compiler(>=6.0)` arm); a local Xcode 26 build only ever compiles the latter. **Since #412 the `macos-14` leg is gone** — actions/runner-images retired every macOS 14 image on 2026-11-02 and no hosted pre-Swift-6 runner remains, so `build-ios` is `macos-15`-only and the `#else` arm is no longer compiled in CI. The arm stays in the source on purpose (`Package.swift` declares `swift-tools-version: 5.9`, so Xcode 15 consumers still compile it); re-close the gap by adding a self-hosted or pinned pre-Swift-6 runner to the `build-ios` matrix. The macOS job runs on `macos-15` alone — no macOS source has a `#if compiler` arm, so a second runner would compile the same arm twice — which still leaves the macOS sources compiled against one SDK generation only, the same blind spot the iOS two-runner split used to close.
- **macOS source-contract tests are not a type-check.** The `zikzak_inappwebview_macos` tests pass on Swift that does not compile: they read the `.swift` files as text and assert on their shape. That is why `build-macos` exists. Treat a green macOS test run as evidence about code *shape*, never as evidence that it compiles — before the `build-macos` job landed, all 73 of them passed while nothing compiled the package at all.

---

## 🚀 Development Conventions

- **Spec-kit workflow:** features live in `specs/<NNN>-<slug>/` (`spec.md`, `plan.md`, `tasks.md`, `tdd/`, `contracts/`, `checklists/`). Config in `.specify/` (`extensions.yml`, `workflows/speckit`, `bugs/`). `feature.json` points at the active feature dir. Bug triage lives in `.specify/bugs/<slug>/` (`assessment.md`, `issue.md`).
- **Two-tier split gate:** `bash scripts/grep_gate.sh` must stay green after any core↔module refactor.
- **Consumer migration:** `CONSUMER_TRANSITION_PLAN.md` describes how value-add classes move from core to `zikzak_inappwebview_module` (re-export-then-remove with `@Deprecated`).
- **Upstream issue tracking:** `UPSTREAM_ISSUES_TRIAGE.md` (156+ triaged upstream issues) and `PROGRESS.md` (Zorphy migration log) are the project memory of what changed and why.

---

## 📦 Deployment / Publishing

Controlled by `scripts/` and documented in `PUBLISH.md`. **9 packages** publish to pub.dev. Eight of them publish in
this exact dependency order, at one shared version (from `scripts/publish.sh` / `scripts/prepare_for_publish.sh`):

```
zikzak_inappwebview_platform_interface → _android → _ios → _web → _macos → _windows → _linux → zikzak_inappwebview
```

The ninth, `zikzak_webview_windows`, publishes **separately and first**, at its own version line (`0.5.0`, not `6.x`):
it is the fork the Windows facade compiles against, so it must exist on pub.dev before `zikzak_inappwebview_windows`
can resolve. See PUBLISH.md. `zikzak_inappwebview_module` is NOT published (`publish_to: none`).

Scripts:
- `scripts/prepare_for_publish.sh <version>` — branch, bump versions, convert path deps → versioned constraints, propagate changelogs, commit. (Interactive; pipe `echo ""` for default.)
- `scripts/publish.sh` — publish to pub.dev in order (needs **≥20 min** timeout; pub.dev propagation between packages).
- `scripts/push_to_master.sh -f` — merge publish branch to master, tag, auto-delete branch.
- `scripts/publish_windows_fork.sh` — publish the `zikzak_webview_windows` fork (its own 0.5.x line) with a dry run first; run it **before** `publish.sh`.
- `scripts/restore_dev_setup.sh` — revert to path dependencies for local dev.
- `scripts/revert_publish_changes.sh` — discard publish changes.

**Pre-publish rules:**
- Convert ALL path deps to caret version constraints; **no `: any`** allowed in any `pubspec.yaml` (publish-manager validates this).
- **Two changelogs, and they are not the same file.** `prepare_for_publish.sh` reads the new version's entry from
  **`zikzak_inappwebview/CHANGELOG.md`** (the umbrella's — its `ROOT_CHANGELOG` variable) and propagates it into the
  other 7 package changelogs, skipping the umbrella's because it already has it. The **repo-root `CHANGELOG.md`** is a
  separate, hand-curated project log that the script never reads. Write the new entry into **both**: if the umbrella's
  is missing it, the script falls back to dumping raw commit subjects into every package changelog (that is how
  `zikzak_inappwebview/CHANGELOG.md`'s `6.3.4` entry became the one-line `* fix: address review comments on #406`).
  The two files have drifted apart historically — the umbrella's entries are more detailed and it is missing `6.3.2`.
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

<!-- local-ci:begin -->
## Running CI locally — `scripts/local_ci.sh`

GitHub Actions is billing-blocked on our private repos: every workflow run ends in
~3s with **zero steps executed**, so a red check here means nothing. Run the same
gate locally instead:

```bash
./scripts/local_ci.sh              # every job of the pull_request workflow
./scripts/local_ci.sh --plan       # print every step that would run, run nothing
./scripts/local_ci.sh --list       # workflows, triggers and jobs in this repo
./scripts/local_ci.sh --job <id>   # one job only
./scripts/local_ci.sh --event push # simulate the push-triggered workflow
./scripts/local_ci.sh --keep-going # do not stop at the first failure
./scripts/local_ci.sh -v           # echo each command before running it
```

It reads `.github/workflows/*` at run time and executes that workflow's jobs and
steps in order, so it cannot drift from CI — it is not a second copy of the gate.
Edit the workflow and the local run changes with it. Exit 0 means every executed
step passed.

What it cannot reproduce, and prints on startup instead of guessing:

- **Linux.** CI runs `ubuntu-latest`; this runs on macOS. The step set is the
  same, the platform is not. `sudo apt-get install` steps are mapped to a local
  presence probe rather than silently passed.
- **GitHub context.** A step needing `${{ secrets.* }}`, `${{ inputs.* }}`,
  `${{ vars.* }}`, `${{ steps.* }}` or `${{ github.event.* }}` is SKIPPED with the
  reason printed, never run with a guessed value.
- **`uses:` actions** are not executed. Toolchain setups (`setup-dart`,
  `setup-node`, `flutter-action`, `rust-toolchain`, …) become a version assertion
  against the local tool; checkout/cache/artifact are noted as no-ops; anything
  else is skipped by name. A Windows-runner job is skipped outright.
- **Cargo cross targets.** A step that builds for a rust cross target (e.g.
  `cargo build --target wasm32-wasip2`) is answered against this host's
  toolchain: a rustup toolchain carrying EVERY target the step asks for is used
  for that step — selected through the rustup proxy (`RUSTUP_TOOLCHAIN`), so
  `cargo +<toolchain>` keeps working — and when no local toolchain carries them
  the step is SKIPPED with the reason printed (`rustup target add <target>`) —
  never a red step that says nothing about the repo. The toolchain the workflow
  pins wins over another one that merely happens to carry the target. A host
  with no rust toolchain at all is a MISSING TOOLCHAIN, not a missing target:
  the step FAILS, as this script's convention says.
- **`container:`** jobs run on the host toolchain, not in the declared image.
- **`continue-on-error: true`** steps are advisory locally, exactly as in CI.
- **Local-only checkout state.** CI checks out the committed tree; this checkout
  also has gitignored and untracked paths, which whole-tree commands (e.g.
  `dart analyze .`) see. A step that fails naming only such paths is reported as
  a LOCAL-ONLY failure, not as a CI failure — pass `--strict` to count it anyway.
  A step that would `git clone` over a sibling checkout that already exists here
  is skipped; `--allow-outside-clone` forces it.

Canonical copy: `arrrrny/forklift` → `scripts/local_ci.sh` (reference:
`docs/forklift-scripts.md`).
<!-- local-ci:end -->

<!-- test-concurrency:begin -->
## Test concurrency (fleet guard)

Cap test concurrency at **2** — one un-capped `flutter test` fan starved the
shared host's services once (load 260; arrrrny/forklift#176).

There is **no config-file knob for `flutter test`**: it ignores
`dart_test.yaml` entirely (its only test-config file is
`flutter_test_config.dart`, an execution hook), so the flag is the only
lever — and it must be passed every time:

```sh
flutter test --concurrency=2
dart test -j 2
```

A repo whose `dart_test.yaml` carries `concurrency: 2` already defaults to it
for `dart test`; pass the flag anyway when you override it, and never raise
the number on a host that also runs the forklift pool. CI carries the same
flags in `.github/workflows`.
<!-- test-concurrency:end -->

<!-- dependency-bump-rule:begin -->
## Publishing without a dependency bump is a no-op — file the upgrade chore

Before any release, resolve and align the DECLARED constraints to what actually
resolved. What a machine resolves is what it builds: a `pubspec.yaml` saying
`^2.4.3` next to a resolved `2.4.4` only guarantees the next machine resolves
to something else, so the release you just cut is not the release anyone else
gets.

**Repo-specific first — this is a 9-package monorepo, not one pub root.** There
is no root `pubspec.yaml` and no root lockfile; every package resolves on its
own, and `.gitignore` keeps `pubspec.lock` out of the umbrella, `_android`,
`_ios`, `_linux` and `_platform_interface` packages (dart.dev: libraries should
not include `pubspec.lock`). Only seven locks are tracked —
`zikzak_inappwebview/example`, `zikzak_inappwebview_linux/example`,
`zikzak_inappwebview_linux/tool/wire_parity`, and the `_macos`, `_web`,
`_windows`, `_module` packages — so those are the ones whose drift changes what
a builder or the example apps get. Read `PUBLISH.md` and `tool/versions.dart`
before touching any version string.

```bash
cd <package> && rm -f pubspec.lock && flutter pub get   # Flutter, not dart-only
```

Then set the caret constraints to the version the resolver picked — here that
means editing `tool/versions.dart` (the single source of truth for every
published-package version and the key third-party pins), running
`dart run tool/update_readmes.dart`, then letting
`./scripts/prepare_for_publish.sh <version>` propagate the values into the nine
pubspecs and the sub-package changelogs. Never hand-edit a version in a pubspec
or a README.

**Measure the tree that ships, not the dev tree.** In dev mode every package
resolves its siblings through `dependency_overrides:` pointing at this checkout,
so `flutter pub outdated` inside the repo sees the local packages as path deps
and never reports them as upgrades. Run it in the publish state — after
`prepare_for_publish.sh` has stripped `dependency_overrides:` and converted them
to versioned constraints, or in a scratch clone of that branch — because that is
the resolution consumers get. `scripts/publish.sh` already aborts the publish
when `flutter pub get` cannot resolve a package, which is the resolution check
that makes a drifted constraint fail loudly instead of silently.

**Do not raise every constraint to the locked version.** The lockfile is what
this repo builds against; the DECLARED constraint is what consumers resolve. Pub
ignores a dependency's lockfile, and a caret constraint does not pin consumers
to one version. Two things here are deliberate pins, not drift: every package
declares `sdk: >=3.8.0 <4.0.0` and `flutter: >=3.47.0`, and the Flutter floor
is the honest minimum because every zuraffa 7.x (via `zuraffa_session`) needs
`meta ^1.19.0`, which Flutter only allows from 3.47.0 (#393) — a newer local
toolchain is not a reason to move either floor. Align a constraint upward only
when a dependency change actually requires it, and preserve the supported lower
bound otherwise.

**Then look at what is still held back.** `flutter pub outdated` lists every
package whose declared constraint refuses an available upgrade. Those are the
upgrades this release did NOT take.

**The rule:** when a package could be upgraded but was not bumped automatically,
the publish **continues as normal** — do not block the release on it — and you
MUST file a GitHub chore issue for the available upgrades (label it `chore`, the
label `gh-triage` applies to a chore per
`.specify/extensions/gh-triage/gh-triage-config.yml`). A publish that silently
leaves upgrades on the table is not a smaller publish; it is a publish nobody
knows is stale. File the issue with the package names, the current and available
versions, and whether the constraint or a transitive pin is what holds it.

Two corollaries worth remembering:

- **A `flutter pub upgrade` that changes nothing is a signal, not a success.**
  If the constraint blocks the upgrade, bumping the constraint is the fix — and
  that is exactly the chore issue above.
- **Transitive holds are still chore material.** A package held only because a
  dependency pins it is not this repo's constraint to widen, but it is still an
  available upgrade a human should decide on.

This is the fleet rule for every Dart/Flutter repo. This repo's publish flow
already runs the per-package resolve (`scripts/publish.sh`), so it still owes the
chore issue for whatever `flutter pub outdated` reports.
<!-- dependency-bump-rule:end -->
