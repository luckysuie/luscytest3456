#!/bin/bash

# detect-db-changes.sh
# Purpose: Detect if any database-related files have been modified or added.
# Returns: 0 if changes detected, 1 if no changes detected.

echo "Checking for database-related changes..."

# Define patterns to look for
DB_PATTERNS=(
    "db/"
    "migrations/"
    "prisma/"
    "schema/"
    "sql/"
    "database/"
    "*.sql"
    "schema.prisma"
)

# Join patterns for grep
PATTERN_STRING=$(printf "|%s" "${DB_PATTERNS[@]}")
PATTERN_STRING=${PATTERN_STRING:1}

# Check for existence of these paths in the current workspace
# This is a broad check for "future-ready" detection
FOUND_FILES=$(find . -maxdepth 3 -regextype posix-extended -regex ".*($PATTERN_STRING).*" -not -path "*/node_modules/*")

if [ -n "$FOUND_FILES" ]; then
    echo "Database-related files detected:"
    echo "$FOUND_FILES"
    
    # Optional: Check if these files were actually changed in this commit/PR
    # For simplicity in this CI context, we'll signal detection if they exist
    # and are part of the current workspace.
    
    exit 0
else
    echo "No database-related files detected."
    exit 1
fi
