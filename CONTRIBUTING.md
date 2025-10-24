# Contributing to homebrew-jdk26

Thank you for your interest in contributing to the JDK 26 Early Access Homebrew tap!

## How to Report Issues

If you encounter any problems with the JDK 26 EA installation or have suggestions for improvement:

1. **Check existing issues** - Search the [issue tracker](https://github.com/Artagon/homebrew-jdk26ea/issues) to see if your issue has already been reported
2. **Use the issue template** - When creating a new issue, use the provided template to ensure all necessary information is included
3. **Be specific** - Include:
   - Your macOS version (`sw_vers`)
   - Homebrew version (`brew --version`)
   - JDK 26 EA build number
   - Complete error messages or unexpected behavior
   - Steps to reproduce the issue

## How to Submit a Pull Request

We welcome contributions! Here's how to submit changes:

### Prerequisites

- A GitHub account
- Homebrew installed on your system
- Basic knowledge of Ruby (for cask/formula syntax)
- Familiarity with Git

### Step-by-Step Guide

1. **Fork the repository**
   ```bash
   # Visit https://github.com/Artagon/homebrew-jdk26ea and click "Fork"
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/homebrew-jdk26ea.git
   cd homebrew-jdk26ea
   ```

3. **Create a feature branch**
   ```bash
   git checkout -b feature/your-improvement
   ```

4. **Make your changes**
   - Edit the appropriate files (Casks/jdk26ea.rb or Formula/jdk26ea.rb)
   - Test your changes locally:
     ```bash
     # For cask
     brew install --cask Casks/jdk26ea.rb

     # For formula
     brew install Formula/jdk26ea.rb
     ```

5. **Validate your changes**
   ```bash
   # Check Ruby syntax
   ruby -c Casks/jdk26ea.rb
   ruby -c Formula/jdk26ea.rb

   # Run brew style check (if available)
   brew style Casks/jdk26ea.rb
   ```

6. **Commit your changes**
   ```bash
   git add .
   git commit -m "Brief description of your changes"
   ```

7. **Push to your fork**
   ```bash
   git push origin feature/your-improvement
   ```

8. **Create a Pull Request**
   - Go to https://github.com/Artagon/homebrew-jdk26ea
   - Click "Pull Requests" > "New Pull Request"
   - Click "compare across forks"
   - Select your fork and branch
   - Fill out the PR template with details about your changes
   - Submit the PR

### Pull Request Guidelines

- **Keep changes focused** - One feature or fix per PR
- **Update documentation** - If you change functionality, update the README
- **Test thoroughly** - Ensure the cask/formula installs correctly
- **Follow Ruby style** - Use proper indentation and Homebrew conventions
- **Write clear commit messages** - Use semantic commits (see below)

### Semantic Commit Messages

This project follows the [Conventional Commits](https://www.conventionalcommits.org/) specification. All commit messages must be formatted as:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat:` - A new feature
- `fix:` - A bug fix
- `docs:` - Documentation only changes
- `style:` - Changes that don't affect code meaning (formatting, missing semicolons, etc.)
- `refactor:` - Code change that neither fixes a bug nor adds a feature
- `perf:` - Performance improvements
- `test:` - Adding or modifying tests
- `chore:` - Changes to build process, dependencies, or auxiliary tools
- `ci:` - Changes to CI configuration files and scripts

**Scope (optional):**
- `cask` - Changes to the cask file
- `formula` - Changes to the formula file
- `workflow` - Changes to GitHub Actions workflows
- `docs` - Changes to documentation

**Examples:**
```bash
feat(cask): add support for JDK 26 EA Build 21
fix(formula): correct SHA256 checksum for Linux ARM64
docs: update README with new installation instructions
chore(workflow): update auto-update schedule to run twice daily
```

**Breaking Changes:**
If your change introduces a breaking change, add `BREAKING CHANGE:` in the footer or add `!` after the type/scope:

```bash
feat(cask)!: rename from jdk26valhalla to jdk26ea

BREAKING CHANGE: Users must uninstall old cask and reinstall with new name
```

**Git Hook:**
This repository includes a commit-msg hook that validates your commit messages automatically.

**Setup:**
The hook is automatically active when you work in this repository (configured via `core.hooksPath`).

To manually configure:
```bash
git config core.hooksPath .githooks
```

**Testing the Hook:**
```bash
# This should pass
echo "feat(cask): add new feature" | .githooks/commit-msg /dev/stdin

# This should fail
echo "bad commit message" | .githooks/commit-msg /dev/stdin
```

**Bypassing (Not Recommended):**
```bash
git commit --no-verify -m "message"
```

Note: PRs that don't follow semantic commit guidelines may be rejected.

### Updating to a New JDK 26 EA Build

When a new JDK 26 EA build is released:

1. Update version number in both `Casks/jdk26ea.rb` and `Formula/jdk26ea.rb`
2. Update URLs for all architectures (macOS ARM64, macOS x64, Linux x64)
3. Update SHA256 checksums for each download
4. Test installation on your system
5. Submit a PR with title: "Update to JDK 26 EA Build XX"

The automated update script can help with this:
```bash
./scripts/update.sh
```

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on the issue, not the person
- Help create a welcoming environment for all contributors

## Questions?

If you have questions about contributing, feel free to:
- Open a discussion in the [issue tracker](https://github.com/Artagon/homebrew-jdk26ea/issues)
- Review existing PRs to see examples
- Check [Homebrew's documentation](https://docs.brew.sh/Formula-Cookbook) for cask/formula syntax

## Issue-Driven Workflow

This repository supports an issue-driven workflow for automation and collaboration.

### Issue Commands

Authorized collaborators can trigger actions by commenting on issues with slash commands:

| Command | Description | Permission Required |
|---------|-------------|---------------------|
| `/update` | Trigger JDK update check and PR creation | Write access |
| `/check-version` | Check current vs latest JDK version | Write access |
| `/validate` | Run validation checks on cask/formula | Write access |
| `/help` | Show available commands | Anyone |

**Example:**
```
/check-version
```

### Issue Labels

Certain labels automatically trigger workflows:

- `update-request` - Automatically triggers the update workflow
- `bug` - Marks issue as a bug report
- `enhancement` - Marks issue as a feature request

### Workflow Integration

1. **Create an issue** using one of our templates
2. **Apply relevant labels** or use slash commands
3. **Workflows automatically respond** with updates
4. **PRs are created automatically** when updates are available

### For Maintainers

The issue-driven workflow allows you to:
- Trigger updates without manual workflow dispatch
- Check versions directly from issues
- Validate changes before merging
- Track all actions in issue comments

## Branch Protection

The `main` branch is protected to ensure code quality and prevent accidental changes.

### Protection Rules

- ✅ **Require pull request before merging**
  - Required approvals: 0 (for single maintainer)
  - Dismiss stale reviews on new commits
- ✅ **Require status checks to pass**
  - `Validate` - Validates cask/formula syntax
  - Branches must be up to date before merging
- ✅ **Require conversation resolution**
- ❌ **No force pushes allowed**
- ❌ **No deletions allowed**

### Merge Options

- ✅ Allow merge commits
- ✅ Allow squash merging (recommended for clean history)
- ❌ Rebase merging disabled
- ✅ Automatically delete head branches after merge

### Benefits

1. **Prevents accidental direct commits** - All changes must go through pull requests
2. **Enforces quality checks** - Validates syntax and semantic commits
3. **Maintains clean history** - Requires conversation resolution, prevents force pushes
4. **Automated cleanup** - Auto-deletes merged branches

### Development Workflow

```bash
# 1. Create feature/fix branch
git checkout -b feat/my-feature

# 2. Make changes and commit with semantic commits
git add .
git commit -m "feat(cask): add new feature"

# 3. Push branch
git push origin feat/my-feature

# 4. Create pull request on GitHub
# 5. Wait for 'Validate' status check to pass
# 6. Merge PR (branch will be auto-deleted)
```

### Configuration (Maintainers Only)

View/edit protection settings at:
https://github.com/artagon/homebrew-jdk26ea/settings/branches

Or via API:
```bash
# Requires admin permissions
bash <<'EOF'
TOKEN=$(gh auth token)
curl -s -X PUT \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/artagon/homebrew-jdk26ea/branches/main/protection \
  -d @.github/branch-protection.json
EOF
```

## License

By contributing, you agree that your contributions will be licensed under the same terms as the project (GPL-2.0, matching the JDK license).
