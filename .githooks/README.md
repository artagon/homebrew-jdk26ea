# Git Hooks

This directory contains git hooks for the homebrew-jdk26 repository.

## Setup

These hooks are automatically configured when you work in this repository. The repository is configured to use `.githooks/` instead of `.git/hooks/`.

To manually configure:

```bash
git config core.hooksPath .githooks
```

## Available Hooks

### commit-msg

Validates that commit messages follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

**Format:**
```
<type>(<scope>): <description>
```

**Valid types:**
- `feat` - A new feature
- `fix` - A bug fix
- `docs` - Documentation changes
- `style` - Code style changes (formatting, etc.)
- `refactor` - Code refactoring
- `perf` - Performance improvements
- `test` - Test changes
- `chore` - Build process or auxiliary tool changes
- `ci` - CI configuration changes

**Valid scopes:**
- `cask` - Cask file changes
- `formula` - Formula file changes
- `workflow` - GitHub Actions workflow changes
- `docs` - Documentation changes
- `scripts` - Script changes

**Examples:**
```bash
feat(cask): add support for JDK 26 EA Build 21
fix(formula): correct SHA256 checksum for Linux ARM64
docs: update README with new installation instructions
chore(workflow): update auto-update schedule
```

## Testing Hooks

To test the commit-msg hook:

```bash
# This should pass
echo "feat(cask): add new feature" | .githooks/commit-msg /dev/stdin

# This should fail
echo "bad commit message" | .githooks/commit-msg /dev/stdin
```

## Bypassing Hooks

In rare cases where you need to bypass the hooks (not recommended):

```bash
git commit --no-verify -m "message"
```

**Note:** Pull requests that don't follow semantic commit guidelines may be rejected.
