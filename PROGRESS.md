# zikzak_inappwebview → Zorphy migration — PROGRESS

Goal: migrate the fork's model/entity layer from its custom build_runner codegen
(`@ExchangeableObject` / `@ExchangeableEnum` from `dev_packages/generators`) to
**Zorphy entities** generated via the Zuraffa CLI (`zfa`), making this a
Zuraffa-built plugin — mirroring the vendure-flutter-sdk rewrite (task …2095)
and the zikzak→zuraffa v6 migration (…7545).

## STATUS

**Phase 1 (JS dialogue model family → Zorphy entities) — DONE (PR #218, merged b792cb9e)**
**Phase 2a (ajax_request family → Zorphy entities) — DONE on branch
`feat/migrate-models-zorphy-entities-phase2` (PR pending)**

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

(none — active run)

## LAST ISSUE FILED

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
  Phase 2 sub-phase.
- **zuraffa #349** (2026-08-15): `zfa entity create --allow-forward-refs`
  emits `$X` + a bogus import for external (non-entity) types — plugin model
  migration gap. Minimal repro in the issue body. Workaround used (documented,
  vendure-#272-style fallback): hand-fix the generated source (drop the `$`
  prefix, correct the import). AFFECTS every entity that references a type
  outside `lib/src/domain/entities` (e.g. `WebUri`). Not blocking Phase 1:
  post-generation source fixes are part of the zfa workflow (`_fixEntityImports`
  does the same class of edit); the issue tracks the framework gap for a real
  fix.

## RESUME FROM

Phase 2b — next `types/` family (candidate: fetch_request + network capture
family; recipe + zuraffa #351 patch documented above).

---

## Toolchain (box)

- Flutter **3.47.0** / Dart 3.13.0 at `/opt/flutter` (box shipped with Dart 3.8.1
  only; 3.41.1/Dart 3.11 first installed but the fork's core package
  `synchronized: ^3.4.1` requires Dart >=3.12, so bumped to 3.47.0).
- `zfa` = `dart run /workspace/zuraffa/bin/zuraffa.dart` (v6.0.0, development).
  Not on PATH; run from the target package dir with
  `export PATH=/opt/flutter/bin:$PATH`.
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

### Phase 2b — remaining `types/` value objects + enums (upstream, ~175 files)
TODO list generated from the inventory below (add `[ ]` per file as phases
are carved out; each phase = one cohesive callback family).

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

