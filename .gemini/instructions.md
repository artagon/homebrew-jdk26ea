<!-- AUTO-GENERATED from .model-context/
     DO NOT EDIT DIRECTLY - Edit .model-context/shared/ instead
     Last synced: 2025-10-25 09:56:23 UTC
     Agent: Gemini Code Assist -->

<!-- BEGIN: .model-context/shared/instructions.md -->
<!-- AUTO-GENERATED from .ai-context/
     DO NOT EDIT DIRECTLY - Edit .ai-context/shared/ instead
     Last synced: 2025-10-25 09:39:59 UTC
     Agent: Claude Code -->

<!-- BEGIN: .ai-context/shared/instructions.md -->
# AI Assistant Instructions for homebrew-jdk26ea

## Repository-Specific Guidelines

When working with this repository, AI assistants (Claude/ChatGPT/Codex/Gemini/Grok) should follow these specific instructions:

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

**IMPORTANT:** Do NOT include AI attribution in commits.

Commit messages should follow the standard format without any AI-related footers:
```
type(scope): description

[optional body]
```

No co-author or AI attribution footer should be added. Commits should appear
as regular human-authored commits without mentioning AI assistance.

## 2. Ruby Code Style

### RuboCop Rules
- Run `brew style` to validate changes
- Run `brew audit --cask` for cask validation
- Never bypass style checks (no `|| true`)

### Cask Stanza Ordering
```ruby
cask "jdk26ea" do
  arch arm: "aarch64", intel: "x64"

  version "...,..."

  sha256 arm:   "...",
         intel: "..."

  url "https://download.java.net/java/early_access/jdk26/#{version.csv.second}/GPL/openjdk-#{version.csv.first}_macos-#{arch}_bin.tar.gz"
  name "..."
  desc "..."
  homepage "..."

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

## 15. GitHub Actions Workflow Security Best Practices

### Overview

GitHub Actions workflows run with elevated privileges and have access to repository secrets. Compromised workflows can lead to supply chain attacks, secret exposure, and repository takeover. This section outlines critical security practices for all workflow files.

### 15.1 Action Version Pinning

**CRITICAL:** Never use mutable references (branches or tags) for third-party actions.

#### ✅ Secure Pattern
```yaml
# Pin to immutable commit SHA
- uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11  # v4.1.1
- uses: peter-evans/create-pull-request@153407881ec5c347639a548ade7d8ad1d6740e38  # v5.0.0

# Add comment with version for maintainability
```

#### ❌ Insecure Patterns
```yaml
# NEVER use branch references
- uses: Homebrew/actions/setup-homebrew@master  # DANGEROUS - mutable

# NEVER use tag references
- uses: peter-evans/create-pull-request@v5  # DANGEROUS - tags can be moved
- uses: softprops/action-gh-release@v1  # DANGEROUS - mutable tag

# Tags can be deleted and recreated pointing to malicious code
```

#### Why Pin to Commit SHAs?
1. **Immutability** - Commits cannot be changed once created
2. **Supply Chain Security** - Prevents upstream compromise from affecting your workflows
3. **Reproducibility** - Same commit SHA always runs same code
4. **Audit Trail** - Easy to verify exactly what code ran

#### How to Pin Actions
```bash
# Find the commit SHA for a specific version
gh api repos/actions/checkout/commits/v4.1.1 --jq '.sha'

# Or visit GitHub and find the commit SHA for the tag
# Example: https://github.com/actions/checkout/releases/tag/v4.1.1
```

#### Updating Pinned Actions
```yaml
# Before (old)
- uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11  # v4.1.1

# After (new version)
- uses: actions/checkout@8e5e7e5ab8b370d6c329ec480221332ada57f0ab  # v4.1.2
```

#### Allowlist for First-Party Actions
GitHub's official actions can use semantic versions (but SHA pinning is still preferred):
```yaml
# Acceptable (GitHub-maintained)
- uses: actions/checkout@v4
- uses: actions/setup-node@v4

# But SHA pinning is still better
- uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11  # v4.1.1
```

### 15.2 Secret and Token Security

#### NEVER Expose Tokens in Logs
```yaml
# ❌ DANGEROUS - token could leak in error messages
- name: Update commit status
  run: |
    curl -sS \
         -X POST \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
         -H "Accept: application/vnd.github+json" \
         "https://api.github.com/repos/${REPO}/statuses/${SHA}" \
         -d '{"state":"success"}'
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

#### ✅ Use GitHub CLI or Actions
```yaml
# Secure - uses gh CLI which handles token safely
- name: Update commit status
  run: |
    gh api repos/${{ github.repository }}/statuses/${{ github.sha }} \
      -X POST \
      -F state=success \
      -F context=ValidateExpected \
      -F description="All validation jobs completed successfully."
  env:
    GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

#### Token Permissions Principle of Least Privilege
```yaml
# ✅ Minimal permissions
permissions:
  contents: read
  pull-requests: write

# ❌ Excessive permissions
permissions:
  contents: write  # Too broad if only creating PRs
  pull-requests: write
  issues: write  # Not needed
```

#### Permission Scopes
```yaml
# For auto-update workflows that only create PRs
permissions:
  contents: read        # Read repository
  pull-requests: write  # Create PRs

# For release workflows that create tags
permissions:
  contents: write  # Create tags and releases

# For workflows that update commit status
permissions:
  statuses: write
```

#### Secret Masking
```yaml
# Secrets are automatically masked in logs
- name: Use secret
  run: echo "Token is ${{ secrets.MY_SECRET }}"  # Outputs: Token is ***

# But be careful with base64 encoding or other transformations
- name: DANGEROUS - unmasks secret
  run: echo "${{ secrets.MY_SECRET }}" | base64  # NOT masked!
```

### 15.3 Input Validation and Injection Prevention

#### Command Injection via grep/sed
```yaml
# ❌ VULNERABLE - no validation
- name: Fetch version
  run: |
    BUILD=$(grep -oP 'Build \K[0-9]+' page.html | head -1)
    echo "build=$BUILD" >> $GITHUB_OUTPUT
```

#### ✅ Secure with Validation
```yaml
- name: Fetch version
  run: |
    BUILD=$(grep -oP 'Build \K[0-9]+' page.html | head -1)

    # Validate build number
    if ! [[ "$BUILD" =~ ^[0-9]{1,3}$ ]]; then
      echo "Invalid build number: $BUILD"
      exit 1
    fi

    echo "build=$BUILD" >> $GITHUB_OUTPUT
```

#### URL Validation
```yaml
# ❌ VULNERABLE - no validation
- name: Extract URL
  run: |
    URL=$(grep -oP 'href="\K[^"]*openjdk.*\.tar\.gz' page.html | head -1)
    curl -O "$URL"
```

#### ✅ Secure with Validation
```yaml
- name: Extract URL
  run: |
    URL=$(grep -oP 'href="\K[^"]*openjdk.*\.tar\.gz' page.html | head -1)

    # Validate URL format
    if ! [[ "$URL" =~ ^https://download\.java\.net/java/early_access/jdk26/[0-9]+/GPL/openjdk-26-ea\+[0-9]+_[a-z0-9_-]+\.tar\.gz$ ]]; then
      echo "Invalid URL format: $URL"
      exit 1
    fi

    # Validate domain
    if [[ "$URL" != https://download.java.net/* ]]; then
      echo "URL not from trusted domain: $URL"
      exit 1
    fi

    curl -fsSL "$URL" -o download.tar.gz
```

#### Script Injection Prevention
```yaml
# ❌ VULNERABLE to script injection
- name: Create commit message
  run: |
    git commit -m "Update to ${{ github.event.issue.title }}"

# User-controlled input (issue title) could contain `"; rm -rf / #`
```

#### ✅ Secure with Quoting
```yaml
- name: Create commit message
  run: |
    git commit -m "Update to $ISSUE_TITLE"
  env:
    ISSUE_TITLE: ${{ github.event.issue.title }}
```

### 15.4 Checksum Verification

**CRITICAL:** Always verify checksums of downloaded artifacts.

#### ❌ No Verification
```yaml
- name: Download and use checksums
  run: |
    SHA_MAC_ARM=$(curl -sL "${URL_MAC_ARM}.sha256")
    echo "sha_mac_arm=$SHA_MAC_ARM" >> $GITHUB_OUTPUT
    # NEVER VERIFIED THE ACTUAL DOWNLOAD!
```

#### ✅ Download and Verify
```yaml
- name: Download and verify checksums
  run: |
    URL_MAC_ARM="https://download.java.net/java/early_access/jdk26/${BUILD}/GPL/openjdk-26-ea+${BUILD}_macos-aarch64_bin.tar.gz"

    # Download file
    curl -fsSL "$URL_MAC_ARM" -o openjdk-macos-arm.tar.gz

    # Download checksum
    EXPECTED_SHA=$(curl -fsSL "${URL_MAC_ARM}.sha256" | awk '{print $1}')

    # Verify checksum
    ACTUAL_SHA=$(shasum -a 256 openjdk-macos-arm.tar.gz | awk '{print $1}')

    if [ "$EXPECTED_SHA" != "$ACTUAL_SHA" ]; then
      echo "Checksum mismatch!"
      echo "Expected: $EXPECTED_SHA"
      echo "Actual: $ACTUAL_SHA"
      exit 1
    fi

    echo "✓ Checksum verified"
    echo "sha_mac_arm=$ACTUAL_SHA" >> $GITHUB_OUTPUT
```

### 15.5 Workflow Permissions and GITHUB_TOKEN

#### Default Permissions (Dangerous)
```yaml
# ❌ No permissions specified - uses defaults
# Default is often 'write' for contents, which is excessive
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Has write access by default"
```

#### ✅ Explicit Minimal Permissions
```yaml
# Specify permissions at workflow level
permissions:
  contents: read

# Or at job level for granular control
jobs:
  test:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@v4

  deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: write  # Only this job can write
    steps:
      - run: echo "Deploy step"
```

#### Permission Levels
```yaml
permissions:
  actions: read|write|none           # GitHub Actions workflows
  checks: read|write|none            # Check runs and check suites
  contents: read|write|none          # Repository contents, commits, branches, tags
  deployments: read|write|none       # Deployments
  issues: read|write|none            # Issues and issue comments
  packages: read|write|none          # GitHub Packages
  pages: read|write|none             # GitHub Pages
  pull-requests: read|write|none     # Pull requests
  repository-projects: read|write|none # Projects (classic)
  security-events: read|write|none   # Security events (CodeQL, Dependabot)
  statuses: read|write|none          # Commit statuses
```

### 15.6 Preventing Direct Commits to Main

#### ❌ Dangerous Pattern
```yaml
# Commits directly to main, bypassing PR reviews
- name: Update README
  run: |
    sed -i "s/old/new/" README.md
    git config user.name "github-actions[bot]"
    git config user.email "github-actions[bot]@users.noreply.github.com"
    git add README.md
    git commit -m "docs: update README"
    git push  # PUSHES DIRECTLY TO MAIN!
```

#### ✅ Create PR Instead
```yaml
- name: Update README
  run: |
    sed -i "s/old/new/" README.md

- name: Create Pull Request
  uses: peter-evans/create-pull-request@153407881ec5c347639a548ade7d8ad1d6740e38  # v5.0.0
  with:
    commit-message: "docs: update README"
    title: "docs: update README with latest version"
    body: "Auto-generated update to README"
    branch: update-readme-${{ github.run_id }}
    delete-branch: true
```

#### Exception: Documentation-Only Updates
If you MUST commit directly (not recommended):
```yaml
# Only if branch protection allows bot commits
- name: Update README
  run: |
    sed -i "s/old/new/" README.md
    git diff --quiet && exit 0  # Exit if no changes

    git config user.name "github-actions[bot]"
    git config user.email "github-actions[bot]@users.noreply.github.com"
    git add README.md
    git commit -m "docs: update README [skip ci]"
    git push
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### 15.7 Dependency Confusion and Typosquatting

#### Verify Action Sources
```yaml
# ✅ Official GitHub actions
- uses: actions/checkout@v4
- uses: actions/setup-node@v4

# ✅ Well-known trusted actions
- uses: peter-evans/create-pull-request@v5  # Verified author
- uses: softprops/action-gh-release@v1      # Verified author

# ⚠️ Unknown actions - VERIFY FIRST
- uses: random-user/suspicious-action@v1  # Check source code first!
```

#### Check Action Marketplace
1. Visit https://github.com/marketplace/actions
2. Verify action is published by trusted author
3. Check number of stars and usage
4. Review source code before using
5. Pin to specific commit SHA after verification

### 15.8 Secure Environment Variables

#### ✅ Secure Patterns
```yaml
- name: Use environment variables
  run: |
    echo "Building version $VERSION"
    ./build.sh
  env:
    VERSION: ${{ steps.version.outputs.value }}
    NODE_ENV: production
```

#### ❌ Insecure Patterns
```yaml
# DANGEROUS - secret in command line (visible in process list)
- run: ./deploy.sh --token=${{ secrets.DEPLOY_TOKEN }}

# DANGEROUS - secret could leak in error messages
- run: |
    curl -H "Authorization: Bearer ${{ secrets.API_TOKEN }}" https://api.example.com
```

#### ✅ Secure Alternative
```yaml
- run: ./deploy.sh
  env:
    DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}

- run: |
    curl -H "Authorization: Bearer $API_TOKEN" https://api.example.com
  env:
    API_TOKEN: ${{ secrets.API_TOKEN }}
```

### 15.9 Pull Request Security

#### Dangerous: pull_request_target
```yaml
# ❌ EXTREMELY DANGEROUS
on: pull_request_target  # Runs with WRITE token in PR from fork!

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ github.event.pull_request.head.sha }}  # Checks out untrusted code
      - run: npm install  # Could run malicious install scripts!
      - run: npm test     # Could exfiltrate secrets!
```

#### ✅ Use pull_request for Untrusted Code
```yaml
# Safe for PRs from forks
on: pull_request

permissions:
  contents: read  # Read-only token, no access to secrets

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm install
      - run: npm test
```

#### When to Use pull_request_target
Only use when:
1. You need write access (e.g., to add labels)
2. You DO NOT checkout PR code
3. You only run trusted code

```yaml
on: pull_request_target

permissions:
  pull-requests: write

jobs:
  label:
    runs-on: ubuntu-latest
    steps:
      # DO NOT checkout PR code
      - name: Add label
        run: gh pr edit ${{ github.event.pull_request.number }} --add-label "needs-review"
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### 15.10 Runner Security

#### Self-Hosted Runners
```yaml
# ❌ NEVER use self-hosted runners for public repos
runs-on: self-hosted  # DANGEROUS for public repositories!

# ✅ Use GitHub-hosted runners for public repos
runs-on: ubuntu-latest
runs-on: macos-latest
runs-on: windows-latest
```

#### Why Self-Hosted Runners Are Dangerous for Public Repos
1. PRs from forks can execute arbitrary code
2. Attackers can mine cryptocurrency
3. Attackers can exfiltrate secrets
4. Attackers can persist backdoors on runner
5. Attackers can pivot to internal network

#### Self-Hosted Runners Only For:
- Private repositories with trusted contributors
- Behind strict network segmentation
- With ephemeral runners (destroyed after each job)
- With no access to sensitive resources

### 15.11 Workflow Security Checklist

Before committing workflow changes:

**Action Pinning:**
- [ ] All third-party actions pinned to commit SHAs
- [ ] Comments added with version tags for maintainability
- [ ] Actions verified from trusted sources

**Token Security:**
- [ ] No tokens in command-line arguments
- [ ] No tokens in curl commands
- [ ] GitHub CLI used for API calls
- [ ] Minimal permissions specified
- [ ] Secrets used via environment variables only

**Input Validation:**
- [ ] All scraped values validated with regex
- [ ] Build numbers bounded (e.g., 1-999)
- [ ] URLs validated for correct domain
- [ ] URLs validated for correct format
- [ ] No user-controlled input in shell commands

**Checksum Verification:**
- [ ] Files downloaded and verified (not just checksums fetched)
- [ ] Checksums compared before using values
- [ ] Failures halt workflow execution

**Permissions:**
- [ ] Explicit permissions defined
- [ ] Minimal permissions used
- [ ] Write permissions only when necessary
- [ ] No pull_request_target with code checkout

**Branch Protection:**
- [ ] No direct commits to main
- [ ] PRs used for all changes (or clear justification)
- [ ] Status checks required before merge

**General:**
- [ ] No self-hosted runners for public repos
- [ ] YAML syntax validated
- [ ] Workflow tested in fork first
- [ ] Error handling for all critical steps

### 15.12 Example Secure Workflow

```yaml
name: Secure Auto-Update

on:
  schedule:
    - cron: '0 6 * * *'
  workflow_dispatch:

# Minimal permissions
permissions:
  contents: read
  pull-requests: write

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      # Pinned to commit SHA
      - name: Checkout repository
        uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11  # v4.1.1

      - name: Fetch and validate version
        id: version
        run: |
          # Fetch page
          curl -fsSL "https://jdk.java.net/26/" -o page.html

          # Extract build number
          BUILD=$(grep -oP 'Build \K[0-9]+' page.html | head -1)

          # Validate build number format and range
          if ! [[ "$BUILD" =~ ^[0-9]{1,3}$ ]]; then
            echo "Invalid build number format: $BUILD"
            exit 1
          fi

          if [ "$BUILD" -lt 1 ] || [ "$BUILD" -gt 999 ]; then
            echo "Build number out of range: $BUILD"
            exit 1
          fi

          echo "build=$BUILD" >> $GITHUB_OUTPUT
          echo "✓ Build number validated: $BUILD"

      - name: Download and verify checksums
        id: checksums
        run: |
          BUILD=${{ steps.version.outputs.build }}

          # Construct and validate URL
          URL="https://download.java.net/java/early_access/jdk26/${BUILD}/GPL/openjdk-26-ea+${BUILD}_macos-aarch64_bin.tar.gz"

          if ! [[ "$URL" =~ ^https://download\.java\.net/java/early_access/jdk26/[0-9]+/GPL/openjdk-26-ea\+[0-9]+_macos-aarch64_bin\.tar\.gz$ ]]; then
            echo "Invalid URL format: $URL"
            exit 1
          fi

          # Download file
          curl -fsSL "$URL" -o jdk.tar.gz

          # Download checksum
          EXPECTED_SHA=$(curl -fsSL "${URL}.sha256" | awk '{print $1}')

          # Verify checksum format
          if ! [[ "$EXPECTED_SHA" =~ ^[a-f0-9]{64}$ ]]; then
            echo "Invalid SHA256 format: $EXPECTED_SHA"
            exit 1
          fi

          # Compute actual checksum
          ACTUAL_SHA=$(shasum -a 256 jdk.tar.gz | awk '{print $1}')

          # Verify match
          if [ "$EXPECTED_SHA" != "$ACTUAL_SHA" ]; then
            echo "❌ Checksum mismatch!"
            echo "Expected: $EXPECTED_SHA"
            echo "Actual: $ACTUAL_SHA"
            exit 1
          fi

          echo "✓ Checksum verified: $ACTUAL_SHA"
          echo "sha=$ACTUAL_SHA" >> $GITHUB_OUTPUT

      - name: Update files
        run: |
          BUILD=${{ steps.version.outputs.build }}
          SHA=${{ steps.checksums.outputs.sha }}

          # Update cask
          sed -i "s/version \".*\"/version \"26-ea+${BUILD}\"/" Casks/jdk26ea.rb
          sed -i "s/sha256 \"[a-f0-9]*\"/sha256 \"${SHA}\"/" Casks/jdk26ea.rb

      - name: Validate changes
        run: |
          ruby -c Casks/jdk26ea.rb
          ruby -c Formula/jdk26ea.rb

      - name: Create Pull Request
        uses: peter-evans/create-pull-request@153407881ec5c347639a548ade7d8ad1d6740e38  # v5.0.0
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          commit-message: "chore: update to JDK 26 EA Build ${{ steps.version.outputs.build }}"
          title: "chore: update to JDK 26 EA Build ${{ steps.version.outputs.build }}"
          body: |
            ## Automated Update

            Build: ${{ steps.version.outputs.build }}
            SHA256: ${{ steps.checksums.outputs.sha }}

            Verified checksum matches official source.
          branch: update/build-${{ steps.version.outputs.build }}
          delete-branch: true
```

### 15.13 Security Resources

**GitHub Documentation:**
- [Security hardening for GitHub Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- [Automatic token authentication](https://docs.github.com/en/actions/security-guides/automatic-token-authentication)
- [Using secrets in GitHub Actions](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Keeping your GitHub Actions secure](https://docs.github.com/en/actions/security-guides)

**Best Practices:**
- [GitHub Actions Security Best Practices](https://github.com/step-security/github-actions-goat) - Hands-on security examples
- [OpenSSF Scorecard](https://github.com/ossf/scorecard) - Automated security checks
- [Pinned Actions Monitor](https://github.com/mheap/pin-github-action) - Keep pinned actions updated

**Tools:**
- [actionlint](https://github.com/rhysd/actionlint) - Static checker for workflow files
- [GitGuardian](https://www.gitguardian.com/) - Secret scanning
- [Snyk](https://snyk.io/) - Dependency and action vulnerability scanning

### 15.14 Common Vulnerabilities

| Vulnerability | Impact | Severity | Fix |
|--------------|--------|----------|-----|
| Unpinned actions | Supply chain attack | Critical | Pin to commit SHA |
| Token in curl | Secret exposure | Critical | Use gh CLI or env vars |
| No input validation | Code injection | Critical | Validate all inputs |
| No checksum verification | Malicious downloads | High | Verify checksums |
| Excessive permissions | Privilege escalation | High | Minimal permissions |
| Direct commits to main | Bypass reviews | Medium | Use PRs |
| pull_request_target misuse | Secret exposure | Critical | Use pull_request |
| Self-hosted runners (public) | Full compromise | Critical | Use GitHub-hosted |

## 16. AI Assistant Configuration Synchronization

### Overview

This repository uses two locations for AI assistant configuration:
- `.agents` - File pointer to agent configuration directory
- `.claude/` - Directory containing actual configuration files
  - `.claude/instructions.md` - This file (AI assistant instructions)
  - `.claude/context.md` - Repository context and architecture

**CRITICAL:** Changes to AI configuration files must be synchronized to maintain consistency.

### 16.1 Current Configuration Structure

```
homebrew-jdk26/
├── .agents                    # Points to: .claude
└── .claude/
    ├── instructions.md        # AI assistant behavioral instructions
    └── context.md            # Repository context and architecture
```

### 16.2 Synchronization Rules

#### When Modifying .claude/instructions.md or .claude/context.md

**ALWAYS follow these steps:**

1. **Make changes to files in `.claude/` directory**
   ```bash
   # Edit the actual files
   vim .claude/instructions.md
   vim .claude/context.md
   ```

2. **Verify .agents file points to .claude**
   ```bash
   cat .agents
   # Should output: .claude
   ```

3. **If .agents content is incorrect, update it:**
   ```bash
   echo ".claude" > .agents
   ```

4. **Commit both locations together:**
   ```bash
   git add .agents .claude/instructions.md .claude/context.md
   git commit -m "docs: update AI assistant configuration"
   ```

#### When .agents File Changes

If the `.agents` file is modified to point to a different location:

1. **Create the new directory structure**
2. **Copy existing configuration files**
   ```bash
   NEW_DIR=$(cat .agents)
   mkdir -p "$NEW_DIR"
   cp .claude/instructions.md "$NEW_DIR/"
   cp .claude/context.md "$NEW_DIR/"
   ```

3. **Update both locations going forward**
4. **Document the change in commit message**

### 16.3 AI Assistant Responsibilities

When an AI assistant (Claude/ChatGPT/Codex/Gemini/Grok) modifies configuration:

#### Before Making Changes

1. **Check current configuration:**
   ```bash
   # Verify .agents points to .claude
   cat .agents

   # List configuration files
   ls -la .claude/
   ```

2. **Read both files to understand current state:**
   ```bash
   cat .claude/instructions.md
   cat .claude/context.md
   ```

#### After Making Changes

1. **Verify file integrity:**
   ```bash
   # Check markdown syntax
   mdl .claude/instructions.md || echo "No markdown linter installed"
   mdl .claude/context.md || echo "No markdown linter installed"

   # Check file is not empty
   [ -s .claude/instructions.md ] || echo "ERROR: instructions.md is empty!"
   [ -s .claude/context.md ] || echo "ERROR: context.md is empty!"
   ```

2. **Verify .agents pointer:**
   ```bash
   AGENTS_DIR=$(cat .agents)
   if [ "$AGENTS_DIR" != ".claude" ]; then
     echo "WARNING: .agents points to $AGENTS_DIR, not .claude"
     echo "Synchronization may be needed"
   fi
   ```

3. **Create atomic commit:**
   ```bash
   git add .agents .claude/instructions.md .claude/context.md
   git commit -m "docs: update AI configuration - [brief description]"
   ```

#### Validation Checklist

Before committing configuration changes, verify:

- [ ] `.agents` file exists and is not empty
- [ ] `.agents` contains valid directory path
- [ ] Directory referenced in `.agents` exists
- [ ] `instructions.md` exists in configuration directory
- [ ] `context.md` exists in configuration directory
- [ ] Both markdown files are valid and not empty
- [ ] Both markdown files have proper formatting
- [ ] Changes are documented in commit message
- [ ] All files committed together (atomic commit)

### 16.4 Synchronization Automation

#### Manual Sync Script (Future Enhancement)

If synchronization becomes complex, create `scripts/sync-agents.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

AGENTS_DIR=$(cat .agents)

# Ensure directory exists
mkdir -p "$AGENTS_DIR"

# Sync files
cp .claude/instructions.md "$AGENTS_DIR/"
cp .claude/context.md "$AGENTS_DIR/"

echo "✓ Synchronized .claude/ → $AGENTS_DIR/"
```

#### Git Pre-Commit Hook (Future Enhancement)

Add to `.githooks/pre-commit`:

```bash
#!/usr/bin/env bash

# Check if AI configuration files are being committed
if git diff --cached --name-only | grep -qE '\.claude/|\.agents'; then
  AGENTS_DIR=$(cat .agents 2>/dev/null || echo ".claude")

  # Verify .agents points to .claude
  if [ "$AGENTS_DIR" != ".claude" ]; then
    echo "ERROR: .agents must point to .claude"
    echo "Current value: $AGENTS_DIR"
    exit 1
  fi

  # Verify required files exist
  if [ ! -f .claude/instructions.md ]; then
    echo "ERROR: .claude/instructions.md is missing"
    exit 1
  fi

  if [ ! -f .claude/context.md ]; then
    echo "ERROR: .claude/context.md is missing"
    exit 1
  fi

  echo "✓ AI configuration validation passed"
fi
```

### 16.5 Common Synchronization Scenarios

#### Scenario 1: Adding New Section to instructions.md

```bash
# 1. Edit the file
vim .claude/instructions.md

# 2. Verify changes
git diff .claude/instructions.md

# 3. Verify .agents is correct
cat .agents  # Should show: .claude

# 4. Commit everything together
git add .agents .claude/instructions.md
git commit -m "docs(instructions): add section on X"
```

#### Scenario 2: Updating Repository Context

```bash
# 1. Edit context
vim .claude/context.md

# 2. Review changes
git diff .claude/context.md

# 3. Commit with .agents
git add .agents .claude/context.md
git commit -m "docs(context): update architecture documentation"
```

#### Scenario 3: Restructuring Configuration

```bash
# If moving from .claude to .ai-config (example)

# 1. Create new directory
mkdir .ai-config

# 2. Copy files
cp .claude/instructions.md .ai-config/
cp .claude/context.md .ai-config/

# 3. Update pointer
echo ".ai-config" > .agents

# 4. Verify
cat .agents
ls -la .ai-config/

# 5. Commit all changes
git add .agents .ai-config/ .claude/
git commit -m "refactor: restructure AI configuration from .claude to .ai-config"

# 6. Update this section in instructions.md
```

### 16.6 Error Prevention

#### ❌ Anti-Patterns (NEVER Do This)

```bash
# DON'T: Modify only .agents without updating content
echo "wrong-directory" > .agents
git commit -m "update agents"  # Files don't exist in wrong-directory!

# DON'T: Modify configuration files without committing .agents
vim .claude/instructions.md
git add .claude/instructions.md  # Missing .agents!
git commit -m "update instructions"

# DON'T: Create inconsistent state
echo ".agents-config" > .agents  # Points to .agents-config
vim .claude/instructions.md      # But modifying .claude
# Now .agents points to wrong location!

# DON'T: Commit empty configuration files
echo "" > .claude/instructions.md
git add .claude/instructions.md
git commit -m "clear instructions"  # AI assistants won't work!
```

#### ✅ Best Practices

```bash
# DO: Always verify before committing
cat .agents                      # Check pointer
ls -la .claude/                  # Check files exist
wc -l .claude/instructions.md    # Check file has content
git diff .claude/                # Review changes

# DO: Atomic commits
git add .agents .claude/instructions.md .claude/context.md
git commit -m "docs: comprehensive update to AI configuration"

# DO: Descriptive commit messages
git commit -m "docs(instructions): add GitHub Actions security best practices

- Added section 15 with workflow security guidelines
- Covers action pinning, token security, input validation
- Includes example secure workflow
- References official security resources"

# DO: Test after changes
# Ask AI assistant a question to verify it can read new instructions
```

### 16.7 Troubleshooting

#### Problem: AI Assistant Not Following New Instructions

**Diagnosis:**
```bash
# Check .agents pointer
cat .agents

# Check files exist
ls -la $(cat .agents)

# Check file contents
head -20 $(cat .agents)/instructions.md
```

**Solution:**
```bash
# Ensure .agents points to correct directory
echo ".claude" > .agents

# Verify files are not empty
[ -s .claude/instructions.md ] && echo "✓ instructions.md has content" || echo "✗ instructions.md is empty"
[ -s .claude/context.md ] && echo "✓ context.md has content" || echo "✗ context.md is empty"

# Commit fix
git add .agents .claude/
git commit -m "fix: restore AI configuration integrity"
```

#### Problem: .agents Points to Non-Existent Directory

**Diagnosis:**
```bash
AGENTS_DIR=$(cat .agents)
echo "Points to: $AGENTS_DIR"
ls -la "$AGENTS_DIR" 2>&1
```

**Solution:**
```bash
# Option 1: Create missing directory and populate
mkdir -p "$AGENTS_DIR"
cp .claude/instructions.md "$AGENTS_DIR/"
cp .claude/context.md "$AGENTS_DIR/"

# Option 2: Fix .agents to point to .claude
echo ".claude" > .agents
git add .agents
git commit -m "fix: correct .agents pointer to .claude"
```

#### Problem: Configuration Files Out of Sync

**Diagnosis:**
```bash
AGENTS_DIR=$(cat .agents)
diff .claude/instructions.md "$AGENTS_DIR/instructions.md"
diff .claude/context.md "$AGENTS_DIR/context.md"
```

**Solution:**
```bash
# If .claude is the source of truth
AGENTS_DIR=$(cat .agents)
cp .claude/instructions.md "$AGENTS_DIR/"
cp .claude/context.md "$AGENTS_DIR/"

# Commit sync
git add .agents "$AGENTS_DIR/"
git commit -m "fix: synchronize AI configuration between .claude and $AGENTS_DIR"
```

### 16.8 Integration with CI/CD

#### Validation in GitHub Actions

Add to `.github/workflows/validate.yml`:

```yaml
- name: Validate AI configuration
  run: |
    # Check .agents exists
    if [ ! -f .agents ]; then
      echo "ERROR: .agents file missing"
      exit 1
    fi

    # Check .agents is not empty
    if [ ! -s .agents ]; then
      echo "ERROR: .agents file is empty"
      exit 1
    fi

    # Read .agents
    AGENTS_DIR=$(cat .agents)
    echo "AI configuration directory: $AGENTS_DIR"

    # Verify directory exists
    if [ ! -d "$AGENTS_DIR" ]; then
      echo "ERROR: Directory $AGENTS_DIR does not exist"
      exit 1
    fi

    # Verify required files exist and are not empty
    if [ ! -s "$AGENTS_DIR/instructions.md" ]; then
      echo "ERROR: $AGENTS_DIR/instructions.md missing or empty"
      exit 1
    fi

    if [ ! -s "$AGENTS_DIR/context.md" ]; then
      echo "ERROR: $AGENTS_DIR/context.md missing or empty"
      exit 1
    fi

    echo "✓ AI configuration validation passed"
```

### 16.9 Migration Guide

If changing configuration structure in the future:

1. **Document the change:**
   ```markdown
   ## Migration: .claude → .ai-config (2025-10-25)

   Reason: [explain why]
   Impact: AI assistants will read from new location
   ```

2. **Create migration script:**
   ```bash
   #!/usr/bin/env bash
   # scripts/migrate-ai-config.sh

   # Create new structure
   mkdir -p .ai-config
   cp .claude/instructions.md .ai-config/
   cp .claude/context.md .ai-config/

   # Update pointer
   echo ".ai-config" > .agents

   # Verify
   ls -la .ai-config/
   cat .agents
   ```

3. **Update this section** with new structure
4. **Notify collaborators** (if any)
5. **Update CI/CD** validation scripts
6. **Archive old location** (don't delete immediately)

### 16.10 Summary: Quick Reference

**Every time you modify AI configuration:**

```bash
# 1. Check current state
cat .agents && ls -la .claude/

# 2. Make your changes
vim .claude/instructions.md
vim .claude/context.md

# 3. Verify integrity
[ -s .claude/instructions.md ] && [ -s .claude/context.md ] && echo "✓ Files have content"

# 4. Atomic commit
git add .agents .claude/instructions.md .claude/context.md
git commit -m "docs: [description of changes]"

# 5. Verify commit
git show --stat
```

**Key Principles:**
- `.agents` and `.claude/` must always be in sync
- Never commit empty configuration files
- Always commit `.agents` with configuration changes
- Use atomic commits for all configuration changes
- Validate before and after modifications

## 17. Maintenance Schedule

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
- Update pinned action SHAs when new versions released
- Validate AI configuration synchronization

## Summary

This repository values:
1. **Security** - Path validation, secure commands, checksum verification
2. **Automation** - Daily updates, automatic releases, comprehensive CI
3. **Quality** - RuboCop enforcement, semantic commits, multi-platform testing
4. **Simplicity** - Clear documentation, single maintainer model
5. **Reliability** - Early detection of issues, rollback capabilities

When in doubt, prioritize security and let automation handle routine tasks.


<!-- END: .ai-context/shared/instructions.md -->

<!-- BEGIN: .ai-context/shared/security.md -->
# AI Security Guidelines for homebrew-jdk26ea

## Critical Security Practices

### 1. GitHub Actions Security
- Pin ALL actions to commit SHAs (not tags/branches)
- Validate all external inputs with regex
- Use `gh` CLI instead of curl for API calls
- Download and verify checksums (don't just fetch)
- Use minimal permissions
- Never expose tokens in logs

### 2. Cask/Formula Security
- Use `realpath` for all path operations
- Validate paths stay within staging area
- Use `ditto` instead of `rsync`
- Use `system_command!` (with !) for error handling
- Verify SHA256 checksums for ALL platforms

### 3. Input Validation
- Build numbers: `^[0-9]{1,3}$`
- URLs: Must match `https://download.java.net/...`
- SHA256: `^[a-f0-9]{64}$`
- Bound all numeric values (1-999)

### 4. Commit Security
- Follow semantic commit format
- Never bypass git hooks
- Create PRs instead of direct commits
- Run validation before committing

<!-- END: .ai-context/shared/security.md -->

<!-- BEGIN: .ai-context/shared/style-guide.md -->
# Code Style Guide for homebrew-jdk26ea

## Commit Messages
Format: `type(scope): description`

Valid types: feat, fix, docs, style, refactor, perf, test, chore, ci
Valid scopes: cask, formula, workflow, docs, scripts

Examples:
- `feat(cask): add support for JDK 26 EA Build 21`
- `fix(formula): correct SHA256 checksum`
- `ci(workflow): pin action to commit SHA`

## Ruby/Homebrew Style
- Run `brew style` before committing
- Run `brew audit --cask` for validation
- Maintain stanza ordering
- Use empty lines between stanza groups

## Workflow Style
- Pin actions to commit SHAs with version comments
- Validate all inputs
- Use minimal permissions
- Add error handling to all critical steps

<!-- END: .ai-context/shared/style-guide.md -->

<!-- BEGIN: .ai-context/agents/claude.md -->
# Claude Code Specific Instructions

This file contains Claude Code specific instructions.
Shared context is loaded from:
- .ai-context/shared/instructions.md
- .ai-context/shared/context.md
- .ai-context/shared/security.md
- .ai-context/shared/style-guide.md

## Claude-Specific Features
- Use TodoWrite tool for task tracking
- Use Task tool for complex multi-step operations
- Prefer Edit tool over Write for existing files
- Use Grep/Glob for searching (not bash)

<!-- END: .ai-context/agents/claude.md -->


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

