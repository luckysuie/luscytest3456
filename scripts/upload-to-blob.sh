#!/bin/bash

# upload-to-blob.sh
# Purpose: Upload the backup directory to Azure Blob Storage.

BACKUP_PATH=$1
STORAGE_ACCOUNT=$2
STORAGE_KEY=$3
CONTAINER_NAME=$4

echo "--------------------------------------------------"
echo "☁️ UPLOADING TO AZURE BLOB STORAGE"
echo "--------------------------------------------------"

if [ -z "$BACKUP_PATH" ] || [ -z "$STORAGE_ACCOUNT" ] || [ -z "$STORAGE_KEY" ] || [ -z "$CONTAINER_NAME" ]; then
    echo "❌ Error: Missing required arguments for Azure Blob upload."
    echo "Usage: ./upload-to-blob.sh <BACKUP_PATH> <STORAGE_ACCOUNT> <STORAGE_KEY> <CONTAINER_NAME>"
    exit 1
fi

if [ ! -d "$BACKUP_PATH" ]; then
    echo "❌ Error: Backup directory '$BACKUP_PATH' does not exist."
    exit 1
fi

# Extract the backup name from the path (e.g., backups/backup_... -> backup_...)
BACKUP_NAME=$(basename "$BACKUP_PATH")

echo "Source:      $BACKUP_PATH"
echo "Destination: $CONTAINER_NAME/$BACKUP_NAME"
echo "Account:     $STORAGE_ACCOUNT"

# Use Azure CLI to upload the directory
# We upload into a subfolder named after the backup to keep things organized
echo "Starting upload..."
az storage blob upload-batch \
    --account-name "$STORAGE_ACCOUNT" \
    --account-key "$STORAGE_KEY" \
    --destination "$CONTAINER_NAME/$BACKUP_NAME" \
    --source "$BACKUP_PATH" \
    --overwrite true

if [ $? -eq 0 ]; then
    echo "--------------------------------------------------"
    echo "✅ Upload successful."
    echo "--------------------------------------------------"
else
    echo "--------------------------------------------------"
    echo "❌ Upload failed."
    echo "--------------------------------------------------"
    exit 1
fi
