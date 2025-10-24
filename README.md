# homebrew-jdk26

Homebrew tap for JDK 26 Early Access builds with automated updates, CI/CD, and support for both macOS and Linux.

[![Release](https://github.com/Artagon/homebrew-jdk26ea/actions/workflows/release.yml/badge.svg)](https://github.com/Artagon/homebrew-jdk26ea/actions/workflows/release.yml)
[![Validate](https://github.com/Artagon/homebrew-jdk26ea/actions/workflows/validate.yml/badge.svg)](https://github.com/Artagon/homebrew-jdk26ea/actions/workflows/validate.yml)

## Quick Start

### Cask Installation (macOS)

```bash
brew tap Artagon/jdk26ea
brew install --cask jdk26ea
```

The cask installation places JDK in `/Library/Java/JavaVirtualMachines/jdk-26-ea.jdk` and integrates with macOS's Java management system.

### Formula Installation (macOS/Linux)

```bash
brew tap Artagon/jdk26ea
brew install jdk26ea
```

The formula installation creates symlinks in your Homebrew bin directory.

## Current Version

**JDK 26 EA Build 20** (Released: 2025-10-17)

## About

This tap provides automated updates for JDK 26 Early Access builds from [jdk.java.net/26](https://jdk.java.net/26/).

### Features

- Automatic updates when new EA builds are released
- Support for macOS (ARM64 & Intel) and Linux (ARM64 & x64)
- CI/CD validation with GitHub Actions
- Automatic GitHub releases on version updates
- Both cask and formula options

## Usage

### Setting JAVA_HOME

After installation, you may want to set `JAVA_HOME`:

**For cask installation:**
```bash
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-26-ea.jdk/Contents/Home"
```

**For formula installation:**
```bash
export JAVA_HOME="$(brew --prefix jdk26ea)"
```

### Verifying Installation

```bash
java -version
# Should output: openjdk version "26-ea" ...
```

## Updating

The tap is automatically updated with new EA builds. To update to the latest version:

```bash
brew update
brew upgrade jdk26ea  # or brew upgrade --cask jdk26ea
```

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on:
- How to report issues
- How to submit pull requests
- Guidelines for updating to new builds

## Issue Reporting

Found a problem? [Open an issue](https://github.com/Artagon/homebrew-jdk26ea/issues/new/choose) using our issue templates.

## Automated Updates

This repository uses GitHub Actions to:
- Validate cask/formula syntax on every commit
- Create GitHub releases when the version changes
- Run weekly audits to ensure quality

## License

This tap is distributed under the same license as OpenJDK (GPL-2.0 with Classpath Exception).

## Disclaimer

These are early-access builds provided for testing and development purposes. They are not intended for production use. For production environments, please use stable JDK releases.

## Links

- [JDK 26 EA Downloads](https://jdk.java.net/26/)
- [OpenJDK Project](https://openjdk.org/)
- [Homebrew Documentation](https://docs.brew.sh/)
