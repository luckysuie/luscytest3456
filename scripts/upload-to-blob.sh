#!/bin/bash

# upload-to-blob.sh
# Purpose: Upload the backup directory to Azure Blob Storage.

BACKUP_PATH=$1
STORAGE_ACCOUNT=$2
STORAGE_KEY=$3
CONTAINER_NAME=$4

if [ -z "$BACKUP_PATH" ] || [ -z "$STORAGE_ACCOUNT" ] || [ -z "$STORAGE_KEY" ] || [ -z "$CONTAINER_NAME" ]; then
    echo "Error: Missing required arguments for Azure Blob upload."
    exit 1
fi

echo "Uploading $BACKUP_PATH to Azure Blob Storage container: $CONTAINER_NAME..."

# Use Azure CLI to upload the directory
# Note: az storage blob upload-batch is efficient for directories
az storage blob upload-batch \
    --account-name "$STORAGE_ACCOUNT" \
    --account-key "$STORAGE_KEY" \
    --destination "$CONTAINER_NAME" \
    --source "$BACKUP_PATH" \
    --overwrite true

if [ $? -eq 0 ]; then
    echo "Upload successful."
else
    echo "Upload failed."
    exit 1
fi
