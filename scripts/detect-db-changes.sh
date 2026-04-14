#!/bin/bash

# detect-db-changes.sh
# Purpose: Detect if any database-related files have been MODIFIED or ADDED.
# Usage: ./detect-db-changes.sh <BEFORE_SHA> <AFTER_SHA> <EVENT_NAME>

BEFORE_SHA=$1
AFTER_SHA=$2
EVENT_NAME=$3

echo "--------------------------------------------------"
echo "🔍 DATABASE CHANGE DETECTION"
echo "--------------------------------------------------"
echo "Event Type: $EVENT_NAME"
echo "Before SHA: $BEFORE_SHA"
echo "After SHA:  $AFTER_SHA"

# Define patterns to look for (regex format for grep -E)
DB_PATTERNS="^(db/|migrations/|prisma/|schema/|sql/|database/|.*\.sql$|schema\.prisma$)"

# Determine the comparison range based on event type
if [ "$EVENT_NAME" == "pull_request" ]; then
    # For PRs, compare base to head
    RANGE="$BEFORE_SHA..$AFTER_SHA"
    echo "Context: Pull Request"
elif [ "$EVENT_NAME" == "push" ]; then
    # For pushes, compare previous state to current
    if [ "$BEFORE_SHA" == "0000000000000000000000000000000000000000" ]; then
        echo "Context: First push to branch. Checking current commit only."
        RANGE="$AFTER_SHA"
    else
        RANGE="$BEFORE_SHA..$AFTER_SHA"
        echo "Context: Push"
    fi
else
    # Manual or other
    echo "Context: $EVENT_NAME / Manual"
    RANGE="$AFTER_SHA"
fi

echo "Comparison Range: $RANGE"

# Get list of changed files
if [ "$RANGE" == "$AFTER_SHA" ]; then
    # Single commit or fallback
    CHANGED_FILES=$(git ls-tree -r --name-only "$AFTER_SHA" 2>/dev/null)
else
    # Range diff
    CHANGED_FILES=$(git diff --name-only --diff-filter=ACMR "$RANGE" 2>/dev/null)
fi

# Fallback if git commands fail
if [ $? -ne 0 ]; then
    echo "⚠️ Git command failed. Falling back to full tree scan of HEAD."
    CHANGED_FILES=$(git ls-tree -r --name-only HEAD)
fi

echo "--------------------------------------------------"
echo "📄 ALL CHANGED FILES:"
echo "$CHANGED_FILES" | sed 's/^/  - /'
echo "--------------------------------------------------"

# Filter changed files against our DB patterns
DETECTED_CHANGES=$(echo "$CHANGED_FILES" | grep -E "$DB_PATTERNS" || true)

if [ -n "$DETECTED_CHANGES" ]; then
    echo "✅ DATABASE CHANGES DETECTED:"
    echo "$DETECTED_CHANGES" | sed 's/^/  - /'
    echo "--------------------------------------------------"
    exit 0
else
    echo "ℹ️ No database-related changes detected."
    echo "--------------------------------------------------"
    exit 1
fi
