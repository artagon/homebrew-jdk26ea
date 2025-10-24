#!/usr/bin/env bash
# Update JDK 26 EA cask and formula to the latest build
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Directories
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FORMULA="$ROOT/Formula/jdk26ea.rb"
CASK="$ROOT/Casks/jdk26ea.rb"

# JDK page URL
JDK_PAGE="https://jdk.java.net/26/"

log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

# Determine SHA command (macOS vs Linux)
if command -v shasum >/dev/null 2>&1; then
    SHA_CMD="shasum -a 256"
elif command -v sha256sum >/dev/null 2>&1; then
    SHA_CMD="sha256sum"
else
    log_error "Neither shasum nor sha256sum found. Cannot compute checksums."
    exit 1
fi

# Fetch the JDK page and extract build number
log_info "Fetching latest JDK 26 EA build information from $JDK_PAGE"
page_content=$(curl -fsSL "$JDK_PAGE" 2>/dev/null || {
    log_error "Failed to fetch JDK page"
    exit 1
})

# Extract build number from page
build_number=$(echo "$page_content" | grep -oP 'Build \K\d+' | head -1)

if [[ -z "$build_number" ]]; then
    log_error "Could not extract build number from JDK page"
    exit 1
fi

version="26-ea+${build_number}"
log_info "Latest build: $version"

# Get current version from cask
current_version=$(grep -oP 'version "\K[^"]+' "$CASK" 2>/dev/null || echo "unknown")
log_info "Current version: $current_version"

if [[ "$version" == "$current_version" ]]; then
    log_info "Already at latest version: $version"
    exit 0
fi

# Define download URLs
base_url="https://download.java.net/java/early_access/jdk26/${build_number}/GPL"
declare -A urls=(
    ["mac_arm"]="${base_url}/openjdk-${version}_macos-aarch64_bin.tar.gz"
    ["mac_x64"]="${base_url}/openjdk-${version}_macos-x64_bin.tar.gz"
    ["linux_arm"]="${base_url}/openjdk-${version}_linux-aarch64_bin.tar.gz"
    ["linux_x64"]="${base_url}/openjdk-${version}_linux-x64_bin.tar.gz"
)

# Function to get SHA256 from remote .sha256 file
get_remote_sha256() {
    local url="$1"
    local sha_url="${url}.sha256"

    local sha=$(curl -fsSL "$sha_url" 2>/dev/null | awk '{print $1}')

    if [[ -z "$sha" || ! "$sha" =~ ^[a-f0-9]{64}$ ]]; then
        log_error "Failed to get valid SHA256 for $url"
        return 1
    fi

    echo "$sha"
}

# Fetch all SHA256 checksums
log_info "Fetching SHA256 checksums..."
declare -A shas

for platform in "${!urls[@]}"; do
    log_info "  - $platform"
    shas[$platform]=$(get_remote_sha256 "${urls[$platform]}")
    if [[ $? -ne 0 ]]; then
        log_error "Failed to fetch checksum for $platform"
        exit 1
    fi
done

log_info "All checksums fetched successfully"

# Backup files
log_info "Creating backups..."
cp "$CASK" "${CASK}.backup"
cp "$FORMULA" "${FORMULA}.backup"

# Update CASK
log_info "Updating Cask..."

# Update version
sed -i.tmp "s/version \".*\"/version \"$version\"/" "$CASK"

# Update URLs and checksums for macOS
sed -i.tmp \
    -e "s|https://download.java.net/java/early_access/jdk26/[0-9]*/GPL/openjdk-.*_macos-aarch64_bin.tar.gz|${urls[mac_arm]}|g" \
    -e "s|https://download.java.net/java/early_access/jdk26/[0-9]*/GPL/openjdk-.*_macos-x64_bin.tar.gz|${urls[mac_x64]}|g" \
    "$CASK"

# Update checksums in cask (more precise)
awk -v arm="${shas[mac_arm]}" -v x64="${shas[mac_x64]}" '
    /on_arm/,/end/ {
        if (/sha256/) {
            gsub(/sha256 ".*"/, "sha256 \"" arm "\"")
        }
    }
    /on_intel/,/end/ {
        if (/sha256/ && !/on_arm/) {
            gsub(/sha256 ".*"/, "sha256 \"" x64 "\"")
        }
    }
    {print}
' "$CASK" > "${CASK}.new" && mv "${CASK}.new" "$CASK"

# Remove sed temp files
rm -f "${CASK}.tmp"

# Update FORMULA
log_info "Updating Formula..."

# Update version
sed -i.tmp "s/version \".*\"/version \"$version\"/" "$FORMULA"

# Update all URLs
sed -i.tmp \
    -e "s|https://download.java.net/java/early_access/jdk26/[0-9]*/GPL/openjdk-.*_macos-aarch64_bin.tar.gz|${urls[mac_arm]}|g" \
    -e "s|https://download.java.net/java/early_access/jdk26/[0-9]*/GPL/openjdk-.*_macos-x64_bin.tar.gz|${urls[mac_x64]}|g" \
    -e "s|https://download.java.net/java/early_access/jdk26/[0-9]*/GPL/openjdk-.*_linux-aarch64_bin.tar.gz|${urls[linux_arm]}|g" \
    -e "s|https://download.java.net/java/early_access/jdk26/[0-9]*/GPL/openjdk-.*_linux-x64_bin.tar.gz|${urls[linux_x64]}|g" \
    "$FORMULA"

# Update checksums in formula
awk -v mac_arm="${shas[mac_arm]}" \
    -v mac_x64="${shas[mac_x64]}" \
    -v linux_arm="${shas[linux_arm]}" \
    -v linux_x64="${shas[linux_x64]}" '
    BEGIN { in_macos=0; in_linux=0; in_arm_block=0 }

    /on_macos do/ { in_macos=1; in_linux=0; next_is_macos=1 }
    /on_linux do/ { in_linux=1; in_macos=0; next_is_linux=1 }

    /if Hardware::CPU\.arm\?/ { in_arm_block=1 }
    /else$/ { in_arm_block=0 }
    /^  end$/ {
        if (in_macos || in_linux) {
            in_macos=0
            in_linux=0
        }
    }

    /sha256/ {
        if (in_macos && in_arm_block) {
            gsub(/sha256 ".*"/, "sha256 \"" mac_arm "\"")
        }
        else if (in_macos && !in_arm_block) {
            gsub(/sha256 ".*"/, "sha256 \"" mac_x64 "\"")
        }
        else if (in_linux && in_arm_block) {
            gsub(/sha256 ".*"/, "sha256 \"" linux_arm "\"")
        }
        else if (in_linux && !in_arm_block) {
            gsub(/sha256 ".*"/, "sha256 \"" linux_x64 "\"")
        }
    }

    {print}
' "$FORMULA" > "${FORMULA}.new" && mv "${FORMULA}.new" "$FORMULA"

# Remove sed temp files
rm -f "${FORMULA}.tmp"

# Validate Ruby syntax
log_info "Validating Ruby syntax..."

if ! ruby -c "$CASK" > /dev/null 2>&1; then
    log_error "Cask syntax validation failed!"
    log_warn "Restoring backup..."
    mv "${CASK}.backup" "$CASK"
    mv "${FORMULA}.backup" "$FORMULA"
    exit 1
fi

if ! ruby -c "$FORMULA" > /dev/null 2>&1; then
    log_error "Formula syntax validation failed!"
    log_warn "Restoring backup..."
    mv "${CASK}.backup" "$CASK"
    mv "${FORMULA}.backup" "$FORMULA"
    exit 1
fi

# Clean up backups
rm -f "${CASK}.backup" "${FORMULA}.backup"

# Summary
log_info "Successfully updated to $version"
echo ""
echo "Summary of changes:"
echo "  Previous version: $current_version"
echo "  New version:      $version"
echo ""
echo "Updated files:"
echo "  - $CASK"
echo "  - $FORMULA"
echo ""
echo "Checksums:"
echo "  macOS ARM64:   ${shas[mac_arm]}"
echo "  macOS x64:     ${shas[mac_x64]}"
echo "  Linux ARM64:   ${shas[linux_arm]}"
echo "  Linux x64:     ${shas[linux_x64]}"
echo ""
log_info "Run 'git diff' to review changes"
log_info "Run 'git add . && git commit -m \"Update to JDK $version\"' to commit"
