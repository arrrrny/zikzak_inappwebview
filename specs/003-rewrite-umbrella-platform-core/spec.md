# Feature Specification: Rewrite Umbrella — Thin Platform Core + Zuraffa v6 WebView Module

**Feature Branch**: `003-rewrite-umbrella-platform-core`

**Created**: 2026-08-22

**Status**: Draft

**Input**: GitHub issue #241 (Wave Z umbrella epic). The plugin's value-add surface — network capture, WebViewPool, VCR, dialogue dismissers, recipes, navigation tracking, controllers — has outgrown a platform plugin's remit. The repo is to be split into a two-tier shape: `zikzak_inappwebview` becomes a thin platform core (widget, controller facades, `platform_interface`, native packages — raw APIs only: webview lifecycle, JS eval, cookies, capture-event plumbing), and a new in-repo `zuraffa v6` package `zikzak_inappwebview_module` holds the intelligence (pool, capture management + distillation wiring, VCR, dialogue dismisser, recipes, navigation tracker, session/cookie stores, `ZuraffaUseCases`, generated agent tools). This issue delivers the split map and the module scaffold (the first cut of the umbrella); in-flight feature issues #237 (pool), #238 (VCR), #239 (tools), #240 (intercept) re-home into the module with their specs unchanged. The module must consume ONLY the public plugin API — never `platform_interface` internals.

## User Scenarios & Testing

### User Story 1 - Split map published and reviewed (Priority: P1)

The architecture owner produces an exhaustive split map that assigns every current Dart-side value-add class in `zikzak_inappwebview/lib/src` to either the plugin core (raw plumbing) or the new module (policy, state, intelligence). The map records the seam between the two tiers — the module's ONLY dependency on the plugin is the documented public API surface (widgets, controller facades, headless API, raw capture events). Reviewers can read the map and confirm no value-add class is left unassigned and no module dependency reaches into `platform_interface` internals.

**Why this priority**: The split map is the contract that every downstream decomposition issue (#237–#240, plus the +1/+2 follow-ups) depends on. Until it is merged, no team can safely move code. It is the first deliverable named in the issue.

**Independent Test**: Can be tested by opening the merged split map document and validating it against an automated inventory: every class under `zikzak_inappwebview/lib/src` appears exactly once, and every module-side class's import graph contains no path resolving to `platform_interface` (other than re-exported public facades).

**Acceptance Scenarios**:

1. **Given** the current source tree of `zikzak_inappwebview/lib/src`, **When** the split map is published, **Then** every value-add class (pool, capture manager, VCR, dialogue dismisser, session recipe, navigation tracker, session/cookie stores, use cases, generated tools) is listed with a destination tier.
2. **Given** the split map, **When** a reviewer checks the listed module dependencies, **Then** each dependency path resolves to the plugin's public API (widget/controller/headless/capture-event surface) and none reaches `platform_interface` internals.
3. **Given** the split map is merged, **When** issue #241 is queried, **Then** the map is attached/linked and marked reviewed.

---

### User Story 2 - Module scaffolded via zuraffa v6 package SDK (Priority: P1)

The new `zikzak_inappwebview_module` package is created in-repo (default location `zikzak_inappwebview_module/`) using the zuraffa package tooling (`zfa package create`, from zuraffa#389 package mode). The scaffold follows the zuraffa v6 domain/data/module layout, ships a DI registrar, and registers itself with the engine as a module. The scaffold builds cleanly (`zfa build`) and passes static analysis (`dart analyze`) with no errors.

**Why this priority**: Without a building scaffold, the re-homed feature issues (#237–#240) have nowhere to land and the "hello mission" cannot be demonstrated. It is the second named deliverable and the hard gate for all downstream work.

**Independent Test**: Can be tested by running `zfa build` followed by `dart analyze` in the `zikzak_inappwebview_module` package directory and confirming both exit clean; the package also appears in the repo's package inventory (e.g., `melos`/`pub` workspace) and registers a module with the zuraffa engine.

**Acceptance Scenarios**:

1. **Given** the zuraffa v6 package SDK (zuraffa#389) is available, **When** `zfa package create` is run with the in-repo naming decision, **Then** a `zikzak_inappwebview_module` package is created with the domain/data/module directory layout.
2. **Given** the scaffolded module, **When** its DI registrar and engine module registration are declared, **Then** `zfa build` completes without error and registers the module with the engine.
3. **Given** the scaffolded module, **When** `dart analyze` is run on it, **Then** it reports zero errors and zero warnings.

---

### User Story 3 - Plugin core API freeze and "hello mission" through module APIs (Priority: P2)

The plugin core freezes a stable raw API surface: raw capture events, controller facades (`InAppWebViewController`), and the headless API (`HeadlessInAppWebView`). The module depends only on that frozen surface, so the two tiers version independently. A "hello mission" — browse to a URL and read back the page HTML (`getHtml`) — is implemented purely against module APIs and runs end-to-end on iOS, Android, and macOS.

**Why this priority**: This is the first end-to-end proof that the two-tier seam works in practice and that consumers (e.g., `zik_zak`'s `webview.*` tools, `dws_playground` missions) can be re-pointed to the module. It sits below the scaffold but is the deciding acceptance criterion for the epic.

**Independent Test**: Can be tested by writing a small consumer that imports only `zikzak_inappwebview_module`, executes `browse` → `getHtml` against a test URL, and asserting the returned HTML is non-empty on a real device/simulator for each of iOS, Android, and macOS. The plugin core version can be bumped independently without breaking the module.

**Acceptance Scenarios**:

1. **Given** the frozen core API, **When** a bump to the plugin core occurs, **Then** the module compiles and the `browse`/`getHtml` mission continues to pass without changes to the module's API usage.
2. **Given** a fresh consumer app importing only the module, **When** the "hello mission" is executed, **Then** the page HTML is returned successfully on iOS, Android, and macOS.
3. **Given** the split map's seam rule, **When** the module imports the plugin, **Then** the imports reference only public facades (controller, headless, raw capture event stream) and never `platform_interface` internals.

---

### Edge Cases

- What if zuraffa#389 (package SDK) is not yet released? The scaffold step is blocked; the split map deliverable can still proceed in isolation, and the module package directory is stubbed with a documented dependency pin rather than guessing the API.
- What about in-flight PRs (e.g., #234 domain-delegate split) that touch `platform_interface`? Those land in the core tier and must not reintroduce value-add logic; the grep gate re-validates after they merge.
- What about generated agent tools that depend on both the module and external zuraffa agent surface? They live in the module's agent surface and must not be copied into the plugin core; the grep gate covers `tools`.
- What about the `network_capture` plumbing that the issue explicitly keeps in core? The raw capture event stream stays in core; only the capture management/distillation wiring (state, policy) moves to the module. The grep gate distinguishes the event source from the manager.
- What if a value-add class has a cyclic dependency on a core controller facade? The seam must be inverted: expose a stable facade on the core that the module consumes, rather than the module reaching into internals.
- What about consumers currently importing value-add classes directly from the plugin core (e.g., `session_recipe`, `navigation_tracker`)? The transition plan must document the deprecation/re-export window before removal, so external apps do not break on the next core release.

## Requirements

### Functional Requirements

- **FR-001**: The system MUST produce and merge a split map that assigns every current Dart-side value-add class in `zikzak_inappwebview/lib/src` to exactly one tier (plugin core for raw plumbing, or the module for policy/state/intelligence), with no class left unassigned.
- **FR-002**: The system MUST ensure the module's dependency on the plugin resolves exclusively to the plugin's public API surface (widgets, controller facades, headless API, raw capture-event stream); direct imports of `platform_interface` internals from the module MUST be rejected.
- **FR-003**: The system MUST scaffold a new in-repo package `zikzak_inappwebview_module` via the zuraffa v6 package SDK (`zfa package create`, zuraffa#389) using the domain/data/module layout, including a DI registrar and engine module registration.
- **FR-004**: The system MUST freeze the plugin core's raw API surface — raw capture events, `InAppWebViewController` facades, and the `HeadlessInAppWebView` API — and keep it stable such that the module and core version independently.
- **FR-005**: The system MUST relocate all intelligence-layer code (WebViewPool, capture management + distillation wiring, VCR, dialogue dismisser, session recipes, navigation tracker, session/cookie stores, `ZuraffaUseCases`, generated agent tools) out of the plugin core and into the module.
- **FR-006**: The system MUST provide an automated grep gate that fails if identifiers tied to the intelligence layer (e.g., pool, VCR, dismiss, recipe, tracker, tools) appear in the plugin core package, with an explicit carve-out for the raw capture-event plumbing permitted to remain in core.
- **FR-007**: The system MUST demonstrate a "hello mission" — browse to a URL and read back page HTML via `getHtml` — implemented purely against module APIs that executes successfully on iOS, Android, and macOS.
- **FR-008**: The system MUST document a consumer transition plan that re-points known downstream consumers (e.g., `zik_zak`'s `webview.*` tools, `dws_playground` missions) from the plugin core's value-add classes to the module, and MUST record the naming/location decision (`zikzak_inappwebview_module/` in-repo default).
- **FR-009**: The system MUST re-home in-flight feature issues #237 (pool), #238 (VCR), #239 (tools), and #240 (intercept) into the module, preserving their existing specifications, with their landing zone changed from the plugin core to the module.

### Key Entities

- **Plugin core (`zikzak_inappwebview`)**: The thin platform plugin that remains after the split. Contains the widget, controller facades, `platform_interface`, and native packages. Exposes raw APIs only: webview lifecycle, JS evaluation, cookie management, and raw capture-event plumbing.
- **Module (`zikzak_inappwebview_module`)**: The new in-repo `zuraffa v6` package holding all policy/state/intelligence. Consumes only the plugin's public API. Contains pool, capture management + distillation wiring, VCR, dialogue dismisser, recipes, navigation tracker, session/cookie stores, `ZuraffaUseCases`, and generated agent tools.
- **Split map**: The authoritative artifact listing each value-add class and its destination tier plus the seam contract (module → public plugin API only).
- **Seam / public plugin API**: The frozen surface the module may depend on: widget, `InAppWebViewController` facades, `HeadlessInAppWebView`, and the raw capture-event stream.
- **ZuraffaUseCases**: The module-level orchestration (browse / search / intercept / ...) that wires the intelligence layer and is surfaced as generated agent tools.

## Success Criteria

### Measurable Outcomes

- **SC-001**: A merged, reviewed split map exists that assigns 100% of current Dart-side value-add classes to a tier, with the seam rule (public-plugin-API-only) documented and validated by an import-graph check.
- **SC-002**: `zikzak_inappwebview_module` exists in-repo, builds via `zfa build` with zero errors, and `dart analyze` reports zero errors and zero warnings.
- **SC-003**: The automated grep gate passes for the plugin core package — no intelligence-layer identifiers (pool/VCR/dismiss/recipe/tracker/tools) remain except the explicitly permitted raw capture-event plumbing.
- **SC-004**: The "hello mission" (`browse` → `getHtml`) executed through module-only APIs returns non-empty HTML successfully on iOS, Android, and macOS.
- **SC-005**: The plugin core's raw API surface (raw capture events, controller facades, headless API) is demonstrably stable — a core version bump does not require any change to the module's API usage.
- **SC-006**: A documented consumer transition plan exists that re-points `zik_zak`'s `webview.*` tools and `dws_playground` missions to the module, and the naming/location decision (`zikzak_inappwebview_module/` in-repo) is recorded.
- **SC-007**: Feature issues #237, #238, #239, and #240 are re-homed into the module with their specifications preserved and their landing zone updated.

## Assumptions

- The zuraffa v6 package SDK (zuraffa#389, "package mode") is available and stable enough to scaffold the module; if it is not, FR-003 is blocked until it lands (tracked as a blocking dependency).
- The plugin's existing public facades (`InAppWebViewController`, `HeadlessInAppWebView`, capture-event stream) are sufficient as the seam and can be frozen without breaking current consumers; minor facade additions for the module are permitted but classed as core changes.
- The decomposition detail (clean ports for each extraction, zuraffa-native DDA store/usecase wiring, agent surface + cassette parity) is handled by follow-up issues and is out of scope for this umbrella's first cut beyond the split map and scaffold.
- Downstream consumers (`zik_zak`, `dws_playground`) are willing to re-point their imports to the module per the transition plan; until they do, a deprecation/re-export window is assumed acceptable.
- Raw capture-event plumbing (the event source, not the management/distillation policy) is explicitly permitted to remain in the plugin core and is the singular carve-out from the grep gate.
- The current repository uses a multi-package layout (melos/pub workspace) capable of hosting the new in-repo module package alongside the existing platform packages.
