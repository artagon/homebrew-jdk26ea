#!/usr/bin/env bash
# Verify AI configuration files are in sync with centralized source

set -euo pipefail

SHARED_DIR=".ai-context/shared"
AGENTS_DIR=".ai-context/agents"

echo "=== Verifying AI Configuration Sync ==="
echo ""

EXIT_CODE=0

# Check if centralized config exists
if [ ! -d "$SHARED_DIR" ]; then
  echo "❌ ERROR: Centralized config not found"
  echo "Run ./scripts/centralize-ai-config.sh first"
  exit 1
fi

echo "Checking shared source files..."
SHARED_FILES=$(find "$SHARED_DIR" -type f -name "*.md" | wc -l)
AGENT_FILES=$(find "$AGENTS_DIR" -type f -name "*.md" | wc -l)
echo "  ✓ Found $SHARED_FILES shared files"
echo "  ✓ Found $AGENT_FILES agent-specific files"
echo ""

# Function to check if file has sync header
check_sync_header() {
  local file="$1"
  local agent="$2"

  if [ ! -f "$file" ]; then
    echo "  ❌ $file - MISSING"
    EXIT_CODE=1
    return 1
  fi

  if ! grep -q "AUTO-GENERATED from .ai-context" "$file" 2>/dev/null; then
    echo "  ⚠️  $file - Missing sync header (manual edit detected)"
    EXIT_CODE=1
    return 1
  fi

  # Check if file is recent (synced within last 24 hours)
  if [ "$(uname)" = "Darwin" ]; then
    FILE_TIME=$(stat -f %m "$file")
  else
    FILE_TIME=$(stat -c %Y "$file")
  fi

  CURRENT_TIME=$(date +%s)
  DIFF=$((CURRENT_TIME - FILE_TIME))
  HOURS=$((DIFF / 3600))

  if [ $HOURS -gt 24 ]; then
    echo "  ⚠️  $file - Last synced $HOURS hours ago (may be stale)"
  else
    echo "  ✓ $file - Synced recently"
  fi
}

echo "Checking Claude Code configuration..."
check_sync_header ".claude/instructions.md" "Claude"
check_sync_header ".claude/context.md" "Claude"

AGENTS_CONTENT=$(cat .agents 2>/dev/null || echo "")
if [ "$AGENTS_CONTENT" = ".claude" ]; then
  echo "  ✓ .agents → .claude"
else
  echo "  ❌ .agents should point to .claude, but points to: $AGENTS_CONTENT"
  EXIT_CODE=1
fi
echo ""

echo "Checking Gemini configuration..."
check_sync_header ".gemini/styleguide.md" "Gemini"
if [ -f .gemini/config.yaml ]; then
  echo "  ✓ .gemini/config.yaml exists"
else
  echo "  ⚠️  .gemini/config.yaml missing"
fi
echo ""

echo "Checking GitHub Copilot configuration..."
check_sync_header ".github/copilot-instructions.md" "Copilot"
echo ""

echo "Checking Cursor configuration..."
if [ ! -f .cursorrules ]; then
  echo "  ❌ .cursorrules - MISSING"
  EXIT_CODE=1
elif ! grep -q "AUTO-GENERATED from .ai-context" .cursorrules 2>/dev/null; then
  echo "  ⚠️  .cursorrules - Missing sync header"
  EXIT_CODE=1
else
  echo "  ✓ .cursorrules - Synced"
fi
echo ""

# Check for manual edits in generated files
echo "Checking for manual edits in generated files..."
MANUAL_EDITS_FOUND=0

for file in .claude/instructions.md .claude/context.md .gemini/styleguide.md .github/copilot-instructions.md .cursorrules; do
  if [ -f "$file" ]; then
    if ! grep -q "AUTO-GENERATED from .ai-context" "$file" 2>/dev/null; then
      echo "  ⚠️  $file - May have been manually edited"
      MANUAL_EDITS_FOUND=1
    fi
  fi
done

if [ $MANUAL_EDITS_FOUND -eq 0 ]; then
  echo "  ✓ No manual edits detected"
fi
echo ""

# File size comparison
echo "Configuration file sizes:"
du -h .claude/instructions.md .claude/context.md .gemini/styleguide.md .github/copilot-instructions.md .cursorrules 2>/dev/null | column -t || true
echo ""

# Summary
echo "=== Verification Summary ==="
echo ""

if [ $EXIT_CODE -eq 0 ]; then
  echo "✅ All configurations are in sync"
  echo ""
  echo "Sync status: HEALTHY"
else
  echo "⚠️  Some issues detected"
  echo ""
  echo "To fix, run:"
  echo "  ./scripts/sync-ai-config.sh"
  echo ""
  echo "Sync status: NEEDS ATTENTION"
fi

exit $EXIT_CODE
