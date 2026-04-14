#!/bin/bash

# detect-db-changes.sh
# Purpose: Detect if any database-related files have been MODIFIED or ADDED in the current commit/PR.
# Returns: 0 if changes detected, 1 if no changes detected.

echo "Checking for database-related changes..."

# Define patterns to look for (regex format for grep -E)
# This covers directories and specific file extensions/names
DB_PATTERNS="^(db/|migrations/|prisma/|schema/|sql/|database/|.*\.sql$|schema\.prisma$)"

# Determine the comparison range
# In GitHub Actions, we can use GITHUB_BASE_REF for PRs or compare HEAD~1 for pushes
if [ -n "$GITHUB_BASE_REF" ]; then
    # Pull Request context
    echo "Context: Pull Request (Base: $GITHUB_BASE_REF)"
    # Ensure we have the base branch fetched
    git fetch origin "$GITHUB_BASE_REF" --depth=1 > /dev/null 2>&1
    RANGE="origin/$GITHUB_BASE_REF..HEAD"
else
    # Push context
    echo "Context: Push/Manual"
    if git rev-parse --verify HEAD~1 >/dev/null 2>&1; then
        RANGE="HEAD~1..HEAD"
    else
        # Fallback for initial commit or shallow clones without history
        echo "Warning: Only one commit found. Checking all files in current commit."
        RANGE="HEAD"
    fi
fi

echo "Comparing range: $RANGE"

# Get list of changed files in the specified range
# --name-only gives us just the paths
# --diff-filter=ACMR ensures we only look at Added, Copied, Modified, or Renamed files
CHANGED_FILES=$(git diff --name-only --diff-filter=ACMR "$RANGE" 2>/dev/null)

# If git diff fails (e.g. shallow clone issues), fallback to checking all files in HEAD
if [ $? -ne 0 ]; then
    echo "Git diff failed. Falling back to listing all files in HEAD..."
    CHANGED_FILES=$(git ls-tree -r --name-only HEAD)
fi

# Filter changed files against our DB patterns
DETECTED_CHANGES=$(echo "$CHANGED_FILES" | grep -E "$DB_PATTERNS")

if [ -n "$DETECTED_CHANGES" ]; then
    echo "--------------------------------------------------"
    echo "✅ DATABASE CHANGES DETECTED:"
    echo "--------------------------------------------------"
    echo "$DETECTED_CHANGES"
    echo "--------------------------------------------------"
    exit 0
else
    echo "--------------------------------------------------"
    echo "ℹ️ No database-related changes detected."
    echo "--------------------------------------------------"
    exit 1
fi
