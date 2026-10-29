# Chore PR: Declare the real Flutter floor (>=3.47.0) and add a resolution guard

- **Slug**: 393-flutter-floor-bump
- **Opened**: 2026-10-29
- **PR**: 404
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/pull/404
- **Branch**: chore/393-flutter-floor-bump
- **Issue**: 393 (already closed as completed — referenced, not auto-closed)

Declares `flutter: ">=3.47.0"` on all 8 publishable packages, moves
`zuraffa_session` to `">=1.2.1 <8.0.0"` (deterministic nocterm-free zuraffa
7.3.0 resolution), adds the `resolve-floor` CI job that resolves the #393
minimal-consumer repro on the declared floor, and refreshes the tracked
lockfiles and AGENTS.md floor docs.
