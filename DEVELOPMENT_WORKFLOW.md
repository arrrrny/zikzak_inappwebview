# Development Workflow

## Branch Structure

This repository uses a **development branch workflow** to ensure stability in production while allowing active development and testing.

### Branches

- **`master`** - Production-ready code. Stable releases only.
- **`claude/dev-011CUpeFkCsKojcjNBK1eRo6`** - Development branch (default). All PRs merge here first.

## Workflow

### 1. Development & PRs

All pull requests should target the **`claude/dev-011CUpeFkCsKojcjNBK1eRo6`** branch (this is now the default).

```bash
# Create feature branch
git checkout claude/dev-011CUpeFkCsKojcjNBK1eRo6
git pull origin claude/dev-011CUpeFkCsKojcjNBK1eRo6
git checkout -b claude/feature-name-011CUpeFkCsKojcjNBK1eRo6

# Make changes, commit, push
git push -u origin claude/feature-name-011CUpeFkCsKojcjNBK1eRo6

# Create PR targeting claude/dev-011CUpeFkCsKojcjNBK1eRo6 (automatic default)
```

### 2. Testing on Dev Branch

After merging PRs to `claude/dev-011CUpeFkCsKojcjNBK1eRo6`:

```bash
# Pull latest dev branch
git checkout claude/dev-011CUpeFkCsKojcjNBK1eRo6
git pull origin claude/dev-011CUpeFkCsKojcjNBK1eRo6

# Test thoroughly
flutter pub get
flutter analyze
flutter test

# Test in your app
cd your_app
flutter pub upgrade zikzak_inappwebview
flutter run
```

### 3. Promote to Master (Production)

Once testing is complete on `claude/dev-011CUpeFkCsKojcjNBK1eRo6`:

```bash
# Checkout master
git checkout master
git pull origin master

# Merge dev into master
git merge claude/dev-011CUpeFkCsKojcjNBK1eRo6 --no-ff -m "Merge dev to master: [describe changes]"

# Push to master
git push origin master

# Tag release (optional)
git tag -a v3.0.0 -m "Release v3.0.0: [major features]"
git push origin v3.0.0
```

## Current PRs Status

All open PRs have been updated to target `claude/dev-011CUpeFkCsKojcjNBK1eRo6`:

- **PR #16**: [SECURITY] Remove JavaScript-based CSP injection
- **PR #17**: [SECURITY] Implement URL validation with scheme checking
- **PR #18**: [SECURITY] Implement SSL/TLS Certificate Pinning
- **PR #19**: [SECURITY] Implement HTTPS-only enforcement mode

## Merging PRs

You can now merge all PRs safely to the dev branch:

```bash
# Via GitHub UI (recommended)
1. Go to each PR
2. Click "Merge pull request"
3. Confirm merge to claude/dev-011CUpeFkCsKojcjNBK1eRo6

# Via command line
git checkout claude/dev-011CUpeFkCsKojcjNBK1eRo6
gh pr merge 16 --merge  # Repeat for 17, 18, 19
```

## Testing Checklist

Before promoting dev → master:

- [ ] All PRs merged to dev
- [ ] `flutter analyze` passes with no errors
- [ ] `flutter test` passes (when tests are added)
- [ ] Manual testing in sample app
- [ ] Security features validated:
  - [ ] CSP headers work correctly
  - [ ] URL validation blocks javascript: schemes
  - [ ] HTTPS enforcement working (if enabled)
  - [ ] Certificate pinning configured (if enabled)
- [ ] No breaking changes for existing users (or documented)
- [ ] README and docs updated if needed

## Release Process

1. **Merge to dev** → Test thoroughly
2. **Merge dev to master** → Production-ready
3. **Tag release** → Semantic versioning (v3.0.0, v3.0.1, etc.)
4. **Publish to pub.dev** → Make it available to Flutter community
5. **GitHub Release** → Announcement with changelog

## Benefits of This Workflow

✅ **Safety**: Test everything on dev before production
✅ **Speed**: Merge multiple PRs to dev, test together
✅ **Flexibility**: Roll back dev without affecting master
✅ **Confidence**: Master branch always stable
✅ **CI/CD Ready**: Can automate testing on dev branch

## Notes

- **Branch Naming**: All branches must start with `claude/` and end with the session ID for push permissions
- **Default Branch**: GitHub PRs will automatically target `claude/dev-011CUpeFkCsKojcjNBK1eRo6`
- **Master Protection**: Consider enabling branch protection rules on master for additional safety

---

**Questions?** Open an issue or check the GitHub discussions!
