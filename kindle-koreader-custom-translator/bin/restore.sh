#!/bin/sh
# Redirect all output to a log file in the extension directory
LOG_FILE="$(dirname "$0")/../restore.log"
exec >> "$LOG_FILE" 2>&1

echo "------------------------------------------------"
echo "Restore script started at $(date)"

# Try to show message on Kindle screen
msg() {
    echo "$1"
    if command -v eips >/dev/null 2>&1; then
        eips 10 35 "$1"
    fi
}

msg "Restoring..."

set -e

KO_DIR="${KO_DIR:-/mnt/us/koreader}"
DEST_FILE="${KO_DIR}/frontend/ui/translator.lua"
BACKUP_FILE="${DEST_FILE}.bak"

echo "Restore start"
if [ -f "${BACKUP_FILE}" ]; then
    echo "Restore backup -> ${DEST_FILE}"
    cp -p "${BACKUP_FILE}" "${DEST_FILE}"
    sync
    msg "Restore complete"
else
    msg "Backup file not found: ${BACKUP_FILE}"
    exit 1
fi