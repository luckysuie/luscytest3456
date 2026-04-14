#!/bin/bash

# backup-db.sh
# Purpose: Perform a database backup. 
# For mock testing, it copies DB-related files into a timestamped artifact.

# Inputs from environment or arguments
BRANCH_NAME=${1:-"unknown"}
COMMIT_SHA=${2:-"unknown"}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Define the backup directory name
# Format: backup_YYYYMMDD_HHMMSS_BRANCH_SHA
BACKUP_NAME="backup_${TIMESTAMP}_${BRANCH_NAME}_${COMMIT_SHA:0:7}"
BACKUP_DIR="backups/$BACKUP_NAME"

echo "--------------------------------------------------"
echo "📦 STARTING MOCK DATABASE BACKUP"
echo "--------------------------------------------------"
echo "Timestamp: $TIMESTAMP"
echo "Branch:    $BRANCH_NAME"
echo "SHA:       $COMMIT_SHA"
echo "Target:    $BACKUP_DIR"

# Create the backup directory
mkdir -p "$BACKUP_DIR"

# Define directories and files to include in the backup
DB_PATHS=(
    "db"
    "migrations"
    "prisma"
    "schema"
    "sql"
    "database"
)

# Copy each path if it exists
for path in "${DB_PATHS[@]}"; do
    if [ -d "$path" ]; then
        echo "  -> Copying directory: $path"
        cp -r "$path" "$BACKUP_DIR/"
    elif [ -f "$path" ]; then
        echo "  -> Copying file: $path"
        cp "$path" "$BACKUP_DIR/"
    fi
done

# Also copy any .sql files in the root (if any)
find . -maxdepth 1 -name "*.sql" -exec cp {} "$BACKUP_DIR/" \;

# Create a metadata file
cat <<EOF > "$BACKUP_DIR/metadata.json"
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "branch": "$BRANCH_NAME",
  "commit_sha": "$COMMIT_SHA",
  "backup_type": "mock_filesystem_copy"
}
EOF

echo "--------------------------------------------------"
echo "✅ Backup completed successfully."
echo "Backup Location: $BACKUP_DIR"
echo "--------------------------------------------------"

# Output the backup directory for GitHub Actions
if [ -n "$GITHUB_OUTPUT" ]; then
    echo "backup_dir=$BACKUP_DIR" >> "$GITHUB_OUTPUT"
    echo "backup_name=$BACKUP_NAME" >> "$GITHUB_OUTPUT"
fi
