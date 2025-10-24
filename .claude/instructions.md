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

## 14. Homebrew Formulas Secure Development Practices

### Overview

Homebrew formulas and casks execute with elevated privileges during installation. This requires strict adherence to security best practices to prevent privilege escalation, arbitrary code execution, and system compromise.

### 14.1 SHA256 Checksum Verification

**CRITICAL:** Every download MUST be verified with SHA256 checksums.

#### ✅ Correct Pattern
```ruby
# Cask
on_arm do
  sha256 "dc75cdb507e47a66b0edc73d1cfc4a1c011078d5d0785c7660320d2e9c3e04d4"
  url "https://download.java.net/java/early_access/jdk26/20/GPL/openjdk-26-ea+20_macos-aarch64_bin.tar.gz"
end

# Formula
on_macos do
  if Hardware::CPU.arm?
    url "https://download.java.net/java/early_access/jdk26/20/GPL/openjdk-26-ea+20_macos-aarch64_bin.tar.gz"
    sha256 "dc75cdb507e47a66b0edc73d1cfc4a1c011078d5d0785c7660320d2e9c3e04d4"
  end
end
```

#### ❌ NEVER Do This
```ruby
# NO checksum - DANGEROUS!
url "https://example.com/file.tar.gz"

# Using :no_check - FORBIDDEN!
sha256 :no_check

# Dynamic checksum - DANGEROUS!
sha256 ENV['CHECKSUM']
```

#### Checksum Sources
1. **Official checksums only** - Download from same domain as binary
2. **Verify manually** - Download file, run `shasum -a 256 file.tar.gz`
3. **Document source** - Comment where checksum came from
4. **Update atomically** - Update checksum and URL together

### 14.2 URL Security

#### HTTPS Required
```ruby
# ✅ HTTPS only
url "https://download.java.net/..."

# ❌ NEVER use HTTP
url "http://download.java.net/..."  # FORBIDDEN

# ❌ NEVER use FTP
url "ftp://ftp.example.com/..."     # FORBIDDEN
```

#### URL Validation
```ruby
# ✅ Use official domains only
url "https://download.java.net/java/early_access/jdk26/20/GPL/openjdk-26-ea+20_macos-aarch64_bin.tar.gz"

# ❌ Avoid third-party mirrors
url "https://random-mirror.com/jdk.tar.gz"  # DANGEROUS

# ❌ No user-controlled URLs
url ENV['DOWNLOAD_URL']  # FORBIDDEN

# ❌ No URL shorteners
url "https://bit.ly/jdk26"  # FORBIDDEN
```

### 14.3 Path Validation and Directory Traversal Prevention

#### Cask Postflight Security

**CRITICAL:** All paths must be validated to prevent directory traversal attacks.

```ruby
postflight do
  require "pathname"

  # ✅ ALWAYS use realpath to resolve symlinks
  staged_root = staged_path.realpath

  # ✅ Validate number of candidates
  candidates = Dir["#{staged_root}/jdk-*.jdk"]
  odie "Expected exactly one JDK bundle in #{staged_root}, found #{candidates.length}" unless candidates.length == 1

  # ✅ Resolve path and validate it's a directory
  jdk_src = Pathname(candidates.first).realpath
  odie "Staged JDK bundle #{jdk_src} is not a directory" unless jdk_src.directory?

  # ✅ CRITICAL: Validate path doesn't escape staging area
  odie "Resolved JDK path escapes staging area" unless jdk_src.to_s.start_with?(staged_root.to_s)

  # ✅ Use Pathname for target
  jdk_target = Pathname("/Library/Java/JavaVirtualMachines/jdk-26-ea.jdk")

  # ✅ Use to_s for command arguments
  system_command! "/usr/bin/ditto",
                  args: ["--noqtn", jdk_src.to_s, jdk_target.to_s],
                  sudo: true
end
```

#### ❌ Insecure Patterns - NEVER Use
```ruby
postflight do
  # ❌ NO path validation
  jdk_src = Dir["#{staged_path}/jdk-*"].first
  system_command "cp", args: ["-R", jdk_src, "/Library/..."], sudo: true

  # ❌ String interpolation with user input
  target = "/Library/#{some_variable}/jdk.jdk"  # DANGEROUS

  # ❌ No verification that path is in staging
  jdk_src = "/tmp/malicious/path"  # Could be symlink attack

  # ❌ Using glob without validation
  Dir["#{staged_path}/*"].each do |file|
    # No check if 'file' escapes staging area!
  end
end
```

### 14.4 Command Execution Security

#### Use system_command! (with exclamation)
```ruby
# ✅ Fails immediately on error
system_command! "/usr/bin/ditto",
                args: ["--noqtn", src, dst],
                sudo: true

# ❌ Silently continues on error
system_command "/usr/bin/ditto",
               args: ["--noqtn", src, dst],
               sudo: true
```

#### Command Allowlist

**ONLY use Apple-signed system commands:**
```ruby
# ✅ Allowed commands (Apple-signed)
"/usr/bin/ditto"      # Preferred for copying
"/bin/mkdir"          # Create directories
"/bin/rm"             # Remove files (with caution)
"/bin/chmod"          # Change permissions (rarely needed)
"/bin/ln"             # Create symlinks

# ❌ FORBIDDEN commands
"rsync"               # Not signed by Apple, use ditto
"curl"                # Use Homebrew's download mechanism
"wget"                # Use Homebrew's download mechanism
"bash"                # No arbitrary shell execution
"sh"                  # No arbitrary shell execution
"python"              # No arbitrary code execution
```

#### Argument Safety
```ruby
# ✅ Use args array (prevents injection)
system_command! "/bin/mkdir",
                args: ["-p", directory_path],
                sudo: true

# ❌ NEVER use string interpolation
system_command! "/bin/mkdir -p #{directory_path}", sudo: true  # DANGEROUS

# ❌ NEVER use shell expansion
system_command! "mkdir -p $TARGET_DIR", sudo: true  # DANGEROUS
```

### 14.5 Privilege Escalation Prevention

#### Minimize sudo Usage
```ruby
# ✅ Only use sudo for system locations
postflight do
  # System location - needs sudo
  system_command! "/usr/bin/ditto",
                  args: ["--noqtn", src, "/Library/Java/..."],
                  sudo: true
end

# ✅ User locations - NO sudo needed
postflight do
  # User's home directory - NO sudo
  system_command! "/usr/bin/ditto",
                  args: ["--noqtn", src, "#{Dir.home}/.jdk"],
                  sudo: false
end
```

#### ❌ Dangerous Patterns
```ruby
# ❌ NEVER run arbitrary scripts with sudo
system_command! "#{staged_path}/install.sh", sudo: true  # FORBIDDEN

# ❌ NEVER chmod to 777
system_command! "/bin/chmod", args: ["-R", "777", path], sudo: true  # DANGEROUS

# ❌ NEVER chown to user from root
system_command! "/usr/sbin/chown", args: ["-R", "root:wheel", path], sudo: true  # DANGEROUS
```

### 14.6 Error Handling

#### Use odie for Fatal Errors
```ruby
# ✅ Stop immediately on fatal errors
odie "JDK source directory not found in staged path" if jdk_src.nil?
odie "Expected exactly one JDK bundle" unless candidates.length == 1
odie "Not a directory" unless jdk_src.directory?
odie "Path escapes staging area" unless jdk_src.to_s.start_with?(staged_root.to_s)

# ❌ NEVER silently continue
return if jdk_src.nil?  # Might leave system in bad state
```

#### User-Facing Messages
```ruby
# ✅ Use ohai for informational messages
ohai "Installing JDK 26 EA to #{jdk_target}"
ohai "Removing existing JDK at #{jdk_target}"

# ✅ Use opoo for warnings (non-fatal)
opoo "JDK source directory not found in staged path" if jdk_src.nil?

# ✅ Use odie for fatal errors
odie "Installation failed: source directory not found"
```

### 14.7 File Operations Security

#### Prefer ditto over rsync/cp
```ruby
# ✅ Use ditto (Apple-signed, atomic, preserves metadata)
system_command! "/usr/bin/ditto",
                args: ["--noqtn", src, dst],
                sudo: true

# ❌ Avoid rsync (external tool, potential vulnerabilities)
system_command! "rsync", args: ["-a", src, dst], sudo: true  # NOT RECOMMENDED

# ❌ Avoid cp (less robust than ditto on macOS)
system_command! "/bin/cp", args: ["-R", src, dst], sudo: true  # NOT RECOMMENDED
```

#### ditto Flags
```ruby
# --noqtn: Don't preserve quarantine attributes
# This prevents "app from unidentified developer" warnings
system_command! "/usr/bin/ditto",
                args: ["--noqtn", src, dst],
                sudo: true
```

### 14.8 Cleanup Security

#### Safe Uninstallation
```ruby
uninstall delete: "/Library/Java/JavaVirtualMachines/jdk-26-ea.jdk"

# ✅ Alternative with validation
uninstall_postflight do
  jdk_path = Pathname("/Library/Java/JavaVirtualMachines/jdk-26-ea.jdk")

  if jdk_path.exist? && jdk_path.directory?
    ohai "Removing JDK 26 EA from #{jdk_path}"
    system_command! "/bin/rm",
                    args: ["-rf", jdk_path.to_s],
                    sudo: true
  end
end
```

#### ❌ Dangerous Cleanup Patterns
```ruby
# ❌ NEVER use wildcards with rm -rf
system_command! "/bin/rm", args: ["-rf", "/Library/Java/*"], sudo: true  # DANGEROUS

# ❌ NEVER remove without validation
system_command! "/bin/rm", args: ["-rf", user_provided_path], sudo: true  # DANGEROUS

# ❌ NEVER remove system directories
system_command! "/bin/rm", args: ["-rf", "/usr"], sudo: true  # CATASTROPHIC
```

### 14.9 Download Security

#### HTTPS and Checksum Together
```ruby
# ✅ Both HTTPS and SHA256
on_arm do
  sha256 "dc75cdb507e47a66b0edc73d1cfc4a1c011078d5d0785c7660320d2e9c3e04d4"
  url "https://download.java.net/java/early_access/jdk26/20/GPL/openjdk-26-ea+20_macos-aarch64_bin.tar.gz"
end
```

#### Version Pinning
```ruby
# ✅ Pin exact version in URL
url "https://download.java.net/java/early_access/jdk26/20/GPL/openjdk-26-ea+20_macos-aarch64_bin.tar.gz"

# ❌ NEVER use "latest" or version-less URLs
url "https://example.com/latest/jdk.tar.gz"  # DANGEROUS - no version control
url "https://example.com/jdk-latest.tar.gz"  # DANGEROUS - checksum will break
```

### 14.10 Homebrew Audit Compliance

#### Run Before Every Commit
```bash
# Validate cask
brew audit --cask ./Casks/jdk26ea.rb

# Validate formula
brew audit --formula ./Formula/jdk26ea.rb

# Check style
brew style Casks/jdk26ea.rb
brew style Formula/jdk26ea.rb

# Syntax check
ruby -c Casks/jdk26ea.rb
ruby -c Formula/jdk26ea.rb
```

#### Common Audit Failures
1. **Missing SHA256** - Every URL must have checksum
2. **HTTP instead of HTTPS** - Always use HTTPS
3. **sha256 :no_check** - Forbidden, always verify
4. **Incorrect stanza order** - Follow RuboCop rules
5. **Unsafe system commands** - Use approved commands only

### 14.11 Security Checklist

Before committing formula/cask changes:

**Downloads:**
- [ ] All URLs use HTTPS
- [ ] SHA256 checksums provided for ALL platforms
- [ ] Checksums verified against official sources
- [ ] Version pinned in URLs (no "latest")

**Path Validation:**
- [ ] All paths resolved with `realpath`
- [ ] Paths validated to prevent directory traversal
- [ ] Number of candidates validated
- [ ] Paths confirmed to be directories
- [ ] Paths confirmed within staging area

**Command Execution:**
- [ ] Only Apple-signed commands used
- [ ] `system_command!` (with !) used for critical operations
- [ ] `args` array used (no string interpolation)
- [ ] `sudo` only for system locations
- [ ] No arbitrary script execution

**Error Handling:**
- [ ] Fatal errors use `odie`
- [ ] User messages use `ohai`
- [ ] Warnings use `opoo`
- [ ] No silent failures

**Cleanup:**
- [ ] Uninstall paths validated
- [ ] No wildcards in `rm -rf`
- [ ] Existence checked before deletion

**Validation:**
- [ ] `brew audit --cask` passes
- [ ] `brew style` passes
- [ ] `ruby -c` passes
- [ ] Tested on actual platform

### 14.12 Common Vulnerabilities to Avoid

#### 1. Directory Traversal
```ruby
# ❌ VULNERABLE
jdk_src = Dir["#{staged_path}/../../../etc/passwd"].first

# ✅ SECURE
staged_root = staged_path.realpath
jdk_src = Pathname(Dir["#{staged_root}/jdk-*.jdk"].first).realpath
odie "Path escapes staging" unless jdk_src.to_s.start_with?(staged_root.to_s)
```

#### 2. Command Injection
```ruby
# ❌ VULNERABLE
system_command! "mkdir -p #{user_input}"

# ✅ SECURE
system_command! "/bin/mkdir", args: ["-p", user_input]
```

#### 3. Symlink Attacks
```ruby
# ❌ VULNERABLE - follows symlinks
FileUtils.cp_r(staged_path, target)

# ✅ SECURE - validates real path
staged_root = staged_path.realpath
target = Pathname(target).realpath
```

#### 4. Time-of-Check-Time-of-Use (TOCTOU)
```ruby
# ❌ VULNERABLE - path could change between check and use
if File.exist?(path)
  # Attacker could replace 'path' here via symlink
  system_command! "cp", args: [path, target]
end

# ✅ SECURE - validate and use realpath atomically
path = Pathname(path).realpath
odie "Not in staging" unless path.to_s.start_with?(staged_root.to_s)
system_command! "/usr/bin/ditto", args: ["--noqtn", path.to_s, target.to_s]
```

#### 5. Privilege Escalation via Uncontrolled Paths
```ruby
# ❌ VULNERABLE
system_command! "/bin/chmod", args: ["777", user_path], sudo: true

# ✅ SECURE - validate path first
validated_path = Pathname(user_path).realpath
odie "Invalid path" unless validated_path.to_s.start_with?("/Library/Java/")
system_command! "/bin/chmod", args: ["755", validated_path.to_s], sudo: true
```

### 14.13 References

**Official Homebrew Security Documentation:**
- [Homebrew Security Policy](https://github.com/Homebrew/brew/security/policy) - Security vulnerability reporting
- [Homebrew Cask Security](https://docs.brew.sh/Cask-Cookbook#stanza-sha256) - SHA256 requirements and checksum verification
- [Formula Cookbook - sha256](https://docs.brew.sh/Formula-Cookbook#specifying-other-formulae-as-dependencies) - Checksum best practices
- [system_command API](https://rubydoc.brew.sh/Cask/DSL#system_command-instance_method) - Secure command execution
- [Cask Staged Path](https://rubydoc.brew.sh/Cask/DSL#staged_path-instance_method) - Staging directory handling

**Homebrew Development Guides:**
- [Formula Cookbook](https://docs.brew.sh/Formula-Cookbook) - General formula development
- [Cask Cookbook](https://docs.brew.sh/Cask-Cookbook) - Cask development guide
- [Acceptable Casks](https://docs.brew.sh/Acceptable-Casks) - Cask acceptance criteria
- [Homebrew Governance](https://docs.brew.sh/Homebrew-Governance) - Project governance and policies

**Homebrew Source Code (Security Examples):**
- [Cask DSL Implementation](https://github.com/Homebrew/brew/blob/master/Library/Homebrew/cask/dsl.rb) - DSL security features
- [System Command](https://github.com/Homebrew/brew/blob/master/Library/Homebrew/system_command.rb) - Command execution implementation
- [Quarantine](https://github.com/Homebrew/brew/blob/master/Library/Homebrew/cask/quarantine.rb) - macOS quarantine handling

**Security Best Practices:**
- [OWASP Path Traversal](https://owasp.org/www-community/attacks/Path_Traversal) - Directory traversal prevention
- [OWASP Command Injection](https://owasp.org/www-community/attacks/Command_Injection) - Command injection prevention
- [Apple Code Signing](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution) - Code signing and notarization
- [CWE-22: Path Traversal](https://cwe.mitre.org/data/definitions/22.html) - Common weakness enumeration
- [CWE-78: OS Command Injection](https://cwe.mitre.org/data/definitions/78.html) - Command injection patterns

**Ruby Security:**
- [Ruby Pathname Class](https://ruby-doc.org/stdlib-3.1.0/libdoc/pathname/rdoc/Pathname.html) - Safe path handling
- [Ruby File Class](https://ruby-doc.org/core-3.1.0/File.html) - File operations security
- [Ruby Dir Class](https://ruby-doc.org/core-3.1.0/Dir.html) - Directory operations

**Additional Resources:**
- [Homebrew/homebrew-cask Security](https://github.com/Homebrew/homebrew-cask/blob/master/SECURITY.md) - Cask-specific security
- [macOS Security Compliance Project](https://github.com/usnistgov/macos_security) - macOS security baselines

## 15. Maintenance Schedule

### Daily (Automated):
- `auto-update.yml` checks for new JDK builds at 6 AM UTC

### Weekly (Automated):
- `audit.yml` validates syntax on Monday at 12 PM UTC

### As Needed (Manual):
- Review and merge auto-update PRs
- Address security issues immediately
- Update documentation
- Improve CI/CD processes
- Review security practices quarterly

## Summary

This repository values:
1. **Security** - Path validation, secure commands, checksum verification
2. **Automation** - Daily updates, automatic releases, comprehensive CI
3. **Quality** - RuboCop enforcement, semantic commits, multi-platform testing
4. **Simplicity** - Clear documentation, single maintainer model
5. **Reliability** - Early detection of issues, rollback capabilities

When in doubt, prioritize security and let automation handle routine tasks.
