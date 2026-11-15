# Contributing

Thanks for improving zikzak_inappwebview! A few ground rules keep your PR moving fast.

## Opening a pull request

1. Fork the repository and create a feature branch off `master`.
2. One logical change per PR — keep it focused so review stays precise.
3. Watch CI once it finishes and fix any reds on the same branch before the review round closes.
4. **When you open the PR, always leave "Allow edits by maintainers" checked.** This is the checkbox under the comment box on the PR creation form (it is on by default — keep it on).
   - It lets maintainers push review fixes **directly onto your PR branch**, so the automated review-fix rounds land on your PR and **yours is the PR that ships**.
   - Without it, fixes cannot land on your branch: your PR has to be closed and the change ships through a superseding branch instead (it happened once already — #434 → #435 — and we would rather it never happens again).
5. Link the issues your PR closes in its description (`Closes #N`), so the pipeline closes them automatically on merge.

## How review works here

- Every PR gets an automated review round with inline findings.
- Because your PR allows maintainer edits, the fixes round pushes the accepted fixes straight onto your branch — you don't need to do anything.
- The pipeline (review → fixes → merge) runs automatically once the review round completes.

## Code conventions

- Follow the existing code style; run `dart format` on the files you changed.
- Add a test for new behaviour in the affected package, and keep `dart analyze` clean on the files you touched.
- Keep platform-specific code inside its platform package (`zikzak_inappwebview_android`, `zikzak_inappwebview_linux`, …).
