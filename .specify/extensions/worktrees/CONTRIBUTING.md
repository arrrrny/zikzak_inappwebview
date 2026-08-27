# Contributing

This is a public repository. Changes should follow the usual **GitHub flow**: work on a **branch**, open a **pull request** into `main`, and merge only after review — **not** by committing directly to `main`.

## For contributors

1. **Fork** the repository (or use a branch if you have write access).
2. Create a **feature branch** from up-to-date `main`:

   ```bash
   git fetch origin
   git checkout -b your-branch-name origin/main
   ```

3. Make commits with clear messages.
4. **Push** your branch and open a **pull request** targeting `main`.
5. Wait for CI (GitHub Actions) to pass and for maintainer review.

## For maintainers

- Merge contributions via **Pull request** → **Merge** (squash or merge commit, per repo preference).
- **Do not** push commits directly to `main` for routine changes; use a short-lived branch and PR so history and review stay consistent with contributor expectations.
- In repository **Settings → Rules → Rulesets** (or **Branch protection rules**), protect `main`: require a pull request before merging, and require status checks where appropriate.

## Releases

After a change to versioned files (`extension.yml`, `CHANGELOG.md`, `catalog-entry.json`) is **merged** to `main`:

1. Tag a semantic version (e.g. `v1.3.0`) on the merge commit.
2. Push the tag so `download_url` and install snippets that point at `/archive/refs/tags/v…` stay valid.

See [PUBLISH.md](PUBLISH.md) for catalog and distribution notes.
