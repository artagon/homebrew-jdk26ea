# Contributing to homebrew-jdk26

Thank you for your interest in contributing to the JDK 26 Early Access Homebrew tap!

## How to Report Issues

If you encounter any problems with the JDK 26 EA installation or have suggestions for improvement:

1. **Check existing issues** - Search the [issue tracker](https://github.com/Artagon/homebrew-jdk26/issues) to see if your issue has already been reported
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
   # Visit https://github.com/Artagon/homebrew-jdk26 and click "Fork"
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/homebrew-jdk26.git
   cd homebrew-jdk26
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
   - Go to https://github.com/Artagon/homebrew-jdk26
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
This repository includes a commit-msg hook that validates your commit messages. Install it by running:

```bash
# The hooks are automatically installed when you clone the repository
# To manually install:
cp .githooks/commit-msg .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg
```

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
- Open a discussion in the [issue tracker](https://github.com/Artagon/homebrew-jdk26/issues)
- Review existing PRs to see examples
- Check [Homebrew's documentation](https://docs.brew.sh/Formula-Cookbook) for cask/formula syntax

## License

By contributing, you agree that your contributions will be licensed under the same terms as the project (GPL-2.0, matching the JDK license).
