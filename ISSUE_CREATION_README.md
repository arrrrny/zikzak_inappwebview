# How to Create GitHub Issues

I cannot create GitHub issues directly from this container because:
- No GitHub CLI installed
- No access to your GitHub token
- Container has no authentication

## ✅ Easy Solution: Use the Python Script

### Step 1: Get Your GitHub Token
1. Go to https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Give it a name: "Issue Creation"
4. Select scope: `public_repo` (or `repo` for private repos)
5. Click "Generate token"
6. **Copy the token** (you won't see it again!)

### Step 2: Run the Script
```bash
# Make sure you have requests library
pip3 install requests

# Run the script
python3 create_issues.py YOUR_GITHUB_TOKEN_HERE
```

This will create all issues from `issues_to_create.json`

---

## Alternative: Use GitHub CLI

If you have `gh` installed:

```bash
# Login
gh auth login

# Run the bash script
./create_github_issues.sh
```

---

## Alternative: Manual Creation

If you prefer to create issues manually, see `create_issues_quick.md` for templates.

---

## Current Issues Ready to Create

The `issues_to_create.json` file contains **5 critical issues**:

1. **[SECURITY]** Remove JavaScript-based CSP injection
2. **[SECURITY]** Implement SSL/TLS certificate pinning
3. **[SECURITY]** Implement HTTPS-only mode
4. **[SECURITY]** Fix URL validation - Add scheme checking
5. **✅ [iOS]** Add Privacy Manifest (already done, for tracking)

More issues can be added from the full modernization plan (35 total).

---

## Security Note

**Never commit your GitHub token to git!**

The script accepts the token as a command-line argument, so it stays in your terminal history only.
