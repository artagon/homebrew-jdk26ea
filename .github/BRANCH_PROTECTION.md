# Branch Protection Configuration

This document describes the branch protection settings for the `main` branch.

## Manual Setup (GitHub Web UI)

Since branch protection via API can be complex, configure it manually:

1. Go to https://github.com/artagon/homebrew-jdk26ea/settings/branches
2. Click "Add branch protection rule"
3. Set branch name pattern: `main`

### Recommended Settings

**Protect matching branches:**
- ✅ Require a pull request before merging
  - Required approvals: 0 (for single maintainer)
  - ✅ Dismiss stale pull request approvals when new commits are pushed
  - ✅ Require approval of the most recent reviewable push

**Status checks:**
- ✅ Require status checks to pass before merging
  - ✅ Require branches to be up to date before merging
  - Required checks:
    - `Validate` (validates cask/formula syntax)

**Additional settings:**
- ✅ Require conversation resolution before merging
- ✅ Do not allow bypassing the above settings (uncheck "Allow force pushes")
- ✅ Do not allow deletions

**Merge options (Repository settings):**
- ✅ Allow merge commits
- ✅ Allow squash merging
- ❌ Allow rebase merging (disabled for cleaner history)
- ✅ Automatically delete head branches

## Via GitHub CLI (Alternative)

```bash
# Note: This may require additional permissions
gh api -X PUT /repos/artagon/homebrew-jdk26ea/branches/main/protection \
  --input .github/branch-protection.json
```

See `branch-protection.json` for the configuration.

## Benefits

1. **Prevents accidental direct commits to main**
   - All changes must go through pull requests
   - Ensures code review process

2. **Enforces quality checks**
   - Validates cask/formula syntax before merge
   - Ensures semantic commit messages (via git hook)

3. **Maintains clean history**
   - Requires conversation resolution
   - Prevents force pushes that could rewrite history

4. **Automated cleanup**
   - Auto-deletes merged branches
   - Keeps repository tidy

## Workflow

1. Create feature/fix branch: `git checkout -b feat/my-feature`
2. Make changes and commit with semantic commits
3. Push branch: `git push origin feat/my-feature`
4. Create pull request on GitHub
5. Wait for status checks to pass
6. Merge PR (branch auto-deleted)
