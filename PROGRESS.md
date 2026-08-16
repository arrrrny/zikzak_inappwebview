# zikzak_inappwebview → Zorphy migration — PROGRESS

Goal: migrate the fork's model/entity layer from its custom build_runner codegen
(`@ExchangeableObject` / `@ExchangeableEnum` from `dev_packages/generators`) to
**Zorphy entities** generated via the Zuraffa CLI (`zfa`), making this a
Zuraffa-built plugin — mirroring the vendure-flutter-sdk rewrite (task …2095)
and the zikzak→zuraffa v6 migration (…7545).

## STATUS

**Phase 1 (JS dialogue model family → Zorphy entities) — DONE (PR #218, merged b792cb9e)**
**Phase 2a (ajax_request family → Zorphy entities) — DONE (PR #219, merged bc0f757b)**
**Phase 2b (fetch_request family → Zorphy entities) — DONE (PR #220, merged 984bd850)**
**Phase 2c (console_message + web_resource family → Zorphy entities) — DONE (PR #221, merged 18d26075)**
**Phase 2d (permission/safe-browsing family → Zorphy entities) — DONE (PR #222, merged 6f64b60c)**
**Phase 2e (navigation family) — BLOCKED on zorphy_migrator support (zorphy #86)**
**Phase 2e (navigation family → Zorphy via zorphy_migrator) — DONE on branch
`feat/migrate-models-zorphy-entities-phase2e` (not yet merged)**

- Phase 0 (mapping + toolchain) DONE.
- Note on the task premise: this repo does **NOT** use Freezed. Upstream
  flutter_inappwebview dropped Freezed before 4.x; both upstream 4.x and this
  fork generate models with the in-repo `@ExchangeableObject` /
  `@ExchangeableEnum` annotations (`dev_packages/generators`, build_runner).
  "Freezed → Zorphy" is therefore executed as "ExchangeableObject codegen →
  Zorphy entities" — same end state, different starting point. The fork's own
  custom models (e.g. `session_recipe`, `web_uri`) are already hand-written
  plain Dart with toJson/fromJson (no codegen).

## STOPPED AT STEP

**Phase 2e DONE on the branch (not yet merged)** — the full navigation
family was converted with zorphy_migrator (`--apply`), moved to
`domain/entities/`, glued (wire formats incl. platform-native NavigationType
and non-sequential URLRequestNetworkServiceType), barrels + controllers
updated, build + analyze + tests green (see the worklog entry below). Next:
Phase 2f (auth/ssl family — URLAuthenticationChallenge hierarchy, which now
also needs its still-codegen http_authentication_challenge to be converted
since its URLResponse reference was migrated in 2e).

## LAST ISSUE FILED

- **zorphy #86 (2026-08-16)**: `zorphy_migrator` silently no-ops on this
  repo — `@ExchangeableObject`/`@ExchangeableEnum` codegen models are not
  freezed, and the migrator's `FreezedDetector` only resolves
  `package:freezed_annotation` annotations (enums are skipped entirely).
  Whole-`lib/src/types/` run → "Converted classes (0)" + "clean migration",
  exit 0. Control: same tool converts 11 classes on its own smoke fixture.
  Filed per the user's stop rule ("ONLY USE zorphy_migrator; issue → STOP +
  file GitHub issue"); options in the issue: (1) add `@ExchangeableObject`/
  `@ExchangeableEnum` as a second input dialect, (2) at minimum exit non-zero
  on 0 detected classes instead of claiming success.
- **zorphy #349 (RE-OPENED as misfire, 2026-08-15)**: the documented `!Type`
  external field syntax was broken end-to-end in the CURRENT checkouts.
  `zfa entity create --field 'request:!URLRequest'` emitted
  `$!URLRequest get request;` (FieldNormalizer treated `!URLRequest` as a
  type name, found no on-disk entity, added the `$` forward-ref prefix), and
  the builder then misparsed it into a phantom `$` field
  (`required dynamic $`, `Field<..., dynamic>('$', ...)`) — build failed.
  Root cause: the zuraffa-side fix (def7d5f on branch
  `fix/349-external-type-no-dollar-prefix`) was NEVER MERGED, and the zorphy
  half it depends on (`FieldDefinition.isExternal`, "zorphy 05feef3" per the
  Phase 1 note) does NOT exist in zorphy history. PROGRESS.md's earlier
  "FIXED + RELEASED" note was wrong (pool task 070 did not land).
  **FIXED in this run**: zorphy PR #84
  (https://github.com/arrrrny/zorphy/pull/84 — **MERGED 2026-08-15** as 9cfb13f; branch
  `fix/349-external-type-no-dollar-prefix-cli`) — `FieldDefinition.parse`
  strips `!` → `isExternal`, `FieldNormalizer` keeps external types plain,
  `ImportResolver` skips them; regression suite (7 tests) added. The branch
  also carries the #351 (c09d966) + #310 (2d093f1) fixes so zuraffa can
  point at one ref. **zuraffa PR #362** (https://github.com/arrrrny/zuraffa/pull/362, open,
  branch `fix/349-external-type-zorphy-bump`) — merges the original fix/349 content
  (def7d5f + CodeRabbit 154cfa8: validator + `_fixEntityImports` skip
  external fields), fixes the #349 regression test's compile assertion
  (correct relative import + the standard `@JsonKey` glue the migration
  recipe applies to custom types), and bumps the zorphy git ref to
  `fix/349-external-type-no-dollar-prefix-cli`. NOTE: zorphy #84 was merged
  WITHOUT the #351 commit (merge happened at 1bf0d6d) — the #310+#351 fixes
  are now tracked by **zorphy PR #85** (https://github.com/arrrrny/zorphy/pull/85,
  branch `fix/310-351-into-development`, open).
  Verified locally: zfa emits `WebUri? get url;` (no `$`, no bogus imports),
  build_runner resolves the external type (no `InvalidType`), the remaining
  json_serializable ask is the NORMAL custom-type `@JsonKey` glue (documented
  recipe — not a defect).
- **zuraffa #351** (2026-08-15): cross-entity reference defect — when a
  Zorphy entity has a field whose type is ANOTHER Zorphy entity in the same
  package, `zfa build` generates `InvalidType` in the generated class
  (`*.zorphy.dart`) for that field and the build fails at the json_serializable
  stage. Verified in a minimal scratch repro (ParentThing/ChildThing), even
  with the referenced entity's parts already on disk. Also covers the secondary
  finding: `dynamic` fields become `required dynamic this.x` in the generated
  constructor (constructor-shape change). Workaround used (documented,
  #349-style fallback): after `zfa build`, patch the COMMITTED generated
  `*.zorphy.dart` — replace `InvalidType` with the real entity type and drop
  `required`/`?` on `dynamic` params. The `.g.dart` is unaffected (uses the
  per-field `fromJson`/`toJson` glue). LOST on the next regeneration — the
  issue tracks the framework fix. AFFECTS every entity referencing a sibling
  entity (e.g. `AjaxRequest.event`, `FetchRequest.credential`,
  `HttpAuthenticationChallenge.credentials`) — expect this patch in every
  Phase 2 sub-phase. **CARRIED on zorphy PR #84** (c09d966 merged into the
  fix branch — the #351 regression test passes against the local checkout).
- **zuraffa #349** (2026-08-15): `zfa entity create --allow-forward-refs`
  emits `$X` + a bogus import for external (non-entity) types — plugin model
  migration gap. Minimal repro in the issue body. Workaround used (documented,
  vendure-#272-style fallback): hand-fix the generated source (drop the `$`
  prefix, correct the import). AFFECTS every entity that references a type
  outside `lib/src/domain/entities` (e.g. `WebUri`). Not blocking Phase 1:
  post-generation source fixes are part of the zfa workflow (`_fixEntityImports`
  does the same class of edit); the issue tracks the framework gap for a real
  fix. **UPDATE 2026-08-15 (REVISED in Phase 2e): the earlier "FIXED +
  RELEASED" claim was WRONG** — the `!Type` syntax was broken end-to-end in
  the current checkouts (see the new zorphy #349 entry above); now truly
  fixed via zorphy PR #84 + zuraffa PR.
- **zuraffa #351** (2026-08-15, RE-CONFIRMED in Phase 2d): the InvalidType
  defect struck `PermissionRequest.frame` (`FrameInfo?` external ref → the
  generator emitted `required InvalidType this.frame` + `final InvalidType
  frame`); #351 patch re-applied by hand. ALSO re-confirmed that a zorphy
  regeneration of the previously-converted entities reintroduces the defect
  (ajax_request/fetch_request .zorphy.dart regenerated with InvalidType by
  the 05feef3 build — restored from git). The issue tracks the framework fix;
  expect the hand-patch in every phase until it lands.

## RESUME FROM

**Phase 2f (auth/ssl family) — next.** Phase 2e is DONE on the branch
(not yet merged): the navigation family (`navigation_action`,
`navigation_response`, `url_request`, `url_response`, `frame_info`,
`security_origin`, `window_features`, `login_request`,
`create_window_action` flattened + the 6 enums) are Zorphy entities
converted with zorphy_migrator (`dart run
/workspace/zorphy/zorphy_migrator/bin/zorphy_migrator.dart migrate <dir>
--apply --report ...`). Phase 2f scope:
`http_authentication_challenge` (still codegen; its source + .g.dart were
patched in 2e to reference the converted URLResponse — convert together
with the rest), URLAuthenticationChallenge hierarchy
(HttpAuthenticationChallenge/ClientCertChallenge/ServerTrustChallenge),
URLProtectionSpace (+authentication_method/proxy_type enums), URLCredential
(+persistence), HttpAuthResponse (+action), ClientCertResponse (+action),
ServerTrustAuthResponse (+action), SslCertificate, SslError (+type),
should_allow_deprecated_tls_action. NOTE:
render_process_gone_detail + renderer_priority + renderer_priority_policy
are COUPLED to the still-codegen InAppWebViewSettings.g.dart — convert
them with the settings family (Phase 3), not standalone.

---

## Toolchain (box)

- Flutter **3.47.0** / Dart 3.13.0 at `/opt/flutter` (box shipped with Dart 3.8.1
  only; 3.41.1/Dart 3.11 first installed but the fork's core package
  `synchronized: ^3.4.1` requires Dart >=3.12, so bumped to 3.47.0).
- `zfa` = `dart run /workspace/zuraffa/bin/zuraffa.dart` (v6.0.0, development).
  Not on PATH; run from the target package dir with
  `export PATH=/opt/flutter/bin:$PATH`.
  **IMPORTANT (Phase 2e+): the MAIN zuraffa checkout is on branch
  `fix/354-...` (uncommitted user work, NOT touched) and does NOT carry the
  #349 fixes. Run zfa from the fix-branch worktree instead:
  `dart run /workspace/zuraffa-wt/bin/zuraffa.dart` (branch
  `fix/349-external-type-zorphy-bump`, zuraffa PR #362) until that PR merges
  and the main checkout is updated to development. zorphy resolves via the
  target package's dependency_overrides → `/workspace/zorphy` (currently on
  `fix/349-external-type-no-dollar-prefix-cli` — carries #349 + #351 + #310,
  zorphy PR #84).
- zorphy (generator) + zorphy_annotation from `/workspace/zorphy` (development,
  includes the merged autoId + ValueObject work from zuraffa#320/#321).
- Entity output is hardcoded by zfa v6 to `lib/src/domain/entities/<snake>/`
  (zuraffa v5 fixed layout — per zuraffa AGENTS.md "do not invent alternate
  folder structures"). Public API is preserved via the package barrel, which is
  the only import surface consumers use (verified: no deep `src/` imports in
  any package).

## Conversion recipe (per model, validated end-to-end in a scratch package)

1. `zfa entity enum -n <Enum> --value A,B,...` → plain Dart enum.
2. `zfa entity create -n <Name> --kind=value_object --field ...` →
   `lib/src/domain/entities/<name>/<name>.dart` with
   `@Zorphy(kind: ZorphyKind.valueObject, generateJson: true, generateCompareTo: true)`
   abstract `$<Name>` class + `part '<name>.zorphy.dart'; part '<name>.g.dart';`.
3. Post-process the generated source:
   - constructor defaults via `@JsonKey(defaultValue: ...)` on getters
     (zorphy emits non-required params; verified: `JsAlertResponse()` still
     works with the fork's defaults);
   - `@JsonKey(toJson: ..., fromJson: ...)` for non-JSON-native field types
     (e.g. `WebUri`), for enums that must keep the int wire contract
     (`toNativeValue()` ints ↔ `.index`), for STRING-wire enums (native string
     ↔ enum, e.g. `AjaxRequestEventType` "loadstart"↔`LOADSTART`), for
     `Map<String,dynamic>` fields (`.cast<String,dynamic>()` — platform maps
     arrive as `Map<dynamic,dynamic>` and a plain `as` cast throws), and for
     nested sibling entities (`X.fromJson(value as Map)` / `x?.toJson()`);
   - fix imports (WebUri / sibling-entity / external refs) —
     `--allow-forward-refs` skips zfa's on-disk type validation for types
     living outside `lib/src/domain/entities` (e.g. `WebUri`).
4. `zfa build` (runs build_runner: zorphy + json_serializable).
   THEN (zuraffa #351 workaround): patch the committed generated
   `*.zorphy.dart` — replace `InvalidType` → real sibling-entity type (incl.
   the `Field<X, InvalidType>`/`static InvalidType _$x` accessors — make them
   nullable like the field), and drop `required` (+ optional `?`) from
   `dynamic` constructor params. Restore any `.g.dart` files the
   `--delete-conflicting-outputs` pass removed (only the ones NOT being
   deleted by the migration: `git checkout --` everything except the current
   family's old files).
5. Delete the old `@ExchangeableObject` source + its `.g.dart` from
   `lib/src/types/`; update barrels (`types/main.dart` + root main.dart) to
   re-export the entity with the SAME public class name.
6. Glue (manual by design — "platform channels stay manual"): replace
   `X.fromMap(m)!` → `X.fromJson(m)` and `?.toMap()` → `?.toJson()` in the
   platform controllers; enum native-value translation via the per-field
   `toJson`/`fromJson` glue in step 3. Watch out for `jsonEncode(callback())`
   return paths (an extension `toJson` is invisible to `jsonEncode` — wrap as
   `jsonEncode((await cb())?.toJson())`) and for callback return values sent
   back over the channel (`?.toNativeValue()` → `?.index` for int enums;
   string-wire enums need a small switch helper).

### Public-API invariants preserved
- Same public class/enum names, same fields (now final — verified no field
  mutation of the converted classes anywhere in the repo).
- Same constructor call shapes (defaults preserved via `@JsonKey(defaultValue:)`).
- Same JSON wire format: map keys unchanged; enums still serialize as ints
  (`.index` == old `_nativeValue` for this family), `WebUri` as `toString()`.
- `fromMap`/`toMap` → `fromJson`/`toJson` (json_serializable; null-tolerant
  `fromJson` reproduces the fork's missing-key-default behavior). `copyWith`,
  `==`, `hashCode`, `compareTo` are ADDED surface (improvements, no removals).

---

## Migration map — all model/enum files

Total: **105 `@ExchangeableObject` classes + 94 `@ExchangeableEnum` enums**,
all in `zikzak_inappwebview_platform_interface`. Other packages define no
models (they consume via the barrel).

Legend: `[ ]` pending · `[~]` in progress · `[x]` converted · `[–]` skip/fork

### Phase 1 — JS dialogue family (value objects + action enums)
- [x] `types/js_alert_request.dart` → `JsAlertRequest` (lib/src/domain/entities/js_alert_request/)
- [x] `types/js_alert_response.dart` → `JsAlertResponse`
- [x] `types/js_confirm_request.dart` → `JsConfirmRequest`
- [x] `types/js_confirm_response.dart` → `JsConfirmResponse`
- [x] `types/js_prompt_request.dart` → `JsPromptRequest`
- [x] `types/js_prompt_response.dart` → `JsPromptResponse`
- [x] `types/js_before_unload_request.dart` → `JsBeforeUnloadRequest`
- [x] `types/js_before_unload_response.dart` → `JsBeforeUnloadResponse`
- [x] `types/js_alert_response_action.dart` → `JsAlertResponseAction` (enum)
- [x] `types/js_confirm_response_action.dart` → `JsConfirmResponseAction` (enum)
- [x] `types/js_prompt_response_action.dart` → `JsPromptResponseAction` (enum)
- [x] `types/js_before_unload_response_action.dart` → `JsBeforeUnloadResponseAction` (enum)

### Phase 2a — ajax_request family (network capture callbacks)
- [x] `types/ajax_request.dart` → `AjaxRequest` (lib/src/domain/entities/ajax_request/)
- [x] `types/ajax_request_action.dart` → `AjaxRequestAction` (enum, int wire)
- [x] `types/ajax_request_event.dart` → `AjaxRequestEvent` (string-enum wire glue)
- [x] `types/ajax_request_event_type.dart` → `AjaxRequestEventType` (enum, string wire)
- [x] `types/ajax_request_headers.dart` → `[–]` skip/fork: mutable-by-design with
      method surface (`getHeaders`/`setRequestHeader`) + wire = accumulated new
      headers; Zorphy value objects cannot express it. Rewritten as plain Dart
      (codegen wrapper dropped, public API/wire identical).
- [x] `types/ajax_request_ready_state.dart` → `AjaxRequestReadyState` (enum, int wire)

### Phase 2b — fetch_request family (network fetch interception)
- [x] `types/fetch_request.dart` → `FetchRequest` (lib/src/domain/entities/fetch_request/)
- [x] `types/fetch_request_action.dart` → `FetchRequestAction` (enum, int wire)
- [x] `types/fetch_request_credential.dart` + default/federated/password → `[–]`
      skip/hierarchy: polymorphic base + subclasses dispatching on the wire
      `type` key; Zorphy value objects cannot express inheritance. Rewritten as
      plain Dart (codegen wrappers dropped, public API/is-a/wire identical);
      `FetchRequest.credentials` typed `FetchRequestCredential?` via custom
      fromJson/toJson dispatcher glue in the entity.

### Phase 2c — console_message + web_resource family (webview resource callbacks)
- [x] `types/console_message.dart` → `ConsoleMessage` (lib/src/domain/entities/console_message/)
- [x] `types/console_message_level.dart` → `ConsoleMessageLevel` (enum, int wire)
- [x] `types/web_resource_error.dart` → `WebResourceError`
- [x] `types/web_resource_error_type.dart` → `WebResourceErrorType` (enum,
      string wire == enum name, 62 values)
- [x] `types/web_resource_request.dart` → `WebResourceRequest` (WebUri + Map
      String,String glue)
- [x] `types/web_resource_response.dart` → `WebResourceResponse` (Uint8List
      data glue: typed-list pass-through on the channel, List<int> on JSON
      paths)
- [x] network capture family (`network_request`/`network_entry`/
      `network_response`/`network_response_body`/`resource_type`/
      `url_pattern_type`) → `[–]` skip: already hand-written plain Dart with
      ZERO codegen dependency (verified: no internal_annotations import, no
      `.g.dart`), and stateful/mutable by design (NetworkResponseBody lazy
      decode cache, NetworkEntry accumulator semantics, mutable NetworkRequest
      fields) — not pure value types; Zorphy value objects cannot express
      them. Same category as AjaxRequestHeaders (documented skip).

### Phase 2d — permission/safe-browsing family (permission + safe-browsing callbacks)
- [x] `types/permission_request.dart` → `PermissionRequest` (lib/src/domain/entities/permission_request/; WebUri + sibling-enum native-value list + external `FrameInfo?` glue — #349 import fixes)
- [x] `types/permission_resource_type.dart` → `PermissionResourceType` (enum, PLATFORM-DEPENDENT native wire: android `android.webkit.resource.*` strings / iOS-macOS `WKMediaCaptureType` raw values — replicated via `defaultTargetPlatform` switch helpers)
- [x] `types/permission_response.dart` → `PermissionResponse` (native-value resource list + int-wire action; defaults `resources = const []`, `action = DENY`)
- [x] `types/permission_response_action.dart` → `PermissionResponseAction` (enum, int wire)
- [x] `types/safe_browsing_response.dart` → `SafeBrowsingResponse` (defaults `report = true`, `action = SHOW_INTERSTITIAL`)
- [x] `types/safe_browsing_response_action.dart` → `SafeBrowsingResponseAction` (enum, int wire)
- [x] `types/safe_browsing_threat.dart` → `SafeBrowsingThreat` (enum, int wire)
- [x] `types/geolocation_permission_show_prompt_response.dart` → `GeolocationPermissionShowPromptResponse` (WebUri glue; default `retain = false`)

### Phase 2e — navigation family (navigation/URL/security callbacks; scoped 2026-08-15)
Value objects (10): `navigation_action` (→URLRequest, NavigationType, FrameInfo×2),
`navigation_response` (→URLResponse), `url_request` (→WebUri, 3 enums),
`url_response` (→WebUri), `frame_info` (→URLRequest, SecurityOrigin),
`security_origin`, `window_features`, `login_request`, `create_window_action`
(EXTENDS NavigationAction — zorphy `--extends`/implements; wire-format
verified in scratch; flattened super-fields on the wire, concrete class
`implements` the abstract), `http_authentication_challenge` + auth group
(URLAuthenticationChallenge hierarchy: HttpAuthenticationChallenge /
ClientCertChallenge / ServerTrustChallenge EXTENDS URLAuthenticationChallenge;
URLProtectionSpace →SslCertificate/SslError/X509Certificate; URLCredential;
HttpAuthResponse/ClientCertResponse/ServerTrustAuthResponse + action enums)
— CARVED OUT as Phase 2f (auth/ssl family), NOT part of 2e.
Enums (6, int wire unless noted): `navigation_action_policy`, `navigation_response_action`,
`navigation_type` (STRING wire + platform-dependent native values — needs the
defaultTargetPlatform switch helper like PermissionResourceType),
`url_request_cache_policy`, `url_request_network_service_type`, `url_request_attribution`.
Stragglers converted together (they reference URLRequest_/URLResponse_):
`create_window_action` (in 2e), `http_authentication_challenge` (in 2f).
- [x] navigation_action / navigation_action_policy / navigation_response /
      navigation_response_action / navigation_type
- [x] url_request (+3 enums) / url_response / frame_info / security_origin
- [x] window_features / login_request / create_window_action (extends)
- [x] barrels + android/ios/macos/linux glue (fromMap→fromJson etc.)
- [x] regression test test/types/navigation_entities_test.dart
- [x] analyze + test all touched packages

### Phase 2f — auth/ssl family: URLAuthenticationChallenge hierarchy
(HttpAuthenticationChallenge/ClientCertChallenge/ServerTrustChallenge),
URLProtectionSpace (+authentication_method/proxy_type enums), URLCredential
(+persistence), HttpAuthResponse (+action), ClientCertResponse (+action),
ServerTrustAuthResponse (+action), SslCertificate, SslError (+type),
should_allow_deprecated_tls_action. (Scoped; not started.)

### Phase 3 — browser/settings objects (`in_app_browser/`, `in_app_webview/`,
`chrome_safari_browser/`, `print_job/`, `pull_to_refresh/`, `context_menu/`,
`web_storage/`, `web_message/`, `web_authentication_session/`,
`webview_environment/`, controllers)

### Phase 4 — fork-custom models (session_recipe, web_uri, navigation_tracker,
dialogue_dismisser — hand-written toJson/fromJson today → Zorphy, core package)

---

## Phase 1 checklist (this run)

- [x] Investigate repo, install toolchain, validate zfa recipe in scratch
- [x] platform_interface: pubspec (zorphy_annotation, zorphy, json_serializable) + build.yaml (zorphy builder, scoped to domain/entities)
- [x] zfa: create 4 action enums + 8 value objects
- [x] Post-process entities (defaults, WebUri/enum glue, imports)
- [x] Delete old sources/.g.dart; update `types/main.dart` barrel
- [x] Glue: android/ios/macos controllers `fromMap`→`fromJson`, `toMap`→`toJson`
- [x] `zfa build` in platform_interface (then restore untouched `.g.dart` from git)
- [x] Add public-API regression test for the converted family (test/types/js_dialogue_entities_test.dart)
- [x] `flutter analyze` + `flutter test` green on all touched packages (Flutter 3.47.0/Dart 3.13):
      platform_interface 2616 issues vs baseline 2650 (0 errors; 1 pre-existing warning; tests 35/35),
      android 0 errors/0 warnings, ios 0 errors/0 warnings, macos No issues (tests 35/35),
      linux 4 infos, web No issues, windows No issues (tests 13/13), core 21 infos (tests 95/95).
      Analyzed/tested against the LOCAL converted platform_interface via untracked
      pubspec_overrides.yaml (removed before commit; not part of the PR).
- [x] Commit, PR, complete task

## Worklog

- 2026-08-15 — Investigation. Box had no Flutter SDK (only Dart 3.8.1); installed
  Flutter 3.41.1 (Dart 3.11.0) at /opt/flutter to satisfy zuraffa `^3.11.0`.
  zfa v6.0.0 runs via `dart run /workspace/zuraffa/bin/zuraffa.dart`. Confirmed:
  no Freezed in repo; models are @ExchangeableObject (105) + @ExchangeableEnum
  (94), all in platform_interface. Validated in `/workspace/scratch_zfa` that a
  value object generated by zfa preserves the fork's constructor defaults via
  `@JsonKey(defaultValue:)`, that `fromJson` is missing-key tolerant, that the
  generated class does not extend `$X` (so statics like `fromMap` cannot be
  inherited — hence fromJson/toJson glue), and that extension statics are not
  callable via the type name (verified with a Dart snippet).
- 2026-08-15 — Branch `feat/migrate-models-zorphy-entities` created off
  development. PROGRESS.md written.
- 2026-08-15 — Phase 1 executed: platform_interface wired (zorphy_annotation
  path dep + zorphy/json_serializable dev deps + build.yaml scoped to
  lib/src/domain/entities/**); 4 action enums + 8 value objects generated via
  zfa; sources post-processed (@JsonKey defaults + WebUri/enum fromJson/toJson
  glue); old sources deleted; types/main.dart re-exports the entities;
  android/ios/macos controllers switched `X.fromMap(arguments)!` →
  `X.fromJson(arguments)` and `?.toMap()` → `?.toJson()`. Added regression test
  `test/types/js_dialogue_entities_test.dart` (constructor defaults, wire
  format, null-tolerance, enum ints, WebUri round-trip). platform_interface:
  flutter test 35/35 green; analyze 0 errors/0 warnings.
- 2026-08-15 — Build gotcha discovered (documented): `zfa build`'s
  `build_runner` deletes the fork's checked-in @ExchangeableObject `.g.dart`
  files (json_serializable claims the same `.g.dart` extension; the
  `--delete-conflicting-outputs` pass cleans them even though the generator
  builder is not active). Recipe: after each `zfa build`, restore the
  untouched `.g.dart` from git
  (`git checkout -- zikzak_inappwebview_platform_interface/lib/src` — careful:
  also reverts tracked edits; restore only `**/*.g.dart`). Also: barrel
  `show X` hides zorphy's generated `XSerialization` extension (which carries
  `toJson`), so the entity exports list `show X, XSerialization`.
- 2026-08-15 — zuraffa #349 filed (external-type reference gap).
- 2026-08-15 — Toolchain bump: the fork's core package `synchronized: ^3.4.1`
  requires Dart >=3.12, so Flutter 3.41.1 (Dart 3.11) cannot resolve the core
  package. Installing Flutter 3.47.0 (Dart 3.13) at /opt/flutter and re-running
  the full verification chain.
- 2026-08-15 — Phase 1 SHIPPED: PR #218
  (https://github.com/arrrrny/zikzak_inappwebview/pull/218) merged into
  development as b792cb9e (squash). Verification on the merged state:
  platform_interface analyze 0 errors (2616 vs 2650 baseline), flutter test
  35/35; android/ios/macos/linux/web/windows/core analyze clean (0 errors/0
  warnings); core 95/95, macos 35/35, windows 13/13 tests green. Toolchain:
  Flutter 3.47.0 / Dart 3.13.0 at /opt/flutter. Next phase: see the Phase 2
  list at the top of this file.
- 2026-08-15 — Phase 2a (ajax_request family) executed on branch
  `feat/migrate-models-zorphy-entities-phase2` (off development): 3 value
  objects + 3 enums generated via zfa; `AjaxRequestHeaders` handled as
  skip/fork (plain Dart rewrite, codegen wrapper dropped). Post-processed:
  int-enum glue (`.index`), string-enum glue (`AjaxRequestEventType`),
  WebUri glue (×2), nested `AjaxRequestEvent` + `AjaxRequestHeaders` glue,
  `Map<String,dynamic>` cast glue, `action` default via
  `@JsonKey(defaultValue: PROCEED)`. Old sources deleted; barrels re-export
  entities. Glue in android/ios controllers: `fromMap`→`fromJson`,
  `?.toNativeValue()`→`?.index` (both onAjax* callbacks return
  `AjaxRequestAction` — int wire), `jsonEncode(await cb())`→
  `jsonEncode((await cb())?.toJson())` (extension toJson is invisible to
  dart:convert jsonEncode).
- 2026-08-15 — NEW zuraffa defect discovered + filed as **#351**: cross-entity
  references (`AjaxRequest.event: AjaxRequestEvent`) generate `InvalidType` in
  the built `*.zorphy.dart` and fail the build; `dynamic` fields become
  `required dynamic` ctor params. Minimal repro in issue (scratch
  ParentThing/ChildThing). Workaround (documented in the recipe above):
  patch the committed generated part after `zfa build` (`InvalidType` →
  sibling entity type incl. `Field<...>`/`_$x` accessors; drop `required` on
  `dynamic` params). Verified green: platform_interface 0 errors/0 warnings,
  flutter test 45/45 (incl. new test/types/ajax_request_entities_test.dart);
  android/ios/macos/web/windows No issues; linux 4 pre-existing infos; core
  0 errors (21 infos).
- 2026-08-15 — Phase 2b (fetch_request family) executed on branch
  `feat/migrate-models-zorphy-entities-phase2b` (off development): 1 value
  object (`FetchRequest`) + 1 enum (`FetchRequestAction`, int wire) generated
  via zfa; the 4-file polymorphic credential hierarchy
  (`FetchRequestCredential` + default/federated/password) handled as
  skip/hierarchy (plain Dart rewrites — codegen wrappers + their `.g.dart`
  dropped; public API/is-a/wire identical; dispatched on the wire `type` key).
  Post-processed: WebUri glue, `Map<String,dynamic>` cast glue, string-wire
  `ReferrerPolicy` glue (via the still-codegen `ReferrerPolicy.fromNativeValue`/
  `toNativeValue`), polymorphic credentials dispatcher (`_credentialsFromJson`),
  `action` default via `@JsonKey(defaultValue: PROCEED)`; #349 import fixes
  (`$WebUri`/`$FetchRequestCredential`/`$ReferrerPolicy` → real imports) and
  the #351 patch on the generated `.zorphy.dart` (`InvalidType` ×2 →
  `FetchRequestCredential?`/`ReferrerPolicy?` incl. `Field<...>`/`_$x`
  accessors + copyWith/patch; drop `required` on `body`). Old sources +
  `.g.dart` deleted; barrels re-export entities. Glue in android/ios
  controllers: `fromMap`→`fromJson`, `jsonEncode(await cb())` →
  `jsonEncode((await cb())?.toJson())`. Added test
  `test/types/fetch_request_entities_test.dart` (defaults, wire format,
  null-tolerance, polymorphic credential round-trip, int enum values, copyWith,
  credential hierarchy public API/is-a). Verified green: platform_interface
  analyze 0 errors / flutter test 53/53; android 0 errors, ios 0 errors, core
  0 errors. PR #220 merged 984bd850.
  ALSO resolved the "mystery analysis_options writer": it is the Flutter SDK
  built-in `AnalysisOptionsMigration` (flutter_tools project.dart →
  ensureReadyForPlatformSpecificTooling), which appends the analyzer
  `exclude:` block on flutter analyze/test when the package lacks it —
  harmless, reverted before commit (not part of the PRs).
- 2026-08-15 — Phase 2c (console_message + web_resource family) executed on
  branch `feat/migrate-models-zorphy-entities-phase2c` (off development):
  `ConsoleMessage`/`WebResourceError`/`WebResourceRequest`/`WebResourceResponse`
  value objects + `ConsoleMessageLevel` (int wire) + `WebResourceErrorType`
  (string wire == name, 62 values) generated via zfa — this build resolved ALL
  external types cleanly (no `$` prefixes, no InvalidType, no `required
  dynamic`; Uint8List + Map<String,String> + WebUri all correct in the
  generated constructor). Old sources + `.g.dart` deleted; barrels re-export
  entities; direct import in platform_webview_asset_loader.dart re-pointed to
  the entity. Controller glue: android/ios (onReceivedError, onReceivedHttpError,
  onConsoleMessage, onLoadResourceWithCustomScheme, shouldInterceptRequest —
  fromMap→fromJson, `?.toMap()`→`?.toJson()`), android service_worker
  controller, android webview_asset_loader, macos + linux
  (`WebResourceErrorType`/`ConsoleMessageLevel` native-value translations via
  firstWhere on enum name/index). Old upstream console_message_test.dart ported
  fromMap→fromJson (intent preserved); new web_resource_entities_test.dart
  (wire, Uint8List jsonEncode smoke, round-trips). Verified: platform_interface
  0 errors / 58/58; android/ios/macos/linux/web/windows/core all 0 errors.
  Network capture family classified as documented skip (see migration map).
- 2026-08-15 — NOTE on the task lifecycle: task …8103 (this migration) was
  marked `done` by the pool at 10:18 UTC after Phase 2a merged (result
  prUrl=#218). The work continues as documented here (RESUME FROM); updates
  are posted to the same task feed via r.sh --update.
- 2026-08-15 — RESOLVED box quirk (was "mystery writer"): the identical 8-line
  analyzer `exclude:` block (build/**/android/**/ios/**/web/**/windows/**/macos/**/linux/**)
  appended to package `analysis_options.yaml` files is the **Flutter SDK's
  built-in `AnalysisOptionsMigration`** (`flutter_tools` project.dart →
  `ensureReadyForPlatformSpecificTooling`, triggered by `flutter analyze`/
  `test` on packages lacking the excludes). Reproduced empirically (analyze
  rewrote the file; verified the SDK source). It is harmless, official SDK
  output, but NOT part of the migration PR — revert before committing with
  `git checkout HEAD -- <pkg>/analysis_options.yaml` (the Phase 2a run
  reverted it the same way). Future phases: expect it after any flutter
  command; revert or keep at your discretion, but keep the PR diff scoped.
- 2026-08-15 — Phase 2b + 2c merged into development: PR #220 (984bd850) and
  PR #221 (phase2c rebased onto the merged development; PROGRESS.md conflict
  resolved). Task resumed at 10:47 UTC.

- 2026-08-15 — Task resumed (10:47Z). Merged Phase 2b + 2c into development:
  PR #220 (984bd850) via gh squash; PR #221 rebased (PROGRESS.md + enums
  index conflict resolved), merged as 18d26075.
- 2026-08-15 — Phase 2d (permission/safe-browsing family) executed on branch
  `feat/migrate-models-zorphy-entities-phase2d` (off development): 4 value
  objects (PermissionRequest / PermissionResponse / SafeBrowsingResponse /
  GeolocationPermissionShowPromptResponse) + 4 enums (PermissionResourceType /
  PermissionResponseAction / SafeBrowsingThreat / SafeBrowsingResponseAction)
  created via zfa. Post-processed: WebUri glue (×2), external FrameInfo?
  glue + #349 import fixes (permission_request), sibling-enum NATIVE-VALUE
  wire glue (PermissionResourceType — platform-dependent: android
  `android.webkit.resource.*` strings / iOS-macOS WKMediaCaptureType raw
  values; replicated with defaultTargetPlatform switch helpers in both
  permission_request + permission_response), int-enum glue (action/report/
  retain defaults via @JsonKey defaultValue → generated ctor defaults). Old
  sources + .g.dart deleted; barrels re-export entities. Controller glue:
  android + ios onSafeBrowsingHit (SafeBrowsingThreat.fromNativeValue →
  index-range lookup), onPermissionRequest / onPermissionRequestCanceled
  (fromMap→fromJson), onGeolocationPermissionsShowPrompt + callback returns
  `?.toMap()`→`?.toJson()`. New test
  test/types/permission_safe_browsing_entities_test.dart (defaults, wire
  format per platform via debugDefaultTargetPlatformOverride, null-tolerance,
  round-trips, int enum indices, unknown-native drop). Verified green:
  platform_interface analyze 0 errors (2 pre-existing warnings in
  ajax_request.zorphy.dart — committed state, not this PR) / tests 85/85;
  android 0 errors, ios 0 errors, macos No issues (tests 35/35), linux 4
  infos, web/windows No issues, core 0 errors (tests 95/95). Analyzed/
  tested against the local platform_interface via untracked
  pubspec_overrides.yaml (removed before commit).
- 2026-08-15 — TOOLCHAIN/TASK-070 INTERACTION (documented for future phases):
  zuraffa issue #349's fix task (pool task 070, `fix/349-external-type-
  no-dollar-prefix`) was running CONCURRENTLY in this box while Phase 2d
  built. Its WIP edits to /workspace/zuraffa broke the zfa CLI compile
  mid-run (unescaped `$` in the help string) and the zorphy generator got a
  new commit (05feef3 `!Type` prefix) WHILE the build was running. Handling:
  (1) never touched /workspace/zuraffa or /workspace/zorphy (another task's
  files); (2) ran the identical build pipeline directly
  (`dart run build_runner build`, which is exactly what `zfa build` wraps)
  instead of the broken CLI; (3) waited for task 070 to complete (11:19Z)
  before final verification. The #349 fix landed (zuraffa def7d5f + zorphy
  05feef3). ALSO: the zorphy regeneration REINTRODUCED the #351 InvalidType
  defect into the previously-patched ajax_request/fetch_request .zorphy.dart
  (confirmed: #351 "LOST on the next regeneration"); restored the committed
  patched files via git checkout. And a build_runner gotcha: `dart run
  build_runner build` can HANG indefinitely (event-loop idle, zero CPU) on a
  stale build-script cache after an interrupted run — fix:
  `dart run build_runner clean` first, then rebuild (the fresh run completed
  in 44s). Also restored the ~40 checked-in @ExchangeableObject .g.dart files
  the build deleted (they are claimed by no active builder; restore
  everything except the current family's old .g.dart via git checkout).
- 2026-08-15 — Task resumed (Phase 2d merged as 6f64b60c). Started Phase 2e
  (navigation family) on branch `feat/migrate-models-zorphy-entities-phase2e`
  (off development). FIRST BLOCKING MISFIRE hit on the very first zfa call:
  `zfa entity create --field 'request:!URLRequest'` emitted
  `$!URLRequest get request;` + a phantom `$` field (`required dynamic $`),
  and `zfa build` failed. STOPPED per goal rule; diagnosed: the `!Type`
  external marker fix was never actually merged anywhere (zuraffa def7d5f
  sits on unmerged branch `fix/349-external-type-no-dollar-prefix`; zorphy
  "05feef3" does not exist in history). Fixed zorphy first (PR #84,
  `fix/349-external-type-no-dollar-prefix-cli`): FieldDefinition.parse
  strips `!` → isExternal, FieldNormalizer keeps external types plain,
  ImportResolver skips them; 7 regression tests; branch also carries the
  #351 (c09d966) + #310 (2d093f1) fixes (single ref for zuraffa). Then
  zuraffa (worktree `zuraffa-wt`, branch `fix/349-external-type-zorphy-bump`,
  main checkout's uncommitted fix/354 work untouched): merged the original
  fix/349 content, fixed the #349 compile regression test (correct relative
  import path + the standard @JsonKey glue the recipe applies — the
  framework contract is: type resolves, no InvalidType, no `$`; json_serializable
  still needs the documented custom-type glue), bumped zorphy git ref. All
  #349 + #351 regression tests green. Scratch verified end-to-end: plain
  `WebUri? get url;` + build_runner resolves the external type. PROGRESS.md
  updated; zikzak branch parked with no code changes (framework-wait).
- 2026-08-15 — Framework-wait continues: zuraffa #362 + zorphy #85 still OPEN
  (no merge notification). Verified #85's CI failures are the pre-existing
  "Fixture not generated" gap (also red on the merged #84) — fixed zorphy CI
  (dart.yml: analyzer_compat now builds example/ fixtures before dart test,
  commit 63f4a89 on the #85 branch). Deploy job failure is branch-secret
  related (same on #84, merged anyway). Phase 2e/2f inventories scoped in
  the migration map. Waiting on the user's merge; resume point unchanged.
- 2026-08-16 — Framework-wait resolved: zorphy #85 merged into development
  (7e37246, #351 + #310) and zuraffa #362 merged (ff9365f, `!Type` support)
  — zfa is fully usable again. BUT the user's goal directive changed the
  migration tool: "ONLY USE zorphy_migrator; if there is an issue or it does
  not intuitively solve the problem, STOP and report a GitHub issue on
  zorphy". Tested zorphy_migrator 2.0.0 against the repo: whole
  `lib/src/types/` tree → "Converted classes (0)" + "Needs manual attention
  (0)" + "clean migration", exit 0 (report in /tmp/mig_report_zikzak.md).
  Root cause: FreezedDetector only resolves `package:freezed_annotation`
  annotations; the repo has zero freezed usage (grep -rli freezed → only
  PROGRESS.md; 91 files still `@ExchangeableObject`; 94 `@ExchangeableEnum`
  enums — which the migrator skips entirely, it only scans ClassDeclaration).
  Control: the tool converts 11 classes on its own test/fixtures/smoke.
  STOPPED per the directive; filed **zorphy #86**
  (https://github.com/arrrrny/zorphy/issues/86) with repro + sample source +
  two options (add @ExchangeableObject/@ExchangeableEnum dialect; exit
  non-zero on 0 detected). PROGRESS.md updated; branch still has no code
  changes. Reverted the incidental analysis_options.yaml SDK rewrite from
  `flutter pub get`. Next: user decides — extend zorphy_migrator (zorphy
  repo) or fall back to the zfa recipe.
- 2026-08-16 — Implemented zorphy_migrator support for the
  `@ExchangeableObject`/`@ExchangeableEnum` dialect (zorphy issue #86,
  option 1) on branch `feat/86-exchangeable-dialect-migrator` (commit
  8296e3a, PR https://github.com/arrrrny/zorphy/pull/87): new
  `ExchangeableDetector` (resolved-AST, annotation-name match — works
  without the fork's internal-annotations package), dialect-aware
  `ZorphyRenderer` (value objects → `@Zorphy(kind: ZorphyKind.valueObject,
  generateJson: true, generateCompareTo: true)` entities; class-based enums
  → plain Dart enums; `_` suffix stripped; `= expr` ctor defaults →
  `@JsonKey(defaultValue:)`; sibling refs `URLRequest_` → `URLRequest`;
  field/member doc comments preserved; `@SupportedPlatforms` metadata
  dropped), manual reporting for custom ctors/methods/fields + enum wires
  that don't map onto a plain enum, and a 0-detected warning + exit 1 (no
  more silent "clean migration" no-op). 23/23 tests green incl. the freezed
  e2e; verified in dry-run on the repo's `lib/src/types/`: 95 models
  converted, 161 manual items (all legitimate), zero silent misses;
  navigation family spot-checks correct (incl. `CreateWindowAction_ extends
  NavigationAction_` → flattened value object, matching the fork wire
  format). Next slice: Phase 2e migration via `zorphy_migrator --apply` +
  the documented repo-side glue.
- 2026-08-16 — Phase 2e EXECUTED via zorphy_migrator (the new
  `@ExchangeableObject`/`@ExchangeableEnum` dialect, zorphy PR #87): ran
  `zorphy_migrator migrate lib/src/types --apply` (all 15 navigation-family
  files converted; sibling `_`-suffix stripping, defaults → @JsonKey, docs
  preserved), moved the 9 value objects to
  `lib/src/domain/entities/<name>/<name>.dart` and the 6 enums to
  `domain/entities/enums/` (git mv), fixed imports (zorphy_annotation +
  relative entity paths; dropped internal_annotations/platform_webview/
  foundation), added the `.zorphy.dart` parts, deleted the 15 old family
  `.g.dart`, re-exported the family from `types/main.dart` (+ enums in
  `enums/index.dart`), and glued the wire formats in the entity sources:
  WebUri ↔ toString, Map cast, Uint8List typed-list, int enums ↔ `.index`,
  URLRequestNetworkServiceType ↔ its NON-sequential wire
  [0,2,3,4,6,8,9,11], NavigationType ↔ platform-native switch
  (iOS/macOS WKNavigationType raw values, Windows WebView2 kinds, null on
  Android — replicated like PermissionResourceType), sibling entities via
  nested fromJson/toJson. Cross-phase fix: permission_request's FrameInfo
  glue now uses the converted entity, and the still-codegen
  http_authentication_challenge (Phase 2f) source + .g.dart now reference
  `URLResponse`/`fromJson`/`toJson`. Controller glue: android/ios/macos/
  linux — `X.fromMap()` → `X.fromJson()` (+ `!` drops), `toMap` → `toJson`,
  `NavigationActionPolicy/NavigationResponseAction.toNativeValue()` →
  `.index` (incl. the macos test file). Build: `dart run build_runner
  build` — ZERO InvalidType (the merged #351 fix works with the migrator's
  plain sibling refs); restored the build-deleted still-codegen `.g.dart`
  (types/ + other dirs) and the regenerated-but-out-of-scope .zorphy.dart
  (ajax/fetch/permission — reverted). Verified: platform_interface analyze
  0 errors (2353 issues baseline) + tests 98/98 (incl. the new
  test/types/navigation_entities_test.dart: defaults, wires incl.
  platform-native NavigationType via debugDefaultTargetPlatformOverride,
  non-sequential service-type wire, Uint8List, round-trips, copyWith);
  android/ios/macos/linux/windows/web/core analyze 0 errors (macos/windows/
  web No issues); core 95/95, macos 35/35 (updated policy `.index` test),
  windows 13/13. Analyzed/tested via untracked pubspec_overrides.yaml
  (removed before commit). Branch has the full Phase 2e change set; NOT yet
  merged — PR to follow.
