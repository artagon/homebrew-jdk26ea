# Claude Code Instructions for homebrew-jdk26ea

## Repository-Specific Guidelines

When working with this repository, Claude Code should follow these specific instructions:

## 1. Commit Message Requirements

**CRITICAL:** All commits MUST follow Conventional Commits format and will be validated by git hooks.

### Format
```
type(scope): description

[optional body]

[optional footer]
```

### Valid Types
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation only
- `style` - Formatting, missing semicolons, etc.
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
# Feature
feat(cask): add support for JDK 26 EA Build 21

# Bug fix
fix(formula): correct SHA256 checksum for Linux ARM64

# Documentation
docs: update README with new installation instructions

# Breaking change
feat(cask)!: rename from jdk26valhalla to jdk26ea

BREAKING CHANGE: Users must uninstall old cask and reinstall with new name
```

### Commit Footer Format
Always include this footer:
```
🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## 2. Ruby Code Style

### RuboCop Rules
- Run `brew style` to validate changes
- Run `brew audit --cask` for cask validation
- Never bypass style checks (no `|| true`)

### Cask Stanza Ordering
```ruby
cask "jdk26ea" do
  version "..."

  name "..."
  desc "..."
  homepage "..."

  on_macos do
    on_arm do
      sha256 "..."  # SHA256 MUST come before URL
      url "..."
    end

    on_intel do
      sha256 "..."  # SHA256 MUST come before URL
      url "..."
    end
  end

  postflight do
    # Installation logic
  end

  uninstall delete: "..."
end
```

### Common RuboCop Issues
1. **Stanza grouping** - Separate stanza groups with empty lines
2. **Stanza order** - `sha256` before `url`
3. **No logical operators in unless** - Use `if` with negation instead

## 3. Version Updates

### When updating to a new JDK build:

1. **Update version in both files:**
   - `Casks/jdk26ea.rb` - Line 2
   - `Formula/jdk26ea.rb` - Line 4

2. **Update URLs for all 4 platforms:**
   - macOS ARM64: `openjdk-26-ea+{build}_macos-aarch64_bin.tar.gz`
   - macOS x64: `openjdk-26-ea+{build}_macos-x64_bin.tar.gz`
   - Linux ARM64: `openjdk-26-ea+{build}_linux-aarch64_bin.tar.gz`
   - Linux x64: `openjdk-26-ea+{build}_linux-x64_bin.tar.gz`

3. **Update SHA256 checksums for all platforms:**
   - Download from `https://download.java.net/java/early_access/jdk26/{build}/GPL/{filename}.sha256`
   - Extract checksum (first field in file)
   - Update both cask and formula

4. **Validate changes:**
   ```bash
   ruby -c Casks/jdk26ea.rb
   ruby -c Formula/jdk26ea.rb
   brew style Casks/jdk26ea.rb
   brew style Formula/jdk26ea.rb
   brew audit --cask Casks/jdk26ea.rb
   ```

5. **Commit with semantic message:**
   ```bash
   git commit -m "feat: update to JDK 26 EA Build XX"
   ```

6. **Note:** README is auto-updated by release workflow

## 4. Security Considerations

### Cask Postflight Scripts
- **Always validate paths** with `realpath`
- **Check staging area** to prevent directory traversal
- **Use `ditto`** instead of `rsync` for copying
- **Use `system_command!`** to fail fast on errors
- **Use `odie`** for fatal errors
- **Use `ohai`** for user messages

### Example Secure Pattern
```ruby
postflight do
  require "pathname"

  staged_root = staged_path.realpath
  candidates = Dir["#{staged_root}/jdk-*.jdk"]
  odie "Expected exactly one JDK bundle" unless candidates.length == 1

  jdk_src = Pathname(candidates.first).realpath
  odie "Not a directory" unless jdk_src.directory?
  odie "Path escapes staging" unless jdk_src.to_s.start_with?(staged_root.to_s)

  jdk_target = Pathname("/Library/Java/JavaVirtualMachines/jdk-26-ea.jdk")

  system_command! "/usr/bin/ditto",
                  args: ["--noqtn", jdk_src.to_s, jdk_target.to_s],
                  sudo: true
end
```

## 5. Testing

### Before submitting PR:

1. **Test cask installation (macOS only):**
   ```bash
   brew install --cask Casks/jdk26ea.rb
   java -version
   brew uninstall --cask jdk26ea
   ```

2. **Test formula installation:**
   ```bash
   brew install Formula/jdk26ea.rb
   java -version
   brew uninstall jdk26ea
   ```

3. **Validate syntax:**
   ```bash
   ruby -c Casks/jdk26ea.rb
   ruby -c Formula/jdk26ea.rb
   brew style Casks/jdk26ea.rb
   brew style Formula/jdk26ea.rb
   ```

### CI will test:
- macOS 13 (Intel x64) - Cask installation
- macOS 14 (Apple Silicon ARM64) - Cask installation
- Ubuntu 22.04 (x64) - Formula installation
- Ubuntu 24.04 (x64) - Formula installation

## 6. Workflow Modifications

### When modifying GitHub Actions workflows:

1. **Validate YAML syntax** before committing
2. **Test locally** with `act` if possible
3. **Use semantic commit:**
   ```bash
   git commit -m "ci(workflow): description of change"
   ```

### Common workflow patterns:
- Use `brew --prefix jdk26ea` to find installation path
- Set `JAVA_HOME` in tests
- Compile and run HelloWorld.java to verify functionality
- Use `if: always()` for cleanup steps

## 7. Branch Protection

### When working on changes:

1. **Create feature branch:**
   ```bash
   git checkout -b feat/description
   # or
   git checkout -b fix/description
   ```

2. **Make changes and commit** with semantic messages

3. **Push and create PR:**
   ```bash
   git push -u origin feat/description
   gh pr create --title "feat: description" --body "..."
   ```

4. **Wait for CI checks** before merging

5. **Branch auto-deletes** after merge

## 8. Documentation Updates

### When to update README.md:
- **Do NOT** update version manually - handled by release workflow
- **Do** update installation instructions if changed
- **Do** update feature list if new features added
- **Do** update platform support if changed

### When to update context.md:
- Significant architecture changes
- New workflows or automation
- Security practice changes
- New testing approaches

## 9. Script Development

### When modifying scripts/update.sh:

1. **Use colored output:**
   ```bash
   GREEN='\033[0;32m'
   YELLOW='\033[1;33m'
   RED='\033[0;31m'
   NC='\033[0m'

   echo -e "${GREEN}✓ Success${NC}"
   echo -e "${YELLOW}⚠ Warning${NC}"
   echo -e "${RED}✗ Error${NC}"
   ```

2. **Validate before and after changes:**
   ```bash
   ruby -c Casks/jdk26ea.rb || { echo "Validation failed"; exit 1; }
   ```

3. **Create backups** before modifications

4. **Use associative arrays** for multi-platform management

## 10. Issue and PR Templates

### When creating issues:
- Use provided templates (bug_report, build_update, feature_request)
- Include all requested information
- Be specific about reproduction steps

### When creating PRs:
- Fill out all sections of PR template
- Check all applicable items in checklists
- Include test results
- Reference related issues

## 11. Git Configuration

This repository uses a dedicated SSH identity:
- Host: `github.com-artagon`
- Email: `trumpyla@gmail.com`
- SSH key: `~/.ssh/id_trumpyla@gmail.com`

Git config is automatically set via conditional includes for `~/Projects/Artagon/` directory.

## 12. Common Pitfalls

### ❌ Don't:
- Commit without semantic commit format
- Skip `brew style` validation
- Use `rsync` in cask postflight (use `ditto`)
- Hardcode paths without validation
- Update README version manually
- Force push to main
- Bypass git hooks with `--no-verify`
- Use `|| true` to hide errors in workflows

### ✅ Do:
- Run `brew style` before committing
- Validate all SHA256 checksums
- Test on actual platforms when possible
- Use `system_command!` for error handling
- Add user-facing messages with `ohai`
- Create feature branches for changes
- Let CI run before merging
- Keep commits focused and atomic

## 13. Emergency Procedures

### If auto-update creates bad PR:
1. Close the PR
2. Fix the issue locally
3. Let auto-update run again next day
4. Or manually update and create PR

### If release fails:
1. Check workflow logs
2. Fix validation errors
3. Re-push to main (will re-trigger)

### If CI is failing:
1. Check RuboCop violations
2. Validate checksums
3. Test locally if possible
4. Review workflow logs for specifics

## 14. Maintenance Schedule

### Daily (Automated):
- `auto-update.yml` checks for new JDK builds at 6 AM UTC

### Weekly (Automated):
- `audit.yml` validates syntax on Monday at 12 PM UTC

### As Needed (Manual):
- Review and merge auto-update PRs
- Address security issues immediately
- Update documentation
- Improve CI/CD processes

## Summary

This repository values:
1. **Security** - Path validation, secure commands, checksum verification
2. **Automation** - Daily updates, automatic releases, comprehensive CI
3. **Quality** - RuboCop enforcement, semantic commits, multi-platform testing
4. **Simplicity** - Clear documentation, single maintainer model
5. **Reliability** - Early detection of issues, rollback capabilities

When in doubt, prioritize security and let automation handle routine tasks.
