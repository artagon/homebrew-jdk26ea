#!/usr/bin/env bash
# Sync centralized AI context to agent-specific files

set -euo pipefail

SHARED_DIR=".ai-context/shared"
AGENTS_DIR=".ai-context/agents"

echo "=== Syncing AI Configuration ==="
echo ""

# Verify source files exist
if [ ! -d "$SHARED_DIR" ]; then
  echo "❌ ERROR: $SHARED_DIR directory not found"
  echo "Run ./scripts/centralize-ai-config.sh first"
  exit 1
fi

echo "📂 Source: $SHARED_DIR"
echo "🎯 Targets: .claude/, .gemini/, .github/, .cursorrules"
echo ""

# Function to compile files with header
compile_with_header() {
  local output_file="$1"
  local agent_name="$2"
  shift 2
  local source_files=("$@")

  echo "<!-- AUTO-GENERATED from .ai-context/" > "$output_file"
  echo "     DO NOT EDIT DIRECTLY - Edit .ai-context/shared/ instead" >> "$output_file"
  echo "     Last synced: $(date -u +"%Y-%m-%d %H:%M:%S UTC")" >> "$output_file"
  echo "     Agent: $agent_name -->" >> "$output_file"
  echo "" >> "$output_file"

  for file in "${source_files[@]}"; do
    if [ -f "$file" ]; then
      echo "<!-- BEGIN: $file -->" >> "$output_file"
      cat "$file" >> "$output_file"
      echo "" >> "$output_file"
      echo "<!-- END: $file -->" >> "$output_file"
      echo "" >> "$output_file"
    fi
  done
}

# 1. Claude Code
echo "🤖 Syncing Claude Code configuration..."
mkdir -p .claude

# Compile instructions.md
compile_with_header \
  ".claude/instructions.md" \
  "Claude Code" \
  "$SHARED_DIR/instructions.md" \
  "$SHARED_DIR/security.md" \
  "$SHARED_DIR/style-guide.md" \
  "$AGENTS_DIR/claude.md"

# Compile context.md
compile_with_header \
  ".claude/context.md" \
  "Claude Code" \
  "$SHARED_DIR/context.md"

# Update .agents pointer
echo ".claude" > .agents

echo "  ✓ .claude/instructions.md"
echo "  ✓ .claude/context.md"
echo "  ✓ .agents → .claude"
echo ""

# 2. Gemini Code Assist
echo "🔷 Syncing Gemini Code Assist configuration..."
mkdir -p .gemini

# Gemini uses styleguide.md
compile_with_header \
  ".gemini/styleguide.md" \
  "Gemini Code Assist" \
  "$SHARED_DIR/style-guide.md" \
  "$SHARED_DIR/security.md" \
  "$AGENTS_DIR/gemini.md"

# Gemini config.yaml (not auto-generated, leave existing or create default)
if [ ! -f .gemini/config.yaml ]; then
  cat > .gemini/config.yaml << 'EOF'
# Gemini Code Assist Configuration
# https://developers.google.com/gemini-code-assist/docs/customize-gemini-behavior-github

auto_review: true
review_summary: true
comment_severity_threshold: MEDIUM
max_review_comments: 50

ignore:
  - "*.bak"
  - "*.tmp"
  - ".git/**"
EOF
fi

echo "  ✓ .gemini/styleguide.md"
echo "  ✓ .gemini/config.yaml"
echo ""

# 3. GitHub Copilot
echo "🐙 Syncing GitHub Copilot configuration..."
mkdir -p .github

compile_with_header \
  ".github/copilot-instructions.md" \
  "GitHub Copilot" \
  "$SHARED_DIR/context.md" \
  "$SHARED_DIR/instructions.md" \
  "$SHARED_DIR/security.md" \
  "$SHARED_DIR/style-guide.md" \
  "$AGENTS_DIR/copilot.md"

echo "  ✓ .github/copilot-instructions.md"
echo ""

# 4. Cursor
echo "⚡ Syncing Cursor configuration..."

# Cursor uses .cursorrules (plain text, no markdown)
{
  echo "# AUTO-GENERATED from .ai-context/"
  echo "# DO NOT EDIT DIRECTLY - Edit .ai-context/shared/ instead"
  echo "# Last synced: $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
  echo "# Agent: Cursor"
  echo ""

  # Strip markdown headers and format for cursorrules
  for file in "$SHARED_DIR/instructions.md" "$SHARED_DIR/security.md" "$SHARED_DIR/style-guide.md" "$AGENTS_DIR/cursor.md"; do
    if [ -f "$file" ]; then
      # Remove markdown comment blocks and simplify
      grep -v "^<!--" "$file" | grep -v "^-->" || true
      echo ""
    fi
  done
} > .cursorrules

echo "  ✓ .cursorrules"
echo ""

# 5. Create sync verification report
echo "📊 Creating sync report..."

cat > .ai-context/sync-report.md << EOF
# AI Configuration Sync Report

**Last Sync:** $(date -u +"%Y-%m-%d %H:%M:%S UTC")

## Files Synced

### Source Files (Shared Context)
$(find $SHARED_DIR -type f -name "*.md" -exec echo "- {}" \; | sed 's|^- |  ✓ |')

### Agent-Specific Files
$(find $AGENTS_DIR -type f -name "*.md" -exec echo "- {}" \; | sed 's|^- |  ✓ |')

### Generated Files

#### Claude Code
  ✓ .claude/instructions.md ($(wc -l < .claude/instructions.md) lines)
  ✓ .claude/context.md ($(wc -l < .claude/context.md) lines)
  ✓ .agents → .claude

#### Gemini Code Assist
  ✓ .gemini/styleguide.md ($(wc -l < .gemini/styleguide.md) lines)
  ✓ .gemini/config.yaml ($(wc -l < .gemini/config.yaml) lines)

#### GitHub Copilot
  ✓ .github/copilot-instructions.md ($(wc -l < .github/copilot-instructions.md) lines)

#### Cursor
  ✓ .cursorrules ($(wc -l < .cursorrules) lines)

## File Sizes

\`\`\`
$(du -h .claude/instructions.md .claude/context.md .gemini/styleguide.md .github/copilot-instructions.md .cursorrules 2>/dev/null | column -t)
\`\`\`

## Verification

Run \`./scripts/verify-ai-sync.sh\` to verify all files are in sync.

## Next Steps

1. Review generated files
2. Test with each AI assistant
3. Commit changes:
   \`\`\`bash
   git add .ai-context/ .claude/ .gemini/ .github/ .cursorrules .agents
   git commit -m "docs: sync AI configurations from centralized source"
   \`\`\`
EOF

echo "  ✓ .ai-context/sync-report.md"
echo ""

# Summary
echo "=== Sync Complete ==="
echo ""
echo "✅ All AI configurations synced from shared context"
echo ""
echo "Generated files:"
echo "  • Claude Code:   .claude/instructions.md, .claude/context.md"
echo "  • Gemini:        .gemini/styleguide.md"
echo "  • Copilot:       .github/copilot-instructions.md"
echo "  • Cursor:        .cursorrules"
echo ""
echo "📊 Sync report: .ai-context/sync-report.md"
echo ""
echo "To verify: ./scripts/verify-ai-sync.sh"
