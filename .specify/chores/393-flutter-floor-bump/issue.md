# Chore Issue: Declare the real Flutter floor (>=3.47.0) and refresh dependency floors

- **Slug**: 393-flutter-floor-bump
- **Recorded**: 2026-10-29
- **Issue**: 393
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/393
- **State**: closed (completed) — the remaining request from the thread is the scope of this chore
- **Author**: AmrTawfek (report), arrrrny (maintainer directive)
- **Labels**: chore

## Body

Note: **no new GitHub issue was filed for this chore.** The work is already
tracked by #393 ("zuraffa_session dependency makes zikzak_inappwebview
unresolvable with equatable ^3 (any Flutter) and on stable Flutter < 3.47"),
closed as completed after the zuraffa 7.3.0 fleet fixed the equatable
conflict. The maintainer closed it requesting the remaining item for the next
umbrella release; the referenced comment
(https://github.com/arrrrny/zikzak_inappwebview/issues/393#issuecomment-6493010108)
asks for it explicitly:

> `zikzak_inappwebview` still declares `flutter: ">=3.38.6"` (pubspec.yaml:16),
> so on Flutter 3.38 to 3.44 pub reports a solver failure instead of the real
> minimum (on 3.44.8 it suggests going back to 5.0.1). Could the next release
> declare `flutter: ">=3.47.0"`? … a CI job that resolves a minimal Flutter app
> on the oldest supported Flutter would catch this.

This `issue.md` records that linkage so the PR can reference
`Closes #393` semantics correctly: since #393 is already closed, the PR body
references the issue and comment rather than auto-closing it.

Source comment fetched 2026-10-29 via the GitHub API
(`issues/comments/6493010108`); host `api.github.com`/`github.com` — allowlisted.
