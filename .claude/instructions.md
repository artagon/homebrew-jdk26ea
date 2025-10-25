<!-- AUTO-GENERATED from .model-context/
     DO NOT EDIT DIRECTLY - Edit .model-context/shared/ instead
     Last synced: 2025-10-25 10:34:15 UTC
     Agent: Claude Code -->

<!-- BEGIN: .model-context/shared/instructions.md -->
# AI Assistant Instructions for homebrew-jdk26ea

## Domain-Specific Skills

This repository uses domain-organized skill files for specialized expertise. AI assistants should reference these files for detailed guidance in each area:

### Core Skills
- **[Homebrew Development](../skills/homebrew.md)** - Formula and cask development, security patterns, validation
- **[GitHub Workflows](../skills/github-workflows.md)** - Actions security, input validation, workflow patterns
- **[Shell Scripting](../skills/shell-scripts.md)** - Bash best practices, error handling, safe patterns
- **[Security Practices](../skills/security.md)** - Input validation, path traversal prevention, cryptographic verification
- **[Development Workflow](../skills/development-workflow.md)** - Git workflows, PR management, code review
- **[Semantic Commits](../skills/semantic-commits.md)** - Conventional commits, changelog generation

## Project-Specific Requirements

### Repository Context
- **Purpose**: Homebrew tap for OpenJDK 26 Early Access builds
- **Platforms**: macOS (ARM64, x64), Linux (ARM64, x64)
- **Automation**: Daily auto-updates, automated releases, multi-platform CI testing

### Commit Requirements
All commits MUST follow Conventional Commits format. See [semantic-commits.md](../skills/semantic-commits.md) for details.

**Quick Reference:**
```
type(scope): description

Valid types: feat, fix, docs, style, refactor, perf, test, chore, ci
Valid scopes: cask, formula, workflow, docs, scripts
```

**Examples:**
```bash
feat(cask): add support for JDK 26 EA Build 21
fix(formula): correct SHA256 checksum for Linux ARM64
ci(workflow): pin action to commit SHA for security
```

### File Structure
```
homebrew-jdk26/
├── Casks/jdk26ea.rb           # macOS cask
├── Formula/jdk26ea.rb         # Linux/macOS formula
├── .github/workflows/         # CI/CD automation
├── scripts/                   # Update and sync scripts
└── .model-context/            # AI configuration
    ├── skills/               # Domain-specific skills
    ├── shared/               # Shared context
    └── agents/               # Agent-specific overrides
```

### Version Updates

When updating to a new JDK build:

1. **Update version** in both Casks/jdk26ea.rb and Formula/jdk26ea.rb
2. **Download and verify checksums** for all 4 platforms
3. **Validate changes** with brew style and brew audit
4. **Commit** with semantic message: `feat: update to JDK 26 EA Build XX`

**Reference Skills:**
- [Homebrew Development](../skills/homebrew.md#version-management)
- [Security Practices](../skills/security.md#cryptographic-verification)
- [Shell Scripting](../skills/shell-scripts.md#network-operations)

### Security Requirements

**Critical Rules:**
- Pin ALL GitHub Actions to commit SHAs → [github-workflows.md](../skills/github-workflows.md#action-pinning)
- Validate ALL external inputs → [security.md](../skills/security.md#input-validation)
- Verify checksums before use → [security.md](../skills/security.md#cryptographic-verification)
- Use realpath for path operations → [homebrew.md](../skills/homebrew.md#path-validation)
- Quote all shell variables → [shell-scripts.md](../skills/shell-scripts.md#safe-command-execution)

### Testing Requirements

**Before Committing:**
```bash
# Syntax validation
ruby -c Casks/jdk26ea.rb
ruby -c Formula/jdk26ea.rb

# Style checking
brew style Casks/jdk26ea.rb Formula/jdk26ea.rb

# Audit
brew audit --cask Casks/jdk26ea.rb
brew audit --formula Formula/jdk26ea.rb
```

**CI Testing:**
- macOS 13, 14 (cask installation)
- Ubuntu 22.04, 24.04 (formula installation)
- Syntax and style validation
- Functional tests (java -version, compile HelloWorld)

### Workflow Patterns

**Feature Development:**
```bash
# Create feature branch
git checkout -b feat/description

# Make changes with semantic commits
git commit -m "feat(cask): add support for new feature"

# Push and create PR
git push -u origin feat/description
gh pr create --title "feat: description" --body "..."
```

**Reference:**
- [Development Workflow](../skills/development-workflow.md#feature-branch-workflow)
- [Semantic Commits](../skills/semantic-commits.md#commit-types)

### Automation

**Daily Auto-Updates** (6 AM UTC):
- Scrapes https://jdk.java.net/26/ for new builds
- Downloads and verifies checksums
- Creates PR if new build available

**Automated Releases** (on main branch push):
- Validates syntax and style
- Runs multi-platform tests
- Creates GitHub release with changelog

**Reference:**
- [GitHub Workflows](../skills/github-workflows.md#auto-update-workflow)
- [Development Workflow](../skills/development-workflow.md#versioning-and-tagging)

## Quick Reference: Common Tasks

### Task: Add New JDK Build
1. Run `./scripts/update.sh <build-number>` or update manually
2. Verify checksums for all 4 platforms
3. Test: `brew style` and `brew audit`
4. Commit: `feat: update to JDK 26 EA Build XX`
5. Push and create PR

**Skills:** [homebrew.md](../skills/homebrew.md), [security.md](../skills/security.md#cryptographic-verification)

### Task: Fix Security Issue
1. Identify vulnerability
2. Create branch: `fix/security-issue-name`
3. Apply fix following security best practices
4. Add tests if applicable
5. Commit: `fix(scope): description` with security note
6. Create PR with security context

**Skills:** [security.md](../skills/security.md), [github-workflows.md](../skills/github-workflows.md)

### Task: Update GitHub Workflow
1. Validate YAML syntax
2. Pin all actions to commit SHAs
3. Validate inputs and add error handling
4. Test in fork if possible
5. Commit: `ci(workflow): description`
6. Monitor workflow runs after merge

**Skills:** [github-workflows.md](../skills/github-workflows.md), [security.md](../skills/security.md#input-validation)

### Task: Write Shell Script
1. Start with strict mode: `set -euo pipefail`
2. Add input validation
3. Implement error handling (trap)
4. Quote all variables
5. Test with ShellCheck
6. Commit: `chore(scripts): description`

**Skills:** [shell-scripts.md](../skills/shell-scripts.md), [security.md](../skills/security.md)

## Error Prevention

### Common Mistakes

❌ **Don't:**
- Skip brew style validation
- Hardcode SHA256 checksums without verification
- Use unpinned GitHub Actions
- Commit without semantic format
- Update README version manually (automated)
- Use rsync in cask postflight (use ditto)

✅ **Do:**
- Run validation before every commit
- Download and verify checksums
- Pin actions to commit SHAs with version comments
- Follow Conventional Commits format
- Let automation handle README updates
- Use ditto (Apple-signed) for file operations

## Emergency Procedures

**If auto-update creates bad PR:**
1. Close the PR
2. Fix issue locally
3. Let auto-update run again next day, or
4. Create manual PR with fix

**If release fails:**
1. Check workflow logs for errors
2. Fix validation/test failures
3. Re-push to main (triggers re-run)

**If CI failing:**
1. Check RuboCop violations
2. Verify SHA256 checksums
3. Test locally when possible
4. Review detailed workflow logs

## Repository Operations

All repository operations should follow the guidelines in:
- [Development Workflow](../skills/development-workflow.md) for Git operations
- [Semantic Commits](../skills/semantic-commits.md) for commit messages
- [GitHub Workflows](../skills/github-workflows.md) for CI/CD changes

## Summary

This repository values:
1. **Security** - Path validation, secure commands, checksum verification
2. **Automation** - Daily updates, automatic releases, comprehensive CI
3. **Quality** - RuboCop enforcement, semantic commits, multi-platform testing
4. **Simplicity** - Clear documentation, skill-based organization
5. **Reliability** - Early detection, rollback capabilities

When in doubt:
- Consult relevant skill file for detailed guidance
- Prioritize security over convenience
- Let automation handle routine tasks
- Follow semantic commit format
- Test before committing

<!-- END: .model-context/shared/instructions.md -->

<!-- BEGIN: .model-context/shared/security.md -->
# Security Guidelines for homebrew-jdk26ea

## 1. GitHub Actions Security

### Pin Actions to Commit SHAs
- NEVER use tags or branches (they're mutable)
- ALWAYS use full commit SHA with version comment
- Example: `uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11  # v4.1.1`

### Token Security
- Never expose tokens in curl commands
- Use `gh` CLI for GitHub API calls
- Pass secrets via environment variables only
- Use minimal permissions (contents: read, pull-requests: write)

### Input Validation
- Validate ALL external inputs with regex
- Build numbers: `^[0-9]{1,3}$` (range: 1-999)
- URLs: Must match `https://download.java.net/java/early_access/...`
- SHA256: `^[a-f0-9]{64}$`
- Reject invalid inputs immediately

### Checksum Verification
- Download files AND verify checksums (don't just fetch checksums)
- Compare expected vs actual before using values
- Fail workflow if verification fails

## 2. Cask/Formula Security

### Path Validation
- Use `realpath` to resolve all symlinks
- Validate paths stay within staging area
- Check: `path.to_s.start_with?(staged_root.to_s)`
- Validate candidate count: `odie` if not exactly 1

### Command Execution
- Use `system_command!` (with !) to fail fast
- Use `ditto` instead of `rsync` (Apple-signed)
- Pass args as array (never string interpolation)
- Use `sudo` only for system locations

### Error Handling
- Use `odie` for fatal errors (stops execution)
- Use `ohai` for user messages
- Use `opoo` for warnings (non-fatal)
- Never silently continue on errors

## 3. Workflow Permissions

### Minimal Permissions
```yaml
# For auto-update PRs
permissions:
  contents: read
  pull-requests: write

# For releases
permissions:
  contents: write
```

### Avoid Direct Commits
- Create PRs instead of pushing to main
- Exception: Documentation-only auto-updates with clear justification
- Always respect branch protection rules

## 4. Common Vulnerabilities

| Vulnerability | Fix |
|--------------|-----|
| Unpinned actions | Pin to commit SHA |
| Token in curl | Use gh CLI |
| No input validation | Add regex validation |
| No checksum verify | Download and verify |
| Excessive permissions | Use minimal permissions |
| Direct commits to main | Create PRs |

## 5. New Security Rule
- Always validate API responses

<!-- END: .model-context/shared/security.md -->

<!-- BEGIN: .model-context/shared/style-guide.md -->
# Code Style Guide for homebrew-jdk26ea

## Commit Messages

### Format
```
type(scope): description

[optional body]
```

### Valid Types
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation only
- `style` - Code formatting
- `refactor` - Code refactoring
- `perf` - Performance improvements
- `test` - Adding/modifying tests
- `chore` - Build process, dependencies
- `ci` - CI configuration changes

### Valid Scopes
- `cask` - Changes to Casks/jdk26ea.rb
- `formula` - Changes to Formula/jdk26ea.rb
- `workflow` - GitHub Actions workflows
- `docs` - Documentation changes
- `scripts` - Script changes

### Examples
```bash
feat(cask): add support for JDK 26 EA Build 21
fix(formula): correct SHA256 checksum for Linux ARM64
ci(workflow): pin action to commit SHA for security
docs: update README with installation instructions
```

## Ruby/Homebrew Style

### Before Committing
1. Validate syntax: `ruby -c Casks/jdk26ea.rb`
2. Check style: `brew style Casks/jdk26ea.rb`
3. Run audit: `brew audit --cask Casks/jdk26ea.rb`

### Cask Stanza Ordering
1. `arch` declaration
2. `version`
3. `sha256` (before url!)
4. `url`
5. `name`
6. `desc`
7. `homepage`
8. `postflight`
9. `uninstall`

### Common Issues
- Missing empty lines between stanza groups
- SHA256 after URL (should be before)
- Logical operators in `unless` (use `if` with negation)

## Workflow Style

### YAML Structure
- Use consistent indentation (2 spaces)
- Add comments for complex logic
- Name all steps clearly
- Group related steps

### Security Annotations
```yaml
# Pin to commit SHA with version comment
- uses: actions/checkout@a1b2c3d...  # v4.1.1

# Document why permissions are needed
permissions:
  contents: read      # Checkout repository
  pull-requests: write  # Create update PRs
```

## Testing

### Required Tests
- Syntax validation (all files)
- Style checks (brew style)
- Audit checks (brew audit)
- Installation tests (macOS 13, 14, Ubuntu 22.04, 24.04)
- Functional tests (java -version, compile HelloWorld)

### CI Expectations
- All jobs must pass
- No RuboCop violations
- No audit failures
- Successful installation on all platforms

<!-- END: .model-context/shared/style-guide.md -->

<!-- BEGIN: .model-context/agents/claude.md -->
# Claude Code Specific Instructions

## Shared Context
Claude loads this file plus all files in `.model-context/shared/`:
- instructions.md - Behavioral instructions
- context.md - Repository context
- security.md - Security guidelines
- style-guide.md - Code style rules

## Claude-Specific Tools and Practices

### Task Management
- Use `TodoWrite` tool for multi-step tasks
- Mark tasks `in_progress` before starting
- Mark tasks `completed` immediately after finishing
- Never batch completions

### Code Operations
- Prefer `Edit` tool over `Write` for existing files
- Use `Read` before `Write` or `Edit`
- Use `Grep` and `Glob` for searching (NOT bash grep/find)
- Use `Bash` only for actual shell commands

### Agent Usage
- Use `Task` tool with `subagent_type=Explore` for codebase exploration
- Launch agents in parallel when possible (single message, multiple Task calls)
- Never guess parameters - wait for actual values

### Communication
- Output text directly to user (not via echo/bash)
- No emojis unless user explicitly requests
- Be concise - user sees output in CLI
- Use Github-flavored markdown

## Repository Operations

### Git Commits
- Create commits only when explicitly requested
- Use heredoc for commit messages to preserve formatting
- Never use `--no-verify` to bypass hooks
- Always validate commit message format before committing

### Creating PRs
- Always show full diff before creating PR
- Generate comprehensive PR description
- Include test plan
- Return PR URL when done

<!-- END: .model-context/agents/claude.md -->

