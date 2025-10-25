# Security Policy

## Supported Versions

This project provides automated updates for JDK 26 Early Access builds. As EA builds are not intended for production use, we only support the latest available build.

| Version | Supported          |
| ------- | ------------------ |
| Latest EA Build | :white_check_mark: |
| Older EA Builds | :x:                |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please report it responsibly:

### Where to Report

- **Email**: Open an issue at https://github.com/artagon/homebrew-jdk26ea/issues
- **For sensitive issues**: Please email the repository maintainer directly

### What to Include

1. Description of the vulnerability
2. Steps to reproduce
3. Potential impact
4. Suggested fix (if available)

### Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Resolution**: Depends on severity and complexity

## Supply Chain Security

This project implements multiple security measures to ensure the integrity of JDK distributions:

### 1. Manual Approval for Updates

- All automated JDK updates require manual approval before distribution
- Updates create pull requests that must be reviewed and approved
- The `jdk-updates` environment enforces this requirement

### 2. Checksum Verification

- All JDK downloads are verified against official SHA256 checksums
- Checksums are fetched from official OpenJDK sources
- Downloads fail if checksums don't match

### 3. URL Validation

- Download URLs are validated against expected patterns
- Only downloads from `https://download.java.net/` are accepted
- URL structure is verified to match expected format

### 4. Automated Security Scanning

- **CodeQL**: Weekly security analysis of workflow code
- **Dependabot**: Automated dependency updates for Actions and Ruby gems
- **GitHub Actions**: All actions pinned to specific commit SHAs

### 5. Build Verification

- Ruby syntax validation for all formula/cask changes
- Homebrew audit checks before release
- Multi-platform installation testing (macOS ARM64/x64, Linux ARM64/x64)

### 6. Timeout Protection

- All network operations have timeouts (30s for metadata, 5min for downloads)
- Prevents hanging workflows and resource exhaustion
- Protects against slowloris-style attacks

### 7. Branch Protection

- Main branch requires passing status checks
- Pull request reviews required before merge
- Automated validation must pass

## Security Best Practices

### For Users

1. **Verify Downloads**: Always verify the JDK installation after download
   ```bash
   java -version
   ```

2. **Use Official Sources**: Only install from this tap or official OpenJDK sources

3. **Stay Updated**: Regularly update to the latest EA build
   ```bash
   brew update
   brew upgrade jdk26ea
   ```

4. **EA Builds**: Remember that EA builds are for testing only, not production use

### For Contributors

1. **Pin Actions**: Always pin GitHub Actions to specific commit SHAs
2. **Quote Variables**: Quote shell variables in workflow scripts
3. **Add Timeouts**: Include timeouts for all network operations
4. **Test Locally**: Test formula/cask changes locally before submitting
5. **Follow Conventional Commits**: Use semantic commit messages

## Known Limitations

1. **EA Build Nature**: Early-access builds may contain bugs or security issues
2. **GPG Verification**: OpenJDK EA builds don't currently provide GPG signatures
3. **SLSA Provenance**: Not yet available for OpenJDK EA builds
4. **Multi-source Verification**: Currently relies on single upstream source

## Planned Security Enhancements

### Short-term (Next 3 months)

- [ ] Implement GPG verification when available from OpenJDK
- [ ] Add SBOM (Software Bill of Materials) generation for releases
- [ ] Set up workflow run approval for first-time contributors
- [ ] Document security policy for downstream consumers

### Long-term (Next 6-12 months)

- [ ] Implement SLSA provenance when OpenJDK supports it
- [ ] Multi-source verification (cross-check against multiple sources)
- [ ] Automated security policy compliance checks
- [ ] Integration with supply chain security tools (Sigstore, etc.)

## Security Contacts

- **Primary**: Repository issues - https://github.com/artagon/homebrew-jdk26ea/issues
- **Security Policy**: This document - https://github.com/artagon/homebrew-jdk26ea/blob/main/SECURITY.md

## Acknowledgments

We thank the security community for responsible disclosure practices and the OpenJDK project for providing transparent build processes.

---

**Last Updated**: 2025-10-25
**Policy Version**: 1.0.0
