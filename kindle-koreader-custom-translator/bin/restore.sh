#!/bin/sh
set -e

KO_DIR="${KO_DIR:-/mnt/us/koreader}"
DEST_FILE="${KO_DIR}/frontend/ui/translator.lua"
BACKUP_FILE="${DEST_FILE}.bak"

echo "[Custom Translator] Restore start"
if [ -f "${BACKUP_FILE}" ]; then
    echo "Restore backup -> ${DEST_FILE}"
    cp -p "${BACKUP_FILE}" "${DEST_FILE}"
    sync
    echo "[Custom Translator] Restore complete"
else
    echo "Backup file not found: ${BACKUP_FILE}"
    exit 1
fi