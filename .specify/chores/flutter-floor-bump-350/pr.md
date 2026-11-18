# Chore PR: Raise the Flutter floor to 3.50.0 (fixes #331 on iOS)

- **Slug**: flutter-floor-bump-350
- **Opened**: 2026-11-18
- **PR**: 453
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/pull/453
- **Branch**: chore/flutter-floor-bump-350
- **Issue**: 331 (Closes #331 — the upstream engine fix shipped in 3.50.0; this PR adopts it by raising the floor)
- **Base**: master

Raises `flutter:` to `>=3.50.0` on all 10 packages, moves the `resolve-floor` CI
job (name + pin + probe Dart 3.14.0) and the `build-linux` bootstrap pin to
3.50.0, updates AGENTS.md + both READMEs (removing the now-obsolete #331 Known
Issues section), and refreshes 6 tracked lockfile `sdks:` footers (footer-only).
No Dart/native source changed.

Per the forklift-pool rule, this PR is NOT merged by hand — the pool drives
review → fixes → merge.