#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FORM="$ROOT/Formula/jdk26valhalla.rb"
CASK="$ROOT/Casks/jdk26valhalla.rb"
pages=("https://jdk.java.net/valhalla/" "https://jdk.java.net/26/")
find_link(){ curl -fsSL "$1" | grep -Eo "https?://[^"']+${2}" | head -n1; }
if command -v shasum >/dev/null; then SHACMD="shasum -a 256"; else SHACMD="sha256sum"; fi
mac_arm= mac_x64= lin_x64= ver="26-ea"
for p in "${pages[@]}"; do
  [[ -z "$mac_arm" ]] && mac_arm=$(find_link "$p" "_macos-aarch64_bin\.(tar\.gz|zip)")
  [[ -z "$mac_x64" ]] && mac_x64=$(find_link "$p" "_(macos|osx)-x64_bin\.(tar\.gz|zip)")
  [[ -z "$lin_x64" ]] && lin_x64=$(find_link "$p" "_linux-x64_bin\.(tar\.gz|zip)")
done
getsha(){ local u="$1"; f="$(mktemp)"; curl -fsSL "$u" -o "$f"; $SHACMD "$f" | awk '{print $1}'; rm -f "$f"; }
sha_ma="deadbeef"; sha_mx="deadbeef"; sha_lx="deadbeef"
[[ -n "$mac_arm" ]] && sha_ma=$(getsha "$mac_arm")
[[ -n "$mac_x64" ]] && sha_mx=$(getsha "$mac_x64")
[[ -n "$lin_x64" ]] && sha_lx=$(getsha "$lin_x64")
sed -i.bak -e "s|__URL_MAC_ARM__|$mac_arm|g" -e "s|__SHA_MAC_ARM__|$sha_ma|g"   -e "s|__URL_MAC_INTEL__|$mac_x64|g" -e "s|__SHA_MAC_INTEL__|$sha_mx|g"   -e "s|__URL_LINUX_X64__|$lin_x64|g" -e "s|__SHA_LINUX_X64__|$sha_lx|g"   -e "s|__VERSION__|$ver|g" "$FORM" "$CASK"; rm -f "$FORM.bak" "$CASK.bak"
echo "Updated formula & cask with version=$ver"
