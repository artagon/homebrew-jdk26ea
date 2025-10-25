<!-- AUTO-GENERATED from .model-context/
     DO NOT EDIT DIRECTLY - Edit .model-context/shared/ instead
     Last synced: 2025-10-25 10:34:16 UTC
     Agent: Gemini Code Assist -->

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

<!-- BEGIN: .model-context/agents/gemini.md -->
# Gemini Code Assist Specific Instructions

## Configuration
Gemini loads from `.gemini/styleguide.md` (auto-generated from shared context)

## Gemini-Specific Features
- Automated code reviews on PRs
- Multi-file context awareness
- Natural language code generation
- Integrated with Google Cloud

## Code Review Focus
When reviewing PRs, prioritize:
1. Security vulnerabilities (path traversal, injection, token exposure)
2. Missing SHA256 checksums
3. Unpinned GitHub Actions
4. Semantic commit message compliance
5. RuboCop/style violations
6. Test coverage

## Review Comments
- Use severity levels: CRITICAL, HIGH, MEDIUM, LOW
- Be specific about fixes required
- Reference relevant documentation
- Suggest concrete improvements

<!-- END: .model-context/agents/gemini.md -->

