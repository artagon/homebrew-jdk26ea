#!/usr/bin/env bash
set -euo pipefail

echo "Repository Rename Script"
echo "========================"
echo ""
echo "This script will update your local repository after renaming on GitHub"
echo "from: homebrew-jdk26valhalla"
echo "to:   homebrew-jdk26-ea"
echo ""

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Get current remote URL
CURRENT_URL=$(git remote get-url origin)
echo "Current remote URL: $CURRENT_URL"

# New URL
NEW_URL="https://github.com/trumpyla/homebrew-jdk26-ea.git"

# Update the remote URL
echo ""
echo "Updating remote URL to: $NEW_URL"
git remote set-url origin "$NEW_URL"

# Verify the change
UPDATED_URL=$(git remote get-url origin)
echo "Updated remote URL: $UPDATED_URL"

# Test connection
echo ""
echo "Testing connection to new repository..."
if git ls-remote origin > /dev/null 2>&1; then
    echo "✓ Successfully connected to renamed repository!"
else
    echo "✗ Could not connect to repository."
    echo "  Make sure you've renamed the repository on GitHub first."
    echo "  Go to: Settings → Repository name → Change to 'homebrew-jdk26-ea'"
    exit 1
fi

echo ""
echo "✓ Local repository successfully updated!"
echo ""
echo "Next steps:"
echo "1. Make sure the GitHub repository has been renamed to 'homebrew-jdk26-ea'"
echo "2. You can continue working normally with git commands"
echo "3. Users will need to update their tap with:"
echo "   brew untap trumpyla/jdk26valhalla"
echo "   brew tap trumpyla/jdk26-ea"
